# shellcheck shell=bash
# dot deploy / revert: copying from the repo onto this machine, with a backup of
# everything it replaces and a manifest that `dot revert` replays backwards.

BACKUP_ROOT=${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups
BACKUP_DIR=''

# begin_backup — create this deploy's backup directory (once).
begin_backup() {
    [[ -n $BACKUP_DIR ]] && return 0
    local stamp n=1
    stamp=$(date +%Y%m%d-%H%M%S)
    BACKUP_DIR=$BACKUP_ROOT/$stamp
    while [[ -e $BACKUP_DIR ]]; do BACKUP_DIR=$BACKUP_ROOT/$stamp-$((n++)); done
    mkdir -p -- "$BACKUP_DIR/files" || die "cannot create $BACKUP_DIR"
    printf '# dot deploy %s from %s (mode: %s)\n# kind\taction\tpath\tdeployed content\n' \
        "$(date -Is)" "$DOT_REPO" "$MODE" >"$BACKUP_DIR/manifest.tsv"
}

# record KIND ACTION PATH ID — one manifest line: home|etc, created|replaced|mkdir.
record() { printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "${4:-}" >>"$BACKUP_DIR/manifest.tsv"; }

# plan_entries INDEX... — prints "state<TAB>group<TAB>path" for every file the repo
# holds for these entries; state is new, changed, same or blocked (a directory is in the way).
plan_entries() {
    local i rel src f path target nested
    for i in "$@"; do
        is_system_entry "$i" && continue
        rel=$(repo_rel_of "$i") src=$DOT_REPO/$rel
        [[ -e $src || -L $src ]] || continue
        nested=$(nested_under "$i")
        while IFS= read -r -d '' f; do
            path=${f#"$DOT_REPO"/home/}
            [[ -z $nested || $(owner_of "$path") == "$i" ]] || continue
            target=$HOME/$path
            printf '%s\t%s\t%s\n' "$(target_state "$f" "$target")" "${E_GROUP[$i]}" "$path"
        done < <(find "$src" \( -type f -o -type l \) -print0 | sort -z)
    done
}

target_state() {
    local src=$1 target=$2
    if [[ -d $target && ! -L $target ]]; then
        echo blocked
    elif [[ ! -e $target && ! -L $target ]]; then
        echo new
    elif [[ $MODE == link ]]; then
        if [[ -L $target && $(readlink -- "$target") == "$src" ]]; then echo same; else echo changed; fi
    elif [[ -L $src ]]; then
        if [[ -L $target && $(readlink -- "$target") == "$(readlink -- "$src")" ]]; then echo same; else echo changed; fi
    elif [[ ! -L $target ]] && cmp -s -- "$src" "$target"; then
        echo same
    else
        echo changed
    fi
}

choose_groups() {
    local all reply g n
    all=$(list_groups | paste -sd' ')
    if [[ -n $OPT_GROUPS ]]; then
        check_groups "$OPT_GROUPS"
        printf '%s' "$OPT_GROUPS"
        return
    fi
    if ((OPT_ALL)) || ! is_interactive; then
        printf '%s' "$all"
        return
    fi
    {
        heading "Which groups?"
        for g in $all; do
            n=$(entries_in_groups "$g" | wc -l)
            printf '    %s%-10s%s %s\n' "$C_BOLD" "$g" "$C_RESET" "$(list_entries_of "$g" "$n")"
        done
    } >&2
    reply=$(prompt_line "Groups to deploy, separated by spaces [all]:" all)
    [[ $reply == all ]] && reply=$all
    check_groups "$reply"
    printf '%s' "$reply"
}

list_entries_of() { # short preview of a group's entries
    local g=$1 n=$2 i out='' k=0
    for i in "${!E_PATH[@]}"; do
        [[ ${E_GROUP[$i]} == "$g" ]] || continue
        ((k++ < 4)) && out+="$(pretty "${E_PATH[$i]}") "
    done
    ((n > 4)) && out+="… ($n entries)"
    [[ $g == "$SNAPSHOT_GROUP" ]] && out+="+ package/service lists"
    printf '%s' "$out"
}

cmd_deploy() {
    local groups plan state group path n_new n_changed n_same n_blocked g
    local -a idx
    load_manifest
    groups=$(choose_groups) || exit 1
    mapfile -t idx < <(entries_in_groups "$groups")
    heading "Deploying ($MODE mode): $groups"
    note "Files only on this machine are never deleted. Anything replaced is backed up first."
    plan=$(plan_entries "${idx[@]}")
    n_new=$(grep -c $'^new\t' <<<"$plan")
    n_changed=$(grep -c $'^changed\t' <<<"$plan")
    n_same=$(grep -c $'^same\t' <<<"$plan")
    n_blocked=$(grep -c $'^blocked\t' <<<"$plan")
    local shown hidden
    while IFS= read -r g; do
        grep -qE $'^(new|changed|blocked)\t'"$g"$'\t' <<<"$plan" || { ((VERBOSE)) && subheading "  [$g] up to date"; continue; }
        subheading "  [$g]"
        shown=0 hidden=0
        while IFS=$'\t' read -r state group path; do
            [[ $group == "$g" ]] || continue
            case $state in
                new)
                    # Long lists of new files are cut short; replaced files are always shown.
                    if ((VERBOSE || shown < 8)); then change_line + "$(pretty "$path")"; shown=$((shown + 1)); else hidden=$((hidden + 1)); fi
                    ;;
                changed) change_line '~' "$(pretty "$path")$([[ $MODE == link ]] && echo ' (becomes a link)')" ;;
                blocked) change_line '!' "$(pretty "$path") (a directory is in the way; skipped)" ;;
                same) ((VERBOSE)) && change_line '=' "$(pretty "$path")" ;;
            esac
        done <<<"$plan"
        ((hidden)) && note "  … and $hidden more new files (--verbose lists them all)"
    done <<<"$(tr ' ' '\n' <<<"$groups")"
    say "$n_new new, $n_changed to replace, $n_same already up to date$( ((n_blocked)) && echo ", $n_blocked blocked")."

    if ((n_new + n_changed)); then
        if ((DRY_RUN)); then
            note "Dry run: nothing was written."
        elif ! { ((ASSUME_YES)) || { is_interactive && ask "Write these $((n_new + n_changed)) files?" n; }; }; then
            note "Nothing was written. This was a preview; run 'dot deploy --yes' (or answer y) to apply."
            DRY_RUN=1
        else
            apply_plan "$plan"
        fi
    fi

    if [[ " $groups " == *" $SNAPSHOT_GROUP "* ]] || ((OPT_PACKAGES || OPT_UNITS || OPT_ETC)); then
        step_packages
        step_units
        step_etc
    fi
    step_bluerune
    deploy_summary
}

apply_plan() {
    local plan=$1 state group path src target done_count=0
    begin_backup
    heading "Writing files"
    while IFS=$'\t' read -r state group path; do
        [[ $state == new || $state == changed ]] || continue
        src=$DOT_REPO/home/$path target=$HOME/$path
        if [[ $state == changed ]]; then
            mkdir -p -- "$BACKUP_DIR/files/$(dirname -- "$path")"
            cp -a --no-dereference -- "$target" "$BACKUP_DIR/files/$path" || { warn "couldn't back up $(pretty "$path"); skipped"; continue; }
            rm -f -- "$target"
        else
            make_parents "$(dirname -- "$path")"
        fi
        if [[ $MODE == link ]]; then
            ln -s -- "$src" "$target"
        else
            cp -P --preserve=mode,timestamps -- "$src" "$target"
        fi || { warn "couldn't write $(pretty "$path")"; continue; }
        if [[ $state == changed ]]; then
            record home replaced "$path" "$(content_id "$target")"
        else
            record home created "$path" "$(content_id "$target")"
        fi
        done_count=$((done_count + 1))
    done <<<"$plan"
    ok "Wrote $(plural "$done_count" file)."
}

# make_parents DIR — mkdir -p under ~, recording each directory it creates (for revert).
make_parents() {
    local dir=$1 part='' seg
    [[ $dir == . ]] && return 0
    local IFS=/
    for seg in $dir; do
        part=${part:+$part/}$seg
        if [[ ! -e $HOME/$part ]]; then
            mkdir -- "$HOME/$part" && record home mkdir "$part"
        fi
    done
}

deploy_summary() {
    heading "Summary"
    if [[ -n $BACKUP_DIR ]]; then
        ok "Done. Replaced files were saved in $BACKUP_DIR"
        say "Undo everything this deploy did with: dot revert $(basename -- "$BACKUP_DIR")"
    elif ((DRY_RUN)); then
        say "Preview only; nothing on this machine changed."
    else
        ok "Nothing needed changing."
    fi
}

list_backups() {
    local d
    [[ -d $BACKUP_ROOT ]] || return 0
    for d in "$BACKUP_ROOT"/*/; do
        [[ -f $d/manifest.tsv ]] && basename -- "$d"
    done
}

cmd_revert() {
    local stamp=${1:-} dir kind action path id target saved now
    local -a lines
    if [[ -z $stamp ]]; then
        heading "Deploy backups"
        list_backups | while IFS= read -r d; do
            printf '    %s  %s%s\n' "$d" "$(grep -vc '^#' "$BACKUP_ROOT/$d/manifest.tsv") changes" \
                "$([[ -f $BACKUP_ROOT/$d/REVERTED ]] && echo ' (reverted)')"
        done
        stamp=$(list_backups | while IFS= read -r d; do [[ -f $BACKUP_ROOT/$d/REVERTED ]] || echo "$d"; done | tail -1)
        [[ -n $stamp ]] || { say "Nothing to revert."; return 0; }
        confirm "Revert the latest deploy, $stamp?" n || { say "Pick one with: dot revert <timestamp>"; return 0; }
    fi
    dir=$BACKUP_ROOT/$stamp
    [[ -f $dir/manifest.tsv ]] || die "no deploy backup called '$stamp' (see: dot revert)"
    [[ -f $dir/REVERTED ]] && ! ((FORCE)) && die "$stamp was already reverted on $(cat "$dir/REVERTED") (--force to do it again)"
    mapfile -t lines < <(grep -v '^#' "$dir/manifest.tsv" | tac)
    heading "Reverting $stamp$( ((DRY_RUN)) && echo ' (dry run)')"
    now=$(date +%Y%m%d-%H%M%S)
    saved=$dir/before-revert-$now
    local line
    for line in "${lines[@]}"; do
        IFS=$'\t' read -r kind action path id <<<"$line"
        if [[ $kind == etc ]]; then revert_etc "$action" "$path" "$id" "$dir" "$saved"; continue; fi
        target=$HOME/$path
        case $action in
            mkdir)
                if ((DRY_RUN)); then change_line - "$(pretty "$path")/ (if empty)"; else rmdir -- "$target" 2>/dev/null && change_line - "$(pretty "$path")/"; fi
                ;;
            created)
                if [[ $(content_id "$target") != "$id" ]]; then
                    warn "$(pretty "$path") changed since the deploy; left it alone."
                    continue
                fi
                change_line - "$(pretty "$path")"
                ((DRY_RUN)) || rm -f -- "$target"
                ;;
            replaced)
                change_line '~' "$(pretty "$path") (restored)"
                ((DRY_RUN)) && continue
                if [[ -e $target || -L $target ]] && [[ $(content_id "$target") != "$id" ]]; then
                    mkdir -p -- "$saved/$(dirname -- "$path")"
                    cp -a --no-dereference -- "$target" "$saved/$path"
                    warn "$(pretty "$path") changed since the deploy; kept that version in $saved"
                fi
                rm -f -- "$target"
                mkdir -p -- "$(dirname -- "$target")"
                cp -a --no-dereference -- "$dir/files/$path" "$target" || warn "couldn't restore $(pretty "$path")"
                ;;
        esac
    done
    if ((DRY_RUN)); then note "Dry run: nothing changed."; return 0; fi
    date -Is >"$dir/REVERTED"
    ok "Reverted $stamp. The backup stays in $dir"
}

revert_etc() {
    local action=$1 path=$2 id=$3 dir=$4 saved=$5 target=${DOT_ROOT:-}$2
    case $action in
        created)
            change_line - "$path"
            ((DRY_RUN)) || sudo rm -f -- "$target"
            ;;
        replaced)
            change_line '~' "$path (restored)"
            ((DRY_RUN)) && return 0
            if [[ -f $target ]] && [[ $(sudo_cat "$target" | sha256sum | cut -d' ' -f1) != "$id" ]]; then
                mkdir -p -- "$saved/etc/$(dirname -- "$path")"
                sudo_cat "$target" >"$saved/etc$path"
                warn "$path changed since the deploy; kept that version in $saved"
            fi
            sudo install -m 0644 -- "$dir/etc$path" "$target" || warn "couldn't restore $path"
            ;;
    esac
}
