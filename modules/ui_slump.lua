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

  label = _("SLUMP Architecture"),

  side = "left",
  priority = 104,
  engine = "vanilla",

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
      units = " Rooms",
      min = 1,
      max = 37,
      increment = 1,
      default = 15,
      nan = _("Mix It Up"),
      tooltip = _("Minimum number of rooms per level."),
      randomize_group="architecture",
    },

    {
      name = "float_bigify_slump",
      label = _("Room Bigification Chance"),
      valuator = "slider",
      units = "%",
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
      units = "%",
      min = 0,
      max = 100,
      increment = 1,
      default = 50,
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
    
    {
      name = "bool_immediate_monsters_slump",
      label = _("Quiet Start"),
      valuator = "button",
      default = 1,
      tooltip = _("Prevents monsters from spawning in the starting room."),
      longtip = _("Monsters in other rooms may still have a line of sight to you, so be careful!"),
    }
  }
}

OB_MODULES["ui_slump_mons"] =
{

  name = "ui_slump_mons",

  label = _("SLUMP Monsters"),

  side = "right",
  priority = 103,
  engine = "vanilla",

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
  }
}

OB_MODULES["slump_all_nazis"] =
{

  name = "slump_all_nazis",

  label = _("Oops! All Nazis!"),

  side = "right",
  priority = 102,
  engine = "vanilla",
  game = "doom2",
  tooltip = _("Populates the level with only SS troopers. This may expand to include pinkies/the Cyberdemon."),

  hooks = 
  {
    setup = UI_SLUMP.setup,
  },
}
