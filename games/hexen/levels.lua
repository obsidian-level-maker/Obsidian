------------------------------------------------------------------------
--  HEXEN LEVELS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HEXEN.EPISODES =
{
  episode1 =
  {
    theme = "ELEMENTAL"
    sky_light = 0.65
  }

  episode2 =
  {
    theme = "WILDERNESS"
    sky_light = 0.75
  }

  episode3 =
  {
    theme = "DUNGEON"
    sky_light = 0.65
  }

  episode4 =
  {
    theme = "DUNGEON"
    sky_light = 0.60
  }

  episode5 =
  {
    theme = "DUNGEON"
    sky_light = 0.50
  }
}


HEXEN.THEME_FOR_MAP =
{
  [1]  = "hexen_wild4"
  [2]  = "hexen_dungeon5"
  [3]  = "hexen_element2"
  [4]  = "hexen_element1"
  [5]  = "hexen_element3"
  [8]  = "hexen_wild4"
  [9]  = "hexen_wild3"
  [10] = "hexen_wild2"
  [11] = "hexen_wild1"
  [14] = "hexen_dungeon6"
  [15] = "hexen_dungeon1"
  [16] = "hexen_dungeon1"
  [17] = "hexen_wild4"
  [18] = "hexen_dungeon1"
  [19] = "hexen_dungeon1"
  [20] = "hexen_dungeon1"
  [21] = "hexen_dungeon1"
  [22] = "hexen_dungeon2"
  [23] = "hexen_dungeon2"
  [24] = "hexen_dungeon1"
  [25] = "hexen_dungeon4"
  [26] = "hexen_dungeon2"
  [27] = "hexen_dungeon2"
  [28] = "hexen_dungeon2"
  [29] = "hexen_dungeon3"
  [30] = "hexen_dungeon3"
  [31] = "hexen_dungeon3"
  [32] = "hexen_dungeon3"
  [35] = "hexen_dungeon2"
}


HEXEN.PREBUILT_LEVELS =
{
}


function HEXEN.get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "game",   5, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 7)

--??  GAME.original_themes = {}

  for ep_index = 1,EP_NUM do
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = HEXEN.EPISODES["episode" .. ep_index]
    assert(ep_info)

--??    GAME.original_themes[episode] = ep_info.orig_theme

    for map = 1,MAP_NUM do
      local map_id = (ep_index - 1) * MAP_NUM + map

      local ep_along = map / MAP_NUM

      if MAP_NUM == 1 then
        ep_along = rand.range(0.3, 0.7)
      end

      local LEV =
      {
        episode = EPI

        name  = string.format("MAP%02d", map_id)
--??    patch = string.format("WILV%d%d", ep_index-1, map-1)

        map       = map_id
        next_map  = map_id + 1
        local_map = map

        cluster  = ep_index

          ep_along = ep_along
        game_along = (ep_index - 1 + ep_along) / EP_NUM

        sky_light = ep_info.sky_light

        name_theme = "GOTHIC"
      }

      -- make certain levels match original
	  -- Was not working, so fixed above, BlackJar72
      if OB_CONFIG.theme == "original" then
        if ep_index == 3 then
          LEV.theme_name = "hexen_dungeon1"
        elseif ep_index == 4 then
          LEV.theme_name = "hexen_dungeon2"
        elseif ep_index == 5 then
          LEV.theme_name = "hexen_dungeon3"
        end -- Specific special levels

        LEV.theme_name = HEXEN.THEME_FOR_MAP[map_id]

        if LEV.theme_name then
           LEV.theme = assert(GAME.LEVEL_THEMES[LEV.theme_name])
        end

        if map_id == 29 then
          LEV.style_list =
          {
            outdoors = { heaps=100 }
            caves = { some=50, heaps=50 }
          }
        end
      end

      -- second last map in each episode is a secret level, and
      -- last map in each episode is the boss map.

      if map == 6 then
        LEV.kind = "SECRET"
      elseif map == 7 then
        LEV.kind = "BOSS"
      end

      -- very last map of the game?
      if ep_index == 5 and map == 7 then
        LEV.next_map = nil
      end

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)
    end

    -- link hub together (unless only making a single level)

    if MAP_NUM > 1 then
      Hub_connect_levels(EPI, GAME.THEME_DEFAULTS.hub_keys)

      Hub_assign_keys(EPI, GAME.THEME_DEFAULTS.keys)
      Hub_assign_weapons(EPI)
      Hub_assign_pieces(EPI, { "piece1", "piece2", "piece3" })
    end

  end -- for episode

end


function HEXEN.make_mapinfo()
  local mapinfo = {}

  local function add(...)
    table.insert(mapinfo, string.format(...) .. "\n")
  end

  each L in GAME.levels do
    local desc = string.upper(L.description or L.name)

    add("map %d \"%s\"", L.map, desc)
    add("warptrans %d", L.map)
    add("next %d", L.next_map or 1)
    add("cluster %d", L.cluster)
    add("sky1 SKY2 0")
    add("sky2 SKY3 0")
    add("")
  end

  gui.wad_add_text_lump("MAPINFO", mapinfo)
end

