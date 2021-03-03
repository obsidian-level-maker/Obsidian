--------------------------------------------------------------------
--  The Plutonia Experiment
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C) 2019-2021 Armaetus
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

PLUTONIA = { }


PLUTONIA.PARAMETERS =
{
  bex_map_prefix  = "PHUSTR_",

  bex_secret_name  = "P5TEXT",
  bex_secret2_name = "P6TEXT",
}


PLUTONIA.MATERIALS =
{
  -- Note the actual texture names contain hyphens, but we must use
  -- an underscore for the OBLIGE material names.

  A_BRBRK  = { t="A-BRBRK",  f="RROCK18" },
  A_BRBRK2 = { t="A-BRBRK2", f="RROCK16" },
  A_BRICK1 = { t="A-BRICK1", f="MFLR8_1" },
  A_BROWN1 = { t="A-BROWN1", f="RROCK17" },
  A_BROWN2 = { t="A-BROWN2", f="FLAT8" },
  A_BROWN3 = { t="A-BROWN3", f="RROCK03" },
  A_BROWN5 = { t="A-BROWN5", f="RROCK19" },

  A_CAMO1 =  { t="A-CAMO1",  f="GRASS1" },
  A_CAMO2 =  { t="A-CAMO2",  f="SLIME13" },
  A_CAMO3 =  { t="A-CAMO3",  f="SLIME13" },
  A_CAMO4 =  { t="A-CAMO4",  f="FLOOR7_2" },

  A_DBRI1 =  { t="A-DBRI1",  f="FLAT5_4" },
  A_DBRI2 =  { t="A-DBRI2",  f="MFLR8_2" },
  A_DROCK1 = { t="A-DROCK1", f="FLOOR6_2" },
  A_DROCK2 = { t="A-DROCK2", f="MFLR8_2" },

  A_MARBLE = { t="A-MARBLE", f="FLAT1" },
  A_MOSBRI = { t="A-MOSBRI", f="SLIME13" },
  A_MOSROK = { t="A-MOSROK", f="FLAT5_7" },
  A_MOSRK2 = { t="A-MOSRK2", f="SLIME13" },
  A_MOULD =  { t="A-MOULD",  f="RROCK19" },
  A_MUD =    { t="A-MUD",    f="RROCK16" },

  A_MYWOOD = { t="A-MYWOOD", f="FLAT5_1" },
  A_POIS =   { t="A-POIS",   f="CEIL5_2" },
  A_REDROK = { t="A-REDROK", f="FLAT5_3" },
  A_ROCK =   { t="A-ROCK",   f="FLAT5_7" },
  A_TILE =   { t="A-TILE",   f="GRNROCK" },
  A_VINE3 =  { t="A-VINE3",  f="RROCK12" },
  A_VINE4 =  { t="A-VINE4",  f="RROCK16" },
  A_VINE5 =  { t="A-VINE5",  f="MFLR8_3" },

  A_YELLOW = { t="A-YELLOW", f="FLAT23" },

  A_ASKIN1 =   { t="A-ASKIN1",   f="FLAT5_6" },
  A_ASKIN2 =   { t="A-ASKIN2",   f="FLAT5_6" },
  A_ASKIN3 =   { t="A-ASKIN3",   f="FLAT5_6" },
  A_ASKIN4 =   { t="A-ASKIN4",   f="FLAT5_6" },
  A_ASKIN5 =   { t="A-ASKIN5",   f="FLAT5_6" },

  -- Actually named SLIME## but named TSLIME to avoid
  -- confusion with the flats of the same name
  TSLIME1 =  { t="SLIME1",  f="FLAT5_2" },
  TSLIME2 =  { t="SLIME2",  f="MFLR8_2" },
  TSLIME3 =  { t="SLIME3",  f="SLIME13" },
  TSLIME4 =  { t="SLIME4",  f="SLIME13" },
  TSLIME5 =  { t="SLIME5",  f="CEIL5_2" },
  TSLIME8 =  { t="SLIME8",  f="SLIME13" },

  -- this is animated
  AROCK1   = { t="AROCK1",   f="GRNROCK" },
  FIREBLU1 = { t="FIREBLU1", f="GRNROCK" },
  FIREBLU2 = { t="FIREBLU2", f="GRNROCK" },

  JUNGLE1  = { t="MC10", f="RROCK19" },
  JUNGLE2  = { t="MC2",  f="RROCK19" },

  -- use the TNT name for this
  METALDR  = { t="A-BROWN4", f="CEIL5_2" },

  -- use Plutonia's waterfall texture instead of our own
  WFALL1   = { t="WFALL1", f="FWATER1", sane=1 },
  FWATER1  = { t="WFALL1", f="FWATER1", sane=1 },

  -- Railing / Grates
  A_GRATE = { t="A-GRATE", rail_h=128 },
  A_RAIL1 = { t="A-RAIL1", rail_h=32 },
  A_VINE1 = { t="A-VINE1", rail_h=128 },
  A_VINE2 = { t="A-VINE2", rail_h=128 },

  -- Overrides for existing DOOM materials --

  WOOD1    = { t="A-MYWOOD", f="FLAT5_2" },
  CEIL1_1  = { f="CEIL1_1", t="A-WOOD1" },
  CEIL1_3  = { f="CEIL1_3", t="A-WOOD1" },
  FLAT5_1  = { f="FLAT5_1", t="A-WOOD1" },
  FLAT5_2  = { f="FLAT5_2", t="A-WOOD1" },

  STONE   = { t="A-CONCTE", f="FLAT5_4" },
  FLAT5_4 = { t="A-CONCTE", f="FLAT5_4" },

  BIGBRIK2 = { t="A-BRICK1", f="MFLR8_1" },
  BIGBRIK1 = { t="A-BRICK2", f="RROCK14" },
  RROCK14  = { t="A-BRICK2", f="RROCK14" },
  BRICK5   = { t="A-BRICK3", f="RROCK12" },
  BRICJ10  = { t="A-TILE",   f="GRNROCK" },
  BRICK11  = { t="A-BRBRK",  f="RROCK18" },
  BRICK12  = { t="A-BROCK2", f="FLOOR4_6" },

  ASHWALL4 = { t="A-DROCK2", f="MFLR8_2" },
  ASHWALL7 = { t="A-MUD",    f="RROCK16" },

  BIGDOOR2 = { t="A-BROWN4", f="CEIL5_2" },
  BIGDOOR3 = { t="A-BROWN4", f="CEIL5_2" },
  BIGDOOR4 = { t="A-BROWN4", f="CEIL5_2" },
}


PLUTONIA.EPISODES =
{
  episode1 =
  {
    theme = "tech",
    sky_patch = "SKY1",
    dark_prob = 10,
    bex_mid_name = "P1TEXT",
    bex_end_name = "P2TEXT",
  },

  episode2 =
  {
    theme = "urban",
    sky_patch  = "SKY2A",
    sky_patch2 = "SKY2B",
    sky_patch3 = "SKY2C",
    sky_patch4 = "SKY2D",
    dark_prob = 10,
    bex_end_name = "P3TEXT",
  },

  episode3 =
  {
    theme = "hell",
    sky_patch  = "SKY3A",
    sky_patch2 = "SKY3B",
    dark_prob = 40,
    bex_end_name = "P4TEXT",
  },
}

-- WORK IN PROGRESS --
-- TEMPORARY SHIT, USABLE BUT NEEDS MORE!
-- -Armaetus, January 19th, 2021,

-- More tables and other crap are needed so
-- Plutonia has some exclusive themes added,
-- though not too many. If Evilution has some,
-- so should Plutonia.

-- Some thoughts:
-- Plutonia is generally harder and really seems to
-- like using chaingunners and revenants more, possibly
-- other monsters so would suggest monster_prefs be
-- anywhere from 1.25 to 1.5, depending on placement
-- and lethality.


-- Copied from x_tnt.lua as a placeholder, mostly.
--[[PLUTONIA.THEMES =
{

DEFAULTS =
  {
    liquids =
    {
      slime = 60,
      blood = 30,
      water = 40,
      lava  = 10,
    },

    facades =
    {
      SMSTONE6 = 30,
      STONEW1  = 20,
      STWALL   = 20,
      CAVERN1  = 10,

      BIGBRIK1 = 30,
      BSTONE2  = 20,
      BRICK4   = 10,
    },

    window_groups =
    {
      round  = 90,
      barred = 60,
      grate  = 30,
    },

    outdoor_torches =
    {
      blue_torch = 50,
      green_torch = 50,
      red_torch = 50,
      candelabra = 20,
    },

    beam_groups =
    {
      beam_gothic = 50,
      beam_quakeish = 50,
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 50,
      gappy = 50,
      fence_gothic = 50,
    },

    fence_posts =
    {
      Post_metal = 25,
      Post_gothic_blue = 10,
      Post_gothic_green = 10,
      Post_gothic_red = 15,
      Post_gothic_blue_2 = 10,
      Post_gothic_green_2 = 10,
      Post_gothic_red_2 = 15,
    },

-- Based on Plutonia's FUCK YOU to the player..

-- January 17th, 2021,
-- WIP: Further analysis of plutonia.wad's monster placement.
-- WIP 2: Additional analysis on looking at Plutonia 2.
-- monster_prefs are subject to change.
    monster_prefs =
    {
      gunner = 1.5,
      mancubus = 1.2,
      revenant = 1.3,
      knight = 1.2,
      imp = 1.3,
      demon = 0.8,
      vile = 1.1,
      shooter = 1.1,
      zombie = 0.5,
      caco = 1.2,
      skull = 0.4,
    },

    beam_groups =
    {
      beam_gothic = 55,
      beam_quakeish = 25,
      beam_lights = 20,
      beam_lights_white = 40,
      beam_wood = 50,
      beam_textured = 20,
      beam_lights_vertical_hell = 20,
    },

    -- Copied from urban, subject to alteration
    ceiling_sinks =
    {
      sky_metal = 25,
      sky_plain = 10,
      sky_modwall = 7,
      sky_stone_1 = 3,
      sky_stone_2 = 3,
      sky_cement = 8,
      sky_brick10 = 5,
      sky_brownpip = 3,

      light_urban1 = 20,
      light_diamond = 10,
      ceil_icky   = 50,
      ceil_vdark  = 30,

      light_side1 = 70,
      light_side2 = 70,
      light_side3 = 70,
      light_side4 = 70,
      light_side5 = 70,
      light_side6 = 70,
    },

    wall_groups =
    {
      torches2 = 10 --red
      torches3 = 10 --blue
      torches1 = 10 --green
      torches6 = 5,
      torches9 = 2 --burning barrel
      torches10 = 2 --skull rock
      gtd_wall_tech_top_corner_light_set = 8,
      gtd_wall_sewer = 10,
      gtd_generic_beamed_inset = 15,
      gtd_writhing_mass = 2,
      gtd_wall_quakish_insets = 10,
      gtd_wall_high_gap_set = 5,
      gtd_wall_high_gap_alt_set = 5,
      gtd_generic_half_floor = 8,
      gtd_generic_half_floor_no_trim = 8,
      gtd_generic_half_floor_inverted_braced = 8,
      gtd_woodframe = 20,
      gtd_woodframe_green = 5,
      gtd_round_inset = 5,
      gtd_wall_urban_cement_frame = 3,
      gtd_generic_ceilwall = 10,
      gtd_generic_glow_wall = 5,
      gtd_generic_alt_colors = 15,
      gtd_generic_mid_band = 10,
      gtd_generic_double_banded_ceil = 15,
      gtd_generic_frame_light_band = 7,
      gtd_generic_frame_metal = 15,
    },

    window_groups =
    {
      barred = 15,
      tall   = 95,
      round  = 15,
      square = 20,
      grate  = 20,
      supertall = 40,
      gtd_window_cage_highbars = 30,
      gtd_window_cage_lowbars = 40,
      gtd_window_arched = 60,
      gtd_window_arched_tall = 20,
      gtd_window_full_open = 70,
      gtd_window_full_open_tall = 65,
      gtd_window_bay = 30,
      gtd_window_absurdly_open = 45,
      gtd_window_quakeish = 20,
      gtd_window_low = 35,
      gtd_window_arrowslit = 10,
      gtd_window_metal_frames = 70,
      gtd_window_pencil_holes = 15,
      gtd_window_hexagon = 25,
    },

    fence_groups =
    {
      PLAIN = 50,
      gappy = 50,
      crenels = 12,
      fence_gothic = 50,
      fence_corrugated_steel = 50,
      fence_tech_hl_bars = 12,
    },

    fence_posts =
    {
      Post_metal = 50,
      Post_tech_1 = 5,
      Post_tech_2 = 5,
      Post_gothic_blue = 10,
      Post_gothic_green = 10,
      Post_gothic_red = 10,
      Post_gothic_blue_2 = 10,
      Post_gothic_green_2 = 10,
      Post_gothic_red_2 = 10,
    },

    cave_torches =
    {
      green_torch = 75,
      blue_torch  = 75,
      red_torch   = 40,
      blue_torch_sm = 25,
      red_torch_sm  = 10,
      green_torch_sm = 25,
      candelabra = 10,
      burning_barrel = 20,
    },

    outdoor_torches =
    {
      blue_torch = 100,
      red_torch  = 50,
      green_torch = 100,
      candelabra = 20,
      skull_rock = 5,
      blue_torch_sm = 40,
      red_torch_sm  = 25,
      green_torch_sm = 40,
      burning_barrel = 10,
    },

    passable_decor =
    {
      gibs = 20,
      pool_blood_1 = 5,
      pool_blood_2 = 15,
      pool_brains  = 3,

      gibbed_player = 15,
      dead_player = 20,
      dead_zombie = 2,
      dead_shooter = 2,
      dead_imp = 2,
      dead_demon = 1,
      dead_caco  = 1,
    },

    park_decor =
    {
      burnt_tree = 95,
      brown_stub = 30,
      big_tree = 60,
    },

--Any rocky/stonelike/metal doors (IE METALDR) would do great for this theme -Chris
    scenic_fences =
    {
      MIDBARS3 = 50,
    },

    style_list =
    {
      doors = { none=5, few=30, some=65, heaps=20 },
      outdoors = { few=15, some=80, heaps=30 },
      steepness = { some=75, heaps=40 },
      pictures = { few=20, some=50, heaps=70 },
      big_rooms = { few=60, some=25, heaps=10 },
      big_outdoor_rooms = { none=10, few=50, some=20, heaps=10 },
      ambushes = { few=25, some=55, heaps=85 },
      hallways = { none=25, few=70, some=15, heaps=5 },
      teleporters = { none=10, few=30, some=80, heaps=10 },
      keys = { few=20, some=90, heaps=35 },
      trikeys = { none=15, few=40, some=80, heaps=35 },
      liquids = { none=15, few=45, some=35, heaps=15 },
      traps = { few=10, some=40, heaps=70 },
      switches = { none=5, few=40, some=75, heaps=15 },
      cages    = { none=10, few=45, some=85, heaps=15 },
      symmetry = { none=85, few=55, some=15, heaps=10 },
      secrets = { few=25, some=80, heaps=30 },
      scenics = { few=10, some=75, heaps=90 },
      caves = { none=80, few=35, some=5, heaps=1 },
      barrels = { none=15, few=55, some=15, heaps=5 },
      porches = { few=25, some=30, heaps=80 },
      fences  = { few=10, some=70, heaps=35 },
      beams  = { few=10, some=20, heaps=70 },
      mon_variety = { some=10, heaps=95},
    },

    ceil_light_prob = 50,

    cage_lights = { 0, 8, 12, 13, 17 },

    skyboxes =
    {
      Skybox_generic = 70,
      Skybox_hellish_city = 10,
      Skybox_garrett_city = 15,
    },
  },

  tech =
  {

    entity_remap =
    {
      green_torch = "mercury_lamp",
    },

    ceil_light_prob = 70,

    monster_prefs =
    {
      gunner = 1.5,
      mancubus = 0.9,
      revenant = 1.1,
      knight = 1.1,
      imp = 1.33,
      demon = 0.9,
      vile = 0.6,
      shooter = 1.2,
      zombie = 0.9,
      skull = 0.2,
    },

        beam_groups =
    {
      beam_shiny = 75,
      beam_quakeish = 50,
      beam_lights = 50,
      beam_lights_white = 50,
      beam_lights_vertical_tech = 50,
      beam_textured = 50,
    },

    style_list =
    {
      doors = { none=5, few=30, some=65, heaps=20 },
      outdoors = { few=15, some=80, heaps=30 },
      steepness = { few=25, some=75, heaps=40 },
      pictures = { few=20, some=50, heaps=70 },
      big_rooms = { none=15, few=60, some=25, heaps=10 },
      big_outdoor_rooms = { none=20, few=50, some=20, heaps=10 },
      windows = { few=10, some=60, heaps=30 },
      ambushes = { few=25, some=75, heaps=40 },
      hallways = { none=25, few=70, some=15, heaps=5 },
      teleporters = { none=15, few=70, some=25, heaps=5 },
      keys = { none=10, few=40, some=90, heaps=25 },
      trikeys = { none=15, few=40, some=80, heaps=35 },
      liquids = { none=20, few=75, some=35, heaps=10 },
      traps = { few=15, some=80, heaps=40 },
      switches = { none=10, few=40, some=75, heaps=15 },
      cages    = { none=20, few=60, some=20, heaps=15 },
      symmetry = { none=85, few=55, some=15, heaps=15 },
      secrets = { few=25, some=80, heaps=30 },
      scenics = { few=10, some=75, heaps=90 },
      caves = { none=85, few=15, some=3 },
      barrels = { none=5, few=25, some=65, heaps=15 },
      porches = { few=25, some=80, heaps=35 },
      fences  = { few=20, some=70, heaps=35 },
      beams  = { few=10, some=50, heaps=30 },
      mon_variety = { some=10, heaps=95},
    },

    sink_style =
    {
      sharp = 1,
      curved = 1,
    },

    skyboxes =
    {
      Skybox_generic = 50,
      Skybox_hellish_city = 50,
    },

    cage_lights = { 0, 8, 12, 13, 17 },

    techy_doors = true

    post_mat = "DOORSTOP",
  },
 },

  urban =
  {

    ceil_light_prob = 60,

    monster_prefs =
    {
      gunner = 2.0,
      mancubus = 0.9,
      revenant = 1.3,
      knight = 1.2,
      imp = 1.5,
      demon = 1.2,
      vile = 1.2,
      shooter = 1.33,
      zombie = 0.9,
      skull = 0.5,
      pain = 1.33,
    },

    beam_groups =
    {
      beam_gothic = 75,
      beam_quakeish = 30,
      beam_lights = 25,
      beam_lights_white = 40,
      beam_lights_vertical_tech = 30,
      beam_wood = 30,
      beam_textured = 50,
    },

    style_list =
    {
      doors = { few=40, some=85, heaps=25 },
      outdoors = { few=15, some=80, heaps=30 },
      steepness = { few=15, some=45, heaps=90 },
      pictures = { few=10, some=50, heaps=70 },
      big_rooms = { none=5, few=60, some=35, heaps=15 },
      big_outdoor_rooms = { none=10, few=50, some=30, heaps=10 },
      windows = { few=10, some=50, heaps=80 },
      ambushes = { few=25, some=40, heaps=50 },
      hallways = { none=20, few=70, some=20, heaps=5 },
      teleporters = { none=15, few=35, some=70, heaps=10 },
      keys = { none=5, few=20, some=90, heaps=35 },
      trikeys = { none=10, few=40, some=80, heaps=35 },
      liquids = { none=20, few=60, some=45, heaps=15 },
      traps = { few=25, some=80, heaps=60 },
      switches = { none=10, few=40, some=75, heaps=25 },
      cages    = { none=20, few=25, some=60, heaps=15 },
      symmetry = { none=45, few=55, some=25, heaps=25 },
      secrets = { few=15, some=80, heaps=35 },
      scenics = { few=5, some=45, heaps=90 },
      caves = { none=75, few=15, some=3 },
      barrels = { none=25, few=75, some=15, heaps=10 },
      porches = { none=5, few=15, some=35, heaps=85 },
      fences  = { none=10, few=10, some=70, heaps=40 },
      beams  = { few=20, some=50, heaps=40 },
      mon_variety = { some=10, heaps=95},
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.7,
    },

    skyboxes =
    {
      Skybox_generic = 50,
      Skybox_hellish_city = 50,
    },

    cage_lights = { 0, 1, 8, 12, 13, 17 },

  },

hell =
  {
    liquids =
    {
      lava   = 80,
      blood  = 40,
      slime  = 30,
      water  = 20,
      nukage = 5,
    },

    entity_remap =
    {
      k_red    = "ks_red",
      k_blue   = "ks_blue",
      k_yellow = "ks_yellow",
    },

    prefab_remap =
    {
      DOORBLU  = "DOORBLU2",
      DOORRED  = "DOORRED2",
      DOORYEL  = "DOORYEL2",

      BIGDOOR1 = "BIGDOOR6",
      BIGDOOR2 = "BIGDOOR7",
      BIGDOOR3 = "BIGDOOR7",
      BIGDOOR4 = "BIGDOOR5",

      SW1COMP  = "SW1LION",
      SW1PIPE  = "SW1BROWN",
    },

    park_decor =
    {
      burnt_tree = 75,
      brown_stub = 55,
      big_tree = 40,
      evil_eye   = 10,
      skull_rock = 20,
      skull_cairn = 25,
      skull_pole = 20,
      skull_kebab = 15,
      green_pillar = 5,
      green_column  = 5,
      green_column_hrt = 3,
      red_pillar = 5,
      red_column = 5,
      red_column_skl = 3,
    },

    beam_groups =
    {
      beam_gothic = 50,
      beam_quakeish = 50,
      beam_lights_vertical_hell = 50,
      beam_wood = 50,
      beam_textured = 50,
    },

    style_list =
    {
      doors = { none=15, few=60, some=30, heaps=15 },
      outdoors = { none=5, few=25, some=60, heaps=10 },
      steepness = { few=50, some=50, heaps=50 },
      pictures = { few=30, some=50, heaps=70 },
      big_rooms = { none=25, few=60, some=25, heaps=10 },
      big_outdoor_rooms = { none=15, few=25, some=80, heaps=15 },
      ambushes = { few=15, some=40, heaps=75 },
      hallways = { none=20, few=70, some=20, heaps=5 },
      teleporters = { none=10, few=25, some=60, heaps=20 },
      keys = { none=20, few=30, some=50, heaps=85 },
      trikeys = { none=20, few=30, some=80, heaps=50 },
      liquids = { none=15, few=20, some=65, heaps=15 },
      traps = { few=10, some=75, heaps=50 },
      switches = { none=20, few=30, some=60, heaps=10 },
      cages    = { none=10, few=40, some=85, heaps=20 },
      symmetry = { none=75, few=25, some=55, heaps=15 },
      secrets = { few=65, some=40, heaps=10 },
      scenics = { few=20, some=60, heaps=80},
      caves = { none=60, few=30, some=8, heaps=3 },
      barrels = { none=75, few=20, some=5, heaps=4 },
      porches = { few=25, some=80, heaps=40 },
      fences  = { none=10, few=15, some=80, heaps=35 },
      beams  = { none=15, few=25, some=70, heaps=20 },
      windows = { few=15, some=85, heaps=30 },
    },

    monster_prefs =
    {
      zombie  = 0.8,
      shooter = 1.2,
      vile    = 1.3,
      imp     = 1.5,
      demon   = 1.3,
      spectre = 1.3,
      skull   = 1.5,
      gunner  = 1.5,
      revenant = 1.35,
      mancubus = 1.3,
      knight = 1.25,
      Cyberdemon = 1.5,
      Mastermind = 1.5,
    },

    skyboxes =
    {
      Skybox_garrett_hell = 50,
      Skybox_hellish_city = 30,
    },

    ceil_light_prob = 30,
  }]]

-- Seeing if this works to set up Plutonia style traps and ambushes..
PLUTONIA.MONSTERS =
{

  shooter =
  {
    id = 9,
    r = 20,
    h = 56,
    level = 1.5,
    prob = 90,
    health = 30,
    damage = 3.0,
    attack = "hitscan",
    density = 1.0,
    give = { {weapon="shotty"}, {ammo="shell",count=4} },
    weap_prefs = { shotty=1.2, chain=1.5 },
    weap_needed = { shotty=true },
    species = "zombie",
    replaces = "zombie",
    replace_prob = 20,
    room_size = "any", --small
    disloyal = true,
    trap_factor = 2.5,
    infight_damage = 6.1,
  },

  imp =
  {
    id = 3001,
    r = 20,
    h = 56,
    level = 1,
    prob = 140,
    health = 60,
    damage = 1.3,
    attack = "missile",
    density = 1.0,
    replaces = "demon",
    replace_prob = 25,
    weap_prefs = { shotty=1.5, chain=1.25, super=1.2 },
    room_size = "any", --small
    trap_factor = 0.7, --0.3,
    infight_damage = 4.0,
  },

  demon =
  {
    id = 3002,
    r = 30,
    h = 56,
    level = 3,
    prob = 50,
    health = 150,
    damage = 0.4,
    attack = "melee",
    density = 1.0,
    weap_min_damage = 40,
    weap_prefs = { super=1.75, shotty=1.35, chain=1.3, plasma=1.1, launch=0.3 },
    room_size = "any",
    infight_damage = 3.5,
    trap_factor = 1.2,
    cage_factor = 0,
  },

  spectre =
  {
    id = 58,
    r = 30,
    h = 56,
    level = 3,
    replaces = "demon",
    replace_prob = 35,
    crazy_prob = 25,
    health = 150,
    damage = 1.0,
    attack = "melee",
    density = 0.7,
    invis = true,
    outdoor_factor = 3.0,
    weap_min_damage = 40,
    weap_prefs = { super=1.75, shotty=1.5, chain=1.4, plasma=1.1, launch=0.1 },
    species = "demon",
    room_size = "any",
    trap_factor = 1.2,
    infight_damage = 2.5,
    cage_factor = 0,
  },

  caco =
  {
    id = 3005,
    r = 31,
    h = 56,
    level = 4,
    prob = 30,
    health = 400,
    damage = 4.0,
    attack = "missile",
    density = 0.6,
    weap_min_damage = 40,
    float = true,
    weap_prefs = { launch=1.25, super=1.75, chain=1.2, shotty=0.7, plasma=1.2 },
    room_size = "large", --any
    trap_factor = 0.85,
    cage_factor = 0,
    infight_damage = 21,
  },

  gunner =
  {
    id = 65,
    r = 20,
    h = 56,
    level = 1.8,
    prob = 60,
    health = 70,
    damage = 5.5,
    attack = "hitscan",
    give = { {weapon="chain"}, {ammo="bullet",count=10} },
    weap_needed = { chain=true },
    weap_min_damage = 50,
    weap_prefs = { shotty=1.5, super=1.75, chain=2.0, plasma=1.2, launch=1.1 },
    density = 1.1,
    species = "zombie",
    room_size = "any",
    replaces = "shooter",
    replace_prob = 20,
    disloyal = true,
    trap_factor = 5.0,
    infight_damage = 25,
  },

  revenant =
  {
    id = 66,
    r = 20,
    h = 64,
    level = 4,
    prob = 28,
    health = 300,
    damage = 8.5,
    attack = "missile",
    weap_min_damage = 60,
    density = 0.8,
    weap_prefs = { launch=1.75, plasma=1.75, chain=1.5, super=1.25 },
    room_size = "any",
    replaces = "knight",
    replace_prob = 20,
    trap_factor = 4.0,
    infight_damage = 20,
    boss_replacement = "knight",
  },

  knight =
  {
    id = 69,
    r = 24,
    h = 64,
    level = 3,
    prob = 26,
    health = 500,
    damage = 4.0,
    attack = "missile",
    weap_min_damage = 50,
    weap_prefs = { launch=1.75, super=1.5, plasma=1.33 },
    density = 0.75,
    species = "baron",
    replaces = "mancubus",
    replace_prob = 25,
    room_size = "medium",
    infight_damage = 36,
    trap_factor = 1.5,
    boss_replacement = "baron",
  },

  mancubus =
  {
    id = 67,
    r = 48,
    h = 64,
    level = 4.5,
    prob = 20,
    health = 600,
    damage = 8.0,
    attack = "missile",
    weap_prefs = { launch=1.5, super=1.5, plasma=1.5, chain=1.2 },
    density = 0.45,
    outdoor_factor = 1.5,
    weap_min_damage = 88,
    replaces = "arach",
    replace_prob = 20,
    room_size = "large",
    infight_damage = 70,
    trap_factor = 1.2,
    boss_replacement = "baron",
  },

  arach =
  {
    id = 68,
    r = 64,
    h = 64,
    level = 5,
    prob = 12,
    health = 500,
    damage = 10.7,
    attack = "missile",
    outdoor_factor = 1.25,
    weap_min_damage = 60,
    weap_prefs = { launch=1.5, super=1.5, plasma=1.5, chain=1.2 },
    replaces = "mancubus",
    replace_prob = 25,
    density = 0.5,
    room_size = "medium",
    infight_damage = 62,
    boss_replacement = "knight",
  },

  vile =
  {
    id = 64,
    r = 20,
    h = 56,
    level = 5,
    boss_type = "nasty",
    boss_prob = 50,
    boss_limit = 2, --Why? Because of the endless revival party in a room full of monsters -Armaetus
    prob = 5,
    crazy_prob = 15,
    health = 700,
    damage = 25,
    attack = "hitscan",
    density = 0.17,
    room_size = "medium",
    weap_prefs = { launch=2.0, super=1.25, plasma=1.5, bfg=1.5 },
    weap_min_damage = 120,
    outdoor_factor = 0.4,
    nasty = true,
    infight_damage = 18,
    trap_factor = 1.25,
    boss_replacement = "baron",
  },

  pain =
  {
    id = 71,
    r = 31,
    h = 56,
    level = 5,
    boss_type = "nasty",
    boss_prob = 20,
    boss_limit = 4, --Number increased because Plutonia
    prob = 10,
    crazy_prob = 15,
    health = 900,  -- 400 + 5 skulls
    damage = 14.5, -- about 5 skulls
    attack = "missile",
    density = 0.15,
    float = true,
    weap_min_damage = 100,
    weap_prefs = { launch=1.0, super=1.25, chain=1.5, shotty=0.7 },
    room_size = "large", --any
    cage_factor = 0,  -- never put in cages
    outdoor_factor = 1.5,
    infight_damage = 4.5 -- guess
  },
}

function PLUTONIA.setup(self)
  if not PARAM.doom2_weapons then
    GAME.MONSTERS["gunner"] = nil
    GAME.MONSTERS["knight"] = nil
    GAME.MONSTERS["revenant"] = nil
    GAME.MONSTERS["mancubus"] = nil
    GAME.MONSTERS["arach"] = nil
    GAME.MONSTERS["vile"] = nil
    GAME.MONSTERS["pain"] = nil
    GAME.MONSTERS["ss_nazi"] = nil
  end

  for name,_ in pairs(pairs(PLUTONIA.MONSTERS)) do
    local M = GAME.MONSTERS[name]

    if M and factor then
      M.prob = M.prob * factor
      M.crazy_prob = (M.crazy_prob or M.prob) * factor
    end
  end
end

--------------------------------------------------------------------

OB_GAMES["plutonia"] =
{
  label = _("Plutonia"),

  extends = "doom2",

  iwad_name = "plutonia.wad",

  tables =
  {
    PLUTONIA
  },
}
