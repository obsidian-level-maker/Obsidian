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
  "nazis", _("Oops! All Nazis!")
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
      nan = "Mix It Up",
      presets = "",
      tooltip = "Minimum number of rooms per level.",
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
      presets = "",
      tooltip = "% chance that SLUMP will attempt to increase a room's size.",
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
      presets = "",
      tooltip = "% chance that a room will attempt to fork as the level grows.",
      longtip = "0% should look like a bunch of murder hallways. Forking is not guaranteed " ..
                "to succeed, especially if the Room Bigification Chance is increased.",
      randomize_group="architecture",
    },

    {
      name = "bool_dm_starts_slump",
      label = _("Deathmatch Spawns"),
      valuator = "button",
      default = 0,
      tooltip = "Add Deathmatch starts to generated levels."
    },
    
    {
      name = "bool_major_nukage_slump",
      label = _("Major Nukage Mode"),
      valuator = "button",
      default = 0,
      tooltip = "Watch your step!",
      longtip = "Will fill most rooms with damaging liquids.",
      randomize_group="architecture",
    },
    
    {
      name = "bool_immediate_monsters_slump",
      label = _("Quiet Start"),
      valuator = "button",
      default = 1,
      tooltip = "Prevents monsters from spawning in the starting room.",
      longtip = "Monsters in other rooms may still have" ..
      " a line of sight to you, so be careful!",
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
      tooltip = "Control what types of monsters are available",
      randomize_group="monsters",
    },
  }
}
