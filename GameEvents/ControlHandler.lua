-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description: Defines the event manager for custom-input/control events

return function()
  local ControlHandler = {}

  function ControlHandler.OnShowStorageNetworkGUI(event)
    local player = game.players[event.player_index]
    player.print("You pressed my key")
  end

  function ControlHandler.RegisterWithGame()
    script.on_event(SE.Constants.Names.Controls.StorageNetworkGui, ControlHandler.OnShowStorageNetworkGUI)
  end

  return ControlHandler
end
