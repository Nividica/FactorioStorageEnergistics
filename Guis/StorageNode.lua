-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

-- Constructs and returns the StorageNodeGUI object
return function(BaseGui)
  local StorageNodeGUI = {}
  setmetatable(StorageNodeGUI, {__index = BaseGui})

  -- @See BaseGui:OnShow
  function StorageNodeGUI:OnShow(event)
    -- Get root
    local frame =
      BaseGui.CreateFrame(
      event.player_index,
      SE.Constants.Names.Gui.StorageChestFrameRoot,
      SE.Constants.Names.Gui.StorageChestFrame,
      SE.Constants.Strings.Local.ChestSettings
    )
    -- Could new frame be created?
    if (frame == nil) then
      return false
    end

    -- Add read only checkbox
    frame.add(
      {
        type = "checkbox",
        name = SE.Constants.Names.Gui.StorageChestReadOnlyCheckbox,
        state = (self.Node.ReadOnlyMode == true),
        caption = SE.Constants.Strings.Local.ChestMode,
        tooltip = SE.Constants.Strings.Local.ChestMode_Tooltip
      }
    )

    return true
  end

  -- @See BaseGui:OnClose
  function StorageNodeGUI:OnClose(playerIndex)
    local frame = BaseGui.GetFrame(playerIndex, SE.Constants.Names.Gui.StorageChestFrameRoot, SE.Constants.Names.Gui.StorageChestFrame)
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  -- @See BaseGui:OnPlayerChangedCheckboxElement
  function StorageNodeGUI:OnPlayerChangedCheckboxElement(event)
    local chkBox = event.element
    -- Ensure the frame is present, and the correct box was clicked
    if (chkBox.name == SE.Constants.Names.Gui.StorageChestReadOnlyCheckbox) then
      if (chkBox.state) then
        self.Node.ReadOnlyMode = true
      else
        -- Why nil? Micro-optimization.
        -- Setting to false will cause the property to be serialized
        -- Since false is the default mode, removing the property has the same effect
        self.Node.ReadOnlyMode = nil
      end
    end
  end

  return StorageNodeGUI
end
