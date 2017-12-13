-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

return function(BaseGUI)
  local StorageNodeGUI = {}
  setmetatable(StorageNodeGUI, {__index = BaseGUI})

  function StorageNodeGUI.OnShow(player, data)
    -- Get root
    local root = player.gui[SE.Constants.Names.Gui.StorageChestFrameRoot]

    -- Has frame?
    local frame = root[SE.Constants.Names.Gui.StorageChestFrame]
    if (frame ~= nil) then
      -- Already open
      return
    end

    -- Add the frame
    frame =
      root.add(
      {
        type = "frame",
        name = SE.Constants.Names.Gui.StorageChestFrame,
        caption = "Energistics chest" -- TODO: Make localized
      }
    )
    frame.style.title_bottom_padding = 6

    -- Add read only checkbox
    frame.add(
      {
        type = "checkbox",
        name = SE.Constants.Names.Gui.StorageChestReadOnlyCheckbox,
        state = (data.Node.ReadOnlyMode == true),
        caption = "Read Only Mode", -- TODO: Make localized
        tooltip = "Prevents the storage network, and only the storage network, from placing items in this chest." -- TODO: Make localized
      }
    )
  end

  function StorageNodeGUI.OnClose(player, data)
    local root = player.gui[SE.Constants.Names.Gui.StorageChestFrameRoot]
    local frame = root[SE.Constants.Names.Gui.StorageChestFrame]
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  function StorageNodeGUI.OnPlayerChangedCheckboxElement(player, element, data)
    local root = player.gui[SE.Constants.Names.Gui.StorageChestFrameRoot]
    local frame = root[SE.Constants.Names.Gui.StorageChestFrame]
    -- Ensure the frame is present, and the correct box was clicked
    if (frame ~= nil and element.name == SE.Constants.Names.Gui.StorageChestReadOnlyCheckbox) then
      if (element.state) then
        data.Node.ReadOnlyMode = true
      else
        -- Why nil? Micro-optimization.
        -- Setting to false will cause the property to be serialized
        -- Since false is the default mode, removing the property has the same effect
        data.Node.ReadOnlyMode = nil
      end
    end
  end

  return StorageNodeGUI
end
