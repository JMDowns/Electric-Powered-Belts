-- -- -- -- -- local basic_belt = util.table.deepcopy(data.raw["transport-belt"]["transport-belt"])
-- -- -- -- -- basic_belt.name = "energy-transport-belt"
-- -- -- -- -- basic_belt.energy_source = {
-- -- -- -- --   type = "electric",
-- -- -- -- --   usage_priority = "secondary-input",
-- -- -- -- --   emissions_per_minute = 0.01
-- -- -- -- -- }
-- -- -- -- -- basic_belt.energy_usage_per_tick = "10W" -- Consommation statique de base
-- -- -- -- -- basic_belt.icon = "__energy_belts__/graphics/icons/energy-belt.png"
-- -- -- -- -- basic_belt.minable = {mining_time = 0.2, result = "transport-belt"}

-- -- -- -- -- data:extend({basic_belt})

-- -- -- -- local basic_belt = table.deepcopy(data.raw["transport-belt"]["transport-belt"])
-- -- -- -- basic_belt.name = "energy-transport-belt"
-- -- -- -- basic_belt.energy_source = {
-- -- -- --   type = "electric",
-- -- -- --   usage_priority = "secondary-input",
-- -- -- --   emissions_per_minute = 0.01
-- -- -- -- }
-- -- -- -- basic_belt.energy_usage_per_tick = "10W" -- Base energy usage
-- -- -- -- -- basic_belt.icon = "__energy_belts__/graphics/icons/energy-belt.png"
-- -- -- -- basic_belt.icon = data.raw["transport-belt"]["transport-belt"].icon
-- -- -- -- basic_belt.minable = {mining_time = 0.2, result = "transport-belt"}
-- -- -- -- -- basic_belt.placeable_by = {item = "transport-belt", count = 1}
-- -- -- -- basic_belt.crafting_categories = {"smelting"}

-- -- -- -- -- Repeat for fast and express belts
-- -- -- -- local fast_belt = table.deepcopy(data.raw["transport-belt"]["fast-transport-belt"])
-- -- -- -- fast_belt.name = "energy-fast-transport-belt"
-- -- -- -- fast_belt.energy_source = {
-- -- -- --   type = "electric",
-- -- -- --   usage_priority = "secondary-input",
-- -- -- --   emissions_per_minute = 0.02
-- -- -- -- }
-- -- -- -- fast_belt.energy_usage_per_tick = "20W"
-- -- -- -- -- fast_belt.icon = "__energy_belts__/graphics/icons/energy-fast-belt.png"
-- -- -- -- fast_belt.icon = data.raw["transport-belt"]["fast-transport-belt"].icon
-- -- -- -- fast_belt.minable = {mining_time = 0.2, result = "fast-transport-belt"}
-- -- -- -- -- fast_belt.placeable_by = {item = "fast-transport-belt", count = 1}
-- -- -- -- fast_belt.crafting_categories = {"smelting"}

-- -- -- -- data:extend({basic_belt, fast_belt})

-- -- -- -- -- data:extend({
-- -- -- -- --     {
-- -- -- -- --       type = "transport-belt",
-- -- -- -- --       name = "energy-transport-belt",
-- -- -- -- --       energy_source = {
-- -- -- -- --         type = "electric",
-- -- -- -- --         usage_priority = "secondary-input",
-- -- -- -- --         emissions_per_minute = 0.01
-- -- -- -- --       },
-- -- -- -- --       energy_usage_per_tick = "10W",
-- -- -- -- --       icon = data.raw["transport-belt"]["transport-belt"].icon,
-- -- -- -- --       minable = {mining_time = 0.2, result = "energy-transport-belt"},
-- -- -- -- --       placeable_by = {item = "energy-transport-belt", count = 1},
-- -- -- -- --       next_upgrade = "fast-transport-belt",
-- -- -- -- --     --   crafting_categories = {"smelting"},
-- -- -- -- --     },
-- -- -- -- --     {
-- -- -- -- --       type = "transport-belt",
-- -- -- -- --       name = "energy-fast-transport-belt",
-- -- -- -- --       energy_source = {
-- -- -- -- --         type = "electric",
-- -- -- -- --         usage_priority = "secondary-input",
-- -- -- -- --         emissions_per_minute = 0.02
-- -- -- -- --       },
-- -- -- -- --       energy_usage_per_tick = "20W",
-- -- -- -- --       icon = data.raw["transport-belt"]["fast-transport-belt"].icon,
-- -- -- -- --       minable = {mining_time = 0.2, result = "energy-fast-transport-belt"},
-- -- -- -- --       placeable_by = {item = "energy-fast-transport-belt", count = 1},
-- -- -- -- --       next_upgrade = "express-transport-belt",
-- -- -- -- --     --   crafting_categories = {"smelting"},
-- -- -- -- --     }
-- -- -- -- --   })
  

-- -- -- local basic_belt = util.table.deepcopy(data.raw["transport-belt"]["transport-belt"])
-- -- -- local electric_furnace_base = util.table.deepcopy(data.raw["furnace"]["electric-furnace"])

-- -- -- basic_belt.name = "energy-transport-belt"
-- -- -- basic_belt.energy_source = electric_furnace_base.energy_source -- Copy from electric furnace
-- -- -- basic_belt.energy_usage_per_tick = "10W"
-- -- -- basic_belt.icon = data.raw["transport-belt"]["transport-belt"].icon
-- -- -- basic_belt.minable = {mining_time = 0.2, result = "transport-belt"}
-- -- -- basic_belt.placeable_by = {item = "transport-belt", count = 1}
-- -- -- basic_belt.crafting_categories = electric_furnace_base.crafting_categories -- Copy from electric furnace

-- -- -- local fast_belt = util.table.deepcopy(data.raw["transport-belt"]["fast-transport-belt"])
-- -- -- fast_belt.name = "energy-fast-transport-belt"
-- -- -- fast_belt.energy_source = electric_furnace_base.energy_source -- Copy from electric furnace
-- -- -- fast_belt.energy_usage_per_tick = "20W"
-- -- -- fast_belt.icon = data.raw["transport-belt"]["fast-transport-belt"].icon
-- -- -- fast_belt.minable = {mining_time = 0.2, result = "fast-transport-belt"}
-- -- -- fast_belt.placeable_by = {item = "fast-transport-belt", count = 1}
-- -- -- fast_belt.crafting_categories = electric_furnace_base.crafting_categories -- Copy from electric furnace

-- -- -- data:extend({basic_belt, fast_belt})

-- local electric_furnace_base = util.table.deepcopy(data.raw["furnace"]["electric-furnace"])
-- local transport_belt_base = util.table.deepcopy(data.raw["transport-belt"]["transport-belt"])

-- -- Basic energy transport belt
-- local basic_belt = util.table.deepcopy(electric_furnace_base)
-- basic_belt.name = "energy-transport-belt"
-- basic_belt.icon = transport_belt_base.icon
-- basic_belt.minable = {mining_time = 0.2, result = "energy-transport-belt"}
-- basic_belt.placeable_by = {item = "energy-transport-belt", count = 1}

-- -- Merge transport-belt functionality
-- basic_belt.belt_animation_set = transport_belt_base.belt_animation_set
-- basic_belt.speed = transport_belt_base.speed -- Keep transport speed
-- basic_belt.max_health = transport_belt_base.max_health -- Use transport belt health
-- basic_belt.energy_source = electric_furnace_base.energy_source
-- basic_belt.energy_usage = "10kW" -- Adjust energy usage
-- basic_belt.crafting_categories = electric_furnace_base.crafting_categories -- Keep smelting capability

-- -- Fast energy transport belt
-- local fast_belt = util.table.deepcopy(electric_furnace_base)
-- fast_belt.name = "energy-fast-transport-belt"
-- fast_belt.icon = data.raw["transport-belt"]["fast-transport-belt"].icon
-- fast_belt.minable = {mining_time = 0.2, result = "energy-fast-transport-belt"}
-- fast_belt.placeable_by = {item = "energy-fast-transport-belt", count = 1}

-- -- Merge transport-belt functionality
-- fast_belt.belt_animation_set = data.raw["transport-belt"]["fast-transport-belt"].belt_animation_set
-- fast_belt.speed = data.raw["transport-belt"]["fast-transport-belt"].speed
-- fast_belt.max_health = data.raw["transport-belt"]["fast-transport-belt"].max_health
-- fast_belt.energy_source = electric_furnace_base.energy_source
-- fast_belt.energy_usage = "20kW" -- Adjust energy usage
-- fast_belt.crafting_categories = electric_furnace_base.crafting_categories -- Keep smelting capability

-- data:extend({basic_belt, fast_belt})

-- -- local transport_belt_base = util.table.deepcopy(data.raw["transport-belt"]["transport-belt"])
-- -- local electric_furnace_base = util.table.deepcopy(data.raw["furnace"]["electric-furnace"])

-- -- -- Basic energy transport belt
-- -- local basic_belt = util.table.deepcopy(transport_belt_base)
-- -- basic_belt.name = "energy-transport-belt"
-- -- basic_belt.icon = transport_belt_base.icon
-- -- basic_belt.minable = {mining_time = 0.2, result = "energy-transport-belt"}
-- -- basic_belt.placeable_by = {item = "energy-transport-belt", count = 1}

-- -- -- Merge furnace functionality
-- -- basic_belt.energy_source = electric_furnace_base.energy_source
-- -- basic_belt.energy_usage = "10kW"
-- -- basic_belt.crafting_categories = electric_furnace_base.crafting_categories -- Add smelting capability
-- -- basic_belt.allowed_effects = electric_furnace_base.allowed_effects -- Inherit module effects

-- -- -- Fast energy transport belt
-- -- local fast_belt = util.table.deepcopy(data.raw["transport-belt"]["fast-transport-belt"])
-- -- fast_belt.name = "energy-fast-transport-belt"
-- -- fast_belt.icon = fast_belt.icon
-- -- fast_belt.minable = {mining_time = 0.2, result = "energy-fast-transport-belt"}
-- -- fast_belt.placeable_by = {item = "energy-fast-transport-belt", count = 1}

-- -- -- Merge furnace functionality
-- -- fast_belt.energy_source = electric_furnace_base.energy_source
-- -- fast_belt.energy_usage = "20kW"
-- -- fast_belt.crafting_categories = electric_furnace_base.crafting_categories -- Add smelting capability
-- -- fast_belt.allowed_effects = electric_furnace_base.allowed_effects -- Inherit module effects

-- -- data:extend({basic_belt, fast_belt})

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

