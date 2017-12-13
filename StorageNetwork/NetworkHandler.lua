-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/27/2017
-- Description: Handles a single network

return function()
  local SENetwork = {}

  -- Creates a new SENetwork with the given ID and wire type.
  function SENetwork.NewNetwork(networkID, wireType)
    local network = {
      WireType = wireType,
      NetworkID = networkID,
      ControllerNodes = {},
      PowerSourceNodes = {},
      PowerSourceNodeCount = 0,
      StorageNodes = {},
      DeviceNodes = {},
      TickingNodes = {},
      StorageCatalog = nil,
      IdlePowerDraw = 0,
      HasPower = false,
      LastStorageTick = 0
    }
    return network
  end

  -- void RemoveNode(self,node,fireNodeEvents)
  -- Adds a node to the network
  -- node: Node to add
  -- fireNodeEvents: True to inform node that it is joining network
  function SENetwork:AddNode(node, fireNodeEvents)
    -- Get the nodes handler
    local nodeHandler = SE.NodeHandlers.GetNodeHandler(node)
    local nodeType = nodeHandler.Type

    --SE.Logger.Trace("Network: Adding node " .. nodeHandler.HandlerName)

    -- Add to the proper node table
    if (nodeType == SE.Constants.NodeTypes.Storage and self.StorageNodes[node] == nil) then
      self.StorageNodes[node] = nodeHandler
    elseif (nodeType == SE.Constants.NodeTypes.Device and self.DeviceNodes[node] == nil) then
      self.DeviceNodes[node] = nodeHandler
    elseif (nodeType == SE.Constants.NodeTypes.PowerSource and self.PowerSourceNodes[node] == nil) then
      self.PowerSourceNodes[node] = nodeHandler
      self.PowerSourceNodeCount = self.PowerSourceNodeCount + 1
    elseif (nodeType == SE.Constants.NodeTypes.Controller and self.ControllerNodes[node] == nil) then
      self.ControllerNodes[node] = nodeHandler
    else
      return
    end

    -- Does the node tick?
    if (nodeHandler.NeedsTicks == true) then
      --SE.Logger.Trace("Network: Added ticking node")
      self.TickingNodes[node] = nodeHandler
    end

    -- Set the nodes network ID
    node.Networks[self.WireType] = self.NetworkID

    -- Adjust idle power draw
    if (nodeType ~= SE.Constants.NodeTypes.PowerSource) then
      self.IdlePowerDraw = math.max(0, self.IdlePowerDraw + SE.Settings.NodeIdlePowerDrain)
    end

    -- Fire event?
    if (fireNodeEvents) then
      -- Inform the node it is joining
      return nodeHandler.OnJoinNetwork(node, self)
    end
  end

  -- void RemoveNode(self,node,fireNodeEvents)
  -- Removes a node from the network
  -- node: Node to remove
  -- fireNodeEvents: True to inform node that it is leaving network
  function SENetwork:RemoveNode(node, fireNodeEvents)
    -- Get the nodes handler
    local nodeHandler = SE.NodeHandlers.GetNodeHandler(node)
    local nodeType = nodeHandler.Type

    -- Get the node type
    if (self.StorageNodes[node] ~= nil) then
      self.StorageNodes[node] = nil
    elseif (self.DeviceNodes[node] ~= nil) then
      self.DeviceNodes[node] = nil
    elseif (self.PowerSourceNodes[node] ~= nil) then
      self.PowerSourceNodes[node] = nil
      self.PowerSourceNodeCount = self.PowerSourceNodeCount - 1
    elseif (self.ControllerNodes[node] ~= nil) then
      self.ControllerNodes[node] = nil
    else
      -- Node not found
      return
    end

    -- Does the node tick?
    if (nodeHandler.NeedsTicks == true) then
      self.TickingNodes[node] = nil
    end

    -- Remove from node
    node.Networks[self.WireType] = nil

    -- Adjust idle power draw
    if (nodeType ~= SE.Constants.NodeTypes.PowerSource) then
      self.IdlePowerDraw = math.max(0, self.IdlePowerDraw - SE.Settings.NodeIdlePowerDrain)
    end

    if (fireNodeEvents) then
      -- Inform the node it is leaving
      return nodeHandler.OnLeaveNetwork(node, self)
    end
  end

  -- Tick(self :: Network) :: void
  -- Called when the game ticks
  function SENetwork:Tick()
    -- Draw idle power
    self.HasPower = (self.IdlePowerDraw == 0) or SENetwork.ExtractPower(self, self.IdlePowerDraw)
  end

  -- void NetworkTick(self)
  -- Called when the network ticks
  function SENetwork:NetworkTick()
    if (not self.HasPower) then
      -- Not enough power to run network
      SE.Logger.Trace("Not enough power for network " .. tostring(self.NetworkID))
      return
    end

    -- Network requires at least 1 controller to tick devices
    if (next(self.ControllerNodes) == nil) then
      SE.Logger.Trace("Missing controller(s) on network " .. tostring(self.NetworkID))
      return
    end

    -- Tick nodes
    for node, handler in pairs(self.TickingNodes) do
      if (handler.Valid(node)) then
        --SE.Logger.Trace("Ticking Node")
        handler.OnNetworkTick(node, self)
      end
    end
  end

  -- bool CanExtractPower(network,request)
  -- request: PowerRequest
  -- Returns true if the request can be fully satisfied, false if not
  -- If the request can only be partially satisfied, you can check request.WattsRemaining
  -- to get the amount of power that can not be provided.
  local function CanExtractPower(network, request)
    -- Mark that this network has been visitied
    request.VisititedNetworks[network.NetworkID] = true

    --SE.Logger.Trace("Starting Network Power Request For Network " .. tostring(network.NetworkID) .. ", Amount: " .. tostring(request.WattsRemaining))
    if (network.PowerSourceNodeCount > 0) then
      -- Phase 1, Calculate power sum and visit nodes
      local totalPowerInNetwork = 0
      local networkSources = {}
      for node, handler in pairs(network.PowerSourceNodes) do
        -- Is the node valid, and unvisitied?
        if (handler.Valid(node) and request.VisitedNodes[node] == nil) then
          -- Get stored power amount
          local nodeStored = handler.StoredPower(node)

          -- Add to total
          totalPowerInNetwork = totalPowerInNetwork + nodeStored

          -- Add to maps
          local source = {
            Node = node,
            Handler = handler,
            Stored = nodeStored,
            Extract = nodeStored -- Note: This assume worst case that request amount >= total network amount
          }
          if (nodeStored > 0) then
            -- Don't bother doing phase 2+ with fully drained nodes
            networkSources[#networkSources + 1] = source
          end
          request.VisitedNodes[node] = source
        end
      end

      -- Is there less power in the network than in the request?
      if (request.WattsRemaining >= totalPowerInNetwork) then
        --SE.Logger.Trace("Extracting all power from network. " .. tostring(totalPowerInNetwork))
        -- Drain this entire network of power
        request.WattsRemaining = request.WattsRemaining - totalPowerInNetwork
      else
        -- Phase 2, Calculate extract amounts
        local totalExtractionAmount = 0
        local nodeWeight = 0
        for idx, source in ipairs(networkSources) do
          -- Calculate the nodes contribution weight
          nodeWeight = source.Stored / totalPowerInNetwork

          -- Calculate extraction amount with rounding
          source.Extract = math.min(source.Stored, math.floor(0.5 + (nodeWeight * request.WattsRemaining)))

          -- Add to sum
          totalExtractionAmount = totalExtractionAmount + source.Extract

          --SE.Logger.Trace("-- Source Node Found. Stored: " .. tostring(source.Stored) .. ", Weight: " .. tostring(nodeWeight) .. ", Extract: " .. tostring(source.Extract))
        end

        -- Adjust remaining watts
        request.WattsRemaining = request.WattsRemaining - totalExtractionAmount

        -- Was anything left over? (rounding errors)
        if (request.WattsRemaining > 0) then
          --SE.Logger.Trace("Locating the last " .. tostring(request.WattsRemaining))
          -- Phase 3, find any node with power left to take
          for idx, source in ipairs(networkSources) do
            if (source.Extract < source.Stored) then
              local extraExtract = math.min(request.WattsRemaining, source.Stored - source.Extract)
              source.Extract = source.Extract + extraExtract
              request.WattsRemaining = request.WattsRemaining - extraExtract

              -- Done?
              if (request.WattsRemaining == 0) then
                -- Stop phase 3
                break
              end
            end
          end
        end

        -- Sanity check
        if (request.WattsRemaining > 0) then
          SE.Logger.Flush()
          error("Unfinished power request when network had enough power: (" .. tostring(totalPowerInNetwork) .. ", " .. tostring(request.RequestedWatts) .. ")")
        end

        -- Request fully satisfied
        --SE.Logger.Trace("End Network Power Request. Fully satisfied.\n")
        return true
      end -- End request.WattsRemaining >= totalPowerInNetwork
    end -- End network.PowerSourceNodeCount > 0
    --SE.Logger.Trace("End Network Power Request. Remaining watts " .. tostring(request.WattsRemaining))

    -- -- Visit power source nodes
    -- for node, handler in pairs(network.PowerSourceNodes) do
    --   -- Is the node valid, and unvisitied?
    --   if (handler.Valid(node) and request.VisitedNodes[node] == nil) then
    --     -- How much power is in this node?
    --     local nodeStored = handler.StoredPower(node)

    --     -- Does the node have any power?
    --     if (nodeStored > 0) then
    --       -- Is it enough to satisfy the request?
    --       if (request.WattsRemaining <= nodeStored) then
    --         -- Node can satisfy request
    --         nodeStored = request.WattsRemaining
    --       end

    --       -- Add to map
    --       request.VisitedNodes[node] = {Handler = handler, Amount = nodeStored}

    --       -- Adjust remaining
    --       request.WattsRemaining = request.WattsRemaining - nodeStored
    --       if (request.WattsRemaining == 0) then
    --         -- Power request satisfied fully
    --         return true
    --       end
    --     end
    --   end
    -- end

    -- Power request not fully satisfied.
    -- Get the other wire type
    local bridgedColor = nil
    if (network.WireType == defines.wire_type.red) then
      bridgedColor = defines.wire_type.green
    else
      bridgedColor = defines.wire_type.red
    end

    -- Check bridged network(s)
    local satisfied = false
    for controller, handler in pairs(network.ControllerNodes) do
      -- Get the bridged network
      local bridgedNetworkID = controller.Networks[bridgedColor]
      -- Is there a bridged network, and has it not been visited?
      if (bridgedNetworkID ~= nil and request.VisititedNetworks[bridgedNetworkID] == nil) then
        -- Can it satisfy the request?
        if (CanExtractPower(SE.Networks.GetNetwork(bridgedNetworkID), request) == true) then
          -- Request fully satisfied
          return true
        end
      end
    end

    -- Checked every available power source, and was not able to satisfy request
    return false
  end

  -- void DoExtractPower(netMap)
  -- Extracts the requested amount of power from the nodes in the map.
  -- request: PowerRequest
  local function DoExtractPower(request)
    for node, source in pairs(request.VisitedNodes) do
      source.Handler.ExtractPower(node, source.Extract)
    end
  end

  -- PowerRequest NewPowerRequest(watts)
  -- Creates a new power request
  -- watts: Amount of power to request
  -- Returns: {
  -- -- int WattsRemaining,
  -- -- Map( int:NetworkID -> bool ) VisititedNetworks,
  -- -- Map( Node::Node -> {Node::Node, Handler::Handler, Extract::int, Stored::int} ) VisitedNodes
  -- }
  local function NewPowerRequest(watts)
    return {RequestedWatts = watts, WattsRemaining = watts, VisititedNetworks = {}, VisitedNodes = {}}
  end

  -- void ReducePowerRequest(request,watts)
  -- Reduces the amount of power requested
  -- request: PowerRequest
  -- watts: Amount to reduce by
  local function ReducePowerRequest(request, watts)
    local amountRemaining = watts
    for node, info in pairs(request.VisitedNodes) do
      -- Does node provide enough power to reduce by?
      if (info.Amount >= amountRemaining) then
        -- Reduce the amount of power being drawn from the node
        info.Amount = info.Amount - amountRemaining
        -- Reduction complete
        return
      else
        -- Reduce amount remaining by how much power this node would have given.
        amountRemaining = amountRemaining - info.Amount
        -- Completely remove the node
        request.VisitedNodes[node] = nil
      end
    end
  end

  -- bool ExtractPower(self,watts)
  -- Attempts to extract the requested amount of power.
  -- Returns true if the power was extracted.
  function SENetwork:ExtractPower(watts)
    --SE.Logger.Trace("Extract Power Request: " .. tostring(watts))
    if (watts <= 0) then
      return true
    end
    local request = NewPowerRequest(watts)
    if (CanExtractPower(self, request)) then
      DoExtractPower(request)
      return true
    end
    return false
  end

  local TransferReasonCodes = {
    Ok = 0,
    LowPower = 1,
    NotAllTransfered = 2
  }

  -- {Amount,ReasonCode} TransferItems(network, stack, transferFn)
  -- Transfers as many items as possible to/from the network.
  -- network: The network to transfer to/from
  -- stack: The items to transfer
  -- transferFn: Function name to call on each nodes handler to transfer items.
  -- requesterNode: Node that requested the transfer
  -- Returns: Amount transfered
  local function TransferItems(network, stack, transferFn, requesterNode)
    -- Copy the stack amount
    local itemsToTransfer = stack.count

    -- Is the amount valid?
    if (itemsToTransfer <= 0) then
      return 0
    end

    -- Create a new stack with adjusted amount
    local adjustedStack = {name = stack.name, count = itemsToTransfer}

    -- Attempt to transfer all items
    local totalAmountTransfered = 0

    -- Assume not all can be transfered
    local reasoncode = TransferReasonCodes.NotAllTransfered

    for node, handler in pairs(network.StorageNodes) do
      local simTransfered = handler[transferFn](node, adjustedStack, true)

      -- Can any be transfered?
      if (simTransfered > 0) then
        -- Calculate power
        local reqPower = (simTransfered * SE.Settings.PowerPerItem)
        -- Calculate Manhattan distance based on chunks
        reqPower =
          reqPower +
          ((math.abs(node.ChunkPosition.x - requesterNode.ChunkPosition.x) + math.abs((node.ChunkPosition.y - requesterNode.ChunkPosition.y))) *
            (SE.Settings.PowerPerChunk * simTransfered))

        -- Can the power be extracted?
        if (SENetwork.ExtractPower(network, reqPower)) then
          -- Transfer
          handler[transferFn](node, adjustedStack, false)

          -- Adjust amounts
          totalAmountTransfered = totalAmountTransfered + simTransfered
          adjustedStack.count = adjustedStack.count - simTransfered

          -- All done?
          if (adjustedStack.count == 0) then
            reasoncode = TransferReasonCodes.Ok
            break
          end
        else
          -- Not enough power, end here
          reasoncode = TransferReasonCodes.LowPower
          break
        end
      end
    end
    --
    return {Amount = totalAmountTransfered, ReasonCode = reasoncode}
  end

  -- item InsertItems(self,SimpleItemStack,Node)
  -- Attempts to insert the items.
  -- If the network does not have enough power to insert all the items
  -- as many will be inserted as possible.
  -- Returns the amount inserted
  function SENetwork:InsertItems(stack, requesterNode)
    local transfer = TransferItems(self, stack, "InsertItems", requesterNode)

    -- Is the network full?
    if (transfer.ReasonCode == TransferReasonCodes.NotAllTransfered) then
      for idx, player in pairs(game.players) do
        player.add_alert(requesterNode.Entity, defines.alert_type.no_storage)
      end
    end

    return transfer.Amount
  end

  -- int ExtractItems(self,SimpleItemStack,Node)
  -- Attempts to extract the items.
  -- If the network does not have enough power to extract all the items
  -- as many will be extracted as possible.
  -- Returns the amount extracted.
  function SENetwork:ExtractItems(stack, requesterNode)
    return TransferItems(self, stack, "ExtractItems", requesterNode).Amount
  end

  -- Map( item name -> count) GetStorageContents()
  -- Returns all items in the network
  -- TODO: Is this needed?
  function SENetwork:GetStorageContents()
    -- New tick?
    if (game.tick ~= self.LastStorageTick) then
      -- Mark tick
      self.LastStorageTick = game.tick
      self.StorageCatalog = {}
      for node, handler in pairs(self.StorageNodes) do
        handler.GetContents(node, self.StorageCatalog)
      end
    end
    return self.StorageCatalog
  end

  -- bool Empty()
  -- Returns true if there are no nodes on the network
  function SENetwork:Empty()
    return next(self.ControllerNodes) == nil and next(self.PowerSourceNodes) == nil and next(self.StorageNodes) == nil and next(self.DeviceNodes) == nil
  end

  return SENetwork
end
