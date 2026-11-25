# shellcheck shell=bash
# dot backup / status / diff / add: copying from this machine into the repo.

MAX_SIZE=${DOT_MAX_SIZE:-2m}

# stage_entries DIR INDEX... — copy entries from the machine into DIR/<repo path>, applying
# excludes, the size limit and the denylist. Fills MISSING, BIG and BLOCKED.
stage_entries() {
    local dir=$1 i src dst pat f hp reason
    local -a args
    shift
    MISSING=() BIG=() BLOCKED=()
    for i in "$@"; do
        src=$(src_of "$i") dst=$dir/$(repo_rel_of "$i")
        if reason=$(deny_reason "${E_PATH[$i]}"); then
            BLOCKED+=("${E_PATH[$i]}"$'\t'"$reason")
            continue
        fi
        if [[ ! -e $src && ! -L $src ]]; then
            MISSING+=("$i")
            continue
        fi
        args=(-a --max-size="$MAX_SIZE" --info=skip2)
        for pat in "${G_EXCL[@]}"; do args+=(--exclude="$pat"); done
        while IFS= read -r pat; do [[ -n $pat ]] && args+=(--exclude="$pat"); done <<<"${E_EXCL[$i]}"
        [[ ${E_OPTS[$i]} == *nolinks* ]] && args+=(--no-links)
        mkdir -p -- "$(dirname -- "$dst")"
        local prefix=${E_PATH[$i]}
        if [[ -d $src && ! -L $src ]]; then
            while IFS= read -r pat; do [[ -n $pat ]] && args+=(--exclude="/$pat"); done < <(nested_under "$i")
            src+=/ dst+=/ prefix+=/
        else
            prefix=${prefix%/*}/
            [[ ${E_PATH[$i]} == */* ]] || prefix=''
        fi
        while IFS= read -r f; do
            case $f in
                *' is over max-size') BIG+=("$prefix${f% is over max-size}") ;;
                rsync:* | rsync\ error:*) warn "$f" ;;
            esac
        done < <(rsync "${args[@]}" -- "$src" "$dst" 2>&1)
        [[ -e $dst || -L $dst ]] || continue
        while IFS= read -r -d '' f; do
            hp=$(repo_rel_to_path "${f#"$dir"/}")
            if reason=$(deny_reason "$hp"); then
                rm -f -- "$f"
                BLOCKED+=("$hp"$'\t'"$reason")
            fi
        done < <(find "$dst" \( -type f -o -type l \) -print0 2>/dev/null)
    done
}

# sync_entries STAGE DRY PROTECT INDEX... — mirror staged entries into the repo with rsync
# --delete (dry-run when DRY=1). PROTECT holds repo paths to leave untouched (secret
# findings). Prints "mark<TAB>group<TAB>repo path" for every file that changes.
sync_entries() {
    local stage=$1 dry=$2 protect=$3 i rel src dst p
    local -a args
    shift 3
    for i in "$@"; do
        rel=$(repo_rel_of "$i") src=$stage/$rel dst=$DOT_REPO/$rel
        [[ -e $src || -L $src ]] || continue
        args=(-rltE --checksum -i --delete -m --mkpath)
        ((dry)) && args+=(-n)
        if [[ -d $src && ! -L $src ]]; then
            while IFS= read -r p; do [[ -n $p ]] && args+=(--exclude="/$p"); done < <(nested_under "$i")
            while IFS= read -r p; do
                [[ $p == "$rel"/* ]] && args+=(--exclude="/${p#"$rel"/}")
            done <<<"$protect"
            rsync "${args[@]}" -- "$src/" "$dst/" | parse_itemize "${E_GROUP[$i]}" "$rel" dir
        else
            grep -qxF -- "$rel" <<<"$protect" && continue
            rsync "${args[@]}" -- "$src" "$dst" | parse_itemize "${E_GROUP[$i]}" "$rel" file
        fi
    done
}

# sync_snapshot STAGE DRY — like sync_entries, for the generated system/ files.
sync_snapshot() {
    local stage=$1 dry=$2 s
    local -a args=(-rltE --checksum -i --delete --mkpath)
    ((dry)) && args+=(-n)
    for s in "${SNAP_RELS[@]}"; do
        if [[ -d $stage/$s ]]; then
            rsync "${args[@]}" -- "$stage/$s/" "$DOT_REPO/$s/" | parse_itemize "$SNAPSHOT_GROUP" "$s" dir
        elif [[ -e $stage/$s ]]; then
            rsync "${args[@]}" -- "$stage/$s" "$DOT_REPO/$s" | parse_itemize "$SNAPSHOT_GROUP" "$s" file
        fi
    done
}

# parse_itemize GROUP REL dir|file — turn rsync -i lines into "mark<TAB>group<TAB>repo path".
parse_itemize() {
    local group=$1 rel=$2 kind=$3 line item name
    while IFS= read -r line; do
        item=${line%% *} name=${line#* }
        if [[ $item == '*deleting' ]]; then
            name=${line#'*deleting'}
            name=${name#"${name%%[! ]*}"}
        fi
        [[ $name == */ ]] && continue
        name=${name%% -> *}
        if [[ $kind == dir ]]; then name=$rel/$name; else name=$rel; fi
        case $item in
            '*deleting') printf -- '-\t%s\t%s\n' "$group" "$name" ;;
            [\>c][fL]+++++++++) printf '+\t%s\t%s\n' "$group" "$name" ;;
            [\>c][fL]* | .f...p*) printf '~\t%s\t%s\n' "$group" "$name" ;;
        esac
    done
}

# print_changes CHANGES — grouped list plus totals; sets N_ADDED N_CHANGED N_REMOVED.
print_changes() {
    local changes=$1 g mark group path
    N_ADDED=0 N_CHANGED=0 N_REMOVED=0
    [[ -n $changes ]] || return 0
    while IFS= read -r g; do
        grep -q $'^.\t'"$g"$'\t' <<<"$changes" || continue
        subheading "  [$g]"
        while IFS=$'\t' read -r mark group path; do
            [[ $group == "$g" ]] || continue
            change_line "$mark" "$path"
            case $mark in +) N_ADDED=$((N_ADDED + 1)) ;; -) N_REMOVED=$((N_REMOVED + 1)) ;; *) N_CHANGED=$((N_CHANGED + 1)) ;; esac
        done <<<"$changes"
    done < <({ list_groups; cut -f2 <<<"$changes"; } | awk '!seen[$0]++')
}

# Repo files under home/ and system/ that no entry owns any more.
find_orphans() {
    local f rel s
    [[ -d $DOT_REPO/home || -d $DOT_REPO/system ]] || return 0
    while IFS= read -r -d '' f; do
        rel=${f#"$DOT_REPO"/}
        if ((SNAPSHOT)); then
            for s in "${SNAP_RELS[@]}"; do [[ $rel == "$s" || $rel == "$s"/* ]] && continue 2; done
        fi
        owner_of "$(repo_rel_to_path "$rel")" >/dev/null || printf '%s\n' "$rel"
    done < <(find "$DOT_REPO/home" "$DOT_REPO/system" \( -type f -o -type l \) -print0 2>/dev/null | sort -z)
}

report_staging_notes() {
    local i b
    for i in "${MISSING[@]}"; do warn "$(pretty "${E_PATH[$i]}") isn't on this machine; left the repo copy alone."; done
    for b in "${BIG[@]}"; do warn "$(pretty "$b") is bigger than $MAX_SIZE; skipped (DOT_MAX_SIZE raises the limit)."; done
    for b in "${BLOCKED[@]}"; do warn "$(pretty "${b%%$'\t'*}") skipped: ${b#*$'\t'}."; done
}

cmd_backup() {
    local stage findings protect='' changes orphans groups rc=0 o
    need rsync git
    load_manifest
    heading "Copying from ~ into $DOT_REPO"
    make_tmp stage
    stage_entries "$stage" "${!E_PATH[@]}"
    ((SNAPSHOT)) && write_snapshot "$stage"
    report_staging_notes

    heading "Scanning for secrets ($(scanner_names))"
    findings=$(scan_dir "$stage")
    if [[ -n $findings ]]; then
        print_findings "$findings"
        explain_findings
        protect=$(cut -f1 <<<"$findings" | sort -u)
        while IFS= read -r o; do rm -f -- "$stage/$o"; done <<<"$protect"
        rc=3
    else
        ok "No secrets found in $(find "$stage" -type f | wc -l) files."
    fi

    heading "Changes$( ((DRY_RUN)) && echo ' (dry run: the repo is not touched)')"
    changes=$(sync_entries "$stage" "$DRY_RUN" "$protect" "${!E_PATH[@]}"; ((SNAPSHOT)) && sync_snapshot "$stage" "$DRY_RUN")
    print_changes "$changes"
    orphans=$(find_orphans)
    if [[ -n $orphans ]]; then
        warn "These repo files belong to no entry in dotfiles.list any more:"
        while IFS= read -r o; do change_line - "$o"; done <<<"$orphans"
        if ((!DRY_RUN)) && confirm "Remove them from the repo (git keeps their history)?" n; then
            while IFS= read -r o; do
                rm -f -- "${DOT_REPO:?}/$o"
                changes+=$'\n'"-"$'\t'"unlisted"$'\t'"$o"
                N_REMOVED=$((N_REMOVED + 1))
            done <<<"$orphans"
        fi
    fi
    if ((N_ADDED + N_CHANGED + N_REMOVED == 0)); then
        ok "The repo already matches this machine."
    else
        say "$N_ADDED added, $N_CHANGED changed, $N_REMOVED removed."
    fi
    warn_ignored
    ((DRY_RUN)) && { note "Dry run: nothing was written."; return "$rc"; }
    groups=$(grep -v '^$' <<<"$changes" | cut -f2 | awk '!seen[$0]++' | paste -sd' ')
    offer_commit "$groups"
    return "$rc"
}

# Files git would silently skip because of .gitignore.
warn_ignored() {
    local ignored
    git -C "$DOT_REPO" rev-parse --git-dir >/dev/null 2>&1 || return 0
    ignored=$(git -C "$DOT_REPO" ls-files --others --ignored --exclude-standard -- home system 2>/dev/null)
    [[ -n $ignored ]] || return 0
    warn ".gitignore hides $(plural "$(wc -l <<<"$ignored")" file) from git: $(head -5 <<<"$ignored" | paste -sd' ')"
}

# The paths `dot backup` commits: those that exist or that git still tracks (deletions).
commit_paths() {
    local p
    for p in home system dotfiles.list .secrets-allow; do
        if [[ -e $DOT_REPO/$p ]] || [[ -n $(git -C "$DOT_REPO" ls-files -- "$p" | head -1) ]]; then
            printf '%s\n' "$p"
        fi
    done
}

offer_commit() {
    local groups=$1 subject body status n
    local -a paths
    git -C "$DOT_REPO" rev-parse --git-dir >/dev/null 2>&1 || { note "Not a git repo; not committing."; return 0; }
    mapfile -t paths < <(commit_paths)
    ((${#paths[@]})) || return 0
    git -C "$DOT_REPO" add -A -- "${paths[@]}"
    status=$(git -C "$DOT_REPO" diff --cached --name-status -- "${paths[@]}")
    [[ -n $status ]] || { ok "Nothing new to commit."; return 0; }
    subject="Back up dotfiles${groups:+: ${groups// /, }}"
    n=$(wc -l <<<"$status")
    body=$(awk -F'\t' '{ m = ($1 == "A") ? "+" : ($1 == "D") ? "-" : "~"; print m " " $NF }' <<<"$status" | head -40)
    ((n > 40)) && body+=$'\n'"… and $((n - 40)) more"
    heading "Commit"
    say "$subject ($(plural "$n" file))"
    if ((NO_COMMIT)) || ! confirm "Commit these changes?" y; then
        note "Staged but not committed. Commit with: git -C $DOT_REPO commit"
        return 0
    fi
    if ! git -C "$DOT_REPO" commit -q -m "$subject" -m "$body" -- "${paths[@]}"; then
        warn "git commit failed; the changes are staged."
        return 0
    fi
    ok "Committed $(git -C "$DOT_REPO" rev-parse --short HEAD)."
    if ((OPT_PUSH)) || { ((!ASSUME_YES)) && ask "Push to $(git -C "$DOT_REPO" remote | head -1)?" n; }; then
        if git -C "$DOT_REPO" push; then ok "Pushed."; else warn "git push failed."; fi
    else
        note "Not pushed. Push later with: git -C $DOT_REPO push"
    fi
}

cmd_status() {
    local stage changes orphans findings f
    need rsync
    load_manifest
    make_tmp stage
    stage_entries "$stage" "${!E_PATH[@]}"
    heading "What differs between this machine and the repo"
    note "+ only on this machine   ~ different   - only in the repo"
    changes=$(sync_entries "$stage" 1 '' "${!E_PATH[@]}")
    print_changes "$changes"
    findings=$(scan_dir "$stage")
    if [[ -n $findings ]]; then
        while IFS= read -r f; do
            warn "$(pretty "$(repo_rel_to_path "$f")") has something that looks like a secret; dot backup will refuse it."
        done < <(cut -f1 <<<"$findings" | sort -u)
    fi
    if ((SNAPSHOT)); then
        write_snapshot "$stage"
        subheading "  [$SNAPSHOT_GROUP] snapshot"
        snapshot_drift "$stage"
    fi
    orphans=$(find_orphans)
    [[ -n $orphans ]] && warn "$(plural "$(wc -l <<<"$orphans")" repo file) belong to no entry (dot backup offers to remove them)."
    report_staging_notes
    if ((N_ADDED + N_CHANGED + N_REMOVED == 0)); then
        ok "Everything listed is in sync."
    else
        say "$N_ADDED only here, $N_CHANGED different, $N_REMOVED only in the repo."
        note "dot backup copies this machine into the repo; dot deploy goes the other way; dot diff shows the lines."
    fi
}

# dot diff [PATH...] — unified diff, repo copy (old) against this machine (new).
cmd_diff() {
    local stage i path rel colour=''
    local -a idx=() rels=()
    need rsync
    load_manifest
    if (($#)); then
        for path in "$@"; do
            [[ $path == home/* || $path == system/* ]] && path=$(repo_rel_to_path "$path")
            path=$(normalize_path "$path") || die "bad path '$path'"
            i=$(owner_of "$path") || die "$(pretty "$path") isn't in dotfiles.list"
            idx+=("$i")
            if [[ $path == /* ]]; then rels+=("system$path"); else rels+=("home/$path"); fi
        done
    else
        # A nested entry shows up inside its parent's diff, so only top-level entries.
        idx=("${!E_PATH[@]}")
        for i in "${idx[@]}"; do
            [[ $(owner_of "$(dirname -- "${E_PATH[$i]}")") ]] || rels+=("$(repo_rel_of "$i")")
        done
    fi
    make_tmp stage
    stage_entries "$stage" "${idx[@]}"
    [[ -t 1 && -n $C_RESET ]] && colour=--color=always
    for rel in "${rels[@]}"; do
        [[ -e $DOT_REPO/$rel || -e $stage/$rel ]] || continue
        diff -ruN $colour -- "$DOT_REPO/$rel" "$stage/$rel" |
            sed -e "s|$DOT_REPO/|repo/|g" -e "s|$stage/home/|~/|g" -e "s|$stage/system/|/|g"
    done
    return 0
}

cmd_add() {
    local path group='' stage findings i
    local -a excl=()
    while (($#)); do
        case $1 in
            --group | -g) group=${2:?--group needs a name}; shift ;;
            --exclude | -x) excl+=("!${2:?--exclude needs a pattern}"); shift ;;
            -*) die "unknown option for add: $1" ;;
            *) [[ -z ${path:-} ]] || die "add takes one path at a time"; path=$1 ;;
        esac
        shift
    done
    [[ -n ${path:-} ]] || die "usage: dot add <path> [--group NAME] [--exclude PATTERN]"
    case $path in
        "~/"*) path=$HOME/${path#"~/"} ;;
        /*) ;;
        *) path=$PWD/$path ;;
    esac
    path=$(realpath -sm -- "$path")
    if [[ $path == "$HOME"/* ]]; then
        path=${path#"$HOME"/}
    elif [[ $path != /etc/* ]]; then
        die "only files under ~ or /etc can be added"
    fi
    load_manifest
    local reason
    if reason=$(deny_reason "$path"); then die "$(pretty "$path") won't be backed up: $reason"; fi
    if i=$(owner_of "$path"); then die "$(pretty "$path") is already backed up as part of $(pretty "${E_PATH[$i]}") [${E_GROUP[$i]}]"; fi
    E_PATH+=("$path") E_GROUP+=("${group:-new}") E_EXCL+=("$(printf '%s\n' "${excl[@]#!}")") E_OPTS+=('')
    i=$((${#E_PATH[@]} - 1))
    [[ -e $(src_of "$i") ]] || die "$(pretty "$path") doesn't exist"
    heading "Checking $(pretty "$path")"
    make_tmp stage
    stage_entries "$stage" "$i"
    report_staging_notes
    findings=$(scan_dir "$stage")
    if [[ -n $findings ]]; then
        print_findings "$findings"
        say "Not added: remove the secrets (or exclude those files with --exclude) first."
        return 3
    fi
    ok "No secrets found."
    if [[ -z $group ]]; then
        say "Groups: $(list_groups | grep -vx new | paste -sd' ')"
        group=$(prompt_line "Which group? [apps]" apps)
    fi
    [[ $group =~ ^[A-Za-z0-9_-]+$ ]] || die "group names use letters, digits, - and _"
    add_manifest_entry "$group" "$path${excl:+ ${excl[*]}}"
    ok "Added $(pretty "$path") to [$group] in dotfiles.list."
    say "Run 'dot backup' to copy it into the repo."
}
