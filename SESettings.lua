-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/29/2017
-- Description: Runtime interface to mod settings

return function()
  SESettings = {
    --settings.global["storage_energistics-power_drain-per_node-per_tick-in_watts"].value,
    NodeIdlePowerDrain = 15,
    --settings.global["storage_energistics-transfer_power_drain-per_item-in_watts"].value
    PowerPerItem = 4570,
    --settings.global["storage_energistics-transfer_power_drain-per_chunk-in_watts"].value
    PowerPerChunk = 300,
    --settings.global["storage_energistics-game_ticks-per-network_tick"].value
    TickRate = 30
  }

  return SESettings
end
