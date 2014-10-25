--- === mjolnir.ny.spaces ===
---
--- Functions to deal with moving between spaces, and moving windows between
--- spaces.

local spaces = {}

local window = require "mjolnir.window"
local mouse = require "mjolnir._asm.sys.mouse"
local event = require "mjolnir._asm.eventtap.event"
local keycodes = require "mjolnir.keycodes"

--- mjolnir.ny.spaces.modifiers
--- Variable
---
--- The modifier buttons to push when moving between spaces.  The default is
--- {ctrl = true}, and assumes that you have "switch to space N" bound to
--- "control-N".  Valid modifiers include 'ctrl', 'alt', 'cmd', 'shift', etc.
spaces.modifiers = {ctrl = true}

-- 'key' is actually the string of whatever key you have bound to press to get
-- to a particular space.

--- spaces.movetospace(key)
--- Function
---
--- 'key' should be a string describing the key to press to move to a space.
---
--- Move to a particular space by simulating the key events needed to move to
--- that space, and clicking on a window if there is one.  Clicking on a window
--- seems to convince OSX that a space has actually changed, and shortcuts such
--- as next-window will work properly again.
function spaces.movetospace(key)
  newkeyevent(spaces.modifiers, key, true):post()
  newkeyevent(spaces.modifiers, key, false):post()

  local win = window.focusedwindow()
  local frame
  if not win == nil then
    frame = window.focusedwindow():frame()
  else
    frame = {x = 20, y = 20, w = 0, h = 0}
  end
  local position0 = mouse.get()
  local position = {x=frame.x + 65, y=frame.y + 5}

  event.newmouseevent(event.types.mousemoved, position, 'left'):post()
  event.newmouseevent(event.types.leftmousedown, position, 'left'):post()
  event.newmouseevent(event.types.leftmouseup, position, 'left'):post()
  event.newmouseevent(event.types.mousemoved, position0, 'left'):post()
end

--- spaces.movewindowtospace(key)
--- Function
---
--- 'key' should be a string describing the key to press to move to a space.
---
--- Move to a particular space by simulating the key events needed to move to
--- that space, bringing a window along with it if there is one.
function spaces.movewindowtospace(key)
  local win = window.focusedwindow()
  local frame
  if not win == nil then
    frame = window.focusedwindow():frame()
  else
    frame = {x = 20, y = 20, w = 0, h = 0}
  end
  local position0 = mouse.get()
  local position = {x=frame.x + 65, y=frame.y + 5}

  event.newmouseevent(event.types.mousemoved, position, 'left'):post()
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
