-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/29/2017
-- Description: Gameplay settings

data:extend(
  {
    -- Global
    {
      type = "int-setting",
      name = "storage_energistics-power_drain-per_node-per_tick-in_watts",
      setting_type = "runtime-global",
      default_value = 15,
      minimum_value = 1,
      order = "a-a"
    },
    {
      type = "int-setting",
      name = "storage_energistics-transfer_power_drain-per_item-in_watts",
      setting_type = "runtime-global",
      default_value = 2000,
      minimum_value = 1,
      order = "a-b"
    },
    {
      type = "int-setting",
      name = "storage_energistics-transfer_power_drain-per_chunk-in_watts",
      setting_type = "runtime-global",
      default_value = 300,
      minimum_value = 1,
      order = "a-c"
    },
    {
      type = "int-setting",
      name = "storage_energistics-game_ticks-per-network_tick",
      setting_type = "runtime-global",
      default_value = 30,
      minimum_value = 1,
      order = "a-d"
    }
  }
)
