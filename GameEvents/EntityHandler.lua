-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/17/2017
-- Description: Defines the event handlers for when event effects entities

return function()
  local CreationHandlers = {}
  local DestructionHandlers = {}
  local EntityHandlers = {
    Creation = CreationHandlers,
    Destruction = DestructionHandlers
  }

  -- Called by when either a player or bot builds an entity
  function CreationHandlers.OnEntityBuilt(entity)
    local handler = SE.NodeHandlers.GetEntityHandler(entity)
    if (handler ~= nil) then
      --SE.Logger.Trace("Entity Handler: Adding network node " .. handler.HandlerName)
      SE.Networks.AddNode(handler.NewNode(entity))
    end
  end

  -- on_built_entity
  -- Called when player builds something.
  -- created_entity :: LuaEntity
  -- player_index :: uint
  -- item :: string (optional)
  -- tags :: dictionary string → Any (optional)
  function CreationHandlers.OnBuiltByPlayer(event)
    CreationHandlers.OnEntityBuilt(event.created_entity)
  end

  -- on_robot_built_entity
  -- Called when a construction robot builds an entity.
  -- robot :: LuaEntity
  -- created_entity :: LuaEntity
  -- item :: string (optional)
  -- tags :: dictionary string → Any (optional)
  function CreationHandlers.OnBuiltByBot(event)
    CreationHandlers.OnEntityBuilt(event.created_entity)
  end

  -- on_canceled_deconstruction
  -- Called when the deconstruction of an entity is canceled.
  -- entity :: LuaEntity
  -- player_index :: uint (optional)
  function CreationHandlers.OnUnMarked(event)
    CreationHandlers.OnEntityBuilt(event.entity)
  end

  -- Called when an entity is, or will be, removed from the game
  function DestructionHandlers.OnEntityRemoved(entity)
    local handler = SE.NodeHandlers.GetEntityHandler(entity)
    if (handler ~= nil) then
      SE.Networks.RemoveNodeByEntity(entity)
    end
  end

  -- on_player_mined_entity
  -- Called after the results of an entity being mined are collected just before the entity is destroyed. After this event any items in the buffer will be transferred into the player as if they came from mining the entity.
  -- player_index :: uint: The index of the player doing the mining.
  -- entity :: LuaEntity: The entity that has been mined.
  -- buffer :: LuaInventory: The temporary inventory that holds the result of mining the entity.
  -- Note: The buffer inventory is special in that it's only valid during this event and has a dynamic size expanding as more items are transferred into it.
  function DestructionHandlers.OnMinedByPlayer(event)
    DestructionHandlers.OnEntityRemoved(event.entity)
  end

  -- on_robot_mined_entity
  -- Called after the results of an entity being mined are collected just before the entity is destroyed. After this event any items in the buffer will be transferred into the robot as if they came from mining the entity.
  -- robot :: LuaEntity: The robot doing the mining.
  -- entity :: LuaEntity: The entity that has been mined.
  -- buffer :: LuaInventory: The temporary inventory that holds the result of mining the entity.
  -- Note: The buffer inventory is special in that it's only valid during this event and has a dynamic size expanding as more items are transferred into it.
  function DestructionHandlers.OnMinedByBot(event)
    DestructionHandlers.OnEntityRemoved(event.entity)
  end

  -- on_entity_died
  -- Called when an entity dies.
  -- entity :: LuaEntity
  -- cause :: LuaEntity (optional): The entity that did the killing if available.
  -- force :: LuaForce (optional): The force that did the killing if any.
  function DestructionHandlers.OnKilled(event)
    DestructionHandlers.OnEntityRemoved(event.entity)
  end

  -- on_marked_for_deconstruction
  -- Called when an entity is marked for deconstruction with the Deconstruction planner or via script.
  -- entity :: LuaEntity
  -- player_index :: uint (optional)
  function DestructionHandlers.OnMarked(event)
    DestructionHandlers.OnEntityRemoved(event.entity)
  end

  -- on_entity_settings_pasted
  -- Called after entity copy-paste is done.
  -- player_index :: uint
  -- source :: LuaEntity: The source entity settings have been copied from.
  -- destination :: LuaEntity: The destination entity settings have been copied to.
  function EntityHandlers.OnPasteSettings(event)
    local destEntity = event.destination
    local handler = SE.NodeHandlers.GetEntityHandler(destEntity)
    if (handler ~= nil) then
      local destNode = SE.Networks.GetNodeForEntity(destEntity)
      if (destNode ~= nil) then
        handler.OnPasteSettings(destNode, event.source, game.players[event.player_index])
      end
    end
  end

  function EntityHandlers.RegisterWithGame()
    script.on_event(defines.events.on_entity_settings_pasted, EntityHandlers.OnPasteSettings)
    -- Creation
    script.on_event(defines.events.on_built_entity, EntityHandlers.Creation.OnBuiltByPlayer)
    script.on_event(defines.events.on_robot_built_entity, EntityHandlers.Creation.OnBuiltByBot)
    script.on_event(defines.events.on_canceled_deconstruction, EntityHandlers.Creation.OnUnMarked)
    -- Destruction
    script.on_event(defines.events.on_marked_for_deconstruction, EntityHandlers.Destruction.OnMarked)
    script.on_event(defines.events.on_player_mined_entity, EntityHandlers.Destruction.OnMinedByPlayer)
    script.on_event(defines.events.on_entity_died, EntityHandlers.Destruction.OnKilled)
  end

  -- on_entity_renamed
  -- Called after an entity has been renamed either by the player or through script.
  -- player_index :: uint (optional): If by_script is true this will not be included
  -- by_script :: boolean
  -- entity :: LuaEntity
  -- old_name :: string

  return EntityHandlers
end
