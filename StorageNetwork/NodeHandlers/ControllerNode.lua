-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-10-26
-- Description: Controller node

return function(BaseHandler)
  local ControllerNode = {
    HandlerName = SE.Constants.Names.NodeHandlers.Controller,
    Type = SE.Constants.NodeTypes.Controller
  }
  setmetatable(ControllerNode, {__index = BaseHandler})

  -- @See BaseNode.NewNode
  function ControllerNode.NewNode(entity)
    -- Prevent player interaction with the Controller GUI
    entity.operable = false

    return ControllerNode.EnsureStructure(BaseHandler.NewNode(entity))
  end

  -- @See BaseNode:EnsureStructure
  function ControllerNode:EnsureStructure()
    BaseHandler.EnsureStructure(self)
    self.HandlerName = ControllerNode.HandlerName
    return self
  end

  return ControllerNode
end
