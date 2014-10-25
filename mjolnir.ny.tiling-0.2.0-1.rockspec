package = "mjolnir.ny.tiling"
version = "0.2.0-1"

local url = "github.com/nathyong/mjolnir.ny.tiling"

source = {
  url = "git://" .. url,
  tag = "v0.2.0",
  dir = "mjolnir.ny.tiling"
}

description = {
  summary = "Extensible tiling window management for mjolnir.",
  homepage = "https://" .. url,
  detailed = [[
    Tiling window management for mjolnir, originally based off nathankot's "tiling" module."
  ]]
}

supported_platforms = {
  "macosx"
}

dependencies = {
   "lua >= 5.2",
   "mjolnir.alert",
   "mjolnir.application",
   "mjolnir.hotkey",
   "mjolnir._asm.sys.mouse",
   "mjolnir._asm.eventtap"
}

build = {
  type = "builtin",
  modules = {
    ["mjolnir.ny.tiling"] = "tiling.lua",
    ["mjolnir.ny.tiling.layouts"] = "layouts.lua",
    ["mjolnir.ny.spaces"] = "spaces.lua"
  }
}

