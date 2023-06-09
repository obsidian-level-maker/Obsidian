------------------------------------------------------------------------
--  PANEL: Architecture
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
--  Copyright (C) 2019 Armaetus
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
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

UI_SLUMP = { }

UI_SLUMP.MON_VARIETY =
{
  "normal", _("Normal"),
  "shooters", _("Ranged Only"),
  "noflyzone", _("No Fly Zone"),
}

function UI_SLUMP.setup(self)
  
  module_param_up(self)

end

OB_MODULES["ui_slump_arch"] =
{

  name = "ui_slump_arch",

  label = _("Architecture"),

  where = "arch",
  priority = 104,
  port = "limit_enforcing",

  hooks = 
  {
    setup = UI_SLUMP.setup,
  },

  options =
  {
    { 
      name="float_minrooms_slump",
      label=_("Level Size"),
      valuator = "slider",
      min = 10,
      max = 75,
      increment = 1,
      default = 22,
      nan = _("Mix It Up"),
      presets = _("10:10 (Microscopic),16:16 (Miniature),22:22 (Tiny),30:30 (Small),36:36 (Average),42:42 (Large),48:48 (Huge),58:58 (Colossal),66:66 (Gargantuan),75:75 (Transcendent)"),
      tooltip = _("Determines size of map in rooms."),
      priority = 100,
      randomize_group="architecture"
    },
    { 
      name="float_minrooms_slump_ub",
      label=_("Upper Bound"),
      valuator = "slider",
      min = 10,
      max = 75,
      increment = 1,
      default = 36,
      nan = _("Mix It Up"),
      presets = _("10:10 (Microscopic),16:16 (Miniature),22:22 (Tiny),30:30 (Small),36:36 (Average),42:42 (Large),48:48 (Huge),58:58 (Colossal),66:66 (Gargantuan),75:75 (Transcendent)"),
      tooltip = _("Determines maximum map size when using Mix It Up."),
      priority = 99,
      randomize_group="architecture"
    },
    { 
      name="float_minrooms_slump_lb",
      label=_("Lower Bound"),
      valuator = "slider",
      min = 10,
      max = 75,
      increment = 1,
      default = 2,
      nan = _("Mix It Up"),
      presets = _("10:10 (Microscopic),16:16 (Miniature),22:22 (Tiny),30:30 (Small),36:36 (Average),42:42 (Large),48:48 (Huge),58:58 (Colossal),66:66 (Gargantuan),75:75 (Transcendent)"),
      tooltip = _("Determines minimum room size when using Mix It Up."),
      priority = 98,
      randomize_group="architecture"
    },
  }
}

OB_MODULES["misc_slump"] =
{
  name = "misc_slump",

  label = _("Advanced Architecture"),

  port = "limit_enforcing",

  where = "arch",
  priority = 101,

  hooks =
  {
    setup = UI_SLUMP.setup,
  },

  options =
  {

    {
      name = "float_bigify_slump",
      label = _("Room Bigification Chance"),
      valuator = "slider",
      units = _("%"),
      min = 0,
      max = 100,
      increment = 1,
      default = 50,
      tooltip = _("% chance that SLUMP will attempt to increase a room's size."),
      randomize_group="architecture",
    },
    
    {
      name = "float_forkiness_slump",
      label = _("Forkiness"),
      valuator = "slider",
      units = _("%"),
      min = 0,
      max = 100,
      increment = 1,
      default = 75,
      tooltip = _("% chance that a room will attempt to fork as the level grows."),
      longtip = _("0% should look like a bunch of murder hallways. Forking is not guaranteed to succeed, especially if the Room Bigification Chance is increased."),
      randomize_group="architecture",
    },

    {
      name = "bool_dm_starts_slump",
      label = _("Deathmatch Spawns"),
      valuator = "button",
      default = 0,
      tooltip = _("Add Deathmatch starts to generated levels.")
    },
    
    {
      name = "bool_major_nukage_slump",
      label = _("Major Nukage Mode"),
      valuator = "button",
      default = 0,
      tooltip = _("Watch your step!"),
      longtip = _("Will fill most rooms with damaging liquids."),
      randomize_group="architecture",
    },
  
  },
}


OB_MODULES["ui_slump_mons"] =
{

  name = "ui_slump_mons",

  label = _("Combat"),

  where = "combat",
  priority = 103,
  port = "limit_enforcing",

  hooks = 
  {
    setup = UI_SLUMP.setup,
  },

  options =
  {
    {
      name = "slump_mons",
      label = _("Monster Variety"),
      choices = UI_SLUMP.MON_VARIETY,
      default = "normal",
      tooltip = _("Control what types of monsters are available"),
      randomize_group="monsters",
    },

    {
      name = "bool_quiet_start_slump",
      label = _("Quiet Start"),
      valuator = "button",
      default = 1,
      tooltip = _("Prevents monsters from spawning in the starting room."),
      longtip = _("Monsters in other rooms may still have a line of sight to you, so be careful!"),
    }

  }
}



OB_MODULES["slump_all_nazis"] =
{
  name = "slump_all_nazis",

  label = _("Oops! All Nazis!"),

  where = "combat",
  priority = 102,
  port = "limit_enforcing",
  game = "doom2",
  tooltip = _("Populates the level with only SS troopers. This may expand to include pinkies/the Cyberdemon."),
}
