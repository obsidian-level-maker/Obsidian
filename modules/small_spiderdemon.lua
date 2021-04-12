------------------------------------------------------------------------
--  MODULE: Smaller Spiderdemon
------------------------------------------------------------------------
--
--  Copyright (C) 2014-2016 Andrew Apted
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

-- MSSP: Disabled for now - honestly will convert it to an external addon instead.

--[[SMALL_SPIDERDEMON = {}


function SMALL_SPIDERDEMON.setup(self)
  -- this will be checked in engines/boom.lua
  PARAM.small_spiderdemon = true
end


OB_MODULES["small_spiderdemon"] =
{
  label = _("Smaller Spiderdemon"),

  game = "doomish",

  side = "left",
  priority = 5,

  engine = "boom",

  hooks =
  {
    setup = SMALL_SPIDERDEMON.setup
  },

  tooltip=_(
    "Makes the Spider Mastermind smaller via a DEHACKED lump, " ..
    "which allows her to be placed in maps more often " ..
    "(her default size is so large that there is rarely enough space)")

}]]

  -- honor the "Smaller Mastermind" module, use the DEHACKED lump to
  -- reduce the size of the Spider Mastermind monster from 128 to 80
  -- units so that she fits more reliably on maps.
--[[  if PARAM.small_spiderdemon then
    table.insert(data, "Thing 20 (Spiderdemon)\n")
    table.insert(data, "Width = 5242880\n")  -- 80 units
    table.insert(data, "\n")
  end

  -- honor the "Smaller Mastermind" module
  if PARAM.small_spiderdemon then
    local info = GAME.MONSTERS["Spiderdemon"]
    if info and info.r > 80 then
      info.r = 80
    end
  end
]]