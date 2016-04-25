------------------------------------------------------------------------
--  MODULE: Level Control
------------------------------------------------------------------------
--
--  Copyright (C) 2009      Enhas
--  Copyright (C) 2009-2015 Andrew Apted
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
  "mixed",  _("Mix It Up"),
  "none",   _("NONE"),
  "rare",   _("Rare"),
  "few",    _("Few"),
  "less",   _("Less"),
  "some",   _("Some"),
  "more",   _("More"),
  "heaps",  _("Heaps"),
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
  label = _("Level Control")
  priority = 70

  hooks =
  {
    begin_level = LEVEL_CONTROL.begin_level
  }

  options =
  {
    cages       = { label=_("Cages"),          choices=LEVEL_CONTROL.CHOICES }
    darkness    = { label=_("Dark Outdoors"),  choices=LEVEL_CONTROL.CHOICES }
    doors       = { label=_("Doors"),          choices=LEVEL_CONTROL.CHOICES }
    hallways    = { label=_("Hallways"),       choices=LEVEL_CONTROL.CHOICES }

    keys        = { label=_("Keyed Doors"),    choices=LEVEL_CONTROL.CHOICES }
    liquids     = { label=_("Liquids"),        choices=LEVEL_CONTROL.CHOICES }
    mon_variety = { label=_("Monster Variety"),choices=LEVEL_CONTROL.CHOICES, tooltip="Setting this to NONE will make each level use a single monster type" }
    pictures    = { label=_("Pictures"),       choices=LEVEL_CONTROL.CHOICES }
    secrets     = { label=_("Secrets"),        choices=LEVEL_CONTROL.CHOICES }

    steepness   = { label=_("Steepness"),      choices=LEVEL_CONTROL.CHOICES }
    switches    = { label=_("Switched Doors"), choices=LEVEL_CONTROL.CHOICES }
    teleporters = { label=_("Teleporters"),    choices=LEVEL_CONTROL.CHOICES }
    traps       = { label=_("Traps"),          choices=LEVEL_CONTROL.CHOICES }
    windows     = { label=_("Windows"),        choices=LEVEL_CONTROL.CHOICES }

--  crates      = { label=_("Crates"),         choices=LEVEL_CONTROL.CHOICES }
--  pillars     = { label=_("Pillars"),        choices=LEVEL_CONTROL.CHOICES }
--  porches     = { label=_("Porches"),        choices=LEVEL_CONTROL.CHOICES }

--  big_rooms   = { label=_("Big Rooms"),      choices=LEVEL_CONTROL.CHOICES }
--  closets     = { label=_("Closets"),        choices=LEVEL_CONTROL.CHOICES }
--  ex_floors   = { label=_("3D Floors"),      choices=LEVEL_CONTROL.CHOICES }
--  lakes       = { label=_("Lakes"),          choices=LEVEL_CONTROL.CHOICES }
--  scenics     = { label=_("Scenic Rooms"),   choices=LEVEL_CONTROL.CHOICES }

--  barrels     = { label=_("Barrels"),        choices=LEVEL_CONTROL.CHOICES }
--  bridges     = { label=_("3D Bridges"),     choices=LEVEL_CONTROL.CHOICES }
--  crossovers  = { label=_("Cross-Overs"),    choices=LEVEL_CONTROL.CHOICES }
--  cycles      = { label=_("Multiple Paths"), choices=LEVEL_CONTROL.CHOICES }
--  symmetry    = { label=_("Symmetry"),       choices=LEVEL_CONTROL.CHOICES }
  }
}

