local spaces = {}

local window = require "mjolnir.window"
local mouse = require "mjolnir._asm.sys.mouse"
local event = require "mjolnir._asm.eventtap.event"
local keycodes = require "mjolnir.keycodes"

spaces.modifiers = {ctrl = true}

-- 'key' is actually the string of whatever key you have bound to press to get
-- to a particular space.
function spaces.movetospace(key)
    local frame = window.focusedwindow():frame()

    local position0 = mouse.get()
    local position = {x=frame.x + 65, y=frame.y + 7}
    event.newmouseevent(event.types.mousemoved, position, 'left'):post()
    event.newmouseevent(event.types.leftmousedown, position, 'left'):post()
    local kev = event.newkeyevent({}, '', true)
    kev:setkeycode(keycodes.map[key])
    kev:setflags(spaces.modifiers)
    kev:post()
    kev = event.newkeyevent({}, '', false)
    kev:setkeycode(keycodes.map[key])
    kev:setflags(spaces.modifiers)
    kev:post()
    event.newmouseevent(event.types.leftmousedown, position, 'left'):post()
    event.newmouseevent(event.types.leftmouseup, position, 'left'):post()
    event.newmouseevent(event.types.mousemoved, position0, 'left'):post()
end

return spaces
