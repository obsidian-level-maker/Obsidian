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
--
--  Thanks to "JohnnyRancid" who contributed most of the
--  complete level names and a lot of cool words.
--
----------------------------------------------------------------

require 'util'


NAMING_THEMES =
{
  TECH =
  {
    patterns =
    {
      ["%a %n"]    = 50, ["%t %a %n"]    = 15,
      ["%b %n"]    = 50, ["%t %b %n"]    = 15,
      ["%a %b %n"] = 50, ["%t %a %b %n"] = 5,

      ["%s"] = 20,
    },

    lexicon =
    {
      t =
      {
        The=50
      },

      a =
      {
        Large=10, Huge=10, Gigantic=1,
        Small=10, Tiny=2,

        Old=10, Ancient=10, Eternal=2,
        Advanced=8, Futuristic=3, Future=1,
        Fantastic=1, Incredible=1, Amazing=0.5,

        Decrepid=10, Run_Down=5,
        Lost=10, Ruined=5, Forgotten=7, Failed=5,
        Ravished=2, Broken=2, Dead=2, Deadly=4,
        Dirty=2, Filthy=1,
        Deserted=10, Abandoned=10,

        Monstrous=5, Demonic=3, Invaded=1, Overtaken=1,
        Infested=10, Haunted=3, Ghostly=5, Hellish=1,
        Subverted=10, Corrupted=1,

        Strange=16, Eerie=4, Weird=2, Creepy=1,
        Dark=20, Gloomy=8, Horrible=1,
        Dismal=2, Dreaded=4, Cold=4,

        Underground=5, Sub_terran=2,
        Ethereal=5, Floating=2,
        Mars=5, Saturn=5, Jupiter=5, Io=1,

        Secret=10, Hidden=2, Experimental=1,
        Northern=1, Southern=1, Eastern=1, Western=1,
        Upper=5, Lower=5, Central=5,
        Inner=5, Outer=5, Innermost=1, Outermost=1,
      },

      b =
      {
        Power=10, Hi_Tech=8, Tech=1, Energy=5,
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
        Crystal=2, Defense=1, Manufacturing=1,
      },

      n =
      {
        Generator=12, Plant=20, Base=30,
        Warehouse=20, Lab=10, Laboratory=2,
        Station=30, Tower=15, Center=15,
        Complex=30, Refinery=15, Factory=10,
        Depot=7, Storage=3, Anomaly=2, Area=2,
        Tunnels=5, Zone=8, Sphere=0.5, Gateway=10,
        Facility=10, Works=1, Outpost=1, Site=1,
        Hanger=1, Portal=2, Installation=1,
        Bunker=1, Device=2, Machine=1, Network=1,

        Artifact=1, Beacon=2, Block=1,
        Colony=5, Compound=1, Core=1, Foundry=1,
        Headquarters=0.2, Observatory=0.2,
        Nexus=2, Platform=1, Project=0.2,
        Quadrant=1, Satellite=2, Sector=1,
        Shaft=1, Silos=0.5, Substation=0.2,
        Terminal=1,
      },

      s =
      {
        ["Assault!"]=10,
        ["Bestial Experiment"]=10,
        ["Breakdown"]=10,
        ["Call to Arms"]=10,
        ["Close Quarters"]=10,
        ["Code Red"]=10,
        ["Cold Science"]=10,
        ["Deconstruction Site"]=10,
        ["Emergency Situation"]=10,
        ["Horrific Signal"]=10,
        ["Ignition"]=10,
        ["Launchpad"]=10,
        ["Lockdown"]=10,
        ["Mayday!"]=10,
        ["Mission Improbable"]=10,
        ["Motornerve"]=10,
        ["Negative Reinforcement"]=10,
        ["Network Collapse"]=10,
        ["Neural Butchery"]=10,
        ["Panic Attack"]=10,
        ["Paying Ohmage"]=20,
        ["Power Surge"]=10,
        ["Pressure Point"]=10,
        ["Revolution"]=10,
        ["Shock-Drop"]=10,
        ["Sickbay"]=10,
        ["Steel Foundry"]=5,
        ["Supernova"]=10,
        ["Terminal Velocity"]=10,
        ["The Disruption"]=10,
        ["UAC Crisis"]=10,

        ["Artificial Nonsense"]=5,
        ["Delusion Machine"]=10,
        ["False Discharge"]=10,
        ["Higher Voltage"]=10,
        ["Hunger for Weapons"]=10,
        ["Input-Output"]=5,
        ["Interstellar Starport"]=10,
        ["Nebula Checkpoint"]=10,
        ["Muon Collective"]=5,
        ["Mow 'em Down!"]=20,
        ["Sudden Death"]=10,
      },
    },

    divisors =
    {
      a = 5,
      b = 3,
      n = 20,
      s = 20,
    },
  },

  ----------------------------------------

  GOTHIC =
  {
    patterns =
    {
         ["%a %n"] = 50,
      ["%t %a %n"] = 5,

         ["%n of %h"] = 25,
      ["%a %n of %h"] = 15,

      ["%p's %n"]       = 7,
      ["%p's %a %n"]    = 7,
      ["%p's %n of %h"] = 5,

      ["%s"] = 20,
    },

    lexicon =
    {
      t =
      {
        The=50
      },

      p =
      {
        Satan=10, ["The Devil"]=5, Lucifer=1,
      },

      a =
      {
        Large=10, Massive=10, Sprawling=1,
        Small=1, Endless=7,

        Old=10, Ancient=20, Eternal=1,
        Decrepid=10, Desolate=5,
        Ruined=5, Forgotten=7, Lost=10,
        Ravished=2, Barren=4, Deadly=3,
        Dirty=2, Filthy=1, Essel=1,
        Stagnant=3, Rancid=5, Rotten=3,
        Burning=30, Scorching=3, Hot=1, Melting=1,

        Blood=20, Blood_filled=3, Bloody=1,
        Blood_stained=1, Blood_soaked=1,
        Monstrous=15, Monster=4, Zombie=5,
        Demonic=10, Demon=2, Ghoulish=2,
        Haunted=10, Ghostly=15, Ghastly=2,
        Unholy=10, Godless=2, God_forsaken=1,
        Evil=40, Wicked=15, Cruel=5, Ungodly=1,

        Eerie=10, Strange=20, Weird=2, Creepy=5,
        Gloomy=15, Awful=3, Horrible=5,
        Dismal=10, Dreaded=8, Dank=1, Frightful=1,
        Moan_filled=2, Spooky=10, Nightmare=4,
        Screaming=2, Silent=5,

        Underground=5, Subterranean=1,
        Hidden=1, Secret=1,
        Upper=5, Lower=5,
        Inner=5, Outer=5,
        Deepest=5,

        Abhorrent=2, Abominable=2,
        Brutal=10, Bleeding=3, Bestial=1,
        Catastrophic=1, Corrosive=1,
        Darkening=1, Detested=2,
        Direful=1, Disastrous=1,
        Execrated=1, Fatal=7,
        Final=2, Frail=2, Grisly=5,
        Ill_fated=5, Immoral=1,
        Immortal=3, Impure=3,
        Loathsome=2, Merciless=5,
        Morbid=5, Pestilent=2,
        Profane=1, Raw=2,
        Unsanctified=1,
        Vicious=7, Violent=5,
      },

      n =
      {
        Grotto=20, Tomb=20,
        Crypt=30, Chapel=6, Church=2, Mosque=1,
        Graveyard=10, Cloister=2,
        Pit=14, Cavern=10, Cave=2,
        Wasteland=20, Fields=4,
        Ghetto=4, City=1, Well=2, Realm=7,
        Lair=10, Den=4, Domain=2, Hive=1,
        Valley=8, River=2, Catacombs=1,
        Palace=2, Cathedral=3, Chamber=8,
        Labyrinth=2, Dungeon=10,
        Temple=15, Shrine=7, Vault=7,
        Spire=10, Arena=1,

        Gate=1, Circle=1, Altar=4,
        Tower=2, Mountain=1, Prison=1,
        Sanctuary=1, Monolith=1, Crucible=1,

        Excruciation=0.1, Abnormality=0.1,
        Hallucination=0.1, Ache=0.1,
        Ceremony=0.1, Threshold=0.1,
        Basillica=0.1, Apocalypse=0.2,
      },

      h =
      {
        Hell=50, Fire=30, Flames=7,
        Horror=10, Terror=10, Death=10,
        Pain=15, Fear=5, Hate=5,
        Limbo=2, Souls=10, Doom=10,
        Heathens=1,
        Darkness=10, Destruction=3,
        Suffering=3, Torment=9, Torture=5,
        Twilight=2, Midnight=1,
        Flesh=2, Corpses=2,
        Whispers=2, Tears=1, Fate=1,
        Treachery=2,

        ["the Dead"]=10,
        ["the Damned"]=10,
        ["the Undead"]=10,
      },

      s =
      {
        ["Absent Savior"]=10,
        ["Absolution Neglect"]=10,
        ["Atrophy of the Soul"]=10,
        ["A Vile Peace"]=10,
        ["Awaiting Evil"]=10,
        ["Baptised in Parasites"]=10,
        ["Blood Clot"]=10,
        ["Bloodless Unreality"]=10,
        ["Bloodstains"]=10,
        ["Bonded by Blood"]=10,
        ["Born/Dead"]=10,
        ["Cocoon of Filth"]=10,
        ["Cries of Pain"]=10,
        ["Dead Inside"]=10,
        ["Disdain and Anguish"]=10,
        ["Disease"]=10,
        ["Extinction of Mankind"]=10,
        ["Falling Sky"]=10,
        ["Feign Sympathy"]=10,
        ["Guttural Breath"]=10,
        ["Human Landfill"]=10,
        ["Human Trafficking"]=10,
        ["Internal Darkness"]=10,
        ["Mandatory Suicide"]=10,
        ["Manifest Destination"]=10,
        ["Meltdown"]=10,
        ["Necessary Death"]=10,
        ["Origin of Nausea"]=10,
        ["Paranoia"]=10,
        ["Punishment Defined"]=10,
        ["Purgatory"]=10,
        ["Putrid Serenity"]=10,
        ["Sealed Fate"]=10,
        ["Skinfeast"]=10,
        ["Skin Graft"]=10,
        ["Soul Scars"]=10,
        ["Terminal Filth"]=10,
        ["The Second Coming"]=10,
        ["Thinning the Herd"]=10,
        ["Total Doom"]=10,

        ["Can't Handle the Noose"]=10,
        ["Infernal Directorate"]=10,
        ["Kill Thy Neighbor"]=10,
        ["No Salvation"]=10,
        ["Rampage!"]=10,
        ["Searching for Sanity"]=10,
        ["Taste the Blade"]=10,
        ["Slice 'em Twice!"]=10,
        ["Sorrowful Faction"]=10,
        ["Traces of Evil"]=10,
        ["Vengeance Denied"]=10,
        ["Where the Devils Spawn"]=10,
      }
    },

    divisors =
    {
      p = 2,
      a = 5,
      h = 3,
      n = 20,
      s = 20,
    },
  },

  ----------------------------------------

  URBAN =
  {
    patterns =
    {
         ["%a %n"] = 50,
      ["%t %a %n"] = 25,

      [   "%n of %h"] = 5,
      ["%t %n of %h"] = 15,
      ["%a %n of %h"] = 5,

      ["%s"] = 15,
    },

    lexicon =
    {
      t =
      {
        The=50
      },

      a =
      {
        Huge=1, Sprawling=1, Unending=5,

        Old=10, Ancient=20, Eternal=4,
        Decrepid=10, Lost=10, Forgotten=7,
        Ravished=7, Barren=10, Deadly=3,
        Stagnant=3, Rancid=5, Rotten=3,

        Monstrous=5, Monster=10,
        Demonic=5, Demon=10,
        Invaded=3, Overtaken=3,
        Infected=10, Infested=3, Haunted=20,
        Corrupted=10, Corrupt=3,

        Eerie=4, Strange=10, Weird=2, Creepy=1,
        Dark=30, Horrible=5, Exotic=7,
        Dismal=5, Dreaded=4, Cold=4, Ugly=0.2,
        Lonely=7,

        Aethereal=5, Hidden=2, Secret=5,
        Northern=7, Southern=7, Eastern=7, Western=7,
        Upper=2, Lower=2, Central=2,
        Inner=2, Outer=5, Innermost=1, Outermost=1,

        Bleak=40, Abandoned=20, Forsaken=20,
        Cursed=20, Forbidden=30,
        Sinister=30, Bewitched=3, Hostile=5,
        Industrial=1, Residential=1, Living=1,
        Mysterious=7, Obscure=5,
        Ominous=5, Perilous=10,
        Murder=2, Killing=1,
        Vacant=20, Empty=10, Isolated=3,
        Whispering=30,
      },

      n =
      {
        Town=20, City=20, Village=14,
        Condominium=10, Condo=3, Plaza=10,
        Fortress=10, Fort=2, Stronghold=1,
        Palace=10, Courtyard=10, Court=3, Kingdom=1,
        Hallways=12, Hall=5, Corridors=7,
        House=15, Refuge=1, Sanctuary=1,
        Post=3, Keep=1, Slough=0.2,
        Gate=5, Prison=5,

        World=7, Zone=15,
        District=10, Precinct=10,
        Dominion=5, Domain=1,
        Region=1, Territory=3,

        Alleys=5, Docks=5,
        Towers=7, Streets=4,
        Gardens=5, Warrens=1,
        Crossroads=1, Fields=10,
        Suburbs=4, Quarters=4,

        Forests=7, Deserts=7,
        Mountain=10, Cliffs=7,
        Canyon=5, Chasm=5, Valley=5,
        Bay=1, Beach=1,

        Mines=5, Barracks=3,
        Camp=1, Compound=1,
        Harbor=2, Reserve=1,
        Venue=1, Ward=1,
      },

      h =
      {
        Doom=20, Gloom=15, Despair=10, Sorrow=15,
        Horror=10, Terror=10, Death=10,
        Danger=10, Pain=15, Fear=5, Hate=5,
        Desolation=3, Reparation=1,

        Ruin=5, Flames=1, Destruction=3,
        Twilight=2, Midnight=2,
        Tears=5, Fate=1, Helplessness=2,

        Ghosts=10, Gods=10, Spirits=3, Souls=1,
        Menace=5, Evil=1, Ghouls=5, Goblins=1,

        ["the Night"]=5,
      },

      s =
      {
        ["Aftermath"]=10,
        ["Armed to the Teeth"]=10,
        ["Bad Company"]=10,
        ["Black and Grey"]=10,
        ["Blind Salvation"]=10,
        ["Blizzard of Glass"]=10,
        ["Corpse of Decadence"]=10,
        ["Darkness at Noon"]=10,
        ["Days of Rage"]=10,
        ["Dead End"]=10,
        ["Deadly Visions"]=10,
        ["Dead Silent"]=10,
        ["Doomed Society"]=10,
        ["Eight Floors Above"]=10,
        ["Ground Zero"]=1,
        ["Hidden Screams"]=10,
        ["Left for Dead"]=10,
        ["Left in the Cold"]=10,
        ["Lights Out!"]=10,
        ["Lucid Illusion"]=10,
        ["New Beginning"]=10,
        ["No Exit"]=10,
        ["Nothing's There"]=10,
        ["Open Wound"]=10,
        ["Point of No Return"]=10,
        ["Poison Society"]=10,
        ["Red Valley"]=10,
        ["Retribution"]=10,
        ["Roadkill"]=10,
        ["The New Fury"]=10,
        ["Voice of the Voiceless"]=10,
        ["Watch it Burn"]=10,
        ["Watch your Step!"]=10,
        ["When Ashes Rise"]=10,

        ["Disestablishment"]=5,
        ["Eaten by the Furniture"]=5,
        ["Nobody's Home"]=10,
        ["Passing Away"]=10,
        ["Stream of Unconsciousness"]=10,
        ["Ups and Downs"]=10,
      },
    },

    divisors =
    {
      a = 5,
      h = 3,
      n = 20,
      s = 20,
    },
  },
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
    local low = string.lower(w)

    if not NAMING_IGNORE_WORDS[low] then
      -- truncate to 4 letters
      if #low > 4 then
        low = string.sub(low, 1, 4)
      end

      tab[low] = (tab[low] or 0) + 1
    end
  end
end


function Naming_match_parts(word, parts)
  for p,_ in pairs(parts) do
    for w in string.gmatch(word, "%a+") do
      local low = string.lower(w)

      -- truncate to 4 letters
      if #low > 4 then
        low = string.sub(low, 1, 4)
      end

      if p == low then
        return true
      end
    end
  end

  return false
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


function Name_choose_one(DEF, seen_words)

---## do return Name_from_pattern(DEF) end

  local name, parts = Name_from_pattern(DEF)

  -- adjust probabilities
  for c,divisor in pairs(DEF.divisors) do
    for w,prob in pairs(DEF.lexicon[c]) do
      if Naming_match_parts(w, parts) then
        DEF.lexicon[c][w] = prob / divisor
      end
    end
  end

  return Name_fixup(name)
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
  local list = Naming_generate("URBAN", 99)

  for i,name in ipairs(list) do
    gui.debugf("Name %2d: %s\n", i, name)
  end
end

