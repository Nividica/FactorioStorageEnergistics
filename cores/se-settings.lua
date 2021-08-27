return function()
    SESettings = {
        NodeIdlePowerDrain = 5,
        PowerPerItem = 1000,
        PowerPerChunk = 50,
        TickRate = 30
    }

    -- Called to load or reload the mod settings
    function SESettings.LoadSettings()
        SESettings.NodeIdlePowerDrain = settings.global["storage-energistics-power-drain-per-node-per-tick-in-watts"].value
        SESettings.PowerPerItem = settings.global["storage-energistics-transfer-power-drain-per-item-in-watts"].value
        SESettings.PowerPerChunk = settings.global["storage-energistics-transfer-power-drain-per-chunk-in-watts"].value
        SESettings.TickRate = settings.global["storage-energistics-game-ticks-per-network-tick"].value
    end

    -- Load the settings upon creation
    SESettings.LoadSettings()

    return SESettings
end
