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
      ["%a %n"]    = 48, ["%t %a %n"]    = 17,
      ["%b %n"]    = 48, ["%t %b %n"]    = 17,
      ["%a %b %n"] = 60, ["%t %a %b %n"] = 5,

      ["%s"] = 25,
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
        Small=10, Tiny=1,

        Old=10, Ancient=10, Eternal=2,
        Advanced=8, Futuristic=3, Future=1,
        Fantastic=1, Incredible=1, Amazing=0.5,

        Decrepid=10, Run_Down=5,
        Lost=10, Ruined=5, Forgotten=7, Failed=5,
        Ravished=2, Broken=2, Dead=2, Deadly=4,
        Dirty=2, Filthy=1, Faulty=2,
        Deserted=10, Abandoned=10,

        Monstrous=5, Demonic=3, Invaded=1, Overtaken=1,
        Infested=10, Haunted=3, Ghostly=5, Hellish=1,
        Subverted=10, Corrupted=2, Contaminated=1,
        Perverted=3, Doomed=5,

        Strange=16, Eerie=4, Weird=2, Creepy=1,
        Dark=20, Gloomy=8, Horrible=1,
        Dismal=2, Dreaded=4, Cold=4,

        Underground=5, Sub_terran=2,
        Aethereal=5, Floating=2,
        Mars=5, Saturn=5, Jupiter=5,
        Deimos=2, Phobos=2,

        Secret=10, Hidden=2, Experimental=1,
        Northern=1, Southern=1, Eastern=1, Western=1,
        Upper=5, Lower=5, Central=7,
        Inner=5, Outer=5, Innermost=1, Outermost=1,
        Auxiliary=5, Primary=7, Prime=1,
        Exterior=3, Subsidiary=1, Ultimate=1,
      },

      b =
      {
        Power=10, Hi_Tech=8, Lo_Tech=1, Energy=7,
        Star=1, Stellar=3, Solar=3, Lunar=5,
        Space=12, Control=10, Military=10, Security=3,
        Mechanical=3, Rocket=1, Missile=3, Research=10,
        Nukage=3, Slime=1, Toxin=3, Plasma=6,
        Bio_=10, Bionic=2, Nuclear=10, Chemical=7,
        Processing=6, Refueling=3, Supply=4,
        Computer=5, Electronics=1, Electro_=1,
        Industrial=2, Engineering=2, Logic=1,
        Teleport=1, Cryogenic=1, Metallic=2,
        Worm_hole=1, Black_hole=1, Robotic=1,
        Magnetic=4, Electrical=2, Proto_=1,
        Slige=1, Waste=1, Optic=1, Time=1, Chrono_=1,
        Alpha=3, Gamma=4, Photon=2,
        Crystal=2, Defense=1, Manufacturing=1,
        Beta=1, Delta=1, Omega=2, Thermal=3, Laser=1,
        Maintenance=1, Radiation=1, Fusion=8,

        ["I/O"]=2,
      },

      n =
      {
        Generator=12, Plant=15, Base=30,
        Warehouse=10, Lab=10, Laboratory=2,
        Station=20, Tower=15, Center=15,
        Complex=20, Refinery=15, Factory=10,
        Depot=7, Storage=3, Anomaly=3, Area=2,
        Tunnels=5, Zone=8, Sphere=2, Gateway=10,
        Facility=10, Works=1, Outpost=2, Site=1,
        Hanger=2, Portal=3, Installation=1,
        Bunker=2, Device=2, Machine=1, Network=1,

        Artifact=1, Beacon=2,
        Colony=6, Compound=4, Core=2, Foundry=1,
        Headquarters=0.5, Observatory=1,
        Nexus=3, Platform=1, Project=0.5,
        Quadrant=1, Satellite=2, Sector=2,
        Shaft=1, Silos=1, Sub_station=2,
        Reactor=10, Terminal=2, Port=1, Hub=3,
        System=4, Dimension=1,
        Paradox=1, Vortex=1,
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
        ["Ignition!"]=10,
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
        ["Steel Forgery"]=10,
        ["Supernova"]=10,
        ["Terminal Velocity"]=10,
        ["The Disruption"]=10,
        ["UAC Crisis"]=10,

        ["Artificial Apathy"]=10,
        ["Blast Radius"]=10,
        ["Celestial Crimes"]=10,
        ["Excessive Exposure"]=10,
        ["False Discharge"]=10,
        ["Galaxy on Fire"]=10,
        ["Gravity Well"]=10,
        ["Higher Voltage"]=10,
        ["Hollow Dynamo"]=10,
        ["Hunger for Weapons"]=10,
        ["In a Future World"]=10,
        ["Input-Output"]=10,
        ["Interstellar Starport"]=10,
        ["Nebula Checkpoint"]=10,
        ["Quantum Distortion"]=10,
        ["Sudden Death"]=10,
        ["System Overload"]=10,
        ["The Delusion Machine"]=10,
        ["The Emerald Parallax"]=10,
        ["The Mental Abyss"]=10,
        ["The Muon Collective"]=10,
        ["Transportation H.Q."]=10,
        ["Warp Factor 666"]=10,
      },
    },

    divisors =
    {
      a = 6,
      b = 6,
      n = 20,
      s = 70,
    },
  },

  ----------------------------------------

  GOTHIC =
  {
    patterns =
    {
         ["%a %n"] = 55,
      ["%t %a %n"] = 20,

         ["%n of %h"] = 25,
      ["%a %n of %h"] = 15,

      ["%p's %n"]       = 4,
      ["%p's %a %n"]    = 4,
      ["%p's %n of %h"] = 4,

      ["%s"] = 18,
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

        Old=10, Ancient=15, Eternal=1,
        Decrepid=10, Desolate=5,
        Lost=10, Ruined=5, Forgotten=7,
        Ravished=2, Barren=4, Deadly=3,
        Dirty=2, Filthy=1, Stinking=1,
        Stagnant=3, Rancid=9, Rotten=3,
        Burning=25, Burnt=3, Scorching=3,
        Melting=2, Red_Hot=1, Fractured=1,

        Blood=20, Blood_filled=3, Bloody=2,
        Blood_stained=1, Blood_soaked=1,
        Monstrous=15, Monster=4, Zombie=6,
        Demonic=10, Demon=3, Ghoulish=2,
        Ogre=2, Wizard=2, Warlock=1, Wiccan=1,
        Haunted=10, Ghostly=12, Ghastly=2,
        Unholy=10, Godless=2, God_forsaken=1,
        Evil=30, Wicked=15, Cruel=7, Ungodly=1,
        Perverse=5, Hallowed=1, Oppressive=1,
        Uncivilised=1, Gothic=5,

        Eerie=10, Strange=20, Weird=2, Creepy=5,
        Gloomy=15, Awful=5, Horrible=5,
        Dismal=10, Dreaded=8, Dank=1, Frightful=1,
        Moan_filled=2, Spooky=10, Nightmare=4,
        Screaming=2, Silent=5, Sullen=5,
        Lava_filled=2, Lava=2,
        Magical=1, Magic=1, Mystical=1,

        Underground=5, Subterranean=1,
        Hidden=1, Secret=1,
        Upper=5, Lower=5,
        Inner=5, Outer=5, Deepest=8,

        Abhorrent=2, Abominable=2,
        Brutal=15, Bleeding=2, Bestial=1,
        Corrosive=1, Darkening=1, Detested=2,
        Direful=1, Disastrous=1,
        Execrated=1, Fatal=7,
        Final=2, Frail=2, Grisly=6,
        Ill_fated=5, Immoral=1,
        Immortal=3, Impure=3,
        Loathsome=2, Merciless=5,
        Morbid=10, Pestilent=2,
        Profane=2, Raw=1,
        Unsanctified=1, Heathen=1,
        Vicious=7, Violent=5,
      },

      n =
      {
        Crypt=15, Grotto=12, Tomb=12,
        Chapel=6, Church=3, Mosque=1,
        Graveyard=6, Cloister=2,
        Pit=10, Cavern=10, Cave=3,
        Wasteland=12, Fields=4,
        Ghetto=4, City=1, Well=2, Realm=7,
        Lair=10, Den=4, Domain=6, Hive=1,
        Valley=8, River=3, Catacombs=1,
        Palace=2, Cathedral=3, Chamber=8,
        Labyrinth=2, Dungeon=10, Shores=2,
        Temple=10, Shrine=7, Vault=7, Sanctum=3,
        Spire=7, Arena=1, Swaths=0.5,

        Gate=1, Circle=2, Altar=4,
        Tower=2, Mountains=1, Prison=1,
        Sanctuary=1, Monolith=2, Crucible=1,
        Communion=2,

        Excruciation=0.5, Abnormality=0.5,
        Hallucination=0.5, Ache=0.5,
        Ceremony=0.5, Threshold=0.5,
        Basillica=0.5, Apocalypse=0.5,
      },

      h =
      {
        Hell=40, Fire=25, Flames=7,
        Horror=10, Terror=10, Death=15,
        Pain=15, Fear=5, Hate=5,
        Limbo=2, Souls=10, Doom=10,
        Carnage=5, Gore=5, Shadows=8,
        Darkness=10, Destruction=3,
        Suffering=3, Torment=10, Torture=5,
        Twilight=2, Midnight=1,
        Flesh=2, Corpses=2,
        Whispers=2, Tears=1, Fate=1,
        Treachery=2, Lunacy=1,

        ["the Dead"]=10,
        ["the Damned"]=10,
        ["the Undead"]=10,
        ["the Possessed"]=10,
        ["the Beast"]=5,
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
        ["Thinning the Horde"]=10,
        ["Total Doom"]=10,

        ["Divine Intoxication"]=10,
        ["Infernal Directorate"]=10,
        ["Gore Soup"]=10,
        ["Kill Thy Neighbor"]=10,
        ["No Salvation"]=10,
        ["Out for Revenge"]=10,
        ["Pulse of Depravity"]=10,
        ["Rampage!"]=15,
        ["Rip in Reality"]=10,
        ["Reaper Unleashed"]=10,
        ["Searching for Sanity"]=10,
        ["Slice 'em Twice!"]=15,
        ["Sorrowful Faction"]=10,
        ["Taste the Blade"]=15,
        ["Traces of Evil"]=10,
        ["Twists and Turns"]=10,
        ["Vengeance Denied"]=10,
        ["Welcome to the Coalface"]=10,
        ["Where the Devils Spawn"]=10,
        ["You Can't Handle the Noose"]=10,
      }
    },

    divisors =
    {
      p = 2,
      a = 6,
      h = 6,
      n = 20,
      s = 70,
    },
  },

  ----------------------------------------

  URBAN =
  {
    patterns =
    {
         ["%a %n"] = 60,
      ["%t %a %n"] = 20,

      [   "%n of %h"] = 15,
      ["%t %n of %h"] = 12,
      ["%a %n of %h"] = 7,

      ["%s"] = 18,
    },

    lexicon =
    {
      t =
      {
        The=50
      },

      a =
      {
        Huge=1, Sprawling=2, Unending=5,
        Serpentine=5, Hulking=1, Giant=2, Vast=2,
        Lupine=1, Furthest=2,

        Old=10, Ancient=10, Eternal=4,
        Decrepid=10, Lost=10, Forgotten=7,
        Ravished=7, Barren=10, Deadly=3,
        Stagnant=3, Rancid=5, Rotten=3,
        Flooded=1, Sunken=0.5, Far_flung=1,
        Misty=3, Foggy=1, Rain_soaked=1,
        Windy=2, Hazy=1, Smoky=1, Smoke_filled=1,
        Urban=2, Concrete=5,

        Monstrous=5, Monster=10, Wild=3,
        Demonic=5, Demon=10, Polluted=5,
        Invaded=3, Overtaken=3, Stolen=1,
        Infected=7, Infested=5, Haunted=20,
        Corrupted=10, Corrupt=3, Fateful=3,

        Eerie=2, Strange=10, Weird=2, Creepy=3,
        Dark=30, Darkest=3, Horrible=5, Exotic=7,
        Dismal=5, Dreaded=3, Cold=5, Ugly=0.5,
        Lonely=7, Slaughter=2, Desperate=5,
        Unknown=2, Unexplored=1,

        Hidden=2, Secret=5, Ethereal=2, Nether_=2,
        Northern=6, Southern=6, Eastern=6, Western=6,
        Upper=2, Lower=5, Central=2,
        Inner=2, Outer=5, Innermost=1, Outermost=1,

        Bleak=30, Abandoned=15, Forsaken=10,
        Cursed=20, Forbidden=20,
        Sinister=20, Bewitched=3, Hostile=7,
        Industrial=1, Residential=1, Living=1,
        Mysterious=7, Obscure=5,
        Ominous=5, Perilous=10,
        Murder=2, Killing=1,
        Vacant=10, Empty=6, Isolated=3,
        Whispering=16, Catastrophic=2, 
      },

      n =
      {
        City=20, Town=12, Village=12,
        Condominium=7, Condo=2, Citadel=3,
        Plaza=10, Square=2, Kingdom=3,
        Fortress=10, Fort=2, Stronghold=1,
        Palace=10, Courtyard=10, Court=3,
        Hallways=10, Hall=5, Corridors=7,
        House=12, Mansion=5, Castle=10,
        Refuge=1, Sanctuary=1,
        Manor=2, Estate=0.5,
        Outpost=2, Keep=1, Slough=1, Temple=1,
        Gate=5, Prison=5, Dens=1, Asylum=2,

        World=8, Zone=2, Lands=10,
        District=10, Precinct=10,
        Dominion=5, Domain=1, Trail=1,
        Region=1, Territory=3, Path=3,
        Country=2, Environs=0.5, Neighborhood=1,

        Alleys=5, Docks=5,
        Towers=7, Streets=7, Roads=1,
        Gardens=5, Warrens=1, Quarry=1,
        Crossroads=1, Fields=10,
        Suburbs=7, Quarters=4, Dwelling=1,

        Forests=7, Cliffs=7, Grove=5,
        Desert=5, Mountain=3, Jungle=3,
        Canyon=5, Chasm=3, Valley=5,
        Bay=1, Beach=1, Echo=0.5,

        Mines=7, Barracks=3, Camp=2, Compound=1,
        Harbor=4, Reserve=1, Venue=1, Ward=1,
      },

      h =
      {
        Doom=20, Gloom=15, Despair=10, Sorrow=15,
        Horror=20, Terror=10, Death=10,
        Danger=10, Pain=15, Fear=5, Hate=5,
        Desolation=3, Reparation=1, Solace=2,

        Ruin=7, Flames=1, Destruction=3,
        Twilight=3, Midnight=2, Dreams=1,
        Tears=5, Helplessness=1, Misfortune=3,
        Turmoil=5, Misery=8, Decay=3,

        Ghosts=10, Gods=10, Spirits=3, Souls=3,
        Menace=5, Evil=2, Ghouls=5,
        Inequity=1, Blood=5,
        Insanity=2, Madmen=0.5, Fools=5,

        ["the Mad"]=2,
        ["the Night"]=5,
      },

      s =
      {
        ["Aftermath"]=10,
        ["Armed to the Teeth"]=10,
        ["Bad Company"]=10,
        ["Black and Grey"]=10,
        ["Blind Salvation"]=10,
        ["Blizzard of Glass"]=5,
        ["Course of Decadence"]=10,
        ["Darkness at Noon"]=10,
        ["Days of Rage"]=10,
        ["Dead End"]=10,
        ["Deadly Visions"]=10,
        ["Dead Silent"]=10,
        ["Doomed Society"]=15,
        ["Eight Floors Above"]=10,
        ["Ground Zero"]=5,
        ["Hidden Screams"]=10,
        ["Left for Dead"]=10,
        ["Left in the Cold"]=10,
        ["Lights Out!"]=10,
        ["Lucid Illusion"]=10,
        ["New Beginning"]=10,
        ["No Exit!"]=10,
        ["Nothing's There!"]=10,
        ["Open Wound"]=10,
        ["Point of No Return"]=10,
        ["Poison Society"]=10,
        ["Red Valhalla"]=10,
        ["Retribution"]=10,
        ["Roadkill"]=10,
        ["The New Fury"]=10,
        ["Voice of the Voiceless"]=10,
        ["Watch it Burn!"]=10,
        ["Watch your Step!"]=10,
        ["When Ashes Rise"]=10,

        ["Ambushed!"]=10,
        ["Bullet Hole"]=10,
        ["Civil Disobedience"]=5,
        ["Disestablishment"]=10,
        ["Eaten by the Furniture"]=10,
        ["Escape is Futile"]=10,
        ["Fight That!"]=10,
        ["Mindless Architecture"]=10,
        ["Mow 'em Down!"]=15,
        ["Nobody's Home"]=10,
        ["No Comfort"]=10,
        ["Out of Luck"]=10,
        ["Passing Away"]=10,
        ["Stream of Unconsciousness"]=10,
        ["Struggle No More"]=10,
        ["Today You Die!"]=10,
        ["Ups and Downs"]=10,
        ["You Don't Belong Here"]=10,
      },
    },

    divisors =
    {
      a = 6,
      h = 6,
      n = 20,
      s = 70,
    },
  },
}


NAMING_IGNORE_WORDS =
{
  ["the"]=1, ["a"]=1,  ["an"]=1, ["of"]=1, ["s"]=1,
  ["for"]=1, ["in"]=1, ["on"]=1, ["to"]=1,
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

      local w = rand_key_by_probs(lex)
      name = name .. w

      Naming_split_word(words, w)
    end
  end

  return name, words
end


function Name_choose_one(DEF, seen_words, max_len)

  local name, parts

  repeat
    name, parts = Name_from_pattern(DEF)
  until #name <= max_len

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


function Naming_generate(theme, count, max_len)
 
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
    local name = Name_choose_one(DEF, seen_words, max_len)

    table.insert(list, name)
  end

  return list
end


function Naming_test()
  local function test_theme(T)
    for set = 1,9 do
      gui.rand_seed(set)
      local list = Naming_generate(T, 20, 24)

      for i,name in ipairs(list) do
        gui.debugf("%s Set %d Name %2d: %s\n", T, set, i, name)
      end

      gui.debugf("\n");
    end
  end

  test_theme("TECH")
  test_theme("GOTHIC")
  test_theme("URBAN")
end

