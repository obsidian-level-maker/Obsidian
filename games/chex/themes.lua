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

    pool_depth = 24
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
      slime1 = 15,
      slime2 = 10
    },


    narrow_halls =
    {
      vent = 50
    },

    wide_halls =
    {
      deuce = 50
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
      square = 70,
      tall   = 30
    },

    wall_groups =
    {
      PLAIN = 50,
      torches1 = 10
    },

    cave_torches =
    {
      -- TODO
    },

    outdoor_torches =
    {
      -- TODO
    },

    ceil_light_prob = 70,

    scenic_fences =
    {
      VINE1 = 80 -- Find a better fence
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "CEIL5_1",

    post_mat  = "COMPSPAN"

  }

}


CHEX3.ROOM_THEMES =
{

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

    naturals =
    {
      SKSNAKE2 = 50,
      CJMINE02 = 15
    },

    porch_floors =
    {
      SKSNAKE2 = 50,
      CJMINE02 = 15
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
  }

}


------------------------------------------------------------------------


OB_THEMES["spaceport"] =
{
  label = _("Spaceport"),
  game = "chex3",
  name_class = "TECH",
  mixed_prob = 50
}

