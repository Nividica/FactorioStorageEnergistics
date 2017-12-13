-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/26/2017
-- Description: Energy Acceptor node

return function(BaseHandler)
  local EnergyAcceptorNodeHandler = {
    HandlerName = SE.Constants.Names.NodeHandlers.EnergyAcceptor,
    Type = SE.Constants.NodeTypes.PowerSource
  }
  setmetatable(EnergyAcceptorNodeHandler, {__index = BaseHandler})

  -- int ExtractPower(self,watts)
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

  -- int StoredPower(self)
  -- Called to determine amount of power stored in the node.
  -- Return amount of power stored.
  function EnergyAcceptorNodeHandler:StoredPower()
    return self.Entity.energy
  end

  function EnergyAcceptorNodeHandler.NewNode(entity)
    return EnergyAcceptorNodeHandler.EnsureStructure(BaseHandler.NewNode(entity))
  end

  function EnergyAcceptorNodeHandler:EnsureStructure()
    BaseHandler.EnsureStructure(self)
    self.HandlerName = EnergyAcceptorNodeHandler.HandlerName
    return self
  end

  return EnergyAcceptorNodeHandler
end
