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

  begin_level_func = Level_Control_begin_level,

  options =
  {
    hallways   = { label="Hallways", priority = 21, choices=LEVEL_CONTROL_CHOICES },
    liquids    = { label="Liquids",  priority = 20, choices=LEVEL_CONTROL_CHOICES },
    subrooms   = { label="Sub-Rooms",priority = 19, choices=LEVEL_CONTROL_CHOICES },
    naturals   = { label="Natural Areas", priority = 17, choices=LEVEL_CONTROL_CHOICES },
    lakes      = { label="Lakes",    priority = 16, choices=LEVEL_CONTROL_CHOICES },

    symmetry   = { label="Symmetry", priority = 15, choices=LEVEL_CONTROL_CHOICES },
    pillars    = { label="Pillars",  priority = 14, choices=LEVEL_CONTROL_CHOICES },
    beams      = { label="Beams",    priority = 13, choices=LEVEL_CONTROL_CHOICES },
    barrels    = { label="Barrels",  priority = 12, choices=LEVEL_CONTROL_CHOICES },

    windows    = { label="Windows",  priority = 11, choices=LEVEL_CONTROL_CHOICES },
    pictures   = { label="Pictures", priority = 10, choices=LEVEL_CONTROL_CHOICES },
    cages      = { label="Cages",    priority =  9, choices=LEVEL_CONTROL_CHOICES },
    fences     = { label="Fences",   priority =  8, choices=LEVEL_CONTROL_CHOICES },
    crates     = { label="Crates",   priority =  7, choices=LEVEL_CONTROL_CHOICES },
    scenics    = { label="Scenics",  priority =  5, choices=LEVEL_CONTROL_CHOICES },

    favor_shape = { label ="Favor Shape", priority = 3, choices=LEVEL_CONTROL_SHAPES },
  }, 
}

