-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description: Defines the event manager for custom-input/control events

-- Constructs and returns the ControlHandler object
return function()
  local ControlHandler = {}

  -- OnShowStorageNetworkGUI( Event ) :: void
  -- Called when the key bound to show network overview is pressed
  function ControlHandler.OnShowStorageNetworkGUI(event)
    -- Get the plaery
    local player = game.players[event.player_index]

    -- Toggle show/close
    if (SE.GuiManager.IsGuiOpen(player, SE.GuiManager.Guis.NetworkOverview)) then
      SE.GuiManager.CloseGui(player, SE.GuiManager.Guis.NetworkOverview)
    else
      SE.GuiManager.ShowGui(player, SE.GuiManager.Guis.NetworkOverview, {})
    end
  end

  -- RegisterWithGame() :: void
  -- Registers a listener for custom inputs
  function ControlHandler.RegisterWithGame()
    script.on_event(SE.Constants.Names.Controls.StorageNetworkGui, ControlHandler.OnShowStorageNetworkGUI)
  end

  return ControlHandler
end
