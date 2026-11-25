-- This file will not be overwritten across dots-hyprland updates.
-- Ported from custom/general.conf, hyprland.conf and the edits made to
-- hyprland/general.conf.

-- Monitors: ~/.config/hypr/monitors-persistent.conf stays the source of truth
-- (merge-monitors.sh keeps it updated from nwg-displays). Its hyprlang
-- "monitor=" lines are read here; Hyprland ignores entries for monitors that
-- are not connected.
local function apply_monitor_line(value)
    local f = {}
    for field in (value .. ","):gmatch("([^,]*),") do
        f[#f + 1] = field:match("^%s*(.-)%s*$")
    end
    local spec = { output = f[1], mode = f[2], position = f[3], scale = tonumber(f[4]) or f[4] }
    local i = 5
    while f[i] and f[i] ~= "" do
        local value_ = f[i + 1]
        spec[f[i]] = tonumber(value_) or value_
        i = i + 2
    end
    hl.monitor(spec)
end

local known = {}
local persistent = io.open(HOME .. "/.config/hypr/monitors-persistent.conf", "r")
if persistent then
    for line in persistent:lines() do
        local value = line:match("^%s*monitor%s*=%s*(.-)%s*$")
        if value then
            apply_monitor_line(value)
            local desc = value:match("^desc:([^,]+)")
            if desc then
                known[desc] = true
            end
        end
    end
    persistent:close()
end

-- Portable display (YMK EM160) fallback when its desc: match fails; prevents
-- the 720p fallback during lock/unlock DPMS cycles. Hyprland 0.57 lets this
-- name rule override a desc: rule, so it applies only to a monitor actually on
-- DP-2 that is none of the known ones. (At startup no monitor exists yet when
-- this file runs, hence the event; on the desktop DP-2 is the AW2725DF, which
-- has no 2880x1800 mode and goes black with it.)
local function dp2_fallback(monitor)
    if monitor and monitor.name == "DP-2" and not known[monitor.description or ""] then
        hl.monitor({ output = "DP-2", mode = "2880x1800@120", position = "0x0", scale = 1.0, bitdepth = 10 })
    end
end
dp2_fallback(hl.get_monitor("DP-2"))
hl.on("monitor.added", dp2_fallback)


hl.workspace_rule({ workspace = "1", monitor = "DP-2" })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })

hl.config({
    general = {
        gaps_in = 1,
        gaps_out = 0,
        border_size = 0,
        snap = {
            window_gap = 1,
            monitor_gap = 1,
        },
    },
    -- The old look: the pre-Lua dots values this setup ran with, where the
    -- new upstream defaults differ.
    decoration = {
        rounding = 8,
        rounding_power = 2, -- upstream now 2.5 (squircle corners)
        blur = {
            size = 14,
            noise = 0.04,
            contrast = 1,
            vibrancy = 0.1696, -- Hyprland defaults; upstream now sets 0.5/0.5
            vibrancy_darkness = 0,
            popups = true,
        },
        shadow = {
            range = 30,
            color = "rgba(00000010)",
        },
        dim_strength = 0.025,
        dim_special = 0.07,
    },
    input = {
        repeat_delay = 300,
        accel_profile = "flat",
        sensitivity = 0,
        touchpad = {
            scroll_factor = 0.5,
        },
    },
    misc = {
        vrr = 0,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})
