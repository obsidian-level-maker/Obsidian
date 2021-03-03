------------------------------------------------------------------------
--  MODULE: Sky Generator
------------------------------------------------------------------------
--
--  Copyright (C) 2008-2017 Andrew Apted
--  Copyright (C) 2018-2019 Armaetus
--  Copyright (C) 2018-2020 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

SKY_GEN = { }

SKY_GEN.SKY_CHOICES =
{
  "sky_default", _("Default"),
  "50",          _("Random"),
  "sky_night",   _("Night"),
  "sky_day",     _("Day"),
}

SKY_GEN.HILL_STATE =
{
  "hs_random", _("Random"),
  "hs_none",   _("Never"),
  "hs_always", _("Always"),
}

SKY_GEN.HILL_PARAMS =
{
  "hp_random",      _("Random"),
  "hp_hilly",       _("Hills"),
  "hp_mountainous", _("Mountainous"),
  "hp_cavernous",   _("Cavernous"),
}

SKY_GEN.CLOUD_COLOR_CHOICES =
{
  "default", _("DEFAULT"),
  "SKY_CLOUDS", _("Blue + White Clouds"),
  "GREY_CLOUDS", _("Grey"),
  "DARK_CLOUDS", _("Dark Grey"),
  "BLUE_CLOUDS", _("Dark Blue"),
  "HELL_CLOUDS", _("Red"),
  "ORANGE_CLOUDS", _("Orange"),
  "HELLISH_CLOUDS", _("Red-ish"),
  "BROWN_CLOUDS", _("Brown"),
  "BROWNISH_CLOUDS", _("Brown-ish"),
  "YELLOW_CLOUDS", _("Yellow"),
  "GREEN_CLOUDS", _("Green"),
  "JADE_CLOUDS", _("Jade"),
  "DARKRED_CLOUDS", _("Dark Red"),
  "PEACH_CLOUDS", _("Peach"),
  "WHITE_CLOUDS", _("White"),
  "PURPLE_CLOUDS", _("Purple"),
  "RAINBOW_CLOUDS", _("Rainbow"),
}

SKY_GEN.TERRAIN_COLOR_CHOICES =
{
  "default", _("DEFAULT"),
  "BLACK_HILLS", _("Black"),
  "BROWN_HILLS", _("Brown"),
  "TAN_HILLS", _("Tan"),
  "GREEN_HILLS", _("Green"),
  "DARKGREEN_HILLS", _("Dark Green"),
  "HELL_HILLS", _("Red"),
  "DARKBROWN_HILLS", _("Dark Brown"),
  "GREENISH_HILLS", _("Green-ish"),
  "ICE_HILLS", _("Ice"),
}

SKY_GEN.NEBULA_COLOR_CHOICES =
{
  "default", _("DEFAULT"),
  "none", _("None"),
  "BLUE_NEBULA", _("Blue"),
  "RED_NEBULA", _("Red"),
  "BROWN_NEBULA", _("Brown"),
  "GREEN_NEBULA", _("Green"),
}

SKY_GEN.colormaps =
{
  -- star colors --

  STARS =
  {
    8, 7, 6, 5,
    111, 109, 107, 104, 101,
    98, 95, 91, 87, 83, 4,
  },

  RED_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    191,190,189,188,186,184,182,180,
  },

  BLUE_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    247,246,245,244,243,242,241,240,
    207,206,205,204,203,202,201,200,
  },

  BROWN_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    2,2,1,1, 79,79,78,77,76,75,74,73,71,69,
  },

  GREEN_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    127, 126, 125, 124, 123, 122, 121,
    120, 119, 118, 117, 115, 113, 112,
  },

  -- cloud colors --

  GREY_CLOUDS =
  {
    106, 104, 102, 100,
    98, 96, 94, 92, 90,
    88, 86, 84, 82, 80,
  },

  DARK_CLOUDS =
  {
    7, 6, 5,
    110, 109, 108, 107, 106,
    105, 104, 103, 102, 101,
  },

  BLUE_CLOUDS =
  {
    245, 245, 244, 244, 243, 242, 241,
    240, 206, 205, 204, 204, 203, 203,
  },

  HELL_CLOUDS =
  {
    188, 185, 184, 183, 182, 181, 180,
    179, 178, 177, 176, 175, 174, 173,
  },

  ORANGE_CLOUDS =
  {
    234, 232, 222, 220, 218, 216, 214, 211,
  },

  HELLISH_CLOUDS =
  {
    0, 0, 0, 0, 0, 47, 191, 190, 191, 47, 0, 0,
  },

  BROWN_CLOUDS =
  {
     2, 1,
     79, 78, 77, 76, 75, 74, 73,
     72, 71, 70, 69, 67, 66, 65,
  },

  BROWNISH_CLOUDS =
  {
    239, 238, 237, 236, 143, 142, 141,
    140, 139, 138, 137, 136, 135, 134,
    133, 130, 129, 128,
  },

  YELLOW_CLOUDS =
  {
    167, 166, 165, 164, 163, 162,
    161, 160, 228, 227, 225,
  },

  GREEN_CLOUDS =
  {
    127, 126, 125, 124, 123, 122, 121,
    120, 119, 118, 117, 115, 113, 112,
  },

  JADE_CLOUDS =
  {
    12, 11, 10, 9,
    159, 158, 157, 156, 155, 154, 153, 152,
  },

  DARKRED_CLOUDS =
  {
     47, 46, 45, 44, 43, 42, 41, 40, 39, 37, 36, 34,
  },

  PEACH_CLOUDS =
  {
     68, 66, 64, 62, 60, 58, 57,
  },

  WHITE_CLOUDS =
  {
     99, 98, 97, 96, 95, 94, 93,
     92, 91, 90, 89, 88, 87, 86,
     85, 84, 83, 81,
  },

  SKY_CLOUDS =
  {
    193, 194, 195, 196, 197, 198, 199, 200, 201,
  },

  PURPLE_CLOUDS =
  {
    254, 253, 252, 251, 250, 251, 252, 253, 254,
  },

  RAINBOW_CLOUDS =
  {
    191, 186, 181, 176,
    231, 161, 164, 167,
    242, 207, 204, 199,
    115, 119, 123, 127,
  },

  -- hill colors --

  BLACK_HILLS =
  {
    0, 0, 0,
  },

  BROWN_HILLS =
  {
    0, 2, 2, 1,
    79,78,77,76,75,74,73,72,
    71,70,69,68,67,66,65,64,
  },

  TAN_HILLS =
  {
    239, 238, 237,
    143, 142, 141, 140, 138, 136, 134, 132, 130, 129, 128,
  },

  GREEN_HILLS =
  {
    0, 7,
    127, 126, 125, 124, 123, 122, 121,
    120, 119, 118, 117, 116, 115, 114, 113,
  },

  DARKGREEN_HILLS =
  {
    0, 7, 127, 126, 125, 124,
  },

  HELL_HILLS =
  {
    0, 6, 47, 46, 45, 44, 43, 42, 41, 40,
    39, 38, 37, 36, 35, 34, 33,
  },

  DARKBROWN_HILLS =
  {
    8, 7, 2, 1, 79, 78, 77, 76, 75,
  },

  GREENISH_HILLS =
  {
    0, 7, 12, 11, 10, 9, 15, 14, 13,
    159, 158, 157, 156, 155, 154,
  },

  ICE_HILLS =
  {
    0, 244,
    207, 206, 205, 204, 203, 202, 201,
    200, 198, 197, 195, 194, 193, 192,
  },

  SNOW_HILLS =
  {
    0, 8, 6, 5, 111, 109, 107, 105,
    90, 88, 86, 84, 82, 80, 4,
    --87, 86, 85, 84, 83, 82, 81, 80, 4,
  },
}

-- Some ideas for Doom/Ultimate Doom if going with a theme to make it like "Original" theming:
-- Phobos: White/Gray/Dark skies, brown/brown-green/ice hills/mountains
-- Deimos: Red/Orange/Dark skies, brown/black/ice hills/mountains
-- Hell: Red/Orange/Yellow/Green skies, any hill/mountain type goes
-- E4: Orange/Yellow/White/Gray/Dark skies, any hill/mountain type goes


SKY_GEN.themes =
{
  urban =
  {
    clouds =
    {
      SKY_CLOUDS = 130,
      BLUE_CLOUDS = 80,
      WHITE_CLOUDS = 80,
      GREY_CLOUDS = 100,
      DARK_CLOUDS = 100,

      BROWN_CLOUDS = 60,
      BROWNISH_CLOUDS = 40,
      PEACH_CLOUDS = 40,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      GREEN_CLOUDS = 25,
      JADE_CLOUDS = 25,
    },

    hills =
    {
      TAN_HILLS = 30,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      GREENISH_HILLS = 30,
      ICE_HILLS = 12,
      BLACK_HILLS = 5,
      SNOW_HILLS = 20,
    },

    dark_hills =
    {
      DARKGREEN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      ICE_HILLS = 25,
    },
  },


  hell =
  {
    clouds =
    {
      HELL_CLOUDS = 100,
      DARKRED_CLOUDS = 70,
      HELLISH_CLOUDS = 55,
      YELLOW_CLOUDS = 40,
      ORANGE_CLOUDS = 40,
      JADE_CLOUDS = 35,
      GREEN_CLOUDS = 30,
      WHITE_CLOUDS = 30,
      GREY_CLOUDS = 30,
      PEACH_CLOUDS = 20,
      DARK_CLOUDS = 40,

    },

    hills =
    {
      HELL_HILLS = 50,
      BROWN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      BLACK_HILLS = 25,
      SNOW_HILLS = 25,
    },

    dark_hills =
    {
      HELL_HILLS = 50,
      DARKBROWN_HILLS = 20,
    },
  },

  psycho =
  {
    clouds =
    {
      PURPLE_CLOUDS  = 90,
      YELLOW_CLOUDS  = 70,
      HELLISH_CLOUDS = 20,
      RAINBOW_CLOUDS = 10,

      GREEN_CLOUDS = 70,
      BLUE_CLOUDS  = 70,
      WHITE_CLOUDS = 30,
      GREY_CLOUDS  = 30,
    },

    hills =
    {
      BLUE_CLOUDS = 50,
      GREEN_HILLS = 50,
      RAINBOW_CLOUDS = 50,
      PURPLE_CLOUDS = 30,
      YELLOW_CLOUDS = 30,
      ORANGE_CLOUDS = 30,
      WHITE_CLOUDS = 30,
      HELLISH_CLOUDS = 20,
    },

    -- no dark_hills
  },

}

function SKY_GEN.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end

  PARAM.episode_sky_color = {}
end

function SKY_GEN.generate_skies()

  -- select episode for the starry starry night
  local starry_ep = rand.irange(1, # GAME.episodes)

  -- less chance of it being the first episode
  -- [ for people who usually make a single episode or less ]
  if starry_ep == 1 then
    starry_ep = rand.irange(1, # GAME.episodes)
  end

  -- often have no starry sky at all
  if rand.odds(30) then
    starry_ep = -7
  end

  -- copy all theme tables [so we can safely modify them]
  local all_themes = table.deep_copy(SKY_GEN.themes)


  gui.printf("\nSky generator:\n");

  for index,EPI in pairs(GAME.episodes) do

    if not EPI.levels[1] then return end -- empty game episode?

    assert(EPI.sky_patch)

    local seed = int(gui.random() * 1000000)

    local is_starry = (_index == starry_ep) or rand.odds(2)

    if PARAM.force_sky == "sky_day" then
      is_starry = false
    elseif PARAM.force_sky == "sky_night"
    or (PARAM.force_sky == "50" and rand.odds(50)) then
      is_starry = true
    end

    gui.printf("Forced sky: " .. PARAM.force_sky .. "\n")

    local is_nebula = is_starry and rand.odds(60)

    if PARAM.nebula_color == "none" then
      is_nebula = false
    end

    -- only rarely combine stars + nebula + hills
    local is_hilly  = rand.odds(sel(is_nebula, 25, 90))

    -- MSSP-SUGGESTS: add sky themes for other level theme types?
    local theme_name = rand.pick{"urban", "hell"}

    if OB_CONFIG.theme == "psycho" then
      theme_name = "psycho"
    end

    if EPI.levels[1].theme_name == "tech" then
      theme_name = "urban"
    elseif EPI.levels[1].theme_name == "hell" then
      theme_name = "hell"
    end

    local theme = all_themes[theme_name]
    assert(theme)

    local cloud_tab = assert(theme.clouds)
    local  hill_tab = assert(theme.hills)

    local nebula_tab =
    {
      BLUE_NEBULA  = 6,
      RED_NEBULA  = 6,
      BROWN_NEBULA = 4,
      GREEN_NEBULA = 3,
    }


    gui.fsky_create(256, 128, 0)


    --- Clouds ---

    if not is_starry or is_nebula then

      local name

      if is_nebula then
        name = rand.key_by_probs(nebula_tab)
        -- don't use same one again
        nebula_tab[name] = nebula_tab[name] / 1000

        if PARAM.nebula_color ~= "default" then
          name = PARAM.nebula_color
        end
      else
        name = rand.key_by_probs(cloud_tab)
        -- don't use same one again
        cloud_tab[name] = cloud_tab[name] / 1000

        if PARAM.cloud_color ~= "default" then
          name = PARAM.cloud_color
        end
      end

      local colormap = SKY_GEN.colormaps[name]
      if not colormap then
        error("SKY_GEN: unknown colormap: " .. tostring(name))
      end

      gui.printf("Sky theme: " .. theme_name .. "\n")
      gui.printf("  %d = %s\n", index, name)

      gui.set_colormap(1, colormap)
      gui.fsky_add_clouds({ seed=seed, colmap=1, squish=2.0 })

      EPI.dark_prob = 10

      PARAM.episode_sky_color[index] = name
    end


    --- Stars ---

    if is_starry then

      local name = "STARS"

      local colormap = SKY_GEN.colormaps[name]
      if not colormap then
        error("SKY_GEN: unknown colormap: " .. tostring(name))
      end

      gui.printf("  %d = %s\n", index, name)

      gui.set_colormap(1, colormap)
      gui.fsky_add_stars({ seed=seed, colmap=1 })

      if theme.dark_hills and rand.odds(90) then
        hill_tab = theme.dark_hills
      end

      EPI.dark_prob = 100  -- always, for flyingdeath
    end


    --- Hills ---
    if PARAM.force_hills == "hs_none" then
       is_hilly = false
    elseif PARAM.force_hills == "hs_always" then
       is_hilly = true
    end

    if is_hilly then

      local name = rand.key_by_probs(hill_tab)
      -- don't use same one again
      hill_tab[name] = hill_tab[name] / 1000

      if PARAM.terrain_color ~= "default" then
        name = PARAM.terrain_color
      end

      local colormap = SKY_GEN.colormaps[name]
      if not colormap then
        error("SKY_GEN: unknown colormap: " .. tostring(name))
      end

      gui.printf("    + %s\n", name)

      local info =
      {
        seed = seed + 1,
        colmap = 2,
      }

      info.max_h = rand.pick({0.6, 0.65, 0.7, 0.8 })
      info.min_h = rand.pick({ -0.2, -0.1 })

      info.frac_dim = rand.pick({1.4, 1.65, 1.8, 1.9 })

      if PARAM.force_hill_params == "hp_hilly" then
        info.max_h = rand.pick({0.5, 0.55, 0.6, 0.65 })
      elseif PARAM.force_hill_params == "hp_mountainous" then
        info.max_h = rand.pick({.7, 0.75, 0.8, 0.85})
      elseif PARAM.force_hill_params == "hp_cavernous" then
        info.max_h = rand.pick({0.9, 1, 1.1, 1.2, 1.3})
        info.min_h = rand.pick({0, 0.1, 0.2, 0.3, 0.4, 0.5})
      end

      -- sometimes make more pointy mountains
      if rand.odds(50) then
        info.power = 3.1
        info.max_h = info.max_h + 0.1
        info.min_h = info.min_h + 0.3
      end

      EPI.has_mountains = true


      gui.set_colormap(2, colormap)
      gui.fsky_add_hills(info)
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
  label = _("Sky Generator"),

  side = "left",
  priority = 93,

  game = "doomish",

  hooks =
  {
    setup = SKY_GEN.setup,
    get_levels_after_themes = SKY_GEN.generate_skies
  },

  options =
  {
    force_sky =
    {
      label=_("Time of Day"),
      choices=SKY_GEN.SKY_CHOICES,
      priority = 10,
      tooltip = "This forces the sky background (behind the hills and clouds) to either be night or day. " ..
      "Default means vanilla Oblige behavior of picking one episode to be night. Random means 50% chance of " ..
      "night or day to be picked per episode.",
      default = "sky_default",
    },

    force_hills =
    {
      label=_("Terrain Foreground"),
      choices=SKY_GEN.HILL_STATE,
      priority = 9,
      tooltip = "Influences whether the sky generator should generate terrain in the skybox.",
      default = "hs_random",
    },

    force_hill_params =
    {
      label=_("Terrain Parameters"),
      choices=SKY_GEN.HILL_PARAMS,
      priority = 8,
      tooltip = "Changes the parameters of generated hills, if there are any. " ..
                "'Cavernous' causes the terrain to nearly fill up most of the sky," ..
                "making an impression of being inside a cave or crater.",
      default = "hp_random",
      gap = 1,
    },

    cloud_color =
    {
      label = _("Day Sky Color"),
      choices = SKY_GEN.CLOUD_COLOR_CHOICES,
      priority= 7,
      tooltip = "Picks the color of the sky if day. Default means random and theme-ish.",
      default = "default",
    },

    terrain_color =
    {
      label = _("Terrain Color"),
      choices = SKY_GEN.TERRAIN_COLOR_CHOICES,
      priority = 6,
      tooltip = "Picks the color of the terrain in the sky if available. Default means random and theme-ish.",
      default = "default",
    },

    nebula_color =
    {
      label = _("Nebula Color"),
      choices = SKY_GEN.NEBULA_COLOR_CHOICES,
      priority = 5,
      tooltip = "Picks the color of nebula if sky is night. 'None' means just a plain starry night sky. " ..
                "Default means random and theme-ish.",
      default = "default",
      gap = 1,
    },

    influence_map_darkness =
    {
      label=_("Sky Gen Lighting"),
      choices=MISC_STUFF.YES_NO,
      priority = 4,
      tooltip = "Overrides (and ignores) Dark Outdoors setting in Miscellaneous tab. If the sky generator " ..
      "creates night skies for an episode, episode's map outdoors is also dark but bright if day-ish.",
      default = "no",
    },
  },
}
