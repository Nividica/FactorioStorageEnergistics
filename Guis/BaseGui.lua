-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

return function()
  local BaseGUI = {
    -- NeedsTicks: True if gui will require ticks.
    NeedsTicks = false
  }

  -- void OnShow(Self, Player)
  -- Shows the GUI
  -- Player is required
  -- Self is a table that contains data used by a specific gui. Data is retained
  -- accross all events, and can be used to store state information. However
  -- it is not retained across a save-load.
  -- If called due to an entity with a node being clicked on, will contain the node and handler.
  function BaseGUI:OnShow(player)
  end

  -- void OnClose(Self, Player)
  -- Closes the GUI
  -- Player is required
  -- Self is a table that may contain data used by a specific gui. See OnShow for more details.
  -- - It must be acceptable that this may be nil, and the GUI must still close.
  function BaseGUI:OnClose(player)
  end

  -- void OnTick(Self, Player)
  -- Called if NeedsTicks is true, every game tick
  -- Player is required
  -- Self is a table that contains data used by a specific gui. See OnShow for more details.
  function BaseGUI:OnTick(player)
    if (self ~= nil and self.NeedsTicks) then
      player.print("Unhandled GUI tick")
    end
  end

  -- void OnPlayerChangedSelectionElement(Self, Player, LuaGuiElement)
  -- Called when the player has changed a selection element for this node.
  -- Self is a table that contains data used by a specific gui. See OnShow for more details.
  function BaseGUI:OnPlayerChangedSelectionElement(player, element)
  end

  -- void OnPlayerChangedCheckboxElement(Self, LuaGuiElement, Table)
  -- Called when the player clicks a checkbox in the nodes GUI.
  -- Self is a table that contains data used by a specific gui. See OnShow for more details.
  function BaseGUI:OnPlayerChangedCheckboxElement(player, element)
  end

  -- void OnPlayerChangedDropDown(Player, LuaGuiElement, Table)
  -- Called when the player changes a dropdown.
  -- Self is a table that contains data used by a specific gui. See OnShow for more details.
  function BaseGUI.OnPlayerChangedDropDown(player, element)
  end

  return BaseGUI
end
