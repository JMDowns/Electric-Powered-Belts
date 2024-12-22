-- prototypes/entity.lua

local powered_belt = util.table.deepcopy(data.raw["transport-belt"]["transport-belt"])
powered_belt.name = "electric-transport-belt-powered"
powered_belt.minable.result = "electric-transport-belt-powered"
powered_belt.icons = {{icon = "__base__/graphics/icons/transport-belt.png", tint={r=0.0,g=1.0,b=0.0,a=1.0}}}
powered_belt.speed = 0.03125  -- Normal belt speed
-- We won't add direct energy usage here, just conceptually "powered".
-- This belt acts normal speed. You could also add a custom graphic to differentiate.

local unpowered_belt = util.table.deepcopy(data.raw["transport-belt"]["transport-belt"])
unpowered_belt.name = "electric-transport-belt-unpowered"
unpowered_belt.minable.result = "electric-transport-belt-unpowered"
unpowered_belt.icons = {{icon = "__base__/graphics/icons/transport-belt.png", tint={r=1.0,g=0.0,b=0.0,a=1.0}}}
unpowered_belt.speed = 0.015 -- Slower speed when "unpowered"

-- The controller entity:
local controller = {
  type = "electric-energy-interface",
  name = "belt-line-power-controller",
  icon = "__base__/graphics/icons/accumulator.png",
  icon_size = 64,
  flags = {"placeable-off-grid", "not-on-map"},
  selectable_in_game = false,
  collision_mask = {},
  energy_source = {
    type = "electric",
    buffer_capacity = "1MJ",
    usage_priority = "secondary-input",
    input_flow_limit = "1MW",
    output_flow_limit = "0W",
    render_no_power_icon = false
  },
  energy_usage = "0W",
  energy_production = "0W"
}

data:extend({powered_belt, unpowered_belt, controller})
