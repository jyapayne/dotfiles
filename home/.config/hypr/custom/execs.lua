-- This file will not be overwritten across dots-hyprland updates.
-- Ported from custom/execs.conf and the edits made to hyprland/execs.conf.

-- Systemd user units Hyprland would otherwise never start: Hyprland does not
-- activate graphical-session.target, so import the Wayland session first.
local import_env = "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE XDG_RUNTIME_DIR"

hl.on("hyprland.start", function()
    -- Input method
    hl.exec_cmd("fcitx5")

    -- Idle daemon (replaces the plain "hypridle" of hyprland/execs.lua)
    hl.exec_cmd(import_env .. " && systemctl --user start hypridle.service")

    -- Clipboard history watchers; they retry through compositor outages.
    hl.exec_cmd(import_env .. " && systemctl --user restart cliphist-text.service cliphist-image.service")

    -- Sunshine streaming host; starting it before the import races the
    -- compositor (empty WAYLAND_DISPLAY makes wlr capture fail).
    hl.exec_cmd(import_env .. " && systemctl --user restart sunshine.service")

    -- SpiderWeb: what /etc/xdg/autostart/spiderweb-*.desktop and the
    -- spiderweb-agent user unit would start in a desktop that runs them.
    hl.exec_cmd("sleep 2 && " .. import_env .. " && systemctl --user start spiderweb-agent.service")
    hl.exec_cmd("/usr/bin/spiderweb-desktop mounts session")
    hl.exec_cmd("/usr/bin/spiderweb-desktop host --login")
    hl.exec_cmd("/usr/bin/spiderweb-desktop integration watch")
end)
