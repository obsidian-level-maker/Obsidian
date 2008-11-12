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


NAMING_THEMES =
{
  TECH =
  {
    patterns =
    {
      ["%a %n"]    = 50, ["%t %a %n"]    = 10,
      ["%b %n"]    = 50, ["%t %b %n"]    = 10,
      ["%a %b %n"] = 50, ["%t %a %b %n"] = 5,

      ["%s"] = 5,
    },

    lexicon =
    {
      t =
      {
        The=90, A=10
      },

      a =
      {
        Large=10, Huge=10, Gigantic=1,
        Small=10, Tiny=2,

        Old=10, Ancient=10, Eternal=2,
        Advanced=8, Futuristic=3, Future=1,
        Fantastic=1, Incredible=1, Amazing=0.5,

        Decrepid=10, Run_Down=5,
        Ruined=5, Forgotten=7, Lost=10, Failed=5,
        Ravished=2, Broken=2, Dead=2, Deadly=4,
        Dirty=2, Filthy=1,
        Deserted=10, Abandoned=10,

        Monstrous=5, Demonic=3, Invaded=1, Overtaken=1,
        Infested=10, Haunted=3, Ghostly=5, Hellish=1,

        Eerie=4, Strange=16, Weird=2, Creepy=1,
        Dark=20, Gloomy=8, Horrible=1,
        Dismal=2, Dreaded=4, Cold=4,

        Underground=5, Subterranean=2,
        Ethereal=5, Floating=2,
        Mars=5, Saturn=5, Jupiter=5,

        Hidden=2, Secret=10, Experimental=1,
        Northern=1, Southern=1, Eastern=1, Western=1,
        Upper=5, Lower=5, Central=5,
        Inner=5, Outer=5, Innermost=1, Outermost=1,
      },

      b =
      {
        Power=10, Hi_Tech=8, Tech=1,
        Star=2, Stellar=2, Solar=2, Lunar=4,
        Space=12, Control=10, Military=10, Security=3,
        Mechanical=3, Rocket=1, Missile=2, Research=10,
        Nukage=3, Slime=3, Toxin=2, Plasma=5,
        Bio_=10, Bionic=2, Nuclear=10, Chemical=7,
        Processing=6, Refueling=3, Metal=1,
        Computer=5, Electronics=1, Electro_=1,
        Industrial=2, Engineering=2, Logic=1,
        Teleport=1, Supply=2, Cryogenic=1,
        Worm_hole=1, Black_hole=1, Robotic=1,
        Magnetic=2, Electrical=2, Proto_=1,
        Slige=1, Waste=1, Optic=1, Time=1, Chrono_=1,
        Alpha=3, Gamma=3, Photon=1, Jedi=1,
        Crystal=2,
      },

      n =
      {
        Generator=15, Plant=20, Base=30,
        Warehouse=20, Lab=10, Laboratory=2,
        Station=30, Tower=20, Center=20,
        Complex=30, Refinery=20, Factory=20,
        Depot=7, Storage=4, Anomaly=1, Area=2,
        Tunnels=3, Zone=8, Sphere=1, Gateway=10,
        Facility=10, Works=1, Outpost=1, Site=1,
        Hanger=1, Portal=2, Installation=1,
        Bunker=1, Device=2, Machine=1, Network=1,
      },

      s =
      {
        ["Power Surge"]=50,
        ["Steel Foundry"]=50,
      },
    },

    divisors =
    {
      a = 5,
      b = 3,
      n = 30,
      s = 10,
    },
  },

  HELL =
  {
    patterns =
    {
      ["%a %n"] = 70, ["%t %a %n"] = 5,
      ["%a %n of %h"] = 20,

      ["%p's %a %n"] = 10,
      ["%p's %n of %h"] = 5,

      ["%s"] = 5,
    },

    lexicon =
    {
      t =
      {
        The=70, A=5
      },

      p =
      {
        Satan=10, ["The Devil"]=10,
      },

      a =
      {
        Large=10, Massive=10, Sprawling=1,
        Small=1, Endless=7,

        Old=10, Ancient=20, Eternal=1,
        Decrepid=10, Desolate=5,
        Ruined=5, Forgotten=7, Lost=10,
        Ravished=2, Barren=4, Deadly=3,
        Dirty=2, Filthy=1,
        Stagnant=3, Rancid=5, Rotten=3,
        Burning=15, Scorching=3, Hot=1, Melting=1,

        Blood=20, Blood_filled=3, Bloody=1,
        Blood_stained=1, Blood_soaked=1,
        Monstrous=15, Monster=4, Zombie=5,
        Demonic=10, Demon=2, Ghoulish=2,
        Haunted=10, Ghostly=15, Ghastly=2,
        Unholy=10, Godless=2, God_forsaken=1,
        Evil=30, Wicked=15, Cruel=5,

        Eerie=10, Strange=20, Weird=2, Creepy=5,
        Gloomy=15, Awful=3, Horrible=5,
        Dismal=10, Dreaded=8, Dank=1, Frightful=1,
        Moan_filled=2, Spooky=10, Nightmare=4,
        Screaming=2,

        Underground=5, Subterranean=1,
        Hidden=1, Secret=1,
        Upper=5, Lower=5,
        Inner=5, Outer=5,
      },

      n =
      {
        Grotto=10, Tomb=10,
        Crypt=20, Chapel=3, Church=1,
        Graveyard=5, Cloister=1,
        Pit=7, Cavern=5, Cave=1,
        Wasteland=10, Fields=1,
        Ghetto=2, City=0.5, Well=1,
        Lair=5, Den=2, Domain=1, Gate=1,
        Valley=4, River=1, Catacombs=1,
        Palace=1, Cathedral=1, Chamber=4,
        Labyrinth=1,
      },

      h =
      {
        Hell = 40, Fire = 25, Flames = 3,
        Horror = 10, Terror = 10, Death = 10,
        Pain = 15, Fear = 5, Hate = 5,
        Limbo = 2, Souls = 10,
        ["the Damned"] = 10,
        ["the Dead"] = 10, ["the Undead"] = 10,
        Darkness = 10, Destruction = 3,
        Suffering = 3, Torment = 5, Torture = 4,
        Twilight = 2, Midnight = 1,
        Flesh = 2, Corpses = 2,
        Whispers = 2, Essel = 1, Tears = 1,
      },

      s =
      {
        ["Skin Graft"]=50,
        ["Meltdown"]=50,
        ["Bloodstains"]=50,
      }
    },

    divisors =
    {
      p = 2,
      a = 5,
      h = 3,
      n = 30,
      s = 10,
    },
  },

--[[ TODO !!!
  URBAN =
  {
  },
--]]
}


NAMING_IGNORE_WORDS =
{
  ["the"]=1, ["a"]=1, ["s"]=1, ["of"]=1,

  ["in"]=1, ["on"]=1, ["to"]=1, ["for"]=1,
}


function Name_fixup(name)
  -- convert "_" to "-"
  name = string.gsub(name, "_ ", "-")
  name = string.gsub(name, "_",  "-")

  -- convert "A" to "AN" where necessary
  name = string.gsub(name, "^[aA] ([aAeEiIoOuU])", "An %1")

  return name
end


function Naming_split_word(tab, word)
  for w in string.gmatch(word, "%a+") do
    if NAMING_IGNORE_WORDS[string.lower(w)] then
      -- ignore it
    else
      -- truncate to 4 letters
      if #w > 4 then
        w = string.sub(w, 1, 4)
      end

      tab[w] = (tab[w] or 0) + 1
    end
  end
end


function Name_from_pattern(DEF)
  local name = ""
  local words = {}

  local pattern = rand_key_by_probs(DEF.patterns)
  local pos = 1

  while pos <= #pattern do
    
    local c = string.sub(pattern, pos, pos)
    pos = pos + 1

    if c ~= "%" then
      name = name .. c
    else
      assert(pos <= #pattern)
      c = string.sub(pattern, pos, pos)
      pos = pos + 1

      if not string.match(c, "%a") then
        error("Bad naming pattern: expected letter after %")
      end

      local lex = DEF.lexicon[c]
      if not lex then
        error("Naming theme is missing letter: " .. c)
      end

      if #name > 0 and string.sub(name,#name,#name) ~= " " then
        name = name .. " "
      end

      local w = rand_key_by_probs(lex)
      name = name .. w

      Naming_split_word(words, w)
    end
  end

  return name, words
end


function Name_cost(words, seen_words)
  local cost = 2 + gui.random()

---##  -- check for duplicate words in the name
---##  for w, count in pairs(words) do
---##    if count > 1 then
---##      cost = cost * 3
---##    end
---##  end

  for w, _ in pairs(words) do
    if seen_words[w] then
      cost = cost * (2 ^ seen_words[w])
    end
  end

  return cost
end


function Name_choose_one(DEF, seen_words)

  local candidates = {}

  for i = 1,20 do
    local name, words = Name_from_pattern(DEF)

    local C =
    {
      name  = name,
      words = words,
      cost  = Name_cost(words, seen_words),
    }

    table.insert(candidates, C)
  end

  table.sort(candidates, function(A,B) return A.cost < B.cost end)

  --[[
  for _,c in ipairs(candidates) do
    gui.debugf("candidate: %1.1f => %s\n", c.cost, c.name)
    gui.debugf("%s\n", table_to_str(c.words, 2))
  end --]]

  local C = candidates[1]

---  gui.debugf("CHOOSEN ---> %s\n", C.name)

  -- remember the words
  for w,_ in pairs(C.words) do
    seen_words[w] = (seen_words[w] or 0) + 1
  end

  return Name_fixup(C.name)
end


function Naming_generate(theme, count)
 
  local defs = deep_copy(NAMING_THEMES)

  if GAME.name_themes then
    deep_merge(defs, GAME.name_themes)
  end
 
  -- !!! FIXME: mods or other sources ???

  local DEF = defs[theme]
  if not DEF then
    error("Naming_generate: unknown theme: " .. tostring(theme))
  end

  local list = {}
  local seen_words = {}

  for i = 1, count do
    local name = Name_choose_one(DEF, seen_words)

    table.insert(list, name)
  end

  return list
end


function Naming_test()
  local list = Naming_generate("TECH", 1000)

  for i,name in ipairs(list) do
    gui.debugf("Name %2d: %s\n", i, name)
  end
end

