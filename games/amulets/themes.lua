------------------------------------------------------------------------
--  AMULETS THEMES
------------------------------------------------------------------------

AMULETS.SINKS =
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

AMULETS.THEMES =
{
  DEFAULTS =
  {

    keys =
    {

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


  amulets_city =
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
      nukage = 20,
      lava   = 10,
    },

    narrow_halls =
    {
      vent = 50
    },

    wide_halls =
    {
      curve = 50
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
      WALL1 = 50
    },

    cage_mats =
    {
      WALL1 = 50
    },

    facades =
    {
      WALL1 = 50
    },

    fence_groups =
    {
      PLAIN = 50
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
    },

    wall_groups =
    {
      PLAIN = 50,
      torches1 = 10
    },

    cave_torches =
    {

    },

    outdoor_torches =
    {

    },

    ceil_light_prob = 70,

    scenic_fences =
    {

    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "WALL1",

    post_mat  = "ROCK1"

  }

}


AMULETS.ROOM_THEMES =
{

  amulets_city_Generic =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      WALL1 = 50
    },

    floors =
    {
      WALL1 = 50
    },

    ceilings =
    {
      WALL1 = 50
    }
  },

  amulets_city_Hallway_curve =
  {
    env   = "hallway",
    group = "curve",
    prob = 50,

    walls =
    {
      WALL1 = 50
    },

    floors =
    {
      WALL1 = 50
    },

    ceilings =
    {
      WALL1 = 50
    }
  },

  amulets_city_Hallway_vent =
  {
    env   = "hallway",
    group = "vent",
    prob = 50,

    walls =
    {
      WALL1 = 50
    },

    floors =
    {
      WALL1 = 50
    },

    ceilings =
    {
      WALL1 = 50
    }
  },

  amulets_city_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      WALL1 = 50
    },

    naturals =
    {
      ROCK1 = 50
    },

    porch_floors =
    {
      WALL1 = 50
    },

  },

  amulets_city_Cave =
  {
    env  = "cave",
    prob = 50,

    floors =
    {
      ROCK1 = 50
    },

    walls =
    {
      ROCK1 = 50
    }
  }

}
------------------------------------------------------------------------


AMULETS.ROOMS =
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

OB_THEMES["amulets_city"] =
{
  label = "City",
  game = "amulets",
  name_theme = "URBAN",
  mixed_prob = 50
}
