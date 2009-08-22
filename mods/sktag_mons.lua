----------------------------------------------------------------
--  MODULE: Skulltag Monsters and Items
----------------------------------------------------------------
--
--  Copyright (C) 2009 Andrew Apted
--  Copyright (C) 2009 Chris Pisarczyk
--  Copyright (C) 2009 Enhas
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

SKULLTAG_THINGS =
{
  -- monsters
  darkimp    = { id=5003, kind="monster", r=20,h=56 },
  bldemon    = { id=5004, kind="monster", r=30,h=56 },
  superguy   = { id=5005, kind="monster", r=20,h=56 },
  cacolant   = { id=5006, kind="monster", r=31,h=56 },
  hectebus   = { id=5007, kind="monster", r=48,h=64 },
  belphegor  = { id=5008, kind="monster", r=24,h=64 },
  abaddon    = { id=5015, kind="monster", r=31,h=56 },

  -- weapons
  glaunch = { id=5011, kind="pickup", r=20,h=16, pass=true },
  railgun = { id=5012, kind="pickup", r=20,h=16, pass=true },
  bfg10k  = { id=5013, kind="pickup", r=20,h=16, pass=true },
  minigun = { id=5014, kind="pickup", r=20,h=16, pass=true },

  -- pickups
  max_potion = { id=5090, kind="pickup", r=20,h=16, pass=true },
  max_helmet = { id=5091, kind="pickup", r=20,h=16, pass=true },
  red_armor  = { id=5040, kind="pickup", r=20,h=16, pass=true },
}


SKULLTAG_MONSTERS =
{
  darkimp =
  {
    prob=55, guard_prob=11, trap_prob=11, cage_prob=40,
    health=120, damage=30, attack="missile",
    density=0.6,
  },

  superguy =
  {
    prob=33, guard_prob=21, trap_prob=11, cage_prob=30,
    health=120, damage=65, attack="hitscan",
    give={ {weapon="super"}, {ammo="shell",count=4} },
    density=0.5,
  },

  bldemon =
  {
    prob=20, guard_prob=11, trap_prob=31,
    health=300, damage=25, attack="melee",
    density=0.5,
  },

  cacolant =
  {
    prob=25, guard_prob=21, trap_prob=11, cage_prob=11, crazy_prob=10,
    health=800, damage=55, attack="missile",
    density=0.4, float=true,
  },

  hectebus =
  {
    prob=35, guard_prob=21, trap_prob=21, cage_prob=88,
    health=1200, damage=120, attack="missile",
    density=0.2,
  },

  abaddon =
  {
    prob=15, guard_prob=21, trap_prob=11, cage_prob=5, crazy_prob=25,
    health=1200, damage=65, attack="missile",
    density=0.2, float=true,
  },

  belphegor =
  {
    prob=15, guard_prob=21, trap_prob=21, cage_prob=5, crazy_prob=25,
    health=1500, damage=80, attack="missile",
    density=0.2,
  },
}

SKULLTAG_WEAPONS =
{
  minigun =
  {
    pref=85, add_prob=40,  start_prob=20,
    rate=15, damage=10, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",count=20} },
  },

  glaunch =
  {
    pref=50, add_prob=40,  start_prob=20,
    rate=1.7, damage=90, attack="missile", --FIXME splash damage
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=2} },
  },

  railgun =
  {
    pref=20, add_prob=20, start_prob=7,
    rate=3, damage=200, attack="hitscan",
    ammo="cell", per=10,
    give={ {ammo="cell",count=40} },
  },

  bfg10k =
  {
    pref=15, add_prob=2, start_prob=0.1,
    rate=1.2, damage=300, attack="missile", --FIXME splash damage
    ammo="cell", per=5,
    give={ {ammo="cell",count=40} },
  },
}


SKULLTAG_PICKUPS =
{
  max_potion =
  {
    prob=1, cluster={ 1,2 },
    give={ {health=1} },
  },

  max_helmet =
  {
    prob=1, armor=true, cluster={ 1,2 },
    give={ {health=1} },
  },

  red_armor =
  {
    prob=2, armor=true, big_item=true,
    give={ {health=90} },
  },
}

function Skulltag_Setup(self)
  if OB_CONFIG.game == "doom1" then
    GAME.monsters["superguy"] = nil
    GAME.monsters["hectebus"] = nil
  end
end


OB_MODULES["sktag_mons"] =
{
  label = "Skulltag Monsters and Items",

  for_games = { doom1=1, doom2=1, freedoom=1 },
  for_modes = { sp=1, coop=1 },
  for_engines = { skulltag=1 },

  setup_func = Skulltag_Setup,

  tables =
  {
    "things",   SKULLTAG_THINGS,
    "monsters", SKULLTAG_MONSTERS,
    "weapons",  SKULLTAG_WEAPONS,
    "pickups",  SKULLTAG_PICKUPS,
  },
}
