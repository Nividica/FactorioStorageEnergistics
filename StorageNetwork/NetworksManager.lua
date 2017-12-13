-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/26/2017
-- Description: Manages all storage networks

return function()
  local NetworksManager = {}

  -- All Nodes
  -- Sequential array
  -- Serialized
  local Nodes = nil

  -- Map( CircuitNetworkID -> Network )
  local Networks = {}

  -- Map ( Node -> Handler )
  local TickingNodes = {}

  -- Returns the index of the given node
  local function GetNodeIndex(node)
    for idx = 1, #Nodes do
      if (node == Nodes[idx]) then
        return idx
      end
    end
    return 0
  end

  -- Gets the network for the given node and wire type, will create one if no network is found
  -- Will return nil if the node is not connected to a circuit network for the wire type.
  local function GetOrCreateSENetworkForCircuitNetwork(node, wireType)
    local circuitNetwork = SE.NodeHandlers.GetNodeHandler(node).GetCircuitNetwork(node, wireType)
    if (circuitNetwork == nil) then
      return nil
    end

    local netID = circuitNetwork.network_id
    local network = Networks[netID]
    if (network == nil) then
      network = SE.NetworkHandler.NewNetwork(netID, wireType)
      Networks[netID] = network
    --SE.Logger.Trace("Creating new network for " .. tostring(circuitNetwork.network_id))
    end

    return network
  end

  -- Checks if the node has changed circuit networks, and adjusts SE networks accordingly
  local function ValidateConnection(node, wireType)
    local detectedNet = GetOrCreateSENetworkForCircuitNetwork(node, wireType)

    -- Note that for loading purposes, GetNetworkForNode must come after GetOrCreateSENetworkForCircuitNetwork
    local prevNetwork = NetworksManager.GetNetworkForNode(node, wireType)

    -- Has connection changed?
    if (detectedNet ~= prevNetwork) then
      -- Was on a network?
      if (prevNetwork ~= nil) then
        -- Leave old network
        SE.NetworkHandler.RemoveNode(prevNetwork, node, true)
      --SE.Logger.Trace("Node leaving network " .. tostring(prevNetwork.NetworkID))
      end

      -- Joining a network?
      if (detectedNet ~= nil) then
        SE.NetworkHandler.AddNode(detectedNet, node, true)
      --SE.Logger.Trace("Node joining network " .. tostring(detectedNet.NetworkID))
      end
    end
  end

  -- Removes a node by its index
  local function RemoveNodeByIndex(idx)
    --SE.Logger.Trace("Networks: Removing node")
    local node = Nodes[idx]

    -- Remove from networks
    local network = NetworksManager.GetNetworkForNode(node, defines.wire_type.green)
    if (network ~= nil) then
      SE.NetworkHandler.RemoveNode(network, node, true)
    end
    network = NetworksManager.GetNetworkForNode(node, defines.wire_type.red)
    if (network ~= nil) then
      SE.NetworkHandler.RemoveNode(network, node, true)
    end

    -- Set node networks to nil
    node.Networks[defines.wire_type.red] = nil
    node.Networks[defines.wire_type.green] = nil

    -- Remove from nodes
    table.remove(Nodes, idx)

    -- Does the node tick?
    if (SE.NodeHandlers.GetNodeHandler(node).NeedsTicks) then
      -- Remove from ticking
      TickingNodes[node] = nil
    end
  end

  -- Returns the network with the specified ID
  function NetworksManager.GetNetwork(ID)
    return Networks[ID]
  end

  -- Returns the network the node is on, or nil
  function NetworksManager.GetNetworkForNode(node, wireType)
    return Networks[node.Networks[wireType]]
  end

  -- Add a node, if it is not already present
  function NetworksManager.AddNode(node)
    if (GetNodeIndex(node) == 0) then
      -- Add to nodes
      Nodes[#Nodes + 1] = node

      -- Does the node tick?
      local handler = SE.NodeHandlers.GetNodeHandler(node)
      if (handler.NeedsTicks) then
        -- Add to ticking
        TickingNodes[node] = handler
      end

    --SE.Logger.Trace("Networks: Added node")
    end
  end

  -- Removes a node from its network(s)
  -- This will remove all references to the node, and should
  -- only be called when the entity is being removed
  function NetworksManager.RemoveNode(node)
    local idx = GetNodeIndex(node)
    if (idx > 0) then
      RemoveNodeByIndex(idx)
    end
  end

  -- Finds the node for the given entity and removes it.
  function NetworksManager.RemoveNodeByEntity(entity)
    for idx = 1, #Nodes do
      if (Nodes[idx].Entity == entity) then
        RemoveNodeByIndex(idx)
        break
      end
    end
  end

  -- NetworkNode GetNodeForEntity(entity)
  -- Returns the node for the given entity, or nil
  function NetworksManager.GetNodeForEntity(entity)
    for idx = 1, #Nodes do
      if (Nodes[idx].Entity == entity) then
        return Nodes[idx]
      end
    end
    return nil
  end

  -- Ticks all nodes, and periodically ticks each network
  function NetworksManager.Tick()
    -- Tick networks
    for _, network in pairs(Networks) do
      SE.NetworkHandler.Tick(network)
    end

    -- Tick nodes
    for node, handler in pairs(TickingNodes) do
      if (handler.Valid(node)) then
        handler.OnTick(node)
      end
    end

    -- Network tick?
    if (math.fmod(game.tick, SE.Settings.TickRate) == 0) then
      -- Validate all nodes and connections
      local node = nil
      local idx = 1
      while (idx <= #Nodes) do
        node = Nodes[idx]
        -- Is the node still valid?
        if (SE.NodeHandlers.GetNodeHandler(node).Valid(node)) then
          -- Validate connections
          ValidateConnection(node, defines.wire_type.green)
          ValidateConnection(node, defines.wire_type.red)

          -- Increment loop variable
          idx = idx + 1
        else
          -- Node is no longer valid, remove it, and do not increment loop varaiable
          --SE.Logger.Trace("Networks: Removing invalid node")
          --SE.Logger.Trace(serpent.block(node))
          RemoveNodeByIndex(idx)
        end
      end

      -- Validate and tick all networks
      for circuitNetworkID, network in pairs(Networks) do
        if (SE.NetworkHandler.Empty(network)) then
          --SE.Logger.Trace("Removing empty network " .. tostring(circuitNetworkID))
          Networks[circuitNetworkID] = nil
        else
          --SE.Logger.Trace("Ticking Network " .. tostring(circuitNetworkID))
          SE.NetworkHandler.NetworkTick(network)
        end
      end
    end -- End network tick
  end

  -- Called during the mods OnInit phase
  function NetworksManager.OnInit()
    Nodes = SE.DataStore.Nodes
  end

  -- Called during the mods OnLoad phase
  function NetworksManager.OnLoad()
    NetworksManager.OnInit()
  end

  -- Called when the first tick of a new/loaded game happens.
  -- Re-establishes all networks
  function NetworksManager.FirstTick()
    -- Recreate all networks
    local network = nil
    local node = nil
    for idx = 1, #Nodes do
      node = Nodes[idx]

      -- Get the handler
      local handler = SE.NodeHandlers.GetNodeHandler(node)

      -- Ensure the nodes structure is valid
      handler.EnsureStructure(node)

      ValidateConnection(node, defines.wire_type.green)
      ValidateConnection(node, defines.wire_type.red)

      -- Is there a green network?
      network = NetworksManager.GetNetworkForNode(node, defines.wire_type.green)
      if (network ~= nil) then
        -- Add the node
        SE.NetworkHandler.AddNode(network, node, false)
      end

      -- Is there a red network?
      network = NetworksManager.GetNetworkForNode(node, defines.wire_type.red)
      if (network ~= nil) then
        -- Add the node
        SE.NetworkHandler.AddNode(network, node, false)
      end

      -- Does the node tick?
      if (handler.NeedsTicks) then
        -- Add to ticking
        TickingNodes[node] = handler
      end
    end
  end

  return NetworksManager
end
