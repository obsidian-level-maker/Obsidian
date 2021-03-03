------------------------------------------------------------------------
--  MODULE: prefab spawn quantity controller
------------------------------------------------------------------------
--
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
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
-------------------------------------------------------------------

PREFAB_CONTROL_HERETIC = { }

PREFAB_CONTROL_HERETIC.WALL_CHOICES =
{
  "fab_default", _("DEFAULT"),
  "fab_some",    _("Some"),
  "fab_less",    _("Less"),
  "fab_few",     _("Few"),
  "fab_rare",    _("Rare"),
  "fab_random",  _("Mix It Up"),
}

PREFAB_CONTROL_HERETIC.POINT_CHOICES =
{
  "fab_none",    _("NONE"),
  "fab_rare",    _("Rare"),
  "fab_few",     _("Few"),
  "fab_default", _("DEFAULT"),
  "fab_more",    _("More"),
  "fab_heaps",   _("Heaps"),
}

PREFAB_CONTROL_HERETIC.ON_OFF =
{
  "on",  _("On"),
  "off", _("Off"),
}

PREFAB_CONTROL_HERETIC.FINE_TUNE_MULT_FACTORS =
{
  "0", _("NONE"),
  "0.33", _("Rare"),
  "0.5",  _("Few"),
  "0.75", _("Less"),
  "1", _("Default"),
  "2", _("More"),
  "4", _("Heaps"),
  "8", _("I LOVE IT"),
}

function PREFAB_CONTROL_HERETIC.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end
end

function PREFAB_CONTROL_HERETIC.fine_tune_filters()
  for name,fab in pairs(PREFABS) do
    if fab.filter == "gamble" then
      fab.prob = fab.prob * tonumber(PARAM.pf_gamble)
      fab.use_prob = fab.use_prob * tonumber(PARAM.pf_gamble)

      if fab.skip_prob then
        fab.skip_prob = math.clamp(0,fab.skip_prob / tonumber(PARAM.pf_gamble),100)
      end
    end

    if fab.filter == "crushers" then
      fab.prob = fab.prob * tonumber(PARAM.pf_crushers)
      fab.use_prob = fab.use_prob * tonumber(PARAM.pf_crushers)

      if fab.skip_prob then
        fab.skip_prob = math.clamp(0,fab.skip_prob / tonumber(PARAM.pf_crushers),100)
      end
    end

    if fab.filter == "dexterity" then
      fab.prob = fab.prob * tonumber(PARAM.pf_dexterity)
      fab.use_prob = fab.use_prob * tonumber(PARAM.pf_dexterity)

      if fab.skip_prob then
        fab.skip_prob = math.clamp(0,fab.skip_prob / tonumber(PARAM.pf_dexterity),100)
      end
    end

    if fab.filter == "mirror_maze" then
      fab.prob = fab.prob * tonumber(PARAM.pf_mirror_mazes)
      fab.use_prob = fab.use_prob * tonumber(PARAM.pf_mirror_mazes)

      if fab.skip_prob then
        fab.skip_prob = math.clamp(0,fab.skip_prob / tonumber(PARAM.pf_mirror_mazes),100)
      end
    end
  end
end

----------------------------------------------------------------

OB_MODULES["prefab_control_heretic"] =
{
  label = _("Prefab Control"),

  side = "left",
  priority = 93,

  game = "heretic",

  hooks =
  {
    setup = PREFAB_CONTROL_HERETIC.setup
--    get_levels = PREFAB_CONTROL_HERETIC.fine_tune_filters
  },

  options =
  {
    autodetail =
    {
      name = "autodetail",
      label=("Auto Detailing"),
      choices=PREFAB_CONTROL_HERETIC.ON_OFF,
      tooltip = "Reduces the amount of complex architecture in a map based on its size. Default is on.",
      default = "on",
      priority = 102,
      gap = 1,
    },

    point_prob =
    {
      name = "point_prob",
      label=_("Decor"),
      choices=PREFAB_CONTROL_HERETIC.POINT_CHOICES,
      tooltip = "Decor prefabs are prefabs placed along the floors such as crates, pillars, and other decorative elements which aren't tied to walls. This directly modifies probabilities on a per-room basis, not the density for decor prefabs in any given room.\n\nNote: DEFAULT actually behaves like Mix-It-Up.",
      default = "fab_default",
      priority = 101,
    },

    wall_prob = -- code for this option is currently under revision
    {
      name = "wall_prob",
      label=_("Walls"),
      choices=PREFAB_CONTROL_HERETIC.WALL_CHOICES,
      tooltip = "Determines the amount plain wall prefabs. What it actually does is greatly increase the probability of Oblige's basic plain wall prefab, rather than reduce the probability of all the prefabs in the library.",
      default = "fab_default",
      priority = 100,
      gap = 1,
    },

    --

--[[    pf_crushers =
    {
      name="pf_crushers", label=_("Crushers"), choices=PREFAB_CONTROL_HERETIC.FINE_TUNE_MULT_FACTORS
      tooltip="Changes probabilities for fabs with crushing sectors. Default is on.",
      default="1",
      priority = 49,
    },

    pf_dexterity =
    {
      name="pf_dexterity", label=_("Dexterity Fabs"), choices=PREFAB_CONTROL_HERETIC.FINE_TUNE_MULT_FACTORS
      tooltip="Changes probabilities for fabs featuring Chasm-ish navigation. Default is on.",
      default="1",
      priority = 48,
    },

    pf_gamble =
    {
      name="pf_dexterity", label=_("Gambling Fabs"), choices=PREFAB_CONTROL_HERETIC.FINE_TUNE_MULT_FACTORS
      tooltip="Changes probabilities for fabs that may lockout a player on items. Default is on.",
      default="1",
      priority = 47,
    },

    pf_sight_ambushes =
    {
      name="pf_sight_ambushes", label=_("Sight Ambush Cages"), choices=PREFAB_CONTROL_HERETIC.FINE_TUNE_MULT_FACTORS
      tooltip="Changes probabilities for cages that unleash its monsters when player is in sight. " ..
      "Default is on.",
      default="1",
      priority = 46,
    },

    pf_mirror_mazes =
    {
      name = "pf_mirror_mazes", label=_("Mirror Mazes"), choices=PREFAB_CONTROL_HERETIC.FINE_TUNE_MULT_FACTORS
      tooltip="Changes probabilities for hell mirror maze closets and joiners.",
      default="1",
      priority = 45,
      gap = 1,
    }]]

    --

    fab_match_theme =
    {
      name = "fab_match_theme",
      label=("Match Theme"),
      choices=PREFAB_CONTROL_HERETIC.ON_OFF,
      tooltip = "Ensures that prefabs selected match their intended Theme.",
      default = "on",
      priority = 1,
    },
  },
}
