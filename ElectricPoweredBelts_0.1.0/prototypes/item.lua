-- prototypes/item.lua
data:extend({
  {
    type = "item",
    name = "electric-transport-belt-powered",
    icon = "__base__/graphics/icons/transport-belt.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "belt",
    order = "a[transport-belt]-z[electric-powered]",
    place_result = "electric-transport-belt-powered",
    stack_size = 100
  },
  {
    type = "item",
    name = "electric-transport-belt-unpowered",
    icon = "__base__/graphics/icons/transport-belt.png",
    icon_size = 64, icon_mipmaps = 4,
    subgroup = "belt",
    order = "a[transport-belt]-z[electric-unpowered]",
    place_result = "electric-transport-belt-unpowered",
    stack_size = 100
  }
})
