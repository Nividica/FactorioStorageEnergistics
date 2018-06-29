-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-10-17
-- Description: Defines the event handlers for when event effects entities

-- Constructs and returns the EntityHandlers object
return function()
  local CreationHandlers = {}
  local DestructionHandlers = {}
  local EntityHandlers = {
    Creation = CreationHandlers,
    Destruction = DestructionHandlers
  }

  -- OnEntityBuilt( LuaEntity ) :: void
  -- Called by when either a player or bot builds an entity
  function CreationHandlers.OnEntityBuilt(entity)
    local handler = SE.NodeHandlers.GetEntityHandler(entity)
    if (handler ~= nil) then
      --SE.Logger.Trace("Entity Handler: Adding network node " .. handler.HandlerName)
      SE.Networks.AddNode(handler.NewNode(entity))
    end
  end

  -- OnBuiltByPlayer( Event ) :: void
  -- Called when player builds something.
  -- Event fields:
  -- - created_entity :: LuaEntity
  -- - player_index :: uint
  -- - item :: string (optional)
  -- - tags :: dictionary string -> Any (optional)
  function CreationHandlers.OnBuiltByPlayer(event)
    CreationHandlers.OnEntityBuilt(event.created_entity)
  end

  -- OnBuiltByBot( Event ) :: void
  -- Called when a construction robot builds an entity.
  -- Event fields:
  -- - robot :: LuaEntity
  -- - created_entity :: LuaEntity
  -- - item :: string (optional)
  -- - tags :: dictionary string -> Any (optional)
  function CreationHandlers.OnBuiltByBot(event)
    CreationHandlers.OnEntityBuilt(event.created_entity)
  end

  -- -- OnUnMarked( Event ) :: void
  -- -- Called when the deconstruction of an entity is canceled.
  -- -- Event fields:
  -- -- - entity :: LuaEntity
  -- -- - player_index :: uint (optional)
  -- function CreationHandlers.OnUnMarked(event)
  --   CreationHandlers.OnEntityBuilt(event.entity)
  -- end

  -- OnEntityRemoved( LuaEntity, LuaInventory ) :: void
  -- Called when an entity is removed from the game
  function DestructionHandlers.OnEntityRemoved(entity, bufferInventory)
    local handler = SE.NodeHandlers.GetEntityHandler(entity)
    if (handler ~= nil) then
      SE.Networks.OnNodeEntityMined(entity, bufferInventory)
    end
  end

  -- OnPreMined( NodeHandler, LuaEntity, LuaEntity )
  function DestructionHandlers.OnPreMined(handler, entity, miner)
    -- Get the node
    local node = SE.Networks.GetNodeForEntity(entity)
    if (node ~= nil) then
      -- Call premined
      handler.OnPreMined(node, miner)
    end
  end

  -- Called when the player finishes mining an entity, before the entity is removed from map.
  -- Event fields:
  -- - entity :: LuaEntity: The entity being mined
  -- - player_index :: uint
  function DestructionHandlers.OnPreMinedByPlayer(event)
    local entity = event.entity
    local handler = SE.NodeHandlers.GetEntityHandler(entity)
    if (handler ~= nil) then
      DestructionHandlers.OnPreMined(handler, entity, game.players[event.player_index])
    end
  end

  -- Called before a robot mines an entity.
  -- Event fields:
  -- - robot :: LuaEntity: The robot that's about to do the mining.
  -- - entity :: LuaEntity: The entity which is about to be mined.
  function DestructionHandlers.OnPreMinedByBot(event)
    local entity = event.entity
    local handler = SE.NodeHandlers.GetEntityHandler(entity)
    if (handler ~= nil) then
      DestructionHandlers.OnPreMined(handler, entity, event.robot)
    end
  end

  -- OnMinedByPlayer( Event ) :: void
  -- Called after the results of an entity being mined are collected just before the entity is destroyed. After this event any items in the buffer will be transferred into the player as if they came from mining the entity.
  -- Event fields:
  -- - player_index :: uint
  -- - entity :: LuaEntity
  -- - buffer :: LuaInventory: The temporary inventory that holds the result of mining the entity.
  -- Note: The buffer inventory is special in that it's only valid during this event and has a dynamic size expanding as more items are transferred into it.
  function DestructionHandlers.OnMinedByPlayer(event)
    DestructionHandlers.OnEntityRemoved(event.entity, event.buffer)
  end

  -- OnMinedByBot( Event ) :: void
  -- Called after the results of an entity being mined are collected just before the entity is destroyed. After this event any items in the buffer will be transferred into the robot as if they came from mining the entity.
  -- Event fields:
  -- - robot :: LuaEntity
  -- - entity :: LuaEntity
  -- - buffer :: LuaInventory: The temporary inventory that holds the result of mining the entity.
  -- Note: The buffer inventory is special in that it's only valid during this event and has a dynamic size expanding as more items are transferred into it.
  function DestructionHandlers.OnMinedByBot(event)
    DestructionHandlers.OnEntityRemoved(event.entity, event.buffer)
  end

  -- OnKilled( Event )
  -- Called when an entity dies.
  -- Event fields:
  -- - entity :: LuaEntity
  -- - cause :: LuaEntity (optional)
  -- - force :: LuaForce (optional)
  function DestructionHandlers.OnKilled(event)
    DestructionHandlers.OnEntityRemoved(event.entity, nil)
  end

  local thingy = function()
  end

  -- Todo: Add inactive/marked flag on the node in the networks manager?
  -- -- OnMarked( Event ) :: void
  -- -- Called when an entity is marked for deconstruction with the Deconstruction planner or via script.
  -- -- Event fields:
  -- -- - entity :: LuaEntity
  -- -- - player_index :: uint (optional)
  -- function DestructionHandlers.OnMarked(event)
  --   DestructionHandlers.OnEntityRemoved(event.entity)
  -- end

  -- OnPasteSettings( Event )
  -- Called after entity copy-paste is done.
  -- Event fields:
  -- - player_index :: uint
  -- - source :: LuaEntity: The source entity settings have been copied from.
  -- - destination :: LuaEntity: The destination entity settings have been copied to.
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

  -- RegisterWithGame() :: void
  -- Registers event listeners with the game.
  function EntityHandlers.RegisterWithGame()
    script.on_event(defines.events.on_entity_settings_pasted, EntityHandlers.OnPasteSettings)
    -- Creation
    script.on_event(defines.events.on_built_entity, EntityHandlers.Creation.OnBuiltByPlayer)
    script.on_event(defines.events.on_robot_built_entity, EntityHandlers.Creation.OnBuiltByBot)
    --script.on_event(defines.events.on_canceled_deconstruction, EntityHandlers.Creation.OnUnMarked)

    -- Destruction
    --script.on_event(defines.events.on_marked_for_deconstruction, EntityHandlers.Destruction.OnMarked)
    script.on_event(defines.events.on_player_mined_entity, EntityHandlers.Destruction.OnMinedByPlayer)
    script.on_event(defines.events.on_entity_died, EntityHandlers.Destruction.OnKilled)
    script.on_event(defines.events.on_pre_player_mined_item, EntityHandlers.Destruction.OnPreMinedByPlayer)
    script.on_event(defines.events.on_robot_pre_mined, EntityHandlers.Destruction.OnPreMinedByBot)
  end

  return EntityHandlers
end
