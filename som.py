import os

# Définir la structure des fichiers et leur contenu
file_structure = {
    "ElectricPoweredBelts_0.1.0": {
        "info.json": '''{
  "name": "ElectricPoweredBelts",
  "version": "0.1.0",
  "title": "Electric Powered Belts",
  "author": "YourName",
  "factorio_version": "2.0",
  "dependencies": ["base >= 1.1"]
}
''',
        "data.lua": '''-- data.lua
-- This file loads our prototypes

require("prototypes.item")
require("prototypes.entity")
require("prototypes.recipe")
require("prototypes.technology")
''',
        "control.lua": '''-- control.lua
-- Runtime script that manages belt lines, controllers, and power states.

global.belt_lines = global.belt_lines or {}
global.belt_to_line = global.belt_to_line or {}
global.line_index = global.line_index or 0

-- Utility functions from previous explanations:

local function get_connected_belts(start_entity)
  local to_check = {start_entity}
  local checked = {}
  local belts = {}

  while #to_check > 0 do
    local belt = table.remove(to_check)
    if belt and belt.valid and not checked[belt.unit_number] then
      checked[belt.unit_number] = true
      table.insert(belts, belt)

      local neighbors = belt.neighbours
      for _, dir_belts in pairs(neighbors) do
        for _, neighbor in pairs(dir_belts) do
          if neighbor.valid and neighbor.type == "transport-belt" and not checked[neighbor.unit_number] then
            table.insert(to_check, neighbor)
          end
        end
      end
    end
  end
  return belts
end

local function merge_lines_into_first(line_ids)
  table.sort(line_ids)
  local primary_line_id = line_ids[1]

  for i = 2, #line_ids do
    local other_line_id = line_ids[i]
    for _, belt in pairs(global.belt_lines[other_line_id].belts) do
      global.belt_to_line[belt.unit_number] = primary_line_id
      table.insert(global.belt_lines[primary_line_id].belts, belt)
    end
    if global.belt_lines[other_line_id].controller and global.belt_lines[other_line_id].controller.valid then
      global.belt_lines[other_line_id].controller.destroy()
    end
    global.belt_lines[other_line_id] = nil
  end

  return primary_line_id
end

function identify_line(start_entity)
  local belts = get_connected_belts(start_entity)

  local found_line_ids_map = {}
  for _, belt in pairs(belts) do
    local existing_line_id = global.belt_to_line[belt.unit_number]
    if existing_line_id then
      found_line_ids_map[existing_line_id] = true
    end
  end

  local line_ids = {}
  for line_id, _ in pairs(found_line_ids_map) do
    table.insert(line_ids, line_id)
  end

  local final_line_id

  if #line_ids == 0 then
    global.line_index = global.line_index + 1
    final_line_id = global.line_index
    global.belt_lines[final_line_id] = {
      controller = nil,
      belts = {},
      powered = false,
      last_power_check = game.tick
    }
  elseif #line_ids == 1 then
    final_line_id = line_ids[1]
  else
    final_line_id = merge_lines_into_first(line_ids)
  end

  local line_data = global.belt_lines[final_line_id]
  local existing_lookup = {}
  for _, b in pairs(line_data.belts) do
    existing_lookup[b.unit_number] = true
  end

  local new_belts_added = false
  for _, belt in pairs(belts) do
    if not existing_lookup[belt.unit_number] then
      table.insert(line_data.belts, belt)
      global.belt_to_line[belt.unit_number] = final_line_id
      new_belts_added = true
    end
  end

  return final_line_id, line_data.belts, new_belts_added
end

-- Functions to change belt states:
function make_line_normal_speed(belts)
  for _, belt in pairs(belts) do
    if belt.valid then
      if belt.name == "electric-transport-belt-unpowered" then
        local dir = belt.direction
        local pos = belt.position
        belt.destroy()
        belt.surface.create_entity{
          name = "electric-transport-belt-powered",
          position = pos,
          direction = dir,
          force = belt.force
        }
      end
    end
  end
end

function make_line_slow(belts)
  for _, belt in pairs(belts) do
    if belt.valid then
      if belt.name == "electric-transport-belt-powered" then
        local dir = belt.direction
        local pos = belt.position
        belt.destroy()
        belt.surface.create_entity{
          name = "electric-transport-belt-unpowered",
          position = pos,
          direction = dir,
          force = belt.force
        }
      end
    end
  end
end

-- When a belt is built, identify/update the line and create/update the controller
script.on_event(defines.events.on_built_entity, function(event)
  local entity = event.created_entity
  if entity and entity.valid and entity.type == "transport-belt" then
    local line_id, belts, new_belts_added = identify_line(entity)
    local line_data = global.belt_lines[line_id]

    if line_data.controller == nil or not (line_data.controller.valid) then
      -- Create a controller
      local controller = entity.surface.create_entity{
        name = "belt-line-power-controller",
        position = {entity.position.x, entity.position.y - 0.5},
        force = entity.force
      }
      line_data.controller = controller
      -- Initially make them slow (unpowered)
      make_line_slow(line_data.belts)
      line_data.powered = false
    else
      -- Line existed. If new belts added, set them to current state:
      if new_belts_added then
        if line_data.powered then
          make_line_normal_speed({entity})
        else
          make_line_slow({entity})
        end
      end
    end
  end
end)

-- Periodic check to see if line is powered or not
script.on_nth_tick(60, function()
  for line_id, line_data in pairs(global.belt_lines) do
    local controller = line_data.controller
    if controller and controller.valid then
      local energy = controller.energy
      local threshold = 10000
      local is_powered = (energy > threshold)
      if is_powered ~= line_data.powered then
        if is_powered then
          make_line_normal_speed(line_data.belts)
          line_data.powered = true
        else
          make_line_slow(line_data.belts)
          line_data.powered = false
        end
      else
        -- If unpowered for a long time, remove controller
        if not is_powered and (game.tick - line_data.last_power_check) > (60*60*10) then
          if controller.valid then
            controller.destroy()
          end
          global.belt_lines[line_id] = nil
        end
      end
      line_data.last_power_check = game.tick
    else
      -- Controller missing, clean up line
      global.belt_lines[line_id] = nil
    end
  end
end)
''',
        "prototypes": {
            "item.lua": '''-- prototypes/item.lua
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
''',
            "entity.lua": '''-- prototypes/entity.lua

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
''',
            "recipe.lua": '''-- prototypes/recipe.lua
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
''',
            "technology.lua": '''-- prototypes/technology.lua
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
'''
        }
    }
}

def create_structure(base_path, structure):
    for name, content in structure.items():
        path = os.path.join(base_path, name)
        if isinstance(content, dict):
            # C'est un répertoire
            os.makedirs(path, exist_ok=True)
            create_structure(path, content)  # Récursion
        else:
            # C'est un fichier, on l'écrit
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Créé: {path}")

def main():
    base_directory = os.getcwd()  # Vous pouvez définir un autre chemin si nécessaire
    create_structure(base_directory, file_structure)
    print("Architecture de fichiers créée avec succès.")

if __name__ == "__main__":
    main()
