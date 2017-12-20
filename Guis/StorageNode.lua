-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

-- Constructs and returns the StorageNodeGUI object
return function(BaseGUI)
  local StorageNodeGUI = {}
  setmetatable(StorageNodeGUI, {__index = BaseGUI})

  -- @See BaseGUI:OnShow
  function StorageNodeGUI:OnShow(player)
    -- Get root
    local root = player.gui[SE.Constants.Names.Gui.StorageChestFrameRoot]

    -- Has frame?
    local frame = root[SE.Constants.Names.Gui.StorageChestFrame]
    if (frame ~= nil) then
      -- Already open
      return false
    end

    -- Add the frame
    frame =
      root.add(
      {
        type = "frame",
        name = SE.Constants.Names.Gui.StorageChestFrame,
        caption = SE.Constants.Strings.Local.ChestSettings
      }
    )
    frame.style.title_bottom_padding = 6

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

  -- @See BaseGUI:OnClose
  function StorageNodeGUI:OnClose(player)
    local root = player.gui[SE.Constants.Names.Gui.StorageChestFrameRoot]
    local frame = root[SE.Constants.Names.Gui.StorageChestFrame]
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  -- @See BaseGUI:OnPlayerChangedCheckboxElement
  function StorageNodeGUI:OnPlayerChangedCheckboxElement(player, element)
    local root = player.gui[SE.Constants.Names.Gui.StorageChestFrameRoot]
    local frame = root[SE.Constants.Names.Gui.StorageChestFrame]
    -- Ensure the frame is present, and the correct box was clicked
    if (frame ~= nil and element.name == SE.Constants.Names.Gui.StorageChestReadOnlyCheckbox) then
      if (element.state) then
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
