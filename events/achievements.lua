function on_achievement_gained(event)
    local event_json = {}
    event_json["name"] = event.name
    event_json["player"] = game.get_player(event.player_index).name
    event_json["event"] = "ACHIEVEMENT_GAINED"
    event_json["achievement_name"] = event.achievement.name
    event_json["tick"] = event.tick
    write_game_event_json(event_json)
    factorio_log(event_json["event"], event_json["name"] .. "by " .. event_json["player"])
end

events[defines.events.on_achievement_gained] = on_achievement_gained