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

  -- ForceReadOnly( Node ) :: bool
  -- Returns true if read only should be forced, based on the entity
  local function ForceReadOnly(node)
    return node.Entity.name == SE.Constants.Names.Proto.RequesterChest.Entity
  end

  -- @See BaseNode:OnGetGuiHandler
  -- Show the gui
  function StorageNodeHandler:OnGetGuiHandler(playerIndex)
    if (not ForceReadOnly(self)) then
      return SE.GuiManager.Guis.StorageNode
    end
  end

  -- @See BaseNode:InsertItems
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

  -- @See BaseNode:ExtractItems
  function StorageNodeHandler:ExtractItems(stack, simulate)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    local removed = inv.remove(stack)
    if (simulate and removed > 0) then
      inv.insert({name = stack.name, count = removed})
    end
    return removed
  end

  -- @See BaseNode:GetItemCount
  function StorageNodeHandler:GetItemCount(itemName)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    return inv.get_item_count(itemName)
  end

  -- @See BaseNode:OnPasteSettings
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

  -- @See BaseNode:OnPreMined
  function StorageNodeHandler:OnPreMined(miner)
    -- Get the entity name
    local entityName = self.Entity.name

    -- Only MK2 can save its inventory
    local chestMk2 = SE.Constants.Names.Proto.StorageChestMk2
    local chestMk2Stored = SE.Constants.Names.Proto.StorageChestMk2Stored
    if (not (entityName == chestMk2.Entity or entityName == chestMk2Stored.Entity)) then
      self.StorageEntity = nil
      return
    end

    -- Get if the entity inventory is empty or not.
    local entityInventory = self.Entity.get_inventory(defines.inventory.chest)
    local entityEmpty = entityInventory.is_empty()

    -- Create the item that ultimately represents this chest
    self.StorageEntity =
      miner.surface.create_entity {
      name = "item-on-ground",
      position = self.Entity.position,
      force = miner.force,
      stack = {name = ((entityEmpty and chestMk2.Item) or chestMk2Stored.Item), count = 1}
    }

    -- Nothing to save?
    if (entityEmpty) then
      return
    end

    local storageInventory = self.StorageEntity.stack.get_inventory(defines.inventory.chest)
    for idx = 1, #entityInventory do
      storageInventory[idx].set_stack(entityInventory[idx])
    end

    -- Clear the contents
    entityInventory.clear()
  end

  -- @See BaseNodeHandler:OnDestroy
  function StorageNodeHandler:OnDestroy(bufferInventory)
    if (self.StorageEntity ~= nil) then
      bufferInventory[1].set_stack(self.StorageEntity.stack)
      self.StorageEntity.destroy()
    end

    -- Things to save?
    --if (not entityIsEmpty) then
    -- Write entity inventory to tag
    --end

    -- -- Can this entity save it's data?
    -- if (CanSaveInventory(self)) then
    --   -- Locate
    --   for i = 1, #buffer do
    --     local stack = buffer[i]
    --     if stack.name == SE.Constants.Names.Proto.StorageChestMk2.Item then
    --     end

    --     if stack.name == SE.Constants.Names.Proto.StorageChestMk2Stored.Item then
    --       stack.set_tag("pos-x", entity.position.x)
    --       stack.set_tag("pos-y", entity.position.y)
    --     end
    --   end
    -- end
  end

  -- OnPasteSettings( Self,  LuaEntity, LuaPlayer ) :: void
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

  -- @See BaseNode.NewNode
  function StorageNodeHandler.NewNode(entity)
    return StorageNodeHandler.EnsureStructure(BaseHandler.NewNode(entity))
  end

  -- Returns if the node is read only or not
  function StorageNodeHandler:IsReadOnly()
    return self.ReadOnlyMode
  end

  -- @See BaseNode:EnsureStructure
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
