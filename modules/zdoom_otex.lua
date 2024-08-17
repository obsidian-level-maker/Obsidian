------------------------------------------------------------------------
--  MODULE: OTEX Theme Generator
------------------------------------------------------------------------
--
--  Copyright (C) 2024-2024 MsrSgtShooterPerson
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
-------------------------------------------------------------------
gui.import("zdoom_otex_db.lua")


OTEX_PROC_MODULE = { }

OTEX_MATERIALS = { }
OTEX_ROOM_THEMES = { }

OTEX_EXCLUSIONS = 
{
  WRNG = "textures",
  CHAN = "all",
  EXIT = "all",
  FENC = "all",
  SOLI = "all",
  SWTC = "all",
  FALL = "all",

  TLPT = "all"
}

function OTEX_PROC_MODULE.setup(self)
  PARAM.OTEX_module_activated = true
  module_param_up(self)
  OTEX_PROC_MODULE.synthesize_procedural_themes()
end


function OTEX_PROC_MODULE.synthesize_procedural_themes()
  local resource_tab = {}

  resource_tab = table.copy(OTEX_RESOURCE_DB)
  table.name_up(resource_tab)

  -- resource_tab exclusions
  for k,v in ipairs(OTEX_EXCLUSIONS) do
    if v == "textures" then
      resource_tab[k].textures = nil
    elseif v == "flats" then
      resource_tab[k].flats = nil
    else
      resource_tab[k] = nil
    end
  end

  for _,resource_group in pairs(resource_tab) do
    if resource_group.has_all then
      for _,T in pairs(resource_group.textures) do
        OTEX_MATERIALS[T]=
        {
          t=T,
          f=rand.pick(resource_group.flats)
        }
      end
      for _,F in pairs(resource_group.flats) do
        OTEX_MATERIALS[F]=
        {
          f=F,
          t=rand.pick(resource_group.textures)
        }
      end
    end

    if resource_group.has_textures and
    not resource_group.has_flats then
      for _,T in pairs(resource_group.textures) do
        OTEX_MATERIALS[T]=
        {
          t=T,
          f="CEIL5_2"
        }
      end
    end

    if resource_group.has_flats and
    not resource_group.has_textures then
      for _,F in pairs(resource_group.flats) do
        OTEX_MATERIALS[F] =
        {
          f=F,
          t="BROWNHUG"
        }
      end
    end
  end


  -- create room themes
  local group_choices = {}
  for k,GN in pairs(resource_tab) do
    table.insert(group_choices, k)
  end

  -- try to create a consistent theme
  for i = 1, PARAM.otex_num_themes / 2 do
    local grouping = {}
    local room_theme = {}
    local tab_pick, RT_name
    while grouping and not grouping.has_all == true do
      grouping = resource_tab[rand.pick(group_choices)]
    end

    RT_name = "any_OTEX_cons_" .. i
    room_theme =
    {
      env = "building",
      prob = rand.pick({40,50,60}) * PARAM.otex_rt_prob_mult
    }
    room_theme.walls = {}
    room_theme.floors = {}
    room_theme.ceilings = {}

    tab_pick = rand.pick(grouping.textures)
    room_theme.walls[tab_pick] = 5
    RT_name = RT_name .. tab_pick .. "_"

    if rand.odds(25) then
      grouping = resource_tab[rand.pick(group_choices)]
      while grouping and not grouping.has_all == true do
        grouping = resource_tab[rand.pick(group_choices)]
      end
    end
    tab_pick = rand.pick(grouping.flats)
    room_theme.floors[tab_pick] = 5
    RT_name = RT_name .. tab_pick .. "_"

    if rand.odds(25) then
      grouping = resource_tab[rand.pick(group_choices)]
      while grouping and not grouping.has_all == true do
        grouping = resource_tab[rand.pick(group_choices)]
      end
    end
    tab_pick = rand.pick(grouping.flats)
    room_theme.ceilings[tab_pick] = 5
    RT_name = RT_name .. tab_pick .. "_"

    room_theme.name = RT_name
    OTEX_ROOM_THEMES[RT_name] = room_theme
  end

  -- try a completely random theme
  for i = 1, PARAM.otex_num_themes / 2 do
    local RT_name = "any_OTEX_" .. i
    local room_theme, tab_pick = {}

    room_theme =
    {
      env = "building",
      prob = rand.pick({40,50,60}),
    }
    room_theme.walls = {}
    room_theme.floors = {}
    room_theme.ceilings = {}

    tab_pick = rand.pick(group_choices)
    while not resource_tab[tab_pick].has_textures == true do
      tab_pick = rand.pick(group_choices)
    end
    RT_name = RT_name .. tab_pick .. "_"
    room_theme.walls[rand.pick(resource_tab[tab_pick].textures)] = 5

    tab_pick = rand.pick(group_choices)
    while not resource_tab[tab_pick].has_flats == true do
      tab_pick = rand.pick(group_choices)
    end
    RT_name = RT_name .. tab_pick .. "_"
    room_theme.floors[rand.pick(resource_tab[tab_pick].flats)] = 5

    tab_pick = rand.pick(group_choices)
    while not resource_tab[tab_pick].has_flats == true do
      tab_pick = rand.pick(group_choices)
    end
    RT_name = RT_name .. tab_pick .. "_"
    room_theme.ceilings[rand.pick(resource_tab[tab_pick].flats)] = 5

    room_theme.name = RT_name
    OTEX_ROOM_THEMES[RT_name] = room_theme
  end
end


function OTEX_PROC_MODULE.get_levels_after_themes()
  table.deep_merge(GAME.MATERIALS, OTEX_MATERIALS, 2)
  table.deep_merge(GAME.ROOM_THEMES, OTEX_ROOM_THEMES, 2)
end

----------------------------------------------------------------

OB_MODULES["otex_proc_module"] =
{

  name = "otex_proc_module",

  label = _("OTEX Resource Pack [PRE-ALPHA]"),

  where = "other",
  priority = 75,

  port = "zdoom",

  game = "doomish",

  hooks =
  {
    setup = OTEX_PROC_MODULE.setup,
    get_levels_after_themes = OTEX_PROC_MODULE.get_levels_after_themes
  },

  tooltip = _("If enabled, generates room themes using OTEX based on a resource table. ".. 
  "OTEX must be manually loaded in the sourceport. " ..
  "Includes textures and flats only, no patches.\n\n" ..
  "Currently does not make any kind of sensibly curated room themes."),

  options =
  {
    {
      name="otex_num_themes",
      label=_("Room Themes Count"),
      valuator = "slider",
      min = 2,
      max = 40,
      increment = 2,
      default = 8,
      tooltip = _("How many OTEX room themes to synthesize."),
      longtip = _("Not all room themes may show up in levels as appearance " ..
      "is reliant on use probability. Use multipler below to increase " ..
      "or decrease further"),
      priority = 2
    },
    {
      name="otex_rt_prob_mult",
      label=_("Probability Multiplier"),
      valuator="slider",
      units="x",
      min = 0,
      max = 20,
      increment = 0.1,
      default = 1,
      tooltip = _("Multiplier for all synthesized OTEX room themes."),
      priority = 1
    }
  }
}
