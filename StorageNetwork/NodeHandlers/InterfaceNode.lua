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

  -- Recalculates the requested amounts for the interface
  local function RecalculateRequestedAmounts(node)
    local items = {}
    for _, itemName in pairs(node.RequestFilters) do
      items[itemName] = (items[itemName] or 0) + SE.StackSizeCache[itemName]
    end
    node.RequestedItemAmounts = items
  end
  -- Shows the selection GUI, attached to the root gui element
  local function ShowSelectionGUI(node, root)
    -- Add the frame
    local frame =
      root.add(
      {
        type = "frame",
        name = SE.Constants.Names.Gui.InterfaceFrame,
        caption = "Energistics request" -- Make localized
      }
    )
    frame.style.title_bottom_padding = 6

    -- Create the inner body
    local body =
      frame.add(
      {
        type = "table",
        name = "body",
        colspan = 5
      }
    )

    -- Add selection buttons
    for idx = 1, 10 do
      body.add(
        {
          type = "choose-elem-button",
          name = SE.Constants.Names.Gui.InterfaceItemSelectionElement .. tostring(idx),
          elem_type = "item",
          item = node.RequestFilters[idx]
        }
      )
    end
  end

  -- Closes the selection GUI, attached to the root gui element
  local function CloseSelectionGUI(root)
    local frame = root[SE.Constants.Names.Gui.InterfaceFrame]
    if (frame ~= nil) then
      frame.destroy()
    end
  end

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
    node.RequestedItemAmounts = {}

    -- Get source filters
    local sFilters = sHandler.GetFilters(sourceNode, "item")
    if (sFilters == nil) then
      -- No filters set on source node
      return
    end

    -- Copy the filters
    for item, amount in pairs(sFilters) do
      -- Set the amount
      node.RequestedItemAmounts[item] = amount

      -- Determine how many GUI slots this will occupy
      local reqSlots = math.ceil(amount / SE.StackSizeCache[item])
      -- Add gui slots
      for i = 1, reqSlots do
        table.insert(node.RequestFilters, item)
      end
    end
  end

  -- Sets the filters for the node based on the given recipe
  local function SetFiltersFromRecipe(node, recipe)
    -- Clear node filters
    node.RequestFilters = {}
    for _, ingredient in ipairs(recipe.ingredients) do
      -- Only copy items
      if (ingredient.type == "item") then
        -- Add the item
        table.insert(node.RequestFilters, ingredient.name)
      end
    end
    -- Update request amounts
    RecalculateRequestedAmounts(node)
  end

  function InterfaceNodeHandler:IsFiltered(type)
    return type == "item"
  end

  function InterfaceNodeHandler:GetFilters(type)
    if (type == "item") then
      return self.RequestedItemAmounts
    end
    return nil
  end

  -- Fills interface with filtered items, removes anything else
  function InterfaceNodeHandler:OnNetworkTick(network)
    -- Get the nodes inventory
    local inv = self.Entity.get_inventory(defines.inventory.chest)

    -- No work to perform?
    if (inv.is_empty() and next(self.RequestedItemAmounts) == nil) then
      --SE.Logger.Trace("No work for interface")
      return
    end

    -- Get what is stored in the inventory
    local existing = inv.get_contents()

    -- Assume all filters are to be fully requested
    local toAdd = {}
    for itemName, Amount in pairs(self.RequestedItemAmounts) do
      toAdd[itemName] = Amount
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

  -- Build and add the filter GUI to the player
  function InterfaceNodeHandler:OnPlayerOpenedNode(player)
    ShowSelectionGUI(self, player.gui[SE.Constants.Names.Gui.InterfaceFrameRoot])
  end

  -- Close the selection gui
  function InterfaceNodeHandler:OnPlayerClosedNode(player)
    CloseSelectionGUI(player.gui[SE.Constants.Names.Gui.InterfaceFrameRoot])
  end

  -- Player changed a gui filter
  function InterfaceNodeHandler:OnPlayerChangedSelectionElement(player, element)
    -- Get the index
    local index = tonumber(string.sub(element.name, 1 + string.len(SE.Constants.Names.Gui.InterfaceItemSelectionElement)))
    --player.print("Thing changed! " .. index .. ", " .. (element.elem_value or "Cleared"))

    -- Set the filter
    self.RequestFilters[index] = element.elem_value

    -- Recalc request amounts
    RecalculateRequestedAmounts(self)
  end

  -- Settings pasted
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

  function InterfaceNodeHandler.NewNode(entity)
    return InterfaceNodeHandler.EnsureStructure(BaseHandler.NewNode(entity))
  end

  function InterfaceNodeHandler:EnsureStructure()
    BaseHandler.EnsureStructure(self)

    -- Map( FilterIndex :: int -> ItemName :: string )
    -- Used by the GUI to display selected items
    self.RequestFilters = self.RequestFilters or {}

    -- Map( ItemName :: string -> RequestedAmount :: int )
    -- Used internaly as the aggrigation of the request filters
    self.RequestedItemAmounts = self.RequestedItemAmounts or {}

    -- Set handler name
    self.HandlerName = InterfaceNodeHandler.HandlerName

    return self
  end

  return InterfaceNodeHandler
end
