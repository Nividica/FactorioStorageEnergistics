data:extend {
    -- Group SE
    {
        type = "item-group",
        name = Constants.Strings.ItemGroups.StorageEnergistics.Name,
        order = "se",
        inventory_order = "se",
        icon = Constants.DataPaths.TechGFX .. "high-capacity.png",
        icon_size = 128
    },
    -- Buildings
    {
        type = "item-subgroup",
        name = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Buildings,
        group = Constants.Strings.ItemGroups.StorageEnergistics.Name,
        order = "a"
    },
    -- Items
    {
        type = "item-subgroup",
        name = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Items,
        group = Constants.Strings.ItemGroups.StorageEnergistics.Name,
        order = "b"
    }
}