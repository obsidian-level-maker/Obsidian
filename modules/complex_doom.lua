----------------------------------------------------------------
--  MODULE: Complex Doom Changes
----------------------------------------------------------------
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2011, 2021 Armaetus
--  Copyright (C) 2021 MsrShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

-- Usable keywords
-- ===============
--
-- id         : editor number used to place monster on the map
-- level      : how far along (over episode) it should appear (1..9)
--
-- prob       : general probability of being used
-- crazy_prob : probability for "Crazy" setting (default is 50)
--
-- health : hit points of monster
-- damage : total damage inflicted on player (on average)
-- attack : kind of attack (hitscan | missile | melee)
-- density : how many too use (e.g. 0.5 = half the normal amount)
--
-- float  : true if monster floats (flies)
-- invis  : true if invisible (or partially)
--
-- weap_needed : weapons player must have to fight this monster
-- weap_min_damage : damage (per second) of player weapon required
-- weap_prefs : weapon preferences table (usage by player)
-- disloyal   : can hurt a member of same species
-- infight_damage : damage inflicted on one (or more) other monsters

--

-- Changes to make up for the difficulty ramp that Complex Doom
-- does. Even the weaker monsters could kill you if you're not
-- careful!

-- Based on the "Harder Enemy Setup" module, so there's no need to
-- use both.

-- Another note for contributors: If you also have Complex Doom v27,
-- please run this and provide feedback so I can further tweak settings
-- as I am not certain things are fully balanced yet.
-- -Armaetus, Jan. 31st, 2021,

COMPLEX_DOOM = { }

COMPLEX_DOOM.MONSTERS =
{

-- Possible replacements:
-- Plasma zombie (Weakest but plasma bursts hurt)
-- Railgun zombie (Has to aim before shooting, and not Skulltag level damage)
-- DemonTech zombie (Unique weapon used, still hurts)
-- Rocket zombie (Uses a rocket launcher, heavy if not lethal damage!)
  zombie =
  {
    id = 3004,
    r = 20,
    h = 56,
    level = 1,
    prob = 50,
    health = 45, -- Average health. All replacement health divided by 4.
    damage = 3.0, -- Need some sort of average damage due to the replacements.
    attack = "hitscan",
    replaces = "shooter",
    replace_prob = 20,
    give = { {ammo="bullet",count=5} },
    weap_prefs = { shotty=1.2, chain=1.5 }, -- Pistol is actually useful on these guys!
    density = 1.5,
    room_size = "any", --small
    disloyal = true,
    trap_factor = 0.3,
    infight_damage = 12.0 -- Due to the projectile damage done
  },

  -- Possible replacements:
  -- Shotgun zombie (Same as stock, but potential to do more damage)
  -- Assault shotgun zombie (Uses a semi-auto shotgun, hurts even more due to fire rate)
  -- Super shotgun zombie (Double barrel misery. Hurts a lot)
  -- Quad barrel shotgunner (If you thought super shotgunner was bad..Don't want to be close to him!)
  shooter =
  {
    id = 9,
    r = 20,
    h = 56,
    level = 1,
    prob = 75,
    health = 50,
    damage = 5.0,
    attack = "hitscan",
    density = 1.0,
    give = { {weapon="shotty"}, {ammo="shell",count=4} },
    weap_prefs = { shotty=1.2, chain=1.5, plasma=1.2 },
    weap_needed = { shotty=true },
    species = "zombie",
    replaces = "zombie",
    replace_prob = 20,
    room_size = "any", --small
    disloyal = true,
    trap_factor = 2.0,
    infight_damage = 20.0,
  },

  -- Possible replacements:
  -- Imp (Standard, but can lunge at you if you get close for surprise melee damage)
  -- Void Imp (Tougher and can launch spread projectiles)
  -- Devil (Can charge its shot for extra damage)
  -- Phase Imp (Can evade and charge its shots as well)
  imp =
  {
    id = 3001,
    r = 20,
    h = 56,
    level = 1,
    prob = 140,
    health = 85,
    damage = 4.0,
    attack = "missile",
    density = 1.0,
    replaces = "demon",
    replace_prob = 25,
    weap_needed = { shotty=true },
    weap_prefs = { shotty=1.5, chain=1.25, super=1.2, plasma=1.2 },
    room_size = "any", --small
    trap_factor = 0.5, --0.3,
    infight_damage = 12.0,
  },

  skull =
  {
    id = 3006,
    r = 16,
    h = 56,
    level = 5,
    prob = 25,
    health = 100,
    damage = 2.0,
    attack = "melee",
    density = 0.5,
    float = true,
    weap_prefs = { super=1.5, chain=1.3, launch=0.3 },
    weap_needed = { shotty=true },
    room_size = "any", --small
    disloyal = true,
    trap_factor = 0,
    cage_factor = 0,
    infight_damage = 6.0,
  },

  -- Possible replacements:
  -- Bull Demon (Stock demon, can also lunge to close distance and harm player)
  -- Cyber Fiend (Cyberneticized version, stronger)
  -- Magma Demon (Fire based, has projectile attack)
  -- D-Tech Fiend (Sturdier, has projectile attack?)
  demon =
  {
    id = 3002,
    r = 30,
    h = 56,
    level = 4,
    prob = 50,
    health = 260,
    damage = 5.0,
    attack = "melee",
    density = 0.85,
    weap_min_damage = 40,
    weap_needed = { shotty=true },
    weap_prefs = { super=1.75, shotty=1.35, chain=1.5, plasma=1.2, launch=0.3 },
    room_size = "any",
    cage_factor = 0,
    infight_damage = 40,
  },

-- Same as Demon.
  spectre =
  {
    id = 58,
    r = 30,
    h = 56,
    level = 4,
    replaces = "demon",
    replace_prob = 35,
    crazy_prob = 25,
    health = 260,
    damage = 5.0,
    attack = "melee",
    density = 0.5,
    invis = true,
    outdoor_factor = 3.0,
    weap_min_damage = 40,
    weap_needed = { shotty=true },
    weap_prefs = { super=1.75, shotty=1.35, chain=1.5, plasma=1.2, launch=0.3 },
    species = "demon",
    room_size = "any",
    trap_factor = 0.3,
    cage_factor = 0,
    infight_damage = 40,
  },

  caco =
  {
    id = 3005,
    r = 31,
    h = 56,
    level = 5,
    prob = 30,
    health = 600,
    damage = 6.0,
    attack = "missile",
    density = 0.6,
    weap_min_damage = 40,
    float = true,
    weap_needed = { chain=true },
    weap_prefs = { launch=1.25, super=1.75, chain=1.2, shotty=0.7, plasma=1.2 },
    weap_min_damage = 40,
    replaces = "pain",
    replace_prob = 20,
    room_size = "any", --large
    trap_factor = 0.5,
    infight_damage = 40,
  },


  ---| BOSSES |---

  baron =
  {
    id = 3003,
    r = 24,
    h = 64,
    level = 7,
    boss_type = "minor",
    boss_prob = 50,
    prob = 6.4,
    crazy_prob = 20,
    weap_needed = { launch=true },
    weap_prefs = { launch=1.75, super=1.5, plasma=1.75, bfg=1.5 },
    health = 1250,
    damage = 10.0,
    attack = "missile",
    density = 0.3,
    weap_min_damage = 88,
    room_size = "any", --medium
    infight_damage = 120,
  },

  Cyberdemon =
  {
    id = 16,
    r = 40,
    h = 110,
    level = 9,
    boss_type = "tough",
    boss_prob = 50,
    prob = 1.6,
    crazy_prob = 10,
    health = 4000,
    damage = 200,
    attack = "missile",
    density = 0.1,
    weap_needed = { bfg=true },
    weap_min_damage = 150,
    weap_prefs = { bfg=10.0 },
    room_size = "large", --medium
    infight_damage = 1600,
    cage_factor = 0,
    boss_replacement = "baron",
  },

-- Added cage_factor to prevent any chance
-- of placement in cages.
  Spiderdemon =
  {
    id = 7,
    r = 128,
    h = 100,
    level = 8,
    boss_type = "tough",
    boss_prob = 15,
    boss_limit = 1, -- because they infight
    prob = 2.0,
    crazy_prob = 10,
    health = 3000,
    damage = 150,
    attack = "hitscan",
    density = 0.1,
    cage_factor = 0,
    weap_needed = { bfg=true },
    weap_min_damage = 200,
    weap_prefs = { bfg=10.0 },
    room_size = "large",
    infight_damage = 700,
    boss_replacement = "baron",
  },


  ---== Doom II only ==---

  -- Possible replacements:
  -- Assault rifle zombie (Standard assault rifle, shoots in bursts)
  -- Chaingunner (Pretty much like your stock chaingunner. Higher ROF)
  -- Minigunner (Like chaingunner but very high ROF. Dangerous up close)
  -- BFG zombie (Yeah, don't want to fuck with these guys. Can wipe out lesser monsters and YOU)
  gunner =
  {
    id = 65,
    r = 20,
    h = 56,
    level = 1.6,
    prob = 60,
    health = 80,
    damage = 7.0,
    attack = "hitscan",
    give = { {weapon="chain"}, {ammo="bullet",count=10} },
    weap_needed = { shotty=true },
    weap_min_damage = 50,
    weap_prefs = { shotty=1.5, super=1.75, chain=2.0, plasma=1.3, launch=1.1 },
    density = 0.75,
    species = "zombie",
    room_size = "any", --large
    replaces = "shooter",
    replace_prob = 15,
    disloyal = true,
    trap_factor = 2.4,
    infight_damage = 65,
  },

-- Shows up sooner, marginal probability decrease and
-- increased damage. They *can* knock out up to 80,
-- health at maximum.
  revenant =
  {
    id = 66,
    r = 20,
    h = 64,
    level = 4,
    prob = 25,
    health = 300,
    damage = 11.0, -- Some replacements do tons of damage
    attack = "missile",
    weap_min_damage = 60,
    density = 0.6,
    weap_prefs = { launch=1.75, plasma=1.75, chain=1.5, super=1.25 },
    weap_needed = { super=true },
    room_size = "any",
    replaces = "knight",
    replace_prob = 15,
    trap_factor = 2.0,
    infight_damage = 50,
  },

-- Shows up sooner, increased chance to replace
-- Mancubus and can be placed in  any sized room.
  knight =
  {
    id = 69,
    r = 24,
    h = 64,
    level = 5,
    prob = 26,
    health = 500,
    damage = 6.0,
    attack = "missile",
    weap_min_damage = 50,
    weap_needed = { super=true },
    weap_prefs = { launch=1.75, super=1.5, plasma=1.33 },
    density = 0.75,
    species = "baron",
    replaces = "mancubus",
    replace_prob = 25,
    room_size = "any", --medium
    infight_damage = 60,
  },

-- Shows up sooner, increased replacement for Arachnotron
-- and can show up outside more. Also has a floating replacement!
  mancubus =
  {
    id = 67,
    r = 48,
    h = 64,
    level = 6,
    prob = 20,
    health = 600,
    damage = 10.0,
    attack = "missile",
    weap_needed = { super=true },
    weap_prefs = { launch=1.5, super=1.5, plasma=1.5, chain=1.2 },
    density = 0.32,
    weap_min_damage = 88,
    replaces = "arach",
    replace_prob = 30,
    room_size = "large",
    outdoor_factor = 2.0,
    infight_damage = 110, -- Has a close up flamethrower attack as well
    boss_replacement = "baron",
  },

-- Shows up sooner and increased chance to replace
-- Mancubus.
  arach =
  {
    id = 68,
    r = 64,
    h = 64,
    level = 5,
    prob = 12,
    health = 500,
    damage = 12.0,
    attack = "missile",
    weap_min_damage = 60,
    weap_needed = { super=true },
    weap_prefs = { launch=1.5, super=1.5, plasma=1.5, chain=1.2 },
    replaces = "mancubus",
    replace_prob = 30,
    density = 0.5,
    cage_factor = 0,
    room_size = "medium",
    infight_damage = 95,
    boss_replacement = "revenant",
  },

-- Shows up sooner and increased number that can be
-- placed in one room. Can replace boss monster for
-- the Baron.

-- NOTES:
-- Summoner replacement is very nasty, so prob has been dropped.
  vile =
  {
    id = 64,
    r = 20,
    h = 56,
    level = 8,
    boss_type = "nasty",
    boss_prob = 20,
    boss_limit = 1, -- Vile replacements are pretty nasty, hence limited to 1,
    prob = 2,
    crazy_prob = 5,
    health = 850,
    damage = 25,
    attack = "hitscan",
    density = 0.1,
    trap_factor = 0.01,
    room_size = "medium",
    weap_needed = { bfg=true },
    weap_prefs = { launch=3.0, super=1.5, plasma=2.0, bfg=2.5 },
    weap_min_damage = 120,
    nasty = true,
    infight_damage = 150,
    boss_replacement = "baron",
  },

-- Shows up sooner, increased total number placed in one
-- room to 4 and density slightly increased.
  pain =
  {
    id = 71,
    r = 31,
    h = 56,
    level = 5,
    boss_type = "nasty",
    boss_prob = 15,
    boss_limit = 2,
    prob = 10,
    crazy_prob = 15,
    health = 900,  -- 400 + 5 skulls
    damage = 16.0, -- about 5 skulls
    attack = "missile",
    density = 0.2,
    float = true,
    weap_min_damage = 100,
    weap_needed = { launch=true },
    weap_prefs = { launch=1.5, super=1.5, chain=1.5, shotty=0.7, plasma=1.7 },
    room_size = "any", --large
    cage_factor = 0,  -- never put in cages
    trap_factor = 1.1,
    infight_damage = 50 -- Pain Elemental replacements have direct damage now
  },

  -- Possible replacements:
  -- SS Nazi (Blue outfit with submachine guns)
  -- Guard (The tan outfit guys with pistol)
  -- Mutant (Chest rifles!)
  -- SS Officer (Gray outfits with good aim)
  -- Dog (Bitey bite)
  -- HITLER! (Mecha suit!)
  ss_nazi =
  {
    id = 84,
    r = 20,
    h = 56,
    level = 1,
    prob  = 0,
    crazy_prob = 0,
    health = 50,
    damage = 5,
    attack = "hitscan",
    give = { {ammo="bullet",count=5} },
    density = 1.5,
    infight_damage = 25,
  },
}

COMPLEX_DOOM.WEAPONS =
{
  fist =
  {
    attack = "melee",
    rate = 1.5,
    damage = 15,
  },

  pistol =
  {
    pref = 4,
    attack = "hitscan",
    rate = 5.0, -- Pistol is semi-automatic now
    accuracy = 85,
    damage = 10,
    ammo = "bullet",
    per = 1,
  },

  shotty =
  {
    id = 2001,
    level = 1,
    pref = 40,
    add_prob = 40,
    attack = "hitscan",
    rate = 0.9,
    accuracy = 65,
    damage = 70,
    splash = { 15 },
    ammo = "shell",
    per = 1,
    give = { {ammo="shell",count=8} },
    bonus_ammo = 8,
  },

  chain =
  {
    id = 2002,
    level = 1,
    pref = 70,
    upgrades = "pistol",
    add_prob = 40,
    attack = "hitscan",
    rate = 8.5,
    accuracy = 85,
    damage = 10,
    ammo = "bullet",
    per = 1,
    give = { {ammo="bullet",count=20} },
    bonus_ammo = 50,
  },

  -- the super shotgun is Doom II only
  super =
  {
    id = 82,
    level = 2.5,
    pref = 40,
    upgrades = "shotty",
    add_prob = 70,
    attack = "hitscan",
    rate = 0.6,
    accuracy = 65,
    damage = 150,
    -- use splash to simulate hitting a second monster (etc)
    splash = { 40,20,10 },
    ammo = "shell",
    per = 2,
    give = { {ammo="shell",count=8} },
    bonus_ammo = 12,
  },

  launch =
  {
    id = 2003,
    level = 4,
    pref = 30,
    add_prob = 45,
    hide_prob = 10,
    attack = "missile",
    rate = 1.7,
    accuracy = 80,
    damage = 200, -- Rocket does a bit more damage
    splash = { 65,20,5 },
    ammo = "rocket",
    per = 1,
    give = { {ammo="rocket",count=2} },
    bonus_ammo = 5,
  },

  plasma =
  {
    id = 2004,
    level = 4,
    pref = 25,
    add_prob = 50,
    attack = "missile",
    rate = 11,
    accuracy = 80,
    damage = 22,
    ammo = "cell",
    per = 1,
    give = { {ammo="cell",count=40} },
    bonus_ammo = 40,
  },

  bfg =
  {
    id = 2006,
    level = 6,
    pref = 12,
    upgrades = "plasma",
    add_prob = 20,
    hide_prob = 35,
    attack = "missile",
    rate = 0.8,
    accuracy = 80,
    damage = 640,
    splash = { 150,150,150,150, 80,80,80,80 },
    ammo = "cell",
    per = 40,
    give = { {ammo="cell",count=40} },
    bonus_ammo = 40,
  },
}

-- Need some changes here too!
COMPLEX_DOOM.PICKUPS =
{
  -- HEALTH --

  potion =
  {
    id = 2014,
    kind = "health",
    add_prob = 20,
    cluster = { 3,7 },
    give = { {health=2} },
  },

  -- ARMOR --

  helmet =
  {
    id = 2015,
    kind = "armor",
    add_prob = 10,
    cluster = { 3,7 },
    give = { {health=2} },
  },


  --
  -- NOTES:
  --
  -- Armor (all types) is modelled as health, because it merely
  -- saves the player's health when you are hit with damage.
  -- For example, the BLUE jacket saves 50% of damage, hence
  -- it is roughly equivalent to 100 units of health.
  --
}


--------------------------------------------------------------------


function COMPLEX_DOOM.setup(self)
  if not PARAM.doom2_weapons then
    GAME.MONSTERS["gunner"] = nil
    GAME.MONSTERS["knight"] = nil
    GAME.MONSTERS["revenant"] = nil
    GAME.MONSTERS["mancubus"] = nil
    GAME.MONSTERS["arach"] = nil
    GAME.MONSTERS["vile"] = nil
    GAME.MONSTERS["pain"] = nil
    GAME.MONSTERS["ss_nazi"] = nil
  end

  for name,_ in pairs(COMPLEX_DOOM.MONSTERS) do
    local M = GAME.MONSTERS[name]

    if M and factor then
      M.prob = M.prob * factor
      M.crazy_prob = (M.crazy_prob or M.prob) * factor
    end
  end
end

-- How to implement this into "Modded Game Extras" module??
OB_MODULES["complex_doom"] =
{
  label = _("Complex Doom Modifications"),

  side = "left",
  priority = 61,
  game = { doom1=1, doom2=1 }, -- Dunno if it has support for Heretic/Hexen

  tooltip = "Alters to better fit the difficulty that Complex Doom provides. Do not use with 'Harder Enemy Setup' addon, will conflict.",

  -- Zandronum *SHOULD* work with v27, otherwise will remove it.
  engine = { zdoom=1, gzdoom=1, skulltag=1 },

  tables =
  {
    COMPLEX_DOOM
  },

  hooks =
  {
    setup = COMPLEX_DOOM.setup
  },
}
