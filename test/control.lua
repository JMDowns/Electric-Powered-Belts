-- Main control logic for Electric Powered Belts

local constants = require("scripts/constants")
local utils = require("scripts/utils")
local rendering = require("scripts/rendering")

-- Initialization
script.on_init(function()
    storage.powered_belts = {}
end)

-- Event handlers
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, function(event)
    local entity = event.created_entity

    if utils.is_supported_entity(entity) then
        -- Add the entity to the storage tracking table
        storage.powered_belts[entity.unit_number] = entity
        
        -- Render power overlay for the belt
        rendering.render_power_overlay(entity)
    end
end)

script.on_event(defines.events.on_tick, function()
    -- Periodic updates for powered belts
    for _, entity in pairs(storage.powered_belts) do
        if entity.valid then
            -- Update power overlay
            rendering.render_power_overlay(entity)
        else
            storage.powered_belts[entity.unit_number] = nil
        end
    end
end)
