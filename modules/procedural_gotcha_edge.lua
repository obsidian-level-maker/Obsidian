------------------------------------------------------------------------
--  MODULE: Procedural Gotcha Fine Tune
------------------------------------------------------------------------
--
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
--  Copyright (C) 2021-2022 Reisal
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

PROCEDURAL_GOTCHA_FINE_TUNE_EDGE = {}

PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.GOTCHA_MAP_SIZES =
{
  "large", _("Large"),
  "regular", _("Regular"),
  "small", _("Small"),
  "tiny", _("Tiny")
}

PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.PROC_GOTCHA_CHOICES =
{
  "final", _("Final Map Only"),
  "epi",   _("Last Level of Episode"),
  "2epi",   _("Two per Episode"),
  "3epi",   _("Three per Episode"),
  "4epi",   _("Four per Episode"),
  "_",     _("_"),
  "5p",    _("5% Chance, Any Map After Map 4"),
  "10p",   _("10% Chance, Any Map After Map 4"),
  "all",   _("Everything")
}

PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.BOSS_LESS_HITSCAN =
{
  "default", _("Default"),
  "less", _("50% less"),
  "muchless", _("80% less"),
  "none", _("100% less"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.ARENA_STEEPNESS =
{
  "none",  _("NONE"),
  "rare",  _("Rare"),
  "few",   _("Few"),
  "less",  _("Less"),
  "some",  _("Some"),
  "mixed", _("Mix It Up"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.BOSS_DIFF_CHOICES =
{
  "easier", _("Easier"),
  "default", _("Moderate"),
  "harder", _("Harder"),
  "nightmare", _("Nightmare"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.BOSS_WEAP =
{
  "scatter", _("Scatter around arena"),
  "close",  _("Close to player start"),
}

PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.BOSS_LIMITS =
{
  "hardlimit",  _("Hard Limit"),
  "softlimit",     _("Soft Limit"),
  "nolimit", _("No Limit"),
}

function PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.setup(self)

  module_param_up(self)

end

function PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.boss_spot(self, spot)

  local x, y = geom.box_mid (spot.x1, spot.y1, spot.x2, spot.y2)

end

OB_MODULES["procedural_gotcha_edge"] =
{
  name = "procedural_gotcha_edge",

  label = _("Procedural Gotchas"),

  port = "edge",
  where = "combat",
  priority = 92,

  hooks =
  {
    setup = PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.setup,
    boss_spot = PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.boss_spot
  },

  tooltip=_("This module allows you to fine tune the Procedural Gotcha experience if you have Procedural Gotchas enabled. Does not affect prebuilts. It is recommended to pick higher scales on one of the two options, but not both at once for a balanced challenge."),

  options =
  {

    {
      name = "header_gotchaoptions",
      label = _("Regular Gotcha Options"),
    },

     {
      name="gotcha_frequency",
      label=_("Gotcha Frequency"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.PROC_GOTCHA_CHOICES,
      default="final",
      tooltip = _("Procedural Gotchas are two room maps, where the second is an immediate but immensely-sized exit room with gratitiously intensified monster strength. Essentially an arena - prepare for a tough, tough fight!\n\nNotes:\n\n5% of levels may create at least 1 or 2 gotcha maps in a standard full game."),
      priority = 106,
      
      gap = 1
    },

    {
      name = "bool_gotcha_boss_fight",
      label=_("Force Big-Boss Fight"),
      valuator = "button",
      default = 1,
      tooltip = _("Attempts to guarantee a fight against a boss-type (nasty tier) monster in the procedural gotcha."),
      priority = 105,
      
      gap = 1
    },

    {
      name="float_gotcha_qty",
      label=_("Extra Quantity"),
      valuator = "slider",
      units = _("x Monsters"),
      min = 0.2,
      max = 10,
      increment = 0.1,
      default = 1.2,
      tooltip = _("Offset monster strength from your default quantity of choice plus the increasing level ramp. If your quantity choice is to reduce the monsters, the monster quantity will cap at a minimum of 0.1 (Scarce quantity setting)."),
      priority = 104,
      
    },

    {
      name="float_gotcha_strength",
      label=_("Extra Strength"),
      valuator = "slider",
      min = 0,
      max = 16,
      increment = 1,
      default = 4,
      presets = _("0:NONE,2:2 (Stronger),4:4 (Harder),6:6 (Tougher),8:8 (CRAZIER),16:16 (NIGHTMARISH)"),
      tooltip = _("Offset monster quantity from your default strength of choice plus the increasing level ramp."),
      priority = 103,
      
    },


    {
      name="gotcha_map_size",
      label=_("Map Size"),
      choices=PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.GOTCHA_MAP_SIZES,
      default = "small",
      tooltip = _("Size of the procedural gotcha. Start and arena room sizes are relative to map size as well."),
      priority = 102,
      
      gap = 1
    },

    {
      name = "header_bossoptions",
      label = _("DDF Generated Boss Options"),
    },

    {
      name = "bool_boss_gen",
      label=_("Enable Procedural Bosses"),
      valuator = "button",
      default = 1,
      tooltip = _("Toggles Boss Monster generation with special traits for Gotchas."),
      priority = 101,
    },

    {
      name = "boss_gen_steepness",
      label = _("Arena Steepness"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.ARENA_STEEPNESS,
      default = "none",
      tooltip = _("Influences steepness settings for boss arenas. Boss arena steepness is capped to be less intrusive to boss movement."),
      priority = 99,
      gap = 1,
      
    },

    {
      name = "boss_gen_diff",
      label = _("Boss Tier"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.BOSS_DIFF_CHOICES,
      default = "default",
      tooltip = _("Increases or reduces chances of boss being based off of a more powerful monster."),
      priority = 98,
      
    },

    {
      name = "float_boss_gen_mult",
      label = _("Boss Health Multiplier"),
      tooltip = _("Makes boss health higher or lower than default, useful when playing with mods that have different average power level of weapons."),
      valuator = "slider",
      units = _("x"),
      min = 0.25,
      max = 5,
      increment = 0.25,
      default = 1,
      priority = 97,
      
    },

    {
      name = "boss_gen_hitscan",
      label = _("Hitscan Bosses"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.BOSS_LESS_HITSCAN,
      default = "default",
      tooltip = _("Reduces chance of hitscan bosses spawning."),
      priority = 96,
      
    },

    {
      name = "bool_boss_gen_types",
      label = _("Respect zero prob"),
      priority = 96,
      valuator = "button",
      default = 0,
      tooltip = _("If enabled, monsters disabled in monster control module cant be chosen as a boss."),
      priorty = 91,
      gap = 1,
      
    },

    {
      name = "boss_gen_typelimit",
      label = _("Monster limit type"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.BOSS_LIMITS,
      default = "softlimit",
      tooltip = _("Influences how boss difficulty and megawad progression affects the monster type of boss.\n\nHard Limit: Doesn't allow monster types outside of range to ever spawn.\n\nSoft Limit: Reduces the probability of spawning of monster types outside of range.\n\nNo Limit: Difficulty doesn't have effect on monster type selection."),
      priority = 90,
      
    },


    {
      name = "boss_gen_weap",
      label = _("Weapon placement"),
      choices = PROCEDURAL_GOTCHA_FINE_TUNE_EDGE.BOSS_WEAP,
      default = "scatter",
      tooltip = _("Influences weapon placement in boss arena."),
      priority = 89,
      gap = 1,
      
    },

    {
      name = "float_boss_gen_ammo",
      label = _("Ammo supplies mult"),
      valuator = "slider",
      units = _("x"),
      min = 1,
      max = 5,
      increment = 1,
      default = 3,
      tooltip = _("Changes multiplier of ammunition items on the boss arena(This is also affected by boss health multiplier)."),
      priority = 87,
      
    },


    {
      name = "float_boss_gen_heal",
      label = _("Healing supplies mult"),
      valuator = "slider",
      units = _("x"),
      min = 1,
      max = 5,
      increment = 1,
      default = 3,
      tooltip = _("Changes multiplier of healing items on the boss arena."),
      priority = 86,
      
    },
  },
}
