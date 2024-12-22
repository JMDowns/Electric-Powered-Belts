-- control.lua
-- Runtime script that manages belt lines, controllers, and power states.
storage.belt_lines = storage.belt_lines or {}
storage.belt_to_line = storage.belt_to_line or {}
storage.line_index = storage.line_index or 0

-- Utility functions from previous explanations:

local function get_connected_belts(start_entity)
    local to_check = {start_entity}
    local checked = {}
    local belts = {}

    while #to_check > 0 do
        local belt = table.remove(to_check)
        if belt and belt.valid and not checked[belt.unit_number] then
            checked[belt.unit_number] = true
            table.insert(belts, belt)

            local neighbors = belt.neighbours
            for _, dir_belts in pairs(neighbors) do
                for _, neighbor in pairs(dir_belts) do
                    if neighbor.valid and neighbor.type == "transport-belt" and not checked[neighbor.unit_number] then
                        table.insert(to_check, neighbor)
                    end
                end
            end
        end
    end
    return belts
end

local function merge_lines_into_first(line_ids)
    table.sort(line_ids)
    local primary_line_id = line_ids[1]

    for i = 2, #line_ids do
        local other_line_id = line_ids[i]
        for _, belt in pairs(storage.belt_lines[other_line_id].belts) do
            storage.belt_to_line[belt.unit_number] = primary_line_id
            table.insert(storage.belt_lines[primary_line_id].belts, belt)
        end
        if storage.belt_lines[other_line_id].controller and storage.belt_lines[other_line_id].controller.valid then
            storage.belt_lines[other_line_id].controller.destroy()
        end
        storage.belt_lines[other_line_id] = nil
    end

    return primary_line_id
end

function identify_line(start_entity)
    local belts = get_connected_belts(start_entity)

    local found_line_ids_map = {}
    for _, belt in pairs(belts) do
        local existing_line_id = storage.belt_to_line[belt.unit_number]
        if existing_line_id then
            found_line_ids_map[existing_line_id] = true
        end
    end

    local line_ids = {}
    for line_id, _ in pairs(found_line_ids_map) do
        table.insert(line_ids, line_id)
    end

    local final_line_id

    if #line_ids == 0 then
        storage.line_index = storage.line_index + 1
        final_line_id = storage.line_index
        storage.belt_lines[final_line_id] = {
            controller = nil,
            belts = {},
            powered = false,
            last_power_check = game.tick
        }
    elseif #line_ids == 1 then
        final_line_id = line_ids[1]
    else
        final_line_id = merge_lines_into_first(line_ids)
    end

    local line_data = storage.belt_lines[final_line_id]
    local existing_lookup = {}
    for _, b in pairs(line_data.belts) do
        existing_lookup[b.unit_number] = true
    end

    local new_belts_added = false
    for _, belt in pairs(belts) do
        if not existing_lookup[belt.unit_number] then
            table.insert(line_data.belts, belt)
            storage.belt_to_line[belt.unit_number] = final_line_id
            new_belts_added = true
        end
    end

    return final_line_id, line_data.belts, new_belts_added
end

-- Functions to change belt states:
function make_line_normal_speed(belts)
    for _, belt in pairs(belts) do
        if belt.valid then
            if belt.name == "electric-transport-belt-unpowered" then
                local dir = belt.direction
                local pos = belt.position
                belt.destroy()
                belt.surface.create_entity {
                    name = "electric-transport-belt-powered",
                    position = pos,
                    direction = dir,
                    force = belt.force
                }
            end
        end
    end
end

function make_line_slow(belts)
    for _, belt in pairs(belts) do
        if belt.valid then
            if belt.name == "electric-transport-belt-powered" then
                local dir = belt.direction
                local pos = belt.position
                belt.destroy()
                belt.surface.create_entity {
                    name = "electric-transport-belt-unpowered",
                    position = pos,
                    direction = dir,
                    force = belt.force
                }
            end
        end
    end
end

-- When a belt is built, identify/update the line and create/update the controller
script.on_event({defines.events.on_robot_built_entity, defines.events.on_built_entity,
                 defines.events.script_raised_revive, defines.events.script_raised_built,
                 defines.events.on_space_platform_built_entity}, function(event)
    local entity = event.created_entity
    if entity and entity.valid and entity.type == "transport-belt" then
        local line_id, belts, new_belts_added = identify_line(entity)
        local line_data = storage.belt_lines[line_id]

        if line_data.controller == nil or not (line_data.controller.valid) then
            -- Create a controller
            local controller = entity.surface.create_entity {
                name = "belt-line-power-controller",
                position = {entity.position.x, entity.position.y - 0.5},
                force = entity.force
            }
            line_data.controller = controller
            -- Initially make them slow (unpowered)
            make_line_slow(line_data.belts)
            line_data.powered = false
        else
            -- Line existed. If new belts added, set them to current state:
            if new_belts_added then
                if line_data.powered then
                    make_line_normal_speed({entity})
                else
                    make_line_slow({entity})
                end
            end
        end
    end
end)

-- Periodic check to see if line is powered or not
script.on_nth_tick(60, function()
    for line_id, line_data in pairs(storage.belt_lines) do
        local controller = line_data.controller
        if controller and controller.valid then
            local energy = controller.energy
            local threshold = 10000
            local is_powered = (energy > threshold)
            if is_powered ~= line_data.powered then
                if is_powered then
                    make_line_normal_speed(line_data.belts)
                    line_data.powered = true
                else
                    make_line_slow(line_data.belts)
                    line_data.powered = false
                end
            else
                -- If unpowered for a long time, remove controller
                if not is_powered and (game.tick - line_data.last_power_check) > (60 * 60 * 10) then
                    if controller.valid then
                        controller.destroy()
                    end
                    storage.belt_lines[line_id] = nil
                end
            end
            line_data.last_power_check = game.tick
        else
            -- Controller missing, clean up line
            storage.belt_lines[line_id] = nil
        end
    end
end)
