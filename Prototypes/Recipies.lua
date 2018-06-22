-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/20/2017
-- Description: Defines SE recipes

require "SEConstants"

-- Enable productivity modules on intermediate recipes
local function AllowProductivity(recipeName)
  table.insert(data.raw.module["productivity-module"].limitation, recipeName)
  table.insert(data.raw.module["productivity-module-2"].limitation, recipeName)
  table.insert(data.raw.module["productivity-module-3"].limitation, recipeName)
end
AllowProductivity(SEConstants.Names.Proto.PetroQuartz.Recipe)
AllowProductivity(SEConstants.Names.Proto.PhaseCoil.Recipe)
AllowProductivity(SEConstants.Names.Proto.PatternBuffer.Recipe)

data:extend(
  {
    -- Controller
    {
      type = "recipe",
      name = SEConstants.Names.Proto.Controller.Recipe,
      enabled = false,
      energy_required = 3,
      ingredients = {
        {"copper-cable", 10},
        {"advanced-circuit", 7},
        {SEConstants.Names.Proto.PetroQuartz.Item, 1}
      },
      result = SEConstants.Names.Proto.Controller.Item
    },
    -- Energy Acceptor
    {
      type = "recipe",
      name = SEConstants.Names.Proto.EnergyAcceptor.Recipe,
      enabled = false,
      energy_required = 5,
      ingredients = {
        {"iron-plate", 4},
        {"battery", 5},
        {SEConstants.Names.Proto.PetroQuartz.Item, 5}
      },
      result = SEConstants.Names.Proto.EnergyAcceptor.Item
    },
    -- Chest Mk1
    {
      type = "recipe",
      name = SEConstants.Names.Proto.StorageChestMk1.Recipe,
      enabled = false,
      energy_required = 2,
      ingredients = {
        {"steel-chest", 1},
        {SEConstants.Names.Proto.PhaseCoil.Item, 1}
      },
      result = SEConstants.Names.Proto.StorageChestMk1.Item
    },
    -- Chest Mk2
    {
      type = "recipe",
      name = SEConstants.Names.Proto.StorageChestMk2.Recipe,
      enabled = false,
      energy_required = 6,
      ingredients = {
        {"steel-chest", 1},
        {SEConstants.Names.Proto.PhaseCoil.Item, 1},
        {SEConstants.Names.Proto.PatternBuffer.Item, 1}
      },
      result = SEConstants.Names.Proto.StorageChestMk2.Item
    },
    -- Chest Mk1 Upgrade
    {
      type = "recipe",
      name = SEConstants.Names.Proto.StorageChestMk1.Recipe .. "_upgrade",
      enabled = false,
      energy_required = 2,
      ingredients = {
        {SEConstants.Names.Proto.StorageChestMk1.Item, 1},
        {SEConstants.Names.Proto.PatternBuffer.Item, 1}
      },
      main_product = "",
      icon = SEConstants.DataPaths.Icons .. "SE_ChestMk1_Upgrade.png",
      icon_size = 32,
      results = {
        {type = "item", name = SEConstants.Names.Proto.StorageChestMk2.Item, amount = 1}
      },
      subgroup = SEConstants.Strings.SEIGroup,
      order = "b-a-b"
    },
    -- Interface Chest
    {
      type = "recipe",
      name = SEConstants.Names.Proto.InterfaceChest.Recipe,
      enabled = false,
      energy_required = 4,
      ingredients = {
        {"steel-chest", 1},
        {"advanced-circuit", 1},
        {SEConstants.Names.Proto.PhaseCoil.Item, 1}
      },
      result = SEConstants.Names.Proto.InterfaceChest.Item
    },
    -- Provider Chest
    {
      type = "recipe",
      name = SEConstants.Names.Proto.ProviderChest.Recipe,
      enabled = false,
      energy_required = 3,
      ingredients = {
        {"logistic-chest-passive-provider", 1},
        {SEConstants.Names.Proto.PhaseCoil.Item, 1}
      },
      result = SEConstants.Names.Proto.ProviderChest.Item
    },
    -- Requester Chest
    {
      type = "recipe",
      name = SEConstants.Names.Proto.RequesterChest.Recipe,
      enabled = false,
      energy_required = 3,
      ingredients = {
        {"logistic-chest-requester", 1},
        {SEConstants.Names.Proto.PhaseCoil.Item, 1}
      },
      result = SEConstants.Names.Proto.RequesterChest.Item
    },
    -- Phase Transition Coil
    {
      type = "recipe",
      name = SEConstants.Names.Proto.PhaseCoil.Recipe,
      enabled = false,
      energy_required = 6,
      ingredients = {
        {SEConstants.Names.Proto.PetroQuartz.Item, 3},
        {"iron-plate", 4},
        {"copper-cable", 4},
        {"processing-unit", 1}
      },
      result = SEConstants.Names.Proto.PhaseCoil.Item
    },
    -- Petro Quartz
    {
      type = "recipe",
      name = SEConstants.Names.Proto.PetroQuartz.Recipe,
      category = "chemistry",
      energy_required = 10,
      enabled = false,
      ingredients = {
        {type = "item", name = "stone", amount = 10},
        {type = "fluid", name = "water", amount = 10},
        {type = "fluid", name = "petroleum-gas", amount = 40}
      },
      results = {
        {type = "item", name = SEConstants.Names.Proto.PetroQuartz.Item, amount = 1}
      },
      crafting_machine_tint = {
        primary = {r = 0.204, g = 0.553, b = 0.722, a = 0.000},
        secondary = {r = 0.573, g = 0.839, b = 0.934, a = 0.000},
        tertiary = {r = 0.204, g = 0.505, b = 0.612, a = 0.000}
      }
    },
    -- Pattern Buffer
    {
      type = "recipe",
      name = SEConstants.Names.Proto.PatternBuffer.Recipe,
      enabled = false,
      energy_required = 5,
      ingredients = {
        {SEConstants.Names.Proto.PetroQuartz.Item, 10},
        {"battery", 5},
        {"processing-unit", 1}
      },
      result = SEConstants.Names.Proto.PatternBuffer.Item
    }
  }
)
