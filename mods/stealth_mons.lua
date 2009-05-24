----------------------------------------------------------------
--  MODULE: Stealth Monsters
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2009 Enhas
--                     (C) 2009 Andrew Apted
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

STEALTH_THINGS_EDGE =
{
  stealth_arach    = { id=4050, kind="monster", r=66,h=64 },
  stealth_vile     = { id=4051, kind="monster", r=20,h=56 },
  stealth_baron    = { id=4052, kind="monster", r=24,h=64 },
  stealth_caco     = { id=4053, kind="monster", r=31,h=56 },
  stealth_gunner   = { id=4054, kind="monster", r=20,h=56 },
  stealth_demon    = { id=4055, kind="monster", r=30,h=56 },
  stealth_knight   = { id=4056, kind="monster", r=24,h=64 },
  stealth_imp      = { id=4057, kind="monster", r=20,h=56 },
  stealth_mancubus = { id=4058, kind="monster", r=48,h=64 },
  stealth_revenant = { id=4059, kind="monster", r=20,h=64 },
  stealth_shooter  = { id=4060, kind="monster", r=20,h=56 },
  stealth_zombie   = { id=4061, kind="monster", r=20,h=56 },
}

STEALTH_THINGS_ZDOOM =
{
  stealth_arach    = { id=9050, kind="monster", r=66,h=64 },
  stealth_vile     = { id=9051, kind="monster", r=20,h=56 },
  stealth_baron    = { id=9052, kind="monster", r=24,h=64 },
  stealth_caco     = { id=9053, kind="monster", r=31,h=56 },
  stealth_gunner   = { id=9054, kind="monster", r=20,h=56 },
  stealth_demon    = { id=9055, kind="monster", r=30,h=56 },
  stealth_knight   = { id=9056, kind="monster", r=24,h=64 },
  stealth_imp      = { id=9057, kind="monster", r=20,h=56 },
  stealth_mancubus = { id=9058, kind="monster", r=48,h=64 },
  stealth_revenant = { id=9059, kind="monster", r=20,h=64 },
  stealth_shooter  = { id=9060, kind="monster", r=20,h=56 },
  stealth_zombie   = { id=9061, kind="monster", r=20,h=56 },
}


STEALTH_MONSTERS =
{
  -- FIXME: Only Doom II supported for now.

  -- These are basically the same as the ones in doom.lua,
  -- only their probabilites are lower (cut by 3/4).

  stealth_zombie =
  {
    prob=10, cage_prob=11, crazy_prob=0.5,
    health=20, damage=4, attack="hitscan",
    give={ {ammo="bullet",count=5} },
    invis=true,
  },

  stealth_shooter =
  {
    prob=12, guard_prob=11, trap_prob=11, cage_prob=11,
    health=30, damage=10, attack="hitscan",
    give={ {weapon="shotty"}, {ammo="shell",count=4} },
    invis=true,
  },

  stealth_imp =
  {
    prob=15, guard_prob=11, trap_prob=20, cage_prob=50, crazy_prob=25,
    health=60, damage=20, attack="missile",
    invis=true,
  },

  stealth_demon =
  {
    prob=8, guard_prob=31, trap_prob=61,
    health=150, damage=25, attack="melee",
    invis=true,
  },

  stealth_caco =
  {
    prob=10, guard_prob=61, trap_prob=21, cage_prob=21,
    health=400, damage=35, attack="missile",
    density=0.6, float=true,
    invis=true,
  },

  stealth_baron =
  {
    prob=5, guard_prob=11, trap_prob=11, cage_prob=3,
    health=1000, damage=45, attack="missile",
    density=0.3,
    invis=true,
  },
  
  stealth_gunner =
  {
    prob=4, guard_prob=21, trap_prob=41, cage_prob=71,
    health=70, damage=50, attack="hitscan",
    give={ {weapon="chain"}, {ammo="bullet",count=10} },
    invis=true,
  },

  stealth_revenant =
  {
    prob=11, guard_prob=41, trap_prob=41, cage_prob=51, crazy_prob=20,
    health=300, damage=70, attack="missile",
    density=0.6,
    invis=true,
  },

  stealth_knight =
  {
    prob=15, guard_prob=41, trap_prob=41, cage_prob=11,
    health=500, damage=45, attack="missile",
    density=0.4,
    invis=true,
  },

  stealth_mancubus =
  {
    prob=8, guard_prob=41, trap_prob=41, cage_prob=11,
    health=600, damage=70, attack="missile",
    density=0.4,
    invis=true,
  },

  stealth_arach =
  {
    prob=6, guard_prob=21, trap_prob=21, cage_prob=11,
    health=500, damage=70, attack="missile",
    density=0.5,
    invis=true,
  },

  stealth_vile =
  {
    prob=3, guard_prob=11, trap_prob=31, cage_prob=21, crazy_prob=5,
    health=700, damage=40, attack="hitscan",
    density=0.2, never_promote=true,
    invis=true,
  },
}


OB_MODULES["edge_stealth"] =
{
  label = "EDGE Stealth Monsters",

  for_games   = { doom2=1, freedoom=1 },
  for_modes   = { sp=1, coop=1 },
  for_engines = { edge=1 },

  tables =
  {
    "things",   STEALTH_THINGS_EDGE,
    "monsters", STEALTH_MONSTERS,
  },
}

OB_MODULES["zdoom_stealth"] =
{
  label = "ZDoom Stealth Monsters",

  for_games   = { doom2=1, freedoom=1 },
  for_modes   = { sp=1, coop=1 },
  for_engines = { zdoom=1, gzdoom=1, skulltag=1 },

  tables =
  {
    "things",   STEALTH_THINGS_ZDOOM,
    "monsters", STEALTH_MONSTERS,
  },
}

