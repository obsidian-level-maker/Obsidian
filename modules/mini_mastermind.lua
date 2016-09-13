------------------------------------------------------------------------
--  MODULE: Smaller Spiderdemon
------------------------------------------------------------------------
--
--  Copyright (C) 2014-2016 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

MINI_MASTERMIND = {}


function MINI_MASTERMIND.setup(self)
  -- this will be checked in engines/boom.lua
  PARAM.mini_mastermind = true
end


OB_MODULES["mini_mastermind"] =
{
  label = _("Smaller Spiderdemon")
  priority = 88

  engine = "boom"

  hooks =
  {
    setup = MINI_MASTERMIND.setup
  }

  tooltip=_(
    "Makes the Spider Mastermind smaller via a DEHACKED lump, " ..
    "which allows her to be placed in maps more often " ..
    "(her default size is so large that there is rarely enough space)")

}

