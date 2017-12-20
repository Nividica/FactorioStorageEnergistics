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

  -- AddHandler( NodeHandler ) :: void
  -- Adds a node handler
  function NodeHandlers.AddHandler(handler)
    Handlers[handler.HandlerName] = handler
  end

  -- GetHandler( string ) :: NodeHandler
  -- Gets a node handler by name
  function NodeHandlers.GetHandler(name)
    return Handlers[name]
  end

  -- GetNodeHandler( Node ) :: NodeHandler
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

  -- GetEntityHandler( LuaEntity ) :: NodeHandler
  -- Get the handler for the given entity
  function NodeHandlers.GetEntityHandler(entity)
    local handlerName = EntityToHandlerMap[entity.name]
    if (handlerName == nil) then
      return nil
    end
    return Handlers[handlerName]
  end

  -- AddEntityHandler( string, string )
  -- Maps an entity(by name) to a node handler(also by name)
  -- Such that the handler for that name, will control the entity for its name
  function NodeHandlers.AddEntityHandler(entityName, handlerName)
    EntityToHandlerMap[entityName] = handlerName
  end

  return NodeHandlers
end
