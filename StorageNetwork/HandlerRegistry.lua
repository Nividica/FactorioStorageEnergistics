-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 11/01/2017
-- Description: Registry for handlers. Provides mapping from handler names, and entity names to handlers

return function()
  local NodeHandlers = {}
  -- Map( HandlerName -> Handler )
  local Handlers = {}

  -- Map( EntityName - > HandlerName )
  local EntityToHandlerMap = {}

  -- Adds a node handler
  function NodeHandlers.AddHandler(handler)
    Handlers[handler.HandlerName] = handler
  end

  -- Gets a node handler by name
  function NodeHandlers.GetHandler(name)
    return Handlers[name]
  end

  -- Gets the handler for the given node
  function NodeHandlers.GetNodeHandler(node)
    if (node == nil) then
      error("GetNodeHandler: Expected node, got nil")
    end
    if (node.HandlerName == nil) then
      error("GetNodeHandler: Malformed node, missing HandlerName.\nNode:" .. serpent.block(node))
    end
    return Handlers[node.HandlerName]
  end

  -- Get the handler for the given entity
  function NodeHandlers.GetEntityHandler(entity)
    local handlerName = EntityToHandlerMap[entity.name]
    if (handlerName == nil) then
      return nil
    end
    return Handlers[handlerName]
  end

  function NodeHandlers.AddEntityHandler(entityName, handlerName)
    EntityToHandlerMap[entityName] = handlerName
  end

  return NodeHandlers
end
