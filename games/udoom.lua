----------------------------------------------------------------
--  GAME DEFINITION : ULTIMATE DOOM
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------
--
--  Note: common definitions are in doom.lua
--        (including entities, monsters and weapons)
--
----------------------------------------------------------------

DOOM1 = { }


DOOM1.MATERIALS =
{
  -- these are the materials unique to Ultimate DOOM


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

  SP_DUDE3 = { t="SP_DUDE3", f="DEM1_5" }
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


  -- rails --

  BRNBIGC  = { t="BRNBIGC",  rail_h=128, line_flags=1 }

  MIDVINE1 = { t="MIDVINE1", rail_h=128 }
  MIDVINE2 = { t="MIDVINE2", rail_h=128 }


  -- liquid stuff (using new patches)
  BFALL1   = { t="BLODGR1",  f="BLOOD1", sane=1 }
  BLOOD1   = { t="BLODGR1",  f="BLOOD1", sane=1 }

  SFALL1   = { t="SLADRIP1", f="NUKAGE1", sane=1 }
  NUKAGE1  = { t="SLADRIP1", f="NUKAGE1", sane=1 }


  -- FIXME: HACK HACK HACK
  BRICKLIT = { t="LITEMET",  f="CEIL5_1" }
  PIPEWAL1 = { t="COMPWERD", f="CEIL5_1" }
  MIDBARS3 = { t="MIDGRATE", f="CEIL5_1" }
}

 
DOOM1.THEME_DEFAULTS =
{
  big_junctions =
  {
    Junc_Octo = 70
    Junc_Spokey = 10
  }
}


DOOM1.ROOM_THEMES =
{
  ----- Tech Bases -------------------------

  D1_Tech_room =
  {
    walls =
    {
      STARTAN3=25, STARG2=20, STARTAN2=18, STARG3=11,
      STARBR2=5, STARGR2=10, STARG1=5, STARG2=5,
      SLADWALL=18, GRAY7=10, BROWN1=5,
      BROWNGRN=10, BROWN96=8, METAL1=1, GRAY5=3,

      COMPOHSO=10, STARTAN1=5, COMPTILE=5,
    }

    floors =
    {
      FLOOR0_1=50, FLOOR0_2=20, FLOOR0_3=50,
      FLOOR0_7=50, FLOOR3_3=50, FLOOR7_1=10,
      FLOOR4_5=50, FLOOR4_6=50, FLOOR4_8=50, FLOOR5_2=50,
      FLAT1=20, FLAT5=20, FLAT9=50, FLAT14=50,
      CEIL3_2=50,
    }

    ceilings =
    {
      CEIL5_1=50, CEIL5_2=50, CEIL3_3=50, CEIL3_5=50,
      FLAT1=50, FLAT4=50, FLAT18=50,
      FLOOR0_2=50, FLOOR4_1=50, FLOOR5_1=50, FLOOR5_4=20,
      TLITE6_5=2, TLITE6_6=2, CEIL1_2=2,
    }

    __corners =
    {
      STARGR1=40, METAL1=20, ICKWALL3=6,
      TEKWALL4=6, COMPTALL=3, COMPBLUE=3,

      COMPTILE=10,
    }
  }


  D1_Tech_hallway =
  {
    walls =
    {
      BROWN1=33, BROWNGRN=50, GRAY1=50, STARBR2=33
    }

    floors =
    {
      FLAT4=50, CEIL5_1=50, FLOOR1_1=50, FLOOR3_3=50
    }

    ceilings =
    {
      FLAT4=50, CEIL5_1=50, CEIL3_5=50, CEIL3_3=50
    }
  }


  D1_Tech_cave =
  {
    naturals =
    {
      ASHWALL=50,
      SP_ROCK1=50,
      GRAYVINE=50,
      TEKWALL4=3,
    }
  }


  D1_Tech_outdoors =
  {
    floors =
    {
      BROWN144=30, BROWN1=20, STONE=20,
      ASHWALL=5, FLAT10=5,
    }

    naturals =
    {
      ASHWALL=50,
      SP_ROCK1=50,
      GRAYVINE=50,
      STONE=50,
    }
  }


  ----- Hell / Gothic -------------------------

  D1_Marble_room =
  {
    walls =
    {
      MARBLE1=25, MARBLE2=10, MARBLE3=20,
      GSTVINE2=20, SLADWALL=10,
      SKINMET1=3, SKINMET2=3,

      SKINTEK1=15, SKINTEK2=15,
    }

    floors =
    {
      DEM1_5=15, DEM1_6=15, FLAT5_7=10, FLAT10=10,
      FLOOR7_1=10, FLAT1=10, FLOOR5_2=10,
    }

    ceilings =
    {
      FLAT1=10, FLAT10=10, FLAT5_5=10, FLOOR7_2=10,
    }

    __corners =
    {
      SKULWALL=8, SKULWAL3=7,
    }
  }


  D1_Marble_outdoors =
  {
    floors =
    {
      ASHWALL=20,
      FLAT5_6=10, FLAT10=20,
      SFLR6_1=10, MFLR8_2=20,
    }

    naturals =
    {
      ASHWALL=50, GRAYVINE=50,
      SP_ROCK1=50, ROCKRED1=90,
      SKSNAKE1=10, SKSNAKE2=10,
    }
  }


  D1_Hot_room =
  {
    walls =
    {
      SP_HOT1=25, GSTVINE1=17, STONE=10, SKINMET2=5, BROWN1=2,
      SKINCUT=2,

      SKINTEK1=10, SKINTEK2=10,
    }

    floors =
    {
      FLAT5_7=10, FLAT10=10, FLAT5_3=10,
      FLOOR7_1=10, FLAT1=10, FLOOR5_2=10,
    }

    ceilings =
    {
      FLAT1=10, FLOOR6_1=10, FLAT10=10, FLAT8=10,
    }

    __corners =
    {
      SKULWALL=10, SKULWAL3=10, REDWALL1=15,
    }
  }


  D1_Hot_outdoors =
  {
    floors =
    {
      FLAT5_6=10, ASHWALL=5, FLAT10=5,
      SFLR6_4=10, MFLR8_2=10,
    }

    naturals =
    {
      ASHWALL=50, GRAYVINE=50,
      SP_ROCK1=50, ROCKRED1=90,
      SKSNAKE1=10, SKSNAKE2=10,
    }
  }


  D1_Hell_cave =
  {
    naturals =
    {
      ROCKRED1=90,
      SKIN2=50, SKINFACE=50, SKSNAKE1=35, SKSNAKE2=35,
      FIREBLU1=50, FIRELAVA=50, 
    }
  }


  ---- Episode 2 --------------------------

  Deimos_room =
  {
    walls =
    {
      STARTAN3=10, STARG2=15, BROVINE=20, ICKWALL1=15,
      STARBR2=15, STARGR2=10, STARG1=5, STARG2=3, ICKWALL3=30,
      SLADWALL=10, GRAY7=20, BROWN1=5, GRAY1=15, BROVINE2=15,
      BROWNGRN=10, BROWN96=5, METAL1=15, GRAY5=15, STONE=10,

      STONE2=30, STARTAN1=5, STONE3=20,
    }

    floors =
    {
      FLOOR0_1=30, FLOOR0_2=40, FLOOR0_3=30, CEIL4_1=5,
      FLOOR0_7=10, FLOOR3_3=20, FLOOR7_1=20, CEIL_4_2=10,
      FLOOR4_1=30, FLOOR4_6=20, FLOOR4_8=50, FLOOR5_2=35,
      FLAT1=40, FLAT5=30, FLAT14=10, FLAT1_1=30, FLOOR1_6=3,
      FLAT1_2=30, FLOOR5_1=50, FLAT3=15, FLAT5_4=15,
    }

    ceilings =
    {
      CEIL5_1=30, CEIL3_3=70, CEIL3_5=50, CEIL4_1=10,
      FLAT1=30, FLAT4=20, FLAT19=30, FLAT8=15, FLAT5_4=20,
      FLOOR0_2=20, FLOOR4_1=50, FLOOR5_1=50, FLOOR5_4=10,
    }

    __corners =
    {
      STARGR1=40, METAL1=20, ICKWALL3=6, TEKWALL1=20,
      TEKWALL4=6, COMPTALL=3, COMPBLUE=3, STARTAN1=7,

      COMPTILE=10,
    }
  }

  Deimos_hallway =
  {
    walls =
    {
      BROWN1=33, BROWNGRN=50, BROVINE=20,
      GRAY1=50, GRAY5=33, ICKWALL1=30, ICKWALL3=30,
      STONE2=40, STONE3=50, METAL1=30
    }

    floors =
    {
      FLAT4=30, CEIL5_1=30, FLAT14=20, FLAT5_4=20
      FLOOR3_3=30, FLOOR4_8=40, FLOOR5_1=25,
    }

    ceilings =
    {
      FLAT4=50, CEIL5_1=50, CEIL3_5=50, CEIL3_3=50, FLAT19=20
    }
  }

  Deimos_cave =
  {
    naturals =
    {
      SP_ROCK1=90,
      ASHWALL=20, BROWNHUG=15,
      GRAYVINE=15,
    }
  }

  Deimos_outdoors =
  {
--Makes sense for high prob for SP_ROCK1 because the intermission screen shows
--Deimos has a desolate, gray ground.
    floors = { BROWN144=20, BROWN1=10, STONE=10 }

    naturals = { SP_ROCK1=60, ASHWALL=2, FLAT10=3 }
  }


  ---- Episode 4 --------------------------

  Flesh_room =
  {
    walls =
    {
      MARBLE1=10, MARBLE2=10, MARBLE3=10, WOOD1=30,
      GSTVINE2=12, SLADWALL=10, GSTONE1=15, WOOD5=20,
      SKINMET1=3, SKINMET2=3, GSTVINE1=12, WOOD3=15, STONE2=3,

      SKINTEK1=10, SKINTEK2=10, BROWNGRN=7, BROVINE2=5, STONE3=3,
    }

    floors =
    {
      DEM1_5=10, DEM1_6=10, FLAT5_7=12, FLAT10=12,
      FLOOR7_1=10, FLAT1=12, FLOOR5_2=10, FLAT5_8=10,
      FLOOR5_4=10, FLOOR5_3=10, FLAT5=10, FLAT5_4=15,
      FLOOR7_2=10, FLAT5_1=15, FLAT5_2=15, FLAT8=10,
    }

    ceilings =
    {
      FLAT1=10, FLAT10=10, FLAT5_5=10, FLOOR7_2=6, DEM1_6=10,
      FLOOR6_1=10, FLOOR6_2=10, MFLR8_1=12, FLAT5_4=10, SFLR6_1=5,
      SFLR6_2=5, CEIL1_1=5, FLAT5_1=12, FLAT5_2=12, FLAT8=8,
    }

    __corners =
    {
      SKULWALL=8, SKULWAL3=7, SKSNAKE1=5, SKSNAKE2=5, ASHWALL=5, METAL=15
    }
  }

  Flesh_cave =
  {
    naturals =
    {
      ROCKRED1=70, SP_ROCK1=50, BROWNHUG=15,
      SKIN2=10, SKINFACE=20, SKSNAKE1=5, SKSNAKE2=5,
      FIREBLU1=10, FIRELAVA=10, 
    }
  }

  Flesh_outdoors =
  {
    floors =
    {
      ASHWALL=12, FLAT5_7=10, FLAT1_1=15, FLAT5_4=10,
      FLAT10=20, FLAT5_8=10, MFLR8_4=10, FLOOR7_1=15,
      SFLR6_1=8, MFLR8_2=5, FLAT1_2=10, MFLR8_3=10,
    }

    naturals =
    {
      ASHWALL=30, GRAYVINE=30, SP_ROCK2=15,
      SP_ROCK1=50, ROCKRED1=50, BROWNHUG=10,
      SKSNAKE1=10, SKSNAKE2=10,
    }
  }
}


DOOM1.LEVEL_THEMES =
{
  doom_tech1 =
  {
    prob = 60

    liquids = { nukage=90, water=15, lava=10 }

    buildings = { D1_Tech_room=50 }
    hallways  = { D1_Tech_hallway=50 }
    caves     = { D1_Tech_cave=50 }
    outdoors  = { D1_Tech_outdoors=50 }

    __logos = { carve=5, pill=50, neon=50 }

    __pictures =
    {
      shawn1=10, tekwall1=4, tekwall4=2,
      lite5=30, lite5_05blink=10, lite5_10blink=10,
      liteblu4=30, liteblu4_05sync=10, liteblu4_10sync=10,
      compsta1=40, compsta1_blink=4,
      compsta2=40, compsta2_blink=4,
      redwall=5,

---!!!   planet1=20,  planet1_blink=8,
      compute1=20, compute1_blink=3,
---!!!   compute2=15, compute2_blink=2,
      litered=10,
    }

    OLD__exits = { stone_pillar=50 }

    OLD__switches = { sw_blue=50, sw_hot=50 }

    bars = { bar_silver=50, bar_gray=50 }

    OLD__doors =
    {
      silver=20, silver_fast=33, silver_once=2,
      bigdoor2=5, bigdoor2_fast=8, bigdoor2_once=5,
      bigdoor4=5, bigdoor4_fast=8, bigdoor4_once=5,
      bigdoor3=5,
    }

    ceil_lights =
    {
      TLITE6_5=50, TLITE6_6=30, TLITE6_1=30, FLOOR1_7=30,
      FLAT2=20,    CEIL3_4=10,  FLAT22=10,
    }

    big_lights = { TLITE6_5=30, TLITE6_6=30, FLAT17=30, CEIL3_4=30 }

    pillars = { metal1=70, tekwall4=20 }
    big_pillars = { big_red=50, big_blue=50 }

    crates = { crate1=50, crate2=50, comp=70, lite5=20 }

    style_list =
    {
      naturals = { none=30, few=70, some=30, heaps=2 }
    }
  }


  -- Deimos theme by Mr. Chris

  doom_deimos1 =
  {
    prob = 50

    liquids = { nukage=60, water=10, blood=20 }

    buildings = { Deimos_room=50 }
    caves     = { Deimos_cave=50 }
    outdoors  = { Deimos_outdoors=50 }
    hallways  = { Deimos_hallway=50 }

    -- Best facades would be STONE/2/3, BROVINE/2, BROWN1 and maybe a few others as I have not seen many
    -- other textures on the episode 2 exterior.
    facades =
    {
      STONE2=50, STONE3=50, BROVINE=30, BROVINE2=30,
      BROWN1=50,  -- etc...
    }

    __logos = { carve=5, pill=50, neon=50 }

    __pictures =
    {
      shawn1=10, tekwall1=4, tekwall4=2,
      lite5=20, lite5_05blink=10, lite5_10blink=10,
      liteblu4=30, liteblu4_05sync=10, liteblu4_10sync=10,
      compsta1=30, compsta1_blink=15,
      compsta2=30, compsta2_blink=15,

---!!!   planet1=20,  planet1_blink=8,
      compute1=20, compute1_blink=15,
---!!!   compute2=15, compute2_blink=2,
      litered=10,
    }

    OLD__exits = { stone_pillar=50 }

    OLD__switches = { sw_blue=50, sw_hot=50 }

    bars = { bar_silver=50, bar_gray=50 }

    OLD__doors =
    {
      silver=20, silver_fast=33, silver_once=2,
      bigdoor2=5, bigdoor2_fast=8, bigdoor2_once=5,
      bigdoor4=5, bigdoor4_fast=8, bigdoor4_once=5,
      bigdoor3=5,
    }

    ceil_lights =
    {
      TLITE6_5=50, TLITE6_6=30, TLITE6_1=30, FLOOR1_7=30, CEIL1_3=5,
      FLAT2=20, CEIL3_4=10, FLAT22=10, FLAT17=20, CEIL1_2=7,
    }

    big_lights = { TLITE6_5=30, TLITE6_6=30, FLAT17=30, CEIL3_4=30 }

    pillars = { metal1=70, tekwall4=20 }
    big_pillars = { big_red=50, big_blue=50 }

    crates = { crate1=50, crate2=50, comp=70, lite5=20 }

    style_list =
    {
      naturals = { none=40, few=70, some=20, heaps=2 }
    }
  }


  -- this is the greeny/browny/marbley Hell

  doom_hell1 =
  {
    prob = 40,

    liquids = { lava=30, blood=90, nukage=5 }

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 }

    buildings = { D1_Marble_room=50 }
    outdoors  = { D1_Marble_outdoors=50 }
    caves     = { D1_Hell_cave=50 }


    FIXME_switch_doors = { Door_pink = 50, Door_vine = 50 }

    __logos = { carve=90, pill=50, neon=5 }

    __pictures =
    {
      marbface=10, skinface=10, firewall=20,
      spdude1=4, spdude2=4, spdude5=3, spine=2,

      skulls1=10, skulls2=10, spdude3=3, spdude6=3,
    }

    OLD__exits = { skin_pillar=40,
              demon_pillar2=10, demon_pillar3=10 }

    OLD__switches = { sw_marble=50, sw_vine=50, sw_wood=50 }

    bars = { bar_wood=50, bar_metal=50 }

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10 }

    monster_prefs = { zombie=0.3, shooter=0.6, skull=2.0 }
  }


  -- this is the reddy/skinny/firey Hell

  doom_hell2 =
  {
    prob = 25,

    liquids = { lava=90, blood=40 }

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 }

    buildings = { D1_Hot_room=50 }
    outdoors  = { D1_Hot_outdoors=50 }
    caves     = { D1_Hell_cave=50 }


    __logos = { carve=90, pill=50, neon=5 }

    __pictures =
    {
      marbfac2=10, marbfac3=10,
      spface1=2, firewall=20,
      spine=5,

      skulls1=20, skulls2=20,
    }

    OLD__exits = { skin_pillar=40,
              demon_pillar2=10, demon_pillar3=10 }

    OLD__switches = { sw_skin=50, sw_vine=50, sw_wood=50 }

    bars = { bar_wood=50, bar_metal=50 }

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10 }

    monster_prefs = { zombie=0.3, shooter=0.6, skull=2.0 }
  }


  -- Thy Flesh Consumed by Mr. Chris
  -- Basically a modified version of doom_hell1 to match id's E4 better

  doom_flesh1 =
  {
    prob = 40,

    liquids = { lava=30, blood=50, nukage=10, water=20 }

    buildings = { Flesh_room=50 }
    caves     = { Flesh_cave=50 }
    outdoors  = { Flesh_outdoors=50 }

    __logos = { carve=90, pill=50, neon=5 }

    __pictures =
    {
      marbface=10, skinface=10, firewall=10,
      spdude1=5, spdude2=5, spdude5=5, spine=2,

      skulls1=8, skulls2=8, spdude3=3, spdude6=3,
    }

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 }

    __exits = { skin_pillar=30, demon_pillar2=10 }

    __switches = { sw_marble=50, sw_vine=50, sw_wood=50 }

    __bars = { bar_wood=50, bar_metal=50 }

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10, MARBLE3=10, BROWNHUG=20 }

    __crates = { crate1=0, crate2=0, comp=0, lite5=0, wood=50, ick=15, }

    monster_prefs =
    {
      zombie=0.6, shooter=0.8, skull=1.2,
      demon=2.0, spectre=1.2,
      imp=2.0, baron=1.5, caco=0.8
    }
  }
}



DOOM1.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=40, file="doom1_boss/anomaly1.wad", map="E1M8" }
    { prob=80, file="doom1_boss/anomaly2.wad", map="E1M8" }
  }

  E2M8 =
  {
    { prob=50, file="doom1_boss/tower1.wad", map="E2M8" }
  }

  E3M8 =
  {
    { prob=50, file="doom1_boss/dis1.wad", map="E3M8" }
  }

  E4M6 =
  {
    { prob=50, file="doom1_boss/tower1.wad", map="E2M8" }
  }

  E4M8 =
  {
    { prob=50, file="doom1_boss/dis1.wad", map="E3M8" }
  }
}



DOOM1.SECRET_EXITS =
{
  E1M3 = true
  E2M5 = true
  E3M6 = true
  E4M2 = true
}


DOOM1.EPISODES =
{
  episode1 =
  {
    sky_light = 0.85
  }

  episode2 =
  {
    sky_light = 0.65
  }

  episode3 =
  {
    sky_light = 0.75
  }

  episode4 =
  {
    sky_light = 0.75
  }
}


DOOM1.ORIGINAL_THEMES =
{
  "doom_tech"
  "doom_deimos"
  "doom_hell"
  "doom_flesh"
}


------------------------------------------------------------

function DOOM1.setup()
  -- remove Doom II only stuff
  GAME.WEAPONS["super"] = nil
  GAME.PICKUPS["mega"]  = nil

  -- tweak monster probabilities
  GAME.MONSTERS["Cyberdemon"].crazy_prob = 8
  GAME.MONSTERS["Mastermind"].crazy_prob = 12
end


function DOOM1.get_levels()
  local EP_MAX  = (OB_CONFIG.game   == "ultdoom" ? 4 ; 3)
  local EP_NUM  = (OB_CONFIG.length == "full"    ? EP_MAX ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single"  ? 1 ; 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  -- this accounts for last two levels are BOSS and SECRET level
  local LEV_MAX = MAP_NUM
  if LEV_MAX == 9 then LEV_MAX = 7 end

  for ep_index = 1,EP_NUM do
    -- create episode info...
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = DOOM1.EPISODES["episode" .. ep_index]
    assert(ep_info)

    for map = 1,MAP_NUM do
      local ep_along = map / LEV_MAX

      if MAP_NUM == 1 then
        ep_along = rand.range(0.3, 0.7);
      elseif map == 9 then
        ep_along = 0.5
      end

      -- create level info...
      local LEV =
      {
        episode = EPI

        name  = string.format("E%dM%d",   ep_index,   map)
        patch = string.format("WILV%d%d", ep_index-1, map-1)

         ep_along = ep_along
        mon_along = ep_along + (ep_index-1) / 5

        sky_light   = ep_info.sky_light
        secret_kind = (map == 9) and "plain"
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

      -- prebuilt levels
      LEV.prebuilt = GAME.PREBUILT_LEVELS[LEV.name]

      if LEV.prebuilt then
        LEV.name_theme = LEV.prebuilt.name_theme or "BOSS"
      end

      if MAP_NUM == 1 or map == 3 then
        LEV.demo_lump = string.format("DEMO%d", ep_index)
      end
    end -- for map

  end -- for episode
end


function DOOM1.end_level()
  if LEVEL.description and LEVEL.patch then
    DOOM.make_level_gfx()
  end
end


function DOOM1.all_done()
  DOOM.make_cool_gfx()

  gui.wad_merge_sections("doom_falls.wad");
end


------------------------------------------------------------

OB_GAMES["doom1"] =
{
  label = "Doom"

  priority = 98  -- keep at second spot

  format = "doom"

  tables =
  {
    DOOM, DOOM1
  }

  hooks =
  {
    setup        = DOOM1.setup
    get_levels   = DOOM1.get_levels
    end_level    = DOOM1.end_level
    all_done     = DOOM1.all_done
  }
}


OB_GAMES["ultdoom"] =
{
  label = "Ultimate Doom"

  extends = "doom1"

  priority = 97  -- keep at third spot
  
  -- no additional tables

  -- no additional hooks
}


------------------------------------------------------------

OB_THEMES["doom_deimos"] =
{
  label = "Deimos"
  priority = 6
  for_games = { doom1=1 }
  name_theme = "TECH"
  mixed_prob = 30
}


OB_THEMES["doom_flesh"] =
{
  label = "Thy Flesh"
  priority = 2
  for_games = { ultdoom=1 }
  name_theme = "GOTHIC"
  mixed_prob = 20
}

