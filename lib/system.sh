# shellcheck shell=bash
# The system snapshot (packages, enabled units, a few facts) and the optional deploy steps
# that restore it: packages, units, /etc files and BlueRune.

# write_snapshot DIR — write system/packages, system/units and system/info.txt under DIR.
write_snapshot() {
    local dir=$1/system
    mkdir -p "$dir/packages" "$dir/units"
    if command -v pacman >/dev/null 2>&1; then
        pacman -Qqen 2>/dev/null | LC_ALL=C sort >"$dir/packages/native.txt"
        pacman -Qqem 2>/dev/null | LC_ALL=C sort >"$dir/packages/foreign.txt"
    fi
    if command -v systemctl >/dev/null 2>&1; then
        systemctl list-unit-files --state=enabled --no-legend --no-pager 2>/dev/null |
            awk '{ print $1 }' | LC_ALL=C sort >"$dir/units/system-enabled.txt"
        systemctl --user list-unit-files --state=enabled --no-legend --no-pager 2>/dev/null |
            awk '{ print $1 }' | LC_ALL=C sort >"$dir/units/user-enabled.txt"
    fi
    {
        echo "# Facts about the machine this backup came from. Informational: deploy doesn't apply it."
        printf 'os: %s\n' "$(. "${DOT_ROOT:-}/etc/os-release" 2>/dev/null && echo "${PRETTY_NAME:-unknown}" || echo unknown)"
        printf 'kernel: %s\n' "$(uname -r)"
        printf 'hyprland: %s\n' "$(Hyprland --version 2>/dev/null | sed -nE '1s/^Hyprland ([^ ]+).*/\1/p' | grep . || echo 'not installed')"
        printf 'login shell: %s\n' "$(getent passwd "$(id -un)" 2>/dev/null | cut -d: -f7 || echo unknown)"
        printf 'locale: %s\n' "$(sed -nE 's/^LANG=//p' "${DOT_ROOT:-}/etc/locale.conf" 2>/dev/null || true)"
        printf 'keymap: %s\n' "$(sed -nE 's/^KEYMAP=//p' "${DOT_ROOT:-}/etc/vconsole.conf" 2>/dev/null || true)"
        echo "mkinitcpio (set these by hand if the hardware matches):"
        grep -E '^(MODULES|HOOKS)=' "${DOT_ROOT:-}/etc/mkinitcpio.conf" 2>/dev/null | sed 's/^/  /'
    } >"$dir/info.txt"
}

# One-line summary of how the live package list differs from the saved one.
snapshot_drift() {
    local repo=$DOT_REPO/system stage=$1/system f added removed
    for f in packages/native.txt packages/foreign.txt units/system-enabled.txt units/user-enabled.txt; do
        [[ -f $stage/$f ]] || continue
        if [[ ! -f $repo/$f ]]; then
            change_line + "system/$f (new, $(plural "$(wc -l <"$stage/$f")" line))"
            continue
        fi
        added=$(comm -13 "$repo/$f" "$stage/$f" | wc -l)
        removed=$(comm -23 "$repo/$f" "$stage/$f" | wc -l)
        ((added + removed)) || continue
        change_line '~' "system/$f (+$added −$removed since the last backup)"
    done
}

# Packages from a saved list that aren't installed yet (one per line).
missing_packages() {
    local list=$1 installed
    [[ -s $list ]] || return 0
    installed=$(pacman -Qq 2>/dev/null | LC_ALL=C sort)
    LC_ALL=C comm -23 <(LC_ALL=C sort -u "$list") <(printf '%s\n' "$installed")
}

step_packages() {
    local native=$DOT_REPO/system/packages/native.txt foreign=$DOT_REPO/system/packages/foreign.txt
    local -a want avail gone aur
    local helper=''
    heading "Packages"
    if ! command -v pacman >/dev/null 2>&1; then warn "pacman isn't here; skipping packages."; return 0; fi
    mapfile -t want < <(missing_packages "$native")
    mapfile -t aur < <(missing_packages "$foreign")
    if ((${#want[@]} + ${#aur[@]} == 0)); then ok "Every saved package is already installed."; return 0; fi
    if ((${#want[@]})); then
        mapfile -t avail < <(LC_ALL=C comm -12 <(printf '%s\n' "${want[@]}") <(pacman -Slq 2>/dev/null | LC_ALL=C sort -u))
        mapfile -t gone < <(LC_ALL=C comm -23 <(printf '%s\n' "${want[@]}") <(printf '%s\n' "${avail[@]}"))
        say "$(plural "${#avail[@]}" package) to install from the repos: ${avail[*]:0:12}$( ((${#avail[@]} > 12)) && echo ' …')"
        ((${#gone[@]})) && warn "Not in any repo, skipped: ${gone[*]}"
    fi
    ((${#aur[@]})) && say "$(plural "${#aur[@]}" package) from the AUR: ${aur[*]:0:12}$( ((${#aur[@]} > 12)) && echo ' …')"
    if ((DRY_RUN)); then note "Dry run: nothing installed."; return 0; fi
    if ((${#avail[@]})) && { ((OPT_PACKAGES)) || ask "Install them with sudo pacman?" n; }; then
        sudo pacman -S --needed "${avail[@]}" && ok "Installed repo packages." || warn "pacman failed; see above."
    fi
    if ((${#aur[@]})); then
        command -v paru >/dev/null 2>&1 && helper=paru
        command -v yay >/dev/null 2>&1 && helper=yay
        if [[ -z $helper ]]; then
            warn "No AUR helper (yay or paru); install these by hand: ${aur[*]}"
        elif ((OPT_PACKAGES)) || ask "Install the AUR packages with $helper?" n; then
            "$helper" -S --needed "${aur[@]}" && ok "Installed AUR packages." || warn "$helper failed; see above."
        fi
    fi
}

step_units() {
    local scope unit list
    local -a todo
    heading "Services"
    if ! command -v systemctl >/dev/null 2>&1; then warn "systemctl isn't here; skipping services."; return 0; fi
    for scope in system user; do
        list=$DOT_REPO/system/units/$scope-enabled.txt
        [[ -s $list ]] || continue
        todo=()
        while IFS= read -r unit; do
            [[ -z $unit || $unit == *@.* ]] && continue
            if [[ $scope == system ]]; then
                systemctl is-enabled --quiet "$unit" 2>/dev/null && continue
                [[ -n $(systemctl list-unit-files --no-legend "$unit" 2>/dev/null) ]] || continue
            else
                systemctl --user is-enabled --quiet "$unit" 2>/dev/null && continue
                [[ -n $(systemctl --user list-unit-files --no-legend "$unit" 2>/dev/null) ]] || continue
            fi
            todo+=("$unit")
        done <"$list"
        if ((${#todo[@]} == 0)); then ok "Every saved $scope unit that exists here is enabled."; continue; fi
        say "$(plural "${#todo[@]}" "$scope unit") to enable: ${todo[*]}"
        ((DRY_RUN)) && continue
        ((OPT_UNITS)) || ask "Enable them?" n || continue
        if [[ $scope == system ]]; then
            sudo systemctl enable "${todo[@]}" && ok "Enabled system units." || warn "systemctl failed; see above."
        else
            systemctl --user enable "${todo[@]}" && ok "Enabled user units." || warn "systemctl failed; see above."
        fi
    done
    ((DRY_RUN)) && note "Dry run: nothing enabled."
    return 0
}

# Copy the saved /etc files back with sudo, keeping the old ones in the deploy backup.
step_etc() {
    local i src rel target f
    local -a todo=()
    heading "System files (/etc)"
    for i in "${!E_PATH[@]}"; do
        is_system_entry "$i" || continue
        src=$DOT_REPO/$(repo_rel_of "$i")
        [[ -e $src ]] || continue
        while IFS= read -r -d '' f; do
            rel=/${f#"$DOT_REPO"/system/}
            target=${DOT_ROOT:-}$rel
            if [[ -f $target ]] && sudo_cat "$target" | cmp -s - "$f"; then continue; fi
            todo+=("$rel")
            if [[ -f $target ]]; then
                change_line '~' "$rel"
                ((VERBOSE)) && sudo_cat "$target" | diff -u --label "now $rel" --label "repo $rel" - "$f" | sed 's/^/        /'
            else
                change_line + "$rel"
            fi
        done < <(find "$src" -type f -print0)
    done
    if ((${#todo[@]} == 0)); then ok "The saved /etc files match this machine."; return 0; fi
    if ((DRY_RUN)); then note "Dry run: nothing copied (add --verbose for diffs)."; return 0; fi
    ((OPT_ETC)) || ask "Copy $(plural "${#todo[@]}" file) into /etc with sudo (old ones are backed up)?" n || return 0
    begin_backup
    for rel in "${todo[@]}"; do
        target=${DOT_ROOT:-}$rel
        if [[ -f $target ]]; then
            mkdir -p "$BACKUP_DIR/etc/$(dirname "$rel")"
            sudo_cat "$target" >"$BACKUP_DIR/etc$rel"
            record etc replaced "$rel" "$(file_sha "$DOT_REPO/system$rel")"
        else
            record etc created "$rel" "$(file_sha "$DOT_REPO/system$rel")"
        fi
        if sudo install -D -m 0644 -- "$DOT_REPO/system$rel" "$target"; then
            ok "$rel"
        else
            warn "couldn't write $rel"
        fi
    done
}

sudo_cat() {
    if [[ -r $1 ]]; then cat -- "$1"; else sudo cat -- "$1"; fi
}

step_bluerune() {
    local dir=${BLUERUNE_DIR:-$HOME/Projects/bluerune} profile installer
    local -a args=()
    installer=$dir/scripts/install-bluerune.sh
    profile=${BLUERUNE_PROFILE:-$dir/dist/profiles/joey}
    heading "BlueRune"
    if [[ ! -f $installer ]]; then
        say "BlueRune isn't checked out at $dir; skipping."
        note "Clone it there (or set BLUERUNE_DIR) and run dot deploy again to install it."
        return 0
    fi
    if [[ -d $profile ]]; then
        args+=(--profile "$profile")
    else
        warn "No profile at $profile; the installer will ask its own questions."
    fi
    ((ASSUME_YES)) && args+=(--yes)
    say "Would run: $installer ${args[*]}"
    ((DRY_RUN)) && { note "Dry run: not run."; return 0; }
    ((OPT_BLUERUNE)) || ask "Run BlueRune's installer now?" n || return 0
    if bash "$installer" "${args[@]}"; then ok "BlueRune installer finished."; else warn "BlueRune's installer failed; see above."; fi
}
