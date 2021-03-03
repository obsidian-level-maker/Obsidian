------------------------------------------------------------------------
--  MODULE: Sky Generator
------------------------------------------------------------------------
--
--  Copyright (C) 2008-2017 Andrew Apted
--  Copyright (C) 2018-2019 Armaetus
--  Copyright (C) 2018-2020 MsrSgtShooterPerson
--  Adapted for Heretic by Dashodanger
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

SKY_GEN_HERETIC = { }

SKY_GEN_HERETIC.SKY_CHOICES =
{
  "sky_default", _("Default"),
  "50",          _("Random"),
  "sky_night",   _("Night"),
  "sky_day",     _("Day"),
}

SKY_GEN_HERETIC.HILL_STATE =
{
  "hs_random", _("Random"),
  "hs_none",   _("Never"),
  "hs_always", _("Always"),
}

SKY_GEN_HERETIC.HILL_PARAMS =
{
  "hp_random",      _("Random"),
  "hp_hilly",       _("Hills"),
  "hp_mountainous", _("Mountainous"),
  "hp_cavernous",   _("Cavernous"),
}

SKY_GEN_HERETIC.CLOUD_COLOR_CHOICES =
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

SKY_GEN_HERETIC.TERRAIN_COLOR_CHOICES =
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

SKY_GEN_HERETIC.NEBULA_COLOR_CHOICES =
{
  "default", _("DEFAULT"),
  "none", _("None"),
  "BLUE_NEBULA", _("Blue"),
  "RED_NEBULA", _("Red"),
  "BROWN_NEBULA", _("Brown"),
  "GREEN_NEBULA", _("Green"),
}

SKY_GEN_HERETIC.colormaps =
{
  -- star colors --

  STARS =
  {
    0, 1, 2, 3,
    6, 9, 11, 13, 15,
    16, 19, 21, 23, 25, 255,
  },

  RED_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    145,146,147,148,150,152,154,156,
  },

  BLUE_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    185,186,187,188,189,190,191,192,
    193,194,195,196,197,198,199,200,
  },

  BROWN_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    3,3,4,4, 67,67,68,69,70,71,72,73,75,77,
  },

  GREEN_NEBULA =
  {
    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
    209, 210, 211, 212, 213, 214, 215,
    216, 217, 218, 219, 221, 223, 224,
  },

  -- cloud colors --

  GREY_CLOUDS =
  {
    11, 13, 15, 17,
    19, 21, 23, 25, 27,
    29, 31, 33,
  },

  DARK_CLOUDS =
  {
    1, 2, 3,
    4, 5, 6, 7, 8,
    9, 10, 11, 12, 13,
  },

  BLUE_CLOUDS =
  {
    185, 185, 186, 186, 187, 188, 189,
    190, 192, 193, 194, 194, 195, 195,
  },

  HELL_CLOUDS =
  {
    148, 149, 150, 151, 152, 153, 154,
    155, 156, 157, 158, 159, 160, 161,
  },

  ORANGE_CLOUDS =
  {
    137, 138, 139, 140, 127, 128, 130, 132,
  },

  HELLISH_CLOUDS =
  {
    0, 0, 0, 0, 0, 145, 146, 147, 146, 145, 0, 0,
  },

  BROWN_CLOUDS =
  {
     3, 4,
     68, 69, 70, 71, 72, 73, 74,
     75, 76, 77, 78, 80, 81, 82,
  },

  BROWNISH_CLOUDS =
  {
    95, 96, 97, 98, 99, 100, 101,
    102, 103, 104, 105, 106, 107, 108,
    109, 110,
  },

  YELLOW_CLOUDS =
  {
    118, 119, 121, 123, 125, 131,
    132, 133, 144, 136,
  },

  GREEN_CLOUDS =
  {
    209, 210, 211, 212, 213, 214, 215,
    216, 217, 218, 219, 221, 223, 224,
  },

  JADE_CLOUDS =
  {
    229, 230, 231, 232,
    233, 234, 235, 236, 237, 238, 239, 240,
  },

  DARKRED_CLOUDS =
  {
     145, 146, 147, 148, 149, 150, 151, 152,
  },

  PEACH_CLOUDS =
  {
     80, 82, 84, 86, 88, 89,
  },

  WHITE_CLOUDS =
  {
     12, 13, 14, 15, 16, 17, 18,
     19, 20, 21, 22, 23, 24, 25,
     26, 27, 28, 30, 32,
  },

  SKY_CLOUDS =
  {
    200, 199, 198, 197,
  },

  PURPLE_CLOUDS =
  {
    171, 172, 173, 174, 175, 174, 173, 172, 171,
  },

  RAINBOW_CLOUDS =
  {
    145, 150, 154, 158,
    144, 143, 140, 137,
    187, 192, 196, 199,
    219, 215, 213, 211,
  },

  -- hill colors --

  BLACK_HILLS =
  {
    0, 0, 0,
  },

  BROWN_HILLS =
  {
    0, 3, 3, 4,
    96,97,98,99,100,76,77,78,
    79,80,81,82,83,84,123,122,
  },

  TAN_HILLS =
  {
    96, 97, 98,
    99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110,
  },

  GREEN_HILLS =
  {
    0, 1,
    210, 211, 212, 213, 214, 215, 216,
    217, 218, 219, 220, 221, 222, 223, 224,
  },

  DARKGREEN_HILLS =
  {
    0, 1, 210, 211, 212, 213,
  },

  HELL_HILLS =
  {
    0, 2, 145, 146, 147, 148, 149, 150, 151, 152,
    153,
  },

  DARKBROWN_HILLS =
  {
    1, 2, 3, 4, 95, 96, 97, 98,
  },

  GREENISH_HILLS =
  {
    0, 1, 225, 226, 227, 228, 96, 97, 98,
    232, 233, 234, 235, 236, 237,
  },

  ICE_HILLS =
  {
    0, 185,
    193, 194, 195, 196, 197, 198, 199,
    200, 201, 202,
  },
}

SKY_GEN_HERETIC.themes =
{
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

  castle =
    -- at the moment a 1:1 copy of the Doom generator urban theme values
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
    },

    dark_hills =
    {
      DARKGREEN_HILLS = 50,
      DARKBROWN_HILLS = 50,
      ICE_HILLS = 25,
    },
  },

}

function SKY_GEN_HERETIC.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end

  PARAM.episode_sky_color = {}
end

function SKY_GEN_HERETIC.generate_skies()

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
  local all_themes = table.deep_copy(SKY_GEN_HERETIC.themes)


  gui.printf("\nSky generator:\n");

  for _,EPI in pairs(GAME.episodes) do

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

    local theme_name = "castle"

    if OB_CONFIG.theme == "psycho" then
      theme_name = "psycho"
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

      local colormap = SKY_GEN_HERETIC.colormaps[name]
      if not colormap then
        error("SKY_GEN: unknown colormap: " .. tostring(name))
      end

      gui.printf("Sky theme: " .. theme_name .. "\n")
      gui.printf("  %d = %s\n", _index, name)

      gui.set_colormap(1, colormap)
      gui.fsky_add_clouds({ seed=seed, colmap=1, squish=2.0 })

      EPI.dark_prob = 10

      PARAM.episode_sky_color[_index] = name
    end


    --- Stars ---

    if is_starry then

      local name = "STARS"

      local colormap = SKY_GEN_HERETIC.colormaps[name]
      if not colormap then
        error("SKY_GEN: unknown colormap: " .. tostring(name))
      end

      gui.printf("  %d = %s\n", _index, name)

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

      local colormap = SKY_GEN_HERETIC.colormaps[name]
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

OB_MODULES["sky_generator_heretic"] =
{
  label = _("Sky Generator"),

  side = "left",
  priority = 93,

  game = "heretic",

  hooks =
  {
    setup = SKY_GEN_HERETIC.setup,
    get_levels_after_themes = SKY_GEN_HERETIC.generate_skies
  },

  options =
  {
    force_sky =
    {
      label=_("Time of Day"),
      choices=SKY_GEN_HERETIC.SKY_CHOICES,
      priority = 10,
      tooltip = "This forces the sky background (behind the hills and clouds) to either be night or day. " ..
      "Default means vanilla Oblige behavior of picking one episode to be night. Random means 50% chance of " ..
      "night or day to be picked per episode.",
      default = "sky_default",
    },

    force_hills =
    {
      label=_("Terrain Foreground"),
      choices=SKY_GEN_HERETIC.HILL_STATE,
      priority = 9,
      tooltip = "Influences whether the sky generator should generate terrain in the skybox.",
      default = "hs_random",
    },

    force_hill_params =
    {
      label=_("Terrain Parameters"),
      choices=SKY_GEN_HERETIC.HILL_PARAMS,
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
      choices = SKY_GEN_HERETIC.CLOUD_COLOR_CHOICES,
      priority= 7,
      tooltip = "Picks the color of the sky if day. Default means random and theme-ish.",
      default = "default",
    },

    terrain_color =
    {
      label = _("Terrain Color"),
      choices = SKY_GEN_HERETIC.TERRAIN_COLOR_CHOICES,
      priority = 6,
      tooltip = "Picks the color of the terrain in the sky if available. Default means random and theme-ish.",
      default = "default",
    },

    nebula_color =
    {
      label = _("Nebula Color"),
      choices = SKY_GEN_HERETIC.NEBULA_COLOR_CHOICES,
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
