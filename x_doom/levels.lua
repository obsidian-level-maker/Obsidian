--------------------------------------------------------------------
--  DOOM LEVELS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2013 Andrew Apted
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
    sky_light = 0.75
  }

  episode2 =
  {
    sky_light = 0.50
  }

  episode3 =
  {
    sky_light = 0.75
  }
}


DOOM2.ORIGINAL_THEMES =
{
  "doom_tech"
  "doom_urban"
  "doom_hell"
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
    { prob=30, file="doom2_boss/icon1.wad", map="MAP30" }
    { prob=50, file="doom2_boss/icon2.wad", map="MAP30" }
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

  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

  gotcha_map = rand.pick{17,18,19}
  gallow_map = rand.pick{24,25,26}

  local EP_NUM = 1
  if MAP_NUM > 11 then EP_NUM = 2 end
  if MAP_NUM > 30 then EP_NUM = 3 end

  -- create episode info...

  for ep_index = 1,EP_NUM do
    local EPI =
    {
      levels = {}
    }

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

    local EPI = GAME.episodes[ep_index]
    assert(EPI)

    local ep_info = DOOM2.EPISODES["episode" .. ep_index]
    assert(ep_info)
    assert(ep_along <= 1)

    local LEV =
    {
      episode = EPI

      name  = string.format("MAP%02d", map)
      patch = string.format("CWILV%02d", map-1)

      ep_along = ep_along

      sky_light = ep_info.sky_light
    }

    table.insert( EPI.levels, LEV)
    table.insert(GAME.levels, LEV)

    LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

    if map == 31 or map == 32 then
      -- secret levels are easy
      LEV.mon_along = 0.35
    elseif OB_CONFIG.length == "single" then
      LEV.mon_along = ep_along
    else
      -- difficulty ramps up over whole wad
      LEV.mon_along = map * 1.4 / math.min(MAP_NUM, 20)
    end

    -- secret levels
    if map == 31 or map == 32 then
      LEV.theme_name = "doom_wolf1"
      LEV.theme = GAME.LEVEL_THEMES[LEV.theme_name]

      LEV.name_theme = "URBAN"
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
      LEV.name_theme = LEV.prebuilt.name_theme or "BOSS"
    end

    if MAP_NUM == 1 or (map % 10) == 3 then
      LEV.demo_lump = string.format("DEMO%d", ep_index)
    end
  end
end

