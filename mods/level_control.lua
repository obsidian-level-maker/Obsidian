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

LEVEL_CONTROL_CHOICES_A =
{
  "mixed",  "Mix It Up",
  "few",    "Few",
  "some",   "Some",
  "heaps",  "Heaps",
}

LEVEL_CONTROL_CHOICES_B =
{
  "mixed",  "Mix It Up",
  "none",   "NONE",
  "some",   "Some",
  "heaps",  "Heaps",
}

LEVEL_CONTROL_CHOICES_D =
{
  "mixed",  "Mix It Up",
  "none",   "NONE",
  "few",    "Few",
  "some",   "Some",
}

LEVEL_CONTROL_CHOICES_F =
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
      LEVEL.style[name] = factor
    end
  end
end


OB_MODULES["level_control"] =
{
  label = "Level Control",

  begin_level_func = Level_Control_begin_level,

  options =
  {
    hallways   = { label="Hallways", priority = 21, choices=LEVEL_CONTROL_CHOICES_A },
    liquids    = { label="Liquids",  priority = 20, choices=LEVEL_CONTROL_CHOICES_A },
    subrooms   = { label="Sub-Rooms",priority = 19, choices=LEVEL_CONTROL_CHOICES_B },
    scenics    = { label="Scenics",  priority = 18, choices=LEVEL_CONTROL_CHOICES_A },

    symmetry   = { label="Symmetry", priority = 15, choices=LEVEL_CONTROL_CHOICES_A },
    pillars    = { label="Pillars",  priority = 14, choices=LEVEL_CONTROL_CHOICES_A },
    beams      = { label="Beams",    priority = 13, choices=LEVEL_CONTROL_CHOICES_A },
    barrels    = { label="Barrels",  priority = 12, choices=LEVEL_CONTROL_CHOICES_A },

    windows    = { label="Windows",  priority = 11, choices=LEVEL_CONTROL_CHOICES_A },
    pictures   = { label="Pictures", priority = 10, choices=LEVEL_CONTROL_CHOICES_A },
    cages      = { label="Cages",    priority =  9, choices=LEVEL_CONTROL_CHOICES_B },
    fences     = { label="Fences",   priority =  8, choices=LEVEL_CONTROL_CHOICES_D },
    crates     = { label="Crates",   priority =  7, choices=LEVEL_CONTROL_CHOICES_B },

    favor_shape = { label ="Favor Shape", priority = 3, choices=LEVEL_CONTROL_CHOICES_F },
  }, 
}

