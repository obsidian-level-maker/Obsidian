------------------------------------------------------------------------
--  MODULE: Level Control
------------------------------------------------------------------------
--
--  Copyright (C) 2009      Enhas
--  Copyright (C) 2009-2016 Andrew Apted
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
  label = _("Level Control")

  side = "left"
  priority = 70

  hooks =
  {
    begin_level = LEVEL_CONTROL.begin_level
  }

  options =
  {
    big_rooms   = { label=_("Big Rooms"),      choices=STYLE_CHOICES }
--  cages       = { label=_("Cages"),          choices=STYLE_CHOICES }
    darkness    = { label=_("Dark Outdoors"),  choices=STYLE_CHOICES }
    doors       = { label=_("Doors"),          choices=STYLE_CHOICES }

    keys        = { label=_("Keyed Doors"),    choices=STYLE_CHOICES }
--  liquids     = { label=_("Liquids"),        choices=STYLE_CHOICES }
--  mon_variety = { label=_("Monster Variety"),choices=STYLE_CHOICES, tooltip="Setting this to NONE will make each level use a single monster type" }

--  secrets     = { label=_("Secrets"),        choices=STYLE_CHOICES }
--  steepness   = { label=_("Steepness"),      choices=STYLE_CHOICES }
    switches    = { label=_("Switched Doors"), choices=STYLE_CHOICES }

--  teleporters = { label=_("Teleporters"),    choices=STYLE_CHOICES }
--  traps       = { label=_("Traps"),          choices=STYLE_CHOICES }
    windows     = { label=_("Windows"),        choices=STYLE_CHOICES }

---- PLANNED (UNFINISHED) STUFF ----

--  hallways    = { label=_("Hallways"),       choices=STYLE_CHOICES }
--  symmetry    = { label=_("Symmetry"),       choices=STYLE_CHOICES }
--  pictures    = { label=_("Pictures"),       choices=STYLE_CHOICES }
--  cycles      = { label=_("Multiple Paths"), choices=STYLE_CHOICES }
--  ex_floors   = { label=_("3D Floors"),      choices=STYLE_CHOICES }

--  barrels     = { label=_("Barrels"),        choices=STYLE_CHOICES }
--  porches     = { label=_("Porches"),        choices=STYLE_CHOICES }
--  lakes       = { label=_("Lakes"),          choices=STYLE_CHOICES }
--  bridges     = { label=_("3D Bridges"),     choices=STYLE_CHOICES }
--  crossovers  = { label=_("Cross-Overs"),    choices=STYLE_CHOICES }
  }
}

