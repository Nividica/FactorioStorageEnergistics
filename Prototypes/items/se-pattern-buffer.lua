
--- ITEM ---
local sePatternBufferI = {}

sePatternBufferI.type = "item"
sePatternBufferI.name = Constants.Names.Proto.PatternBuffer.Item
sePatternBufferI.icon = Constants.DataPaths.Icons .. "se-pattern-buffer.png"
sePatternBufferI.icon_size = 32
sePatternBufferI.flags = {}
sePatternBufferI.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Items
sePatternBufferI.order = "b"
sePatternBufferI.stack_size = 16

--- RECIPE ---
local sePatternBufferR = {}

sePatternBufferR.type = "recipe"
sePatternBufferR.name = Constants.Names.Proto.PatternBuffer.Recipe
sePatternBufferR.enabled = false
sePatternBufferR.energy_required = 5
sePatternBufferR.ingredients = {
    { Constants.Names.Proto.PetroQuartz.Item, 10 },
    {"battery", 5},
    { "electronic-circuit", 50 }
}
sePatternBufferR.result = Constants.Names.Proto.PatternBuffer.Item
sePatternBufferR.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Items
sePatternBufferR.order = Constants.Names.Proto.PatternBuffer.Recipe

--- IMPORT se-pattern-buffer ---
data:extend { sePatternBufferI }
data:extend { sePatternBufferR }