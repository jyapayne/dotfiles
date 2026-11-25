# shellcheck shell=bash
# Reads dotfiles.list: the one list of what gets backed up and deployed.
#
# Parsed into parallel arrays, one element per entry:
#   E_GROUP[i]  group name            E_PATH[i]  path relative to ~, or absolute (/etc/...)
#   E_EXCL[i]   newline-separated rsync exclude patterns
#   E_OPTS[i]   space-separated options (nolinks)
# plus G_EXCL (patterns excluded everywhere) and SNAPSHOT / SNAPSHOT_GROUP for `@snapshot`.

# Files the system snapshot writes, relative to the repo.
SNAP_RELS=(system/packages system/units system/info.txt)

load_manifest() {
    local file=$DOT_REPO/dotfiles.list group='' line lineno=0 tok path excl opts j
    local -a toks
    [[ -f $file ]] || die "there is no dotfiles.list in $DOT_REPO"
    E_GROUP=() E_PATH=() E_EXCL=() E_OPTS=() G_EXCL=() SNAPSHOT=0 SNAPSHOT_GROUP=''
    while IFS= read -r line || [[ -n $line ]]; do
        lineno=$((lineno + 1))
        [[ $line =~ ^[[:space:]]*# ]] && continue
        line=${line%%[[:space:]]#*}
        read -ra toks <<<"$line"
        ((${#toks[@]})) || continue
        if [[ ${toks[0]} =~ ^\[([A-Za-z0-9_-]+)\]$ ]]; then
            group=${BASH_REMATCH[1]}
            continue
        fi
        if [[ $group == global ]]; then
            for tok in "${toks[@]}"; do
                [[ $tok == '!'?* ]] || die "dotfiles.list:$lineno: only !patterns belong in [global]"
                G_EXCL+=("${tok#!}")
            done
            continue
        fi
        [[ -n $group ]] || die "dotfiles.list:$lineno: put entries below a [group] heading"
        if [[ ${toks[0]} == @snapshot ]]; then
            SNAPSHOT=1 SNAPSHOT_GROUP=$group
            continue
        fi
        path=$(normalize_path "${toks[0]}") || die "dotfiles.list:$lineno: bad path '${toks[0]}'"
        excl='' opts=''
        for tok in "${toks[@]:1}"; do
            case $tok in
                '!'?*) excl+=${tok#!}$'\n' ;;
                nolinks) opts+=' nolinks' ;;
                *) die "dotfiles.list:$lineno: unknown option '$tok' (excludes start with !)" ;;
            esac
        done
        for j in "${!E_PATH[@]}"; do
            [[ ${E_PATH[$j]} == "$path" ]] && die "dotfiles.list:$lineno: $path is listed twice"
        done
        E_GROUP+=("$group") E_PATH+=("$path") E_EXCL+=("$excl") E_OPTS+=("$opts")
    done <"$file"
}

# normalize_path P — ~/x, $HOME/x and x all become x; /etc/x stays absolute.
normalize_path() {
    local p=$1
    p=${p/#\~\//}
    [[ $p == "$HOME"/* ]] && p=${p#"$HOME"/}
    while [[ $p == */ ]]; do p=${p%/}; done
    while [[ $p == ./* ]]; do p=${p#./}; done
    [[ -n $p && $p != . && $p != "$HOME" && $p != *'/../'* && $p != ../* && $p != */.. && $p != .. ]] || return 1
    printf '%s' "$p"
}

is_system_entry() { [[ ${E_PATH[$1]} == /* ]]; }

# Where an entry lives on this machine. DOT_ROOT lets the tests fake /.
src_of() {
    local p=${E_PATH[$1]}
    if [[ $p == /* ]]; then printf '%s%s' "${DOT_ROOT:-}" "$p"; else printf '%s/%s' "$HOME" "$p"; fi
}

# Where an entry lives in the repo: home/<path> or system/<absolute path>.
repo_rel_of() {
    local p=${E_PATH[$1]}
    if [[ $p == /* ]]; then printf 'system%s' "$p"; else printf 'home/%s' "$p"; fi
}

# repo_rel_to_path home/x → x, system/etc/x → /etc/x
repo_rel_to_path() {
    case $1 in
        home/*) printf '%s' "${1#home/}" ;;
        system/*) printf '/%s' "${1#system/}" ;;
        *) printf '%s' "$1" ;;
    esac
}

# Paths (relative to entry i) of other entries nested inside it; they belong to those entries.
nested_under() {
    local i=$1 j p=${E_PATH[$1]}
    for j in "${!E_PATH[@]}"; do
        [[ $j != "$i" && ${E_PATH[$j]} == "$p"/* ]] && printf '%s\n' "${E_PATH[$j]#"$p"/}"
    done
    return 0
}

# owner_of PATH — index of the most specific entry containing PATH (relative or /abs), or 1.
owner_of() {
    local path=$1 j best=-1 len=-1
    for j in "${!E_PATH[@]}"; do
        if [[ $path == "${E_PATH[$j]}" || $path == "${E_PATH[$j]}"/* ]] && ((${#E_PATH[$j]} > len)); then
            best=$j len=${#E_PATH[$j]}
        fi
    done
    ((best >= 0)) || return 1
    printf '%s' "$best"
}

# group_of_rel REPO_REL — the group a repo file belongs to (snapshot files included).
group_of_rel() {
    local rel=$1 s i
    for s in "${SNAP_RELS[@]}"; do
        if ((SNAPSHOT)) && [[ $rel == "$s" || $rel == "$s"/* ]]; then
            printf '%s' "$SNAPSHOT_GROUP"
            return 0
        fi
    done
    i=$(owner_of "$(repo_rel_to_path "$rel")") || { printf 'unlisted'; return 0; }
    printf '%s' "${E_GROUP[$i]}"
}

# Groups in the order they first appear.
list_groups() {
    local -A seen=()
    local g
    for g in "${E_GROUP[@]}" ${SNAPSHOT_GROUP:+"$SNAPSHOT_GROUP"}; do
        [[ -n ${seen[$g]:-} ]] && continue
        seen[$g]=1
        printf '%s\n' "$g"
    done
}

# Entry indexes whose group is in the space-separated list $1 ("" = every group).
entries_in_groups() {
    local wanted=" $1 " i
    for i in "${!E_PATH[@]}"; do
        [[ -z ${1// /} || $wanted == *" ${E_GROUP[$i]} "* ]] && printf '%s\n' "$i"
    done
    return 0
}

# Check every name in the space-separated list exists; die with the known groups otherwise.
check_groups() {
    local g known
    known=" $(list_groups | tr '\n' ' ') "
    for g in $1; do
        [[ $known == *" $g "* ]] || die "unknown group '$g' (groups:${known% })"
    done
}

# add_manifest_entry GROUP LINE — append LINE at the end of GROUP's section (created if missing).
add_manifest_entry() {
    local group=$1 entry=$2 file=$DOT_REPO/dotfiles.list tmp
    tmp=$file.tmp.$$
    awk -v g="[$group]" -v e="$entry" '
        { lines[NR] = $0 }
        !start && $1 == g { start = NR; next }
        start && !ended && /^[[:space:]]*\[[A-Za-z0-9_-]+\]/ { ended = 1 }
        start && !ended && $0 !~ /^[[:space:]]*$/ { last = NR }
        END {
            if (!start) {
                for (n = 1; n <= NR; n++) print lines[n]
                print ""; print g; print e
                exit
            }
            at = last ? last : start
            for (n = 1; n <= NR; n++) { print lines[n]; if (n == at) print e }
        }' "$file" >"$tmp" && mv -- "$tmp" "$file"
}
