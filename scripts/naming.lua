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
--  Thanks to "JohnnyRancid" who contributed many of the
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
      ["%a %n"]    = 60, ["%t %a %n"]    = 17,
      ["%b %n"]    = 60, ["%t %b %n"]    = 17,
      ["%a %b %n"] = 40, ["%t %a %b %n"] = 5,

      ["%s"] = 27,
    },

    lexicon =
    {
      t =
      {
        The=50
      },

      a =
      {
        -- size
        Large=20, Huge=20, Gigantic=3,
        Small=10, Tiny=5, Sprawling=3,

        -- location
        Underground=10, Sub_terran=5,
        Aethereal=10, Floating=5,
        Mars=10, Saturn=10, Jupiter=10,
        Deimos=5, Phobos=5,

        Secret=20, Hidden=10, Experimental=3,
        Northern=3, Southern=3, Eastern=3, Western=3,
        Upper=10, Lower=10, Central=15,
        Inner=10, Outer=10, Innermost=3, Outermost=3,
        Auxiliary=10, Primary=20, Prime=5,
        Exterior=10, Subsidiary=3, Ultimate=3,

        -- condition
        Old=10, Ancient=10, Eternal=5,
        Advanced=10, Futuristic=5, Future=3,
        Fantastic=3, Incredible=3, Amazing=3,
        Wondrous=3,

        Decrepid=20, Run_Down=10, Devastated=3,
        Lost=20, Ruined=10, Forgotten=15, Failed=10,
        Ravished=10, Broken=3, Dead=3,
        Dirty=10, Filthy=5, Faulty=5,
        Deserted=15, Abandoned=15,

        -- infestation
        Monstrous=10, Demonic=10, Invaded=3, Overtaken=3,
        Infested=20, Haunted=5, Ghostly=10, Hellish=3,
        Subverted=15, Corrupted=7, Contaminated=5,

        -- descriptive
        Strange=20, Eerie=10, Weird=10, Creepy=5,
        Dark=20, Gloomy=10, Horrible=3,
        Deadly=10, Dismal=5, Dreaded=5, Cold=10,
        Perverted=5, Doomed=10,
      },

      b =
      {
        -- purpose
        Control=10, Research=15,
        Military=10, Security=5, Defense=5,
        Processing=10, Refueling=5, Supply=15,
        Manufacturing=3, Maintenance=3,
        Industrial=3, Engineering=3,

        -- descriptive
        Hi_Tech=20, Lo_Tech=3,
        Star=3, Stellar=7, Solar=10, Lunar=10,
        Space=20, Proto_=5,
        Alpha=10, Beta=5, Gamma=10,
        Delta=10, Omega=5,

        -- materials / substances
        Power=20, Energy=15,
        Mechanical=5, Rocket=3, Missile=10,
        Bio_=15, Bionic=3, Nuclear=15,
        Nukage=10, Slime=10, Toxin=10,
        Chemical=15, Slige=10, Waste=10,
        Plasma=15, Fusion=15, Thermal=10,
        Crystal=10, Radiation=5, Hydro=3,
        Optic=5, Laser=5, Photon=7,
        Logic=5, Time=3, Chrono_=3,

        Computer=20, Magnetic=15, Metallic=5,
        Electronics=5, Electrical=5, Electro_=3,
        Worm_hole=5, Black_hole=5, Teleport=3,
        Robotic=5, Cryogenic=5, Cryo_=2,

        ["I/O"]=5,
      },

      n =
      {
        -- specific places
        Generator=12, Plant=15, Base=30,
        Warehouse=10, Depot=10, Storage=5,
        Lab=20, Laboratory=5,
        Station=20, Reactor=10, Tower=15,
        Refinery=15, Factory=10,
        Gateway=10, Hanger=5, Outpost=7,
        Tunnels=10, Bunker=3,

        Beacon=3, Satellite=10,
        Colony=15, Compound=5, Foundry=3,
        Headquarters=2, Observatory=3,
        Shaft=3, Silos=7, Sub_station=10,

        -- general places
        Complex=20, Center=20,
        Facility=10, Works=2,
        Area=7, Site=3, Zone=10,
        Quadrant=3, Sector=5, Sphere=5, 
        Platform=3, Port=3,
        Hub=10, Nexus=10, Core=5, 
        Terminal=7, Installation=3,

        -- weird ones
        Device=5, Machine=5, Network=5,
        Anomaly=10, Portal=7, Artifact=5,
        System=10, Project=2,
        Dimension=3, Paradox=3, Vortex=5,
      },

      s =
      {
        -- single complete level names

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
      a = 10,
      b = 10,
      n = 40,
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

         ["%n of %h"] = 26,
      ["%a %n of %h"] = 14,

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
        Satan=10, ["The Devil"]=5, Lucifer=2,
      },

      a =
      {
        -- size
        Large=10, Massive=10, Sprawling=1,
        Small=1, Endless=7,

        -- location
        Underground=5, Subterranean=1,
        Hidden=1, Secret=1,
        Upper=5, Lower=5,
        Inner=5, Outer=5, Deepest=8,

        -- condition
        Old=10, Ancient=15, Eternal=1,
        Decrepid=10, Desolate=5,
        Lost=10, Ruined=5, Forgotten=7,
        Ravished=2, Barren=4, Deadly=3,
        Dirty=2, Filthy=1, Stinking=1,
        Stagnant=3, Rancid=9, Rotten=3,
        Burning=25, Burnt=3, Scorching=3,
        Melting=2, Red_Hot=1, Fractured=1,

        -- contents
        Blood=20, Blood_filled=3, Bloody=2,
        Blood_stained=1, Blood_soaked=1,
        Lava_filled=2, Lava=2, Bleeding=2, 
        Monstrous=15, Monster=4, Zombie=6,
        Demonic=10, Demon=3, Ghoulish=2,
        Wizard=2, Warlock=1, Wiccan=1,
        Haunted=10, Ghostly=12, Ghastly=2,
        Heathen=1,

        -- descriptive
        Unholy=10, Godless=2, God_forsaken=1,
        Evil=30, Wicked=15, Cruel=7, Ungodly=1,
        Perverse=5, Hallowed=1, Oppressive=1,
        Uncivilised=1, Gothic=5,

        Eerie=10, Strange=20, Weird=2, Creepy=5,
        Gloomy=15, Awful=5, Horrible=5,
        Dismal=10, Dank=1, Frightful=1,
        Moan_filled=2, Spooky=10, Nightmare=4,
        Screaming=2, Silent=5, Sullen=5,
        Magical=1, Magic=1, Mystical=1,

        Abhorrent=2, Abominable=2,
        Brutal=15, Bestial=1,
        Corrosive=1, Darkening=1, Detested=2,
        Direful=1, Disastrous=1,
        Execrated=1, Fatal=7,
        Final=2, Frail=2, Grisly=6,
        Ill_fated=5, Immoral=1,
        Immortal=3, Impure=3,
        Loathsome=2, Merciless=5,
        Morbid=10, Pestilent=2,
        Profane=2, Raw=1,
        Unsanctified=1,
        Vicious=7, Violent=5,
      },

      n =
      {
        -- places
        Crypt=15, Grotto=12, Tomb=12,
        Chapel=6, Church=3, Mosque=1,
        Graveyard=6, Cloister=2,
        Pit=10, Cavern=10, Cave=3,
        Wasteland=12, Fields=4,
        Ghetto=4, City=1, Well=2, Realm=7,
        Lair=10, Den=4, Domain=6, Hive=1,
        Valley=8, River=3, Catacombs=1,
        Palace=2, Cathedral=3, Chamber=8,
        Hall=5,

        Labyrinth=2, Dungeon=10, Shores=2,
        Temple=10, Shrine=7, Vault=7, Sanctum=3,
        Spire=7, Arena=1, Swaths=0.5,
        Gate=1, Circle=2, Altar=4,
        Tower=2, Mountains=1, Prison=1,
        Sanctuary=1,

        -- weird ones
        Communion=2, Monolith=2, Crucible=1,
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
        Flesh=2, Corpses=2, Dread=5,
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
        -- single complete level names

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
        ["Glutton for Punishment"]=10,
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
      p = 3,
      a = 10,
      h = 10,
      n = 40,
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
        -- size
        Huge=7, Sprawling=10, Unending=7,
        Serpentine=10, Hulking=3, Giant=3, Vast=7,

        -- location
        Secret=10, Hidden=5, Ethereal=5, Nether_=5,
        Northern=10, Southern=10, Eastern=10, Western=10,
        Upper=5, Lower=10, Central=5,
        Inner=5, Innermost=3,
        Outer=5, Outermost=3,
        Furthest=5, Isolated=5,

        -- condition
        Old=10, Ancient=20, Eternal=7,
        Decrepid=20, Lost=10, Forgotten=10,
        Ravished=10, Barren=20, Deadly=5,
        Stagnant=10, Rancid=15, Rotten=5,
        Flooded=5, Sunken=3, Far_flung=5,
        Misty=10, Foggy=5, Rain_soaked=2,
        Windy=10, Hazy=3, Smoky=5, Smoke_filled=2,
        Urban=10, Concrete=10,

        -- descriptive
        Monstrous=5, Monster=15, Wild=5,
        Demonic=5, Demon=15, Polluted=10,
        Invaded=5, Overtaken=5, Stolen=3,
        Haunted=20, Infected=10, Infested=10,
        Corrupted=15, Corrupt=5, Fateful=5,

        Strange=10, Eerie=5, Weird=5, Creepy=10,
        Dark=30, Darkest=7, Horrible=10, Exotic=10,
        Dismal=10, Dreadful=10, Cold=7, Ugly=2,
        Vacant=15, Empty=7, Lonely=10, Desperate=5,
        Unknown=5, Unexplored=7, Lupine=2,
        Crowded=3,

        Bleak=30, Abandoned=15, Forsaken=10,
        Cursed=20, Wretched=10, Bewitched=5, 
        Forbidden=20, Sinister=10, Hostile=10,
        Mysterious=10, Obscure=10, Living=3,
        Ominous=10, Perilous=15,
        Slaughter=5, Murder=5, Killing=5,
        Catastrophic=5, Whispering=20,
      },

      n =
      {
        City=30, Town=20, Village=20,
        Condominium=10, Condo=5, Citadel=10,
        Plaza=10, Square=5, Kingdom=15,
        Fortress=20, Fort=5, Stronghold=5,
        Palace=20, Courtyard=10, Court=10,
        Hallways=20, Halls=5, Corridors=7,

        Castle=20,
        House=20, Mansion=10, Manor=10,
        Refuge=5, Sanctuary=5, Asylum=10,
        Dwelling=3, Estate=2,
        Outpost=5, Keep=3, Slough=3, Temple=3,
        Gate=10, Prison=15, Dens=5,

        World=15, Country=10, Zone=5,
        District=10, Precinct=10,
        Dominion=10, Domain=3, Trail=3,
        Region=5, Territory=5, Path=5,
        Neighborhood=3, Environs=1,

        Camp=3, Compound=3, Venue=1,
        Harbor=10, Reserve=3, Ward=3,
        Junction=2,

        -- plurals
        Lands=20, Fields=20,
        Alleys=10, Docks=10,
        Towers=10, Streets=10, Roads=5,
        Gardens=15, Warrens=5, Quarry=5,
        Crossroads=5,
        Suburbs=10, Quarters=10,
        Mines=20, Barracks=5,

        -- geological
        Forests=10, Cliffs=10, Grove=10,
        Desert=7, Mountain=5, Jungle=5,
        Canyon=10, Chasm=5, Valley=10,
        Bay=2, Beach=2,

        -- weird ones
        Echo=1,
      },

      h =
      {
        Doom=20, Gloom=15, Despair=10, Sorrow=15,
        Horror=20, Terror=10, Death=10,
        Danger=10, Pain=15, Fear=7, Hate=5,
        Desolation=3, Reparation=3, Solace=10,

        Ruin=10, Flames=3, Destruction=5,
        Twilight=5, Midnight=5, Dreams=2,
        Tears=10, Helplessness=2, Misfortune=5,
        Misery=10, Turmoil=5, Decay=5,
        Blood=10, Insanity=5, Inequity=2,

        -- residents
        Ghosts=15, Gods=10, Spirits=5,
        Menace=15, Evil=5, Ghouls=5,
        Ogres=5, Trolls=7, Souls=5,
        Spiders=2, Snakes=5,
        Madmen=2, Fools=10,

        ["the Mad"]=5,
        ["the Night"]=10,
      },

      s =
      {
        -- single complete level names

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
      a = 10,
      h = 10,
      n = 40,
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
    for set = 1,20 do
      gui.rand_seed(set)
      local list = Naming_generate(T, 12, 28)

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

