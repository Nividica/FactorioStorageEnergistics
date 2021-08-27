
--------------- technology storage network (base) ---------------
local researchSEStorageNetwork = {}

researchSEStorageNetwork.type = "technology"
researchSEStorageNetwork.name = Constants.Names.Tech.StorageNetwork
researchSEStorageNetwork.icon = Constants.DataPaths.TechGFX .. "storage-network.png"
researchSEStorageNetwork.icon_size = 128
researchSEStorageNetwork.order = "a-a"
researchSEStorageNetwork.prerequisites = {}
researchSEStorageNetwork.effects = {
    { type = "unlock-recipe", recipe = Constants.Names.Proto.PetroQuartz.Recipe },
    { type = "unlock-recipe", recipe = Constants.Names.Proto.PhaseCoil.Recipe },
    { type = "unlock-recipe", recipe = Constants.Names.Proto.Controller.Recipe },
    { type = "unlock-recipe", recipe = Constants.Names.Proto.EnergyAcceptor.Recipe },
    { type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestMk1.Recipe },
    { type = "unlock-recipe", recipe = Constants.Names.Proto.InterfaceChest.Recipe }
}
researchSEStorageNetwork.unit = {
    count = 10,
    ingredients = {
        { "automation-science-pack", 1 }
    },
    time = 30
}

data:extend { researchSEStorageNetwork }

--------------- technology high-capacity ---------------
local researchSEHighCapacity = {}

researchSEHighCapacity.type = "technology"
researchSEHighCapacity.name = Constants.Names.Tech.HighCapacity
researchSEHighCapacity.icon = Constants.DataPaths.TechGFX .. "high-capacity.png"
researchSEHighCapacity.icon_size = 128
researchSEHighCapacity.prerequisites = { Constants.Names.Tech.StorageNetwork }
researchSEHighCapacity.effects = {
    { type = "unlock-recipe", recipe = Constants.Names.Proto.PatternBuffer.Recipe },
    { type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestMk2.Recipe },
    { type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestMk1.Recipe .. "-upgrade" }
}
researchSEHighCapacity.unit = {
    count = 10,
    ingredients = {
        { "automation-science-pack", 1 }
    },
    time = 30
}
researchSEHighCapacity.order = "a-b"

data:extend { researchSEHighCapacity }

--------------- technology storage logistics ---------------
local researchSEStorageLogistics = {}

researchSEStorageLogistics.type = "technology"
researchSEStorageLogistics.name = Constants.Names.Tech.Logistics
researchSEStorageLogistics.icon = Constants.DataPaths.TechGFX .. "storage-logistics.png"
researchSEStorageLogistics.icon_size = 128
researchSEStorageLogistics.prerequisites = { Constants.Names.Tech.StorageNetwork }
researchSEStorageLogistics.effects = {
    { type = "unlock-recipe", recipe = Constants.Names.Proto.ProviderChest.Recipe },
    { type = "unlock-recipe", recipe = Constants.Names.Proto.RequesterChest.Recipe }
}
researchSEStorageLogistics.unit = {
    count = 10,
    ingredients = {
        { "automation-science-pack", 1 }
    },
    time = 30
}

data:extend { researchSEStorageLogistics }


