local um = settings.startup["powered-belts-usage-multiplier"].value

for _, v in pairs(data.raw["transport-belt"]) do
    if not string.match(v.name, "unpowered-")  then
        local e = 160*v.speed*um
        local x = table.deepcopy(v)
        x.name = "unpowered-"..x.name
        x.speed = 1e-308 --speed has to be positive, this is close enough to 0
        x.localised_name = {"entity-name." .. v.name}
        x.localised_description = {"entity-description." .. v.name}
        data:extend({x,
            {
                type = "electric-energy-interface",
                name = v.name .. "-power",
                icon = v.icon,
                icon_size = v.icon_size, icon_mipmaps = v.icon_mipmaps,
                flags = {"player-creation", "not-deconstructable","not-blueprintable"},
                max_health = 1,
                resistances = resistances_immune,
                collision_box = nil,
                selection_box = nil,
                drawing_box = v.drawing_box,
                selectable_in_game = false,
                energy_source =
                {
                    type = "electric",
                    usage_priority = "secondary-input",
                    input_flow_limit= (e+1).."kW",
                    buffer_capacity = (17*e).."J"
                },
                energy_production = "0W",
                energy_usage = e.."kW"
            }
        })
    end
end
for _, v in pairs(data.raw["underground-belt"]) do
    if not string.match(v.name, "unpowered-")  then
        local e = 160*v.speed*um*(v.max_distance+2)
        local x = table.deepcopy(v)
        x.name = "unpowered-"..x.name
        x.speed = 1e-308
        x.localised_name = {"entity-name." .. v.name}
        x.localised_description = {"entity-description." .. v.name}
        data:extend({x,
            {
                type = "electric-energy-interface",
                name = v.name.."-power",
                icon = v.icon,
                icon_size = v.icon_size, icon_mipmaps = v.icon_mipmaps,
                flags = {"player-creation", "not-deconstructable","not-blueprintable"},
                max_health = 1,
                resistances = resistances_immune,
                collision_box = nil,
                selection_box = nil,
                drawing_box = v.drawing_box,
                selectable_in_game = false,
                energy_source =
                {
                    type = "electric",
                    usage_priority = "secondary-input",
                    input_flow_limit= (e+1).."kW",
                    buffer_capacity = (17*e).."J"
                },
                energy_production = "0W",
                energy_usage = e.."kW"
            }
        })
    end
end
for _, v in pairs(data.raw["splitter"]) do
    if not string.match(v.name, "unpowered-")  then
        local e = 160*v.speed*um*5
        local x = table.deepcopy(v)
        x.name = "unpowered-"..x.name
        x.speed = 1e-308
        x.localised_name = {"entity-name." .. v.name}
        x.localised_description = {"entity-description." .. v.name}
        data:extend({x,
            {
                type = "electric-energy-interface",
                name = v.name.."-power",
                icon = v.icon,
                icon_size = v.icon_size, icon_mipmaps = v.icon_mipmaps,
                flags = {"player-creation", "not-deconstructable","not-blueprintable"},
                max_health = 1,
                resistances = resistances_immune,
                collision_box = nil,
                selection_box = nil,
                drawing_box = v.drawing_box,
                selectable_in_game = false,
                energy_source =
                {
                    type = "electric",
                    usage_priority = "secondary-input",
                    input_flow_limit= (e+1).."kW",
                    buffer_capacity = (17*e).."J"
                },
                energy_production = "0W",
                energy_usage = e.."kW"
            }
        })
    end
end
for _, v in pairs(data.raw["loader-1x1"]) do
    if not string.match(v.name, "unpowered-")  then
        local e = 160*v.speed*um*5
        local x = table.deepcopy(v)
        x.name = "unpowered-"..x.name
        x.speed = 1e-308
        x.localised_name = {"entity-name." .. v.name}
        x.localised_description = {"entity-description." .. v.name}
        data:extend({x,
            {
                type = "electric-energy-interface",
                name = v.name.."-power",
                icon = v.icon,
                icon_size = v.icon_size, icon_mipmaps = v.icon_mipmaps,
                flags = {"player-creation", "not-deconstructable","not-blueprintable"},
                max_health = 1,
                resistances = resistances_immune,
                collision_box = nil,
                selection_box = nil,
                drawing_box = v.drawing_box,
                selectable_in_game = false,
                energy_source =
                {
                    type = "electric",
                    usage_priority = "secondary-input",
                    input_flow_limit= (e+1).."kW",
                    buffer_capacity = (17*e).."J"
                },
                energy_production = "0W",
                energy_usage = e.."kW"
            }
        })
    end
end
for _, v in pairs(data.raw["loader"]) do
    if not string.match(v.name, "unpowered-")  then
        local e = 160*v.speed*um*10
        local x = table.deepcopy(v)
        x.name = "unpowered-"..x.name
        x.speed = 1e-308
        x.localised_name = {"entity-name." .. v.name}
        x.localised_description = {"entity-description." .. v.name}
        data:extend({x,
            {
                type = "electric-energy-interface",
                name = v.name.."-power",
                icon = v.icon,
                icon_size = v.icon_size, icon_mipmaps = v.icon_mipmaps,
                flags = {"player-creation", "not-deconstructable","not-blueprintable"},
                max_health = 1,
                resistances = resistances_immune,
                collision_box = nil,
                selection_box = nil,
                drawing_box = v.drawing_box,
                selectable_in_game = false,
                energy_source =
                {
                    type = "electric",
                    usage_priority = "secondary-input",
                    input_flow_limit= (e+1).."kW",
                    buffer_capacity = (17*e).."J"
                },
                energy_production = "0W",
                energy_usage = e.."kW"
            }
        })
    end
end