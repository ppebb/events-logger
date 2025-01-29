---Get an array of keys from a table.
---@param tab table - Table to get keys from.
---@return table - Array of keys.
---@usage local keys = get_keys({["a"] = 1, ["b"] = 2, ["c"] = 3}) -- keys = {"a", "b", "c"}
function keys(var)
    local keyset={}
    local n=0

    for k, _ in pairs(var) do
        n=n+1
        keyset[n]=k
    end
    return keyset
end

---Check if Array has value.
---@param tab table - Table to check.
---@param val string - Value to check for.
---@return boolean - True if value is present, false if value is missing.
function has_value (tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

---Write JSONified table to `game-events.json`.
---@param game_event table - Table to write to file.
function write_game_event_json(game_event)
    if settings.global["event-logger-enable-json-logging"].value then
        helpers.write_file("game-events.json", helpers.table_to_json(game_event) .. "\n", true)
    end
end

---Write Event to Factorio log.
---@param event_name string - Name of the event.
---@param message string - Message to log.
function factorio_log(event_name, message)
    if settings.global["event-logger-enable-factorio-logging"].value then
        log("[" .. event_name .. "] " .. message)
    end
end