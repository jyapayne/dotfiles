-- This file will not be overwritten across dots-hyprland updates.
-- Ported from custom/keybinds.conf.

hl.bind("CTRL + SUPER + Slash", hl.dsp.exec_cmd("xdg-open ~/.config/illogical-impulse/config.json"), { description = "Edit shell config" })
hl.bind("CTRL + SUPER + ALT + Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), { description = "Edit user keybinds" })

-- Changes made to the old hyprland/keybinds.conf, carried over.
local function rebind(keys, dispatcher, opts)
    hl.unbind(keys)
    if dispatcher then
        hl.bind(keys, dispatcher, opts)
    end
end

-- Shell: on-screen keyboard and bar moved off Super+K/J (Vim focus keys)
rebind("SUPER + K", nil)
rebind("SUPER + J", nil)
rebind("CTRL + SHIFT + SUPER + K", hl.dsp.global("quickshell:oskToggle"), { description = "Shell: Toggle on-screen keyboard" })
rebind("CTRL + SUPER + SHIFT + J", hl.dsp.global("quickshell:barToggle"), { description = "Shell: Toggle bar" })
rebind("CTRL + SUPER + ALT + T", nil) -- no random wallpaper

-- Utilities: hyprshot snip, the shell's snip on Super+Alt+Shift+S, local OCR
rebind("SUPER + SHIFT + S", hl.dsp.exec_cmd("hyprshot --mode region"), { description = "Utilities: Screen snip" })
rebind("SUPER + ALT + SHIFT + S", hl.dsp.global("quickshell:regionScreenshot"), { description = "Utilities: Screen snip (shell)" })
rebind("SUPER + SHIFT + A", nil) -- no Google Lens
rebind("SUPER + SHIFT + T", hl.dsp.exec_cmd(HOME .. "/.config/hypr/custom/scripts/ocr.sh"), { description = "Utilities: Character recognition (Indra)" })

-- Windows: Vim keys instead of arrows
local vim = { h = "l", l = "r", k = "u", j = "d" }
local arrows = { h = "Left", l = "Right", k = "Up", j = "Down" }
for key, dir in pairs(vim) do
    hl.unbind("SUPER + " .. arrows[key])
    hl.unbind("SUPER + SHIFT + " .. arrows[key])
    rebind("SUPER + " .. key, hl.dsp.focus({ direction = dir }), { description = "Window: Focus " .. arrows[key] })
    rebind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }), { description = "Window: Move " .. arrows[key] })
    -- Alt+Shift+h/j/k/l send arrow keys to the focused window
    rebind("ALT + SHIFT + " .. key, hl.dsp.send_shortcut({ mods = "", key = arrows[key]:lower(), window = "activewindow" }))
end
-- Resize the active window
rebind("SUPER + ALT + K", hl.dsp.window.resize({ x = 0, y = -20 }), { repeating = true })
rebind("SUPER + ALT + J", hl.dsp.window.resize({ x = 0, y = 20 }), { repeating = true })
rebind("SUPER + ALT + H", hl.dsp.window.resize({ x = -20, y = 0 }), { repeating = true })
rebind("SUPER + ALT + L", hl.dsp.window.resize({ x = 20, y = 0 }), { repeating = true })
-- Alt+Tab cycles windows and raises the new one
rebind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Workspaces: Vim keys instead of arrows
for _, k in ipairs({ "Left", "Right", "Up", "Down" }) do
    hl.unbind("CTRL + SUPER + " .. k)
end
hl.unbind("CTRL + SUPER + ALT + Left")
hl.unbind("CTRL + SUPER + ALT + Right")
hl.unbind("CTRL + SUPER + SHIFT + Left")
hl.unbind("CTRL + SUPER + SHIFT + Right")
rebind("CTRL + SUPER + H", hl.dsp.focus({ workspace = "r-1" }), { description = "Workspace: Focus left" })
rebind("CTRL + SUPER + L", hl.dsp.focus({ workspace = "r+1" }), { description = "Workspace: Focus right" })
rebind("CTRL + SUPER + ALT + H", hl.dsp.focus({ workspace = "m-1" }))
rebind("CTRL + SUPER + ALT + L", hl.dsp.focus({ workspace = "m+1" }))
rebind("CTRL + SUPER + SHIFT + H", hl.dsp.window.move({ workspace = "r+1" }))
rebind("CTRL + SUPER + SHIFT + L", hl.dsp.window.move({ workspace = "r-1" }))

-- Session: lock on Ctrl+Super+Shift+L (Super+L focuses right, above); no
-- suspend shortcut; no VM submap; no keypad zoom
rebind("CTRL + SUPER + SHIFT + L", hl.dsp.exec_cmd("loginctl lock-session"), { description = "Session: Lock" })
hl.unbind("SUPER + ALT + F1")
hl.unbind("SUPER + code:82")
hl.unbind("SUPER + code:86")

-- Apps
rebind("SUPER + ALT + C", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/launch_first_available.sh 'command -v nvim && kitty -1 nvim' 'command -v micro && kitty -1 micro'"), { description = "App: Terminal code editor" })
rebind("SUPER + SHIFT + W", hl.dsp.exec_cmd("onlyoffice-desktopeditors"), { description = "App: ONLYOFFICE" })
hl.unbind("CTRL + SUPER + SHIFT + ALT + W")

-- Scrolling: one wheel notch under the pointer, held keys repeat. The
-- keyboard-scroll plugin is built against the running Hyprland (ABI-checked)
-- and loaded once per session; it registers hl.plugin.keyboard_scroll.scroll.
hl.exec_cmd("/usr/bin/python3 " .. HOME .. "/.local/share/keyboard-scroll/load.py")
local function scroll(direction)
    return function()
        local plugin = hl.plugin.keyboard_scroll
        if plugin then
            plugin.scroll(direction)
        end
    end
end
hl.unbind("CTRL + SUPER + J")
hl.unbind("CTRL + SUPER + K")
hl.bind("CTRL + SUPER + J", scroll("down"), { repeating = true, description = "Scroll down one notch (hold to repeat)" })
hl.bind("CTRL + SUPER + K", scroll("up"), { repeating = true, description = "Scroll up one notch (hold to repeat)" })
