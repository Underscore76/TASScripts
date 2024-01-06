local keybinds = require("core.keybinds")

local overlays = require("overlays")

local frame = 74869
overlays.timers.clear()
overlays.timers.register(0, 0, frame, true)
overlays.timers.set_max(frame)

keybinds.clear()
-- keybinds.add(Keys.I,
--     function() 
--         bfreset()
--     end
-- )