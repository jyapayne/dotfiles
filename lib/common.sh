# shellcheck shell=bash
# Output, prompts and small helpers shared by every `dot` command.

setup_colors() {
    if [[ -t 1 && -z ${NO_COLOR:-} && ${TERM:-dumb} != dumb ]]; then
        C_RESET=$'\e[0m' C_BOLD=$'\e[1m' C_DIM=$'\e[2m' C_RED=$'\e[31m'
        C_GREEN=$'\e[32m' C_YELLOW=$'\e[33m' C_BLUE=$'\e[34m' C_CYAN=$'\e[36m'
    else
        C_RESET='' C_BOLD='' C_DIM='' C_RED='' C_GREEN='' C_YELLOW='' C_BLUE='' C_CYAN=''
    fi
}

heading() { printf '\n%s==> %s%s\n' "$C_BOLD$C_BLUE" "$*" "$C_RESET"; }
subheading() { printf '%s%s%s\n' "$C_BOLD" "$*" "$C_RESET"; }
say() { printf '    %s\n' "$*"; }
note() { printf '    %s%s%s\n' "$C_DIM" "$*" "$C_RESET"; }
ok() { printf '  %s✓%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
warn() { printf '  %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*"; }
bad() { printf '  %s✗%s %s\n' "$C_RED" "$C_RESET" "$*"; }
die() {
    printf '%sdot:%s %s\n' "$C_RED" "$C_RESET" "$*" >&2
    exit 1
}

# One changed-file line: mark is + (added), ~ (changed), - (removed).
change_line() {
    local mark=$1 path=$2 colour
    case $mark in
        +) colour=$C_GREEN ;;
        -) colour=$C_RED ;;
        *) colour=$C_YELLOW ;;
    esac
    printf '      %s%s%s %s\n' "$colour" "$mark" "$C_RESET" "$path"
}

# Interactive unless DOT_INTERACTIVE says otherwise (the tests set it).
is_interactive() {
    case ${DOT_INTERACTIVE:-} in
        1) return 0 ;;
        0) return 1 ;;
    esac
    [[ -t 0 ]]
}

# ask QUESTION y|n — a yes/no question. Without a terminal the default is taken.
ask() {
    local question=$1 default=$2 hint reply
    if [[ $default == y ]]; then hint='[Y/n]'; else hint='[y/N]'; fi
    if ! is_interactive; then
        printf '%s?%s %s %s %s(no terminal: %s)%s\n' "$C_CYAN" "$C_RESET" "$question" "$hint" \
            "$C_DIM" "$([[ $default == y ]] && echo yes || echo no)" "$C_RESET"
        [[ $default == y ]]
        return
    fi
    while :; do
        printf '%s?%s %s %s ' "$C_CYAN" "$C_RESET" "$question" "$hint"
        IFS= read -r reply || reply=''
        case ${reply,,} in
            '') [[ $default == y ]]; return ;;
            y | yes) return 0 ;;
            n | no) return 1 ;;
            *) say "Please answer y or n." ;;
        esac
    done
}

# confirm QUESTION y|n — like ask, but --yes answers yes for you.
confirm() {
    if [[ ${ASSUME_YES:-0} == 1 ]]; then
        printf '%s?%s %s %s(yes: --yes)%s\n' "$C_CYAN" "$C_RESET" "$1" "$C_DIM" "$C_RESET"
        return 0
    fi
    ask "$@"
}

# prompt_line QUESTION DEFAULT — read a line of text; returns DEFAULT when empty or non-interactive.
prompt_line() {
    local question=$1 default=$2 reply=''
    if is_interactive; then
        printf '%s?%s %s ' "$C_CYAN" "$C_RESET" "$question" >&2
        IFS= read -r reply || reply=''
    fi
    printf '%s' "${reply:-$default}"
}

# ~/foo for paths under $HOME, unchanged otherwise.
pretty() {
    local p=$1
    if [[ $p == /* ]]; then
        printf '%s' "$p"
    else
        printf '~/%s' "$p"
    fi
}

plural() { # plural COUNT WORD → "1 file" / "2 files"
    if (($1 == 1)); then printf '%s %s' "$1" "$2"; else printf '%s %ss' "$1" "$2"; fi
}

need() {
    local cmd
    for cmd in "$@"; do
        command -v "$cmd" >/dev/null 2>&1 || die "this needs '$cmd'; install it first (e.g. sudo pacman -S $cmd)"
    done
}

file_sha() { sha256sum -- "$1" | cut -d' ' -f1; }

# What a deployed path holds, comparable across time: link:<target> or the file's sha256.
content_id() {
    if [[ -L $1 ]]; then
        printf 'link:%s' "$(readlink -- "$1")"
    elif [[ -f $1 ]]; then
        file_sha "$1"
    else
        printf 'missing'
    fi
}

# make_tmp VAR — create a temporary directory, store its path in VAR; removed on exit.
make_tmp() {
    local d
    d=$(mktemp -d "${TMPDIR:-/tmp}/dot.XXXXXX") || die "cannot create a temporary directory"
    DOT_TMPS+=("$d")
    printf -v "$1" '%s' "$d"
}

cleanup_tmps() {
    local d
    for d in "${DOT_TMPS[@]}"; do [[ -n $d && -d $d ]] && rm -rf -- "$d"; done
}
