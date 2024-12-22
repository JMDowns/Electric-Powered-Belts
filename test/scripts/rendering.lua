-- Rendering logic for Electric Powered Belts

local rendering = {}

--- Render a connection between two entities
---@param from_entity LuaEntity
---@param to_entity LuaEntity
function rendering.render_connection(from_entity, to_entity)
    rendering.draw_line{
        color = {1, 0, 0}, -- Red line
        width = 2,
        from = from_entity.position,
        to = to_entity.position,
        surface = from_entity.surface
    }
end

--- Render a power overlay for an entity
---@param entity LuaEntity
function rendering.render_power_overlay(entity)
    rendering.draw_text{
        text = "Power: " .. tostring(utils.calculate_power_usage(entity)) .. "W",
        surface = entity.surface,
        target = entity,
        target_offset = {0, -1},
        color = {1, 1, 1},
        alignment = "center"
    }
end

return rendering