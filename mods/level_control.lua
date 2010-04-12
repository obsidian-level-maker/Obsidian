----------------------------------------------------------------
--  MODULE: Level Control
----------------------------------------------------------------
--
--  Copyright (C) 2009 Enhas
--  Copyright (C) 2009 Andrew Apted
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
----------------------------------------------------------------

LEVEL_CONTROL_CHOICES =
{
  "mixed",  "Mix It Up",
  "none",   "NONE",
  "few",    "Few",
  "some",   "Some",
  "heaps",  "Heaps",
}

LEVEL_CONTROL_SHAPES =
{
  "mixed",  "Mix It Up",
  "none",   "NONE",
  "L",      "L",
  "T",      "T",
  "O",      "O",
  "S",      "S",
  "X",      "X",
}


function Level_Control_begin_level(self)
  for name,opt in pairs(self.options) do
    local factor = self.options[name].value

    if factor ~= "mixed" then
      STYLE[name] = factor
    end
  end
end


OB_MODULES["level_control"] =
{
  label = "Level Control",

  hooks =
  {
    begin_level = Level_Control_begin_level,
  },

  options =
  {
    barrels    = { label="Barrels",        choices=LEVEL_CONTROL_CHOICES },
    beams      = { label="Beams",          choices=LEVEL_CONTROL_CHOICES },
    cages      = { label="Cages",          choices=LEVEL_CONTROL_CHOICES },
    crates     = { label="Crates",         choices=LEVEL_CONTROL_CHOICES },
    fences     = { label="Fences",         choices=LEVEL_CONTROL_CHOICES },
    hallways   = { label="Hallways",       choices=LEVEL_CONTROL_CHOICES },
    lakes      = { label="Lakes",          choices=LEVEL_CONTROL_CHOICES },
    liquids    = { label="Liquids",        choices=LEVEL_CONTROL_CHOICES },
    naturals   = { label="Natural Areas",  choices=LEVEL_CONTROL_CHOICES },
    pictures   = { label="Pictures",       choices=LEVEL_CONTROL_CHOICES },
    pillars    = { label="Pillars",        choices=LEVEL_CONTROL_CHOICES },
    scenics    = { label="Scenics",        choices=LEVEL_CONTROL_CHOICES },
    subrooms   = { label="Sub-Rooms",      choices=LEVEL_CONTROL_CHOICES },
    switches   = { label="Switches / Keys",choices=LEVEL_CONTROL_CHOICES },
    symmetry   = { label="Symmetry",       choices=LEVEL_CONTROL_CHOICES },
    windows    = { label="Windows",        choices=LEVEL_CONTROL_CHOICES },

    favor_shape = { label ="Favor Shape", priority = 1, choices=LEVEL_CONTROL_SHAPES },
  }, 
}

