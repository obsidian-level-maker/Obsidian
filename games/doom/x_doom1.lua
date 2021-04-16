--------------------------------------------------------------------
--  DOOM 1 / ULTIMATE DOOM
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2011,2019, 2021 Chris Pisarczyk / Armaetus
--  Copyright (C) 2019 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------
--
--  NOTE:
--    Doom 1 and Ultimate Doom are treated here somewhat like a
--    mod of Doom 2.  Hence the MONSTERS table here removes all
--    the Doom 2 monsters and weapons (etc...)
--
--    This is not ideal, but seems better than the previous way
--    of mixing the two games in one file (DOOM1 vs DOOM2 tables)
--    which was probably very confusing to most people.
--

ULTDOOM = { }


ULTDOOM.PARAMETERS =
{
  skip_monsters = { 15,25,35 },

  episodic_monsters = true,

  doom2_monsters = false,
  doom2_weapons  = false,
  doom2_skies    = false
}


ULTDOOM.MATERIALS =
{
  -- These materials are unique to DOOM I / Ultimate DOOM...


  -- walls --

  ASHWALL  = { t="ASHWALL",  f="FLOOR6_2" },
  BROVINE  = { t="BROVINE",  f="FLOOR0_1" },
  BRNPOIS2 = { t="BRNPOIS2", f="FLOOR7_1" },
  BROWNWEL = { t="BROWNWEL", f="FLOOR7_1" },

  COMP2    = { t="COMP2",    f="CEIL5_1" },
  COMPOHSO = { t="COMPOHSO", f="FLOOR7_1" },
  COMPTILE = { t="COMPTILE", f="CEIL5_1" },
  COMPUTE1 = { t="COMPUTE1", f="FLAT19" },
  COMPUTE2 = { t="COMPUTE2", f="CEIL5_1" },
  COMPUTE3 = { t="COMPUTE3", f="CEIL5_1" },

  DOORHI   = { t="DOORHI",   f="FLAT19" },
  GRAYDANG = { t="GRAYDANG", f="FLAT19" },
  GSTVINE1 = { t="GSTVINE1", f="FLOOR7_2" },
  ICKDOOR1 = { t="ICKDOOR1", f="FLAT19" },
  ICKWALL6 = { t="ICKWALL6", f="FLAT18" },

  LITE2    = { t="LITE2",    f="FLOOR0_1" },
  LITE4    = { t="LITE4",    f="FLAT19" },
  LITE96   = { t="LITE96",   f="FLOOR7_1" },
  LITEBLU2 = { t="LITEBLU2", f="FLAT23" },
  LITEBLU3 = { t="LITEBLU3", f="FLAT23" },
  LITEMET  = { t="LITEMET",  f="FLOOR4_8" },
  LITERED  = { t="LITERED",  f="FLOOR1_6" },
  LITESTON = { t="LITESTON", f="MFLR8_1" },

  NUKESLAD = { t="NUKESLAD", f="FLOOR7_1" },
  PLANET1  = { t="PLANET1",  f="FLAT23" },
  REDWALL1 = { t="REDWALL1", f="FLOOR1_6" },
  SKINBORD = { t="SKINBORD", f="FLAT5_5" },
  SKINTEK1 = { t="SKINTEK1", f="FLAT5_5" },
  SKINTEK2 = { t="SKINTEK2", f="FLAT5_5" },
  SKULWAL3 = { t="SKULWAL3", f="FLAT5_6" },
  SKULWALL = { t="SKULWALL", f="FLAT5_6" },
  SLADRIP1 = { t="SLADRIP1", f="FLOOR7_1" },

  SP_DUDE6 = { t="SP_DUDE6", f="DEM1_5" },
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" },
  SP_ROCK2 = { t="SP_ROCK2", f="MFLR8_3" },
  STARTAN1 = { t="STARTAN1", f="FLOOR4_1" },
  STONGARG = { t="STONGARG", f="MFLR8_1" },
  STONPOIS = { t="STONPOIS", f="FLAT5_4" },
  TEKWALL2 = { t="TEKWALL2", f="CEIL5_1" },
  TEKWALL3 = { t="TEKWALL3", f="CEIL5_1" },
  TEKWALL5 = { t="TEKWALL5", f="CEIL5_1" },
  WOODSKUL = { t="WOODSKUL", f="FLAT5_2" },


  -- switches --

  SW1BRN1  = { t="SW1BRN1",  f="FLOOR0_1" },
  SW1STARG = { t="SW1STARG", f="FLAT23" },
  SW1STONE = { t="SW1STONE", f="FLAT1" },
  SW1STON2 = { t="SW1STON2", f="MFLR8_1" },


  -- floors --

  FLAT5_6  = { f="FLAT5_6", t="SKULWALL" },
  FLAT5_7  = { f="FLAT5_7", t="ASHWALL" },
  FLAT5_8  = { f="FLAT5_8", t="ASHWALL" },
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL" },
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL" },


  -- flats with different side textures --

  CONS1_1  = { f="CONS1_1", t="COMPWERD" },
  CONS1_5  = { f="CONS1_5", t="COMPWERD" },
  CONS1_7  = { f="CONS1_7", t="COMPWERD" },

  FLAT8    = { f="FLAT8",   t="BROWN1" },
  FLAT10   = { f="FLAT10",  t="BROWNHUG" },
  FLAT1_1  = { f="FLAT1_1", t="BROWN1" },
  FLAT1_2  = { f="FLAT1_2", t="BROWN1" },
  FLAT1_3  = { f="FLAT1_3", t="BROWN1" },
  FLAT5_5  = { f="FLAT5_5", t="BROWN1" },


  -- rails --

  BRNBIGC  = { t="BRNBIGC",  rail_h=128 },

  MIDVINE1 = { t="MIDVINE1", rail_h=128 },
  MIDVINE2 = { t="MIDVINE2", rail_h=128 },

  -- this is the MIDBARS3 texture from FreeDoom
  MIDBARS3 = { t="SP_DUDE3", rail_h=72 },


  -- liquid stuff (using new patches)
  BFALL1   = { t="BLODGR1",  f="BLOOD1", sane=1 },
  BLOOD1   = { t="BLODGR1",  f="BLOOD1", sane=1 },

  SFALL1   = { t="SLADRIP1", f="NUKAGE1", sane=1 },
  NUKAGE1  = { t="SLADRIP1", f="NUKAGE1", sane=1 },


  --------------------------------------------------------------------
  --
  -- Compatibility section
  --
  -- These allow prefabs containing DOOM 2 specific flats or textures
  -- to at least work in DOOM / Ultimate DOOM (a bit mucked up though).
  --
  -- Big thanks to Chris Pisarczyk for doing the grunt work.
  --

  -- flats
  GRASS1   = { f="DEM1_5",   t="MARBLE1" },
  GRASS2   = { f="DEM1_5",   t="MARBLE1" },
  GRNLITE1 = { f="TLITE6_6", t="METAL" },
  GRNROCK  = { f="MFLR8_3",  t="SP_ROCK1" },

  RROCK01  = { f="FLOOR6_1", t="REDWALL" },
  RROCK02  = { f="LAVA1",    t="FIREMAG1" },
  RROCK03  = { f="FLOOR6_2", t="ASHWALL" },
  RROCK04  = { f="FLOOR6_2", t="ASHWALL" },
  RROCK05  = { f="FLOOR6_1", t="REDWALL" },
  RROCK06  = { f="FLOOR6_1", t="REDWALL" },
  RROCK07  = { f="FLOOR6_1", t="REDWALL" },
  RROCK08  = { f="FLOOR6_1", t="REDWALL" },
  RROCK09  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK10  = { f="FLAT5",    t="BROWNHUG" },
  RROCK11  = { f="FLAT5",    t="BROWNHUG" },
  RROCK12  = { f="FLAT5",    t="BROWNHUG" },
  RROCK13  = { f="MFLR8_3",  t="SP_ROCK1" },
  RROCK14  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK15  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK16  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK17  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK18  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK19  = { f="FLOOR7_1", t="BROWNHUG" },
  RROCK20  = { f="FLOOR7_2", t="MARBLE1" },

  SLIME01  = { f="NUKAGE1",  t="SLADRIP1" },
  SLIME02  = { f="NUKAGE1",  t="SLADRIP1" },
  SLIME03  = { f="NUKAGE1",  t="SLADRIP1" },
  SLIME04  = { f="NUKAGE1",  t="SLADRIP1" },
  SLIME05  = { f="BLOOD1",   t="BLODGR1" },
  SLIME06  = { f="BLOOD1",   t="BLODGR1" },
  SLIME07  = { f="BLOOD1",   t="BLODGR1" },
  SLIME08  = { f="BLOOD1",   t="BLODGR1" },
  SLIME09  = { f="FLOOR6_1", t="REDWALL" },
  SLIME10  = { f="FLOOR6_1", t="REDWALL" },
  SLIME11  = { f="FLOOR6_1", t="REDWALL" },
  SLIME12  = { f="FLOOR6_1", t="REDWALL" },
  SLIME13  = { f="FLOOR7_2", t="MARBLE1" },
  SLIME14  = { f="FLOOR4_8", t="METAL1" },
  SLIME15  = { f="FLOOR4_8", t="METAL1" },
  SLIME16  = { f="FLAT1_1",  t="BROWN1" },

  -- textures
  ASHWALL2 = { t="ASHWALL",  f="FLOOR6_2" },
  ASHWALL3 = { t="BROWNHUG", f="FLOOR7_1" },
  ASHWALL4 = { t="BROWNHUG", f="FLOOR7_1" },
  ASHWALL6 = { t="PIPE2",    f="FLOOR4_5" },
  ASHWALL7 = { t="PIPE4",    f="FLOOR4_5" },
  BIGBRIK1 = { t="BROWN96",  f="FLOOR7_1" },
  BIGBRIK2 = { t="STONE2",   f="MFLR8_1" },
  BIGBRIK3 = { t="LITE3",    f="FLAT19" },
  BLAKWAL1 = { t="COMPSPAN", f="CEIL5_1" },
  BLAKWAL2 = { t="COMPSPAN", f="CEIL5_1" },

  BRICK1   = { t="BROWN1",   f="FLOOR0_1" },
  BRICK10  = { t="BROWNGRN", f="FLOOR7_1" },
  BRICK11  = { t="REDWALL",  f="FLAT5_3" },
  BRICK12  = { t="BROWN1",   f="FLOOR0_1" },
  BRICK2   = { t="BROWN1",   f="FLOOR0_1" },
  BRICK3   = { t="BROWN1",   f="FLOOR0_1" },
  BRICK4   = { t="BROVINE",  f="FLOOR0_1" },
  BRICK5   = { t="BROVINE2", f="FLOOR7_1" },
  BRICK6   = { t="BROWN1",   f="FLOOR0_1" },
  BRICK7   = { t="BROWN96",  f="FLOOR7_1" },
  BRICK8   = { t="BROWN96",  f="FLOOR7_1" },
  BRICK9   = { t="BROWN144", f="FLOOR7_1" },
  BRICKLIT = { t="LITEMET",  f="CEIL5_1" },
  BRONZE1  = { t="BROWN96",  f="FLOOR7_1" },
  BRONZE2  = { t="BROWN96",  f="FLOOR7_1" },
  BRONZE3  = { t="BROWN96",  f="FLOOR7_1" },
  BRONZE4  = { t="LITE96",   f="FLOOR7_1" },
  BRWINDOW = { t="BROWN1",   f="FLOOR0_1" },
  BSTONE1  = { t="SLADWALL", f="FLOOR7_1" },
  BSTONE2  = { t="SLADWALL", f="FLOOR7_1" },
  BSTONE3  = { t="LITE3",    f="FLAT19" },

  CEMENT7  = { t="GRAY1",    f="FLAT18" },
  CEMENT8  = { t="GRAY5",    f="FLAT18" },
  CEMENT9  = { t="GRAYVINE", f="FLAT1" },
  CRACKLE2 = { t="ROCKRED1", f="FLOOR6_1" },
  CRACKLE4 = { t="ROCKRED1", f="FLOOR6_1" },
  CRATE3   = { t="CRATELIT", f="CRATOP1" },
  DBRAIN1  = { t="FIREBLU1", f="FLOOR6_1" },
  DBRAIN2  = { t="FIREBLU1", f="FLOOR6_1" },
  DBRAIN3  = { t="FIREBLU1", f="FLOOR6_1" },
  DBRAIN4  = { t="FIREBLU1", f="FLOOR6_1" },
  MARBFAC4 = { t="SP_DUDE6", f="DEM1_5" },
  MARBGRAY = { t="GSTONE1",  f="FLOOR7_2" },

  METAL2   = { t="METAL1",   f="FLOOR4_8" },
  METAL3   = { t="METAL1",   f="FLOOR4_8" },
  METAL4   = { t="METAL1",   f="FLOOR4_8" },
  METAL5   = { t="METAL1",   f="FLOOR4_8" },
  METAL6   = { t="METAL1",   f="FLOOR4_8" },
  METAL7   = { t="LITE3",    f="FLAT19" },
  MODWALL1 = { t="ICKWALL1", f="FLAT19" },
  MODWALL2 = { t="ICKWALL1", f="FLAT19" },
  MODWALL3 = { t="ICKWALL3", f="FLAT19" },
  MODWALL4 = { t="ICKWALL3", f="FLAT19" },

  PANBLACK = { t="LITE5",    f="FLAT19" },
  PANBLUE  = { t="LITEBLU4", f="FLAT1" },
  PANBOOK  = { t="WOODSKUL", f="FLAT5_2" },
  PANBORD1 = { t="WOOD1",    f="FLAT5_2" },
  PANBORD2 = { t="WOOD1",    f="FLAT5_2" },
  PANCASE1 = { t="WOOD1",    f="FLAT5_2" },
  PANCASE2 = { t="WOOD1",    f="FLAT5_2" },
  PANEL1   = { t="SKINMET1", f="CEIL5_2" },
  PANEL2   = { t="SKINMET1", f="CEIL5_2" },
  PANEL3   = { t="SKINMET1", f="CEIL5_2" },
  PANEL4   = { t="WOOD1",    f="FLAT5_2" },
  PANEL5   = { t="WOODGARG", f="FLAT5_2" },
  PANEL6   = { t="WOOD3",    f="FLAT5_1" },
  PANEL7   = { t="WOOD3",    f="FLAT5_1" },
  PANEL8   = { t="WOOD3",    f="FLAT5_1" },
  PANEL9   = { t="WOOD3",    f="FLAT5_1" },
  PANRED   = { t="LITERED",  f="FLOOR1_6" },
  PIPES    = { t="BROWNPIP", f="FLOOR0_1" },
  PIPEWAL1 = { t="PIPE2",    f="FLOOR4_5" },
  PIPEWAL2 = { t="PIPE2",    f="FLOOR4_5" },
  ROCK1    = { t="STONE2",   f="MFLR8_1" },
  ROCK2    = { t="STONE3",   f="MFLR8_1" },
  ROCK3    = { t="STONE2",   f="MFLR8_1" },
  ROCK4    = { t="SP_ROCK1", f="MFLR8_3" },
  ROCK5    = { t="SP_ROCK1", f="MFLR8_3" },

  SILVER1  = { t="SHAWN2",   f="FLAT23" },
  SILVER2  = { t="COMPUTE1", f="FLAT23" },
  SILVER3  = { t="PLANET1",  f="FLAT23" },
  SPACEW2  = { t="TEKWALL4", f="CEIL5_1" },
  SPACEW3  = { t="COMPUTE1", f="FLAT1" },
  SPACEW4  = { t="TEKWALL1", f="CEIL5_1" },
  SPCDOOR1 = { t="BIGDOOR4", f="FLOOR3_3" },
  SPCDOOR2 = { t="BIGDOOR2", f="FLAT1" },
  SPCDOOR3 = { t="BIGDOOR2", f="FLAT1" },
  SPCDOOR4 = { t="BIGDOOR4", f="FLOOR3_3" },

  SK_LEFT  = { t="SKULWAL3", f="FLAT5_6" },
  SK_RIGHT = { t="SKULWAL3", f="FLAT5_6" },
  SLOPPY1  = { t="SKULWAL3", f="FLAT5_6" },
  SLOPPY2  = { t="SKULWAL3", f="FLAT5_6" },
  SP_DUDE7 = { t="SKULWAL3", f="FLAT5_6" },
  SP_DUDE8 = { t="SKULWALL", f="FLAT5_6" },
  SP_FACE2 = { t="SKULWAL3", f="FLAT5_6" },

  STONE4   = { t="STONE",    f="FLAT5_4" },
  STONE5   = { t="STONE",    f="FLAT5_4" },
  STONE6   = { t="BROWNHUG", f="FLOOR7_1" },
  STONE7   = { t="BROWNHUG", f="FLOOR7_1" },
  STUCCO   = { t="SKINTEK1", f="FLAT5_5" },
  STUCCO1  = { t="SKINTEK1", f="FLAT5_5" },
  STUCCO2  = { t="SKINTEK2", f="FLAT5_5" },
  STUCCO3  = { t="SKINTEK2", f="FLAT5_5" },

  SW1BRIK  = { t="SW1STONE", f="FLAT1" },
  SW1MARB  = { t="SW1GSTON", f="FLOOR7_2" },
  SW1MET2  = { t="SW1GARG",  f="CEIL5_2" },
  SW1MOD1  = { t="SW1GRAY1", f="FLAT19" },
  SW1PANEL = { t="SW1WOOD",  f="FLAT5_2" },
  SW1ROCK  = { t="SW1SATYR", f="CEIL5_2" },
  SW1SKULL = { t="SW1SKIN",  f="CRATOP2" },
  SW1STON6 = { t="SW1DIRT",  f="FLOOR7_1" },
  SW1TEK   = { t="SW1STRTN", f="FLOOR4_1" },
  SW1WDMET = { t="SW1LION",  f="CEIL5_2" },
  SW1ZIM   = { t="SW1SLAD",  f="FLOOR7_1" },

  TANROCK2 = { t="BROWNHUG", f="FLOOR7_1" },
  TANROCK3 = { t="BROWNHUG", f="FLOOR7_1" },
  TANROCK4 = { t="BROWNHUG", f="FLOOR7_1" },
  TANROCK5 = { t="BROWNHUG", f="FLOOR7_1" },
  TANROCK7 = { t="BROWN144", f="FLOOR7_1" },
  TANROCK8 = { t="BROVINE",  f="FLOOR0_1" },
  TEKBRON1 = { t="TEKWALL4", f="CEIL5_1" },
  TEKBRON2 = { t="TEKWALL4", f="CEIL5_1" },
  TEKGREN1 = { t="STARG1",   f="FLAT23" },
  TEKGREN2 = { t="STARG1",   f="FLAT23" },
  TEKGREN3 = { t="STARG1",   f="FLAT23" },
  TEKGREN4 = { t="STARG2",   f="FLAT23" },
  TEKGREN5 = { t="LITE3",    f="FLAT19" },
  TEKLITE  = { t="LITE3",    f="FLAT19" },
  TEKLITE2 = { t="LITE4",    f="FLAT19" },
  TEKWALL6 = { t="TEKWALL4", f="CEIL5_1" },

  WOOD6    = { t="WOOD5",    f="CEIL5_2" },
  WOOD7    = { t="WOOD3",    f="FLAT5_1" },
  WOOD8    = { t="WOOD3",    f="FLAT5_1" },
  WOOD9    = { t="WOOD1",    f="FLAT5_2" },
  WOOD10   = { t="WOOD1",    f="FLAT5_2" },
  WOOD12   = { t="WOOD1",    f="FLAT5_2" },
  WOODMET1 = { t="WOOD5",    f="CEIL5_2" },
  WOODMET2 = { t="WOOD5",    f="CEIL5_2" },
  WOODMET3 = { t="WOOD5",    f="CEIL5_2" },
  WOODMET4 = { t="WOOD5",    f="CEIL5_2" },
  WOODVERT = { t="WOOD3",    f="FLAT5_1" },

  ZDOORB1  = { t="SHAWN2",   f="FLAT23" },
  ZDOORF1  = { t="SHAWN2",   f="FLAT23" },
  ZELDOOR  = { t="BIGDOOR2", f="FLAT1" },

  ZIMMER1  = { t="SP_ROCK1", f="MFLR8_3" },
  ZIMMER2  = { t="SP_ROCK1", f="MFLR8_3" },
  ZIMMER3  = { t="BROWNHUG", f="FLOOR7_1" },
  ZIMMER4  = { t="BROWNHUG", f="FLOOR7_1" },
  ZIMMER5  = { t="ASHWALL",  f="FLOOR6_2" },
  ZIMMER7  = { t="ASHWALL",  f="FLOOR6_2" },
  ZIMMER8  = { t="SP_ROCK1", f="MFLR8_3" },

  ZZZFACE4 = { t="MARBFACE", f="DEM1_5" },

  -- rails
  MIDBARS1 = { t="MIDGRATE", rail_h=128 },
  MIDBRONZ = { t="MIDGRATE", rail_h=128 },
  MIDSPACE = { t="MIDGRATE", rail_h=128 },
}


--------------------------------------------------------------------

ULTDOOM.WEAPONS =
{
  super = REMOVE_ME
}


ULTDOOM.NICE_ITEMS =
{
  mega = REMOVE_ME
}


ULTDOOM.MONSTERS =
{
  gunner   = REMOVE_ME,
  revenant = REMOVE_ME,
  knight   = REMOVE_ME,
  mancubus = REMOVE_ME,
  arach    = REMOVE_ME,
  vile     = REMOVE_ME,
  pain     = REMOVE_ME,
  ss_nazi  = REMOVE_ME
}


ULTDOOM.ENTITIES =
{
  -- compatible replacements for things lacking in DOOM 1 / Ultimate DOOM

  mercury_lamp  = { id=2028, r=16, h=48 },
  mercury_small = { id=2028, r=16, h=48 },

  gutted_victim1 = { id=59, r=20, h=84, ceil=true, pass=true },
  gutted_victim2 = { id=61, r=20, h=52, ceil=true, pass=true },

  gutted_torso1  = { id=59, r=20, h=84, ceil=true, pass=true },
  gutted_torso2  = { id=61, r=20, h=52, ceil=true, pass=true },
  gutted_torso3  = { id=63, r=20, h=68, ceil=true, pass=true },
  gutted_torso4  = { id=63, r=20, h=68, ceil=true, pass=true },

  pool_blood_1  = { id=24, r=20, h=16, pass=true },
  pool_blood_2  = { id=24, r=20, h=16, pass=true },
  pool_brains   = { id=10, r=20, h=16, pass=true },
}


--------------------------------------------------------------------

ULTDOOM.THEMES =
{
  DEFAULTS =
  {
    keys =
    {
      k_red    = 50,
      k_blue   = 50,
      k_yellow = 50,
    },

    window_groups =
    {
      square = 90,
      tall   = 30,
      grate  = 10,
    },

    narrow_halls =
    {
      vent = 50,
    },

    wide_halls =
    {
      deuce = 50,
      metro = 20,
    },

    barrels =
    {
      barrel = 50,
    },

    passable_decor =
    {
      gibs = 40,

      gibbed_player = 10,
      dead_player = 10,
      dead_zombie = 3,
      dead_shooter = 3,
      dead_imp = 3,
      dead_demon = 1,
      dead_caco  = 1,
    },

    cave_torches =
    {
      red_torch   = 60,
      green_torch = 40,
      blue_torch  = 20,
    },

    cliff_trees =
    {
      burnt_tree = 80,
      brown_stub = 40,
        big_tree = 20,
    },

    park_decor =
    {
      burnt_tree = 80,
      brown_stub = 40,
        big_tree = 20,
    },

    fences =
    {
      BROWN144 = 60,
      WOOD5    = 40,
      STONE    = 30,
      SLADWALL = 20,

      BROVINE  = 15,
      GRAYVINE = 15,
      GSTVINE2 = 15,
      SP_ROCK1 =  5,
    },

    cage_mats =
    {
      METAL1   = 60,
      BROWN144 = 60,
      ICKWALL3 = 60,

      STONE    = 20,
      SLADWALL = 20,
      WOOD1    = 20,
    },

    --  8 = oscillates
    -- 12 = flashes @ 1 hz
    -- 13 = flashes @ 2 hz
    -- 17 = flickering
    cage_lights = { 0, 8, 12, 13, 17 },

    wall_groups =
    {
      PLAIN = 100,
    },

    ceil_light_prob = 60,
  },


  ---- Episode 1 ----

  tech =
  {
    liquids =
    {
      nukage = 80,
      water  = 30,
      lava   = 10,
    },

    facades =
    {
      BROWN1 = 50,
      BROWNGRN = 20,
      BROWN96 = 5,
      STONE2 = 10,
      STONE3 = 10,
      STARTAN3 = 30,
      STARG3 = 20,
      BROVINE2 = 5,
      BROVINE  = 5,
    },

    prefab_remap =
    {
    },

    floor_sinks =
    {
      liquid_plain = 10,
      liquid_shiny = 5,
      liquid_metal = 5,
      floor_blue  = 10,
      floor_blue3 = 5,
    },

    ceiling_sinks =
    {
      sky_shiny = 20,
      sky_metal = 10,
      sky_tech3 = 2,
      light_red_shiny = 20,
      light_orange_shiny = 7,
      light_brightred_metal = 7,
      light_brightred_metal2 = 5,
      light_diamond = 3,
      light_side1 = 5,
      light_side4 = 5,
    },

    street_sinks =
    {
      floor_default_streets = 1,
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

    wall_groups =
    {
      low_gap = 2,
      mid_band = 3,
      lite2 = 10,
      torches6 = 8,
      torches7 = 35,
      torches11 = 12,
      gtd_wall_urban_storage = 10,
      gtd_wall_tech_top_corner_light_set = 25,
      gtd_wall_server_room = 25,
      gtd_wall_sewer = 10,
      gtd_generic_beamed_inset = 7,
      gtd_computers = 35,
      gtd_writhing_mass = 2,
      gtd_wall_octagon_insets = 18,
      gtd_wall_grated_machines = 15,
      gtd_wall_quakish_insets = 20,
      gtd_ribbed_lights = 15,
      gtd_wall_high_gap_set = 10,
      gtd_wall_high_gap_alt_set = 10,
      gtd_generic_half_floor = 15,
      gtd_wall_urban_cement_frame = 10,
      gtd_generic_ceilwall = 25,
    },

    fence_groups =
    {
      PLAIN = 50,
      gappy = 50,
      fence_tech_lit = 50,
    },

    fence_posts =
    {
      Post_metal = 50,
      Post_tech_1 = 50,
      Post_tech_2 = 50,
      Post_tech_simple = 50,
    },

    cage_mats =
    {
      METAL1   = 60,
      BROWN144 = 60,
      STONE    = 50,
      SHAWN2   = 40,
      TEKWALL1 = 40,
      TEKWALL4 = 40,
      STONE2   = 20,
    },

    fences =
    {
      METAL1   = 60,
      STONE    = 60,
      STARG1   = 30,
      STONE2   = 20,
      STONE3   = 30,
      BROVINE  = 20,
      BROVINE2 = 20,
      GRAY1    = 20,
    },

    passable_decor =
    {
      gibs = 60,
      gibbed_player = 20,
      dead_player = 35,
    },

    park_decor =
    {
      burnt_tree = 95,
      brown_stub = 55,
      big_tree = 30,
    },

    window_groups =
    {
      square = 90,
      tall   = 90,
      grate  = 40,
      barred = 10,
      round  = 5,
      supertall = 70,
      gtd_window_cage_highbars = 20,
      gtd_window_cage_lowbars = 10,
      gtd_window_full_open = 15,
      gtd_window_full_open_tall = 15,
      gtd_window_bay = 20,
      gtd_window_absurdly_open = 25,
      gtd_window_quakeish = 20,
      gtd_window_low = 10,
      gtd_window_weabdows = 20,
      gtd_window_metal_frames = 20,
      gtd_window_construction_frames = 20,
    },

    cave_torches =
    {
      lamp        = 25,
      red_torch   = 70,
    },

    outdoor_torches =
    {
      lamp   = 40,
      red_torch = 15,
    },

    style_list =
    {
      caves = { none=70, few=30 },
      outdoors = { few=70, some=30, heaps=10 },
      big_rooms = { none=50, few=25, some=10, heaps=5 },
      big_outdoor_rooms = { none=25, few=30, some=70, heaps=10 },
      hallways = { none=20, few=45, some=20, heaps=10 },
      windows = { few=15, some=85, heaps=40 },
      pictures = { few=20, some=75, heaps=45 },
      liquids = { none=50, few=35, some=10, heaps=5 },
      doors = { few=25, some=75, heaps=30 },
      teleporters = { none=75, few=30, some=10, heaps=3 },
      keys = { none=15, few=40, some=70, heaps=30 },
      trikeys = { none=15, few=70, some=30, heaps=10 },
      switches = { none=25, few=75, some=40, heaps=15 },
      secrets = { few=15, some=80, heaps=30 },
      symmetry = { none=50, few=50, some=50, heaps=50 },
      steepness = { few=30, some=70, heaps=40 },
      scenics = { none=3, few=10, some=80, heaps=25 },
      cages = { none=70, few=20, some=10, heaps=2 },
      traps = { few=60, some=40, heaps=15 },
      barrels = { few=5, some=85, heaps=60 },
      ambushes = { few=35, some=65, heaps=20 },
      beams  = { none=10, few=15, some=40, heaps=5 },
      porches = { none=15, few=40, some=60, heaps=30 },
      fences = { none=5, few=40, some=60, heaps=15 },
    },

    scenic_fences =
    {
      MIDGRATE = 50,
    },

    monster_prefs =
    {
      zombie  = 2.0,
      shooter = 1.25,
      imp     = 1.5,
      demon   = 1.25,
      caco    = 0.5,
      baron   = 0.35,
      skull   = 0.2,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    skyboxes =
    {
      Skybox_generic = 50,
    },

  ceil_light_prob = 70,

  },


  ---- Episode 2 ----

  -- Deimos theme by Chris Pisarczyk / Armaetus

  deimos =
  {
    liquids =
    {
      nukage = 60,
      blood  = 20,
      water  = 10,
      lava   = 3,
    },

    -- Best facades would be STONE/2/3, BROVINE/2, BROWN1 and maybe a few others as I have not seen many
    -- other textures on the episode 2 exterior.
    facades =
    {
      STONE2 = 40,
      STONE3 = 60,
      BROVINE = 30,
      BROVINE2 = 25,
      BROWN1 = 50,
      BROWNGRN = 20,
      STONE    = 15,
    },

    prefab_remap =
    {
    },

    floor_sinks =
    {
      liquid_plain = 10,
      liquid_shiny = 5,
      liquid_metal = 5,
      floor_green = 5,
      floor_blue  = 10,
      floor_blue2 = 5,
      floor_blue3 = 5,
    },

    ceiling_sinks =
    {
      sky_shiny = 20,
      sky_metal = 10,
      light_red_shiny = 20,
      light_orange_shiny = 7,
      light_brightred_metal = 7,
      ceil_icky = 4,
      ceil_vdark2 = 3,
      light_side1 = 4,
      light_side2 = 4,
      light_side3 = 4,
    },

    street_sinks =
    {
      floor_default_streets = 1,
    },

    park_decor =
    {
      burnt_tree = 95,
      brown_stub = 55,
      big_tree = 40,
    },

    fences =
    {
      METAL1   = 90,
      BROVINE  = 60,
      STONE3   = 40,
      STONE2   = 40,
      BROVINE2 = 30,
      GRAY1    = 20,
      ICKWALL3 = 20,
    },

    sink_style =
    {
      curved = 1,
      sharp = 1,
    },

    skyboxes =
    {
      Skybox_generic = 50,
      Skybox_garrett_hell = 50,
    },

    beam_groups =
    {
      beam_gothic = 50,
      beam_shiny = 25,
      beam_quakeish = 50,
      beam_lights = 25,
      beam_lights_white = 25,
      beam_lights_vertical_tech = 25,
      beam_lights_vertical_hell = 25,
      beam_textured = 50,
    },

   -- This is because of the slow Hellification of the Deimos base, hence a few Hell wall prefabs are here.
    wall_groups =
    {
      low_gap = 7,
      mid_band = 5,
      lite2 = 5,
      torches1 = 5,
      torches2 = 5,
      torches3 = 3,
      torches6 = 10,
      torches7 = 50,
      torches8 = 10,
      torches11 = 15,
      runes1 = 1,
      runes2 = 1,
      runes3 = 1,
      runes4 = 1,
      runes5 = 1,
      cross1 = 1,
      cross2 = 3,
      cross3 = 1,
      cross4 = 1,
      cross5 = 3,
      mid_band_hell = 1,
      gtd_wall_urban_storage = 20,
      gtd_wall_tech_top_corner_light_set = 30,
      gtd_wall_server_room = 30,
      gtd_wall_sewer = 10,
      gtd_generic_beamed_inset = 10,
      gtd_computers = 45,
      gtd_writhing_mass = 4,
      gtd_wall_octagon_insets = 25,
      gtd_wall_grated_machines = 20,
      gtd_wall_quakish_insets = 25,
      gtd_ribbed_lights = 15,
      gtd_wall_high_gap_set = 8,
      gtd_wall_high_gap_alt_set = 8,
      gtd_generic_half_floor = 15,
      gtd_wall_urban_cement_frame = 10,
      gtd_generic_ceilwall = 25,
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 50,
      gappy = 50,
      fence_tech_lit = 50,
      fence_gothic = 50,
    },

    fence_posts =
    {
      Post_metal = 50,
      Post_tech_1 = 40,
      Post_tech_2 = 40,
      Post_gothic_blue = 10,
      Post_gothic_green = 10,
      Post_gothic_red = 10,
      Post_gothic_blue_2 = 10,
      Post_gothic_green_2 = 10,
      Post_gothic_red_2 = 10,
    },

    -- Copied from the Tech theme and altered a bit.
    window_groups =
    {
      square = 70,
      tall   = 90,
      grate  = 40,
      barred = 5,
      round  = 10,
      supertall = 70,
      gtd_window_cage_highbars = 20,
      gtd_window_cage_lowbars = 10,
      gtd_window_full_open = 15,
      gtd_window_full_open_tall = 15,
      gtd_window_bay = 20,
      gtd_window_absurdly_open = 40,
      gtd_window_quakeish = 20,
      gtd_window_low = 10,
      gtd_window_weabdows = 20,
      gtd_window_metal_frames = 20,
      gtd_window_construction_frames = 20,
    },

    ceil_light_prob = 65,

    style_list =
    {
      caves = { none=60, few=40 },
      outdoors = { few=40, some=70, heaps=10 },
      big_rooms = { none=40, few=35, some=15, heaps=5 },
      hallways = { none=15, few=45, some=20, heaps=10 },
      windows = { few=15, some=85, heaps=40 },
      pictures = { few=20, some=75, heaps=45 },
      liquids = { none=60, few=30, some=12, heaps=5 },
      doors = { few=25, some=75, heaps=30 },
      teleporters = { none=55, few=40, some=15, heaps=3 },
      keys = { none=15, few=60, some=70, heaps=40 },
      trikeys = { few=40, some=80, heaps=20 },
      switches = { none=20, few=65, some=50, heaps=15 },
      secrets = { few=12, some=80, heaps=30 },
      symmetry = { none=50, few=50, some=50, heaps=50 },
      steepness = { few=40, some=80, heaps=35 },
      scenics = { few=20, some=50, heaps=85},
      cages = { none=55, few=35, some=10, heaps=5 },
      traps = { few=40, some=60, heaps=30 },
      barrels = { few=10, some=55, heaps=30 },
      ambushes = { few=20, some=95, heaps=30 },
      beams  = { none=10, few=15, some=40, heaps=5 },
      porches = { none=15, few=20, some=80, heaps=45 },
      fences = { none=10, few=20, some=80, heaps=30 },
    },

    scenic_fences =
    {
      MIDGRATE = 50,
      MIDBRN1  = 10,
    },
  },


  ---- Episode 3 ----

  hell =
  {
    --  Water is seen in a few locations in episode 3 -Chris

    liquids =
    {
      lava   = 90,
      blood  = 30,
      water  = 10,
      nukage = 5,
    },

    entity_remap =
    {
      k_red    = "ks_red",
      k_blue   = "ks_blue",
      k_yellow = "ks_yellow",
    },

    facades =
    {
      STONE2 = 10,
      STONE3 = 15,
      WOOD1 = 50,
      GSTONE1 = 50,
      MARBLE1 = 30,
      BROWN1 = 5,
      BROWNGRN = 5,
      WOOD5 = 30,
      SP_HOT1 = 15,
      SKINMET1 = 10,
      SKINMET2 = 10,
      SKINTEK1 = 10,
      SKINTEK2 = 10,
      STONE = 5,
    },

    fences =
    {
      WOOD5 = 50,
      WOOD3 = 50,
      STONE3 = 40,
      STONE2 = 35,
      MARBLE2 = 30,
      GSTONE1 = 30,
      ASHWALL = 20,
      SKIN2   = 20,
      SKINFACE = 20,
      FIREBLU1 = 20,
      ICKWALL3 = 15,
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
      SILVER3  = "MARBFACE",
    },

    floor_sinks =
    {
      liquid_plain = 10,
      liquid_blood = 10,
      floor_skulls = 20,
      floor_glowingrock = 10,
      floor_snakes = 5,
      floor_red = 5,
      liquid_firelava = 5,
      liquid_ash = 4,
      liquid_marble = 4,
    },

    ceiling_sinks =
    {
      sky_metal = 20,
      sky_plain = 20,
      light_diamond = 10,
      light_hell_red = 20,
      light_hell_lava = 5,
      ceil_redash = 5,
      ceil_hotrock = 5,
      ceil_hotrock2 = 5,
      ceil_blood = 7,
      ceil_sprock = 4,
      ceil_water = 4,
      ceil_icky = 10,
      sky_hell_10 = 3,
      sky_hell_11 = 3,
      sky_hell_12 = 3,
      sky_hell_13 = 3,
    },

    street_sinks =
    {
      floor_default_streets = 1,
    },

    beam_groups =
    {
      beam_gothic = 50,
      beam_quakeish = 50,
      beam_lights_vertical_hell = 50,
      beam_wood = 50,
      beam_textured = 50,
    },

    wall_groups =
    {
      torches2 = 30, --red
      torches3 = 30, --blue
      torches1 = 30, --green
      torches6 = 10, --candelabra
      torches8 = 10, --evil eye
      torches10 = 7, --skull rock
      lowhell1 = 4,
      lowhell2 = 2,
      lowhell3 = 4,
      runes1 = 7,
      runes2 = 7,
      runes3 = 7,
      runes4 = 7,
      runes5 = 7,
      cross1 = 7,
      cross2 = 15,
      cross3 = 7,
      cross4 = 5,
      cross5 = 10,
      mid_band_hell = 2,
      gtd_wall_hell_bloodgutters = 30,
      gtd_wall_tech_top_corner_light_set = 40,
      gtd_wall_hell_vaults = 40,
      gtd_generic_beamed_inset = 40,
      gtd_writhing_mass = 40,
      gtd_library = 40,
      gtd_furnace = 20,
      gtd_furnace_face = 20,
      gtd_wall_marbface = 40,
      gtd_wall_quakish_insets = 40,
      gtd_ribbed_lights = 5,
      gtd_wall_high_gap_set = 20,
      gtd_wall_high_gap_alt_set = 20,
      gtd_generic_half_floor = 20,
      gtd_wall_urban_cement_frame = 10,
      gtd_generic_ceilwall = 25,
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 50,
      gappy = 25,
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

    window_groups =
    {
      round  = 80, --80,
      tall   = 65, --65,
      barred = 20, --20,
      grate  = 40, --40,
      square = 30, --30,
      supertall = 60,
      gtd_window_cage_highbars = 20,
      gtd_window_cage_lowbars = 20,
      gtd_window_cage_hell = 50,
      gtd_window_arched = 50,
      gtd_window_arched_tall = 50,
      gtd_window_full_open = 30,
      gtd_window_full_open_tall = 30,
      gtd_window_absurdly_open = 40,
      gtd_window_quakeish = 20,
      gtd_window_low = 25,
      gtd_window_arrowslit = 40,
      gtd_window_metal_frames = 40,
      gtd_window_construction_frames = 35,
    },

    cave_torches =
    {
      red_torch   = 50,
      green_torch = 50,
      blue_torch  = 50,
      blue_torch_sm = 15,
      green_torch_sm = 15,
      red_torch_sm = 15,

      candelabra = 15,
      skull_rock = 15,
      skull_cairn = 20,
      evil_eye   = 10,
    },

    outdoor_torches =
    {
      blue_torch = 70,
      red_torch  = 70,
      green_torch = 70,
      candelabra = 30,
      skull_rock = 30,
      blue_torch_sm = 15,
      red_torch_sm  = 15,
      green_torch_sm = 15,
    },

    passable_decor =
    {
      gibs = 70,
      gibbed_player = 30,
      dead_player = 40,
      dead_zombie = 2,
      dead_shooter = 2,
      dead_imp = 1,
      dead_demon = 1,
      dead_caco  = 1,
    },

    park_decor =
    {
      burnt_tree = 95,
      brown_stub = 55,
      big_tree = 40,
      evil_eye   = 15,
      skull_rock = 10,
      skull_cairn = 15,
      skull_pole = 10,
      skull_kebab = 10,
      green_pillar = 5,
      green_column  = 5,
      green_column_hrt = 3,
      red_pillar = 5,
      red_column = 5,
      red_column_skl = 3,
    },

    style_list =
    {
      doors = { none=15, few=30, some=65, heaps=25 },
      outdoors = { none=10, few=35, some=60, heaps=15 },
      steepness = { few=35, some=70, heaps=30 },
      pictures = { few=50, some=50, heaps=70 },
      big_rooms = { none=25, few=60, some=15, heaps=10 },
      big_outdoor_rooms = { none=5, few=50, some=80, heaps=25},
      ambushes = { none=10, few=15, some=55, heaps=35 },
      hallways = { none=20, few=60, some=15, heaps=5 },
      teleporters = { none=15, few=25, some=60, heaps=10 },
      keys = { none=15, few=40, some=60, heaps=25 },
      trikeys = { none=10, few=40, some=70, heaps=35 },
      liquids = { none=20, few=45, some=25, heaps=15 },
      traps = { few=20, some=70, heaps=40 },
      switches = { none=25, few=60, some=35, heaps=10 },
      cages    = { none=15, few=25, some=65, heaps=10 },
      symmetry = { none=55, few=25, some=40, heaps=20 },
      secrets = { few=65, some=40, heaps=10 },
      caves = { none=60, few=35, some=8, heaps=3 },
      barrels = { none=45, few=15, some=5, heaps=4 },
      fences = { none=30, few=20, some=90, heaps=40 },
      porches = { none=10, few=40, some=30, heaps=75 },
      beams = { none=15, few=40, some=20, heaps=5 },
    },

    monster_prefs =
    {
      zombie  = 0.5,
      shooter = 0.75,
      imp     = 1.5,
      demon   = 1.3,
      spectre = 1.3,
      skull   = 2.0,
      Cyberdemon = 1.25,
      Mastermind = 1.5,
    },

    scenic_fences =
    {
      MIDBRN1 = 3,
      MIDGRATE = 12,
    },

    sink_style =
    {
      sharp = 0.1,
      curved = 1,
    },

    skyboxes =
    {
      Skybox_garrett_hell = 50,
    },

    ceil_light_prob = 35,
  },


  ---- Episode 4 ----

  -- Thy Flesh Consumed by Chris Pisarczyk / Armaetus
  -- Basically a modified version of "hell" to match id's E4 better

  flesh =
  {
    liquids =
    {
      blood  = 60,
      lava   = 30,
      water  = 20,
      nukage = 10,
    },

    entity_remap =
    {
      k_red    = "ks_red",
      k_blue   = "ks_blue",
      k_yellow = "ks_yellow",
    },

    facades =
    {
      STONE2 = 20,
      STONE3 = 15,
      WOOD1 = 50,
      GSTONE1 = 30,
      MARBLE1 = 20,
      BROWN1 = 10,
      BROWNGRN = 10,
      WOOD5 = 40,
      SP_HOT1 = 5,
      SKINMET1 = 10,
      SKINMET2 = 10,
    },

    fences =
    {
     WOOD5 = 50,
     WOOD3 = 50,
     STONE = 50,
     STONE3 = 50,
     ICKWALL3 = 30,
     BROVINE = 30,
     ASHWALL = 30,
     SKIN2 = 20,
     SKINFACE = 20,
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

      SW1COMP  = "SW1GARG",
      SW1PIPE  = "SW1BROWN",
      SILVER3  = "STONGARG",
    },

    floor_sinks =
    {
      liquid_plain = 10,
      liquid_blood = 10,
      floor_skulls = 15,
      floor_glowingrock = 10,
      floor_snakes = 5,
      liquid_firelava = 5,
      floor_snakes2 = 5,
    },

    ceiling_sinks =
    {
      sky_metal = 20,
      sky_plain = 20,
      light_diamond = 10,
      light_hell_red = 20,
      light_hell_lava = 5,
      ceil_redash = 5,
      sky_urban_1 = 5,
      sky_urban_3 = 4,
      sky_hell_2 = 4,
      sky_hell_9 = 3,
      light_side4 = 3,
      ceil_vdark2 = 6,
      ceil_icky = 5,
      ceil_water = 4,
      ceil_blood = 4,
      ceil_sprock = 3,
      sky_hell_13 = 3,
      sky_hell_14 = 4,
      sky_hell_15 = 4,
    },

    street_sinks =
    {
      floor_default_streets = 1,
    },

    beam_groups =
    {
      beam_gothic = 50,
      beam_quakeish = 50,
      beam_lights_white = 25,
      beam_lights_vertical_tech = 25,
      beam_lights_vertical_hell = 50,
      beam_wood = 80,
      beam_textured = 50,
    },

    wall_groups =
    {
      torches2 = 30, --red
      torches3 = 30, --blue
      torches1 = 30, --green
      torches6 = 10, --candelabra
      torches8 = 10, --evil eye
      torches10 = 7, --skull rock
      lowhell1 = 4,
      lowhell2 = 2,
      lowhell3 = 4,
      runes1 = 5,
      runes2 = 5,
      runes3 = 5,
      runes4 = 5,
      runes5 = 5,
      cross1 = 5,
      cross2 = 12,
      cross3 = 5,
      cross4 = 5,
      cross5 = 10,
      mid_band_hell = 2,
      gtd_wall_hell_bloodgutters = 30,
      gtd_wall_tech_top_corner_light_set = 35,
      gtd_wall_hell_vaults = 40,
      gtd_generic_beamed_inset = 40,
      gtd_writhing_mass = 30,
      gtd_library = 40,
      gtd_furnace = 20,
      gtd_furnace_face = 20,
      gtd_wall_marbface = 30,
      gtd_wall_quakish_insets = 25,
      gtd_ribbed_lights = 8,
      gtd_wall_high_gap_set = 10,
      gtd_wall_high_gap_alt_set = 10,
      gtd_generic_half_floor = 15,
      gtd_woodframe = 15,
      gtd_woodframe_green = 15,
      gtd_generic_ceilwall = 20,
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 50,
      fence_gothic = 50,
    },

    fence_posts =
    {
      Post_metal = 50,
      Post_tech_1 = 20,
      Post_tech_2 = 20,
      Post_gothic_blue = 20,
      Post_gothic_green = 20,
      Post_gothic_red = 20,
      Post_gothic_blue_2 = 20,
      Post_gothic_green_2 = 20,
      Post_gothic_red_2 = 20,
    },

    passable_decor =
    {
      gibs = 70,
      gibbed_player = 30,
      dead_player = 40,
      dead_zombie = 2,
      dead_shooter = 2,
      dead_imp = 1,
      dead_demon = 1,
      dead_caco  = 1,
    },

    park_decor =
    {
      burnt_tree = 95,
      brown_stub = 55,
      big_tree = 45,
      evil_eye   = 7,
      skull_rock = 5,
      skull_cairn = 7,
      skull_pole = 5,
      skull_kebab = 5,
      green_pillar = 3,
      green_column  = 3,
      green_column_hrt = 2,
      red_pillar = 3,
      red_column = 3,
      red_column_skl = 2,
    },

    monster_prefs =
    {
      zombie  = 0.8,
      shooter = 1.25,
      imp     = 2.0,
      demon   = 1.1,
      spectre = 1.1,
      skull   = 0.7,
      Cyberdemon = 1.5,
      Mastermind = 1.5,
    },

    window_groups =
    {
      round  = 20,
      tall   = 90,
      barred = 15,
      grate  = 25,
      square = 50,
      supertall = 75,
      gtd_window_cage_highbars = 30,
      gtd_window_cage_lowbars = 20,
      gtd_window_cage_hell = 40,
      gtd_window_arched = 60,
      gtd_window_arched_tall = 60,
      gtd_window_full_open = 30,
      gtd_window_full_open_tall = 30,
      gtd_window_absurdly_open = 30,
      gtd_window_low = 20,
      gtd_window_arrowslit = 40,
      gtd_window_weabdows = 15,
      gtd_window_metal_frames = 30,
      gtd_window_construction_frames = 30,
    },

    style_list =
    {
      doors = { none=10, few=30, some=65, heaps=20 },
      outdoors = { none=10, few=35, some=60, heaps=15 },
      steepness = { few=25, some=75, heaps=30 },
      pictures = { few=30, some=50, heaps=70 },
      big_rooms = { none=25, few=40, some=15, heaps=10 },
      ambushes = { few=5, some=25, heaps=65 },
      hallways = { none=20, few=60, some=15, heaps=5 },
      teleporters = { none=15, few=25, some=60, heaps=10 },
      keys = { none=15, few=40, some=60, heaps=25 },
      trikeys  = { none=10, few=40, some=85, heaps=20 },
      liquids = { none=20, few=45, some=25, heaps=15 },
      traps = { few=20, some=40, heaps=80 },
      switches = { none=25, few=60, some=35, heaps=10 },
      cages    = { none=15, few=25, some=65, heaps=10 },
      symmetry = { none=55, few=25, some=40, heaps=20 },
      secrets = { few=45, some=40, heaps=10 },
      scenics = { few=15, some=60, heaps=80},
      caves = { none=60, few=35, some=8, heaps=3 },
      barrels = { none=45, few=15, some=5, heaps=4 },
      beams = { none=10, few=40, some=50, heaps=15 },
      porches = { few=10, some=60, heaps=80 },
      fences = { none=5, few=20, some=80, heaps=40 },
    },

    scenic_fences =
    {
      MIDGRATE = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 1,
    },

    skyboxes =
    {
      Skybox_garrett_city = 50,
      Skybox_hellish_city = 50,
    },

    ceil_light_prob = 45,
  },
}



ULTDOOM.ROOM_THEMES =
{
  -- this ensures the following room themes REPLACE those of Doom 2.
  replace_all = true,


-----  GENERIC STUFF  ------------------------------

  any_vent_Hallway =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRAY1 = 50,
    },

    floors =
    {
      FLAT1 = 30,
    },

    ceilings =
    {
      CEIL3_5 = 30,
    },
  },


  any_deuce_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 1,

    walls =
    {
      GRAY1 = 50,
    },

    floors =
    {
      FLAT1 = 30,
    },

    ceilings =
    {
      CEIL3_5 = 30,
    },
  },


------ EPISODE 1 : Tech Bases ----------------------

  tech_Room =
  {
    env  = "building",
    prob = 90,

    walls =
    {
      STARTAN3 = 25,
      STARTAN2 = 12,
      STARTAN1 = 5,
      STARG1 = 5,
      STARG2 = 15,
      STARG3 = 15,
      STARBR2 = 5,
      STARGR2 = 10,
      METAL1 = 2,
    },

    floors =
    {
      FLOOR0_1 = 30,
      FLOOR0_2 = 20,
      FLOOR0_3 = 30,
      FLOOR0_7 = 20,
      FLOOR3_3 = 15,
      FLOOR7_1 = 10,
      FLOOR4_5 = 30,
      FLOOR4_6 = 20,
      FLOOR4_8 = 50,
      FLOOR5_1 = 35,
      FLOOR5_2 = 30,
      FLAT1 = 10,
      FLAT5 = 20,
      FLAT14 = 20,
      FLAT5_4 = 15,
    },

    ceilings =
    {
      CEIL5_1 = 20,
      CEIL3_3 = 15,
      CEIL3_5 = 50,
      FLAT1 = 20,
      FLAT4 = 15,
      FLAT18 = 20,
      FLOOR0_2 = 10,
      FLOOR4_1 = 30,
      FLOOR5_1 = 15,
      FLOOR5_4 = 10,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
    },
  },


  tech_Brown =
  {
    env  = "building",
    prob = 70,

    walls =
    {
      BROWN1 = 30,
      BROWNGRN = 20,
      BROWN96 = 10,
      BROVINE = 5,
      BROVINE2 = 5,
    },

    floors =
    {
      FLOOR0_1 = 30,
      FLOOR0_2 = 20,
      FLOOR3_3 = 20,
      FLOOR7_1 = 15,
      FLOOR4_5 = 30,
      FLOOR4_6 = 30,
      FLOOR5_2 = 30,
      FLAT5 = 20,
    },

    ceilings =
    {
      CEIL5_1 = 20,
      CEIL3_3 = 15,
      CEIL3_5 = 50,
      FLAT1 = 20,
      FLOOR4_1 = 30,
      FLAT5_4 = 10,
      FLOOR5_4 = 10,
    },
  },


  tech_Computer =
  {
    env = "building",
    prob = 25,

    walls =
    {
      COMPSPAN = 30,
      COMPOHSO = 10,
      COMPTILE = 15,
      COMPBLUE = 15,
      TEKWALL4 = 3,
    },

    floors =
    {
      FLAT14 = 50,
      FLOOR1_1 = 15,
      FLAT4 = 10,
      CEIL4_1 = 20,
      CEIL4_2 = 20,
      CEIL5_1 = 20,
    },

    ceilings =
    {
      CEIL5_1 = 50,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
    },
  },

  tech_Shiny =
  {
    env = "building",
    prob = 15,

    walls =
    {
      SHAWN2 = 50,
      METAL1 = 5,
    },

    floors =
    {
      FLOOR4_8 = 10,
      FLAT14 = 10,
      FLOOR1_1 = 5,
      FLAT23 = 60,
    },

    ceilings =
    {
      FLAT23 = 50,
    },
  },


  tech_Gray =
  {
    env = "building",
    prob = 40,

    walls =
    {
      GRAY1 = 50,
      GRAY4 = 30,
      GRAY7 = 30,
      ICKWALL1 = 40,
      ICKWALL3 = 20,
    },

    floors =
    {
      FLAT4 = 50,
      FLOOR0_3 = 30,
      FLAT5_4 = 25,
      FLAT19 = 15,
      FLAT1 = 15,
      FLOOR0_5 = 10,
    },

    ceilings =
    {
      FLAT19 = 40,
      FLAT5_4 = 20,
      FLAT4  = 20,
      FLAT23 = 10,
      FLAT1 = 10,
    },
  },


  tech_metro_Hallway =
  {
    env   = "hallway",
    group = "metro",
    prob  = 25,

    walls =
    {
      BROWN1 = 50,
      SHAWN2 = 50,
      STARTAN3 = 50,
      STARG3 = 50,
      BROWNGRN = 50,
      BROWN96 = 50,
      GSTONE1 = 50,
      SP_HOT = 50,
    },

    floors =
    {
      FLAT1 = 50,
      FLAT4 = 50,
      FLAT19 = 50,
      FLAT20 = 50,
      FLAT3 = 50,
      FLAT5 = 50,
      FLOOR0_1 = 50,
      FLOOR0_2 = 50,
      FLOOR0_3 = 50,
      FLOOR1_1 = 50,
      FLOOR1_6 = 50,
      FLOOR3_3 = 50,
      FLOOR4_1 = 50,
      FLOOR4_5 = 50,
      FLOOR4_6 = 50,
      FLOOR4_8 = 50,
      FLOOR5_3 = 50,
    },

    ceilings =
    {
      CEIL3_2 = 50,
      CEIL3_3 = 50,
      CEIL3_5 = 50,
      FLAT1 = 50,
      FLAT18 = 50,
      FLAT19 = 50,
      FLAT20 = 50,
      FLAT3 = 50,
      FLOOR3_3 = 50,
      FLOOR4_1 = 50,
      FLOOR4_6 = 50,
      FLOOR4_8 = 50,
      FLOOR5_3 = 50,
      FLOOR5_4 = 50,
    },
  },


  tech_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      BROWN1 = 33,
      BROWNGRN = 50,
      STARBR2 = 15,
      STARTAN3 = 30,
      STARG3 = 30,
      TEKWALL4 = 5,
    },

    floors =
    {
      FLOOR0_1 = 30,
      FLOOR0_2 = 20,
      FLOOR0_3 = 30,
      FLOOR0_7 = 20,
      FLOOR3_3 = 15,
      FLOOR7_1 = 15,
      FLOOR4_5 = 30,
      FLOOR4_6 = 20,
      FLOOR4_8 = 30,
      FLOOR5_1 = 35,
      FLOOR5_2 = 30,
      FLAT1 = 10,
      FLAT4 = 20,
      FLAT5 = 20,
      FLAT9 = 5,
      FLAT14 = 20,
      FLAT5_4 = 20,
      CEIL5_1 = 30,
      CEIL4_1 = 10,
      CEIL4_2 = 10,
    },

    ceilings =
    {
      FLAT4 = 20,
      CEIL5_1 = 35,
      CEIL3_5 = 50,
      CEIL3_3 = 20,
      FLAT19 = 20,
      FLAT23 = 20,
      FLAT5_4 = 15,
      CEIL4_1 = 20,
      CEIL4_2 = 20,
    },
  },


  tech_Cave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      ASHWALL = 30,
      SP_ROCK1 = 60,
      BROWNHUG = 20,
    },

    floors =
    {
      ASHWALL = 30,
      SP_ROCK1 = 60,
      FLOOR7_1 = 20,
    },
  },


  tech_Outdoors =
  {
    env = "outdoor",
    prob = 50,

    floors =
    {
      BROWN144 = 30,
      BROWN1 = 20,
      STONE = 20,
      ASHWALL = 5,
      FLAT10 = 5,
    },

    naturals =
    {
      ASHWALL = 35,
      SP_ROCK1 = 70,
      GRAYVINE = 20,
      STONE = 30,
    },

    porch_floors =
    {
      FLAT1 = 10,
      CEIL5_2 = 10,
      FLAT19 = 5,
      FLAT3 = 10,
      FLOOR0_5 = 10,
      FLOOR5_3 = 10,
      FLOOR5_4 = 10,
      FLOOR7_1 = 10,
    },
  },


------ EPISODE 2 ------------------------------

  deimos_Room =
  {
    env = "building",
    prob = 70,

    walls =
    {
      STARTAN3 = 10,
      STARTAN2 = 5,
      STARTAN1 = 5,
      STARG2 = 15,
      ICKWALL1 = 15,
      STARBR2 = 15,
      STARGR2 = 10,
      STARG1 = 5,
      STARG2 = 5,
      STARG3 = 7,
      ICKWALL3 = 30,
      GRAY7 = 20,
      GRAY5 = 15,
      GRAY1 = 15,
      BROWN1 = 5,
      BROWNGRN = 10,
      BROWN96 = 5,
      STONE2 = 30,
      STONE3 = 20,
    },

    floors =
    {
      FLOOR0_1 = 30,
      FLOOR0_2 = 40,
      FLOOR0_3 = 30,
      CEIL4_1 = 5,
      FLOOR0_7 = 10,
      FLOOR3_3 = 20,
      FLOOR7_1 = 20,
      CEIL4_2 = 10,
      FLOOR4_1 = 30,
      FLOOR4_6 = 20,
      FLOOR4_8 = 50,
      FLOOR5_2 = 35,
      FLAT1 = 40,
      FLAT5 = 30,
      FLAT14 = 10,
      FLAT1_1 = 30,
      FLOOR1_6 = 3,
      FLAT1_2 = 30,
      FLOOR5_1 = 50,
      FLAT3 = 15,
      FLAT5_4 = 15,
    },

    ceilings =
    {
      CEIL5_1 = 30,
      CEIL3_3 = 70,
      CEIL3_5 = 50,
      CEIL4_1 = 10,
      CEIL4_2 = 10,
      FLAT1 = 30,
      FLAT4 = 20,
      FLAT19 = 30,
      FLAT8 = 15,
      FLAT5_4 = 20,
      FLOOR0_2 = 20,
      FLOOR4_1 = 50,
      FLOOR5_1 = 50,
      FLOOR5_4 = 10,
    },
  },


  deimos_Hellish =
  {
    env = "building",
    prob = 50,

    walls =
    {
      MARBLE1 = 15,
      MARBLE2 = 15,
      MARBLE3 = 15,
      BROWNGRN = 15,
      COMPTILE = 15,
      BROWN1 = 15,
      STARTAN3 = 15,
      STARG3 = 15,
      WOOD1 = 15,
      WOOD3 = 15,
      WOOD5 = 15,
      BROVINE = 15,
      BROVINE2 = 15,
      ICKWALL3 = 15,
      GRAY7 = 15,
    },

    floors =
    {
      DEM1_5 = 30,
      DEM1_6 = 50,
      FLAT10 = 5,
      FLOOR7_1 = 5,
      FLOOR7_2 = 50,
      FLOOR4_1 = 30,
      FLOOR4_6 = 20,
      FLOOR4_8 = 50,
      FLOOR5_2 = 35,
      FLAT1 = 40,
      FLAT5 = 30,
      FLAT14 = 10,
    },

    ceilings =
    {
      FLOOR7_2 = 50,
      DEM1_5 = 50,
      DEM1_6 = 30,
      FLOOR6_2 = 5,
      CEIL5_1 = 30,
      CEIL3_3 = 50,
      CEIL3_5 = 30,
      CEIL4_1 = 10,
      CEIL4_2 = 10,
    },
  },


  deimos_Lab =
  {
    env = "building",
    prob = 15,

    walls =
    {
      COMPTILE = 40,
      COMPBLUE = 10,
      COMPSPAN = 15,
      METAL1 = 20,
    },

    floors =
    {
      FLOOR4_8 = 15,
      FLOOR5_1 = 15,
      FLAT14 = 40,
      FLOOR1_1 = 30,
      CEIL4_2 = 20,
      CEIL4_1 = 20,
    },

    ceilings =
    {
      CEIL5_1 = 30,
      CEIL4_1 = 10,
      CEIL4_2 = 15,
      FLOOR4_8 = 15,
      FLAT14 = 10,
    },
  },


  deimos_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      BROWN1 = 33,
      BROWNGRN = 50,
      BROVINE = 20,
      BROVINE2 = 15,
      GRAY1 = 50,
      GRAY5 = 33,
      ICKWALL1 = 30,
      ICKWALL3 = 30,
      STONE2 = 40,
      STONE3 = 50,
      METAL1 = 30,
    },

    floors =
    {
      FLAT4 = 30,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      FLAT14 = 20,
      FLAT5_4 = 20,
      FLOOR3_3 = 30,
      FLOOR4_8 = 40,
      FLOOR5_1 = 25,
      FLOOR5_2 = 10,
      FLAT5 = 20,
      FLOOR1_6 = 4,
      FLOOR7_2 = 3,
      FLAT5_1 = 3,
      FLAT5_2 = 3,
      DEM1_5 = 3,
      DEM1_6 = 3,
    },

    ceilings =
    {
      FLAT4 = 20,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      CEIL3_5 = 25,
      CEIL3_3 = 50,
      FLAT18 = 15,
      FLAT19 = 20,
      FLAT5_4 = 10,
      FLOOR4_8 = 25,
      FLOOR5_1 = 20,
      FLOOR7_1 = 15,
      FLOOR7_2 = 2,
      FLAT5_1 = 2,
      FLAT5_2 = 2,
      DEM1_5 = 2,
      DEM1_6 = 2,
    },
  },


  deimos_Hallway_hell =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      MARBLE1 = 20,
      MARBLE2 = 20,
      MARBLE3 = 20,
      GSTONE1 = 20,
      BROVINE = 20,
      COMPTILE = 20,
    },

    floors =
    {
      FLAT4 = 30,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      FLAT14 = 20,
      FLAT5_4 = 20,
      FLOOR3_3 = 30,
      FLOOR4_8 = 40,
      FLOOR5_1 = 25,
      FLOOR5_2 = 10,
      FLAT5 = 20,
      FLOOR1_6 = 4,
      FLOOR7_2 = 15,
      FLAT5_1 = 15,
      FLAT5_2 = 15,
      DEM1_5 = 15,
      DEM1_6 = 15,
    },

    ceilings =
    {
      FLAT4 = 20,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      CEIL3_5 = 25,
      CEIL3_3 = 20,
      FLAT18 = 15,
      FLAT19 = 20,
      FLAT5_4 = 10,
      FLOOR4_8 = 15,
      FLOOR5_1 = 20,
      FLOOR7_1 = 15,
      FLOOR7_2 = 15,
      FLAT5_1 = 15,
      FLAT5_2 = 15,
      DEM1_5 = 15,
      DEM1_6 = 15,
    },
  },


  deimos_Cave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      SP_ROCK1 = 90,
      ASHWALL = 20,
      BROWNHUG = 15,
      GRAYVINE = 10,
    },

    floors =
    {
      SP_ROCK1 = 90,
      ASHWALL = 20,
      BROWNHUG = 15,
      GRAYVINE = 10,
    },
  },


  deimos_Outdoors =
  {
    env = "outdoor",
    prob = 50,

--Makes sense for high prob for SP_ROCK1 because the intermission screen shows
--Deimos has a desolate, gray ground.
    floors =
    {
      BROWN144 = 30,
      BROWN1 = 10,
      STONE = 10,
    },

    naturals =
    {
      SP_ROCK1 = 60,
      ASHWALL = 2,
      FLAT10 = 3,
    },

    porch_floors =
    {
      CEIL5_2 = 10,
      FLAT1 = 10,
      FLAT5_3 = 10,
      FLAT5_4 = 10,
      FLAT5_5 = 10,
      FLAT8 = 10,
      FLOOR0_5 = 10,
      FLOOR4_6 = 10,
      DEM1_5 = 20,
      FLOOR7_2 = 20,
      DEM1_6 = 20,
      FLAT1_1 = 5,
      FLAT1_2 = 5,
      MFLR8_1 = 10,
    },
  },

  deimos_metro_Hallway =
  {
    env   = "hallway",
    group = "metro",
    prob  = 25,

    walls =
    {
      BROWN1 = 50,
      SHAWN2 = 50,
      STARTAN3 = 50,
      STARG3 = 50,
      BROWNGRN = 50,
      BROWN96 = 50,
      ICKWALL3 = 50,
      ICKWALL1 = 50,
      BROVINE = 50,
      BROVINE2 = 50,
    },

    floors =
    {
      FLAT1 = 50,
      FLAT4 = 50,
      FLAT19 = 50,
      FLAT20 = 50,
      FLAT3 = 50,
      FLAT5 = 50,
      FLOOR0_1 = 50,
      FLOOR0_2 = 50,
      FLOOR0_3 = 50,
      FLOOR1_1 = 50,
      FLOOR1_6 = 50,
      FLOOR3_3 = 50,
      FLOOR4_1 = 50,
      FLOOR4_5 = 50,
      FLOOR4_6 = 50,
      FLOOR4_8 = 50,
      FLOOR5_3 = 50,
    },

    ceilings =
    {
      CEIL3_2 = 50,
      CEIL3_3 = 50,
      CEIL3_5 = 50,
      FLAT1 = 50,
      FLAT18 = 50,
      FLAT19 = 50,
      FLAT20 = 50,
      FLAT3 = 50,
      FLOOR3_3 = 50,
      FLOOR4_1 = 50,
      FLOOR4_6 = 50,
      FLOOR4_8 = 50,
      FLOOR5_3 = 50,
      FLOOR5_4 = 50,
    },
  },


----- EPISODE 3 : Hell ---------------------------

  hell_Marble =
  {
    env = "building",
    prob = 90,

    walls =
    {
      MARBLE1 = 30,
      MARBLE2 = 15,
      MARBLE3 = 20,
      GSTVINE1 = 20,
      GSTVINE2 = 20,
      SKINMET1 = 3,
      SKINMET2 = 3,
      SKINTEK1 = 5,
      SKINTEK2 = 5,
    },

    floors =
    {
      DEM1_5 = 30,
      DEM1_6 = 30,
      FLAT5_7 = 10,
      FLAT5_8 = 5,
      FLAT10 = 10,
      FLOOR7_1 = 10,
      FLOOR7_2 = 30,
      FLAT1 = 10,
      FLAT5 = 5,
      FLAT8 = 5,
      FLOOR5_2 = 10,
    },

    ceilings =
    {
      FLAT1 = 10,
      FLAT10 = 10,
      FLAT5_5 = 5,
      FLOOR7_2 = 30,
      DEM1_5 = 30,
      DEM1_6 = 30,
      FLOOR6_2 = 5,
      FLAT5_1 = 5,
      FLAT5_2 = 5,
      CEIL1_1 = 5,
    },
  },


  hell_Wood =
  {
    env = "building",
    prob = 45,

    walls =
    {
      WOOD1 = 50,
      WOOD3 = 30,
      WOOD5 = 20,
    },

    floors =
    {
      FLAT5_1 = 30,
      FLAT5_2 = 50,
      FLAT5_5 = 15,
    },

    ceilings =
    {
      CEIL1_1 = 50,
      FLAT5_2 = 30,
      FLAT5_1 = 15,
    },
  },


  hell_Skin =
  {
    env = "building",
    prob = 25,

    walls =
    {
      SKIN2 = 15,
      SKINFACE = 20,
      SKSNAKE2 = 20,
      SKINTEK1 = 10,
      SKINTEK2 = 10,
      SKINMET1 = 50,
      SKINMET2 = 40,
      SKINCUT = 10,
      SKINSYMB = 5,
    },

    floors =
    {
      SFLR6_1 = 10,
      FLOOR7_1 = 20,
      FLAT5_5 = 10,
      FLOOR6_1 = 40,
      MFLR8_2 = 10,
      MFLR8_4 = 10,
    },

    ceilings =
    {
      SFLR6_1 = 30,
      SFLR6_4 = 10,
      FLOOR6_1 = 20,
      FLAT5_2 = 5,
    },
  },


  hell_Hot =
  {
    env = "building",
    prob = 60,

    walls =
    {
      SP_HOT1 = 70,
      GSTVINE1 = 15,
      GSTVINE2 = 15,
      STONE = 10,
      STONE3 = 5,
      SKINMET2 = 5,
      BROWN1 = 2,
      SKINCUT = 2,
      SKINTEK1 = 5,
      SKINTEK2 = 5,
    },

    floors =
    {
      FLAT5_7 = 10,
      FLAT5_8 = 10,
      FLAT10 = 10,
      FLAT5_3 = 30,
      FLOOR7_1 = 15,
      FLAT1 = 10,
      FLOOR5_2 = 10,
      FLOOR6_1 = 35,
      FLAT8 = 15,
      FLAT5 = 15,
      FLAT5_1 = 5,
      FLAT5_2 = 5,
    },

    ceilings =
    {
      FLAT1 = 15,
      FLOOR6_1 = 30,
      FLOOR6_2 = 15,
      FLAT10 = 10,
      FLAT8 = 5,
      FLAT5_3 = 20,
      FLAT5_1 = 5,
      FLAT5_2 = 5,
      CEIL1_1 = 5,
    },
  },


  hell_Hallway =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      FIREBLU1 = 50,
      FIREWALL = 50,
      SKSPINE2 = 50,
      SKIN2    = 50,
      SKINSYMB = 50,
      MARBGRAY = 50,
    },

    floors =
    {
      BLOOD1 = 50,
      FLAT4 = 30,
      CEIL4_1 = 15,
      CEIL5_1 = 30,
      FLAT14 = 20,
      FLAT5_4 = 20,
      FLOOR5_2 = 10,
      FLAT5 = 20,
      FLOOR7_2 = 3,
      FLAT5_2 = 3,
      DEM1_5 = 3,
      DEM1_6 = 3,
    },

    ceilings =
    {
      BLOOD1 = 50,
      LAVA1 = 20,
      FLAT4 = 20,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      CEIL3_3 = 50,
      FLAT19 = 20,
      FLAT5_4 = 10,
      FLOOR7_1 = 2,
      FLAT5_1 = 2,
      DEM1_6 = 2,
    },

    y_offsets =
    {
      SKSPINE2 = 13,
      SKINSYMB = 30,
      MARBGRAY = 24,
    },
  },


  hell_Outdoors =
  {
    env = "outdoor",
    prob = 50,

    floors =
    {
      ASHWALL = 30,
      FLAT5_4 = 5,
      FLAT10 = 20,
      FLOOR6_1 = 40,
      SFLR6_1 = 10,
      SFLR6_4 = 10,
      MFLR8_2 = 15,
      MFLR8_4 = 10,
      FLAT5_2 = 5,
      FLAT5 = 5,
    },

    naturals =
    {
      ASHWALL = 50,
      GRAYVINE = 20,
      SP_ROCK1 = 50,
      ROCKRED1 = 90,
      SKSNAKE1 = 10,
      SKSNAKE2 = 10,
    },

    porch_floors =
    {
      CEIL5_2 = 10,
      DEM1_5 = 30,
      DEM1_6 = 30,
      FLAT1_1 = 10,
      FLAT1_2 = 10,
      FLAT5_1 = 20,
      FLAT5_2 = 20,
      FLAT5_3 = 10,
      FLAT5_5 = 10,
      FLOOR0_2 = 10,
      FLOOR4_6 = 10,
      FLOOR7_1 = 10,
      FLOOR7_2 = 30,
    },
  },


  hell_Outdoors_hot =
  {
    env = "outdoor",
    prob = 50,

    floors =
    {
      FLAT5_6 = 5,
      ASHWALL = 10,
      FLAT10 = 20,
      DEM1_5 = 15,
      DEM1_6 = 15,
      FLOOR7_2 = 20,
      FLOOR7_1 = 15,
      SFLR6_1 = 10,
      SFLR6_4 = 15,
      MFLR8_2 = 10,
      FLAT5_2 = 5,
    },

    naturals =
    {
      ASHWALL = 30,
      GRAYVINE = 15,
      SP_ROCK1 = 50,
      ROCKRED1 = 90,
      SKSNAKE1 = 10,
      SKSNAKE2 = 10,
      FIREBLU1 = 70,
    },

    porch_floors =
    {
      CEIL3_5 = 10,
      CEIL5_2 = 10,
      FLAT1_1 = 10,
      FLAT1_2 = 10,
      FLAT5_3 = 5,
      FLAT5_3 = 10,
    },
  },


  hell_Cave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      ROCKRED1 = 90,
      SKIN2 = 30,
      SKINFACE = 25,
      SKSNAKE1 = 35,
      SKSNAKE2 = 35,
      FIREBLU1 = 50,
      FIRELAVA = 50,
      ASHWALL  = 20,
    },

    floors =
    {
      ROCKRED1 = 90,
      SKIN2 = 30,
      SKINFACE = 25,
      SKSNAKE1 = 35,
      SKSNAKE2 = 35,
      FIREBLU1 = 50,
      FIRELAVA = 50,
      ASHWALL  = 20,
    },
  },

  hell_metro_Hallway =
  {
    env   = "hallway",
    group = "metro",
    prob  = 12,

    walls =
    {
      BROWN1 = 50,
      WOOD1 = 50,
      MARBLE1 = 50,
      FIREBLU1 = 50,
      ASHWALL = 50,
      METAL = 50,
      BROWNHUG = 50,
    },

    floors =
    {
      FLOOR7_1 = 50,
      FLOOR7_2 = 50,
      FLOOR5_4 = 50,
      MFLR8_1 = 50,
      MFLR8_2 = 50,
      MFLR8_3 = 50,
      MFLR8_4 = 50,
      FLAT5_1 = 50,
      FLAT5_2 = 50,
      FLAT1_1 = 50,
      FLAT1_2 = 50,
      DEM1_5 = 50,
      DEM1_6 = 50,
    },

    ceilings =
    {
      CEIL3_5 = 50,
      LAVA1 = 50,
      FLOOR6_1 = 50,
      FLOOR6_2 = 50,
      FLOOR7_1 = 50,
      FLOOR7_2 = 50,
      FLAT5_3 = 50,
      FLAT5_4 = 50,
      FLAT5_5 = 50,
      FLAT5_6 = 50,
      FLAT5_7 = 50,
      FLAT5_8 = 50,
      FLAT1_1 = 50,
      FLAT1_2 = 50,
      DEM1_5 = 50,
      DEM1_6 = 50,
      CEIL3_2 = 50,
      CEIL3_5 = 50,
    },
  },



----- EPISODE 4 -------------------------------

  flesh_Room =
  {
    env = "building",
    prob = 110,

    walls =
    {
      BROWNGRN = 20,
      BROVINE2 = 15,
      WOOD5 = 10,
      GSTONE1 = 20,
      STONE = 10,
      STONE2 = 5,
      STONE3 = 10,
    },

    floors =
    {
      DEM1_5 = 10,
      DEM1_6 = 10,
      FLAT5_5 = 10,
      FLAT5_7 = 7,
      FLAT5_8 = 7,
      FLAT10 = 12,
      FLOOR7_1 = 10,
      FLOOR7_2 = 10,
      FLOOR5_2 = 10,
      FLOOR5_3 = 10,
      FLOOR5_4 = 10,
      FLAT5 = 10,
      FLAT8 = 10,
      SFLR6_1 = 5,
      SFLR6_4 = 5,
      MFLR8_1 = 5,
      MFLR8_2 = 10,
    },

    ceilings =
    {
      FLAT1 = 10,
      FLAT10 = 10,
      FLAT5_5 = 10,
      FLOOR7_2 = 15,
      DEM1_6 = 10,
      FLOOR6_1 = 10,
      FLOOR6_2 = 10,
      MFLR8_1 = 12,
      FLAT5_4 = 10,
      SFLR6_1 = 5,
      SFLR6_4 = 5,
      CEIL1_1 = 10,
      FLAT5_1 = 5,
      FLAT5_2 = 5,
      FLAT8 = 8,
    },
  },


  flesh_Wood =
  {
    env = "building",
    prob = 80,

    walls =
    {
      WOOD1 = 70,
      WOOD3 = 50,
      WOOD5 = 40,
      SKINMET1 = 15,
      SKINMET2 = 15,
      SKINTEK1 = 6,
      SKINTEK2 = 6,
    },

    floors =
    {
      FLAT5_1 = 30,
      FLAT5_2 = 50,
      FLAT5_5 = 15,
      FLAT5 = 7,
      FLAT8 = 7,
    },

    ceilings =
    {
      CEIL1_1 = 50,
      FLAT5_2 = 30,
      FLAT5_1 = 15,
      FLOOR7_1 = 10,
    },
  },


  flesh_Marble =
  {
    env = "building",
    prob = 40,

    walls =
    {
      MARBLE1 = 50,
      MARBLE2 = 25,
      MARBLE3 = 20,
    },

    floors =
    {
      DEM1_5 = 30,
      DEM1_6 = 50,
      FLAT10 = 5,
      FLOOR7_1 = 5,
      FLOOR7_2 = 50,
    },

    ceilings =
    {
      FLOOR7_2 = 50,
      DEM1_5 = 50,
      DEM1_6 = 50,
      FLOOR6_2 = 5,
    },
  },


  -- andrewj: this is a straight copy of deimos_Hallway_hell

  flesh_Hallway_hell =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      MARBLE1 = 20,
      MARBLE2 = 20,
      MARBLE3 = 20,
      GSTONE1 = 20,
      BROVINE = 20,
      COMPTILE = 20,
    },

    floors =
    {
      FLAT4 = 30,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      FLAT14 = 20,
      FLAT5_4 = 20,
      FLOOR3_3 = 30,
      FLOOR4_8 = 40,
      FLOOR5_1 = 25,
      FLOOR5_2 = 10,
      FLAT5 = 20,
      FLOOR1_6 = 4,
      FLOOR7_2 = 15,
      FLAT5_1 = 15,
      FLAT5_2 = 15,
      DEM1_5 = 15,
      DEM1_6 = 15,
    },

    ceilings =
    {
      FLAT4 = 20,
      CEIL4_1 = 15,
      CEIL4_2 = 15,
      CEIL5_1 = 30,
      CEIL3_5 = 25,
      CEIL3_3 = 20,
      FLAT18 = 15,
      FLAT19 = 20,
      FLAT5_4 = 10,
      FLOOR4_8 = 15,
      FLOOR5_1 = 20,
      FLOOR7_1 = 15,
      FLOOR7_2 = 15,
      FLAT5_1 = 15,
      FLAT5_2 = 15,
      DEM1_5 = 15,
      DEM1_6 = 15,
    },
  },


  flesh_Cave =
  {
    env = "cave",
    prob = 50,

    walls =
    {
      ROCKRED1 = 70,
      SP_ROCK1 = 50,
      BROWNHUG = 15,
      SKIN2 = 10,
      SKINFACE = 20,
      SKSNAKE1 = 5,
      SKSNAKE2 = 5,
      FIREBLU1 = 10,
      FIRELAVA = 10,
    },

    floors =
    {
      ROCKRED1 = 70,
      SP_ROCK1 = 50,
      BROWNHUG = 15,
      SKIN2 = 10,
      SKINFACE = 20,
      SKSNAKE1 = 5,
      SKSNAKE2 = 5,
      FIREBLU1 = 10,
      FIRELAVA = 10,
    },
  },


  flesh_Outdoors =
  {
    env = "outdoor",
    prob = 50,

    floors =
    {
      ASHWALL = 12,
      FLAT1_1 = 15,
      FLAT5_4 = 10,
      FLAT10 = 20,
      FLAT5_7 = 10,
      FLAT5_8 = 10,
      MFLR8_4 = 10,
      FLOOR7_1 = 15,
      SFLR6_1 = 8,
      SFLR6_4 = 8,
      FLAT5 = 7,
      MFLR8_2 = 5,
      FLAT1_1 = 10,
      FLAT1_2 = 10,
      MFLR8_3 = 10,
      FLAT5_2 = 20,
    },

    naturals =
    {
      ASHWALL = 30,
      GRAYVINE = 20,
      SP_ROCK1 = 70,
      ROCKRED1 = 70,
      BROWNHUG = 20,
      SKSNAKE1 = 10,
      SKSNAKE2 = 10,
    },

    porch_floors =
    {
      CEIL1_1 = 50,
      FLAT5_1 = 50,
      FLAT5_2 = 50,

      FLOOR7_1 = 30,
      FLAT8 = 20,
      FLOOR0_2 = 20,

      DEM1_5 = 10,
      DEM1_6 = 10,
      FLOOR7_2 = 10,
    },
  },

  flesh_metro_Hallway =
  {
    env   = "hallway",
    group = "metro",
    prob  = 20,

    walls =
    {
      BROWN1 = 50,
      WOOD1 = 50,
      WOOD3 = 50,
      WOOD5 = 50,
      WOODMET1 = 50,
      BIGDOOR5 = 50,
    },

    floors =
    {
      FLAT5_1 = 50,
      FLAT5_2 = 50,
      FLOOR7_1 = 50,
    },

    ceilings =
    {
      FLAT5_1 = 50,
      FLAT5_2 = 50,
      CEIL1_1 = 50,
      FLOOR7_1 = 50,
    },
  },


}


--------------------------------------------------------------------

ULTDOOM.EPISODES =
{
  episode1 =
  {
    ep_index = 1,

    theme = "tech",
    sky_patch = "SKY1",
    dark_prob = 10,

    name_patch = "M_EPI1",
    description = "Knee-Deep in the Dead",
    bex_end_name = "E1TEXT",
  },

  episode2 =
  {
    ep_index = 2,

    theme = "deimos",
    sky_patch = "SKY2",
    dark_prob = 40,

    name_patch = "M_EPI2",
    description = "The Shores of Hell",
    bex_end_name = "E2TEXT",
  },

  episode3 =
  {
    ep_index = 3,

    theme = "hell",
    sky_patch = "SKY3",
    dark_prob = 10,

    name_patch = "M_EPI3",
    description = "Inferno",
    bex_end_name = "E3TEXT",
  },

  episode4 =
  {
    ep_index = 4,

    theme = "flesh",
    sky_patch = "SKY4",
    dark_prob = 10,

    name_patch = "M_EPI4",
    description  = "Thy Flesh Consumed",
    bex_end_name = "E4TEXT",
  },
}


ULTDOOM.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=50,  file="games/doom/data/boss1/anomaly1.wad", map="E1M8" },
    { prob=50,  file="games/doom/data/boss1/anomaly2.wad", map="E1M8" },
    { prob=100, file="games/doom/data/boss1/anomaly3.wad", map="E1M8" },
    { prob=50,  file="games/doom/data/boss1/ult_anomaly.wad",  map="E1M8" },
    { prob=100, file="games/doom/data/boss1/ult_anomaly2.wad", map="E1M8" },
  },

  E2M8 =
  {
    { prob=40,  file="games/doom/data/boss1/tower1.wad", map="E2M8" },
    { prob=60,  file="games/doom/data/boss1/tower2.wad", map="E2M8" },
    { prob=100, file="games/doom/data/boss1/ult_tower.wad", map="E2M8" },
  },

  E3M8 =
  {
    { prob=50,  file="games/doom/data/boss1/dis1.wad", map="E3M8" },
    { prob=100, file="games/doom/data/boss1/ult_dis.wad", map="E3M8" },
  },

  E4M6 =
  {
    { prob=50, file="games/doom/data/boss1/tower1.wad", map="E2M8" },
  },

  E4M8 =
  {
    { prob=50, file="games/doom/data/boss1/dis1.wad", map="E3M8" },
  },
}


function ULTDOOM.get_levels()
  local EP_MAX  = sel(OB_CONFIG.game   == "ultdoom", 4, 3)
  local EP_NUM  = sel(OB_CONFIG.length == "game", EP_MAX, 1)

  local MAP_LEN_TAB = { single=1, few=4 }

  local MAP_NUM = MAP_LEN_TAB[OB_CONFIG.length] or 9

  -- this accounts for last two levels are BOSS and SECRET level
  local LEV_MAX = MAP_NUM
  if LEV_MAX == 9 then LEV_MAX = 7 end

  -- create episode info...

  for ep_index = 1,4 do
    local ep_info = GAME.EPISODES["episode" .. ep_index]
    assert(ep_info)

    local EPI = table.copy(ep_info)

    EPI.levels = { }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  for ep_index = 1,EP_NUM do
    local EPI = GAME.episodes[ep_index]

    for map = 1,MAP_NUM do
      local ep_along = map / LEV_MAX

      if MAP_NUM == 1 then
        ep_along = rand.range(0.3, 0.7);
      elseif map == 9 then
        ep_along = 0.5
      end

      local LEV =
      {
        episode = EPI,

        name  = string.format("E%dM%d",   ep_index,   map),
        patch = string.format("WILV%d%d", ep_index-1, map-1),

        ep_along = ep_along,
        game_along = (ep_index - 1 + ep_along) / EP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

      if map == 9 then
        LEV.is_secret = true
      end

      -- prebuilt levels
      if OB_CONFIG.prebuilt_levels == "yes" then
        LEV.prebuilt = GAME.PREBUILT_LEVELS[LEV.name]
      end

      if LEV.prebuilt then
        LEV.name_class = LEV.prebuilt.name_class or "BOSS"
      end

      -- procedural gotcha management code

      -- Prebuilts are to exist over procedural gotchas
      -- this means procedural gotchas will not override
      -- Icon of Sin for example if prebuilts are still on
      if not LEV.prebuilt then

        --handling for the Final Only option
        if OB_CONFIG.procedural_gotchas == "final" then
          if OB_CONFIG.length == "single" then
            if map == 1 then LEV.is_procedural_gotcha = true end
          elseif OB_CONFIG.length == "few" then
            if map == 4 then LEV.is_procedural_gotcha = true end
          elseif OB_CONFIG.length == "episode" then
            if map == 11 then LEV.is_procedural_gotcha = true end
          elseif OB_CONFIG.length == "game" then
            if map == 30 then LEV.is_procedural_gotcha = true end
          end
        end

        --every 10 maps
        if OB_CONFIG.procedural_gotchas == "epi" then
          if map == 11 or map == 21 or map == 30 then
            LEV.is_procedural_gotcha = true
          end
        end

        --5% of maps after map 4,
        if OB_CONFIG.procedural_gotchas == "5p" then
          if map > 4 then
            if rand.odds(5) then LEV.is_procedural_gotcha = true end
          end
        end

        -- 10% of maps after map 4,
        if OB_CONFIG.procedural_gotchas == "10p" then
          if map > 4 then
            if rand.odds(10) then LEV.is_procedural_gotcha = true end
          end
        end

        -- for masochists... or debug testing
        if OB_CONFIG.procedural_gotchas == "all" then
          LEV.is_procedural_gotcha = true
        end
      end

      -- handling for street mode
      if not LEV.is_procedural_gotcha or not LEV.prebuilt then
        if OB_CONFIG.streets_mode == "75" and rand.odds(75) then
          LEV.has_streets = true
        elseif OB_CONFIG.streets_mode == "50" and rand.odds(50) then
          LEV.has_streets = true
        elseif OB_CONFIG.streets_mode == "25" and rand.odds(25) then
          LEV.has_streets = true
        elseif OB_CONFIG.streets_mode == "13" and rand.odds(13) then
          LEV.has_streets = true
        elseif OB_CONFIG.streets_mode == "all" then
          LEV.has_streets = true
        end
      end

      -- handling for linear mode chance choices
      if not LEV.prebuilt then
        if OB_CONFIG.linear_mode == "all" then
          LEV.is_linear = true
        elseif OB_CONFIG.linear_mode ~= "none" then
          if rand.odds(int(OB_CONFIG.linear_mode)) then
            LEV.is_linear = true
          end
        end

        -- nature mode
        if OB_CONFIG.nature_mode and not LEV.has_streets then
          if OB_CONFIG.nature_mode == "all" then
            LEV.is_nature = true
          elseif OB_CONFIG.nature_mode ~= "none" then
            if rand.odds(int(OB_CONFIG.nature_mode)) then
              LEV.is_nature = true
            end
          end
        end

      end

      if MAP_NUM == 1 or map == 3 then
        LEV.demo_lump = string.format("DEMO%d", ep_index)
      end
    end -- for map

    -- set "dist_to_end" value
    if MAP_NUM >= 9 then
      EPI.levels[7].dist_to_end = 1
      EPI.levels[6].dist_to_end = 2
      EPI.levels[5].dist_to_end = 3

    elseif MAP_NUM == 4 then
      EPI.levels[4].dist_to_end = 1
      EPI.levels[3].dist_to_end = 3
    end

  end -- for episode
end


function ULTDOOM.setup()
  -- nothing needed
end


--------------------------------------------------------------------

OB_GAMES["doom1"] =
{
  label = _("Doom 1"),

  priority = 98,  -- keep at second spot

  format = "doom",
  game_dir = "doom",
  iwad_name = "doom.wad",

  tables =
  {
    DOOM, ULTDOOM
  },

  hooks =
  {
    setup      = ULTDOOM.setup,
    get_levels = ULTDOOM.get_levels,

    end_level  = DOOM.end_level,
    all_done   = DOOM.all_done
  },
}


OB_GAMES["ultdoom"] =
{
  label = _("Ultimate Doom"),

  extends = "doom1",

  priority = 97  -- keep at third spot

  -- no additional tables

  -- no additional hooks
}


--------------------------------------------------------------------

OB_THEMES["deimos"] =
{
  label = _("Deimos"),
  game = "doom1",
  priority = 40,
  name_class = "TECH",
  mixed_prob = 30,
}


OB_THEMES["flesh"] =
{
  label = _("Thy Flesh"),
  game = "ultdoom",
  priority = 10,
  name_class = "GOTHIC",
  mixed_prob = 20,
}
