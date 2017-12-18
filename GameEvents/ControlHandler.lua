-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description: Defines the event manager for custom-input/control events

return function()
  local ControlHandler = {
    ShowingOverview = false
  }

  function ControlHandler.OnShowStorageNetworkGUI(event)
    local player = game.players[event.player_index]

    -- Toggle
    ControlHandler.ShowingOverview = not ControlHandler.ShowingOverview
    if (ControlHandler.ShowingOverview) then
      SE.GuiManager.ShowGui(player, SE.GuiManager.Guis.NetworkOverview, {})
    else
      SE.GuiManager.CloseGui(player, SE.GuiManager.Guis.NetworkOverview)
    end
  end

  function ControlHandler.RegisterWithGame()
    script.on_event(SE.Constants.Names.Controls.StorageNetworkGui, ControlHandler.OnShowStorageNetworkGUI)
  end

  return ControlHandler
end
