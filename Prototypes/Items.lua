-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/20/2017
-- Description: Defines SE items

require "SEConstants"

data:extend(
  {
    {
      type = "item-subgroup",
      name = SEConstants.Strings.SEIGroup,
      group = "logistics",
      order = "g"
    },
    -- Controller
    {
      type = "item",
      name = SEConstants.Names.Proto.Controller.Item,
      icon = SEConstants.DataPaths.Icons .. "SE_Controller.png",
      icon_size = 32,
      flags = {"goes-to-quickbar"},
      subgroup = SEConstants.Strings.SEIGroup,
      order = "a-a",
      place_result = SEConstants.Names.Proto.Controller.Entity,
      stack_size = 50
    },
    -- Energy Acceptor
    {
      type = "item",
      name = SEConstants.Names.Proto.EnergyAcceptor.Item,
      icon = SEConstants.DataPaths.Icons .. "SE_EnergyAcceptor.png",
      icon_size = 32,
      flags = {"goes-to-quickbar"},
      subgroup = "energy",
      order = "e-b",
      place_result = SEConstants.Names.Proto.EnergyAcceptor.Entity,
      stack_size = 50
    },
    -- Chest Mk1
    {
      type = "item",
      name = SEConstants.Names.Proto.StorageChestMk1.Item,
      icon = SEConstants.DataPaths.EntityGFX .. "SE_ChestMk1.png",
      icon_size = 32,
      flags = {"goes-to-quickbar"},
      subgroup = SEConstants.Strings.SEIGroup,
      order = "b-a-a",
      place_result = SEConstants.Names.Proto.StorageChestMk1.Entity,
      stack_size = 50
    },
    -- Chest Mk2
    {
      type = "item",
      name = SEConstants.Names.Proto.StorageChestMk2.Item,
      icon = SEConstants.DataPaths.EntityGFX .. "SE_ChestMk2.png",
      icon_size = 32,
      flags = {"goes-to-quickbar"},
      subgroup = SEConstants.Strings.SEIGroup,
      order = "b-a-c",
      place_result = SEConstants.Names.Proto.StorageChestMk2.Entity,
      stack_size = 50
    },
    -- Interface Chest
    {
      type = "item",
      name = SEConstants.Names.Proto.InterfaceChest.Item,
      icon = SEConstants.DataPaths.EntityGFX .. "SE_InterfaceChest.png",
      icon_size = 32,
      flags = {"goes-to-quickbar"},
      subgroup = SEConstants.Strings.SEIGroup,
      order = "b-b",
      place_result = SEConstants.Names.Proto.InterfaceChest.Entity,
      stack_size = 50
    },
    -- Provider Chest
    {
      type = "item",
      name = SEConstants.Names.Proto.ProviderChest.Item,
      icon = SEConstants.DataPaths.EntityGFX .. "SE_ProviderChest.png",
      icon_size = 32,
      flags = {"goes-to-quickbar"},
      subgroup = SEConstants.Strings.SEIGroup,
      order = "b-c",
      place_result = SEConstants.Names.Proto.ProviderChest.Entity,
      stack_size = 50
    },
    -- Requester Chest
    {
      type = "item",
      name = SEConstants.Names.Proto.RequesterChest.Item,
      icon = SEConstants.DataPaths.EntityGFX .. "SE_RequesterChest.png",
      icon_size = 32,
      flags = {"goes-to-quickbar"},
      subgroup = SEConstants.Strings.SEIGroup,
      order = "b-d",
      place_result = SEConstants.Names.Proto.RequesterChest.Entity,
      stack_size = 50
    },
    -- Petro Quartz
    {
      type = "item",
      name = SEConstants.Names.Proto.PetroQuartz.Item,
      icon = SEConstants.DataPaths.Icons .. "SE_Petroleum_Quartz.png",
      icon_size = 32,
      flags = {},
      subgroup = "raw-material",
      order = "g-a",
      stack_size = 100
    },
    -- Phase Transition Coil
    {
      type = "item",
      name = SEConstants.Names.Proto.PhaseCoil.Item,
      icon = SEConstants.DataPaths.Icons .. "SE_PhaseTransitionCoil.png",
      icon_size = 32,
      flags = {},
      subgroup = "intermediate-product",
      order = "h-a",
      stack_size = 50
    },
    -- Pattern Buffer
    {
      type = "item",
      name = SEConstants.Names.Proto.PatternBuffer.Item,
      icon = SEConstants.DataPaths.Icons .. "SE_Pattern_Buffer.png",
      icon_size = 32,
      flags = {},
      subgroup = "intermediate-product",
      order = "h-b",
      stack_size = 16
    }
  }
)
