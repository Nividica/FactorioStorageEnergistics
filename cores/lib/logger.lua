-- Description: Provides logging for the mod
-- Singleton

-- Define the logger function
-- This will append the message to the log file
-- Use: `serpent.block(table_name)` to log a table.
return function()
    local SELogger = {
        EnableTrace = false,
        EnableLogging = false
    }

    -- Queue is used to hold logged data prior to the game object being available
    -- Each new invocation of the logger will start a new section in the log
    local queued = {
        [1] = ":: Starting Log ::\n"
    }

    -- Creates a new log each time a game starts.
    local appendLog = false

    local function log(level, message)
        if SELogger.EnableLogging == false then
            return
        end

        local tick = -1
        if game ~= nil then
            tick = game.tick
        end

        -- Queue the message
        queued[#queued + 1] = "[" .. tick .. "]" .. "[Storage Energistics]" .. "[" .. level .. "] " .. message .. "\n"
        SELogger.Flush()
    end

    function SELogger.Trace(msg)
        if SELogger.EnableTrace then
            log("TRCE", msg)
        end
    end

    function SELogger.Info(msg)
        log("INFO", msg)
    end

    function SELogger.Warning(msg)
        log("WARN", msg)
    end

    function SELogger.Error(msg)
        log("EROR", msg)
    end

    local FlushRate = 180
    local TickCounter = FlushRate

    -- Flushes the log to disk ASAP
    function SELogger.Flush()
        if (#queued == 0 or SELogger.EnableLogging == false) then
            return
        end
        if (game == nil) then
            TickCounter = 0
            return
        end
        -- Log file can be found in the script-output folder
        -- Windows: %appdata%\Factorio\script-output
        game.write_file("logs/storage-energistics.log",
                table.concat(queued),
                appendLog
        )
        queued = {}
        -- Append from now on
        appendLog = true
    end

    function SELogger.Tick()
        if TickCounter > 0 then
            TickCounter = TickCounter - 1
            return
        end
        TickCounter = FlushRate
        SELogger.Flush()
    end

    return SELogger
end
