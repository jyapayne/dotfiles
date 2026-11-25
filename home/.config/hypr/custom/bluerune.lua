-- BlueRune instead of Quickshell ii. Loaded last from ~/.config/hypr/hyprland.lua;
-- remove that `require("custom.bluerune")` line (and uncomment the `qs` line in
-- hyprland/execs.lua) to go back. Backups: ~/.config/hypr.pre-bluerune.

-- ii binds that would fire alongside BlueRune's on the same keys.
for _, key in ipairs({
    "SUPER + SUPER_L", "SUPER + SUPER_R", -- ii's Super tap falls back to fuzzel without Quickshell
    "SUPER + Tab", "SUPER + N", "SUPER + I", "SUPER + J", "SUPER + Slash",
    "CTRL + ALT + Delete", "Print",
    "SUPER + SHIFT + S", "SUPER + SHIFT + A", "SUPER + SHIFT + T",
    "SUPER + SHIFT + R", "SUPER + SHIFT + ALT + R", "SUPER + SHIFT + N",
    "XF86AudioRaiseVolume", "XF86AudioLowerVolume", "XF86AudioMute",
    "XF86MonBrightnessUp", "XF86MonBrightnessDown",
    "CTRL + SUPER + R", -- ii's "restart widgets" would start Quickshell again
    "ALT + Tab", -- custom/keybinds.lua's window cycle; BlueRune's switcher takes Alt+Tab
    "SUPER + V", "SUPER + Period", -- ii's fuzzel clipboard and emoji pickers; BlueRune's launcher has both
}) do
    hl.unbind(key)
end

require("bluerune-binds")
hl.bind("CTRL + SUPER + R", hl.dsp.exec_cmd("systemctl --user restart bluerune.service"), { description = "Shell: Restart BlueRune" })
-- The file BlueRune writes; it exists once BlueRune has started.
if is_file_exists(HOME .. "/.config/hypr/bluerune.lua") then
    require("bluerune")
end
