-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/29/2017
-- Description: Storage Node

return function(BaseHandler)
  local InterfaceNodeHandler = {
    HandlerName = SE.Constants.Names.NodeHandlers.Interface,
    NeedsTicks = true,
    Type = SE.Constants.NodeTypes.Device
  }
  setmetatable(InterfaceNodeHandler, {__index = BaseHandler})

  -- CopyNodeFilters( Node, Node ) :: void
  -- Copies the filters from the source to the node
  local function CopyNodeFilters(node, sourceNode)
    -- Get the handler for the source node
    local sHandler = SE.NodeHandlers.GetNodeHandler(sourceNode)
    if (sHandler == nil) then
      -- No handler
      return
    elseif (not sHandler.IsFiltered(sourceNode, "item")) then
      -- Node isn't filtered
      return
    end

    -- Clear node filters
    node.RequestFilters = {}

    -- Get source filters
    local sFilters = sHandler.GetFilters(sourceNode, "item")
    if (sFilters == nil) then
      -- No filters set on source node
      return
    end

    -- Copy the filters
    for _, filter in pairs(sFilters) do
      -- Determine how many GUI slots this will occupy
      local reqSlots = math.ceil(amount / SE.StackSizeCache[item])
      -- Add gui slots
      for i = 1, reqSlots do
        table.insert(node.RequestFilters, {Item = filter.Item, Amount = filter.Amount})
      end
    end
  end

  -- SetFiltersFromRecipe( Node, LuaRecipe ) :: void
  -- Sets the filters for the node based on the given recipe
  local function SetFiltersFromRecipe(node, recipe)
    -- Clear node filters
    node.RequestFilters = {}
    for _, ingredient in ipairs(recipe.ingredients) do
      -- Only copy items
      if (ingredient.type == "item") then
        -- Add the item
        table.insert(node.RequestFilters, {Item = ingredient.name, Amount = ingredient.amount})
      end
    end
  end

  -- IsFiltered( Self, string ) :: bool
  function InterfaceNodeHandler:IsFiltered(type)
    return type == "item"
  end

  -- GetFilters( Self, string ) :: Array( { Item :: string, Amount: int } )
  function InterfaceNodeHandler:GetFilters(type)
    if (type == "item") then
      return self.RequestFilters
    end
    return nil
  end

  -- @See BaseNode:OnNetworkTick
  -- Fills interface with filtered items, removes anything else
  function InterfaceNodeHandler:OnNetworkTick(network)
    -- Get the nodes inventory
    local inv = self.Entity.get_inventory(defines.inventory.chest)

    -- No work to perform?
    if (inv.is_empty() and next(self.RequestFilters) == nil) then
      --SE.Logger.Trace("No work for interface")
      return
    end

    -- Get what is stored in the inventory
    local existing = inv.get_contents()

    -- Assume all filters are to be fully requested
    local toAdd = {}
    for _, filter in pairs(self.RequestFilters) do
      toAdd[filter.Item] = (toAdd[filter.Item] or 0) + filter.Amount
    end

    -- Debug
    --toAdd["iron-ore"] = 37000

    -- Determine items to remove and to add
    local toRemove = {}
    for itemName, haveAmount in pairs(existing) do
      -- Get wanted amount
      local wantAmount = (toAdd[itemName] or 0)

      --SE.Logger.Trace("For item " .. itemName .. ", Have: " .. tostring(haveAmount) .. ", Want: " .. tostring(wantAmount))

      if (haveAmount < wantAmount) then
        -- Want more
        toAdd[itemName] = wantAmount - haveAmount
      else
        -- Want less or have exact amount
        toAdd[itemName] = nil
        if (haveAmount > wantAmount) then
          -- Want less
          -- Create a simple stack
          local stack = {name = itemName, count = haveAmount - wantAmount}
          --SE.Logger.Trace("Attempting to remove " .. tostring(stack.count) .. " " .. itemName)

          -- Attempt network insertion
          local insertedAmount = SE.NetworkHandler.InsertItems(network, stack, self)
          if (insertedAmount > 0) then
            -- Remove inserted amount from inventory
            stack.count = insertedAmount
            inv.remove(stack)
          end
        end
      end
    end

    -- Add requested
    for itemName, Amount in pairs(toAdd) do
      -- Create a simple stack
      local stack = {name = itemName, count = Amount}
      -- Perform a fake insert to get how many can be inserted
      local canBeInserted = inv.insert(stack)
      -- Can any be inserted
      if (canBeInserted > 0) then
        stack.count = canBeInserted
        -- Remove fake insert
        inv.remove(stack)
        --SE.Logger.Trace("Attempting to add " .. tostring(stack.count) .. " " .. itemName)

        -- Attempt network extraction
        local extractedAmount = SE.NetworkHandler.ExtractItems(network, stack, self)
        if (extractedAmount > 0) then
          -- Add to inventory
          stack.count = extractedAmount
          inv.insert(stack)
        end
      --else
      --SE.Logger.Trace("Not enough inventory space to add any " .. itemName)
      end
    end
  end

  -- @See BaseNode:OnPlayerOpenedNode
  function InterfaceNodeHandler:OnPlayerOpenedNode(player)
    return SE.GuiManager.Guis.InterfaceNode
  end

  -- @See BaseNode:OnPasteSettings
  function InterfaceNodeHandler:OnPasteSettings(sourceEntity, player)
    local otherNode = SE.Networks.GetNodeForEntity(sourceEntity)
    if (otherNode) then
      -- Network node
      CopyNodeFilters(self, otherNode)
    elseif (sourceEntity.recipe) then
      -- Crafting machine
      SetFiltersFromRecipe(self, sourceEntity.recipe)
    end
  end

  -- @See BaseNode.NewNode
  function InterfaceNodeHandler.NewNode(entity)
    return InterfaceNodeHandler.EnsureStructure(BaseHandler.NewNode(entity))
  end

  -- @See BaseNode:EnsureStructure
  function InterfaceNodeHandler:EnsureStructure()
    BaseHandler.EnsureStructure(self)

    -- Map( FilterIndex :: int -> { Item :: string, Amount :: int } )
    -- Used by the GUI to display selected items
    self.RequestFilters = self.RequestFilters or {}

    -- Set handler name
    self.HandlerName = InterfaceNodeHandler.HandlerName

    return self
  end

  return InterfaceNodeHandler
end
