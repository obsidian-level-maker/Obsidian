------------------------------------------------------------------------
--  MODULE: Sky Generator
------------------------------------------------------------------------
--
--  Copyright (C) 2008-2017 Andrew Apted
--  Copyright (C) 2018-2019 Armaetus
--  Copyright (C) 2018-2021 MsrSgtShooterPerson
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
  "sky_default", _("Default (66% of Episodes Day)"),
  "sky_night",   _("Night"),
  "sky_day",     _("Day"),
  "sky_25_day",  _("25% of Episodes Day"),
  "50",          _("50% of Episodes Day"),
  "sky_75_day",  _("75% of Episodes Day")
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

function SKY_GEN.setup(self)
  
  module_param_up(self)

  PARAM.episode_sky_color = {}
  PARAM.sky_generator_active = true
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
  local all_themes = table.deep_copy(GAME.RESOURCES.SKY_GEN_THEMES)


  gui.printf("\nSky generator:\n");

  for index,EPI in pairs(GAME.episodes) do

    if not EPI.levels[1] then return end -- empty game episode?

    assert(EPI.sky_patch)

    local seed = gui.random_int()

    is_starry = (index == starry_ep)

    if PARAM.force_sky == "sky_day" then
      is_starry = false
    elseif PARAM.force_sky == "sky_night" then
      is_starry = true
    elseif PARAM.force_sky == "sky_25_day" and rand.odds(75) then
      is_starry = true
    elseif PARAM.force_sky == "50" and rand.odds(50) then
      is_starry = true
    elseif PARAM.force_sky == "sky_75_day" and rand.odds(25) then
      is_starry = true
    else
      is_starry = false
    end

    gui.printf("Forced sky: " .. PARAM.force_sky .. "\n")

    local is_nebula = is_starry and rand.odds(60)

    if PARAM.nebula_color == "none" then
      is_nebula = false
    end

    -- only rarely combine stars + nebula + hills
    -- local is_hilly  = rand.odds(sel(is_nebula, 25, 90))
    local is_hilly = rand.odds(50)

    -- MSSP-SUGGESTS: add sky themes for other level theme types?
    local theme_name = EPI.levels[1].theme_name

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

    local cloud_palette

    --- Clouds ---

    if not is_starry then
      cloud_palette = rand.key_by_probs(cloud_tab)
      -- don't use same one again
      cloud_tab[cloud_palette] = cloud_tab[cloud_palette] / 1000

      if PARAM.cloud_color ~= "default" then
        cloud_palette = PARAM.cloud_color
      end
    end

    --- Nebula ---

    if is_nebula and is_starry then
      cloud_palette = rand.key_by_probs(nebula_tab)
      -- don't use same one again
      nebula_tab[cloud_palette] = nebula_tab[cloud_palette] / 1000

      if PARAM.nebula_color ~= "default" then
        cloud_palette = PARAM.nebula_color
      end
    end

    --- get sky color ---

    if cloud_palette then
      local colormap = GAME.RESOURCES.SKY_GEN_COLORMAPS[cloud_palette]
      if not colormap then
        error("SKY_GEN: unknown colormap: " .. tostring(cloud_palette))
      end

      gui.printf("Sky theme: " .. theme_name .. "\n")
      gui.printf("  %d = %s\n", index, cloud_palette)

      gui.set_colormap(1, colormap)
      gui.fsky_add_clouds({ seed=seed, colmap=1, squish=2.0 })

      EPI.dark_prob = 10

      PARAM.episode_sky_color[index] = cloud_palette
    end
  
    --- Stars ---

    if is_starry then

      local name = "STARS"

      local colormap = GAME.RESOURCES.SKY_GEN_COLORMAPS[name]
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

      local colormap = GAME.RESOURCES.SKY_GEN_COLORMAPS[name]
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

    -- hack fix for when a generated MAPINFO is available
    -- because Doom2 apparently handles sky lump names weirdly
    
    if PARAM.zdoom_specials_active and OB_CONFIG.game == "doom2" then
      if EPI.id == 1 then EPI.sky_patch = "O_D2SKY1" end
      if EPI.id == 2 then EPI.sky_patch = "O_D2SKY2" end
      if EPI.id == 3 then EPI.sky_patch = "O_D2SKY3" end
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

  where = "other",
  priority = 93,

  game = {doom1=1,doom2=1,tnt=1,plutonia=1,heretic=1,hexen=0,hacx=0,harmony=0,strife=0},
  port = "!limit_enforcing",

  hooks =
  {
    setup = SKY_GEN.setup,
    get_levels_after_themes = SKY_GEN.generate_skies,
  },

  options =
  {

    {
      name = "force_sky",
      label=_("Time of Day"),
      choices=SKY_GEN.SKY_CHOICES,
      priority = 10,
      tooltip = _("This forces the sky background (behind the hills and clouds) to either be night or day. Default means vanilla Oblige behavior of picking one episode to be night. Random means 50% chance of night or day to be picked per episode."),
      default = "sky_default",
    },


    {
      name = "force_hills",
      label=_("Terrain Foreground"),
      choices=SKY_GEN.HILL_STATE,
      priority = 9,
      tooltip = _("Influences whether the sky generator should generate terrain in the skybox."),
      default = "hs_random",
      randomize_group = "misc",
    },


    {
      name = "force_hill_params",
      label=_("Terrain Parameters"),
      choices=SKY_GEN.HILL_PARAMS,
      priority = 8,
      tooltip = _("Changes the parameters of generated hills, if there are any. 'Cavernous' causes the terrain to nearly fill up most of the sky, making an impression of being inside a cave or crater."),
      default = "hp_random",
      gap = 1,
      randomize_group = "misc",
    },


    {
      name = "cloud_color",
      label = _("Day Sky Color"),
      choices = SKY_GEN.CLOUD_COLOR_CHOICES,
      priority= 7,
      tooltip = _("Picks the color of the sky if day. Default means random and theme-ish."),
      default = "default",
      randomize_group = "misc",
    },


    {
      name = "terrain_color",
      label = _("Terrain Color"),
      choices = SKY_GEN.TERRAIN_COLOR_CHOICES,
      priority = 6,
      tooltip = _("Picks the color of the terrain in the sky if available. Default means random and theme-ish."),
      default = "default",
      randomize_group = "misc",
    },


    {
      name = "nebula_color",
      label = _("Nebula Color"),
      choices = SKY_GEN.NEBULA_COLOR_CHOICES,
      priority = 5,
      tooltip = _("Picks the color of nebula if sky is night. 'None' means just a plain starry night sky. Default means random and theme-ish."),
      default = "default",
      gap = 1,
      randomize_group = "misc",
    },


    {
      name = "bool_influence_map_darkness",
      label=_("Sky Gen Lighting"),
      valuator = "button",
      default = 0,
      priority = 4,
      tooltip = _("Overrides (and ignores) Dark Outdoors setting in Miscellaneous tab. If the sky generator creates night skies for an episode, episode's map outdoors is also dark but bright if day-ish."),
    },
  },
}
