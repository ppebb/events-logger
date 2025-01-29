function on_trigger_fired_artillery(event)
    local event_json = {}
    event_json["name"] = event.entity.name
    event_json["event"] = "ARTILLERY"
    event_json["tick"] = event.tick
    event_json["message"] = (event.source.name or "no source")
    write_game_event_json(event_json)
    factorio_log(event_json["event"], event_json["name"] .. event_json["message"])
end

events[defines.events.on_trigger_fired_artillery] = on_trigger_fired_artillery