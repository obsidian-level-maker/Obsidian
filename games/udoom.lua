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


DOOM1.THEME_DEFAULTS =
{
  big_junctions =
  {
    Junc_Octo = 70
    Junc_Spokey = 10
  }
}




DOOM1.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=50, file="doom1_boss/anomaly1.wad", map="E1M8" }
    { prob=50, file="doom1_boss/anomaly2.wad", map="E1M8" }
  }

  E2M8 =
  {
    { prob=40, file="doom1_boss/tower1.wad", map="E2M8" }
    { prob=80, file="doom1_boss/tower2.wad", map="E2M8" }
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
    end_level    = DOOM1.end_level
    all_done     = DOOM1.all_done
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

