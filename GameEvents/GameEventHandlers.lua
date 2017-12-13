-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/17/2017
-- Description: Defines the event manager for game/script events

return function()
  local GameEventHandlers = {
    Setup = (require "GameEvents/SetupHandler")(),
    Entity = (require "GameEvents/EntityHandler")(),
    Control = (require "GameEvents/ControlHandler")()
  }

  function GameEventHandlers.RegisterHandlers()
    GameEventHandlers.Setup.RegisterWithGame()
    GameEventHandlers.Entity.RegisterWithGame()
    GameEventHandlers.Control.RegisterWithGame()
    SE.GuiHandler.RegisterWithGame()
    script.on_event(defines.events.on_tick, GameEventHandlers.OnFirstTick)
  end

  function GameEventHandlers.OnFirstTick(event)
    SE.CachePrototypes()
    SE.Networks.FirstTick()

    -- Pass tick on to regular handler
    GameEventHandlers.OnTick(event)

    -- Change tick handler
    script.on_event(defines.events.on_tick, GameEventHandlers.OnTick)
  end

  function GameEventHandlers.OnTick(event)
    SE.Networks.Tick()
    SE.GuiHandler.Tick()
    SE.Logger.Tick()
  end

  return GameEventHandlers
end
