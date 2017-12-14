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
      SE.GuiHandler.ShowGui(player, SE.GuiHandler.Guis.NetworkOverview, {})
    else
      SE.GuiHandler.CloseGui(player, SE.GuiHandler.Guis.NetworkOverview)
    end
  end

  function ControlHandler.RegisterWithGame()
    script.on_event(SE.Constants.Names.Controls.StorageNetworkGui, ControlHandler.OnShowStorageNetworkGUI)
  end

  return ControlHandler
end
