local energy_belt_item = {
    type = "item",
    name = "unpowered-transport-belt",
    icon = data.raw["transport-belt"]["transport-belt"].icon,
    icon_size = 64,
    subgroup = "production-machine",
    order = "a[transport-belt]-a[transport-belt]",
    place_result = "unpowered-transport-belt",
    stack_size = 100
  }
  
  local energy_fast_belt_item = {
    type = "item",
    name = "unpowered-fast-transport-belt",
    icon = data.raw["transport-belt"]["fast-transport-belt"].icon,
    icon_size = 64,
    subgroup = "production-machine",
    order = "a[transport-belt]-b[fast-transport-belt]",
    place_result = "unpowered-fast-transport-belt",
    stack_size = 100
  }
  
  data:extend({energy_belt_item, energy_fast_belt_item})