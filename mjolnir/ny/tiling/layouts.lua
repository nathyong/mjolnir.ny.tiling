local fnutils = require "mjolnir.fnutils"
local layouts = {}

layouts['fullscreen'] = {}
layouts['fullscreen'].name = 'fullscreen'
layouts['fullscreen'].redraw = function(windows)
  fnutils.each(windows, function(window)
                 window:maximize()
  end)
end

layouts['columns'] = {}
layouts['columns'].name = 'columns'
layouts['columns'].redraw = function(windows)
  local wincount = #windows

  if wincount == 1 then
    return layouts['fullscreen'](windows)
  end

  for index, win in pairs(windows) do
    local frame = win:screen():frame()

    frame.y = 0
    frame.x = frame.w / wincount * (index - 1)
    frame.w = frame.w / wincount

    win:setframe(frame)
  end
end

layouts['main-vertical'] = {}
layouts['main-vertical'].name = 'main-vertical'
layouts['main-vertical'].ratio = 0.5
layouts['main-vertical'].redraw = function(windows)
  local wincount = #windows
  local ratio = layouts['main-vertical'].ratio

  if wincount == 1 then
    return layouts['fullscreen'](windows)
  end

  for index, win in pairs(windows) do
    local frame = win:screen():frame()

    if index == 1 then
      frame.x, frame.y = 0, 0
      frame.w = frame.w * ratio
    else
      frame.x = frame.w * ratio
      frame.w = frame.w * (1 - ratio)
      frame.h = frame.h / (wincount - 1)
      frame.y = frame.h * (index - 2)
    end

    win:setframe(frame)
  end
end

layouts['main-horizontal'] = {}
layouts['main-horizontal'].name = 'main-horizontal'
layouts['main-horizontal'].redraw = function(windows)
  local wincount = #windows
  local ratio = layouts['main-horizontal'].ratio

  if wincount == 1 then
    return layouts['fullscreen'](windows)
  end

  for index, win in pairs(windows) do
    local frame = win:screen():frame()

    if index == 1 then
      frame.x, frame.y = 0, 0
      frame.h = frame.h * layouts.ratio
    else
      frame.y = frame.h * layouts.ratio
      frame.h = frame.h * (1 - layouts.ratio)
      frame.w = frame.w / (wincount - 1)
      frame.x = frame.w * (index - 2)
    end

    win:setframe(frame)
  end
end

return layouts
