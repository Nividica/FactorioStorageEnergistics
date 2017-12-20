-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-10-26
-- Description: Energy Acceptor node

return function(BaseHandler)
  local EnergyAcceptorNodeHandler = {
    HandlerName = SE.Constants.Names.NodeHandlers.EnergyAcceptor,
    Type = SE.Constants.NodeTypes.PowerSource
  }
  setmetatable(EnergyAcceptorNodeHandler, {__index = BaseHandler})

  -- ExtractPower( Self, uint ) :: uint
  -- Called when the network needs power, and ProvidesPower is true.
  -- Return amount of power extracted.
  function EnergyAcceptorNodeHandler:ExtractPower(watts)
    local stored = self.Entity.energy

    -- Optimistically assume there is enough
    local extracted = watts

    -- If there is not enough
    if (stored < watts) then
      -- Take everything available
      extracted = stored
    end

    -- Remove from buffer
    self.Entity.energy = stored - extracted

    return extracted
  end

  -- StoredPower( Self ) : uint
  -- Called to determine amount of power stored in the node.
  -- Return amount of power stored.
  function EnergyAcceptorNodeHandler:StoredPower()
    return self.Entity.energy
  end

  -- @See BaseNode.NewNode
  function EnergyAcceptorNodeHandler.NewNode(entity)
    return EnergyAcceptorNodeHandler.EnsureStructure(BaseHandler.NewNode(entity))
  end

  -- @See BaseNode:EnsureStructure
  function EnergyAcceptorNodeHandler:EnsureStructure()
    BaseHandler.EnsureStructure(self)
    self.HandlerName = EnergyAcceptorNodeHandler.HandlerName
    return self
  end

  return EnergyAcceptorNodeHandler
end
