----------------------------------------------------------------
--  MODULE: Immoral Conduct - Special Edition
----------------------------------------------------------------
--
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

-- === NOTES ===
--
-- The Ammo in Immoral Conduct is a bit different than
-- standard DOOM, there is a couple new ones and some
-- existing ones have new meaning.  The most important are:
--
--     bullets  -> bullets
--     shells   -> shells
--     rockets  -> grenades
--     cells    -> rifle ammo
--
--     gas      -> flak shells (new)
--     nails    -> knives (new)
--     pellets  -> satchel charges (new)
--
-- (Knives and Charges are not modelled by OBLIGE).
--
-- The "Silencer" is another starting weapon, but I assume
-- it's equivalent to the pistol and hence is not modelled.
--
-- Many weapons have cool secondary attacks, often using
-- different ammo.  This is not modelled, on the assumption
-- that they are less effective than the primary attack.
--
-- For weapons that have reloading sequences when the clip
-- runs out.  This is handled by decreasing the rate by a
-- small amount (in practise the player would usually be
-- taking cover somewhere while the weapon reloads).
--


ICDSE_THINGS =
{
  -- players
  -- (replaces COOP_HELPER_SPAWNER with SPACE_MARINE_PRIVATE)
  player4 = { id=3000, kind="player", r=20,h=56 },

  -- monsters
  uzi_trooper     = { id=3042, kind="monster", r=20,h=56 },
  super_shooter   = { id=3043, kind="monster", r=20,h=56 },
  m16_zombie      = { id=3044, kind="monster", r=20,h=56 },
  chainsaw_zombie = { id=3046, kind="monster", r=20,h=56 },

  -- weapons
  pistol_pair = { id=2018, kind="pickup", r=20,h=16, pass=true },
  uzi_pair    = { id=2022, kind="pickup", r=20,h=16, pass=true },
  flak_shotty = { id=2006, kind="pickup", r=20,h=16, pass=true },
  gren_launch = { id=  17, kind="pickup", r=20,h=16, pass=true },
  satchel     = { id=2010, kind="pickup", r=20,h=16, pass=true },

  minigun     = { id=2999, kind="pickup", r=20,h=16, pass=true },
  sawed_off   = { id=4444, kind="pickup", r=20,h=16, pass=true },
  beretta     = { id=4445, kind="pickup", r=20,h=16, pass=true },
  revolver    = { id=4446, kind="pickup", r=20,h=16, pass=true },

  -- pickups
  flak_shells = { id=2024, kind="pickup", r=20,h=16, pass=true },
}


ICDSE_MONSTERS =
{
  uzi_trooper =
  {
    prob=20, guard_prob=21, trap_prob=11,
    health=40, damage=30, attack="hitscan",
    give={ {weapon="launch"}, {ammo="bullet",count=20} },
  },

  super_shooter =
  {
    prob=20, guard_prob=21, trap_prob=11,
    health=50, damage=70, attack="hitscan",
    give={ {weapon="super"}, {ammo="shell",count=4} },
    density=0.5,
  },

  m16_zombie =
  {
    prob=20, guard_prob=21, trap_prob=11,
    health=100, damage=40, attack="hitscan",
    give={ {weapon="launch"}, {ammo="rocket",count=2} },
  },

  chainsaw_zombie =
  {
    prob=20, guard_prob=11, trap_prob=31,
    health=100, damage=40, attack="melee",
    give={ {weapon="saw"} },
  },
}


ICDSE_WEAPONS =
{
  bfg = REMOVE_ME,  -- became: upgraded_shotgun

  fist =  -- knife
  {
    rate=1.0, damage=25, attack="melee",
  },

  saw =
  {
    pref=3, add_prob=2, start_prob=1,
    rate=6, damage=15, attack="melee",
  },

  pistol =
  {
    pref=8,
    rate=4.0, damage=15, attack="hitscan",
    ammo="bullet", per=1,
  },

  pistol_pair =
  {
    pref=12, add_prob=10, start_prob=20,
    rate=3.0, damage=30, attack="hitscan",
    ammo="bullet", per=2,
    give={ {ammo="bullet",count=12} },
  },

  shotty =
  {
    pref=40, add_prob=20, start_prob=60,
    rate=1.0, damage=80, attack="hitscan", splash={ 0,10 },
    ammo="shell", per=1,
    give={ {ammo="shell",count=8} },
  },

--[[ this is UPGRADE to the shotgun - so not supported yet
  flak_shotty =
  {
    pref=30, add_prob=20,
    rate=0.9, damage=100, attack="hitscan", splash={ 0,50,50 },
    give={ {ammo="flak",count=24} },
  },
--]]

  super =  -- double barrel
  {
  },

  chain =  -- uzi
  {
  },

  uzi_pair =
  {
  },

  h_grenades =
  {
  },

  gren_launch =
  {
  },

  launch =  -- assault rifle
  {
  },

  plasma =  -- SIG-COW
  {
  },

  satchel =
  {
  },

  minigun  =
  {
  },

  sawed_off =
  {
  },

  beretta =
  {
  },

  revolver =
  {
  },
}


ICDSE_PICKUPS =
{
  green_armor = REMOVE_ME,  -- became: pistol_pair
  rocket      = REMOVE_ME,  -- became: satchel
  cell_box    = REMOVE_ME,  -- became: gren_launch

  flak_shells =
  {
    prob=20, cluster={ 2,5 },
    give={ {ammo="flak",count=4} },
  },
}


ICDSE_POWERUPS =
{
  invul = REMOVE_ME,  -- became: uzi_pair
  invis = REMOVE_ME,  -- became: flak_shells
}


ICDSE_PLAYER_MODEL =
{
  doomguy =
  {
    stats   = { health=0, flak=0, bullet=0, shell=0, rocket=0, cell=0 },
    weapons = { pistol=1, fist=1 },
  }
}


OB_MODULES["icdse"] =
{
  label = "Immoral Conduct - Special Edition",

  for_games = { doom2=1 },
  for_modes = { sp=1, coop=1 },
  for_engines = { edge=1 },

  tables =
  {
    "player_model", ICDSE_PLAYER_MODEL,

    "things",   ICDSE_THINGS,
    "monsters", ICDSE_MONSTERS,
    "weapons",  ICDSE_WEAPONS,
    "pickups",  ICDSE_PICKUPS,
  },
}

