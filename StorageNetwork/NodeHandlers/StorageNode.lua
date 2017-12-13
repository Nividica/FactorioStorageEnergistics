-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/29/2017
-- Description: Storage Node

return function(BaseHandler)
  local StorageNodeHandler = {
    HandlerName = SE.Constants.Names.NodeHandlers.Storage,
    Type = SE.Constants.NodeTypes.Storage
  }
  setmetatable(StorageNodeHandler, {__index = BaseHandler})

  local function GetChestGUIRoot(player)
    return player.gui[SE.Constants.Names.Gui.StorageChestFrameRoot]
  end

  local function GetChestGUIFrame(root)
    return root[SE.Constants.Names.Gui.StorageChestFrame]
  end

  -- Shows the selection GUI, attached to the root gui element
  local function ShowChestGUI(node, root)
    if (GetChestGUIFrame(root) ~= nil) then
      -- GUI already shown
      return
    end
    -- Add the frame
    local frame =
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
        state = (node.ReadOnlyMode == true),
        caption = "Read Only Mode", -- TODO: Make localized
        tooltip = "Prevents the storage network, and only the storage network, from placing items in this chest." -- TODO: Make localized
      }
    )
  end

  -- Closes the selection GUI, attached to the root gui element
  local function CloseChestGUI(root)
    local frame = GetChestGUIFrame(root)
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  -- Returns true if read only should be forced, based on the entity
  local function ForceReadOnly(node)
    return node.Entity.name == SE.Constants.Names.Proto.RequesterChest.Entity
  end

  -- Show the gui
  function StorageNodeHandler:OnPlayerOpenedNode(player)
    if (not ForceReadOnly(self)) then
      ShowChestGUI(self, GetChestGUIRoot(player))
    end
  end

  -- Close the gui
  function StorageNodeHandler:OnPlayerClosedNode(player)
    if (not ForceReadOnly(self)) then
      CloseChestGUI(GetChestGUIRoot(player))
    end
  end

  function StorageNodeHandler:OnPlayerChangedCheckboxElement(player, element)
    -- Ensure the frame is present, and the correct box was clicked
    if (GetChestGUIFrame(GetChestGUIRoot(player)) ~= nil and element.name == SE.Constants.Names.Gui.StorageChestReadOnlyCheckbox) then
      if (element.state) then
        self.ReadOnlyMode = true
      else
        -- Why nil? Micro-optimization.
        -- Setting to false will cause the property to be serialized
        -- Since false is the default mode, removing the property has the same effect
        self.ReadOnlyMode = nil
      end
    end
  end

  function StorageNodeHandler:InsertItems(stack, simulate)
    if (self.ReadOnlyMode) then
      return 0
    end
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    local inserted = inv.insert(stack)
    if (simulate and inserted > 0) then
      inv.remove({name = stack.name, count = inserted})
    end
    return inserted
  end

  function StorageNodeHandler:ExtractItems(stack, simulate)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    local removed = inv.remove(stack)
    if (simulate and removed > 0) then
      inv.insert({name = stack.name, count = removed})
    end
    return removed
  end

  function StorageNodeHandler:GetItemCount(itemName)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    return inv.get_item_count(itemName)
  end

  function StorageNodeHandler:GetContents(catalog)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    -- Get total slot count
    local totalSlots = #inv

    -- Add total to catalog
    catalog[SE.Constants.Strings.TotalSlots] = (catalog[SE.Constants.Strings.TotalSlots] or 0) + totalSlots

    -- Examine inventory
    local freeSlots = 0
    local item = nil
    for idx = 1, totalSlots do
      item = inv[idx]
      if (item.valid_for_read) then
        --SE.Logger.Trace("Index " .. tostring(idx) .. " has item " .. item.name .. " x" .. tostring(item.count))
        -- Add item to catalog
        catalog[item.name] = (catalog[item.name] or 0) + item.count
      else
        freeSlots = freeSlots + 1
      end
    end

    -- Add free to catalog
    catalog[SE.Constants.Strings.FreeSlots] = (catalog[SE.Constants.Strings.FreeSlots] or 0) + freeSlots
  end

  function StorageNodeHandler:OnPasteSettings(sourceEntity, player)
    -- Is this node forced read-only?
    if (ForceReadOnly(self)) then
      return
    end

    -- Other node is storage node?
    local node = SE.Networks.GetNodeForEntity(sourceEntity)
    if (node ~= nil) then
      local handler = SE.NodeHandlers.GetNodeHandler(node)
      if (handler ~= nil and handler.Type == SE.Constants.NodeTypes.Storage) then
        -- Copy read only setting
        self.ReadOnlyMode = node.ReadOnlyMode
      end
    end
  end

  function StorageNodeHandler.NewNode(entity)
    return StorageNodeHandler.EnsureStructure(BaseHandler.NewNode(entity))
  end

  function StorageNodeHandler:EnsureStructure()
    BaseHandler.EnsureStructure(self)
    self.HandlerName = StorageNodeHandler.HandlerName
    if (ForceReadOnly(self)) then
      self.ReadOnlyMode = true
    end
    --self.ReadOnlyMode = nil
    return self
  end

  return StorageNodeHandler
end
