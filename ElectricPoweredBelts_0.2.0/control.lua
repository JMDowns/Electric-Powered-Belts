---- INIT ----
script.on_init(function()
    storage.entities = {}
    storage.power_entities = {}
end)

---- ON EVENT ----
script.on_event({defines.events.on_robot_built_entity,
                 defines.events.on_built_entity,
                 defines.events.script_raised_revive,
                 defines.events.script_raised_built,
                 defines.events.on_space_platform_built_entity}, function(event)
    if event.entity.type == "transport-belt" or event.entity.type == "underground-belt" or event.entity.type ==
        "splitter" or event.entity.type == "loader-1x1" or event.entity.type == "loader" then
        local pos = event.entity.position.x .. " " .. event.entity.position.y
        -- game.print(event.entity.name)
        -- game.print(string.gsub(event.entity.name, "unpowered-", ""))

        storage.power_entities[pos] = event.entity.surface.create_entity {
            name = event.entity.name .. "-power",
            position = event.entity.position,
            force = event.entity.force,
            direction = event.entity.direction,
            destructible = true
        }
        storage.entities[pos] = event.entity
    end
end)

script.on_event({defines.events.on_entity_died,
                 defines.events.on_robot_pre_mined,
                 defines.events.on_pre_player_mined_item,
                 defines.events.on_space_platform_mined_entity,
                 defines.events.script_raised_destroy}, function(event)
    local pos = event.entity.position.x .. " " .. event.entity.position.y
    if storage.entities[pos] ~= nil then
        storage.power_entities[pos].destroy()
        storage.entities[pos] = nil
        storage.power_entities[pos] = nil
    end
end)

---- ON TICK ----
script.on_event(defines.events.on_tick, function(event)
    if storage.power_entities ~= nil and storage.entities ~= nil and next(storage.power_entities) and
        next(storage.entities) then
        local k
        for _ = 1, settings.global["powered-belts-operations-per-tick"].value do
            if next(storage.power_entities) ~= nil and next(storage.entities) ~= nil then
                if next(storage.power_entities, k) == nil then
                    k, _ = next(storage.power_entities, nil)
                else
                    k, _ = next(storage.power_entities, k)
                end
                if storage.entities[k] ~= nil and storage.entities[k].valid then
                    if string.match(storage.entities[k].name, "unpowered-") and storage.power_entities[k].energy > 0 then
                        local entity_data = {
                            surface = storage.entities[k].surface,
                            name = storage.entities[k].name,
                            position = storage.entities[k].position,
                            force = storage.entities[k].force,
                            direction = storage.entities[k].direction
                        }
                        if storage.entities[k].type == "underground-belt" then
                            entity_data.belt_to_ground_type = storage.entities[k].belt_to_ground_type
                        end
                        if storage.entities[k].valid then
                            storage.entities[k] = entity_data.surface.create_entity {
                                name = string.sub(entity_data.name, 11),
                                position = entity_data.position,
                                force = entity_data.force,
                                direction = entity_data.direction,
                                type = entity_data.belt_to_ground_type,
                                fast_replace = true,
                                spill = false
                            }
                        end
                    elseif (not string.match(storage.entities[k].name, "unpowered-")) and
                        storage.power_entities[k].energy <= 0 then

                        local entity_data = {
                            surface = storage.entities[k].surface,
                            name = storage.entities[k].name,
                            position = storage.entities[k].position,
                            force = storage.entities[k].force,
                            direction = storage.entities[k].direction
                        }
                        if storage.entities[k].type == "underground-belt" then
                            entity_data.belt_to_ground_type = storage.entities[k].belt_to_ground_type
                        end
                        if storage.entities[k].valid then
                            storage.entities[k] = entity_data.surface.create_entity {
                                name = "unpowered-" .. entity_data.name,
                                position = entity_data.position,
                                force = entity_data.force,
                                direction = entity_data.direction,
                                type = entity_data.belt_to_ground_type,
                                fast_replace = true,
                                spill = false
                            }
                        end
                    end
                end
            end
        end
    end
end)
