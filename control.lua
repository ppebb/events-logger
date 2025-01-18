local handler = require("event_handler")
handler.add_lib(require("logger"))
require("el_helpers")

---Function: send_std_log
---Add additional reduction factors to the evolution factor storage table.
---@param console_log table - Event message to log into standard log. Format: {["event"] = "EVENT_NAME", ["message"] = "MESSAGE"}
---@result JSON file - Writes event data to a JSON file.
---Function: send_event
---Add additional reduction factors to the evolution factor storage table.
---@param std_log table - Event message to log into standard log. Format: {["event"] = "EVENT_NAME", ["message"] = "MESSAGE"}
---@result JSON file - WritesEvent Log to `factorio-current.log`
remote.add_interface("events-logger", {
    send_std_log = function(std_log)
        std_json_keys = keys(std_log)
        if not has_value(std_json_keys, "event") then
            error("Console JSON must have event name in the 'event' key. Format: {['event'] = 'EVENT_NAME'}")
        elseif not has_value(std_json_keys, "message") and game.tick then
            error("Console JSON must have a 'message' key, containing the log message for event. Format: {['message'] = 'MESSAGE'}")
        end

        log("[" .. std_log.event .. "]" .. std_log.message)
    end,
    send_event = function(event_log)
        --event_json = {}
        event_json_keys = keys(event_log)
        log("Event JSON: " .. helpers.table_to_json(event_log))
        log("Event JSON Keys: " .. helpers.table_to_json(event_json_keys))
        if not has_value(event_json_keys, "event") then
            error("Event JSON must have event name in the 'event' key. Format: {['event'] = 'EVENT_NAME'}")
        elseif not has_value(event_json_keys, "tick") and game.tick then
            error("Event JSON must have a 'tick' key, containing the current game tick. Format: {['tick'] = game.tick}")
        elseif not has_value(event_json_keys, "data") and game.tick then
            error("Event JSON must have a 'data' key, containing event data in the format: {['key'] = value}")
        end

        helpers.write_file("game-events.json", helpers.table_to_json(event_log) .. "\n", true)
    end
})
