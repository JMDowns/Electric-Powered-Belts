-- prototypes/technology.lua
data:extend({
  {
    type = "technology",
    name = "electric-belts",
    icon = "__base__/graphics/technology/logistics.png",
    icon_size = 256,
    prerequisites = {"logistics", "electronics"},
    effects = {
      { type = "unlock-recipe", recipe = "electric-transport-belt-powered" },
      { type = "unlock-recipe", recipe = "electric-transport-belt-unpowered" }
    },
    unit = {
      count = 100,
      ingredients = {{"automation-science-pack", 1},{"logistic-science-pack",1}},
      time = 30
    },
    order = "a-f"
  }
})
