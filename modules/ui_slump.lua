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
  "5",    _("5 Rooms"),
  "10",    _("10 Rooms"),
  "15",  _("15 Rooms"),
  "20",    _("20 Rooms"),
  "25",     _("25 Rooms"),
  "30", _("30 Rooms"),
  "35",   _("35 Rooms"),
}

UI_SLUMP.YES_NO =
{
  "yes", _("Yes"),
  "no",  _("No")
}

OB_MODULES["ui_slump_left"] =
{
  label = _("SLUMP Options"),

  side = "left",
  priority = 104,
  engine = "vanilla",

  options =
  {
    { name="minrooms", label=_("Level Size"), choices=UI_SLUMP.SIZES,  default="15",
      tooltip = "Minimum number of rooms per level."
    },

    {
      name = "dm_starts",
      label = _("Deathmatch Starts"),
      choices = UI_SLUMP.YES_NO,
      default = "no",
      tooltip = "Add Deathmatch starts to generated levels."
    },
  }
}
