------------------------------------------------------------------------
--  HACX THEMES
------------------------------------------------------------------------

HACX.SINKS =
{
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
    light = 16
  },

  -- liquid floor --

  liquid_plain =
  {
    mat = water,
    dz  = -12
  },

  -- street sink def, do not use for anything else
  floor_default_streets =
  {
    mat = "RROCK02",
    dz = 2,
  
    trim_mat = "PLAT1",
    trim_dz = 2,
  }
}


HACX.THEMES =
{
  DEFAULTS =
  {

    keys =
    {
      kz_red = 50,
      kz_yellow = 50,
      kz_blue = 50
    },

    skyboxes =
    {

    },

    cage_lights = { 0, 8, 12, 13 },

    pool_depth = 24,

    street_sinks =
    {
      floor_default_streets = 1
    }
  },


  hacx_urban =
  {

   style_list =
    {
      caves = { none=60, few=40, some=12, heaps=2 },
      outdoors = { none=10, few=35, some=90, heaps=30 },
      pictures = { few=20, some=80, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=30, few=50, some=20, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=25, few=40, some=25, heaps=15 },
      ambushes = { none=5, few=20, some=75, heaps=30 },
      teleporters = { none=20, few=30, some=65, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=70, heaps=25 },
      barrels = { none=10, few=50, some=20, heaps=5 }
    },

    liquids =
    {
      water2 = 40,
      water  = 50,
      lava   = 10,
      slime = 15,
      goo  = 10,
      elec = 10
    },

    narrow_halls =
    {
      vent = 50
    },

    wide_halls =
    {
      curve = 50,
      deuce = 50,
    },

    floor_sinks =
    {
      liquid_plain = 50
    },

    ceiling_sinks =
    {
      sky_plain = 50
    },

    fences =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      BLOCKY2 = 10,
    },

    cage_mats =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      BLOCKY2 = 10,
    },

    facades =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      BLOCKY2 = 10,
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 12,
    },

    fence_posts =
    {
      Post = 50
    },

    beam_groups =
    {
      beam_metal = 50
    },

    window_groups = 
    {
      straddle = 70,
      tall   = 80,
      grate  = 45,
      barred = 10,
      supertall = 60,
      slits = 20,
      pillbox = 20,
      slumpish = 30,
      window_crossfire = 10,
    },

    wall_groups =
    {
      PLAIN = 0.01,
      mid_band = 10,
      lite1 = 20,
      lite2 = 20,
      torches1 = 12,
      torches2 = 12,
      high_gap = 25,
      vert_gap = 25,
      wallgutters = 10,
      lamptorch = 16,
      runic = 10,
    },

    cave_torches =
    {
      rock = 50
    },

    outdoor_torches =
    {
      standing_lamp = 50
    },

    ceil_light_prob = 70,

    scenic_fences =
    {
      BRIDGE_RAIL = 80,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "CEIL5_1",

    post_mat  = "HW209"

  }

}


HACX.ROOM_THEMES =
{

  hacx_urban_Generic =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      BLOCKY2 = 10,
    },

    floors =
    {
      MODWALL3 = 50,
      STONY1 = 50,
      TECHY1 = 50,
      CAVEY1 = 50,
      BLOCKY1 = 50,
      WOODY1 = 50,
      WOOD_TILE = 50
    },

    ceilings =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      WOODY1 = 10,
    }
  },

  hacx_urban_Hallway_v2 =
  {
    env   = "hallway",
    group = "oblige_v2",
    prob = 50,

    walls =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      BLOCKY2 = 10,
    },

    floors =
    {
      MODWALL3 = 50,
      STONY1 = 50,
      TECHY1 = 50,
      CAVEY1 = 50,
      BLOCKY1 = 50,
      WOODY1 = 50,
      WOOD_TILE = 50
    },

    ceilings =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      WOODY1 = 10,
    }
  },

 hacx_urban_Hallway_curve =
  {
    env   = "hallway",
    group = "curve",
    prob = 50,

    walls =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      BLOCKY2 = 10,
    },

    floors =
    {
      MODWALL3 = 50,
      STONY1 = 50,
      TECHY1 = 50,
      CAVEY1 = 50,
      BLOCKY1 = 50,
      WOODY1 = 50,
      WOOD_TILE = 50
    },

    ceilings =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      WOODY1 = 10,
    }
  },

  hacx_urban_Hallway_deuce =
  {
    env   = "hallway",
    group = "deuce",
    prob = 50,

    walls =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      BLOCKY2 = 10,
    },

    floors =
    {
      MODWALL3 = 50,
      STONY1 = 50,
      TECHY1 = 50,
      CAVEY1 = 50,
      BLOCKY1 = 50,
      WOODY1 = 50,
      WOOD_TILE = 50
    },

    ceilings =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      WOODY1 = 10,
    }
  },

 hacx_urban_Hallway_vent =
  {
    env   = "hallway",
    group = "vent",
    prob = 50,

    walls =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      BLOCKY2 = 10,
    },

    floors =
    {
      MODWALL3 = 50,
      STONY1 = 50,
      TECHY1 = 50,
      CAVEY1 = 50,
      BLOCKY1 = 50,
      WOODY1 = 50,
      WOOD_TILE = 50
    },

    ceilings =
    {
      MODWALL3 = 30,
      STONY1 = 10,
      TECHY1 = 20,
      CAVEY1 = 10,
      BLOCKY1 = 30,
      WOODY1 = 10,
    }
  },

  hacx_urban_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      HERRING_1 = 50,
      GRAY_BRICK = 50
    },

    naturals =
    {
      GRAY_ROCK = 50,
      DIRTY1 = 50,
      GRASS1 = 50
    },

    porch_floors =
    {
      HERRING_1 = 50,
      GRAY_BRICK = 50
    },

  },

  hacx_urban_Cave =
  {
    env  = "cave",
    prob = 50,

    floors =
    {
      GRAY_ROCK = 50
    },

    walls =
    {
      GRAY_ROCK = 50
    }
  }

}
------------------------------------------------------------------------


HACX.ROOMS =
{
  GENERIC =
  {
    env = "any"
  },

  OUTSIDE =
  {
    env = "outdoor",
    prob = 50
  }

}


------------------------------------------------------------------------


OB_THEMES["hacx_urban"] =
{
  label = "Urban",
  game = "hacx",
  name_theme = "URBAN",
  mixed_prob = 50
}

