------------------------------------------------------------------------
--  WOLF3D THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
--  --Adapted from MsrSgtShooterPerson's Doom themes.lua file
    --Into a singular theme (Castle) for Heretic
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

WOLF.SINKS =
{
  --[[
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
    light = 16,
  },

  -- liquid floor --

  liquid_plain =
  {
    mat = "F_WATR01",
    dz  = -12,
  },

  -- street sink def, do not use for anything else
  floor_default_streets =
  {
    mat = "F_CHMOL2",
    dz = 2,
  
    trim_mat = "WOOD08",
    trim_dz = 2,
  }]]--

}


WOLF.THEMES =  -- May need to be called WOLF.LEVEL_THEMES per original lua - Dasho
{
  -- Main Themes:
  --
  -- 1. BUNKER --> brick/wood, humans, quarters, plants/urns
  -- 2. CELLS  --> blue_stone, dogs, skeletons
  -- 3. CAVE   --> cave/rock tex, vines, mutants

  wolf_bunker =
  {
    room_size_table = { 20,60,20,3 },

    building_walls =
    {
      BLU_BRIK=50,
      GSTONE1=30,
      WOOD1=30,
    },

    building_floors = { _FLOOR=50 },

--##    ceilings = { TMP_BLUE=50 },
--##
--##    courtyard_walls =
--##    {
--##      TMP_WOOD=30,
--##    },

    hallway =
    {
    },

    exit =
    {
    },

    room_types =
    {
      -- FIXME  COMPUTER  WAREHOUSE  PUMP
    },

    scenery =
    {
      -- FIXME
    },

  },


  --[[  FIXME FIXME
  BUNKER =
  {
    room_probs =
    {
      STORAGE = 50,
      TREASURE = 10, SUPPLIES = 15,
      QUARTERS = 50, BATHROOM = 15,
      KITCHEN = 30,  TORTURE = 20,
    },

    scenery =
    {
      suit_of_armor=50, flag=20,
    },
  },

  CELLS =
  {
    room_probs =
    {
      STORAGE = 40,
      TREASURE = 5,  SUPPLIES = 10,
      QUARTERS = 20, BATHROOM = 10,
      KITCHEN = 10,  TORTURE = 60,
    },

    scenery =
    {
      dead_guard=50, puddle=10,
    },

    monster_prefs =
    {
      dog=2.0, guard=2.0,
    },
  },

  CAVE =
  {
    room_probs =
    {
      STORAGE = 30,
      TREASURE = 15, SUPPLIES = 5,
      QUARTERS = 15, BATHROOM = 30,
      KITCHEN = 5,   TORTURE = 30,
    },

    scenery =
    {
      vines=90, spears=30,
    },

    monster_prefs =
    {
      mutant=4.0,
    },
  },
  --]]

--[[
  SECRET =
  {
    prob=0, -- special style, never chosen randomly

    room_probs =
    {
      STORAGE = 10,
      TREASURE = 90, SUPPLIES = 70,
      QUARTERS = 2,  BATHROOM = 2,
      KITCHEN = 20,  TORTURE = 2,
    },

    -- combo_probs : when missing, all have same prob
  },
--]]
}

WOLF.ROOM_THEMES =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    scenery = { ceil_light=90 },

    space_range = { 10, 50 },
  },

  STORAGE =
  {
    scenery = { barrel=50, green_barrel=80, }
  },

  TREASURE =
  {
    pickups = { cross=90, chalice=90, chest=20, crown=5 },
    pickup_rate = 90,
  },

  SUPPLIES =
  {
    scenery = { barrel=70, bed=40, },

    pickups = { first_aid=50, good_food=90, clip=70 },
    pickup_rate = 66,
  },

  QUARTERS =
  {
    scenery = { table_chairs=70, bed=70, chandelier=70,
                bare_table=20, puddle=20,
                floor_lamp=10, urn=10, plant=10
              },
  },

  BATHROOM =
  {
    scenery = { sink=50, puddle=90, water_well=30, empty_well=30 },
  },

  KITCHEN =
  {
    scenery = { kitchen_stuff=50, stove=50, pots=50,
                puddle=20, bare_table=20, table_chairs=5,
                sink=10, barrel=10, green_barrel=5, plant=2
              },

    pickups = { good_food=15, dog_food=5 },
    pickup_rate = 20,
  },

  TORTURE =
  {
    scenery = { hanging_cage=80, skeleton_in_cage=80,
                skeleton_relax=30, skeleton_flat=40,
                hanged_man=60, spears=10, bare_table=10,
                gibs_1=10, gibs_2=10,
                junk_1=10, junk_2=10,junk_3=10
              },
  },
}


--[[WOLF.ROOM_THEMES =
{
  any_Hallway =
  {
    env  = "hallway",
    prob = 1,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  any_Hallway_Deuce =
  {
    env  = "hallway",
    group = "deuce",
    prob = 1,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  any_Hallway_Vent =
  {
    env  = "hallway",
    group = "vent",
    prob = 1,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  any_Gray =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  any_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_CAVE01 = 50,
    },

    naturals =
    {
      F_CAVE01 = 50,
    },

    porch_floors =
    {
      F_CAVE01 = 50,
    },

  },

  any_Cave =
  {
    env  = "cave",
    prob = 50,

    floors =
    {
      F_CAVE01 = 50,
    },

    walls =
    {
      F_CAVE01 = 50,
    },

  },

}]]--
------------------------------------------------------------------------


WOLF.ROOMS =
{
  GENERIC =
  {
    env = "any",
  },

  OUTSIDE =
  {
    env = "outdoor",
    prob = 50,
  },

}


------------------------------------------------------------------------

OB_THEMES["wolf_bunker"] =
{
  label = _("Bunker"),
  game = "wolf3d",
  name_theme = "URBAN",
  mixed_prob = 50,
}
