function checkEvolution()
    local event_json = {}
    event_json["name"] = "evolution_factor"
    event_json["event"] = "EVOLUTION"
    for surface, _ in pairs(game.surfaces) do
        event_json["stats"] = {
            ["factor"] = game.forces["enemy"].get_evolution_factor(surface),
            ["surface"] = surface
        }
        write_game_event_json(event_json)
        factorio_log(event_json["event"], string.format("Surface: %s Factor: %.4f", event_json["stats"]["surface"], event_json["stats"]["factor"]))
    end
end