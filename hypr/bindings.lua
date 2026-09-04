-- 2Dennis.zoom-in-out — Super++ / Super+- text zoom (not window resize).
-- Loaded from ~/.config/hypr/bindings.lua and applied immediately via hyprctl eval.
-- Do not use o.bind: that wraps uwsm/omarchy-launch and is for apps, not this script.

local zoom = os.getenv("HOME") .. "/.config/omarchy/plugins/2Dennis.zoom-in-out/bin/omarchy-zoom"

hl.unbind("SUPER + code:20")
hl.unbind("SUPER + code:21")
hl.unbind("SUPER + SHIFT + code:20")
hl.unbind("SUPER + SHIFT + code:21")
hl.unbind("SUPER + plus")
hl.unbind("SUPER + SHIFT + plus")
hl.unbind("SUPER + equal")
hl.unbind("SUPER + SHIFT + equal")
hl.unbind("SUPER + minus")
hl.unbind("SUPER + SHIFT + minus")
hl.unbind("SUPER + CTRL + code:19")

local function zoom_bind(keys, desc, args)
  hl.bind(keys, hl.dsp.exec_cmd(zoom .. " " .. args), {
    description = desc,
    repeating = true,
  })
end

-- code:21 = equal, code:20 = minus (same physical keys Omarchy used for resize).
zoom_bind("SUPER + code:21", "Zoom in", "in")
zoom_bind("SUPER + SHIFT + code:21", "Zoom in", "in")
zoom_bind("SUPER + equal", "Zoom in", "in")
zoom_bind("SUPER + SHIFT + equal", "Zoom in", "in")
zoom_bind("SUPER + plus", "Zoom in", "in")
zoom_bind("SUPER + SHIFT + plus", "Zoom in", "in")
zoom_bind("SUPER + code:20", "Zoom out", "out")
zoom_bind("SUPER + SHIFT + code:20", "Zoom out", "out")
zoom_bind("SUPER + minus", "Zoom out", "out")
zoom_bind("SUPER + SHIFT + minus", "Zoom out", "out")
zoom_bind("SUPER + CTRL + code:19", "Reset zoom", "reset")
