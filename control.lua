-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/17/2017
-- Description: Execution entrypoint for the mod
-- The SE variable contains references to all instances used by the mod
-- Very few things live in the lua global table, and only nodes live in the factorio global table

-- Create the instance container
SE = {
  -- Map<ItemName :: string -> MaxStackSize :: int>
  StackSizeCache = {}
}

function SE.CachePrototypes()
  -- Get item stack sizes
  for name, proto in pairs(game.item_prototypes) do
    SE.StackSizeCache[name] = proto.stack_size
  end
end

-- Define Mod --
-- This section defines and loads all tables used by the mod

-- Create constants
SE.Constants = (require "SEConstants")()

-- Get settings
SE.Settings = (require "SESettings")()

-- Create the logger
SE.Logger = (require "Utils/Logger")()
-- Log trace messages
SE.Logger.EnableTrace = true
SE.Logger.EnableLogging = true

-- Create the data store
SE.DataStore = (require "SEDataStore")()

-- Create the storage networks manager
SE.Networks = (require "StorageNetwork/NetworksManager")()

-- Create the storage network handler
SE.NetworkHandler = (require "StorageNetwork/NetworkHandler")()

-- Create node handlers
SE.NodeHandlers = (require "StorageNetwork/HandlerRegistry")()
local BaseHandler = (require "StorageNetwork/NodeHandlers/BaseNode")()
SE.NodeHandlers.AddHandler(BaseHandler)
SE.NodeHandlers.AddHandler((require "StorageNetwork/NodeHandlers/ControllerNode")(BaseHandler))
SE.NodeHandlers.AddHandler((require "StorageNetwork/NodeHandlers/EnergyAcceptorNode")(BaseHandler))
SE.NodeHandlers.AddHandler((require "StorageNetwork/NodeHandlers/InterfaceNode")(BaseHandler))
SE.NodeHandlers.AddHandler((require "StorageNetwork/NodeHandlers/StorageNode")(BaseHandler))

-- Link node handlers with entities
local protoNames = SE.Constants.Names.Proto
local handlerNames = SE.Constants.Names.NodeHandlers
SE.NodeHandlers.AddEntityHandler(protoNames.Controller.Entity, handlerNames.Controller)
SE.NodeHandlers.AddEntityHandler(protoNames.EnergyAcceptor.Entity, handlerNames.EnergyAcceptor)
SE.NodeHandlers.AddEntityHandler(protoNames.StorageChestMk1.Entity, handlerNames.Storage)
SE.NodeHandlers.AddEntityHandler(protoNames.StorageChestMk2.Entity, handlerNames.Storage)
SE.NodeHandlers.AddEntityHandler(protoNames.RequesterChest.Entity, handlerNames.Storage)
SE.NodeHandlers.AddEntityHandler(protoNames.InterfaceChest.Entity, handlerNames.Interface)
SE.NodeHandlers.AddEntityHandler(protoNames.ProviderChest.Entity, handlerNames.Interface)

-- Create the Gui manager
SE.GuiManager = (require "Guis/GuiManager")()

-- Create the game event manager
SE.GameEventHandlers = (require "GameEvents/GameEventHandlers")()

-- Register for events
SE.GameEventHandlers.RegisterHandlers()

-- Add remote interface
remote.add_interface(
  "StorageEnergistics",
  {
    -- Returns full the StorageEnergistics instance
    Instance = function()
      return SE
    end,
    -- Gets a node handler by name
    GetNodeHandlerByName = function(name)
      return SE.NodeHandlers.GetHandler(name)
    end,
    -- Gets a nodes handler
    GetNodeHandlerByNode = function(node)
      return SE.NodeHandlers.GetNodeHandler(node)
    end,
    -- Gets a node handler by entity
    GetNodeHandlerByEntity = function(entity)
      return SE.NodeHandlers.GetEntityHandler(entity)
    end,
    GetBaseNodeHandler = function()
      return BaseHandler
    end,
    -- Adds a node handler
    AddNodeHandler = function(handler)
      SE.NodeHandlers.AddHandler(handler)
    end,
    -- Maps an entity to a handler via their names
    MapEntityToHandler = function(entityName, handlerName)
      SE.NodeHandlers.AddEntityHandler(entityName, handlerName)
    end
  }
)
