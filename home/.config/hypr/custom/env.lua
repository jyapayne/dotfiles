-- This file will not be overwritten across dots-hyprland updates.
-- Ported from custom/env.conf and the edits made to hyprland/env.conf.

hl.env("XKB_DEFAULT_OPTIONS", "caps:escape")
-- hl.env("AQ_MGPU_NO_EXPLICIT", "1") -- disabled: caused rendering artifacts (stale frame flicker)

-- Input method: fcitx5 (started in custom/execs.lua)
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")
hl.env("INPUT_METHOD", "fcitx")

-- Commands from hyprland/execs.lua that this setup replaces with its own
-- (see custom/execs.lua). This file is loaded before hyprland/execs.lua, so
-- the filter is in place when those commands run at start.
local replaced = {
    -- hypridle runs as the systemd user unit hypridle.service instead.
    ["hypridle"] = true,
    -- Clipboard history runs as the cliphist-text/cliphist-image user units,
    -- which survive compositor outages.
    ["wl-paste --type text --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"] = true,
    ["wl-paste --type image --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"] = true,
}
local exec_cmd = hl.exec_cmd
hl.exec_cmd = function(cmd, rules)
    if replaced[cmd] then
        return
    end
    return exec_cmd(cmd, rules)
end
