-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-10-26
-- Description: Energy Acceptor node

return function(BaseHandler)
  local EnergyAcceptorNodeHandler = {
    HandlerName = SE.Constants.Names.NodeHandlers.EnergyAcceptor,
    Type = SE.Constants.NodeTypes.PowerSource,
    NeedsTicks = true
  }
  setmetatable(EnergyAcceptorNodeHandler, {__index = BaseHandler})

  function EnergyAcceptorNodeHandler:GetCircuitNetwork(wireType)
    if (EnergyAcceptorNodeHandler.Valid(self)) then
      return self.Entity.get_circuit_network(wireType, defines.circuit_connector_id.accumulator)
    end
    return nil
  end

  -- ExtractPower( Self, uint ) :: uint
  -- Called when the network needs power, and ProvidesPower is true.
  -- Return amount of power extracted.
  function EnergyAcceptorNodeHandler:ExtractPower(watts)
    if (self.HiddenElectricEntity ~= nil and self.HiddenElectricEntity.valid) then
      local stored = self.HiddenElectricEntity.energy

      -- Optimistically assume there is enough
      local extracted = watts

      -- If there is not enough
      if (stored < watts) then
        -- Take everything available
        extracted = stored
      end

      -- Remove from buffer
      self.HiddenElectricEntity.energy = stored - extracted

      return extracted
    end
    return 0
  end

  -- StoredPower( Self ) : uint
  -- Called to determine amount of power stored in the node.
  -- Return amount of power stored.
  function EnergyAcceptorNodeHandler:StoredPower()
    if (self.HiddenElectricEntity ~= nil and self.HiddenElectricEntity.valid) then
      return self.HiddenElectricEntity.energy
    else
      return 0
    end
  end

  function EnergyAcceptorNodeHandler:OnTick()
    -- Tick!
    self.TicksTillUpdate = self.TicksTillUpdate - 1

    -- Time to update?
    if (self.TicksTillUpdate < 1) then
      if (self.HiddenElectricEntity ~= nil and self.HiddenElectricEntity.valid) then
        -- Get hidden energy
        local hEng = self.HiddenElectricEntity.energy
        if (hEng ~= self.Entity.energy) then
          -- Set actual energy
          self.Entity.energy = hEng
          -- 1/4th second
          self.TickRate = 15
        else
          -- 1 second
          self.TickRate = 60
        end
      else
        -- Continuiously slow ticks while has invalid entity
        self.TickRate = self.TickRate + 1
      end

      self.TicksTillUpdate = self.TickRate
    end
  end

  function EnergyAcceptorNodeHandler:OnDestroy()
    if (self.HiddenElectricEntity ~= nil) then
      self.HiddenElectricEntity.destroy()
    end
  end

  -- @See BaseNode.NewNode
  function EnergyAcceptorNodeHandler.NewNode(entity)
    -- Create the hidden entity
    local hiddenPowerInterface =
      entity.surface.create_entity(
      {
        name = "hidden_" .. SE.Constants.Names.Proto.EnergyAcceptor.Entity,
        position = entity.position,
        force = entity.force
      }
    )
    local node = BaseHandler.NewNode(entity)
    node.HiddenElectricEntity = hiddenPowerInterface
    EnergyAcceptorNodeHandler.EnsureStructure(node)
    return node
  end

  -- @See BaseNode:EnsureStructure
  function EnergyAcceptorNodeHandler:EnsureStructure()
    BaseHandler.EnsureStructure(self)
    self.HandlerName = EnergyAcceptorNodeHandler.HandlerName
    self.HiddenElectricEntity = self.HiddenElectricEntity or nil
    self.TicksTillUpdate = 5
    self.TickRate = 30
    return self
  end

  return EnergyAcceptorNodeHandler
end
