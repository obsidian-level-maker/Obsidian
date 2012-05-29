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

  ASHWALL  = { t="ASHWALL",  f="FLOOR6_2", color=0x242424 }
  BROVINE  = { t="BROVINE",  f="FLOOR0_1", color=0x434824 }
  BRNPOIS2 = { t="BRNPOIS2", f="FLOOR7_1", color=0x3d3119 }
  BROWNWEL = { t="BROWNWEL", f="FLOOR7_1", color=0x3b2d15 }

  COMP2    = { t="COMP2",    f="CEIL5_1",  color=0x21201c }
  COMPOHSO = { t="COMPOHSO", f="FLOOR7_1", color=0x1e1821 }
  COMPTILE = { t="COMPTILE", f="CEIL5_1",  color=0x101034 }
  COMPUTE1 = { t="COMPUTE1", f="FLAT19",   color=0x605f60 }
  COMPUTE2 = { t="COMPUTE2", f="CEIL5_1",  color=0x20201c }
  COMPUTE3 = { t="COMPUTE3", f="CEIL5_1",  color=0x493521 }

  DOORHI   = { t="DOORHI",   f="FLAT19", color=0x7c7066 }
  GRAYDANG = { t="GRAYDANG", f="FLAT19", color=0x6f6666 }
  ICKDOOR1 = { t="ICKDOOR1", f="FLAT19", color=0x6d6f63 }
  ICKWALL6 = { t="ICKWALL6", f="FLAT18", color=0x60615b }

  LITE2    = { t="LITE2",    f="FLOOR0_1" }
  LITE4    = { t="LITE4",    f="FLAT19" }
  LITE96   = { t="LITE96",   f="FLOOR7_1" }
  LITEBLU2 = { t="LITEBLU2", f="FLAT23" }
  LITEBLU3 = { t="LITEBLU3", f="FLAT23" }
  LITEMET  = { t="LITEMET",  f="FLOOR4_8" }
  LITERED  = { t="LITERED",  f="FLOOR1_6" }
  LITESTON = { t="LITESTON", f="MFLR8_1" }

  NUKESLAD = { t="NUKESLAD", f="FLOOR7_1", color=0x2a2e22 }
  PLANET1  = { t="PLANET1",  f="FLAT23",   color=0x423b38 }
  REDWALL1 = { t="REDWALL1", f="FLOOR1_6", color=0xc50000 }
  SKINBORD = { t="SKINBORD", f="FLAT5_5",  color=0x8f5c4d }
  SKINTEK1 = { t="SKINTEK1", f="FLAT5_5",  color=0x604937 }
  SKINTEK2 = { t="SKINTEK2", f="FLAT5_5",  color=0x514130 }
  SKULWAL3 = { t="SKULWAL3", f="FLAT5_6",  color=0x4e311d }
  SKULWALL = { t="SKULWALL", f="FLAT5_6",  color=0x4e3d2b }
  SLADRIP1 = { t="SLADRIP1", f="FLOOR7_1" }

  SP_DUDE3 = { t="SP_DUDE3", f="DEM1_5",   color=0x464631 }
  SP_DUDE6 = { t="SP_DUDE6", f="DEM1_5",   color=0x4b4731 }
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3",  color=0x4c4b42 }
  STARTAN1 = { t="STARTAN1", f="FLOOR4_1", color=0x6a543f }
  STONGARG = { t="STONGARG", f="MFLR8_1",  color=0x33352d }
  STONPOIS = { t="STONPOIS", f="FLAT5_4",  color=0x59554d }
  TEKWALL2 = { t="TEKWALL2", f="CEIL5_1",  color=0x37342a }
  TEKWALL3 = { t="TEKWALL3", f="CEIL5_1",  color=0x323128 }
  TEKWALL5 = { t="TEKWALL5", f="CEIL5_1",  color=0x35322a }
  WOODSKUL = { t="WOODSKUL", f="FLAT5_2",  color=0x4f3b25 }


  -- switches --

  SW1BRN1  = { t="SW1BRN1",  f="FLOOR0_1" }
  SW1STARG = { t="SW1STARG", f="FLAT23" }
  SW1STONE = { t="SW1STONE", f="FLAT1" }
  SW1STON2 = { t="SW1STON2", f="MFLR8_1" }


  -- floors --

  FLAT5_6  = { f="FLAT5_6", t="SKULWALL", color=0x553c20 }
  FLAT5_7  = { f="FLAT5_7", t="ASHWALL",  color=0x353535 }
  FLAT5_8  = { f="FLAT5_8", t="ASHWALL",  color=0x2c2c2c }
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL", color=0x292929 }
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL", color=0x292929 }


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

    pictures =
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

    pictures =
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
      local pb_name = LEV.name

      if LEV.name == "E4M6" then pb_name = "E2M8" end
      if LEV.name == "E4M8" then pb_name = "E3M8" end

      LEV.prebuilt = GAME.PREBUILT_LEVELS[pb_name]

      if LEV.prebuilt then
        LEV.name_theme = LEV.prebuilt.name_theme or "BOSS"
      end

      if MAP_NUM == 1 or map == 3 then
        LEV.demo_lump = string.format("DEMO%d", ep_index)
      end
    end -- for map

  end -- for episode
end


------------------------------------------------------------

UNFINISHED["doom1"] =
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

    end_level    = DOOM.end_level
    all_done     = DOOM.all_done
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


------------------------------------------------------------

UNFINISHED["doom_deimos"] =
{
  label = "Deimos"
  priority = 6
  for_games = { doom1=1 }
  name_theme = "TECH"
  mixed_prob = 30
}


UNFINISHED["doom_flesh"] =
{
  label = "Thy Flesh"
  priority = 2
  for_games = { ultdoom=1 }
  name_theme = "GOTHIC"
  mixed_prob = 20
}

