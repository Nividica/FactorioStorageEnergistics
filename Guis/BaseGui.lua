-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

-- Construct and return the BaseGui object
return function()
  local BaseGui = {
    -- NeedsTicks :: bool
    -- True if gui will require ticks.
    NeedsTicks = false
  }

  -- CreateFrame( uint, string, string, string ) :: LuaGuiElement
  function BaseGui.CreateFrame(playerIndex, rootName, frameName, frameCaption)
    local root = game.players[playerIndex].gui[rootName]

    -- Has frame?
    local frame = root[frameName]
    if (frame ~= nil) then
      -- Already open
      return false
    end

    -- Add the frame
    frame =
      root.add(
      {
        type = "frame",
        name = frameName,
        caption = frameCaption
      }
    )

    frame.style.title_bottom_padding = 6

    return frame
  end

  -- GetFrame( uint, string, string ) :: LuaGuiElement, [LuaPlayer]
  function BaseGui.GetFrame(playerIndex, rootName, frameName)
    local player = game.players[playerIndex]
    return player.gui[rootName][frameName], player
  end

  -- OnShow( Self, Event ) :: bool
  -- Shows the GUI.
  -- playerIndex
  -- Self: is a table that contains data used by a specific gui. Data is retained
  -- accross all events, and can be used to store state information. However
  -- it is not retained across a save-load.
  -- If called due to an entity with a node being clicked on, will contain the node and handler.
  -- Returns: true if the GUI is shown, false if it is not
  function BaseGui:OnShow(event)
    return false
  end

  -- OnClose( Self, uint ) :: void
  -- Closes the GUI.
  -- playerIndex
  -- Self: Gui data. @See BaseGui:OnShow for more details.
  -- Note: It must be acceptable that Self may be nil, and the GUI must still close!
  function BaseGui:OnClose(playerIndex)
  end

  -- OnTick( Self, uint, uint ) :: bool
  -- Called if NeedsTicks is true, every game tick
  -- Self: Gui data. @See BaseGui:OnShow for more details.
  -- Returns: True to keep gui open, return false to close it
  function BaseGui:OnTick(playerIndex, tick)
    return false
  end

  -- OnPlayerChangedSelectionElement( Self, Event ) :: void
  -- Called when the player has changed a selection element for this node.
  -- Self: Gui data. @See BaseGui:OnShow for more details.
  function BaseGui:OnPlayerChangedSelectionElement(event)
  end

  -- OnPlayerChangedCheckboxElement( Self, Event ) :: void
  -- Called when the player clicks a checkbox in the nodes GUI.
  -- Self: Gui data. @See BaseGui:OnShow for more details.
  function BaseGui:OnPlayerChangedCheckboxElement(event)
  end

  -- OnPlayerChangedDropDown( Self, Event ) :: void
  -- Called when the player changes a dropdown.
  -- Self: Gui data. @See BaseGui:OnShow for more details.
  function BaseGui:OnPlayerChangedDropDown(event)
  end

  -- OnPlayerClicked( Self, Event ) :: void
  -- Called when the player clicks something.
  -- Self: Gui data. @See GuiManager::OnElementClicked for more details.
  function BaseGui:OnPlayerClicked(event)
  end

  -- OnPlayerChangedText( Self, Event ) :: void
  -- Called when the player types in a text element
  function BaseGui:OnPlayerChangedText(event)
  end

  -- OnPlayerChangedSlider( Self, Event ) :: void
  -- Called when the player moves a slider
  function BaseGui:OnPlayerChangedSlider(event)
  end

  return BaseGui
end
