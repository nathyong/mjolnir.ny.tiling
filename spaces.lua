local spaces = {}

local window = require "mjolnir.window"
local mouse = require "mjolnir._asm.sys.mouse"
local event = require "mjolnir._asm.eventtap.event"
local keycodes = require "mjolnir.keycodes"

spaces.modifiers = {ctrl = true}

--- spaces.movetospace(key)
--- Function
---
--- 'key' should be a string describing the key to press to move to a space.
---
--- Move to a particular space by simulating the key events needed to move to
--- that space, bringing a window along with it if there is one.
function spaces.movetospace(key)
    local frame = window.focusedwindow():frame()

    local position0 = mouse.get()
    local position = {x=frame.x + 65, y=frame.y + 7}
    event.newmouseevent(event.types.mousemoved, position, 'left'):post()
    os.execute("sleep 0.0.5")
    event.newmouseevent(event.types.leftmousedown, position, 'left'):post()
    newkeyevent(spaces.modifiers, key, true):post()
    newkeyevent(spaces.modifiers, key, false):post()
    event.newmouseevent(event.types.leftmousedown, position, 'left'):post()
    event.newmouseevent(event.types.leftmouseup, position, 'left'):post()
    event.newmouseevent(event.types.mousemoved, position0, 'left'):post()
end


--- newkeyevent(modifiers, key, ispressed) -> event
--- Function
---
--- Acts like mjolnir._asm.eventtap.event.newkeyevent(...), but actually works.
function newkeyevent(modifiers, key, ispressed)
  local kev = event.newkeyevent({}, '', ispressed)
  kev:setkeycode(keycodes.map[key])
  kev:setflags(modifiers)
  return kev
end

return spaces
