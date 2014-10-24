local tiling = {}

local application = require "mjolnir.application"
local window = require "mjolnir.window"
local screen = require "mjolnir.screen"
local fnutils = require "mjolnir.fnutils"
local geometry = require "mjolnir.geometry"
local alert = require "mjolnir.alert"
local layouts = require "mjolnir.ny.tiling.layouts"
local spaces = {}
local settings = {
  layouts = {}
}

local n = 0
for k, v in pairs(layouts) do
  n = n + 1
  settings.layouts[n] = k
end

function tiling.set(name, value)
  settings[name] = value
end

function tiling.cycle(direction)
  local space = getspace()
  local windows = space.windows
  local win = window:focusedwindow() or windows[1]
  local direction = direction or 1
  local currentindex = fnutils.indexof(windows, win)
  if not currentindex then return end
  local nextindex = currentindex + direction

  while nextindex > #windows do
    nextindex = nextindex - #windows
  end

  while nextindex < 1 do
    nextindex = #windows + nextindex
  end

  windows[nextindex]:focus()
end

function tiling.cyclelayout()
  local space = getspace()
  space.layout = space.layoutcycle()
  alert.show(space.layout.name, 0.2)
  redraw(space)
end

function tiling.promote()
  local space = getspace()
  local windows = space.windows
  local win = window:focusedwindow() or windows[1]
  local i = fnutils.indexof(windows, win)
  local current = table.remove(windows, i)
  table.insert(windows, 1, current)
  win:focus()
  redraw(space)
end

function tiling.redraw()
  local space = getspace()
  redraw(space)
end

function redraw(space)
  space.layout.redraw(space.windows)
end

function tiling.changeratio(n)
  local space = getspace()
  if space.layout.ratio == nil then return end
  local ratio = space.layout.ratio
  ratio = ratio + n
  if n > 0 then
    ratio = math.min(ratio, 0.9)
  else
    ratio = math.max(ratio, 0.1)
  end
  space.layout.ratio = ratio
  print(ratio)
  redraw(space)
end

-- Infer a 'space' from our existing spaces
function getspace()
  local mainscreen = screen.mainscreen()
  local windows = fnutils.filter(window.visiblewindows(), function(win)
    return win:screen() == mainscreen and win:isstandard()
  end)

  fnutils.each(spaces, function(space)
    local matches = 0
    fnutils.each(space.windows, function(win)
      if fnutils.contains(windows, win) then matches = matches + 1 end
    end)
    space.matches = matches
  end)

  table.sort(spaces, function(a, b)
    return a.matches > b.matches
  end)

  local space = {}

  if #spaces == 0 or spaces[1].matches == 0 then
    space.windows = windows
    space.layouts = {}
    fnutils.each(settings.layouts,
                 function(l)
                   print("hello")
                   print(layouts[l])
                   table.insert(space.layouts, layouts[l])
                 end
    )
    table.insert(spaces, space)
    space.layout = space.layouts[1]
    space.layoutcycle = fnutils.cycle(space.layouts)
  else
    space = spaces[1]
  end

  space.windows = syncwindows(space.windows, windows)
  return space
end

function syncwindows(windows, newwindows)
  -- Remove any windows no longer around
  windows = fnutils.filter(windows, function(win)
    return fnutils.contains(newwindows, win)
  end)

  -- Add any new windows since
  fnutils.each(newwindows, function(win)
    if fnutils.contains(windows, win) == false then
      table.insert(windows, win)
    end
  end)

  -- Remove any bad windows
  windows = fnutils.filter(windows, function(win)
    return win:isstandard()
  end)

  return windows
end

return tiling
