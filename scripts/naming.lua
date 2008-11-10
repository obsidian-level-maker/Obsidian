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
            
            Old=10, Ancient=20,
            Advanced=7, Futuristic=3, Future=1,
            Fantastic=1, Incredible=1,

            Decrepid=10, Run_Down=5,
            Ruined=5, Forgotten=7, Failed=5,
            Ravished=2, Rotten=1,
            Broken=1, Dead=1,
            Dirty=2, Filthy=1,
            Deserted=10, Abandoned=10,

            Monstrous=10, Demonic=3, Invaded=1,
            Infested=10, Haunted=10, Ghostly=10,
            -- Satanic=1, Unholy=1, Godless=1,

            Eerie=5, Strange=16, Weird=2, Creepy=1,
            Dark=20, Gloomy=12, Awful=1, Horrible=1,
            Dismal=2, Dreaded=4,

            Underground=5, Subterranean=2,
            Ethereal=5, Floating=2,
            Hidden=1, Secret=10, Experimental=1,
            Upper=5, Lower=5, Central=5,
            Northern=1, Southern=1, Eastern=1, Western=1,
            Inner=5, Outer=5, Innermost=1, Outermost=1,
          },

      k = { Power=10, Hi_Tech=8, Tech=1,
            Star=2, Stellar=2, Solar=2, Lunar=4,
            Space=10, Control=10, Military=10,
            Machinery=3, Rocket=2, Missile=2, Research=10,
            Nukage=5, Slime=2, Toxin=2, Plasma=4,
            Bio_=10, Bionic=2, Nuclear=8, Chemical=6,
            Processing=6, Refueling=3,
            Computer=4, Electronics=1, Electro_=1,
            Industrial=2, Engineering=2, Logic=1,
            Teleport=2, Supply=2, Cryogenic=1, Chrono_=1,
            Worm_hole=1, Black_hole=1, Robotic=1,
          },

      n = { Generator=15, Plant=20, Base=30,
            Warehouse=20, Lab=10, Laboratory=2,
            Station=30, Tower=20, Center=20,
            Complex=30, Refinery=20, Factory=20,
            Depot=7, Storage=4, Anomaly=1, Area=2,
            Tunnels=3, Zone=8, Sphere=1, Gateway=10,
            Facility=10, Works=1, Outpost=1, Site=1,
            Hanger=1, Portal=2,
          },
    },
  },
}


function Name_fixup(name)
  -- convert "_" to "-"
  name = string.gsub(name, "_ ", "-")
  name = string.gsub(name, "_",  "-")

  -- convert "A" to "AN" where necessary
  name = string.gsub(name, "^[aA] ([aAeEiIoOuU])", "An %1")

  return name
end



function Name_from_pattern(PAT)
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

  return Name_fixup(name)
end


function Naming_test()
  for i = 1,500 do
    local pat = NAME_PATTERNS.TECH_1
    gui.debugf("Name %2d: %s\n", i, Name_from_pattern(pat))
  end
end

