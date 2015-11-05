--------------------------------------------------------------------
--  DOOM 1 / ULTIMATE DOOM
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011,2014 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
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
  skip_monsters = { 15,25,35 }

  doom2_monsters = false
  doom2_weapons  = false
  doom2_skies    = false
}


ULTDOOM.MATERIALS =
{
  -- These materials are unique to DOOM I / Ultimate DOOM...


  -- walls --

  ASHWALL  = { t="ASHWALL",  f="FLOOR6_2" }
  BROVINE  = { t="BROVINE",  f="FLOOR0_1" }
  BRNPOIS2 = { t="BRNPOIS2", f="FLOOR7_1" }
  BROWNWEL = { t="BROWNWEL", f="FLOOR7_1" }

  COMP2    = { t="COMP2",    f="CEIL5_1" }
  COMPOHSO = { t="COMPOHSO", f="FLOOR7_1" }
  COMPTILE = { t="COMPTILE", f="CEIL5_1" }
  COMPUTE1 = { t="COMPUTE1", f="FLAT19" }
  COMPUTE2 = { t="COMPUTE2", f="CEIL5_1" }
  COMPUTE3 = { t="COMPUTE3", f="CEIL5_1" }

  DOORHI   = { t="DOORHI",   f="FLAT19" }
  GRAYDANG = { t="GRAYDANG", f="FLAT19" }
  GSTVINE1 = { t="GSTVINE1", f="FLOOR7_2" }
  ICKDOOR1 = { t="ICKDOOR1", f="FLAT19" }
  ICKWALL6 = { t="ICKWALL6", f="FLAT18" }

  LITE2    = { t="LITE2",    f="FLOOR0_1" }
  LITE4    = { t="LITE4",    f="FLAT19" }
  LITE96   = { t="LITE96",   f="FLOOR7_1" }
  LITEBLU2 = { t="LITEBLU2", f="FLAT23" }
  LITEBLU3 = { t="LITEBLU3", f="FLAT23" }
  LITEMET  = { t="LITEMET",  f="FLOOR4_8" }
  LITERED  = { t="LITERED",  f="FLOOR1_6" }
  LITESTON = { t="LITESTON", f="MFLR8_1" }

  NUKESLAD = { t="NUKESLAD", f="FLOOR7_1" }
  PLANET1  = { t="PLANET1",  f="FLAT23" }
  REDWALL1 = { t="REDWALL1", f="FLOOR1_6" }
  SKINBORD = { t="SKINBORD", f="FLAT5_5" }
  SKINTEK1 = { t="SKINTEK1", f="FLAT5_5" }
  SKINTEK2 = { t="SKINTEK2", f="FLAT5_5" }
  SKULWAL3 = { t="SKULWAL3", f="FLAT5_6" }
  SKULWALL = { t="SKULWALL", f="FLAT5_6" }
  SLADRIP1 = { t="SLADRIP1", f="FLOOR7_1" }

  SP_DUDE6 = { t="SP_DUDE6", f="DEM1_5" }
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" }
  STARTAN1 = { t="STARTAN1", f="FLOOR4_1" }
  STONGARG = { t="STONGARG", f="MFLR8_1" }
  STONPOIS = { t="STONPOIS", f="FLAT5_4" }
  TEKWALL2 = { t="TEKWALL2", f="CEIL5_1" }
  TEKWALL3 = { t="TEKWALL3", f="CEIL5_1" }
  TEKWALL5 = { t="TEKWALL5", f="CEIL5_1" }
  WOODSKUL = { t="WOODSKUL", f="FLAT5_2" }


  -- switches --

  SW1BRN1  = { t="SW1BRN1",  f="FLOOR0_1" }
  SW1STARG = { t="SW1STARG", f="FLAT23" }
  SW1STONE = { t="SW1STONE", f="FLAT1" }
  SW1STON2 = { t="SW1STON2", f="MFLR8_1" }


  -- floors --

  FLAT5_6  = { f="FLAT5_6", t="SKULWALL" }
  FLAT5_7  = { f="FLAT5_7", t="ASHWALL" }
  FLAT5_8  = { f="FLAT5_8", t="ASHWALL" }
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL" }
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL" }


  -- flats with different side textures --

  CONS1_1  = { f="CONS1_1", t="COMPWERD" }
  CONS1_5  = { f="CONS1_5", t="COMPWERD" }
  CONS1_7  = { f="CONS1_7", t="COMPWERD" }

  FLAT10   = { f="FLAT10", t="BROWNHUG" }
  FLAT1_1  = { f="FLAT1_1", t="BROWN1" }
  FLAT1_2  = { f="FLAT1_2", t="BROWN1" }
  FLAT1_3  = { f="FLAT1_3", t="BROWN1" }
  FLAT5_5  = { f="FLAT5_5", t="BROWN1" }


  -- rails --

  BRNBIGC  = { t="BRNBIGC",  rail_h=128 }

  MIDVINE1 = { t="MIDVINE1", rail_h=128 }
  MIDVINE2 = { t="MIDVINE2", rail_h=128 }

  -- this is the MIDBARS3 texture from FreeDoom
  MIDBARS3 = { t="SP_DUDE3", rail_h=72 }


  -- liquid stuff (using new patches)
  BFALL1   = { t="BLODGR1",  f="BLOOD1", sane=1 }
  BLOOD1   = { t="BLODGR1",  f="BLOOD1", sane=1 }

  SFALL1   = { t="SLADRIP1", f="NUKAGE1", sane=1 }
  NUKAGE1  = { t="SLADRIP1", f="NUKAGE1", sane=1 }


  -- compatibility stuff

  ASHWALL2 = { t="ASHWALL",  f="FLOOR6_2" }
  BRICKLIT = { t="LITEMET",  f="CEIL5_1" }
  PIPEWAL1 = { t="COMPWERD", f="CEIL5_1" }
  SPACEW3  = { t="COMPUTE1", f="FLAT1" }
  SILVER3  = { t="PLANET1",  f="FLAT23" }
  WOOD9    = { t="WOOD1",    f="FLAT5_2" }
  WOOD10   = { t="WOOD1",    f="FLAT5_2" }
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
  gunner   = REMOVE_ME
  revenant = REMOVE_ME
  knight   = REMOVE_ME
  mancubus = REMOVE_ME
  arach    = REMOVE_ME
  vile     = REMOVE_ME
  pain     = REMOVE_ME
  ss_nazi  = REMOVE_ME
}


--------------------------------------------------------------------

--Fixed up for future use in V6 -Chris

ULTDOOM.THEMES =
{
  DEFAULTS =
  {
    keys =
    {
      kc_red    = 50
      kc_blue   = 50
      kc_yellow = 50
    }

    switches = { sw_blue=50 }

    cave_torches =
    {
      red_torch   = 60
      green_torch = 40
      blue_torch  = 20
    }

    fences =
    {
      BROWN144 = 60
      WOOD5    = 40
      STONE    = 30
      SLADWALL = 20

      BROVINE  = 15
      GRAYVINE = 15
      GSTVINE2 = 15
      SP_ROCK1 =  5
    }
  }
}


ULTDOOM.ROOM_THEMES =
{
  -- this field ensures these theme entries REPLACE those of Doom 2.
  replace_all = true


  generic_Stairwell =
  {
    kind = "stairwell"

    walls =
    {
      BROWN1  = 50
      GRAY1   = 50
      STARGR1 = 50
      METAL1  = 20
    }

    floors =
    {
      FLAT1 = 30
      FLOOR7_1 = 50
    }
  }


------ EPISODE 1 : Tech Bases ----------------------

  tech =
  {
    liquids =
    {
      nukage = 90
      water = 15
      lava = 10
    }

    facades =
    {
      BROWN1 = 50
      BROWNGRN = 20
      BROWN96 = 5
      STONE2 = 10
      STONE3 = 10
      STARTAN3 = 30
      STARG3 = 20
    }

    base_skin =
    {
      big_door = "BIGDOOR2"
    }

    style_list =
    {
      naturals = { none=30, few=70, some=30, heaps=2 }
    }

    techy_doors = true

    ---!!!  TEMPORARY V3 CRUD  !!!---
  }


  tech_Room =
  {
    kind = "building"

    walls =
    {
      STARTAN3 = 25
      STARTAN2 = 12
      STARTAN1 = 5
      STARG1 = 5
      STARG2 = 15
      STARG3 = 15
      STARBR2 = 5
      STARGR2 = 10
      METAL1 = 2
    }

    floors =
    {
      FLOOR0_1 = 30
      FLOOR0_2 = 20
      FLOOR0_3 = 30
      FLOOR0_7 = 20
      FLOOR3_3 = 15
      FLOOR7_1 = 10
      FLOOR4_5 = 30
      FLOOR4_6 = 20
      FLOOR4_8 = 50
      FLOOR5_1 = 35
      FLOOR5_2 = 30
      FLAT1 = 10
      FLAT5 = 20
      FLAT14 = 20
      FLAT5_4 = 20
    }

    ceilings =
    {
      CEIL5_1 = 20
      CEIL3_3 = 15
      CEIL3_5 = 50
      FLAT1 = 20
      FLAT4 = 15
      FLAT18 = 20
      FLOOR0_2 = 10
      FLOOR4_1 = 30
      FLOOR5_1 = 15
      FLOOR5_4 = 10
      CEIL4_1 = 15
      CEIL4_2 = 15
    }
  }


  tech_Brown =
  {
    kind = "building"

    walls =
    {
      BROWN1 = 30
      BROWNGRN = 20
      BROWN96 = 10
      BROVINE = 5
      BROVINE2 = 5
    }

    floors =
    {
      FLOOR0_1 = 30
      FLOOR0_2 = 20
      FLOOR3_3 = 20
      FLOOR7_1 = 15
      FLOOR4_5 = 30
      FLOOR4_6 = 30
      FLOOR5_2 = 30
      FLAT5 = 20
      FLAT14 = 10
      FLAT5_4 = 10
    }

    ceilings =
    {
      CEIL5_1 = 20
      CEIL3_3 = 15
      CEIL3_5 = 50
      FLAT1 = 20
      FLOOR4_1 = 30
      FLAT5_4 = 10
      FLOOR5_4 = 10
    }
  }


  tech_Computer =
  {
    prob = 10
    kind = "building"

    walls =
    {
      COMPSPAN = 30
      COMPOHSO = 10
      COMPTILE = 15
      COMPBLUE = 15
      TEKWALL4 = 3
    }

    floors =
    {
      FLAT14 = 50
      FLOOR1_1 = 15
      FLAT4 = 10
      CEIL4_1 = 20
      CEIL4_2 = 20
      CEIL5_1 = 20
    }


    ceilings =
    {
      CEIL5_1 = 50
      CEIL4_1 = 15
      CEIL4_2 = 15
    }
  }


  tech_Shiny =
  {
    kind = "building"
    prob = 10

    walls =
    {
      SHAWN2 = 50
      METAL1 = 5
    }

    floors =
    {
      FLOOR4_8 = 10
      FLAT14 = 10
      FLOOR1_1 = 5
      FLAT23 = 60
    }

    ceilings =
    {
      FLAT23 = 50
    }
  }


  tech_Gray =
  {
    kind = "building"
    prob = 20

    walls =
    {
      GRAY1 = 50
      GRAY4 = 30
      GRAY7 = 30
      ICKWALL1 = 40
      ICKWALL3 = 20
    }

    floors =
    {
      FLAT4 = 50
      FLOOR0_3 = 30
      FLAT5_4 = 25
      FLAT19 = 15
      FLAT1 = 15
      FLOOR0_5 = 10
    }

    ceilings =
    {
      FLAT19 = 40
      FLAT5_4 = 20
      FLAT4  = 20
      FLAT23 = 10
      FLAT1 = 10
    }
  }


  tech_Hallway =
  {
    kind = "hallway"

    walls =
    {
      BROWN1 = 33
      BROWNGRN = 50
      STARBR2 = 15
      STARTAN3 = 30
      STARG3 = 30
      TEKWALL4 = 5
    }

    floors =
    {
      FLOOR0_1 = 30
      FLOOR0_2 = 20
      FLOOR0_3 = 30
      FLOOR0_7 = 20
      FLOOR3_3 = 15
      FLOOR7_1 = 15
      FLOOR4_5 = 30
      FLOOR4_6 = 20
      FLOOR4_8 = 30
      FLOOR5_1 = 35
      FLOOR5_2 = 30
      FLAT1 = 10
      FLAT4 = 20
      FLAT5 = 20
      FLAT9 = 5
      FLAT14 = 20
      FLAT5_4 = 20
      CEIL5_1 = 30
      CEIL4_1 = 10
      CEIL4_2 = 10
    }

    ceilings =
    {
      FLAT4 = 20
      CEIL5_1 = 35
      CEIL3_5 = 50
      CEIL3_3 = 20
      FLAT19 = 20
      FLAT23 = 20
      FLAT5_4 = 15
      CEIL4_1 = 20
      CEIL4_2 = 20
    }
  }


  tech_Cave =
  {
    kind = "cave"

    naturals =
    {
      ASHWALL = 30
      SP_ROCK1 = 60
      GRAYVINE = 20
      TEKWALL4 = 3
    }
  }


  tech_Outdoors =
  {
    kind = "outdoors"

    floors =
    {
      BROWN144 = 30
      BROWN1 = 20
      STONE = 20
      ASHWALL = 5
      FLAT10 = 5
    }

    naturals =
    {
      ASHWALL = 35
      SP_ROCK1 = 70
      GRAYVINE = 20
      STONE = 30
    }
  }


------ EPISODE 2 ------------------------------

  -- Deimos theme by Chris Pisarczyk

  deimos =
  {
    liquids =
    {
      nukage = 60
      blood = 20
      water = 10
    }

    -- Best facades would be STONE/2/3, BROVINE/2, BROWN1 and maybe a few others as I have not seen many
    -- other textures on the episode 2 exterior.
    facades =
    {
      STONE2 = 40
      STONE3 = 60
      BROVINE = 30
      BROVINE2 = 25
      BROWN1 = 50
      BROWNGRN = 20
    }

    base_skin =
    {
      big_door = "BIGDOOR2"
    }

    style_list =
    {
      naturals = { none=40, few=70, some=20, heaps=2 }
    }

    techy_doors = true
  }


  deimos_Room =
  {
    kind = "building"

    walls =
    {
      STARTAN3 = 10
      STARTAN2 = 5
      STARTAN1 = 5
      STARG2 = 15
      ICKWALL1 = 15
      STARBR2 = 15
      STARGR2 = 10
      STARG1 = 5
      STARG2 = 5
      STARG3 = 7
      ICKWALL3 = 30
      GRAY7 = 20
      GRAY5 = 15
      GRAY1 = 15
      BROWN1 = 5
      BROWNGRN = 10
      BROWN96 = 5
      STONE2 = 30
      STONE3 = 20
    }

    floors =
    {
      FLOOR0_1 = 30
      FLOOR0_2 = 40
      FLOOR0_3 = 30
      CEIL4_1 = 5
      FLOOR0_7 = 10
      FLOOR3_3 = 20
      FLOOR7_1 = 20
      CEIL4_2 = 10
      FLOOR4_1 = 30
      FLOOR4_6 = 20
      FLOOR4_8 = 50
      FLOOR5_2 = 35
      FLAT1 = 40
      FLAT5 = 30
      FLAT14 = 10
      FLAT1_1 = 30
      FLOOR1_6 = 3
      FLAT1_2 = 30
      FLOOR5_1 = 50
      FLAT3 = 15
      FLAT5_4 = 15
    }

    ceilings =
    {
      CEIL5_1 = 30
      CEIL3_3 = 70
      CEIL3_5 = 50
      CEIL4_1 = 10
      CEIL4_2 = 10
      FLAT1 = 30
      FLAT4 = 20
      FLAT19 = 30
      FLAT8 = 15
      FLAT5_4 = 20
      FLOOR0_2 = 20
      FLOOR4_1 = 50
      FLOOR5_1 = 50
      FLOOR5_4 = 10
    }
  }


  deimos_Hellish =
  {
    kind = "building"

    walls =
    {
      MARBLE1 = 15
      MARBLE2 = 15
      MARBLE3 = 15
      BROWNGRN = 15
      COMPTILE = 15
      BROWN1 = 15
      STARTAN3 = 15
      STARG3 = 15
      WOOD1 = 15
      WOOD3 = 15
      WOOD5 = 15
      BROVINE = 15
      BROVINE2 = 15
      ICKWALL3 = 15
      GRAY7 = 15
    }

    floors =
    {
      DEM1_5 = 30
      DEM1_6 = 50
      FLAT10 = 5
      FLOOR7_1 = 5
      FLOOR7_2 = 50
      FLOOR4_1 = 30
      FLOOR4_6 = 20
      FLOOR4_8 = 50
      FLOOR5_2 = 35
      FLAT1 = 40
      FLAT5 = 30
      FLAT14 = 10
    }

    ceilings =
    {
      FLOOR7_2 = 50
      DEM1_5 = 50
      DEM1_6 = 30
      FLOOR6_2 = 5
      CEIL5_1 = 30
      CEIL3_3 = 50
      CEIL3_5 = 30
      CEIL4_1 = 10
      CEIL4_2 = 10
    }
  }


  deimos_Lab =
  {
    kind = "building"
    prob = 10

    walls =
    {
      COMPTILE = 40
      COMPBLUE = 10
      COMPSPAN = 15
      METAL1 = 20
    }

    floors =
    {
      FLOOR4_8 = 15
      FLOOR5_1 = 15
      FLAT14 = 40
      FLOOR1_1 = 30
      CEIL4_2 = 20
      CEIL4_1 = 20
    }

    ceilings =
    {
      CEIL5_1 = 30
      CEIL4_1 = 10
      CEIL4_2 = 15
      FLOOR4_8 = 15
      FLAT14 = 10
    }
  }


  deimos_Hallway =
  {
    kind = "hallway"

    walls =
    {
      BROWN1 = 33
      BROWNGRN = 50
      BROVINE = 20
      BROVINE2 = 15
      GRAY1 = 50
      GRAY5 = 33
      ICKWALL1 = 30
      ICKWALL3 = 30
      STONE2 = 40
      STONE3 = 50
      METAL1 = 30
    }

    floors =
    {
      FLAT4 = 30
      CEIL4_1 = 15
      CEIL4_2 = 15
      CEIL5_1 = 30
      FLAT14 = 20
      FLAT5_4 = 20
      FLOOR3_3 = 30
      FLOOR4_8 = 40
      FLOOR5_1 = 25
      FLOOR5_2 = 10
      FLAT5 = 20
      FLOOR1_6 = 4
      FLOOR7_2 = 3
      FLAT5_1 = 3
      FLAT5_2 = 3
      DEM1_5 = 3
      DEM1_6 = 3
    }

    ceilings =
    {
      FLAT4 = 20
      CEIL4_1 = 15
      CEIL4_2 = 15
      CEIL5_1 = 30
      CEIL3_5 = 25
      CEIL3_3 = 50
      FLAT18 = 15
      FLAT19 = 20
      FLAT5_4 = 10
      FLOOR4_8 = 25
      FLOOR5_1 = 20
      FLOOR7_1 = 15
      FLOOR7_2 = 2
      FLAT5_1 = 2
      FLAT5_2 = 2
      DEM1_5 = 2
      DEM1_6 = 2
    }
  }


  deimos_Hallway_hell =
  {
    kind = "hallway"

    walls =
    {
      MARBLE1 = 20
      MARBLE2 = 20
      MARBLE3 = 20
      GSTONE1 = 20
      BROVINE = 20
      COMPTILE = 20
    }

    floors =
    {
      FLAT4 = 30
      CEIL4_1 = 15
      CEIL4_2 = 15
      CEIL5_1 = 30
      FLAT14 = 20
      FLAT5_4 = 20
      FLOOR3_3 = 30
      FLOOR4_8 = 40
      FLOOR5_1 = 25
      FLOOR5_2 = 10
      FLAT5 = 20
      FLOOR1_6 = 4
      FLOOR7_2 = 15
      FLAT5_1 = 15
      FLAT5_2 = 15
      DEM1_5 = 15
      DEM1_6 = 15
    }

    ceilings =
    {
      FLAT4 = 20
      CEIL4_1 = 15
      CEIL4_2 = 15
      CEIL5_1 = 30
      CEIL3_5 = 25
      CEIL3_3 = 20
      FLAT18 = 15
      FLAT19 = 20
      FLAT5_4 = 10
      FLOOR4_8 = 15
      FLOOR5_1 = 20
      FLOOR7_1 = 15
      FLOOR7_2 = 15
      FLAT5_1 = 15
      FLAT5_2 = 15
      DEM1_5 = 15
      DEM1_6 = 15
    }
  }


  deimos_Cave =
  {
    kind = "cave"

    naturals =
    {
      SP_ROCK1 = 90
      ASHWALL = 20
      BROWNHUG = 15
      GRAYVINE = 10
    }
  }


  deimos_Outdoors =
  {
    kind = "outdoors"

--Makes sense for high prob for SP_ROCK1 because the intermission screen shows
--Deimos has a desolate, gray ground.
    floors = 
    { 
      BROWN144 = 30
      BROWN1 = 10
      STONE = 10 
    }

    naturals = 
    { 
      SP_ROCK1 = 60
      ASHWALL = 2
      FLAT10 = 3 
    }
  }


----- EPISODE 3 : Hell ---------------------------

  hell =
  {
    --  Water is seen in a few locations in episode 3 -Chris

    liquids =
    {
      lava = 30
      blood = 90
      nukage = 5
      water = 10
    }

    keys =
    {
      ks_red = 50
      ks_blue = 50
      ks_yellow = 50
    }

    facades =
    {
      STONE2 = 10
      STONE3 = 15
      WOOD1 = 50
      GSTONE1 = 45
      MARBLE1 = 30
      BROWN1 = 5
      BROWNGRN = 5
      WOOD5 = 25
      SP_HOT1 = 10
      SKINMET1 = 10
      SKINMET2 = 10
      SKINTEK1 = 10
    }

    base_skin =
    {
    }

    monster_prefs =
    {
      zombie  = 0.3
      shooter = 0.6
      skull   = 2.0
    }

    archy_arches = true
  }


  hell_Marble =
  {
    kind = "building"
    prob = 90

    walls =
    {
      MARBLE1 = 30
      MARBLE2 = 15
      MARBLE3 = 20
      GSTVINE1 = 20
      GSTVINE2 = 20
      SKINMET1 = 3
      SKINMET2 = 3
      SKINTEK1 = 5
      SKINTEK2 = 5
    }

    floors =
    {
      DEM1_5 = 30
      DEM1_6 = 30
      FLAT5_7 = 10
      FLAT5_8 = 5
      FLAT10 = 10
      FLOOR7_1 = 10
      FLOOR7_2 = 30
      FLAT1 = 10
      FLAT5 = 5
      FLAT8 = 5
      FLOOR5_2 = 10
    }

    ceilings =
    {
      FLAT1 = 10
      FLAT10 = 10
      FLAT5_5 = 5
      FLOOR7_2 = 30
      DEM1_5 = 30
      DEM1_6 = 30
      FLOOR6_2 = 5
      FLAT5_1 = 5
      FLAT5_2 = 5
      CEIL1_1 = 5
    }

    corners =
    {
      SKULWALL = 8
      SKULWAL3 = 7
    }
  }


  hell_Wood =
  {
    kind = "building"
    prob = 20

    walls =
    {
      WOOD1 = 50
      WOOD3 = 30
      WOOD5 = 20
    }

    floors =
    {
      FLAT5_1 = 30
      FLAT5_2 = 50
      FLAT5_5 = 15
    }

    ceilings =
    {
      CEIL1_1 = 50
      FLAT5_2 = 30
      FLAT5_1 = 15
    }
  }


  hell_Skin =
  {
    kind = "building"
    prob = 20

    walls =
    {
      SKIN2 = 15
      SKINFACE = 20
      SKSNAKE2 = 20
      SKINTEK1 = 10
      SKINTEK2 = 10
      SKINMET1 = 50
      SKINMET2 = 40
      SKINCUT = 10
      SKINSYMB = 5
    }

    floors =
    {
      SFLR6_1 = 10
      FLOOR7_1 = 20
      FLAT5_5 = 10
      FLOOR6_1 = 40
      MFLR8_2 = 10
      MFLR8_4 = 10
    }

    ceilings =
    {
      SFLR6_1 = 30
      SFLR6_4 = 10
      FLOOR6_1 = 20
    }
  }


  hell_Hot =
  {
    kind = "building"
    prob = 60

    walls =
    {
      SP_HOT1 = 70
      GSTVINE1 = 15
      GSTVINE2 = 15
      STONE = 10
      STONE3 = 5
      SKINMET2 = 5
      BROWN1 = 2
      SKINCUT = 2
      SKINTEK1 = 5
      SKINTEK2 = 5
    }

    floors =
    {
      FLAT5_7 = 10
      FLAT5_8 = 10
      FLAT10 = 10
      FLAT5_3 = 30
      FLOOR7_1 = 15
      FLAT1 = 10
      FLOOR5_2 = 10
      FLOOR6_1 = 35
      FLAT8 = 15
      FLAT5 = 15
    }

    ceilings =
    {
      FLAT1 = 15
      FLOOR6_1 = 30
      FLOOR6_2 = 15
      FLAT10 = 10
      FLAT8 = 5
      FLAT5_3 = 20
      FLAT5_1 = 5
      FLAT5_2 = 5
      CEIL1_1 = 5
    }

    corners =
    {
      SKULWALL = 10
      SKULWAL3 = 10
      REDWALL1 = 15
    }
  }


  hell_Hallway =
  {
    kind = "hallway"

    walls =
    {
      BROWN1 = 33
      BROWNGRN = 50
      BROVINE = 20
      BROVINE2 = 15
      GRAY1 = 50
      GRAY5 = 33
      ICKWALL1 = 30
      ICKWALL3 = 30
      STONE2 = 40
      STONE3 = 50
      METAL1 = 30
    }

    floors =
    {
      FLAT4 = 30
      CEIL4_1 = 15
      CEIL5_1 = 30
      FLAT14 = 20
      FLAT5_4 = 20
      FLOOR5_2 = 10
      FLAT5 = 20
      FLOOR7_2 = 3
      FLAT5_2 = 3
      DEM1_5 = 3
      DEM1_6 = 3
    }

    ceilings =
    {
      FLAT4 = 20
      CEIL4_2 = 15
      CEIL5_1 = 30
      CEIL3_3 = 50
      FLAT19 = 20
      FLAT5_4 = 10
      FLOOR7_1 = 2
      FLAT5_1 = 2
      DEM1_6 = 2
    }
  }


  hell_Outdoors =
  {
    kind = "outdoors"

    floors =
    {
      ASHWALL = 30
      FLAT5_4 = 5
      FLAT10 = 20
      FLOOR6_1 = 40
      SFLR6_1 = 10
      SFLR6_4 = 10
      MFLR8_2 = 15
      MFLR8_4 = 10
      FLAT5_2 = 5
      FLAT5 = 5
    }

    naturals =
    {
      ASHWALL = 50
      GRAYVINE = 20
      SP_ROCK1 = 50
      ROCKRED1 = 90
      SKSNAKE1 = 10
      SKSNAKE2 = 10
    }
  }


  hell_Outdoors_hot =
  {
    kind = "outdoors"

    floors =
    {
      FLAT5_6 = 5
      ASHWALL = 10
      FLAT10 = 20
      DEM1_5 = 15
      DEM1_6 = 15
      FLOOR7_2 = 20
      FLOOR7_1 = 15
      SFLR6_1 = 10
      SFLR6_4 = 15
      MFLR8_2 = 10
      FLAT5_2 = 5
    }

    naturals =
    {
      ASHWALL = 30
      GRAYVINE = 15
      SP_ROCK1 = 50
      ROCKRED1 = 90
      SKSNAKE1 = 10
      SKSNAKE2 = 10
      FIREBLU1 = 70
    }
  }


  hell_Cave =
  {
    kind = "cave"

    naturals =
    {
      ROCKRED1 = 90
      SKIN2 = 30
      SKINFACE = 25
      SKSNAKE1 = 35
      SKSNAKE2 = 35
      FIREBLU1 = 50
      FIRELAVA = 50
      ASHWALL  = 20
    }
  }


----- EPISODE 4 -------------------------------

  -- Thy Flesh Consumed by Chris Pisarczyk
  -- Basically a modified version of doom_hell1 to match id's E4 better

  flesh =
  {
    liquids =
    {
      lava = 30
      blood = 50
      nukage = 10
      water = 20
    }

    keys =
    {
      ks_red = 50
      ks_blue = 50
      ks_yellow = 50
    }

    facades =
    {
      STONE2 = 20
      STONE3 = 15
      WOOD1 = 50
      GSTONE1 = 30
      MARBLE1 = 20
      BROWN1 = 10
      BROWNGRN = 10
      WOOD5 = 40
      SP_HOT1 = 5
      SKINMET1 = 10
      SKINMET2 = 10
    }

    base_skin =
    {
    }

    monster_prefs =
    {
      zombie = 0.6
      shooter = 0.8
      skull = 1.2
      demon = 1.5
    }

    archy_arches = true

  }


  flesh_Room =
  {
    kind = "building"
    prob = 90

    walls =
    {
      BROWNGRN = 20
      BROVINE2 = 15
      WOOD5 = 10
      GSTONE1 = 20
      STONE = 10
      STONE2 = 5
      STONE3 = 10
    }

    floors =
    {
      DEM1_5 = 10
      DEM1_6 = 10
      FLAT5_5 = 10
      FLAT5_7 = 7
      FLAT5_8 = 7
      FLAT10 = 12
      FLOOR7_1 = 10
      FLOOR7_2 = 10
      FLOOR5_2 = 10
      FLOOR5_3 = 10
      FLOOR5_4 = 10
      FLAT5 = 10
      FLAT8 = 10
      SFLR6_1 = 5
      SFLR6_4 = 5
      MFLR8_1 = 5
      MFLR8_2 = 10
    }

    ceilings =
    {
      FLAT1 = 10
      FLAT10 = 10
      FLAT5_5 = 10
      FLOOR7_2 = 15
      DEM1_6 = 10
      FLOOR6_1 = 10
      FLOOR6_2 = 10
      MFLR8_1 = 12
      FLAT5_4 = 10
      SFLR6_1 = 5
      SFLR6_4 = 5
      CEIL1_1 = 10
      FLAT5_1 = 5
      FLAT5_2 = 5
      FLAT8 = 8
    }
  }


  flesh_Wood =
  {
    kind = "building"
    prob = 50

    walls =
    {
      WOOD1 = 50
      WOOD3 = 30
      WOOD5 = 20
      SKINMET1 = 15
      SKINMET2 = 15
      SKINTEK1 = 6
      SKINTEK2 = 6
    }

    floors =
    {
      FLAT5_1 = 30
      FLAT5_2 = 50
      FLAT5_5 = 15
      FLAT5 = 7
      FLAT8 = 7
    }

    ceilings =
    {
      CEIL1_1 = 50
      FLAT5_2 = 30
      FLAT5_1 = 15
      FLOOR7_1 = 10
    }
  }
 

  flesh_Marble =
  {
    kind = "building"
    prob = 30

    walls =
    {
      MARBLE1 = 50
      MARBLE2 = 25
      MARBLE3 = 20
    }

    floors =
    {
      DEM1_5 = 30
      DEM1_6 = 50
      FLAT10 = 5
      FLOOR7_1 = 5
      FLOOR7_2 = 50
    }

    ceilings =
    {
      FLOOR7_2 = 50
      DEM1_5 = 50
      DEM1_6 = 50
      FLOOR6_2 = 5
    }
  }


  -- andrewj: this is a straight copy of deimos_Hallway_hell

  flesh_Hallway_hell =
  {
    kind = "hallway"

    walls =
    {
      MARBLE1 = 20
      MARBLE2 = 20
      MARBLE3 = 20
      GSTONE1 = 20
      BROVINE = 20
      COMPTILE = 20
    }

    floors =
    {
      FLAT4 = 30
      CEIL4_1 = 15
      CEIL4_2 = 15
      CEIL5_1 = 30
      FLAT14 = 20
      FLAT5_4 = 20
      FLOOR3_3 = 30
      FLOOR4_8 = 40
      FLOOR5_1 = 25
      FLOOR5_2 = 10
      FLAT5 = 20
      FLOOR1_6 = 4
      FLOOR7_2 = 15
      FLAT5_1 = 15
      FLAT5_2 = 15
      DEM1_5 = 15
      DEM1_6 = 15
    }

    ceilings =
    {
      FLAT4 = 20
      CEIL4_1 = 15
      CEIL4_2 = 15
      CEIL5_1 = 30
      CEIL3_5 = 25
      CEIL3_3 = 20
      FLAT18 = 15
      FLAT19 = 20
      FLAT5_4 = 10
      FLOOR4_8 = 15
      FLOOR5_1 = 20
      FLOOR7_1 = 15
      FLOOR7_2 = 15
      FLAT5_1 = 15
      FLAT5_2 = 15
      DEM1_5 = 15
      DEM1_6 = 15
    }
  }


  flesh_Cave =
  {
    kind = "cave"

    naturals =
    {
      ROCKRED1 = 70
      SP_ROCK1 = 50
      BROWNHUG = 15
      SKIN2 = 10
      SKINFACE = 20
      SKSNAKE1 = 5
      SKSNAKE2 = 5
      FIREBLU1 = 10
      FIRELAVA = 10
    }
  }


  flesh_Outdoors =
  {
    kind = "outdoors"

    floors =
    {
      ASHWALL = 12
      FLAT1_1 = 15
      FLAT5_4 = 10
      FLAT10 = 20
      FLAT5_7 = 10
      FLAT5_8 = 10
      MFLR8_4 = 10
      FLOOR7_1 = 15
      SFLR6_1 = 8
      SFLR6_4 = 8
      FLAT5 = 7
      MFLR8_2 = 5
      FLAT1_1 = 10
      FLAT1_2 = 10
      MFLR8_3 = 10
      FLAT5_2 = 20
    }

    naturals =
    {
      ASHWALL = 30
      GRAYVINE = 20
      SP_ROCK1 = 70
      ROCKRED1 = 70
      BROWNHUG = 20
      SKSNAKE1 = 10
      SKSNAKE2 = 10
    }
  }
}


--------------------------------------------------------------------

ULTDOOM.EPISODES =
{
  episode1 =
  {
    ep_index = 1

    theme = "tech"
    sky_patch = "SKY1"
    dark_prob = 10

    name_patch = "M_EPI1"
    description = "Knee-Deep in the Dead"
  }

  episode2 =
  {
    ep_index = 2

    theme = "deimos"
    sky_patch = "SKY2"
    dark_prob = 40

    name_patch = "M_EPI2"
    description = "The Shores of Hell"
  }

  episode3 =
  {
    ep_index = 3

    theme = "hell"
    sky_patch = "SKY3"
    dark_prob = 10

    name_patch = "M_EPI3"
    description = "Inferno"
  }

  episode4 =
  {
    ep_index = 4

    theme = "flesh"
    sky_patch = "SKY4"
    dark_prob = 10

    name_patch = "M_EPI4"
    description  = "Thy Flesh Consumed"
  }
}


ULTDOOM.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=50,  file="games/doom/data/boss1/anomaly1.wad", map="E1M8" }
    { prob=50,  file="games/doom/data/boss1/anomaly2.wad", map="E1M8" }
    { prob=100, file="games/doom/data/boss1/anomaly3.wad", map="E1M8" }
    { prob=50,  file="games/doom/data/boss1/ult_anomaly.wad",  map="E1M8" }
    { prob=100, file="games/doom/data/boss1/ult_anomaly2.wad", map="E1M8" }
  }

  E2M8 =
  {
    { prob=40,  file="games/doom/data/boss1/tower1.wad", map="E2M8" }
    { prob=60,  file="games/doom/data/boss1/tower2.wad", map="E2M8" }
    { prob=100, file="games/doom/data/boss1/ult_tower.wad", map="E2M8" }
  }

  E3M8 =
  {
    { prob=50,  file="games/doom/data/boss1/dis1.wad", map="E3M8" }
    { prob=100, file="games/doom/data/boss1/ult_dis.wad", map="E3M8" }
  }

  E4M6 =
  {
    { prob=50, file="games/doom/data/boss1/tower1.wad", map="E2M8" }
  }

  E4M8 =
  {
    { prob=50, file="games/doom/data/boss1/dis1.wad", map="E3M8" }
  }
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
        episode = EPI

        name  = string.format("E%dM%d",   ep_index,   map)
        patch = string.format("WILV%d%d", ep_index-1, map-1)

        ep_along = ep_along
        game_along = (ep_index - 1 + ep_along) / EP_NUM
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

      if map == 9 then
        LEV.is_secret = true
      end

      -- prebuilt levels
      LEV.prebuilt = GAME.PREBUILT_LEVELS[LEV.name]

      if LEV.prebuilt then
        LEV.name_class = LEV.prebuilt.name_class or "BOSS"
      end

      if MAP_NUM == 1 or map == 3 then
        LEV.demo_lump = string.format("DEMO%d", ep_index)
      end
    end -- for map

  end -- for episode
end


function ULTDOOM.setup()
  -- tweak monster probabilities
  GAME.MONSTERS["Cyberdemon"].crazy_prob = 5
  GAME.MONSTERS["Mastermind"].crazy_prob = 12
end


--------------------------------------------------------------------

UNFINISHED["doom1"] =
{
  label = "Doom 1"

  priority = 98  -- keep at second spot

  format = "doom"
  game_dir = "doom"

  tables =
  {
    DOOM, ULTDOOM
  }

  hooks =
  {
    setup      = ULTDOOM.setup
    get_levels = ULTDOOM.get_levels

    end_level  = DOOM.end_level
    all_done   = DOOM.all_done
  }
}


UNFINISHED["ultdoom"] =
{
  label = "Ultimate Doom"

  extends = "doom1"

  priority = 97  -- keep at third spot
  
  -- no additional tables

  -- no additional hooks
}


--------------------------------------------------------------------

OB_THEMES["deimos"] =
{
  label = "Deimos"
  priority = 16
  game = "doom1"
  name_class = "TECH"
  mixed_prob = 30
}


OB_THEMES["flesh"] =
{
  label = "Thy Flesh"
  priority = 12
  game = "ultdoom"
  name_class = "GOTHIC"
  mixed_prob = 20
}

