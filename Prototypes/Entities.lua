-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/20/2017
-- Description: Defines SE entities

require "SEConstants"

-- Allows settings to be copied from each assembler machine to the destination entity
local function AllowAssemblersToPasteSettingsTo(destEntityName)
  for k, machine in pairs(data.raw["assembling-machine"]) do
    if (k ~= nil and machine ~= nil) then
      machine.additional_pastable_entities = machine.additional_pastable_entities or {}
      table.insert(machine.additional_pastable_entities, destEntityName)
    end
  end
end

AllowAssemblersToPasteSettingsTo(SEConstants.Names.Proto.InterfaceChest.Entity)

data:extend(
  {
    -- Energy Acceptor
    {
      type = "accumulator",
      name = SEConstants.Names.Proto.EnergyAcceptor.Entity,
      icon = SEConstants.DataPaths.Icons .. "SE_EnergyAcceptor.png",
      icon_size = 32,
      flags = {"placeable-neutral", "player-creation"},
      minable = {hardness = 0.2, mining_time = 0.4, result = SEConstants.Names.Proto.EnergyAcceptor.Item},
      max_health = 100,
      corpse = "small-remnants",
      collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
      selection_box = {{-1, -1}, {1, 1}},
      energy_source = {
        type = "electric",
        usage_priority = "terciary",
        input_flow_limit = "0W",
        output_flow_limit = "0W",
        buffer_capacity = "5MJ"
      },
      picture = {
        filename = SEConstants.DataPaths.EntityGFX .. "SE_EnergyAcceptor.png",
        priority = "high",
        width = 124,
        height = 103,
        shift = {0.6875, -0.203125}
      },
      charge_animation = {
        filename = SEConstants.DataPaths.EntityGFX .. "SE_EnergyAcceptor.png",
        width = 124,
        height = 103,
        line_length = 1,
        frame_count = 1,
        shift = {0.6875, -0.203125},
        animation_speed = 1
      },
      charge_cooldown = 30,
      charge_light = {intensity = 0.3, size = 7},
      discharge_animation = {
        filename = SEConstants.DataPaths.EntityGFX .. "SE_EnergyAcceptor.png",
        width = 124,
        height = 103,
        line_length = 1,
        frame_count = 1,
        shift = {0.6875, -0.203125},
        animation_speed = 1
      },
      discharge_cooldown = 30,
      discharge_light = {intensity = 0.0, size = 1},
      circuit_wire_connection_point = {
        shadow = {
          red = {0.984375, 1.10938},
          green = {0.890625, 1.10938}
        },
        wire = {
          red = {0.7175, 0.59375},
          green = {0.6575, 0.71875}
        }
      },
      circuit_connector_sprites = circuit_connector_definitions["accumulator"].sprites,
      circuit_wire_max_distance = 9,
      vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.7},
      map_color = {r = 0.61, g = 0.23, b = 0.64}
    },
    -- 'Hidden' energy interface
    {
      type = "electric-energy-interface",
      name = "hidden_" .. SEConstants.Names.Proto.EnergyAcceptor.Entity,
      icon = SEConstants.DataPaths.Icons .. "SE_EnergyAcceptor.png",
      icon_size = 32,
      flags = {},
      max_health = 150,
      indestructible = true,
      collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
      selection_box = {{-1, -1}, {1, 1}},
      selectable_in_game = false,
      energy_source = {
        type = "electric",
        buffer_capacity = "5MJ",
        usage_priority = "secondary-input",
        input_flow_limit = "500kW",
        output_flow_limit = "0kW"
      },
      energy_production = "0kW",
      energy_usage = "0kW",
      picture = {
        filename = SEConstants.DataPaths.EntityGFX .. "SE_EnergyAcceptor.png",
        priority = "low",
        width = 124,
        height = 103,
        shift = {0.6875, -0.203125}
      },
      order = "h-e-e-i"
    },
    -- Controller
    {
      type = "constant-combinator",
      name = SEConstants.Names.Proto.Controller.Entity,
      icon = SEConstants.DataPaths.Icons .. "SE_Controller.png",
      icon_size = 32,
      flags = {"placeable-neutral", "player-creation"},
      minable = {hardness = 0.4, mining_time = 0.7, result = SEConstants.Names.Proto.Controller.Item},
      max_health = 1000,
      corpse = "small-remnants",
      collision_box = {{-0.32, -0.32}, {0.32, 0.32}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      item_slot_count = 2,
      sprites = {
        east = {
          filename = SEConstants.DataPaths.EntityGFX .. "SE_Controller.png",
          x = 0,
          y = 0,
          width = 79,
          height = 63,
          frame_count = 1,
          shift = {0.42017, 0.14063}
        },
        west = {
          filename = SEConstants.DataPaths.EntityGFX .. "SE_Controller.png",
          x = 79,
          y = 0,
          width = 79,
          height = 63,
          frame_count = 1,
          shift = {0.42017, 0.14063}
        },
        north = {
          filename = SEConstants.DataPaths.EntityGFX .. "SE_Controller.png",
          x = 158,
          y = 0,
          width = 79,
          height = 63,
          frame_count = 1,
          shift = {0.42017, 0.14063}
        },
        south = {
          filename = SEConstants.DataPaths.EntityGFX .. "SE_Controller.png",
          x = 237,
          y = 0,
          width = 79,
          height = 63,
          frame_count = 1,
          shift = {0.42017, 0.14063}
        }
      },
      activity_led_sprites = {
        north = {
          filename = "__base__/graphics/entity/combinator/activity-leds/arithmetic-combinator-LED-N.png",
          width = 11,
          height = 10,
          frame_count = 1,
          shift = {0.296875, -0.40625}
        },
        east = {
          filename = "__base__/graphics/entity/combinator/activity-leds/arithmetic-combinator-LED-E.png",
          width = 14,
          height = 12,
          frame_count = 1,
          shift = {0.25, -0.03125}
        },
        south = {
          filename = "__base__/graphics/entity/combinator/activity-leds/arithmetic-combinator-LED-S.png",
          width = 11,
          height = 11,
          frame_count = 1,
          shift = {-0.296875, -0.078125}
        },
        west = {
          filename = "__base__/graphics/entity/combinator/activity-leds/arithmetic-combinator-LED-W.png",
          width = 12,
          height = 12,
          frame_count = 1,
          shift = {-0.21875, -0.46875}
        }
      },
      activity_led_light = {
        intensity = 0.8,
        size = 1
      },
      activity_led_light_offsets = {
        {0.296875, -0.40625},
        {0.25, -0.03125},
        {-0.296875, -0.078125},
        {-0.21875, -0.46875}
      },
      circuit_wire_connection_points = {
        {
          shadow = {
            red = {0.15625, -0.28125},
            green = {0.65625, -0.25}
          },
          wire = {
            red = {-0.28125, -0.5625},
            green = {0.21875, -0.5625}
          }
        },
        {
          shadow = {
            red = {0.75, -0.15625},
            green = {0.75, 0.25}
          },
          wire = {
            red = {0.46875, -0.5},
            green = {0.46875, -0.09375}
          }
        },
        {
          shadow = {
            red = {0.75, 0.5625},
            green = {0.21875, 0.5625}
          },
          wire = {
            red = {0.28125, 0.15625},
            green = {-0.21875, 0.15625}
          }
        },
        {
          shadow = {
            red = {-0.03125, 0.28125},
            green = {-0.03125, -0.125}
          },
          wire = {
            red = {-0.46875, 0},
            green = {-0.46875, -0.40625}
          }
        }
      },
      circuit_wire_max_distance = 9
    },
    -- Storage Chest Mk1
    {
      type = "container",
      name = SEConstants.Names.Proto.StorageChestMk1.Entity,
      icon = SEConstants.DataPaths.EntityGFX .. "SE_ChestMk1.png",
      icon_size = 32,
      flags = {"placeable-neutral", "player-creation"},
      minable = {mining_time = 2, result = SEConstants.Names.Proto.StorageChestMk1.Item},
      max_health = 200,
      corpse = "small-remnants",
      open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65},
      close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7},
      resistances = {
        {
          type = "fire",
          percent = 80
        },
        {
          type = "impact",
          percent = 30
        }
      },
      collision_box = {{-0.32, -0.32}, {0.32, 0.32}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      fast_replaceable_group = "container",
      inventory_size = 48,
      vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
      picture = {
        filename = SEConstants.DataPaths.EntityGFX .. "SE_ChestMk1.png",
        priority = "extra-high",
        width = 32,
        height = 32,
        shift = {0, 0}
      },
      circuit_wire_connection_point = {
        shadow = {
          red = {0.734375, 0.453125},
          green = {0.609375, 0.515625}
        },
        wire = {
          red = {0.44625, 0.21875},
          green = {0.38625, 0.375}
        }
      },
      circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
      circuit_wire_max_distance = 9
    },
    -- Storage Chest Mk2
    {
      type = "container",
      name = SEConstants.Names.Proto.StorageChestMk2.Entity,
      icon = SEConstants.DataPaths.EntityGFX .. "SE_ChestMk2.png",
      icon_size = 32,
      flags = {"placeable-neutral", "player-creation"},
      minable = {mining_time = 3, result = SEConstants.Names.Proto.StorageChestMk2.Item},
      max_health = 500,
      corpse = "small-remnants",
      open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65},
      close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7},
      resistances = {
        {
          type = "fire",
          percent = 90
        },
        {
          type = "impact",
          percent = 10
        }
      },
      collision_box = {{-0.32, -0.32}, {0.32, 0.32}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      fast_replaceable_group = "container",
      inventory_size = 192,
      vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
      picture = {
        filename = SEConstants.DataPaths.EntityGFX .. "SE_ChestMk2.png",
        priority = "extra-high",
        width = 32,
        height = 32,
        shift = {0, 0}
      },
      circuit_wire_connection_point = {
        shadow = {
          red = {0.734375, 0.453125},
          green = {0.609375, 0.515625}
        },
        wire = {
          red = {0.44625, 0.21875},
          green = {0.38625, 0.375}
        }
      },
      circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
      circuit_wire_max_distance = 9
    },
    -- Interface Chest
    {
      type = "container",
      name = SEConstants.Names.Proto.InterfaceChest.Entity,
      icon = SEConstants.DataPaths.EntityGFX .. "SE_InterfaceChest.png",
      icon_size = 32,
      flags = {"placeable-neutral", "player-creation"},
      minable = {mining_time = 1, result = SEConstants.Names.Proto.InterfaceChest.Item},
      max_health = 200,
      corpse = "small-remnants",
      open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65},
      close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7},
      resistances = {
        {
          type = "fire",
          percent = 80
        },
        {
          type = "impact",
          percent = 30
        }
      },
      collision_box = {{-0.32, -0.32}, {0.32, 0.32}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      fast_replaceable_group = "container",
      inventory_size = 48,
      vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
      picture = {
        filename = SEConstants.DataPaths.EntityGFX .. "SE_InterfaceChest.png",
        priority = "extra-high",
        width = 32,
        height = 32,
        shift = {0, 0}
      },
      circuit_wire_connection_point = {
        shadow = {
          red = {0.734375, 0.453125},
          green = {0.609375, 0.515625}
        },
        wire = {
          red = {0.44625, 0.21875},
          green = {0.38625, 0.375}
        }
      },
      circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
      circuit_wire_max_distance = 9
    },
    -- Provider chest
    {
      type = "logistic-container",
      name = SEConstants.Names.Proto.ProviderChest.Entity,
      icon = SEConstants.DataPaths.EntityGFX .. "SE_ProviderChest.png",
      icon_size = 32,
      flags = {"placeable-player", "player-creation"},
      minable = {hardness = 0.2, mining_time = 0.5, result = SEConstants.Names.Proto.ProviderChest.Item},
      max_health = 350,
      corpse = "small-remnants",
      collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      resistances = {
        {
          type = "fire",
          percent = 90
        },
        {
          type = "impact",
          percent = 60
        }
      },
      fast_replaceable_group = "container",
      inventory_size = 48,
      logistic_mode = "passive-provider",
      open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65},
      close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7},
      vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
      picture = {
        filename = SEConstants.DataPaths.EntityGFX .. "SE_ProviderChest.png",
        priority = "extra-high",
        width = 32,
        height = 32,
        shift = {0, 0}
      },
      circuit_wire_connection_point = {
        shadow = {
          red = {0.734375, 0.453125},
          green = {0.609375, 0.515625}
        },
        wire = {
          red = {0.44625, 0.21875},
          green = {0.38625, 0.375}
        }
      },
      circuit_wire_max_distance = 9,
      circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
    },
    -- Requester chest
    {
      type = "logistic-container",
      name = SEConstants.Names.Proto.RequesterChest.Entity,
      icon = SEConstants.DataPaths.EntityGFX .. "SE_RequesterChest.png",
      icon_size = 32,
      flags = {"placeable-player", "player-creation"},
      minable = {hardness = 0.2, mining_time = 0.5, result = SEConstants.Names.Proto.RequesterChest.Item},
      max_health = 350,
      corpse = "small-remnants",
      collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      resistances = {
        {
          type = "fire",
          percent = 90
        },
        {
          type = "impact",
          percent = 60
        }
      },
      fast_replaceable_group = "container",
      inventory_size = 48,
      logistic_slots_count = 12,
      logistic_mode = "requester",
      open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65},
      close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7},
      vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
      picture = {
        filename = SEConstants.DataPaths.EntityGFX .. "SE_RequesterChest.png",
        priority = "extra-high",
        width = 32,
        height = 32,
        shift = {0, 0}
      },
      circuit_wire_connection_point = {
        shadow = {
          red = {0.734375, 0.453125},
          green = {0.609375, 0.515625}
        },
        wire = {
          red = {0.44625, 0.21875},
          green = {0.38625, 0.375}
        }
      },
      circuit_wire_max_distance = 9,
      circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
    }
  }
)
