function on_post_entity_died(event)
    local event_json = {}
    event_json["name"] = event.name
    event_json["event"] = "POST_DESTROYED"
    event_json["event_name"] = event.name
    event_json["damage_type"] = event.damage_type.name
    if event.quality then
        event_json["quality"] = {}
        event_json["quality"]["name"] = event.quality.name
        event_json["quality"]["type"] = event.quality.type
        event_json["quality"]["color"] = event.quality.color
        event_json["quality"]["level"] = event.quality.level
    end
    if event.force then
        event_json["force"] = {}
        event_json["force"]["name"] = event.force.name
    else
        event_json["force"] = {}
        event_json["force"]["name"] = "none"
    end
    event_json["tick"] = event.tick
    write_game_event_json(event_json)
    factorio_log(event_json["event"], "Event Name: " .. event_json["name"] .. " - " .. "Force Name: " .. event_json["force"]["name"]) --event.g. poison damage
end

function on_entity_died(event)
    local event_json = {}
    event_json["name"] = event.name
    event_json["event"] = "DESTROYED"
    event_json["damage_type"] = event.damage_type.name or "no-damage"
    if event.entity then
        event_json["entity"] = {}
        event_json["entity"]["name"] = event.entity.name
        event_json["entity"]["type"] = event.entity.type
        event_json["entity"]["force"] = event.entity.force.name
        event_json["entity"]["position"] = event.entity.position
    end
    if event.force then
        event_json["force"] = {}
        event_json["force"]["name"] = event.force.name
    else
        event_json["force"] = {}
        event_json["force"]["name"] = "none"
        event_json["force"]["reason"] = "ambient damage"
    end
    if event.cause then
        event_json["cause"] = {}
        event_json["cause"]["reason"] = "Combat"
        event_json["cause"]["name"] =  (event.cause.name or "no-cause")
        event_json["cause"]["type"] = event.cause.type
        event_json["cause"]["force"] = event.force.name
    else
        event_json["cause"] = {}
        event_json["cause"]["reason"] = "ambient damage"
    end
    event_json["tick"] = event.tick
    write_game_event_json(event_json)
    factorio_log(event_json["event"], "Event Name: " .. event_json["name"] .. " - " .. ("Cause Reason: " .. event_json["cause"]["reason"] or "")) --event.g. poison damage
end

function on_built_entity(event)
    -- get the corresponding data
    local player = game.get_player(event.player_index)
    local data = storage.playerstats[player.name]
    if data == nil then
        -- format of array: {entities placed, ticks played}
        storage.playerstats[player.name] = {1, 0}
    else
        data[1] = data[1] + 1 --indexes start with 1 in lua
        storage.playerstats[player.name] = data
    end

    local event_json = {}
    event_json["name"] = event.name
    event_json["tick"] = event.tick
    event_json["player_name"] = player.name
    event_json["event"] = "BUILT_ENTITY"
    if event.entity then
        event_json["entity"] = {}
        event_json["entity"]["name"] = event.entity.type
    end
    write_game_event_json(event_json)
    factorio_log(event_json["event"], event_json["entity"]["name"])
end

events[defines.events.on_post_entity_died] = on_post_entity_died
events[defines.events.on_entity_died] = on_entity_died
events[defines.events.on_built_entity] = on_built_entity
