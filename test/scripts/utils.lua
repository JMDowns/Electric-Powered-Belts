-- Utility functions for Electric Powered Belts

local utils = {}

--- Check if an entity is supported
---@param entity LuaEntity
---@return boolean
function utils.is_supported_entity(entity)
    return constants.SUPPORTED_ENTITIES[entity.type] ~= nil
end

--- Deep copy utility
---@param obj table
---@return table
function utils.deepcopy(obj)
    local copy = {}
    for k, v in pairs(obj) do
        if type(v) == "table" then
            copy[k] = utils.deepcopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

--- Calculate power usage for a belt entity
---@param entity LuaEntity
---@return number
function utils.calculate_power_usage(entity)
    local base_speed = constants.BELT_SPEEDS[entity.name] or 0
    return constants.DEFAULT_POWER_USAGE * base_speed * constants.ENERGY_MULTIPLIER
end

return utils