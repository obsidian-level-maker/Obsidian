----------------------------------------------------------------
--  MODULE: sky generator
----------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Andrew Apted
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

SKY_GEN = { }


SKY_GEN.colormaps =
{
  -- star colors --

  STARS =
  {
    8, 7, 6, 5,
    111, 109, 107, 104, 101,
    98, 95, 91, 87, 83, 4
  }

  -- cloud colors --

  GREY_CLOUDS =
  {
    106, 104, 102, 100,
    98, 96, 94, 92, 90,
    88, 86, 84, 82, 80
  }

  DARK_CLOUDS =
  {
    7, 6, 5,
    110, 109, 108, 107, 106,
    105, 104, 103, 102, 101
  }

  BLUE_CLOUDS =
  {
    245, 245, 244, 244, 243, 242, 241,
    240, 206, 205, 204, 204, 203, 203
  }

  HELL_CLOUDS =
  {
    188, 185, 184, 183, 182, 181, 180,
    179, 178, 177, 176, 175, 174, 173
  }

  ORANGE_CLOUDS =
  {
    234, 232, 222, 220, 218, 216, 214, 211
  }

  HELLISH_CLOUDS =
  {
    0, 0, 0, 0, 0, 47, 191, 190, 191, 47, 0, 0
  }

  BROWN_CLOUDS =
  {
     2, 1,
     79, 78, 77, 76, 75, 74, 73,
     72, 71, 70, 69, 67, 66, 65
  }

  BROWNISH_CLOUDS =
  {
    239, 238, 237, 236, 143, 142, 141,
    140, 139, 138, 137, 136, 135, 134,
    133, 130, 129, 128
  }

  YELLOW_CLOUDS =
  {
    167, 166, 165, 164, 163, 162,
    161, 160, 228, 227, 225
  }

  GREEN_CLOUDS =
  {
    127, 126, 125, 124, 123, 122, 121,
    120, 119, 118, 117, 115, 113, 112
  }

  JADE_CLOUDS =
  {
    12, 11, 10, 9,
    159, 158, 157, 156, 155, 154, 153, 152
  }

  DARKRED_CLOUDS =
  {
     47, 46, 45, 44, 43, 42, 41, 40, 39, 37, 36, 34
  }

  PEACH_CLOUDS =
  {
     68, 66, 64, 62, 60, 58, 57
  }

  WHITE_CLOUDS =
  {
     99, 98, 97, 96, 95, 94, 93,
     92, 91, 90, 89, 88, 87, 86,
     85, 84, 83, 81
  }

  SKY_CLOUDS =
  {
    194, 195, 196, 197, 199, 201
  }

  PURPLE_CLOUDS =
  {
    254, 253, 252, 251, 250, 251, 252, 253, 254
  }

  RAINBOW_CLOUDS =
  {
    191, 186, 181, 176,
    231, 161, 164, 167,
    242, 207, 204, 199,
    115, 119, 123, 127
  }

  BLACK_N_WHITE =
  {
    0, 4, 0, 4, 0, 4, 0, 4
  }

  -- hill colors --

  BLACK_HILLS =
  {
    0, 0, 0
  }

  BROWN_HILLS =
  {
    0, 2, 1, 79, 77, 75, 73, 70, 67, 64
  }

  TAN_HILLS =
  {
    239, 237, 143, 140, 136, 132, 128
  }

  GREEN_HILLS =
  {
    0, 7,
    127, 126, 125, 124, 123,
    122, 120, 118, 116, 113
  }

  DARKGREEN_HILLS =
  {
    0, 7, 127, 126, 125, 124
  }

  HELL_HILLS =
  {
    0, 6, 47, 45, 43, 41, 39, 37, 35, 33
  }

  DARKBROWN_HILLS =
  {
    8, 7, 2, 1, 79, 78, 77, 76, 75
  }

  GREENISH_HILLS =
  {
    0, 7, 12, 11, 10, 9, 15, 14, 13,
    159, 158, 157, 156, 155, 154
  }
}


SKY_GEN.themes =
{
  urban =
  {
    clouds =
    {
      SKY_CLOUDS = 150
      BLUE_CLOUDS = 80
      WHITE_CLOUDS = 80
      GREY_CLOUDS = 80
      DARK_CLOUDS = 50

      BROWN_CLOUDS = 40
      BROWNISH_CLOUDS = 40
      PEACH_CLOUDS = 40
      GREEN_CLOUDS = 20
      JADE_CLOUDS = 20
    }

    hills =
    {
      TAN_HILLS = 30
      BROWN_HILLS = 50
      DARKBROWN_HILLS = 50
      GREENISH_HILLS = 30
      BLACK_HILLS = 5
    }

    dark_hills =
    {
      DARKGREEN_HILLS = 50
      DARKBROWN_HILLS = 50
    }
  }


  hell =
  {
    clouds =
    {
      HELL_CLOUDS = 70
      HELLISH_CLOUDS = 70
      DARKRED_CLOUDS = 50
      YELLOW_CLOUDS = 30
      ORANGE_CLOUDS = 30
    }

    hills =
    {
      HELL_HILLS = 50
      BROWN_HILLS = 50
      DARKBROWN_HILLS = 50
      BLACK_HILLS = 50
    }

    dark_hills =
    {
      HELL_HILLS = 50
      DARKBROWN_HILLS = 20
    }
  }


  psycho =
  {
    clouds =
    {
      PURPLE_CLOUDS  = 90
      YELLOW_CLOUDS  = 70
      HELLISH_CLOUDS = 20
      RAINBOW_CLOUDS = 10

      GREEN_CLOUDS = 70
      BLUE_CLOUDS  = 70
      WHITE_CLOUDS = 30
      GREY_CLOUDS  = 30
    }

    hills =
    {
      BLUE_CLOUDS = 50
      GREEN_HILLS = 50
      RAINBOW_CLOUDS = 50
      PURPLE_CLOUDS = 30
      YELLOW_CLOUDS = 30
      ORANGE_CLOUDS = 30
      WHITE_CLOUDS = 30
      HELLISH_CLOUDS = 20
    }

    -- no dark_hills
  }
}


function SKY_GEN.generate_skies()

  -- select episode for the starry starry night
  local starry_ep = rand.irange(1, # GAME.episodes)

  if rand.odds(37) then
    starry_ep = -7
  end

  -- determine themes for each episode
  local theme_list = { "urban", "urban", "hell", "hell" }

  -- when user has picked a specific theme, honor it
  if OB_CONFIG.theme == "hell" then
    theme_list[1] = "hell"
    theme_list[2] = "hell"
  elseif OB_CONFIG.theme == "urban" then
    theme_list[3] = "urban"
    theme_list[4] = "urban"
  elseif OB_CONFIG.theme == "tech" then
    theme_list[3] = "urban"
  end

  rand.shuffle(theme_list)

  -- copy all theme tables [so we can safely modify them]
  local all_themes = table.deep_copy(SKY_GEN.themes)


  gui.printf("\nSky generator:\n");

  each EPI in GAME.episodes do
    assert(EPI.sky_patch)
    assert(_index <= #theme_list)

    local seed = int(gui.random() * 1000000)

    local squish = rand.index_by_probs({ 1, 4, 2 })

    local is_starry = (_index == starry_ep)


    local theme_name = theme_list[_index]

    if OB_CONFIG.theme == "original" then
      if EPI.theme == "hell" or EPI.theme == "flesh" then
        theme_name = "hell"
      else
        theme_name = "urban"
      end

    elseif OB_CONFIG.theme == "psycho" then
      theme_name = "psycho"
    end

    local theme = all_themes[theme_name]

    assert(theme)
    assert(theme.clouds)
    assert(theme.hills)

    local hill_tab = theme.hills


    gui.fsky_create(256, 128, 0)

    if is_starry then

      --- Stars ---

      local name = "STARS"

      local colormap = SKY_GEN.colormaps[name]
      if not colormap then
        error("SKY_GEN: unknown colormap: " .. tostring(name))
      end

      gui.printf("  %d = %s\n", _index, name)

      gui.set_colormap(1, colormap)
      gui.fsky_add_stars({ seed=seed, colmap=1 })

      if theme.dark_hills then
        hill_tab = theme.dark_hills
      end

      EPI.dark_prob = 100  -- always, for flyingdeath

    else
      --- Clouds ---

      local name = rand.key_by_probs(theme.clouds)
      -- don't use same one again
      theme.clouds[name] = nil

      local colormap = SKY_GEN.colormaps[name]
      if not colormap then
        error("SKY_GEN: unknown colormap: " .. tostring(name))
      end

      gui.printf("  %d = %s\n", _index, name)

      gui.set_colormap(1, colormap)
      gui.fsky_add_clouds({ seed=seed, colmap=1, squish=squish })

      EPI.dark_prob = 10
    end


    if rand.odds(80) then

      --- Hills ---

      local name = rand.key_by_probs(hill_tab)
      -- don't use same one again
      hill_tab[name] = hill_tab[name] / 1000

      local colormap = SKY_GEN.colormaps[name]
      if not colormap then
        error("SKY_GEN: unknown colormap: " .. tostring(name))
      end

      gui.printf("    + %s\n", name)

      gui.set_colormap(2, colormap)
      gui.fsky_add_hills({ seed=seed+1, colmap=2, max_h=0.6 })
    end

    gui.fsky_write(EPI.sky_patch)

    if EPI.sky_patch2 then gui.fsky_write(EPI.sky_patch2) end
    if EPI.sky_patch3 then gui.fsky_write(EPI.sky_patch3) end
    if EPI.sky_patch4 then gui.fsky_write(EPI.sky_patch4) end
  end

  gui.printf("\n")
end


----------------------------------------------------------------

OB_MODULES["sky_generator"] =
{
  label = "Sky Generator (DOOM)"

  game = { doom1=1, doom2=1 }

  hooks =
  {
    get_levels = SKY_GEN.generate_skies
  }
}

