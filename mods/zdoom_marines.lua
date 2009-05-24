----------------------------------------------------------------
--  MODULE: ZDoom Marines
----------------------------------------------------------------
--
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

ZDOOM_MARINE_THINGS =
{
  marine_fist    = { id=9101, kind="monster", r=16,h=56 },
  marine_berserk = { id=9102, kind="monster", r=16,h=56 },
  marine_saw     = { id=9103, kind="monster", r=16,h=56 },
  marine_pistol  = { id=9104, kind="monster", r=16,h=56 },
  marine_shotty  = { id=9105, kind="monster", r=16,h=56 },
  marine_ssg     = { id=9106, kind="monster", r=16,h=56 },
  marine_chain   = { id=9107, kind="monster", r=16,h=56 },
  marine_rocket  = { id=9108, kind="monster", r=16,h=56 },
  marine_plasma  = { id=9109, kind="monster", r=16,h=56 },
  marine_rail    = { id=9110, kind="monster", r=16,h=56 },
  marine_bfg     = { id=9111, kind="monster", r=16,h=56 },
}

ZDOOM_MARINE_MONSTERS =
{
  -- Doom II is required, because SSG Marine needs SSG sounds.

  -- None of these drop anything.

  -- The damage values below are not accurate,
  -- to keep too much health from spawning in the map.  May need more tweaking.

  -- Marines of all types (well, except the fist) are extremely dangerous,
  -- hence the low probabilities and never_promote.
  -- We want them all to be rare.

  marine_fist =
  {
    prob=0.5,
    health=100, damage=4, attack="melee",
    never_promote=true,
  },

  marine_berserk =
  {
    prob=3, trap_prob=3,
    health=100, damage=40, attack="melee",
    never_promote=true,
  },

  marine_saw =
  {
    prob=2, trap_prob=2,
    health=100, damage=15, attack="melee",
    never_promote=true,
  },

  marine_pistol =
  {
    prob=6, cage_prob=2,
    health=100, damage=8, attack="hitscan",
    never_promote=true,
  },

  marine_shotty =
  {
    prob=4, guard_prob=3, trap_prob=3, cage_prob=2,
    health=100, damage=10, attack="hitscan",
    never_promote=true,
  },

  marine_ssg =
  {
    prob=3, guard_prob=2, trap_prob=2, cage_prob=1,
    health=100, damage=65, attack="hitscan",
    never_promote=true,
  },

  marine_chain =
  {
    prob=3, guard_prob=3, trap_prob=3, cage_prob=2,
    health=100, damage=50, attack="hitscan",
    never_promote=true,
  },

  marine_rocket =
  {
    prob=2, guard_prob=2, trap_prob=1, cage_prob=2, crazy_prob=10,
    health=100, damage=100, attack="missile",
    never_promote=true,
  },

  marine_plasma =
  {
    prob=2, guard_prob=1, trap_prob=1, cage_prob=2, crazy_prob=6,
    health=100, damage=70, attack="missile",
    never_promote=true,
  },

  marine_rail =
  {
    prob=1, guard_prob=1, trap_prob=1, cage_prob=1,
    health=100, damage=100, attack="hitscan",
    never_promote=true,
  },

  marine_bfg =
  {
    prob=1, guard_prob=1, trap_prob=1, cage_prob=1,
    health=100, damage=100, attack="missile",
    never_promote=true,
  },
}

-- Monster / Weapon prefs may go here eventually

OB_MODULES["zdoom_marines"] =
{
  label = "ZDoom Marines",

  for_games   = { doom2=1, freedoom=1 },
  for_modes   = { sp=1, coop=1 },
  for_engines = { zdoom=1, gzdoom=1, skulltag=1 },

  tables =
  {
    "things",   ZDOOM_MARINE_THINGS,
    "monsters", ZDOOM_MARINE_MONSTERS,
  },
}

