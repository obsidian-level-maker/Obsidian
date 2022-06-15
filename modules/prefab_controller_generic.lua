------------------------------------------------------------------------
--  MODULE: prefab spawn quantity controller
------------------------------------------------------------------------
--
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
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

PREFAB_CONTROL_GENERIC = { }

PREFAB_CONTROL_GENERIC.WALL_CHOICES =
{
  "fab_default", _("DEFAULT"),
  "fab_some",    _("Some"),
  "fab_less",    _("Less"),
  "fab_few",     _("Few"),
  "fab_rare",    _("Rare"),
  "fab_random",  _("Mix It Up"),
}

PREFAB_CONTROL_GENERIC.WALL_REDUCTION_ODDS =
{
  fab_some = 0.2,
  fab_less = 0.4,
  fab_few = 0.6,
  fab_rare = 0.8,
  fab_none = 1
}

PREFAB_CONTROL_GENERIC.POINT_CHOICES =
{
  "fab_none",    _("NONE"),
  "fab_rare",    _("Rare"),
  "fab_few",     _("Few"),
  "fab_default", _("DEFAULT"),
  "fab_more",    _("More"),
  "fab_heaps",   _("Heaps"),
}

PREFAB_CONTROL_GENERIC.WALL_GROUP_ODDS =
{
  fab_always = 100,
  fab_heaps = 2.25,
  fab_lots = 1.8,
  fab_more = 1.35,
  fab_default = 1,
  fab_some = 0.8,
  fab_less = 0.6,
  fab_few = 0.4,
  fab_rare = 0.2,
  fab_none = 0,
}

function PREFAB_CONTROL_GENERIC.setup(self)
  
  module_param_up(self)

end

----------------------------------------------------------------

OB_MODULES["prefab_control_generic"] =
{

  name = "prefab_control_generic",

  label = _("Advanced Level Control"),

  side = "left",
  priority = 93,

  game = { doom1=0, doom2=0, chex3=1, hacx=1, heretic=1, harmony=1, hexen=1, strife=1 },
  engine = "!vanilla",

  hooks =
  {
    setup = PREFAB_CONTROL_GENERIC.setup
  },

  options =
  {

    {
      name = "bool_autodetail",
      label=("Auto Detailing"),
      valuator = "button",
      default = 1,
      tooltip = "Reduces the amount of complex architecture in a map based on its size. Default is on.",
      priority = 102,
      gap = 1,
    },


    {
      name = "point_prob",
      label=_("Decor"),
      choices=PREFAB_CONTROL_GENERIC.POINT_CHOICES,
      tooltip = "Decor prefabs are prefabs placed along the floors such as crates, pillars, and other decorative elements which aren't tied to walls. This directly modifies probabilities on a per-room basis, not the density for decor prefabs in any given room.\n\nNote: DEFAULT actually behaves like Mix-It-Up.",
      default = "fab_default",
      priority = 101,
      randomize_group = "architecture"
    },

    {
      name = "wall_prob",
      label=_("Walls"),
      choices=PREFAB_CONTROL_GENERIC.WALL_CHOICES,
      tooltip = "Determines the amount plain wall prefabs. What it actually does is greatly increase the probability of Oblige's basic plain wall prefab, rather than reduce the probability of all the prefabs in the library.",
      default = "fab_default",
      priority = 100,
      gap = 1,
      randomize_group = "architecture"
    },

    {
      name = "bool_fab_match_theme",
      label=("Match Theme"),
      valuator = "button",
      default = 1,
      tooltip = "Ensures that prefabs selected match their intended Theme.",
      priority = 1,
      randomize_group="architecture",
    },
  },
}
