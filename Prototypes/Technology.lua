-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 11/12/2017
-- Description: Defines SE research

data:extend(
  {
    -- Storage Network
    {
      type = "technology",
      name = SEConstants.Names.Tech.StorageNetwork,
      icon = SEConstants.DataPaths.TechGFX .. "Storage-Network.png",
      icon_size = 128,
      prerequisites = {"advanced-electronics-2", "battery"},
      effects = {
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.PetroQuartz.Recipe
        },
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.PhaseCoil.Recipe
        },
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.Controller.Recipe
        },
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.EnergyAcceptor.Recipe
        },
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.StorageChestMk1.Recipe
        },
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.InterfaceChest.Recipe
        }
      },
      unit = {
        count = 300,
        ingredients = {
          {"science-pack-1", 1},
          {"science-pack-2", 1},
          {"science-pack-3", 1},
          {"production-science-pack", 1},
          {"high-tech-science-pack", 2}
        },
        time = 30
      },
      order = "a-a"
    },
    -- High capacity storage
    {
      type = "technology",
      name = SEConstants.Names.Tech.HighCapacity,
      icon = SEConstants.DataPaths.TechGFX .. "High-Capacity.png",
      icon_size = 128,
      prerequisites = {SEConstants.Names.Tech.StorageNetwork},
      effects = {
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.PatternBuffer.Recipe
        },
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.StorageChestMk2.Recipe
        },
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.StorageChestMk1.Recipe .. "_upgrade"
        }
      },
      unit = {
        count = 30,
        ingredients = {
          {"science-pack-1", 1},
          {"science-pack-2", 1},
          {"science-pack-3", 1},
          {"high-tech-science-pack", 2}
        },
        time = 150
      },
      order = "a-b"
    },
    -- Storage Logistics
    {
      type = "technology",
      name = SEConstants.Names.Tech.Logistics,
      icon = SEConstants.DataPaths.TechGFX .. "Storage-Logistics.png",
      icon_size = 128,
      prerequisites = {SEConstants.Names.Tech.StorageNetwork, "logistic-system"},
      effects = {
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.ProviderChest.Recipe
        },
        {
          type = "unlock-recipe",
          recipe = SEConstants.Names.Proto.RequesterChest.Recipe
        }
      },
      unit = {
        count = 40,
        ingredients = {
          {"science-pack-1", 4},
          {"science-pack-2", 4},
          {"science-pack-3", 4},
          {"high-tech-science-pack", 1}
        },
        time = 60
      },
      order = "a-c"
    }
  }
)
