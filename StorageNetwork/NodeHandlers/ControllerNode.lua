-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/26/2017
-- Description: Controller node

return function(BaseHandler)
  local ControllerNode = {
    HandlerName = SE.Constants.Names.NodeHandlers.Controller,
    Type = SE.Constants.NodeTypes.Controller
  }
  setmetatable(ControllerNode, {__index = BaseHandler})

  function ControllerNode.NewNode(entity)
    -- Prevent player interaction with the Controller GUI
    entity.operable = false

    return ControllerNode.EnsureStructure(BaseHandler.NewNode(entity))
  end

  function ControllerNode:EnsureStructure()
    BaseHandler.EnsureStructure(self)
    self.HandlerName = ControllerNode.HandlerName
    return self
  end

  return ControllerNode
end
