---
-- Description of the module.
-- @module Player
--
local Player = {
  -- single-line comment
  classname = "SEPlayer"
}

local Lua_player = nil

-------------------------------------------------------------------------------
-- Print message
--
-- @function [parent=#Player] print
--
-- @param #arg message
--
function Player.print(...)
  if Lua_player ~= nil then
    Lua_player.print(table.concat({...}," "))
  end
end
-------------------------------------------------------------------------------
-- Load factorio player
--
-- @function [parent=#Player] load
--
-- @param #LuaEvent event
--
-- @return #Player
--
function Player.load(event)
  Lua_player = game.players[event.player_index]
  return Player
end

-------------------------------------------------------------------------------
-- Set factorio player
--
-- @function [parent=#Player] set
--
-- @param #LuaPlayer player
--
-- @return #Player
--
function Player.set(player)
  Lua_player = player
  return Player
end

-------------------------------------------------------------------------------
-- Set factorio player
--
-- @function [parent=#Player] set
--
-- @param #LuaPlayer player
--
-- @return #Player
--
function Player.setByIndex(index)
  Lua_player = game.players[index]
  return Player
end

-------------------------------------------------------------------------------
-- Get game day
--
-- @function [parent=#Player] getGameDay
--
function Player.getGameDay()
  local surface = game.surfaces[1]
  local day = surface.ticks_per_day
  local dusk = surface.evening-surface.dusk
  local night = surface.morning-surface.evening
  local dawn = surface.dawn-surface.morning
  return day, day*dusk, day*night, day*dawn
end

-------------------------------------------------------------------------------
-- Return factorio player
--
-- @function [parent=#Player] native
--
-- @return #Lua_player
--
function Player.native()
  return Lua_player
end

-------------------------------------------------------------------------------
-- Return admin player
--
-- @function [parent=#Player] isAdmin
--
-- @return #boolean
--
function Player.isAdmin()
  return Lua_player.admin
end

-------------------------------------------------------------------------------
-- Get gui
--
-- @function [parent=#Player] getGui
--
-- @param location
--
-- @return #LuaGuiElement
--
function Player.getGui(location)
  return Lua_player.gui[location]
end

-------------------------------------------------------------------------------
-- Return force's player
--
-- @function [parent=#Player] getForce
--
--
-- @return #table force
--
function Player.getForce()
  return Lua_player.force
end

return Player