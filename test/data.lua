local um = settings.startup["powered-belts-usage-multiplier"].value

local function create_powered_entity(base_entity, energy_multiplier, distance_multiplier)
    local power_usage  = 160 * base_entity.speed * energy_multiplier * (distance_multiplier or 1)
    local powered_entity = table.deepcopy(base_entity)

    powered_entity.name = "unpowered-" .. powered_entity.name
    powered_entity.speed = 1e-308 -- speed has to be positibase_entitye, this is close enough to 0
    powered_entity.localised_name = {"entity-name." .. base_entity.name}
    powered_entity.localised_description = {"entity-description." .. base_entity.name}

    data:extend({powered_entity, {
        type = "electric-energy-interface",
        name = base_entity.name .. "-power",
        icon = base_entity.icon,
        icon_size = base_entity.icon_size,
        icon_mipmaps = base_entity.icon_mipmaps,
        flags = {"placeable-neutral", "not-blueprintable", "not-in-kill-statistics"},
        max_health = 1,
        resistances = resistances_immune,
        collision_box = base_entity.collision_box,
        selection_box = base_entity.selection_box,
        drawing_box = base_entity.drawing_box,
        selectable_in_game = false,
        -- hidden = true,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            input_flow_limit = (power_usage + 1) .. "kW",
            buffer_capacity = (17 * power_usage) .. "J"
        },
        energy_production = "0W",
        energy_usage = power_usage .. "kW"
    }})
end

for _, entity in pairs(data.raw["transport-belt"]) do
    if not string.match(entity.name, "unpowered-") then
        create_powered_entity(entity, um)
    end
end

for _, entity in pairs(data.raw["underground-belt"]) do
    if not string.match(entity.name, "unpowered-") then
        create_powered_entity(entity, um, entity.max_distance + 2)
    end
end

for _, entity in pairs(data.raw["splitter"]) do
    if not string.match(entity.name, "unpowered-") then
        create_powered_entity(entity, um, 5)
    end
end

for _, entity in pairs(data.raw["loader"]) do
    if not string.match(entity.name, "unpowered-") then
        create_powered_entity(entity, um, 5)
    end
end


for _, entity in pairs(data.raw["loader-1x1"]) do
    if not string.match(entity.name, "unpowered-") then
        create_powered_entity(entity, um, 10)
    end
end

for _, entity in pairs(data.raw["linked-belt"]) do
    if not string.match(entity.name, "unpowered-") then
        create_powered_entity(entity, um)
    end
end

-- for _, v in pairs(data.raw["transport-belt"]) do
--     if not string.match(v.name, "unpowered-") then
--         local e = 160 * v.speed * um
--         local x = table.deepcopy(v)
--         x.name = "unpowered-" .. x.name
--         x.speed = 1e-308 -- speed has to be positive, this is close enough to 0
--         x.localised_name = {"entity-name." .. v.name}
--         x.localised_description = {"entity-description." .. v.name}
--         data:extend({x, {
--             type = "electric-energy-interface",
--             name = v.name .. "-power",
--             icon = v.icon,
--             icon_size = v.icon_size,
--             icon_mipmaps = v.icon_mipmaps,
--             flags = {"player-creation", "not-deconstructable", "not-blueprintable"},
--             max_health = 1,
--             resistances = resistances_immune,
--             collision_box = v.collision_box,
--             selection_box = v.selection_box,
--             drawing_box = v.drawing_box,
--             selectable_in_game = false,
--             energy_source = {
--                 type = "electric",
--                 usage_priority = "secondary-input",
--                 input_flow_limit = (e + 1) .. "kW",
--                 buffer_capacity = (17 * e) .. "J"
--             },
--             energy_production = "0W",
--             energy_usage = e .. "kW"
--         }})
--     end
-- end
-- for _, v in pairs(data.raw["underground-belt"]) do
--     if not string.match(v.name, "unpowered-") then
--         local e = 160 * v.speed * um * (v.max_distance + 2)
--         local x = table.deepcopy(v)
--         x.name = "unpowered-" .. x.name
--         x.speed = 1e-308
--         x.localised_name = {"entity-name." .. v.name}
--         x.localised_description = {"entity-description." .. v.name}
--         data:extend({x, {
--             type = "electric-energy-interface",
--             name = v.name .. "-power",
--             icon = v.icon,
--             icon_size = v.icon_size,
--             icon_mipmaps = v.icon_mipmaps,
--             flags = {"player-creation", "not-deconstructable", "not-blueprintable"},
--             max_health = 1,
--             resistances = resistances_immune,
--             collision_box = v.collision_box,
--             selection_box = v.selection_box,
--             drawing_box = v.drawing_box,
--             selectable_in_game = false,
--             energy_source = {
--                 type = "electric",
--                 usage_priority = "secondary-input",
--                 input_flow_limit = (e + 1) .. "kW",
--                 buffer_capacity = (17 * e) .. "J"
--             },
--             energy_production = "0W",
--             energy_usage = e .. "kW"
--         }})
--     end
-- end
-- for _, v in pairs(data.raw["splitter"]) do
--     if not string.match(v.name, "unpowered-") then
--         local e = 160 * v.speed * um * 5
--         local x = table.deepcopy(v)
--         x.name = "unpowered-" .. x.name
--         x.speed = 1e-308
--         x.localised_name = {"entity-name." .. v.name}
--         x.localised_description = {"entity-description." .. v.name}
--         data:extend({x, {
--             type = "electric-energy-interface",
--             name = v.name .. "-power",
--             icon = v.icon,
--             icon_size = v.icon_size,
--             icon_mipmaps = v.icon_mipmaps,
--             flags = {"player-creation", "not-deconstructable", "not-blueprintable"},
--             max_health = 1,
--             resistances = resistances_immune,
--             collision_box = v.collision_box,
--             selection_box = v.selection_box,
--             drawing_box = v.drawing_box,
--             selectable_in_game = false,
--             energy_source = {
--                 type = "electric",
--                 usage_priority = "secondary-input",
--                 input_flow_limit = (e + 1) .. "kW",
--                 buffer_capacity = (17 * e) .. "J"
--             },
--             energy_production = "0W",
--             energy_usage = e .. "kW"
--         }})
--     end
-- end
-- for _, v in pairs(data.raw["loader-1x1"]) do
--     if not string.match(v.name, "unpowered-") then
--         local e = 160 * v.speed * um * 5
--         local x = table.deepcopy(v)
--         x.name = "unpowered-" .. x.name
--         x.speed = 1e-308
--         x.localised_name = {"entity-name." .. v.name}
--         x.localised_description = {"entity-description." .. v.name}
--         data:extend({x, {
--             type = "electric-energy-interface",
--             name = v.name .. "-power",
--             icon = v.icon,
--             icon_size = v.icon_size,
--             icon_mipmaps = v.icon_mipmaps,
--             flags = {"player-creation", "not-deconstructable", "not-blueprintable"},
--             max_health = 1,
--             resistances = resistances_immune,
--             collision_box = v.collision_box,
--             selection_box = v.selection_box,
--             drawing_box = v.drawing_box,
--             selectable_in_game = false,
--             energy_source = {
--                 type = "electric",
--                 usage_priority = "secondary-input",
--                 input_flow_limit = (e + 1) .. "kW",
--                 buffer_capacity = (17 * e) .. "J"
--             },
--             energy_production = "0W",
--             energy_usage = e .. "kW"
--         }})
--     end
-- end
-- for _, v in pairs(data.raw["loader"]) do
--     if not string.match(v.name, "unpowered-") then
--         local e = 160 * v.speed * um * 10
--         local x = table.deepcopy(v)
--         x.name = "unpowered-" .. x.name
--         x.speed = 1e-308
--         x.localised_name = {"entity-name." .. v.name}
--         x.localised_description = {"entity-description." .. v.name}
--         data:extend({x, {
--             type = "electric-energy-interface",
--             name = v.name .. "-power",
--             icon = v.icon,
--             icon_size = v.icon_size,
--             icon_mipmaps = v.icon_mipmaps,
--             flags = {"player-creation", "not-deconstructable", "not-blueprintable"},
--             max_health = 1,
--             resistances = resistances_immune,
--             collision_box = v.collision_box,
--             selection_box = v.selection_box,
--             drawing_box = v.drawing_box,
--             selectable_in_game = false,
--             energy_source = {
--                 type = "electric",
--                 usage_priority = "secondary-input",
--                 input_flow_limit = (e + 1) .. "kW",
--                 buffer_capacity = (17 * e) .. "J"
--             },
--             energy_production = "0W",
--             energy_usage = e .. "kW"
--         }})
--     end
-- end
