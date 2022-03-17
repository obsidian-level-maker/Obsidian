------------------------------------------------------------------------
--  HEXEN THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--  Adapted to Oblige 7.7x by Dashodanger
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HEXEN.SINKS =
{
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
    light = 16,
  },

-- sky ceilings

  sky_ceiling =
  {
    mat   = "_SKY",
    dz    = 48,
    light = 16,

    trim_mat = "_WALL",
    trim_dz  = -9,
    trim_light = 16,
  },

  -- liquid floor --

  liquid_plain =
  {
    mat = "_LIQUID",
    dz  = -12,
  },

  liquid_trim =
  {
    mat   = "_LIQUID",
    dz    = -16,

    trim_mat = "_WALL",
    trim_dz  = -8,
  },

  -- ceiling lights --


  light_plain =
  {
    mat = "_FLOOR",
    dz  = 8,
    light = 32,

    trim_mat = "_WALL",
    trim_dz  = -5,
    trim_light = 16,
  },

-- plain ceilings

  ceiling_plain =
  {
    mat   = "_CEIL",
    dz    = 64,
    light = 16,
  },

-- plain floors

  floor_plain =
  {
    mat = "_FLOOR",
    dz = -16,
    light = 32,

    trim_mat = "_WALL",
    trim_dz = -8,
  },

  -- fantastic floors

  floor_trim_sky =
  {
    mat = "_FLOOR",

    trim_mat = "_SKY",
    trim_dz = -8,
  },

  floor_trim_liquid =
  {
    mat = "_FLOOR",
    dz = -4,

    trim_mat = "_LIQUID",
    trim_dz = -8,
  },

  floor_mixup =
  {
    mat = "_CEIL",
    dz = -8,

    trim_mat = "_WALL",
    trim_dz = -4,
  },

  -- street sink def, do not use for anything else
  floor_default_streets =
  {
    mat = "F_039",
    dz = 2,

    trim_mat = "CAVE04",
    trim_dz = 2,
  }
}

HEXEN.THEMES =
{
  DEFAULTS =
  {
    keys =
    {
      k_axe = 50,
      k_cave = 50,
      k_steel = 50,
    },

    skyboxes =
    {

    },

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

    street_sinks =
    {
      floor_default_streets = 1
    }

  },

    dungeon =
    {

      floor_sinks =
      {
        floor_plain = 50,
        liquid_plain = 40,
        liquid_trim = 40,
        floor_trim_sky = 5,
        floor_trim_liquid = 5,
        floor_mixup = 5,
      },
  
      ceiling_sinks =
      {
        ceiling_plain = 50,
        --sky_plain = 50,
        --sky_ceiling = 50,
        light_plain = 25,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
        crenels = 12,
      },

      beam_groups =
      {
        beam_metal = 50,
      },

      narrow_halls =
      {
        vent = 50,
      },
  
      wide_halls =
      {
        curve = 50,
        deuce = 50,
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
        window_arched = 10,
        window_arched_tall = 10,
        window_arched_inverted = 10
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

      fences =
      {
        CASTLE07=35,
        CASTLE11=25,
        FOREST01=10,
        MONK16=25,
      },

      cage_mats =
      {
        CASTLE07=35,
        CASTLE11=25,
        FOREST01=10,
        MONK16=25,
      },

      scenic_fences =
      {
        GATE01 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {
        CASTLE07=35,
        CASTLE11=25,
        CAVE02=15,
        MONK01=20,
        MONK02=20,
        MONK08=15,
        PRTL02=10,
        PRTL03=5,
        FOREST01=10,
        MONK16=25,
      },

      liquids =
      {
        water  = 50,
        lava   = 10,
        muck   = 20,
      },

      monster_prefs =
      {
        wendigo = 0,
        serpent1 = 0,
        serpent2 = 0
      },

      cave_torches =
      {
        twine_torch = 50,
      },
  
      cliff_trees =
      {
        lean_tree1 = 80,
        lean_tree2 = 80,
      },
  
      park_decor =
      {
        lean_tree1 = 80,
        lean_tree2 = 80,
      },

      sky_mapinfo =
      {
        sky_patch1 = "SKYWALL",
        sky_speed1 = 0,
        sky_patch2 = "SKY1",
        sky_speed2 = 40,
        doublesky = true,
      },

      steps_mat = "F_011",

      post_mat  = "_STRUCT",

    },

    fire_steel =
    {

      floor_sinks =
      {
        floor_plain = 50,
        liquid_plain = 40,
        liquid_trim = 40,
        floor_trim_sky = 5,
        floor_trim_liquid = 5,
        floor_mixup = 5,
      },
  
      ceiling_sinks =
      {
        ceiling_plain = 50,
        --sky_plain = 50,
        --sky_ceiling = 50,
        light_plain = 25,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
        crenels = 12,
      },

      beam_groups =
      {
        beam_metal = 50,
      },

      narrow_halls =
      {
        vent = 50,
      },
  
      wide_halls =
      {
        curve = 50,
        deuce = 50,
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
        window_arched = 10,
        window_arched_tall = 10,
        window_arched_inverted = 10
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

      fences =
      {
        STEEL01=40,
        STEEL02=10,
        STEEL05=10,
        STEEL06=15,
        STEEL07=5,
        STEEL08=5,
      },

      cage_mats =
      {
        STEEL01=40,
        STEEL02=10,
        STEEL05=10,
        STEEL06=15,
        STEEL07=5,
        STEEL08=5,
      },

      scenic_fences =
      {
        GATE01 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {
        FIRE06=15,
        FIRE07=15,
        FIRE08=10,
        FIRE09=10,
        FIRE10=10,
        FIRE11=10,
        FIRE12=10,
        STEEL01=40,
        STEEL02=10,
        STEEL05=10,
        STEEL06=15,
        STEEL07=5,
        STEEL08=5,
      },

      monster_prefs =
      {
        wendigo = 0,
        serpent1 = 0,
        serpent2 = 0
      },

      liquids =
      {
        lava   = 10,
      },

      cave_torches =
      {
        twine_torch = 50,
      },
  
      cliff_trees =
      {
        burnt_stump = 80,
      },
  
      park_decor =
      {
        burnt_stump = 80,
      },

      sky_mapinfo =
      {
        sky_patch1 = "SKYWALL",
        sky_speed1 = 0,
        sky_patch2 = "SKY4",
        sky_speed2 = 25,
        doublesky = true
      },

      steps_mat = "F_013",

      post_mat  = "_STRUCT",
    },

    ice_caves =
    {

      floor_sinks =
      {
        floor_plain = 50,
        liquid_plain = 40,
        liquid_trim = 40,
        floor_trim_sky = 5,
        floor_trim_liquid = 5,
        floor_mixup = 5,
      },
  
      ceiling_sinks =
      {
        ceiling_plain = 50,
        --sky_plain = 50,
        --sky_ceiling = 50,
        light_plain = 25,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
        crenels = 12,
      },

      beam_groups =
      {
        beam_metal = 50,
      },

      narrow_halls =
      {
        vent = 50,
      },
  
      wide_halls =
      {
        curve = 50,
        deuce = 50,
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
        window_arched = 10,
        window_arched_tall = 10,
        window_arched_inverted = 10
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

      fences =
      {
        ICE01=10,
        ICE06=50,
        CAVE03 = 10,
        CAVE04 = 10,
        CAVE06 = 10
      },

      cage_mats =
      {
        ICE01=15,
        ICE02=30,
        ICE03=5,
        ICE06=25,
        CAVE03 = 10,
        CAVE04 = 10,
        CAVE06 = 10
      },

      scenic_fences =
      {
        GATE01 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {
        ICE01=10,
        ICE06=50,
        CAVE03 = 10,
        CAVE04 = 10,
        CAVE06 = 10
      },

      liquids =
      {
        icefloor   = 10,
      },

      monster_prefs =
      {
        serpent1 = 0,
        serpent2 = 0
      },

      cave_torches =
      {
        twine_torch = 50,
      },
  
      cliff_trees =
      {
        ice_stal_F_big    = 80,
        ice_stal_F_medium = 80,
        ice_stal_F_small  = 80,
        ice_stal_F_tiny = 80,
      },
  
      park_decor =
      {
        ice_stal_F_big    = 80,
        ice_stal_F_medium = 80,
        ice_stal_F_small  = 80,
        ice_stal_F_tiny = 80,
      },

      sky_mapinfo =
      {
        sky_patch1 = "SKY3",
        sky_speed1 = 0,
        sky_patch2 = "SKY2",
        sky_speed2 = 25,
        doublesky = true
      },

      steps_mat = "F_039",

      post_mat  = "_STRUCT",
    },

    swamp =
    {

      floor_sinks =
      {
        floor_plain = 50,
        liquid_plain = 40,
        liquid_trim = 40,
        floor_trim_sky = 5,
        floor_trim_liquid = 5,
        floor_mixup = 5,
      },
  
      ceiling_sinks =
      {
        ceiling_plain = 50,
        --sky_plain = 50,
        --sky_ceiling = 50,
        light_plain = 25,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
        crenels = 12,
      },

      beam_groups =
      {
        beam_metal = 50,
      },

      narrow_halls =
      {
        vent = 50,
      },
  
      wide_halls =
      {
        curve = 50,
        deuce = 50,
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
        window_arched = 10,
        window_arched_tall = 10,
        window_arched_inverted = 10
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

      fences =
      {
        SWAMP01=20,
        SWAMP03=20,
        SWAMP04=20,
        FOREST07=10,
        CAVE03=10,
        CAVE04=10,
        CAVE05=10,
        CAVE06=10,
        WASTE02=5,
      },

      cage_mats =
      {
        SWAMP01=20,
        SWAMP03=20,
        SWAMP04=20,
        FOREST07=10,
        CAVE03=10,
        CAVE04=10,
        CAVE05=10,
        CAVE06=10,
        WASTE02=5,
      },

      scenic_fences =
      {
        SEWER_BAR3 = 50,
        SEWER_BAR4 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {
        SWAMP01=20,
        SWAMP03=20,
        SWAMP04=20,
        FOREST07=10,
        CAVE03=10,
        CAVE04=10,
        CAVE05=10,
        CAVE06=10,
        WASTE02=5,
      },

      monster_prefs =
      {
        wendigo = 0
      },

      liquids =
      {
        muck   = 10,
      },

      cave_torches =
      {
        twine_torch = 50,
      },
  
      cliff_trees =
      {
        tree2 = 80,
        tree3 = 80,
      },
  
      park_decor =
      {
        tree2 = 80,
        tree3 = 80,
      },

      sky_mapinfo =
      {
        sky_patch1 = "SKYFOG2",
        sky_speed1 = 10,
        sky_patch2 = "SKYFOG",
        sky_speed2 = 30,
        doublesky = true,
        fadetable = true
      },

      steps_mat = "F_019",

      post_mat  = "_STRUCT",
    },

    forest =
    {

      floor_sinks =
      {
        floor_plain = 50,
        liquid_plain = 40,
        liquid_trim = 40,
        floor_trim_sky = 5,
        floor_trim_liquid = 5,
        floor_mixup = 5,
      },
  
      ceiling_sinks =
      {
        ceiling_plain = 50,
        --sky_plain = 50,
        --sky_ceiling = 50,
        light_plain = 25,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
        crenels = 12,
      },

      beam_groups =
      {
        beam_metal = 50,
      },

      narrow_halls =
      {
        vent = 50,
      },
  
      wide_halls =
      {
        curve = 50,
        deuce = 50,
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
        window_arched = 10,
        window_arched_tall = 10,
        window_arched_inverted = 10
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

      fences =
      {
        FOREST01=40,
        FOREST02=10,
        WINN01=30,
        WOOD01=5,
        VILL04=10,
        VILL05=10,
      },

      cage_mats =
      {
        FOREST01=40,
        FOREST02=10,
        WINN01=30,
        WOOD01=5,
        VILL04=10,
        VILL05=10,
      },

      scenic_fences =
      {
        BAMBOO_6 = 50,
        BAMBOO_7 = 50,
        BAMBOO_8 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {
        FOREST01=40,
        FOREST02=10,
        WINN01=30,
        WOOD01=5,
        VILL04=10,
        VILL05=10,
      },

      liquids =
      {
        muck   = 10,
        water  = 10
      },

      monster_prefs =
      {
        wendigo = 0,
        serpent1 = 0,
        serpent2 = 0
      },

      cave_torches =
      {
        twine_torch = 50,
      },
  
      cliff_trees =
      {
        xmas_tree = 80,
      },
  
      park_decor =
      {
        xmas_tree = 80,
      },

      sky_mapinfo =
      {
        sky_patch1 = "SKY2",
        sky_speed1 = 10,
        sky_patch2 = "SKY3",
        sky_speed2 = 10,
        lightning_chance = 30
      },

      steps_mat = "F_055",

      post_mat  = "_STRUCT",
    },

}



-- TODO / FIXME:  Split-off various special/novelty walls, further split many themes, and
-- remove many excessiv or poorly picked floor/cieling (and a few wall) textures, JB.
HEXEN.ROOM_THEMES =
{
  -- This is the monestary / palacial castle type dungeon

    dungeon_monktan =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      MONK02=40,
      MONK03=15,
      MONK16=15,
    },

    floors =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_077=10,
      F_089=12,
    },

    ceilings =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_092=5,
    },

  },

    dungeon_monktan_large =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      MONK14=35,
      MONK15=15,
      MONK16=5,
      MONK17=3,
      MONK18=2,
    },

    floors =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_077=10,
      F_089=12,
    },

    ceilings =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_092=5,
    },

  },

  dungeon_monkgray =
  {
   env  = "building",
   prob = 50,

    walls =
    {
      MONK01=30,
    },

    floors =
    {
      F_009=30,
      F_012=40,
      F_030=10,
      F_031=15,
      F_042=8,
      F_043=4,
      F_048=9,
      F_057=5,
      F_073=3,
      F_089=12,
    },

    ceilings =
    {
      F_009=30,
      F_012=40,
      F_031=25,
      F_041=3,
      F_042=8,
      F_043=4,
      F_048=9,
      F_057=5,
      F_089=12,
      F_092=5,
    },

  },

  dungeon_monkrosette =
  {

    walls =
    {
      MONK07=35,
      MONK08=10,
    },

    floors =
    {
      F_031=50,
    },

    ceilings =
    {
      F_031=50,
    },

    },

  dungeon_portals1 =
  {

    walls =
    {
      PRTL04=40,
      PRTL05=25,
    },

    floors =
    {
      F_010=25,
      F_044=50,
      F_089=10,
    },

    ceilings =
    {
      F_010=25,
      F_044=50,
    },

  },

  dungeon_portals2 =
  {
    walls =
    {
      PRTL02=30,
      PRTL03=5,
        },

    floors =
    {
      F_010=25,
      F_044=50,
      F_089=10,
    },

    ceilings =
    {
      F_010=25,
      F_044=50,
    },

  },

  -- This is the dark, dank dungeon type of crumbling castles, cemetaries,
  -- crypts, sewers, and of course, dungeons.

  dungeon_tomb1 =
  {
    walls =
    {
      TOMB04=15,
      TOMB02=15,
      TOMB01=5,
      TOMB02=5,
      --GRAVE01=2,
    },

    floors =
    {
      F_009=10,
      F_012=25,
      F_013=25,
      F_031=5,
      F_042=5,
      F_043=5,
      F_045=5,
      F_077=10,
      F_089=5,
    },

    ceilings =
    {
      F_009=10,
      F_012=25,
      F_013=25,
      F_031=5,
      F_042=5,
      F_043=5,
      F_045=5,
      F_077=10,
      F_089=5,
    },

  },

  dungeon_tomb2 =
  {
    walls =
    {
      TOMB05=45,
      TOMB06=5,
  },

    floors =
  {
      F_046=5,
      F_047=5,
      F_059=70,
      F_077=15,
      F_089=5,
    },

    ceilings =
    {
      F_046=5,
      F_047=5,
      F_059=70,
      F_077=15,
      F_089=5,
    },

  },

  dungeon_tomb3 =
  {
    walls =
    {
      TOMB07=25,
      TOMB11=10,
      --GRAVE01=2,
    },

    floors =
    {
      F_046=25,
      F_047=15,
      F_048=10,
    },

    ceilings =
    {
      F_046=25,
      F_047=15,
      F_048=10,
    },

  },

  dungeon_castle_gray =
  {

    walls =
    {
      CASTLE07=35,
      CAVE02=15,
      PRTL03=5,
    },

    floors =
    {
      F_009=10,
      F_012=10,
      F_013=10,
      F_015=10,
      F_022=10,
      F_076=5,
    },

    ceilings =
    {
      F_009=10,
      F_012=10,
      F_013=10,
      F_015=10,
      F_022=10,
      F_076=5,
    },

  },

  dungeon_castle_gray_small =
  {

    walls =
    {
      CASTLE01=20,
      CAVE07=5,
      -- Next, some novelty patterns that should be used rarely
      --CASTLE02=1,
      --CASTLE03=1,
      --CASTLE06=1,
    },

    floors =
    {
      F_008=25,
      F_009=10,
      F_012=10,
      F_013=10,
      F_015=10,
      F_022=10,
      F_076=5,
    },

    ceilings =
    {
      F_008=25,
      F_009=10,
      F_012=10,
      F_013=10,
      F_015=10,
      F_022=10,
      F_076=5,
    },

  },

  dungeon_castle_gray_chains =
  { -- These patterns are pretyy much the same as castle01 (but with chains) -- should the be separate?  JB

    walls =
    {
      CASTLE02=1,
      CASTLE03=1,
      CASTLE06=1,
    },

    floors =
    {
      F_008=25,
      F_009=10,
      F_012=10,
      F_013=10,
      F_015=10,
      F_022=10,
      F_076=5,
    },

    ceilings =
    {
      F_008=25,
      F_009=10,
      F_012=10,
      F_013=10,
      F_015=10,
      F_022=10,
      F_076=5,
    },

  },

  dungeon_castle_yellow =
  {
    walls =
    {
      CASTLE11=25,
      CAVE01=10,
      WINN01=5,
    },

    floors =
    {
      F_011=5,
      F_014=35,
      F_025=15,
      F_028=10,
      F_029=10,
    },

    ceilings =
  {
      F_011=5,
      F_014=35,
      F_025=15,
      F_028=10,
      F_029=10,
    },

  },

  dungeon_library =
  {

    walls =
    { -- When/if prefab bookshelve are available, the walls should usuallty not be books, JB
      --MONK01=10,
      --MONK02=10,
      --CASTLE11=10,
      --WOOD01=25,
      --WOOD01=5,
      BOOKS01=15,
      BOOKS02=10,
    },

    floors =
    {
      F_010=15,
      F_024=15,
      F_030=5,
      F_054=15,
      F_055=15,
      F_089=5,
      F_092=15,
    },

    ceilings =
    {
      F_010=10,
      F_024=10,
      F_030=5,
      F_054=20,
      F_055=20,
      F_089=5,
      F_092=20,
    },
  },

  dungeon_sewer1 =
  {
    walls =
    {
      SEWER01=25,
      SEWER05=5,
      SEWER06=5,
      SEWER02=1,
    },

    floors =
    {
      F_017=10,
      F_018=10,
      F_021=12,
      F_022=15,
      F_023=3,
    },

    ceilings =
    {
      F_017=10,
      F_018=10,
      F_021=10,
      F_022=10,
      F_023=10,
    },

  },

  dungeon_sewer2 =
  {

    walls =
    {
      SEWER07=15,
      --SEWER08=15,
      SEWER09=1,
      SEWER10=1,
      SEWER11=1,
      SEWER12=1,
    },

    floors =
    {
      F_017=10,
      F_018=10,
      F_021=12,
      F_022=15,
      F_023=3,
    },

    ceilings =
    {
      F_017=10,
      F_018=10,
      F_021=10,
      F_022=10,
      F_023=10,
    },

  },

  dungeon_sewer_metal =
  {

    walls =
    {
      STEEL01=25,
      STEEL02=5,
    },

    floors =
    {
      F_073=10,
      F_074=50,
      F_075=25,
      F_021=5,
    },

    ceilings =
    {
      F_073=10,
      F_074=50,
      F_075=25,
      F_021=10,
      F_023=10,
    },

  },

  dungeon_v2_Hallway_Monktan =
  {
    env   = "hallway",
    group = "oblige_v2",
    prob  = 50,

    walls =
    {
      MONK02=40,
      MONK03=15,
      MONK16=15,
    },

    floors =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_077=10,
      F_089=12,
    },

    ceilings =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_092=5,
    },

  },

  dungeon_deuce_Hallway_Monktan =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      MONK02=40,
      MONK03=15,
      MONK16=15,
    },

    floors =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_077=10,
      F_089=12,
    },

    ceilings =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_092=5,
    },

  },

  dungeon_curve_Hallway_Monktan =
  {
    env   = "hallway",
    group = "curve",
    prob  = 50,

    walls =
    {
      MONK02=40,
      MONK03=15,
      MONK16=15,
    },

    floors =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_077=10,
      F_089=12,
    },

    ceilings =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_092=5,
    },

  },

  dungeon_vent_Hallway_Monktan =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      MONK02=40,
      MONK03=15,
      MONK16=15,
    },

    floors =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_077=10,
      F_089=12,
    },

    ceilings =
    {
      F_011=20,
      F_014=8,
      F_025=15,
      F_028=10,
      F_029=10,
      F_092=5,
    },

  },

  dungeon_outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_024=75,
      F_034=50,
      F_001=10,
      F_002=10,
      F_004=10,
      F_005=10,
      F_006=10,
      F_007=10,
      F_010=2,
      F_011=4,
      F_025=3,
      F_028=2,
      F_029=2,
      F_030=2,
      F_031=2,
      F_046=2,
      F_047=2,
      F_048=2,
      F_057=1,
      F_059=2,
      F_077=2,
      F_089=2,
      F_012=2,
      F_014=2,
    },

    naturals =
    {
      WASTE02=50,
      WASTE01=20,
      CAVE05=40,
    },

    porch_floors =
    {
      F_024=75,
      F_034=50,
      F_001=10,
      F_002=10,
      F_004=10,
      F_005=10,
      F_006=10,
      F_007=10,
      F_010=2,
      F_011=4,
      F_025=3,
      F_028=2,
      F_029=2,
      F_030=2,
      F_031=2,
      F_046=2,
      F_047=2,
      F_048=2,
      F_057=1,
      F_059=2,
      F_077=2,
      F_089=2,
      F_012=2,
      F_014=2,
    },

  },

  -- This is the element fire, as in "The Guardian or fire" in Raven's original wad.
  fire_steel_room1 =
  {
    env  = "building",
    prob = 50,
    walls =
    {
      FIRE06=15,
      FIRE07=15,
      FIRE08=10,
      FIRE09=10,
      FIRE10=10,
      FIRE11=10,
      FIRE12=10,
    },

    floors =
    {
      F_013=25,
      F_032=5,
      F_040=4,
      F_044=1,
      F_082=5,
    },

    ceilings =
    {
      F_013=25,
      F_032=5,
      F_040=4,
      F_044=1,
      F_082=5,
    },

  },

  fire_steel_Hallway_v2_room1 =
  {
    env   = "hallway",
    group = "oblige_v2",
    prob  = 50,
    walls =
    {
      FIRE06=15,
      FIRE07=15,
      FIRE08=10,
      FIRE09=10,
      FIRE10=10,
      FIRE11=10,
      FIRE12=10,
    },

    floors =
    {
      F_013=25,
      F_032=5,
      F_040=4,
      F_044=1,
      F_082=5,
    },

    ceilings =
    {
      F_013=25,
      F_032=5,
      F_040=4,
      F_044=1,
      F_082=5,
    },
  },

  fire_steel_Hallway_vent_room1 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,
    walls =
    {
      FIRE06=15,
      FIRE07=15,
      FIRE08=10,
      FIRE09=10,
      FIRE10=10,
      FIRE11=10,
      FIRE12=10,
    },

    floors =
    {
      F_013=25,
      F_032=5,
      F_040=4,
      F_044=1,
      F_082=5,
    },

    ceilings =
    {
      F_013=25,
      F_032=5,
      F_040=4,
      F_044=1,
      F_082=5,
    },
  },

  fire_steel_Hallway_curve_room1 =
  {
    env   = "hallway",
    group = "curve",
    prob  = 50,
    walls =
    {
      FIRE06=15,
      FIRE07=15,
      FIRE08=10,
      FIRE09=10,
      FIRE10=10,
      FIRE11=10,
      FIRE12=10,
    },

    floors =
    {
      F_013=25,
      F_032=5,
      F_040=4,
      F_044=1,
      F_082=5,
    },

    ceilings =
    {
      F_013=25,
      F_032=5,
      F_040=4,
      F_044=1,
      F_082=5,
    },
  },

  fire_steel_Hallway_deuce_room1 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,
    walls =
    {
      FIRE06=15,
      FIRE07=15,
      FIRE08=10,
      FIRE09=10,
      FIRE10=10,
      FIRE11=10,
      FIRE12=10,
    },

    floors =
    {
      F_013=25,
      F_032=5,
      F_040=4,
      F_044=1,
      F_082=5,
    },

    ceilings =
    {
      F_013=25,
      F_032=5,
      F_040=4,
      F_044=1,
      F_082=5,
    },
  },

  fire_steel_room2 =
  {
    env  = "building",
    prob = 50,
    walls =
    {
      FIRE01=30,
      FIRE05=10,
    },

    floors =
    {
      F_032=25,
      F_040=5,
      F_082=5,
    },

    ceilings =
    {
      F_032=25,
      F_040=5,
      F_082=5,
    },

  },

  fire_steel_Hallway_v2_room2 =
  {
    env   = "hallway",
    group = "oblige_v2",
    prob  = 50,
    walls =
    {
      FIRE01=30,
      FIRE05=10,
    },

    floors =
    {
      F_032=25,
      F_040=5,
      F_082=5,
    },

    ceilings =
    {
      F_032=25,
      F_040=5,
      F_082=5,
    },

  },

  fire_steel_Hallway_vent_room2 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,
    walls =
    {
      FIRE01=30,
      FIRE05=10,
    },

    floors =
    {
      F_032=25,
      F_040=5,
      F_082=5,
    },

    ceilings =
    {
      F_032=25,
      F_040=5,
      F_082=5,
    },

  },

  fire_steel_Hallway_curve_room2 =
  {
    env   = "hallway",
    group = "curve",
    prob  = 50,
    walls =
    {
      FIRE01=30,
      FIRE05=10,
    },

    floors =
    {
      F_032=25,
      F_040=5,
      F_082=5,
    },

    ceilings =
    {
      F_032=25,
      F_040=5,
      F_082=5,
    },

  },

  fire_steel_Hallway_deuce_room2 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,
    walls =
    {
      FIRE01=30,
      FIRE05=10,
    },

    floors =
    {
      F_032=25,
      F_040=5,
      F_082=5,
    },

    ceilings =
    {
      F_032=25,
      F_040=5,
      F_082=5,
    },

  },

  -- This is the "element" steel, as in "The Guardian or steel" in Raven's original wad.
  fire_steel_room_mix =
  { -- Not technically right, but works for what it does ;-) JB
    env = "building",
    prob = 50,
    walls =
    {
      STEEL01=40,
      STEEL02=10,
      STEEL05=1,  -- This one should be rare, since also the door texture, JB
      STEEL06=15,
      STEEL07=5,
      STEEL08=5,
    },

    floors =
    {
      F_065=10,
      F_066=10,
      F_067=10,
      F_068=10,
      F_069=15,
      F_070=15,
      F_074=40,
      F_075=15,
      F_078=10,
    },

    ceilings =
    {
      F_065=10,
      F_066=10,
      F_067=10,
      F_068=10,
      F_069=15,
      F_070=15,
      F_074=40,
      F_075=15,
      F_078=10,
    },

  },

  fire_steel_Hallway_v2_room_mix =
  { -- Not technically right, but works for what it does ;-) JB
    env = "hallway",
    group = "oblige_v2",
    prob = 50,
    walls =
    {
      STEEL01=40,
      STEEL02=10,
      STEEL05=1,  -- This one should be rare, since also the door texture, JB
      STEEL06=15,
      STEEL07=5,
      STEEL08=5,
    },

    floors =
    {
      F_065=10,
      F_066=10,
      F_067=10,
      F_068=10,
      F_069=15,
      F_070=15,
      F_074=40,
      F_075=15,
      F_078=10,
    },

    ceilings =
    {
      F_065=10,
      F_066=10,
      F_067=10,
      F_068=10,
      F_069=15,
      F_070=15,
      F_074=40,
      F_075=15,
      F_078=10,
    },

  },

  fire_steel_Hallway_vent_room_mix =
  { -- Not technically right, but works for what it does ;-) JB
    env = "hallway",
    group = "vent",
    prob = 50,
    walls =
    {
      STEEL01=40,
      STEEL02=10,
      STEEL05=1,  -- This one should be rare, since also the door texture, JB
      STEEL06=15,
      STEEL07=5,
      STEEL08=5,
    },

    floors =
    {
      F_065=10,
      F_066=10,
      F_067=10,
      F_068=10,
      F_069=15,
      F_070=15,
      F_074=40,
      F_075=15,
      F_078=10,
    },

    ceilings =
    {
      F_065=10,
      F_066=10,
      F_067=10,
      F_068=10,
      F_069=15,
      F_070=15,
      F_074=40,
      F_075=15,
      F_078=10,
    },

  },

  fire_steel_Hallway_curve_room_mix =
  { -- Not technically right, but works for what it does ;-) JB
    env = "hallway",
    group = "curve",
    prob = 50,
    walls =
    {
      STEEL01=40,
      STEEL02=10,
      STEEL05=1,  -- This one should be rare, since also the door texture, JB
      STEEL06=15,
      STEEL07=5,
      STEEL08=5,
    },

    floors =
    {
      F_065=10,
      F_066=10,
      F_067=10,
      F_068=10,
      F_069=15,
      F_070=15,
      F_074=40,
      F_075=15,
      F_078=10,
    },

    ceilings =
    {
      F_065=10,
      F_066=10,
      F_067=10,
      F_068=10,
      F_069=15,
      F_070=15,
      F_074=40,
      F_075=15,
      F_078=10,
    },

  },

  fire_steel_Hallway_deuce_room_mix =
  { -- Not technically right, but works for what it does ;-) JB
    env = "hallway",
    group = "deuce",
    prob = 50,
    walls =
    {
      STEEL01=40,
      STEEL02=10,
      STEEL05=1,  -- This one should be rare, since also the door texture, JB
      STEEL06=15,
      STEEL07=5,
      STEEL08=5,
    },

    floors =
    {
      F_065=10,
      F_066=10,
      F_067=10,
      F_068=10,
      F_069=15,
      F_070=15,
      F_074=40,
      F_075=15,
      F_078=10,
    },

    ceilings =
    {
      F_065=10,
      F_066=10,
      F_067=10,
      F_068=10,
      F_069=15,
      F_070=15,
      F_074=40,
      F_075=15,
      F_078=10,
    },

  },

  fire_steel_outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_013=5,
      F_032=30,
      F_040=25,
      F_044=4,
      F_082=20,
      F_073=5,
    },

    naturals =
    {
      FIRE01=30,
      FIRE05=10,
      FIRE06=15,
      FIRE07=15,
      FIRE08=10,
      FIRE09=10,
      FIRE10=10,
      FIRE11=10,
      FIRE12=10,
      STEEL01=40,
      STEEL02=10,
      STEEL05=10,
      STEEL06=15,
      STEEL07=5,
      STEEL08=5,
    },

    porch_floors =
    {
      F_013=5,
      F_032=30,
      F_040=25,
      F_044=4,
      F_082=20,
      F_073=5,
    },

  },

  -- This is the "element" ice
  ice_caves_room1 =
  {
    env  = "building",
    prob = 50,
    walls =
    {
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

    floors =
    {
      F_013=40,
      F_040=30,
    },

    ceilings =
    {
      F_013=40,
      F_040=30,
    },


  },

  ice_caves_Hallway_v2_room1 =
  {
    env  = "hallway",
    group = "oblige_v2",
    prob = 50,
    walls =
    {
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

    floors =
    {
      F_013=40,
      F_040=30,
    },

    ceilings =
    {
      F_013=40,
      F_040=30,
    },

  },

  ice_caves_Hallway_vent_room1 =
  {
    env  = "hallway",
    group = "vent",
    prob = 50,
    walls =
    {
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

    floors =
    {
      F_013=40,
      F_040=30,
    },

    ceilings =
    {
      F_013=40,
      F_040=30,
    },

  },

  ice_caves_Hallway_curve_room1 =
  {
    env  = "hallway",
    group = "curve",
    prob = 50,
    walls =
    {
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

    floors =
    {
      F_013=40,
      F_040=30,
    },

    ceilings =
    {
      F_013=40,
      F_040=30,
    },

  },

  ice_caves_Hallway_deuce_room1 =
  {
    env  = "hallway",
    group = "deuce",
    prob = 50,
    walls =
    {
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

    floors =
    {
      F_013=40,
      F_040=30,
    },

    ceilings =
    {
      F_013=40,
      F_040=30,
    },

  },

  ice_caves_room2 =
  { -- Not technically right, but works for what it does ;-) JB
    env  = "building",
    prob = 50,
    walls =
    {
      ICE01=15,
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

    floors =
    {
      F_013=20,
      F_033=25,
      F_040=15,
    },

    ceilings =
    {
      F_013=40,
      F_033=15,
      F_040=30,
    },

  },
  
  ice_caves_Hallway_v2_room2 =
  { -- Not technically right, but works for what it does ;-) JB
    env  = "hallway",
    group = "oblige_v2",
    prob = 50,
    walls =
    {
      ICE01=15,
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

    floors =
    {
      F_013=20,
      F_033=25,
      F_040=15,
    },

    ceilings =
    {
      F_013=40,
      F_033=15,
      F_040=30,
    },

  },

  ice_caves_Hallway_vent_room2 =
  { -- Not technically right, but works for what it does ;-) JB
    env  = "hallway",
    group = "vent",
    prob = 50,
    walls =
    {
      ICE01=15,
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

    floors =
    {
      F_013=20,
      F_033=25,
      F_040=15,
    },

    ceilings =
    {
      F_013=40,
      F_033=15,
      F_040=30,
    },

  },

  ice_caves_Hallway_curve_room2 =
  { -- Not technically right, but works for what it does ;-) JB
    env  = "hallway",
    group = "curve",
    prob = 50,
    walls =
    {
      ICE01=15,
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

    floors =
    {
      F_013=20,
      F_033=25,
      F_040=15,
    },

    ceilings =
    {
      F_013=40,
      F_033=15,
      F_040=30,
    },

  },

  ice_caves_Hallway_deuce_room2 =
  { -- Not technically right, but works for what it does ;-) JB
    env  = "hallway",
    group = "deuce",
    prob = 50,
    walls =
    {
      ICE01=15,
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

    floors =
    {
      F_013=20,
      F_033=25,
      F_040=15,
    },

    ceilings =
    {
      F_013=40,
      F_033=15,
      F_040=30,
    },

  },  

  ice_caves_room =
  { -- These are built rooms for the cave level (the rest are naturals of some kind)
    env = "building",
    prob = 50,
    walls =
    {
      CAVE01=30,
      CAVE02=30,
      CAVE07=25,
    },

    floors =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

    ceilings =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

  },

  ice_caves_Hallway_v2_room =
  { -- These are built rooms for the cave level (the rest are naturals of some kind)
    env = "hallway",
    group = "oblige_v2",
    prob = 50,
    walls =
    {
      CAVE01=30,
      CAVE02=30,
      CAVE07=25,
    },

    floors =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

    ceilings =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

  },

  ice_caves_Hallway_vent_room =
  { -- These are built rooms for the cave level (the rest are naturals of some kind)
    env = "hallway",
    group = "vent",
    prob = 50,
    walls =
    {
      CAVE01=30,
      CAVE02=30,
      CAVE07=25,
    },

    floors =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

    ceilings =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

  },

  ice_caves_Hallway_curve_room =
  { -- These are built rooms for the cave level (the rest are naturals of some kind)
    env = "hallway",
    group = "curve",
    prob = 50,
    walls =
    {
      CAVE01=30,
      CAVE02=30,
      CAVE07=25,
    },

    floors =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

    ceilings =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

  },

  ice_caves_Hallway_deuce_room =
  { -- These are built rooms for the cave level (the rest are naturals of some kind)
    env = "hallway",
    group = "deuce",
    prob = 50,
    walls =
    {
      CAVE01=30,
      CAVE02=30,
      CAVE07=25,
    },

    floors =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

    ceilings =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

  },

  ice_caves_gray =
  {
    env = "building",
    prob = 50,
    walls =
    {
      CAVE03=10,
      CAVE04=55,
      WASTE02=15,
    },

    floors =
    {
      F_039=75,
      F_040=40,
    },

    ceilings =
    {
      F_039=75,
      F_040=40,
    },

  },

  ice_caves_stalag =
  {
    env = "building",
    prob = 50,
    walls =
    {
      CAVE06=60,
    },

    floors =
    {
      F_039=75,
      F_040=40,
    },

    ceilings =
    {
      F_039=75,
      F_040=40,
    },

  },

  ice_caves_outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_013=15,
      F_033=75,
      F_040=30,
      F_007=10,
      F_039=75,
      F_073=10,
      F_076=10,
    },

    porch_floors =
    {
      F_013=15,
      F_033=75,
      F_040=30,
      F_007=10,
      F_039=75,
      F_073=10,
      F_076=10,
    },

    naturals =
    {
      ICE01=45,
      ICE02=30,
      ICE03=5,
      ICE06=25,
      CAVE03=20,
    },

  },

  -- This is the swamp-type wilderness
  swamp_castle =
  {
    env = "building",
    prob = 50,
    walls =
    {
      SWAMP01=30,
      SWAMP03=30,
      SWAMP04=30,
      -- This should probably be a separate theme, but seems to work best this way, JB
      FOREST07=10,
    },

    floors =
    {
      F_017=10,
      F_018=10,
      F_019=20,
      F_020=15,
      F_054=5,
      F_055=5,
      F_092=5,
    },

    ceilings =
    {
      F_017=10,
      F_018=10,
      F_019=20,
      F_020=15,
      F_054=5,
      F_055=5,
      F_092=5,
    },

  },

  swamp_Hallway_v2_castle =
  {
    env = "hallway",
    group = "oblige_v2",
    prob = 50,
    walls =
    {
      SWAMP01=30,
      SWAMP03=30,
      SWAMP04=30,
      -- This should probably be a separate theme, but seems to work best this way, JB
      FOREST07=10,
    },

    floors =
    {
      F_017=10,
      F_018=10,
      F_019=20,
      F_020=15,
      F_054=5,
      F_055=5,
      F_092=5,
    },

    ceilings =
    {
      F_017=10,
      F_018=10,
      F_019=20,
      F_020=15,
      F_054=5,
      F_055=5,
      F_092=5,
    },

  },

  swamp_Hallway_vent_castle =
  {
    env = "hallway",
    group = "vent",
    prob = 50,
    walls =
    {
      SWAMP01=30,
      SWAMP03=30,
      SWAMP04=30,
      -- This should probably be a separate theme, but seems to work best this way, JB
      FOREST07=10,
    },

    floors =
    {
      F_017=10,
      F_018=10,
      F_019=20,
      F_020=15,
      F_054=5,
      F_055=5,
      F_092=5,
    },

    ceilings =
    {
      F_017=10,
      F_018=10,
      F_019=20,
      F_020=15,
      F_054=5,
      F_055=5,
      F_092=5,
    },

  },

  swamp_Hallway_curve_castle =
  {
    env = "hallway",
    group = "curve",
    prob = 50,
    walls =
    {
      SWAMP01=30,
      SWAMP03=30,
      SWAMP04=30,
      -- This should probably be a separate theme, but seems to work best this way, JB
      FOREST07=10,
    },

    floors =
    {
      F_017=10,
      F_018=10,
      F_019=20,
      F_020=15,
      F_054=5,
      F_055=5,
      F_092=5,
    },

    ceilings =
    {
      F_017=10,
      F_018=10,
      F_019=20,
      F_020=15,
      F_054=5,
      F_055=5,
      F_092=5,
    },

  },

  swamp_Hallway_deuce_castle =
  {
    env = "hallway",
    group = "deuce",
    prob = 50,
    walls =
    {
      SWAMP01=30,
      SWAMP03=30,
      SWAMP04=30,
      -- This should probably be a separate theme, but seems to work best this way, JB
      FOREST07=10,
    },

    floors =
    {
      F_017=10,
      F_018=10,
      F_019=20,
      F_020=15,
      F_054=5,
      F_055=5,
      F_092=5,
    },

    ceilings =
    {
      F_017=10,
      F_018=10,
      F_019=20,
      F_020=15,
      F_054=5,
      F_055=5,
      F_092=5,
    },

  },

  swamp_hut =
  {
    env = "building",
    prob = 50,
    walls =
    {
      VILL01=5,
      VILL04=25,
      VILL05=25,
      WOOD01=5,
      WOOD02=5,
      WOOD03=15,
    },

    floors =
    {
      F_054=10,
      F_055=10,
      F_092=10,
    },

    ceilings =
    {
      F_054=10,
      F_055=10,
      F_092=10,
    },

  },

  swamp_outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_017=5,
      F_018=5,
      F_019=10,
      F_020=10,
      F_054=1,
      F_055=1,
      F_092=1,
      F_005=10,
      F_006=10,
      F_007=5,
    },

    porch_floors =
    {
      F_017=5,
      F_018=5,
      F_019=10,
      F_020=10,
      F_054=1,
      F_055=1,
      F_092=1,
      F_005=10,
      F_006=10,
      F_007=5,
    },

    naturals =
    {
      SWAMP01=20,
      SWAMP03=20,
      SWAMP04=20,
      FOREST07=10,
      CAVE03=10,
      CAVE04=10,
      CAVE05=10,
      CAVE06=10,
      WASTE02=5,
    },

  },

  -- This is the woodland wilderness found in The Shadow Wood and Winnowing Hall;
  forest_room1 =
  {
    env = "building",
    prob = 50,
    walls =
    {
      FOREST01=40,
    },

    floors =
    {
      F_010=25,
      F_011=25,
      F_030=15,
      F_077=10,
      F_089=25,
    },

    ceilings =
    {
      F_010=25,
      F_011=25,
      F_030=15,
      F_089=10,
    },

  },

  forest_room2 =
  {
    env = "building",
    prob = 50,
    walls =
    {
      FOREST02=40,
      FOREST03=10,
      FOREST04=10,
    },

    floors =
    {
      F_038=25,
      F_048=25,
      F_089=25,
    },

    ceilings =
    {
      F_038=25,
    },

  },

  forest_Hallway_v2_room2 =
  {
    env = "hallway",
    group = "oblige_v2",
    prob = 50,
    walls =
    {
      FOREST02=40,
      FOREST03=10,
      FOREST04=10,
    },

    floors =
    {
      F_038=25,
      F_048=25,
      F_089=25,
    },

    ceilings =
    {
      F_038=25,
    },

  },

  forest_Hallway_vent_room2 =
  {
    env = "hallway",
    group = "vent",
    prob = 50,
    walls =
    {
      FOREST02=40,
      FOREST03=10,
      FOREST04=10,
    },

    floors =
    {
      F_038=25,
      F_048=25,
      F_089=25,
    },

    ceilings =
    {
      F_038=25,
    },

  },

  forest_Hallway_curve_room2 =
  {
    env = "hallway",
    group = "curve",
    prob = 50,
    walls =
    {
      FOREST02=40,
      FOREST03=10,
      FOREST04=10,
    },

    floors =
    {
      F_038=25,
      F_048=25,
      F_089=25,
    },

    ceilings =
    {
      F_038=25,
    },

  },

  forest_Hallway_deuce_room2 =
  {
    env = "hallway",
    group = "deuce",
    prob = 50,
    walls =
    {
      FOREST02=40,
      FOREST03=10,
      FOREST04=10,
    },

    floors =
    {
      F_038=25,
      F_048=25,
      F_089=25,
    },

    ceilings =
    {
      F_038=25,
    },

  },

  forest_room3 =
  {
    env = "building",
    prob = 50,
    walls =
    {
      FOREST10=40,
      WINN01=10,
    },

    floors =
    {
      F_073=25,
      F_077=20,
      F_089=25,
    },

    ceilings =
    {
      F_073=25,
    },

  },

  forest_outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_005=15,
      F_006=25,
      F_007=60,
    },

    porch_floors =
    {
      F_005=15,
      F_006=25,
      F_007=60,
    },

    naturals =
    {
      FOREST01=25,
      FOREST02=25,
      FOREST07=35,
      CAVE05=40,
      CAVE03=50,
    },

  },

  forest_room =
  {
    env = "building",
    prob = 50,
    walls =
    {
      WOOD01=5,
      VILL04=10,
      VILL05=10,
    },

    floors =
    {
      F_002=10,
      F_003=10,
      F_004=5,
      F_037=10,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

    ceilings =
    {
      F_037=10,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

  },

  forest_Hallway_v2_room =
  {
    env = "hallway",
    group = "oblige_v2",
    prob = 50,
    walls =
    {
      WOOD01=5,
      VILL04=10,
      VILL05=10,
    },

    floors =
    {
      F_002=10,
      F_003=10,
      F_004=5,
      F_037=10,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

    ceilings =
    {
      F_037=10,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

  },

  forest_Hallway_vent_room =
  {
    env = "hallway",
    group = "vent",
    prob = 50,
    walls =
    {
      WOOD01=5,
      VILL04=10,
      VILL05=10,
    },

    floors =
    {
      F_002=10,
      F_003=10,
      F_004=5,
      F_037=10,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

    ceilings =
    {
      F_037=10,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

  },

  forest_Hallway_curve_room =
  {
    env = "hallway",
    group = "curve",
    prob = 50,
    walls =
    {
      WOOD01=5,
      VILL04=10,
      VILL05=10,
    },

    floors =
    {
      F_002=10,
      F_003=10,
      F_004=5,
      F_037=10,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

    ceilings =
    {
      F_037=10,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

  },

  forest_Hallway_deuce_room =
  {
    env = "hallway",
    group = "deuce",
    prob = 50,
    walls =
    {
      WOOD01=5,
      VILL04=10,
      VILL05=10,
    },

    floors =
    {
      F_002=10,
      F_003=10,
      F_004=5,
      F_037=10,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

    ceilings =
    {
      F_037=10,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

  },  

  forest_brick =
  {
    env = "building",
    prob = 50,
    walls =
    {
      VILL01=5,
    },

    floors =
    {
      F_002=10,
      F_003=10,
      F_004=5,
      F_030=30,
      F_028=10,
      F_029=10,
      F_054=10,
      F_055=10,
    },

    ceilings =
    {
      F_030=30,
      F_028=20,
      F_029=20,
      F_054=20,
      F_055=20,
    },

  },

  any_Cave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      CAVE01=30,
      CAVE02=30,
      CAVE07=25,
    },

    floors =
    {
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=15,
    },

  },

}

------------------------------------------------------------------------

HEXEN.ROOMS =
{

  GENERIC =
  {
    environment = "any",
  },

  OUTSIDE =
  {
    env = "outdoor",
    prob = 50,
  },

}

--------------------------------------------------

OB_THEMES["forest"] =
{
  label = _("Forest"),
  game = "hexen",
  name_class = "GOTHIC",
  mixed_prob = 20,
}

OB_THEMES["ice_caves"] =
{
  label = _("Ice Caves"),
  game = "hexen",
  name_class = "GOTHIC",
  mixed_prob = 50,
}

OB_THEMES["fire_steel"] =
{
  label = _("Fire and Steel"),
  game = "hexen",
  name_class = "GOTHIC",
  mixed_prob = 50,
}

OB_THEMES["swamp"] =
{
  label = _("Swamp"),
  game = "hexen",
  name_class = "GOTHIC",
  mixed_prob = 20,
}

OB_THEMES["dungeon"] =
{
  label = _("Dungeon"),
  game = "hexen",
  name_class = "GOTHIC",
  mixed_prob = 50,
}