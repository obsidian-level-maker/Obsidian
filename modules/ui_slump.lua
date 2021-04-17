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

UI_SLUMP.SIZES =
{
  "5", _("5 Rooms"),
  "10", _("10 Rooms"),
  "15", _("15 Rooms"),
  "20", _("20 Rooms"),
  "25", _("25 Rooms"),
  "30", _("30 Rooms"),
  "35", _("35 Rooms"),
  "99", _("Surprise Me")
}

UI_SLUMP.BIGIFY=
{
  "0", _("Default"),
  "5", _("Claustrophobic"),
  "25", _("Mostly Small"),
  "50", _("A Good Mix"),
  "75", _("Mostly Large"),
  "101", _("Supersize Me")
}

UI_SLUMP.FORKINESS=
{
  "0", _("None"),
  "25", _("25%"),
  "50", _("50%"),
  "75", _("75%"),
  "101", _("100%")
}

UI_SLUMP.YES_NO =
{
  "yes", _("Yes"),
  "no",  _("No")
}

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
    { name="minrooms", label=_("Level Size"), choices=UI_SLUMP.SIZES,  default="15",
      tooltip = "Minimum number of rooms per level."
    },

    {
      name = "bigify",
      label = _("Average Room Size"),
      choices = UI_SLUMP.BIGIFY,
      default = "0",
      tooltip = "Default will leave things to chance."
    },
    
    {
      name = "forkiness",
      label = _("Forkiness"),
      choices = UI_SLUMP.FORKINESS,
      default = "50",
      tooltip = "Chance that a room will attempt to fork as the level grows. "..
                "'None' should be a bunch of murder hallways."
    },

    {
      name = "dm_starts",
      label = _("Deathmatch Spawns"),
      choices = UI_SLUMP.YES_NO,
      default = "no",
      tooltip = "Add Deathmatch starts to generated levels."
    },
    
    {
      name = "major_nukage",
      label = _("Major Nukage Mode"),
      choices = UI_SLUMP.YES_NO,
      default = "no",
      tooltip = "Watch your step!"
    },
    
    {
      name = "immediate_monsters",
      label = _("Quiet Start"),
      choices = UI_SLUMP.YES_NO,
      default = "yes",
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
