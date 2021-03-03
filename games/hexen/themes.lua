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

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
    light = 16,
  },

  liquid_plain =
  {
    mat = "X_005",
    dz  = -12,
  },

}

HEXEN.THEMES =
{
  DEFAULTS =
  {
    keys =
    {
      k_axe = 50,
      k_cave = 50,
      k_castle = 50,
      k_dungeon = 50,
      k_emerald = 50,
      k_fire = 20,
      k_horn = 50,
      k_rusty = 50,
      k_silver = 50,
      k_swamp = 50,
      k_steel = 50,
    },

    skyboxes =
    {

    },

  },

    dungeon =
    {

      floor_sinks =
      {
        liquid_plain = 50,
      },

      ceiling_sinks =
      {
        sky_plain = 50,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
      },

      beam_groups =
      {
        beam_metal = 50,
      },

      fences =
      {
        CASTLE07=35,
        CASTLE11=25,
      },

      cage_mats =
      {
        CASTLE07=35,
        CASTLE11=25,
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
        CASTLE07=35,
        CASTLE11=25,
        CAVE02=15,
        MONK01=20,
        MONK02=20,
        MONK08=15,
        PRTL02=10,
        PRTL03=5,
      },

      liquids =
      {
        water  = 50,
        lava   = 10,
        muck   = 20,
      },

      steps_mat = "F_011",

    },

    fire =
    {

      floor_sinks =
      {
        liquid_plain = 50,
      },

      ceiling_sinks =
      {
        sky_plain = 50,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
      },

      beam_groups =
      {
        beam_metal = 50,
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
        SEWER_BAR3 = 50,
        SEWER_BAR4 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {

      },

      liquids =
      {
        lava   = 10,
      },

      steps_mat = "F_011",

    },

    ice =
    {

      floor_sinks =
      {
        liquid_plain = 50,
      },

      ceiling_sinks =
      {
        sky_plain = 50,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
      },

      beam_groups =
      {
        beam_metal = 50,
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
        SEWER_BAR3 = 50,
        SEWER_BAR4 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {

      },

      liquids =
      {
        lava   = 10,
      },

      steps_mat = "F_011",

    },

    steel =
    {

      floor_sinks =
      {
        liquid_plain = 50,
      },

      ceiling_sinks =
      {
        sky_plain = 50,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
      },

      beam_groups =
      {
        beam_metal = 50,
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
        SEWER_BAR3 = 50,
        SEWER_BAR4 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {

      },

      liquids =
      {
        lava   = 10,
      },

      steps_mat = "F_011",

    },

    desert =
    {

      floor_sinks =
      {
        liquid_plain = 50,
      },

      ceiling_sinks =
      {
        sky_plain = 50,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
      },

      beam_groups =
      {
        beam_metal = 50,
      },

      fences =
      {
        FOREST01=10,
        MONK16=25,
      },

      cage_mats =
      {
        FOREST01=10,
        MONK16=25,
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
        FOREST01=10,
        MONK16=25,
      },

      liquids =
      {
        lava   = 10,
      },

      steps_mat = "F_011",

    },

    cave =
    {

      floor_sinks =
      {
        liquid_plain = 50,
      },

      ceiling_sinks =
      {
        sky_plain = 50,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
      },

      beam_groups =
      {
        beam_metal = 50,
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
        SEWER_BAR3 = 50,
        SEWER_BAR4 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {
        CAVE03=10,
      },

      liquids =
      {
        lava   = 10,
      },

      steps_mat = "F_011",

    },

    swamp =
    {

      floor_sinks =
      {
        liquid_plain = 50,
      },

      ceiling_sinks =
      {
        sky_plain = 50,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
      },

      beam_groups =
      {
        beam_metal = 50,
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
        SEWER_BAR3 = 50,
        SEWER_BAR4 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {

      },

      liquids =
      {
        lava   = 10,
      },

      steps_mat = "F_011",

    },

    forest =
    {

      floor_sinks =
      {
        liquid_plain = 50,
      },

      ceiling_sinks =
      {
        sky_plain = 50,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
      },

      beam_groups =
      {
        beam_metal = 50,
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
        SEWER_BAR3 = 50,
        SEWER_BAR4 = 50,
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
      },

      liquids =
      {
        lava   = 10,
      },

      steps_mat = "F_011",

    },

    village =
    {

      floor_sinks =
      {
        liquid_plain = 50,
      },

      ceiling_sinks =
      {
        sky_plain = 50,
      },

      sink_style =
      {
        sharp = 1,
        curved = 0.1,
      },

      fence_groups =
      {
        PLAIN = 50,
      },

      beam_groups =
      {
        beam_metal = 50,
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
        SEWER_BAR3 = 50,
        SEWER_BAR4 = 50,
      },

      fence_posts =
      {
        Post = 50,
      },

      facades =
      {

      },

      liquids =
      {
        lava   = 10,
      },

      steps_mat = "F_011",

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
  fire_room1 =
  {
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

  fire_room2 =
  {

    walls =
    {
      FIRE01=30,
      FIRE04=5,
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


  -- This is the element fire, as in "The Guardian or fire" in Raven's original wad.
  fire_lavawalls =
  { -- fire could be split up, but these textures were pretty mixed up in the
    -- original wads, and it looks good as it is, JB

    walls =
    {
      X_FIRE01=100,
    },

    floors =
    {
      F_013=25,
      F_032=25,
      F_040=15,
      F_044=5,
      F_082=15,
    },

    ceilings =
    {
      X_001=85,
      F_013=25,
      F_032=25,
      F_040=15,
      F_044=5,
      F_082=15,
    },

  },

  fire_outdoors =
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
    },

    naturals =
    {
      FIRE01=30,
      FIRE04=5,
      FIRE05=10,
      FIRE06=15,
      FIRE07=15,
      FIRE08=10,
      FIRE09=10,
      FIRE10=10,
      FIRE11=10,
      FIRE12=10,
    },

  },

  -- This is the "element" ice
  ice_room1 =
  {

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

  ice_room2 =
  { -- Not technically right, but works for what it does ;-) JB

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

  ice_outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_013=15,
      F_033=75,
      F_040=30,
    },

    naturals =
    {
      ICE01=45,
      ICE02=30,
      ICE03=5,
      ICE06=25,
    },

  },


  -- This is the "element" steel, as in "The Guardian or steel" in Raven's original wad.
  steel_room_mix =
  { -- Not technically right, but works for what it does ;-) JB

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

  steel_room_gray =
  {

    walls =
  {
      STEEL06=35,
      STEEL07=15,
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
      F_078=10,
    },

  },

  steel_room_rust =
  {

    walls =
    {
      STEEL01=40,
      STEEL02=10,
    },

    floors =
    {
      F_074=40,
      F_075=15,
    },

    ceilings =
    {
      F_074=40,
      F_075=15,
    },

  },

  -- This is the barren, deserty wildness, based on "The Wasteland" in Raven's original wad.
  desert_room_stone =
  {

    walls =
    {
      WASTE04=10,
      FOREST01=10,
      MONK16=25,
    },

    floors =
    {
      F_002=10,
      F_003=10,
      F_004=5,
      F_037=20,
      F_029=20,
      F_044=15,
      F_082=10,
    },

    ceilings =
    {
      F_037=20,
      F_029=20,
      F_044=15,
      F_082=10,
      D_END3=27,
      D_END4=3,
    },

  },

  desert_outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_002=25,
      F_003=25,
      F_004=10,
      F_005=5,
      F_037=20,
    },

    naturals =
    {
      WASTE01=35,
      WASTE02=15,
      WASTE04=10,
      WASTE03=5,
    },

  },

  -- This is the cave type wildness; also, many caves used elsewhere;
  -- most caves have floor, ceiling, and walls so that they can double
  -- in other cave-ish roles. JB
  cave_room =
  { -- These are built rooms for the cave level (the rest are naturals of some kind)
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

  cave_gray =
  {

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

  cave_stalag =
  {

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

  cave_brown =
  {

    walls =
    {
      CAVE05=60,
    },

    floors =
    {
      F_001=75,
      F_002=40,
    },

    ceilings =
    {
      F_001=75,
      F_002=40,
    },

  },

  cave_green =
  {

    walls =
    {
      FOREST02=25,
    },

    floors =
    {
      F_001=15,
      F_002=10,
      F_038=75,
    },

    ceilings =
    {
      F_001=15,
      F_002=10,
      F_038=75,
    },

  },

  cave_swamp =
  {
    walls =
    {
      SWAMP01=20,
      SWAMP03=20,
    },

    floors =
    {
      F_019=75,
      F_020=40,
      F_039=25,
      F_040=20,
    },

    ceilings =
    {
      F_019=75,
      F_020=40,
      F_039=25,
      F_040=20,
    },

  },

  cave_desert_tan =
  {

    walls =
    {
      WASTE01=35,
    },

    floors =
    {
      F_003=75,
      F_002=40,
      F_004=10,
      F_037=25,
    },

    ceilings =
    {
      F_003=75,
      F_002=40,
    },

  },

  cave_desert_gray =
  {

    walls =
    {
      WASTE02=30,
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

  cave_outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_007=10,
      F_039=75,
      F_040=40,
      F_073=10,
      F_076=10,
    },

    naturals =
    {
      CAVE03=70,
    },

  },


  -- This is the swamp-type wilderness
  swamp_castle =
  {
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

    naturals =
    {
      FOREST01=25,
      FOREST02=25,
      FOREST07=35,
      CAVE05=40,
      CAVE03=50,
    },

  },

  village_room =
  {

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

  village_brick =
  {

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

OB_THEMES["dungeon"] =
{
  label = _("Dungeon"),
  game = "hexen",
  name_theme = "GOTHIC",
  mixed_prob = 50,
}

OB_THEMES["fire"] =
{
  label = _("Fire"),
  game = "hexen",
  name_theme = "GOTHIC",
  mixed_prob = 50,
}

OB_THEMES["ice"] =
{
  label = _("Ice"),
  game = "hexen",
  name_theme = "GOTHIC",
  mixed_prob = 50,
}

OB_THEMES["steel"] =
{
  label = _("Steel"),
  game = "hexen",
  name_theme = "GOTHIC",
  mixed_prob = 20,
}

OB_THEMES["desert"] =
{
  label = _("Desert"),
  game = "hexen",
  name_theme = "GOTHIC",
  mixed_prob = 10,
}

OB_THEMES["cave"] =
{
  label = _("Cave"),
  game = "hexen",
  name_theme = "GOTHIC",
  mixed_prob = 20,
}

OB_THEMES["swamp"] =
{
  label = _("Swamp"),
  game = "hexen",
  name_theme = "GOTHIC",
  mixed_prob = 20,
}

OB_THEMES["forest"] =
{
  label = _("Forest"),
  game = "hexen",
  name_theme = "GOTHIC",
  mixed_prob = 20,
}

OB_THEMES["village"] =
{
  label = _("Village"),
  game = "hexen",
  name_theme = "URBAN",
  mixed_prob = 20,
}

