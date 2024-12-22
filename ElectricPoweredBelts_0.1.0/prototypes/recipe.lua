-- prototypes/recipe.lua
data:extend({
  {
    type = "recipe",
    name = "electric-transport-belt-powered",
    enabled = false,
    ingredients = {
      {"transport-belt", 1},
      {"electronic-circuit", 2}
    },
    result = "electric-transport-belt-powered"
  },
  {
    type = "recipe",
    name = "electric-transport-belt-unpowered",
    enabled = false,
    ingredients = {
      {"transport-belt", 1},
      {"electronic-circuit", 1}
    },
    result = "electric-transport-belt-unpowered"
  }
})
