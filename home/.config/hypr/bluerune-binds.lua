-- BlueRune for Hyprland 0.57 or newer.
--
-- Save this file as ~/.config/hypr/bluerune-binds.lua and load it from the end of your
-- ~/.config/hypr/hyprland.lua:
--
--     require("bluerune-binds")   -- this file: binds, rules, starting the shell
--     require("bluerune")         -- the file BlueRune writes (see "BlueRune's own file" below)
--
-- Or copy what you want into your own config. Nothing here is required: every bind can be
-- changed or left out, and the Shortcuts page of Settings can change them later.
-- Don't save it as bluerune.lua: that name is BlueRune's own file.

-- Start ------------------------------------------------------------------------------------

hl.on("hyprland.start", function()
    -- Give systemd and D-Bus the session's environment, then start the shell as a user
    -- service, so it restarts if it crashes and stops with the session. With uwsm, or with
    -- `systemctl --user enable bluerune.service` and a session that starts
    -- graphical-session.target, the second half does nothing and is harmless.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP && systemctl --user start bluerune.service")
    -- The password prompt for apps and for BlueRune's own settings that need one.
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service")
end)

-- Stop the shell with Hyprland, so it isn't left trying to reach a compositor that is gone.
hl.on("hyprland.shutdown", function()
    hl.exec_cmd("systemctl --user stop bluerune.service")
end)

-- Shell ------------------------------------------------------------------------------------

hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("bluerunectl launcher toggle"), { description = "Shell: App launcher" })
hl.bind("SUPER + N", hl.dsp.exec_cmd("bluerunectl quick toggle"), { description = "Shell: Quick settings" })
hl.bind("SUPER + I", hl.dsp.exec_cmd("bluerunectl settings open"), { description = "Shell: Settings" })
hl.bind("SUPER + J", hl.dsp.exec_cmd("bluerunectl bar toggle"), { description = "Shell: Toggle bar" })
hl.bind("SUPER + SLASH", hl.dsp.exec_cmd("bluerunectl cheatsheet toggle"), { description = "Shell: Cheatsheet" })
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("bluerunectl session toggle"), { description = "Shell: Session screen" })

-- The keyboard's way into the bar and the notification popups: Tab and the arrows walk their
-- controls, Return presses one, Escape (or a press elsewhere) hands the keys back.
hl.bind("CTRL + ALT + TAB", hl.dsp.exec_cmd("bluerunectl bar focus"), { description = "Shell: Walk the bar from the keyboard" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("bluerunectl notifications focus"), { description = "Shell: Reach the notifications from the keyboard" })

-- The overview: every workspace with its windows. Type to find a window.
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("bluerunectl overview toggle"), { description = "Shell: Overview" })

-- The task switcher: hold Alt and press Tab to go through the windows, most recently used
-- first; Shift goes back. Hyprland has no event for a modifier let go, so the release of
-- Alt is bound too: it chooses the window. `non_consuming` and `transparent` leave the
-- release to apps and to every other bind.
hl.bind("ALT + TAB", hl.dsp.exec_cmd("bluerunectl switcher next"), { description = "Shell: Next window" })
hl.bind("ALT + SHIFT + TAB", hl.dsp.exec_cmd("bluerunectl switcher prev"), { description = "Shell: Previous window" })
for _, key in ipairs({ "ALT_L", "ALT_R" }) do
    hl.bind(key, hl.dsp.exec_cmd("bluerunectl switcher done"), { ignore_mods = true, transparent = true, non_consuming = true, release = true })
end

-- The region selector: freeze the screen and drag, click a window or draw round something.
-- A second record (or `bluerunectl region stop`, or the bar's record button) stops recording.
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("bluerunectl region screenshot"), { description = "Shell: Screenshot a region" })
hl.bind("Print", hl.dsp.exec_cmd("bluerunectl region screenshot"), { description = "Shell: Screenshot a region" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("bluerunectl region edit"), { description = "Shell: Screenshot a region and edit it" })
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("bluerunectl region ocr"), { description = "Shell: Copy text from a region" })
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("bluerunectl region search"), { description = "Shell: Search with a region (when turned on)" })
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("bluerunectl region record"), { description = "Shell: Record a region" })
hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("bluerunectl region record-sound"), { description = "Shell: Record a region with sound" })

-- Volume and brightness keys, shown on screen as they change. `locked` keeps them working on
-- the lock screen; `repeating` repeats while held.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("bluerunectl volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("bluerunectl volume down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("bluerunectl volume mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("bluerunectl brightness up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("bluerunectl brightness down"), { locked = true, repeating = true })

-- Tell the shell while Super is held, so the bar can show workspace numbers. `transparent`
-- leaves every other Super bind working.
for _, key in ipairs({ "SUPER_L", "SUPER_R" }) do
    hl.bind(key, hl.dsp.exec_cmd("bluerunectl super down"), { ignore_mods = true, transparent = true })
    hl.bind(key, hl.dsp.exec_cmd("bluerunectl super up"), { ignore_mods = true, transparent = true, release = true })
end

-- Surfaces ---------------------------------------------------------------------------------

-- BlueRune animates its own surfaces; without this Hyprland would animate them a second time.
hl.layer_rule({ match = { namespace = "bluerune-.*" }, no_anim = true })

-- Window motion ----------------------------------------------------------------------------

-- Optional: windows and workspaces move with the same feel as the shell's own surfaces,
-- a quick ease-out of about a quarter of a second. The Animations page of Settings can
-- change these later. Leave this section out to keep your own animations.
hl.curve("bluerune", { type = "bezier", points = { { 0.2, 0.9 }, { 0.1, 1 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "bluerune", style = "popin 90%" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "bluerune" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "bluerune", style = "slide" })

-- BlueRune's own file ----------------------------------------------------------------------
--
-- What you change in Settings that is Hyprland's to do (gaps, borders, input, displays,
-- shortcuts, window rules, animations) BlueRune keeps in ~/.config/hypr/bluerune.lua and
-- rewrites whole on each change. Load it last, after your own settings, with
-- `require("bluerune")` as shown at the top: then a value your config sets after it wins,
-- and Settings shows it as overridden by your Hyprland config. Without that line the
-- changes still apply, but only while BlueRune runs. `bluerunectl hypr status` shows the
-- file, whether Hyprland loads it, and the exact line to add.
--
-- Window borders follow the accent: Appearance > Colours > "Colour window borders to
-- match" (on by default) keeps the focused window's border in the accent and the others
-- in a quiet grey, light or dark with the shell, in the same file. To use your own border
-- colours, turn it off, or set `general.col.active_border` after `require("bluerune")`.
