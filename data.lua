require("util")
	data:extend({
	  {
		type = "fluid",
		name = "oxygen",
		default_temperature = 25,
		heat_capacity = "1KJ",
		base_color = {r=0.7, g=0.7, b=0.7},
		flow_color = {r=0.5, g=0.5, b=0.5},
		max_temperature = 100,
		icon = "__Vacuum__/oxygen.png",
		icon_size=32,
		pressure_to_speed_ratio = 0.4,
		flow_to_energy_ratio = 0.59,
		order = "a[fluid]-h[oxygen]",
		auto_barrel = false,
		gas_temperature = 25,
	  }
	})
data:extend({
  {
	type = "recipe",
	name = "oxygen-from-water",
	--subgroup = "oxygen",
	enabled = "true",
	order = "e-a",
	category = "chemistry",
	ingredients = {
	  {type="fluid", name="water", amount=2}
	},
	results = {
	  {type="fluid", name="oxygen", amount=3}
	}
  }
})






pipecoverspictures = function()
  return {
    north =
    {
      filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
      priority = "extra-high",
      width = 44,
      height = 32
    },
    east =
    {
      filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
      priority = "extra-high",
      width = 32,
      height = 32
    },
    south =
    {
      filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
      priority = "extra-high",
      width = 46,
      height = 52
    },
    west =
    {
      filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
      priority = "extra-high",
      width = 32,
      height = 32
    }
  }
end

data:extend({
  {
	type = "storage-tank",
    name = "oxygen-dispenser",
    icon = "__Vacuum__/dispenser.png",
	icon_size=32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "oxygen-dispenser"},
    max_health = 100,
    corpse = "small-remnants",
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	window_bounding_box = {{-0.125, 0.6875}, {0.1875, 1.1875}},
    pictures =
	{
		picture =
		{
			sheet =
			{
				filename = "__Vacuum__/dispenser.png",
				priority = "extra-high",
				width = 32,
				height = 32,
				frames = 1,
				shift = {0, 0}
			},
			
		},
	gas_flow ={filename = "__base__/graphics/entity/pipe/steam.png",priority = "extra-high",line_length = 10,width = 24,height = 15, frame_count = 60,axially_symmetrical = false,direction_count = 1,animation_speed = 0.25},
		
      fluid_background ={filename = "__Vacuum__/null.png",priority = "extra-high",width = 1,height = 1},
      window_background ={filename = "__Vacuum__/null.png",priority = "extra-high",width = 1,height = 1},
      flow_sprite ={filename = "__Vacuum__/null.png",priority = "extra-high",width = 1,height = 1},
	},
	fluid_box =
    {
      base_area = 3,
	  --pipe_covers = pipecoverspictures(),
	  pipe_connections =
      {
        { position = {0, -1} }
      },
    },
	flow_length_in_ticks = 360,
	
    circuit_wire_connection_points = {},
	circuit_connector_sprites = {},
    circuit_wire_max_distance = 0
  },
  {
	type = "item",
	name = "oxygen-dispenser",
	icon = "__Vacuum__/dispenser.png",
	icon_size=32,
	flags = {"goes-to-quickbar"},
	order = "c[oxyge-devices]-a[oxygen-dispenser]",
	stack_size = 10,
	place_result = "oxygen-dispenser"
  },
  {
	type = "recipe",
	name = "oxygen-dispenser",
	enabled = "true",
	ingredients =
	{
	  {"steel-plate", 10},
	  {"electronic-circuit", 20},
	  {"pipe", 5}
	},
	result = "oxygen-dispenser"
  },
})
