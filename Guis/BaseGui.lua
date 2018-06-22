-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

-- Construct and return the BaseGUI object
return function()
  local BaseGUI = {
    -- NeedsTicks :: bool
    -- True if gui will require ticks.
    NeedsTicks = false
  }

  -- OnShow( Self, LuaPlayer ) :: bool
  -- Shows the GUI.
  -- Player: Required
  -- Self: is a table that contains data used by a specific gui. Data is retained
  -- accross all events, and can be used to store state information. However
  -- it is not retained across a save-load.
  -- If called due to an entity with a node being clicked on, will contain the node and handler.
  -- Returns: true if the GUI is shown, false if it is not
  function BaseGUI:OnShow(player)
    return false
  end

  -- OnClose( Self, LuaPlayer ) :: void
  -- Closes the GUI.
  -- Player: Required
  -- Self: Gui data. @See BaseGUI:OnShow for more details.
  -- It must be acceptable that Self may be nil, and the GUI must still close.
  function BaseGUI:OnClose(player)
  end

  -- OnTick( Self, LuaPlayer ) :: bool
  -- Called if NeedsTicks is true, every game tick
  -- Player: Required
  -- Self: Gui data. @See BaseGUI:OnShow for more details.
  -- Returns: True to keep gui open, return false to close it
  function BaseGUI:OnTick(player)
    if (self ~= nil and self.NeedsTicks) then
      player.print("Unhandled GUI tick")
    end
    return false
  end

  -- OnPlayerChangedSelectionElement( Self, LuaPlayer, LuaGuiElement ) :: void
  -- Called when the player has changed a selection element for this node.
  -- Self: Gui data. @See BaseGUI:OnShow for more details.
  function BaseGUI:OnPlayerChangedSelectionElement(player, element)
  end

  -- OnPlayerChangedCheckboxElement( Self, LuaPlayer, LuaGuiElement ) :: void
  -- Called when the player clicks a checkbox in the nodes GUI.
  -- Self: Gui data. @See BaseGUI:OnShow for more details.
  function BaseGUI:OnPlayerChangedCheckboxElement(player, element)
  end

  -- OnPlayerChangedDropDown( Self, LuaPlayer, LuaGuiElement ) :: void
  -- Called when the player changes a dropdown.
  -- Self: Gui data. @See BaseGUI:OnShow for more details.
  function BaseGUI:OnPlayerChangedDropDown(player, element)
  end

  -- OnPlayerClicked( Self, LuaPlayer, Event ) :: void
  -- Called when the player clicks something.
  -- Self: Gui data. @See GuiManager::OnElementClicked for more details.
  function BaseGUI:OnPlayerClicked(player, event)
  end

  return BaseGUI
end
