--------------------------------------------------------------------
--  DOOM LEVELS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2014 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM2.SECRET_EXITS =
{
  MAP15 = true
  MAP31 = true
}


DOOM2.EPISODES =
{
  episode1 =
  {
    ep_index = 1

    theme = "tech"
    sky_patch = "RSKY1"
    dark_prob = 10
  }

  episode2 =
  {
    ep_index = 2

    theme = "urban"
    sky_patch = "RSKY2"
    dark_prob = 40
  }

  episode3 =
  {
    ep_index = 3

    theme = "hell"
    sky_patch = "RSKY3"
    dark_prob = 10
  }
}


DOOM2.PREBUILT_LEVELS =
{
  MAP07 =
  {
    { prob=50, file="doom2_boss/simple1.wad", map="MAP07" }
    { prob=50, file="doom2_boss/simple2.wad", map="MAP07" }
    { prob=50, file="doom2_boss/simple3.wad", map="MAP07" }
    { prob=50, file="doom2_boss/simple4.wad", map="MAP07" }
  }

  MAP30 =
  {
    { prob=50, file="doom2_boss/icon1.wad", map="MAP30" }
    { prob=50, file="doom2_boss/icon2.wad", map="MAP30" }
    { prob=50, file="doom2_boss/icon3.wad", map="MAP01" }
    { prob=50, file="doom2_boss/icon3.wad", map="MAP02" }
    { prob=50, file="doom2_boss/icon3.wad", map="MAP03" }
  }

  GOTCHA =
  {
    { prob=50, file="doom2_boss/gotcha1.wad", map="MAP01" }
    { prob=50, file="doom2_boss/gotcha2.wad", map="MAP01" }
    { prob=40, file="doom2_boss/gotcha3.wad", map="MAP01" }
    { prob=20, file="doom2_boss/gotcha4.wad", map="MAP01" }
  }

  GALLOW =
  {
    { prob=50, file="doom2_boss/gallow1.wad", map="MAP01" }
    { prob=25, file="doom2_boss/gallow2.wad", map="MAP01" }
  }
}


--------------------------------------------------------------------


function DOOM2.get_levels()
  local MAP_LEN_TAB = { few=4, episode=11, game=32 }

  local MAP_NUM = MAP_LEN_TAB[OB_CONFIG.length] or 1

  gotcha_map = rand.pick{17,18,19}
  gallow_map = rand.pick{24,25,26}

  local EP_NUM = 1
  if MAP_NUM > 11 then EP_NUM = 2 end
  if MAP_NUM > 30 then EP_NUM = 3 end

  -- create episode info...

  for ep_index = 1,3 do
    local ep_info = GAME.EPISODES["episode" .. ep_index]
    assert(ep_info)

    local EPI = table.copy(ep_info)

    EPI.levels = { }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  for map = 1,MAP_NUM do
    -- determine episode from map number
    local ep_index
    local ep_along

    if map > 30 then
      ep_index = 3 ; ep_along = 0.35
    elseif map > 20 then
      ep_index = 3 ; ep_along = (map - 20) / 10
    elseif map > 11 then
      ep_index = 2 ; ep_along = (map - 11) / 9
    else
      ep_index = 1 ; ep_along = map / 11
    end

    if OB_CONFIG.length == "single" then
      ep_along = rand.pick{ 0.2, 0.3, 0.4, 0.6, 0.8 }
    elseif OB_CONFIG.length == "few" then
      ep_along = map / MAP_NUM
    end

    assert(ep_along <= 1)

    local EPI = GAME.episodes[ep_index]
    assert(EPI)

    local LEV =
    {
      episode = EPI

      name  = string.format("MAP%02d", map)
      patch = string.format("CWILV%02d", map-1)

      ep_along = ep_along
    }

    table.insert( EPI.levels, LEV)
    table.insert(GAME.levels, LEV)

    LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

    if OB_CONFIG.length == "single" then
      LEV.mon_along = ep_along
    else
      -- difficulty ramps up over whole wad
      LEV.mon_along = map * 1.4 / math.min(MAP_NUM, 20)
    end

    -- secret levels
    if map == 31 or map == 32 then
      LEV.theme_name = "wolf"
      LEV.name_class = "URBAN"
      LEV.is_secret = true
      -- secret levels are easy
      LEV.mon_along = 0.35
    end

    if map == 23 then
      LEV.style_list = { barrels = { heaps=100 } }
    end

    -- prebuilt levels
    local pb_name = LEV.name

    if map == gotcha_map then pb_name = "GOTCHA" end
    if map == gallow_map then pb_name = "GALLOW" end
    
    LEV.prebuilt = GAME.PREBUILT_LEVELS[pb_name]

    if LEV.prebuilt then
      LEV.name_class = LEV.prebuilt.name_class or "BOSS"
    end

    if MAP_NUM == 1 or (map % 10) == 3 then
      LEV.demo_lump = string.format("DEMO%d", ep_index)
    end
  end
end


--------------------------------------------------------------------
--  DOOM 1 / Ultimate Doom
--------------------------------------------------------------------


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


DOOM1.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=50,  file="doom1_boss/anomaly1.wad", map="E1M8" }
    { prob=50,  file="doom1_boss/anomaly2.wad", map="E1M8" }
    { prob=100, file="doom1_boss/anomaly3.wad", map="E1M8" }
    { prob=200, file="doom1_boss/ult_anomaly.wad", map="E1M8" }
  }

  E2M8 =
  {
    { prob=40,  file="doom1_boss/tower1.wad", map="E2M8" }
    { prob=60,  file="doom1_boss/tower2.wad", map="E2M8" }
    { prob=100, file="doom1_boss/ult_tower.wad", map="E2M8" }
  }

  E3M8 =
  {
    { prob=50,  file="doom1_boss/dis1.wad", map="E3M8" }
    { prob=100, file="doom1_boss/ult_dis.wad", map="E3M8" }
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


function DOOM1.get_levels()
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
        mon_along = ep_along + (ep_index-1) / math.max(3, EP_NUM)

        secret_kind = (map == 9) and "plain"
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


--------------------------------------------------------------------
--  Final DOOM (etc)
--------------------------------------------------------------------


TNT.EPISODES =
{
  episode1 =
  {
    theme = "tech"
    sky_patch  = "DOEDAY"
    sky_patch2 = "DONDAY"
    sky_patch3 = "DOWDAY"
    sky_patch4 = "DOSDAY"
    dark_prob = 10
  }

  episode2 =
  {
    theme = "urban"
    sky_patch  = "DOENITE"
    sky_patch2 = "DONNITE"
    sky_patch3 = "DOWNITE"
    sky_patch4 = "DOSNITE"
    dark_prob = 80
  }

  episode3 =
  {
    theme = "hell"
    sky_patch  = "DOEHELL"
    sky_patch2 = "DONHELL"
    sky_patch3 = "DOWHELL"
    sky_patch4 = "DOSHELL"
    dark_prob = 10
  }
}


PLUTONIA.EPISODES =
{
  episode1 =
  {
    theme = "tech"
    sky_patch  = "SKY1"
    dark_prob = 10
  }

  episode2 =
  {
    theme = "urban"
    sky_patch  = "SKY2A"
    sky_patch2 = "SKY2B"
    sky_patch3 = "SKY2C"
    sky_patch4 = "SKY2D"
    dark_prob = 10
  }

  episode3 =
  {
    theme = "hell"
    sky_patch  = "SKY3A"
    sky_patch2 = "SKY3B"
    dark_prob = 40
  }
}

