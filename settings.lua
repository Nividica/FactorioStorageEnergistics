-- Description: Gameplay settings

data:extend(
        {
            -- Global
            {
                type = "int-setting",
                name = "storage-energistics-power-drain-per-node-per-tick-in-watts",
                setting_type = "runtime-global",
                default_value = 5,
                minimum_value = 1,
                order = "a-a"
            },
            {
                type = "int-setting",
                name = "storage-energistics-transfer-power-drain-per-item-in-watts",
                setting_type = "runtime-global",
                default_value = 1000,
                minimum_value = 1,
                order = "a-b"
            },
            {
                type = "int-setting",
                name = "storage-energistics-transfer-power-drain-per-chunk-in-watts",
                setting_type = "runtime-global",
                default_value = 50,
                minimum_value = 1,
                order = "a-c"
            },
            {
                type = "int-setting",
                name = "storage-energistics-game-ticks-per-network-tick",
                setting_type = "runtime-global",
                default_value = 30,
                minimum_value = 1,
                order = "a-d"
            }
        }
)
