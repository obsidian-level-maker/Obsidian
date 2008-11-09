----------------------------------------------------------------
--  Name Generator
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2008 Andrew Apted
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

require 'util'


NAME_PATTERNS =
{
  SIMPLE =
  {
    pattern = "%4t%5a%5k%n",
    prob = 90,

    words =
    {
      t = { The=90, A=5 },

      a = { Big=10, Large=10, Huge=10, Enormous=5, Gigantic=2,
            Monstrous=10, Demonic=10,
            Small=10, Tiny=2,
            Old=20, Ancient=20, Futuristic=20,
            Decrepid=10, Run_Down=10,
            Infested=10, Haunted=10, Ghostly=10,
            Eerie=10, Strange=20,
            Dark=30,
          },

      k = { Power=10, Tech=5, Space=10, Hi_Tech=5,
            Control=10, Military=10, Nukage=5,
          },

      n = { Generator=50, Plant=60, Base=50, 
            Warehouse=20, Lab=20, Laboratory=2,
            Station=30, Tower=20, Center=50,
          },
    },
  },
}


function name_from_pattern(PAT)
  local name = ""

  local pos = 1

  while pos <= #PAT.pattern do
    
    local c = string.sub(PAT.pattern, pos, pos)
    pos = pos + 1

    local chance = 100

    if c ~= "%" then
      name = name .. c
    else
      assert(pos <= #PAT.pattern)
      c = string.sub(PAT.pattern, pos, pos)
      pos = pos + 1

      if string.match(c, "%d") then
        chance = (0 + c) * 10

        assert(pos <= #PAT.pattern)
        c = string.sub(PAT.pattern, pos, pos)
        pos = pos + 1
      end

      if not string.match(c, "%a") then
        error("Bad pattern: expected letter after %")
      end

      if rand_odds(chance) then
        local words = PAT.words[c]
        if not words then
          error("Pattern is missing word: " .. c)
        end

        if #name > 0 then
          name = name .. " "
        end

        local w = rand_key_by_probs(words)
        name = name .. w
      end
    end
  end
  
  return name
end


function Naming_test()
  for i = 1,200 do
    local pat = NAME_PATTERNS.SIMPLE
    gui.debugf("Name %2d: %s\n", i, name_from_pattern(pat))
  end
end

