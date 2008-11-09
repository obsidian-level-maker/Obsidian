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
  TECH_1 =
  {
    pattern = "%5t%7a%6k%n",
    prob = 90,

    words =
    {
      t = { The=90, A=10 },

      a = { -- FIXME: sizes should reflect level size
            Large=10, Huge=10, Gigantic=1,
            Small=10, Tiny=2,
            
            Old=10, Ancient=20, Futuristic=20,
            Fantastic=1, Incredible=1,

            Decrepid=10, Run_Down=10, Ravished=2,
            Ruined=5, Broken=1, Dead=1, Deserted=3,
            Rotten=1,

            Monstrous=10, Demonic=10,
            Infested=10, Haunted=10, Ghostly=10,
            Satanic=1, Unholy=5,

            Eerie=10, Strange=20, Weird=2, Creepy=1,
            Dark=20, Gloomy=5, Awful=1, Horrible=1,
            Dismal=2,

            Underground=5, Subterranean=2,
            Ethereal=5, Floating=2, Stellar=2,
            Hidden=1, Secret=10, Experimental=1,
            Central=5,
          },

      k = { Power=10, Hi_Tech=8, Tech=2,
            Space=10, Control=10, Military=10,
            Machinery=5, Rocket=5, Research=10,
            Nukage=5, Slime=1, Toxin=2, Plasma=2,
            Bio_=10, Bionic=1, Processing=6,
            Computer=4, Electronics=1, Refueling=3,
            Industrial=2,
          },

      n = { Generator=20, Plant=20, Base=30,
            Warehouse=20, Lab=20, Laboratory=2,
            Station=30, Tower=20, Center=30,
            Complex=30, Refinery=20, Factory=20,
            Depot=4, Storage=4, Anomaly=1, Area=4,
            Tunnels=4, Zone=7, Sphere=1, Gateway=7,
            Facility=5,
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
  for i = 1,500 do
    local pat = NAME_PATTERNS.TECH_1
    gui.debugf("Name %2d: %s\n", i, name_from_pattern(pat))
  end
end

