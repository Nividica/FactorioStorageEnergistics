-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/20/2017
-- Description: Defines constants used throughout SE

return function()
  -- What things are called
  local Names = {}

  -- Where things are at
  local Paths = {}

  -- Kinds of nodes
  local NodeTypes = {}

  -- Misc strings
  local Strings = {}

  ---- Strings
  Strings.SEID = "Storage-Energistics"
  Strings.SEIGroup = Strings.SEID .. "-Logistics"
  Strings.TotalSlots = "__totalslots__"
  Strings.FreeSlots = "__freeslots__"

  ---- Paths
  Paths.Base = "__storage_energistics__/"
  Paths.GFX = Paths.Base .. "Graphics/"
  Paths.Icons = Paths.GFX .. "Icons/"
  Paths.EntityGFX = Paths.GFX .. "Entity/"
  Paths.TechGFX = Paths.GFX .. "Technology/"

  ---- Names
  local function GenNames(name, hasEntity)
    local names = {
      ID = name,
      Item = "item_" .. name,
      Recipe = "recipe_" .. name
    }
    if (hasEntity) then
      names.Entity = "entity_" .. name
    end
    return names
  end

  -- Prototype names
  Names.Proto = {}

  Names.Proto.PetroQuartz = GenNames("se_petroleum_quartz", false)
  Names.Proto.PhaseCoil = GenNames("se_phase_transition_coil", false)
  Names.Proto.Controller = GenNames("se_controller", true)
  Names.Proto.EnergyAcceptor = GenNames("se_energy_acceptor", true)
  Names.Proto.StorageChestMk1 = GenNames("se_chest_mk1", true)
  Names.Proto.InterfaceChest = GenNames("se_interface_chest", true)

  Names.Proto.PatternBuffer = GenNames("se_pattern_buffer", false)
  Names.Proto.StorageChestMk2 = GenNames("se_chest_mk2", true)

  Names.Proto.ProviderChest = GenNames("se_provider_chest", true)
  Names.Proto.RequesterChest = GenNames("se_requester_chest", true)

  -- Technology names
  Names.Tech = {}
  Names.Tech.StorageNetwork = "research_se_storage_network"
  Names.Tech.HighCapacity = "research_se_high_capacity"
  Names.Tech.Logistics = "research_se_storage_logistics"

  -- Handlers
  Names.NodeHandlers = {
    Base = "BaseNodeHandler",
    Controller = "ControllerNodeHandler",
    EnergyAcceptor = "EnergyAcceptorNodeHandler",
    Storage = "StorageNodeHandler",
    Interface = "InterfaceNodeHandler"
  }

  -- Gui Names
  Names.Gui = {
    InterfaceFrame = "se_gui_interface_frame",
    InterfaceFrameRoot = "left",
    InterfaceItemSelectionElement = "se_pick_item:",
    StorageChestFrame = "se_gui_chest_frame",
    StorageChestFrameRoot = "left",
    StorageChestReadOnlyCheckbox = "se_mode_readonly",
    ControllerFrame = "se_gui_controller",
    ControllerFrameRoot = "left"
  }

  -- Control Names
  Names.Controls = {
    StorageNetworkGui = "toggle-storage-network-gui"
  }

  -- Node types
  -- Device: Devices that utilize network functionality but does not fall into other categories.
  NodeTypes.Device = 0
  -- Controller: Directs network traffic. Minimum 1 required for every network for nodes to communicate.
  NodeTypes.Controller = 1
  -- PowerSource: Provides power to the network
  NodeTypes.PowerSource = 2
  -- Storage: Stores items
  NodeTypes.Storage = 4

  SEConstants = {
    Names = Names,
    Strings = Strings,
    DataPaths = Paths,
    NodeTypes = NodeTypes
  }
  return SEConstants
end
