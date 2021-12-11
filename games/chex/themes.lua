------------------------------------------------------------------------
--  CHEX3 THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

CHEX3.SINKS =
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
    mat = "WATER",
    dz  = -12
  },

  liquid_slime0 =
  {
    mat = "SLIME0",
    dz = -12
  },

  liquid_slime1 =
  {
    mat = "SLIME1",
    dz  = -12
  },

  liquid_slime2 =
  {
    mat = "SLIME2",
    dz  = -12
  },

  -- street sink def, do not use for anything else
  floor_default_streets =
  {
    mat = "CEIL5_1",
    dz = 2,
  
    trim_mat = "GRAYTALL",
    trim_dz = 2,
  }

}


CHEX3.THEMES =
{
  DEFAULTS =
  {

    keys =
    {
      k_yellow = 50,
      k_red = 50,
      k_blue = 50
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

  -- Episode 1 Theme by Cubebert --

  bazoik =
  {

   style_list =
    {
      caves = { none=80, few=12, some=5, heaps=3 },
      outdoors = { none=80, few=18, some=2 },
      pictures = { few=20, some=80, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=60, few=20, some=10, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=15, few=60, some=20, heaps=5 },
      ambushes = { none=5, few=50, some=45, heaps=30 },
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
      slime0 = 15,
      slime1 = 10
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
      liquid_slime0 = 50,
      liquid_slime1 = 25,
    },

    ceiling_sinks =
    {
      sky_plain = 50
    },

    fences =
    {
      LITE4_RAIL = 30,
    },

    cage_mats =
    {
      GRAY7 = 30,
      STARG3 = 10
    },

    facades =
    {
      GRAY7 = 50,
      STARG3 = 20,
      CEMENT5 = 5,
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
      green_torch = 50,
      green_torch_sm = 50
    },

    outdoor_torches =
    {
      -- TODO
    },

    ceil_light_prob = 70,

    scenic_fences =
    {
      LITE4_RAIL = 30,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "FLAT1_1",

    post_mat  = "FLOOR0_6"

  },

  spaceport =
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
      water = 50,
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
      SP_DUDE2 = 30,
      STONE3 = 10
    },

    cage_mats =
    {
      SP_DUDE2 = 30,
      STONE3 = 10
    },

    facades =
    {
      SP_DUDE2 = 30,
      STONE3 = 10,
      STONE = 20,
      GRAY7 = 10,
      STARG3 = 30,
      TEKWALL5 = 10,
      BROWN1 = 10
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
      green_torch = 50,
      green_torch_sm = 50
    },

    outdoor_torches =
    {
      -- TODO
    },

    ceil_light_prob = 70,

    scenic_fences =
    {
      METAL_FENCE = 80
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "CEIL5_1",

    post_mat  = "COMPSPAN"

  },

  sewer =
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
      slime1 = 15,
      slime2 = 10
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
      liquid_slime1 = 50,
      liquid_slime2 = 25,
    },

    ceiling_sinks =
    {
      sky_plain = 50
    },

    fences =
    {
      WOOD4 = 30,
      CJSHIP04 = 10
    },

    cage_mats =
    {
      CJSHIP02 = 30,
      CJSHIP05 = 10
    },

    facades =
    {
      CJSHIP02 = 50,
      CJSHIP05 = 20,
      CJSHIP03 = 5,
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
      green_torch = 50,
      green_torch_sm = 50
    },

    outdoor_torches =
    {
      -- TODO
    },

    ceil_light_prob = 70,

    fences =
    {
      LITE4_RAIL = 30,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "FLOOR0_1",

    post_mat  = "GRAY2"

  }
}

CHEX3.ROOM_THEMES =
{

  ---- BAZOIK THEME --------------------------------

  bazoik_Generic =
  {
    env  = "building",
    prob = 50,
  
    walls =
    {
      GRAY7 = 50,
      STARG3  = 15,
    },
  
    floors =
    {
      FLAT1_1 = 50,
      FLAT1 = 50,
      FLAT14 = 50,
      FLOOR0_2 = 50,
      STEP1 = 50
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      CEIL4_2 = 25,
      FLOOR0_6 = 25
    }
  },
  
  bazoik_vent_Hallway =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,
  
    walls =
    {
      GRAY7 = 50,
      STARG3  = 15,
    },
  
    floors =
    {
      FLAT1_1 = 50,
      FLAT1 = 50,
      FLAT14 = 50,
      FLOOR0_2 = 50,
      STEP1 = 50
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      CEIL4_2 = 25,
      FLOOR0_6 = 25
    }
  
  },
  
  bazoik_curve_Hallway =
  {
    env   = "hallway",
    group = "curve",
    prob  = 50,
  
    walls =
    {
      GRAY7 = 50,
      STARG3  = 15,
    },
  
    floors =
    {
      FLAT1_1 = 50,
      FLAT1 = 50,
      FLAT14 = 50,
      FLOOR0_2 = 50,
      STEP1 = 50
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      CEIL4_2 = 25,
      FLOOR0_6 = 25
    }
  
  },

  bazoik_deuce_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,
  
    walls =
    {
      GRAY7 = 50,
      STARG3  = 15,
    },
  
    floors =
    {
      FLAT1_1 = 50,
      FLAT1 = 50,
      FLAT14 = 50,
      FLOOR0_2 = 50,
      STEP1 = 50
    },
  
    ceilings =
    {
      FLAT14 = 50,
      CJFCOMM3 = 50,
      CEIL5_1 = 50,
      CEIL4_2 = 25,
      FLOOR0_6 = 25
    }
  
  },
  
  bazoik_Outdoors =
  {
    env  = "outdoor",
    prob = 50,
  
    floors =
    {
      CEIL3_1 = 50,
    },
  
    naturals =
    {
      BIGDOOR2 = 50,
      BAZOIK1 = 50
    },
  
    porch_floors =
    {
      FLAT1_1 = 50,
      CJFCOMM5 = 50,
      STEP1 = 15,
    },
  
  },
  
  bazoik_Cave =
  {
    env  = "cave",
    prob = 50,
  
    floors =
    {
      CEIL3_1 = 50,
    },
  
    walls =
    {
      BIGDOOR2 = 50,
      BAZOIK1 = 50
    }
  
  },


  ---- SPACEPORT THEME --------------------------------

  spaceport_Generic =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SP_DUDE2 = 30,
      STONE3 = 10,
      STONE = 20,
      GRAY7 = 10,
      STARG3 = 30,
      TEKWALL5 = 10,
      BROWN1 = 10
    },

    floors =
    {
      CEIL5_1 = 50,
      FLAT14 = 50,
      STARG3 = 50,
      CEIL4_1 = 50
    },

    ceilings =
    {
      CEIL4_1 = 50
    }
  },

  spaceport_vent_Hallway =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      SP_DUDE2 = 30,
      STONE3 = 10,
      STONE = 20,
      GRAY7 = 10,
      STARG3 = 30,
      TEKWALL5 = 10,
      BROWN1 = 10
    },

    floors =
    {
      CEIL5_1 = 50,
      FLAT14 = 50,
      STARG3 = 50,
      CEIL4_1 = 50
    },

    ceilings =
    {
      CEIL4_1 = 50
    }

  },

  spaceport_curve_Hallway =
  {
    env   = "hallway",
    group = "curve",
    prob  = 50,

    walls =
    {
      SP_DUDE2 = 30,
      STONE3 = 10,
      STONE = 20,
      GRAY7 = 10,
      STARG3 = 30,
      TEKWALL5 = 10,
      BROWN1 = 10
    },

    floors =
    {
      CEIL5_1 = 50,
      FLAT14 = 50,
      STARG3 = 50,
      CEIL4_1 = 50
    },

    ceilings =
    {
      CEIL4_1 = 50
    }

  },

  spaceport_deuce_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      SP_DUDE2 = 30,
      STONE3 = 10,
      STONE = 20,
      GRAY7 = 10,
      STARG3 = 30,
      TEKWALL5 = 10,
      BROWN1 = 10
    },

    floors =
    {
      CEIL5_1 = 50,
      FLAT14 = 50,
      STARG3 = 50,
      CEIL4_1 = 50
    },

    ceilings =
    {
      CEIL4_1 = 50
    }

  },

  spaceport_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLAT1 = 50,
      CEIL5_1 = 50,
      TEKWALL5 = 50
    },

    naturals =
    {
      FLOOR0_1 = 50
    },

    porch_floors =
    {
      FLAT1 = 50,
      CEIL5_1 = 50,
      TEKWALL5 = 50
    },

  },

  spaceport_Cave =
  {
    env  = "cave",
    prob = 50,

    floors =
    {
      SKSNAKE2 = 50,
      CJMINE02 = 15
    },

    walls =
    {
      SKSNAKE2 = 50,
      CJMINE02 = 15
    }

  },

---- SEWER THEME --------------------------------

sewer_Generic =
{
  env  = "building",
  prob = 50,

  walls =
  {
    GREEN_BRICK = 50,
    GRAY2  = 15,
  },

  floors =
  {
    CJFCRA02 = 50,
    CJFLOD05 = 50,
    ENDFLAT2 = 50,
    GREEN_TILE = 50
  },

  ceilings =
  {
    CJFCRA01 = 50,
    CJFCRA02 = 50,
    CJFVIL02 = 15,
  }
},

sewer_vent_Hallway =
{
  env   = "hallway",
  group = "vent",
  prob  = 50,

  walls =
  {
    GREEN_BRICK = 50,
    GRAY2  = 15,
    SEWERA = 15,
    GREEN_BORDER = 15,
  },

  floors =
  {
    CJFCRA02 = 50,
    CJFLOD05 = 50,
    ENDFLAT2 = 50,
    GREEN_TILE = 50
  },

  ceilings =
  {
    CJFCRA01 = 50,
    CJFCRA02 = 50,
    CJFVIL02 = 15,
  }

},

sewer_curve_Hallway =
{
  env   = "hallway",
  group = "curve",
  prob  = 50,

  walls =
  {
    GREEN_BRICK = 50,
    GRAY2  = 15,
    SEWERA = 15,
    SEWER2 = 15,
  },

  floors =
  {
    CJFCRA02 = 50,
    CJFLOD05 = 50,
    ENDFLAT2 = 50,
    GREEN_TILE = 50
  },

  ceilings =
  {
    CJFCRA01 = 50,
    CJFCRA02 = 50,
    CJFVIL02 = 15,
  }

},

sewer_deuce_Hallway =
{
  env   = "hallway",
  group = "deuce",
  prob  = 50,

  walls =
  {
    GREEN_BRICK = 50,
    GRAY2  = 15,
    SEWERA = 15,
    SEWER2 = 15,
  },

  floors =
  {
    CJFCRA02 = 50,
    CJFLOD05 = 50,
    ENDFLAT2 = 50,
    GREEN_TILE = 50
  },

  ceilings =
  {
    CJFCRA01 = 50,
    CJFCRA02 = 50,
    CJFVIL02 = 15,
  }

},

sewer_Outdoors =
{
  env  = "outdoor",
  prob = 50,

  floors =
  {
    CJFCRA01 = 50,
    CJFCRA02 = 50,
    CJFVIL02 = 15,
  },

  naturals =
  {
    CJFGRAS1 = 50,
    CJFLOD07 = 50,
    FLOOR0_1 = 50,
    CJFFLEM2 = 15,
  },

  porch_floors =
  {
    CJFCRA01 = 50,
    CJFCRA02 = 50,
    CJFVIL02 = 15,
  },

},

sewer_Cave =
{
  env  = "cave",
  prob = 50,

  floors =
  {
    CJFFLEM2 = 50,
    CJFFLEM3 = 50
  },

  walls =
  {
    CJMETE01 = 50,
  }

}


}
------------------------------------------------------------------------


CHEX3.ROOMS =
{
  GENERIC =
  {
    env = "any"
  },

  OUTSIDE =
  {
    env = "outdoor",
    prob = 50
  },

}


------------------------------------------------------------------------

OB_THEMES["bazoik"] =
{
  label = _("Bazoik"),
  game = "chex3",
  name_class = "TECH",
  mixed_prob = 50
}

OB_THEMES["spaceport"] =
{
  label = _("Spaceport"),
  game = "chex3",
  name_class = "TECH",
  mixed_prob = 50
}

OB_THEMES["sewer"] =
{
  label = _("Sewer"),
  game = "chex3",
  name_class = "TECH",
  mixed_prob = 50
}

