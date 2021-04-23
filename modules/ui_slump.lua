------------------------------------------------------------------------
--  PANEL: Architecture
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
--  Copyright (C) 2019 Armaetus
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
------------------------------------------------------------------------

UI_SLUMP = { }

UI_SLUMP.MON_VARIETY =
{
  "normal", _("Normal"),
  "shooters", _("Ranged Only"),
  "noflyzone", _("No Fly Zone"),
  "nazis", _("Oops! All Nazis!")
}

OB_MODULES["ui_slump_arch"] =
{
  label = _("SLUMP Architecture"),

  side = "left",
  priority = 104,
  engine = "vanilla",

  options =
  {
    { name="float_minrooms",
      label=_("Level Size"),
      valuator = "slider",
      units = " Rooms",
      min = 2,
      num_min = 2,
      max = 37,
      increment = 1,
      default = 15,
      nan = "",
      tooltip = "Minimum number of rooms per level."
    },

    {
      name = "float_bigify",
      label = _("Room Bigification Chance"),
      valuator = "slider",
      units = "%",
      min = 0,
      num_min = 0,
      max = 100,
      increment = 1,
      default = 50,
      nan = "",
      tooltip = "% chance that SLUMP will attempt to grow a room."
    },
    
    {
      name = "float_forkiness",
      label = _("Forkiness"),
      valuator = "slider",
      units = "%",
      min = 0,
      num_min = 0,
      max = 100,
      increment = 1,
      default = 50,
      nan = "",
      tooltip = "% chance that a room will attempt to fork as the level grows. "..
                "0% should be a bunch of murder hallways. Forks are not guaranteed " ..
                "to succeed, especially if the room bigification chance is increased."
    },

    {
      name = "bool_dm_starts",
      label = _("Deathmatch Spawns"),
      valuator = "button",
      default = 0,
      tooltip = "Add Deathmatch starts to generated levels."
    },
    
    {
      name = "bool_major_nukage",
      label = _("Major Nukage Mode"),
      valuator = "button",
      default = 0,
      tooltip = "Watch your step!"
    },
    
    {
      name = "bool_immediate_monsters",
      label = _("Quiet Start"),
      valuator = "button",
      default = 1,
      tooltip = "Prevents monsters from spawning in the starting room. Monsters in other rooms may still have" ..
                " a line of sight to you, so be careful!"
    }
  }
}

OB_MODULES["ui_slump_mons"] =
{
  label = _("SLUMP Monsters"),

  side = "right",
  priority = 104,
  engine = "vanilla",

  options =
  {
    {
      name = "slump_mons",
      label = _("Monster Variety"),
      choices = UI_SLUMP.MON_VARIETY,
      default = "normal",
      tooltip = "Control what types of monsters are available"
    },
  }
}
