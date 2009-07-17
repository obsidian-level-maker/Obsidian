----------------------------------------------------------------
--  MODULE: Stealth Monsters
----------------------------------------------------------------
--
--  Copyright (C) 2009 Enhas
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

-- NOTE: Only Doom II supported for now.

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
  -- These are basically the same as the ones in doom.lua,
  -- but with some different trap_prob or crazy_prob values.

  stealth_zombie =
  {
    replaces="zombie", replace_prob=30, crazy_prob=0.5,
    health=20, damage=4, attack="hitscan",
    give={ {ammo="bullet",count=5} },
    invis=true,
  },

  stealth_shooter =
  {
    replaces="shooter", replace_prob=20, crazy_prob=11,
    health=30, damage=10, attack="hitscan",
    give={ {weapon="shotty"}, {ammo="shell",count=4} },
    invis=true,
  },

  stealth_imp =
  {
    replaces="imp", replace_prob=40, trap_prob=20, crazy_prob=25,
    health=60, damage=20, attack="missile",
    invis=true,
  },

  stealth_demon =
  {
    replaces="demon", replace_prob=40, trap_prob=61, crazy_prob=30,
    health=150, damage=25, attack="melee",
    invis=true,
  },

  stealth_caco =
  {
    replaces="caco", replace_prob=25, crazy_prob=41,
    health=400, damage=35, attack="missile",
    invis=true, float=true, density=0.6,
  },

  stealth_baron =
  {
    replaces="baron", replace_prob=20, crazy_prob=10,
    health=1000, damage=45, attack="missile",
    invis=true, density=0.3,
  },
  
  stealth_gunner =
  {
    replaces="gunner", replace_prob=20, crazy_prob=21,
    health=70, damage=50, attack="hitscan",
    give={ {weapon="chain"}, {ammo="bullet",count=10} },
    invis=true,
  },

  stealth_revenant =
  {
    replaces="revenant", replace_prob=30, crazy_prob=40,
    health=300, damage=70, attack="missile",
    invis=true, density=0.6,
  },

  stealth_knight =
  {
    replaces="knight", replace_prob=25, crazy_prob=11,
    health=500, damage=45, attack="missile",
    invis=true, density=0.4,
  },

  stealth_mancubus =
  {
    replaces="mancubus", replace_prob=25, trap_prob=30, crazy_prob=31,
    health=600, damage=70, attack="missile",
    invis=true, density=0.4,
  },

  stealth_arach =
  {
    replaces="arach", replace_prob=25, crazy_prob=11,
    health=500, damage=70, attack="missile",
    invis=true, density=0.5,
  },

  stealth_vile =
  {
    replaces="vile", replace_prob=10, trap_prob=30, crazy_prob=5,
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

