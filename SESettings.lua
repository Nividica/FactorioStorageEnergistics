-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/29/2017
-- Description: Runtime interface to mod settings

return function()
  SESettings = {
    NodeIdlePowerDrain = 15,
    PowerPerItem = 4750,
    PowerPerChunk = 1000,
    TickRate = 30
  }

  -- Called to load or reload the mod settings
  function SESettings.LoadSettings()
    SESettings.NodeIdlePowerDrain = settings.global["storage_energistics-power_drain-per_node-per_tick-in_watts"].value
    SESettings.PowerPerItem = settings.global["storage_energistics-transfer_power_drain-per_item-in_watts"].value
    SESettings.PowerPerChunk = settings.global["storage_energistics-transfer_power_drain-per_chunk-in_watts"].value
    SESettings.TickRate = settings.global["storage_energistics-game_ticks-per-network_tick"].value
  end

  -- Load the settings upon creation
  SESettings.LoadSettings()

  return SESettings
end
