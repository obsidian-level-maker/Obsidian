------------------------------------------------------------------------
--  MODULE: Level Control
------------------------------------------------------------------------
--
--  Copyright (C) 2009      Enhas
--  Copyright (C) 2009-2014 Andrew Apted
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

LEVEL_CONTROL = { }

LEVEL_CONTROL.CHOICES =
{
  "mixed",  "Mix It Up",
  "none",   "NONE",
  "few",    "Few",
  "some",   "Some",
  "heaps",  "Heaps",
}


function LEVEL_CONTROL.begin_level(self)
  for name,opt in pairs(self.options) do
    local factor = self.options[name].value

    if factor != "mixed" then
      STYLE[name] = factor
    end
  end
end


OB_MODULES["level_control"] =
{
  label = "Level Control"

  hooks =
  {
    begin_level = LEVEL_CONTROL.begin_level
  }

  options =
  {
    big_rooms   = { label="Big Rooms",      choices=LEVEL_CONTROL.CHOICES }
    cages       = { label="Cages",          choices=LEVEL_CONTROL.CHOICES }
    crates      = { label="Crates",         choices=LEVEL_CONTROL.CHOICES }
    darkness    = { label="Dark Outdoors",  choices=LEVEL_CONTROL.CHOICES }
    doors       = { label="Doors",          choices=LEVEL_CONTROL.CHOICES }
    hallways    = { label="Hallways",       choices=LEVEL_CONTROL.CHOICES }
    lakes       = { label="Lakes",          choices=LEVEL_CONTROL.CHOICES }
    liquids     = { label="Liquids",        choices=LEVEL_CONTROL.CHOICES }
    ex_floors   = { label="3D Floors",      choices=LEVEL_CONTROL.CHOICES }

    mon_variety = { label="Monster Variety",choices=LEVEL_CONTROL.CHOICES }
    pictures    = { label="Pictures",       choices=LEVEL_CONTROL.CHOICES }
    pillars     = { label="Pillars",        choices=LEVEL_CONTROL.CHOICES }
    scenics     = { label="Scenic Rooms",   choices=LEVEL_CONTROL.CHOICES }
    secrets     = { label="Secrets",        choices=LEVEL_CONTROL.CHOICES }
    sub_rooms   = { label="Sub-Rooms",      choices=LEVEL_CONTROL.CHOICES }
    steepness   = { label="Steepness",      choices=LEVEL_CONTROL.CHOICES }
    switches    = { label="Switched Doors", choices=LEVEL_CONTROL.CHOICES }
    symmetry    = { label="Symmetry",       choices=LEVEL_CONTROL.CHOICES }
    teleporters = { label="Teleporters",    choices=LEVEL_CONTROL.CHOICES }
    windows     = { label="Windows",        choices=LEVEL_CONTROL.CHOICES }

--  closets     = { label="Closets",        choices=LEVEL_CONTROL.CHOICES }
--  traps       = { label="Traps",          choices=LEVEL_CONTROL.CHOICES }
--  barrels     = { label="Barrels",        choices=LEVEL_CONTROL.CHOICES }
--  bridges     = { label="3D Bridges",     choices=LEVEL_CONTROL.CHOICES }
--  big_juncs   = { label="Big Junctions",  choices=LEVEL_CONTROL.CHOICES }
--  crossovers  = { label="Cross-Overs",    choices=LEVEL_CONTROL.CHOICES }
--  cycles      = { label="Multiple Paths", choices=LEVEL_CONTROL.CHOICES }
--  street_mode = { label="Street Mode",    choices=LEVEL_CONTROL.CHOICES }
  }
}

