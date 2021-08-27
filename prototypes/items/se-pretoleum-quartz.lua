
--- ITEM ---
local sePetroleumQuartzI = {}

sePetroleumQuartzI.type = "item"
sePetroleumQuartzI.name = Constants.Names.Proto.PetroQuartz.Item
sePetroleumQuartzI.icon = Constants.DataPaths.Icons .. "se-petroleum-quartz.png"
sePetroleumQuartzI.icon_size = 32
sePetroleumQuartzI.flags = {}
sePetroleumQuartzI.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Items
sePetroleumQuartzI.order = "a"
sePetroleumQuartzI.stack_size = 100

--- RECIPE ---
local sePetroleumQuartzR = {}

sePetroleumQuartzR.type = "recipe"
sePetroleumQuartzR.name = Constants.Names.Proto.PetroQuartz.Recipe
sePetroleumQuartzR.enabled = false
sePetroleumQuartzR.category = "chemistry"
sePetroleumQuartzR.energy_required = 10
sePetroleumQuartzR.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Items
sePetroleumQuartzR.order = Constants.Names.Proto.PetroQuartz.Recipe
sePetroleumQuartzR.ingredients = {
    { type = "item", name = "stone", amount = 10 },
    {type = "fluid", name = "water", amount = 10},
    {type = "fluid", name = "petroleum-gas", amount = 40}
}
sePetroleumQuartzR.results = { { type = "item", name = Constants.Names.Proto.PetroQuartz.Item, amount = 1 } }
sePetroleumQuartzR.crafting_machine_tint = {
    primary = { r = 0.204, g = 0.553, b = 0.722, a = 0.000 },
    secondary = { r = 0.573, g = 0.839, b = 0.934, a = 0.000 },
    tertiary = { r = 0.204, g = 0.505, b = 0.612, a = 0.000 }
}

--- IMPORT se-petroleum-quartz ---
data:extend { sePetroleumQuartzI }
data:extend { sePetroleumQuartzR }