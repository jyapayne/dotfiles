# shellcheck shell=bash
# Keeping secrets out of a public repo: a denylist of sensitive paths and names, and a
# content scan (built-in rules, plus gitleaks/trufflehog when installed).

# Never backed up, whatever dotfiles.list says (relative to ~, or absolute).
DENY_PATHS=(
    .ssh .gnupg .aws .azure .kube .docker .netrc .git-credentials .password-store .pki
    .mozilla .pulse-cookie .claude .claude.json .codex .gemini .cursor .omp .local/share/keyrings
    .local/share/kwalletd .config/gh .config/hub .config/1Password .config/Bitwarden
    ".config/Bitwarden CLI" .config/keepassxc .config/google-chrome .config/chromium
    .config/BraveSoftware .config/vivaldi .config/discord .config/teams-for-linux
    .config/Microsoft .config/obs-studio .config/sunshine .config/rclone .config/legion
    .config/hawk-cli .config/trajectory-labs .config/higgsfield .config/ngrok .modal.toml
    .webui_secret_key .emulator_console_auth_token .config/kwalletrc
    /etc/shadow /etc/gshadow /etc/sudoers /etc/sudoers.d /etc/ssh /etc/ssl/private
    /etc/NetworkManager/system-connections /etc/wireguard /etc/iwd /etc/ppp /etc/openvpn
)
# File names that are credentials, histories or databases.
DENY_NAMES=(
    '*.pem' '*.key' '*.p12' '*.pfx' '*.kdbx' '*.keystore' '*.jks' '*.gpg' '*.asc' 'id_rsa*'
    'id_ed25519*' 'id_ecdsa*' 'id_dsa*' '*_token*' '*token.json' '.env' '.env.*' '*.env'
    '*history*' '*.sqlite' '*.sqlite3' '*.db' 'cookies*' 'credentials*' 'secrets*' '.netrc'
    'hosts.yml' '.Xauthority' '.ICEauthority' 'known_hosts*' 'auth.json' '*.kwl'
)

# deny_reason PATH — prints why PATH (relative to ~, or absolute) must not be copied.
deny_reason() {
    local path=$1 d base=${1##*/} pat
    for d in "${DENY_PATHS[@]}"; do
        if [[ $path == "$d" || $path == "$d"/* ]]; then
            printf 'sensitive location (%s)' "$(pretty "$d")"
            return 0
        fi
    done
    shopt -s nocasematch
    for pat in "${DENY_NAMES[@]}"; do
        # shellcheck disable=SC2053
        if [[ $base == $pat ]]; then
            shopt -u nocasematch
            printf 'sensitive file name (%s)' "$pat"
            return 0
        fi
    done
    shopt -u nocasematch
    return 1
}

# Content rules: names and PCRE patterns, matched line by line on text files.
RULE_NAMES=(
    private-key aws-access-key aws-secret github-token gitlab-token slack-token slack-webhook
    ai-api-key google-api-key stripe-key huggingface-token npm-token jwt bearer-token
    url-credentials secret-assignment
)
RULE_RES=(
    '-----BEGIN[ A-Z0-9]*PRIVATE KEY'
    '\b(AKIA|ASIA|AGPA|AIDA|AROA)[0-9A-Z]{16}\b'
    '(?i)aws_secret_access_key\s*[=:]'
    '\b(gh[pousr]_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{40,})'
    '\bglpat-[A-Za-z0-9_-]{20,}'
    '\bxox[abposr]-[A-Za-z0-9-]{10,}'
    'hooks\.slack\.com/services/T[A-Za-z0-9]+/'
    '\bsk-(ant-|or-|proj-)?[A-Za-z0-9_-]{20,}'
    '\bAIza[0-9A-Za-z_-]{35}'
    '\b[rs]k_live_[A-Za-z0-9]{20,}'
    '\bhf_[A-Za-z0-9]{30,}'
    '\bnpm_[A-Za-z0-9]{36}'
    '\beyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}'
    '(?i)\bbearer\s+[A-Za-z0-9._~+/=-]{20,}'
    '\b[a-z][a-z0-9+.-]{1,20}://[^/\s:@'"'"'"]+:[^/\s@'"'"'"]{3,}@[A-Za-z0-9.-]+'
    '(?i)(pass(word|wd)?|secret|token|api[_-]?key|apikey|access[_-]?key|private[_-]?key|client[_-]?secret|auth[_-]?key)[A-Za-z0-9_]*["'"'"']?\s*[:=]\s*["'"'"']?[A-Za-z0-9_+/.=-]{8,}'
)

# Mask anything key-like so findings can be shown without repeating the secret.
mask() { sed -E 's/([A-Za-z0-9_+\/-]{4})[A-Za-z0-9_+\/=.-]{8,}/\1…/g' | cut -c1-110; }

fingerprint() { printf '%s\n%s\n%s' "$1" "$2" "$3" | sha256sum | cut -c1-12; }

# scan_dir DIR — prints one finding per line: path<TAB>line<TAB>rule<TAB>fingerprint<TAB>excerpt,
# with paths relative to DIR. Allow-listed fingerprints (.secrets-allow) are left out.
scan_dir() {
    local dir=$1 raw k file rest lineno text rule fp
    raw=$(mktemp) || return 1
    for k in "${!RULE_NAMES[@]}"; do
        grep -rnIPZ --exclude-dir=.git -e "${RULE_RES[$k]}" -- "$dir" 2>/dev/null |
            while IFS= read -r -d '' file && IFS= read -r rest; do
                lineno=${rest%%:*} text=${rest#*:}
                printf '%s\t%s\t%s\t%s\t%s\n' "${file#"$dir"/}" "$lineno" "${RULE_NAMES[$k]}" \
                    "$(fingerprint "${file#"$dir"/}" "${RULE_NAMES[$k]}" "$text")" "$(mask <<<"$text")"
            done
    done >>"$raw"
    scan_entropy "$dir" >>"$raw"
    scan_external "$dir" >>"$raw"
    sort -t$'\t' -k1,1 -k2,2n -u "$raw" | while IFS=$'\t' read -r file lineno rule fp text; do
        allowed "$fp" || printf '%s\t%s\t%s\t%s\t%s\n' "$file" "$lineno" "$rule" "$fp" "$text"
    done
    rm -f -- "$raw"
}

# Long random-looking strings: base64-alphabet runs with mixed case, ≥3 digits and close to
# the most entropy their length allows. Path-like runs (/a/b) are judged segment by
# segment. SVGs are skipped (they embed base64 images).
scan_entropy() {
    local dir=$1 file lineno token
    grep -rnoIP --exclude-dir=.git --exclude='*.svg' '[A-Za-z0-9+/_=-]{32,}' -- "$dir" 2>/dev/null |
        awk '
        function random(t,   L, i, h, p, ch, c, thr) {
            L = length(t)
            if (L < 20 || L > 256 || t !~ /[A-Z]/ || t !~ /[a-z]/ || gsub(/[0-9]/, "&", t) < 3) return 0
            for (i = 1; i <= L; i++) c[substr(t, i, 1)]++
            for (ch in c) { p = c[ch] / L; h -= p * log(p) / log(2) }
            # A string of L chars has at most log2(L) bits per char; ask for 90% of that.
            thr = 0.9 * log(L) / log(2); if (thr > 4.5) thr = 4.5
            return h >= thr
        }
        {
            n = split($0, a, ":"); tok = a[n]; ln = a[n - 1]
            path = substr($0, 1, length($0) - length(tok) - length(ln) - 2)
            hit = 0
            # Path-like tokens (/a/b, a/b/c) are judged segment by segment.
            if (tok ~ /^\// || gsub(/\//, "/", tok) >= 3) {
                m = split(tok, seg, "/")
                for (k = 1; k <= m; k++) if (random(seg[k])) hit = 1
            } else if (length(tok) >= 32 && random(tok)) hit = 1
            if (hit) printf "%s\t%s\t%s\n", path, ln, tok
        }' | while IFS=$'\t' read -r file lineno token; do
        printf '%s\t%s\t%s\t%s\t%s\n' "${file#"$dir"/}" "$lineno" high-entropy \
            "$(fingerprint "${file#"$dir"/}" high-entropy "$token")" "$(mask <<<"$token")"
    done
}

# gitleaks / trufflehog, if installed. Their findings join the built-in ones.
scan_external() {
    local dir=$1 report
    if command -v gitleaks >/dev/null 2>&1; then
        report=$(mktemp)
        if ! gitleaks dir --no-banner --redact --report-format csv --report-path "$report" "$dir" >/dev/null 2>&1; then
            gitleaks detect --no-git --no-banner --redact --report-format csv --report-path "$report" \
                --source "$dir" >/dev/null 2>&1
        fi
        # CSV: RuleID,Commit,File,SymlinkFile,Secret,Match,StartLine,...
        awk -F, 'NR > 1 && $3 != "" { print $3 "\t" $7 "\tgitleaks:" $1 }' "$report" |
            while IFS=$'\t' read -r file lineno rule; do
                file=${file#"$dir"/}
                printf '%s\t%s\t%s\t%s\t%s\n' "$file" "$lineno" "$rule" \
                    "$(fingerprint "$file" "$rule" "$lineno")" "(reported by gitleaks)"
            done
        rm -f -- "$report"
    fi
    if command -v trufflehog >/dev/null 2>&1; then
        trufflehog filesystem "$dir" --json --no-update 2>/dev/null |
            sed -nE 's/.*"file":"([^"]*)".*"line":([0-9]+).*"DetectorName":"([^"]*)".*/\1\t\2\t\3/p' |
            while IFS=$'\t' read -r file lineno rule; do
                file=${file#"$dir"/}
                printf '%s\t%s\t%s\t%s\t%s\n' "$file" "$lineno" "trufflehog:$rule" \
                    "$(fingerprint "$file" "trufflehog:$rule" "$lineno")" "(reported by trufflehog)"
            done
    fi
    return 0
}

allowed() {
    local file=$DOT_REPO/.secrets-allow
    [[ -f $file ]] && grep -qE "^[[:space:]]*$1([[:space:]]|$)" "$file"
}

scanner_names() {
    local names='built-in rules'
    command -v gitleaks >/dev/null 2>&1 && names+=', gitleaks'
    command -v trufflehog >/dev/null 2>&1 && names+=', trufflehog'
    printf '%s' "$names"
}

# print_findings FINDINGS — list findings grouped by file. Paths are repo-relative.
print_findings() {
    local findings=$1 file lineno rule fp text last=''
    while IFS=$'\t' read -r file lineno rule fp text; do
        [[ -n $file ]] || continue
        if [[ $file != "$last" ]]; then
            bad "$(pretty "$(repo_rel_to_path "$file")")"
            last=$file
        fi
        printf '        line %-5s %-18s %s  %s[%s]%s\n' "$lineno" "$rule" "$text" "$C_DIM" "$fp" "$C_RESET"
    done <<<"$findings"
}

explain_findings() {
    say "These files were NOT copied (the repo keeps its previous copy, if any)."
    say "To fix: move the secret out of the file (e.g. into ~/.secrets, sourced but not"
    say "listed), or exclude the file in dotfiles.list. If a finding is a false alarm, add"
    say "its [fingerprint] to .secrets-allow (one per line) and back up again."
}
