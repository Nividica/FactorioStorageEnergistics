-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

return function()
  local BaseGUI = {
    -- NeedsTicks: True if gui will require ticks.
    NeedsTicks = false
  }

  -- void OnShow(Player, Table)
  -- Shows the GUI
  -- Player is required
  -- Data is a table that contains data used by a specific gui. Data is retained
  -- accross all events, and can be used to store state information. However
  -- it is not retained across a save-load.
  -- If called from the SE GuiHandler, will contain Node, and Handler
  function BaseGUI.OnShow(player, data)
  end

  -- void OnClose(Player, Table)
  -- Closes the GUI
  -- Player is required
  -- Data is a table that contains data used by a specific gui. See OnShow for more details.
  function BaseGUI.OnClose(player, data)
  end

  -- void OnTick(Player, Table)
  -- Called if NeedsTicks is true, every game tick
  -- Player is required
  -- Data is a table that contains data used by a specific gui. See OnShow for more details.
  function BaseGUI.OnTick(player, data)
    player.print("Unhandled GUI tick")
  end

  -- void OnPlayerChangedSelectionElement(Player, LuaGuiElement, data)
  -- Called when the player has changed a selection element for this node.
  -- Data is a table that contains data used by a specific gui. See OnShow for more details.
  function BaseGUI.OnPlayerChangedSelectionElement(player, element, data)
    player.print("Unhandled selection changed " .. element.name .. ", " .. (element.elem_value or "Cleared"))
  end

  -- void OnPlayerChangedCheckboxElement(Player, LuaGuiElement, Table)
  -- Called when the player clicks a checkbox in the nodes GUI.
  -- Data is a table that contains data used by a specific gui. See OnShow for more details.
  function BaseGUI.OnPlayerChangedCheckboxElement(player, element, data)
    player.print("Unhandled checkbox changed! " .. element.name .. ", " .. tostring(element.state))
  end

  return BaseGUI
end
