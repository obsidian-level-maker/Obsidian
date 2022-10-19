------------------------------------------------------------------------
--  MODULE: Miscellaneous Stuff
------------------------------------------------------------------------
--
--  Copyright (C) 2009 Enhas
--  Copyright (C) 2009-2017 Andrew Apted
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

MISC_STUFF_WOLF_3D = { }

MISC_STUFF_WOLF_3D.ROOM_SIZE_MULTIPLIER_CHOICES =
{
  "0.33", _("x0.33"),
  "0.66", _("x0.66"),
  "1", _("x1"),
  "1.33", _("x1.33"),
  "1.66", _("x1.66"),
  "mixed", _("Mix It Up")
}

function MISC_STUFF_WOLF_3D.setup(self)
  
  module_param_up(self)

end

OB_MODULES["misc_wolf_3d"] =
{

  name = "misc_wolf_3d",

  label = _("Advanced Architecture"),

  engine = "wolf_3d",

  side = "left",
  priority = 101,

  hooks =
  {
    setup = MISC_STUFF_WOLF_3D.setup,
    begin_level = MISC_STUFF_WOLF_3D.begin_level
  },

  options =
  {

    {
      name="room_size_multiplier_wolf_3d", 
      label=_("Room Size Multiplier"),
      choices = MISC_STUFF_WOLF_3D.ROOM_SIZE_MULTIPLIER_CHOICES,
      default = "1",
      tooltip = _("Alters the general size and ground coverage of rooms.\n\nMix It Up: All multiplier ranges are randomly used with highest and lowest multipliers being rarest."),
      priority = 94,
      randomize_group="architecture",
    },
  
  },
}
