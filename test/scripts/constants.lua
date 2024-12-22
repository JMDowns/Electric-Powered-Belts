-- Centralized constants for Electric Powered Belts

local constants = {}

-- Energy multiplier for powered belts
constants.ENERGY_MULTIPLIER = settings.startup["powered-belts-usage-multiplier"].value

-- Supported entity types
constants.SUPPORTED_ENTITIES = {
    ["transport-belt"] = true,
    ["underground-belt"] = true,
    ["splitter"] = true
}

-- Default power usage multiplier
constants.DEFAULT_POWER_USAGE = 160

-- Belt speeds based on tier
constants.BELT_SPEEDS = {
    ["transport-belt"] = 0.03125,
    ["fast-transport-belt"] = 0.0625,
    ["express-transport-belt"] = 0.09375
}

return constants