------------------------------------------------------------------------
--  STRIFE MONSTERS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

STRIFE.MONSTERS =
{

  acolyte_blue =
  {
    id=231,
    r=24,
    h=64,
    level = 1,
    prob = 5,
    density = 0.2,
    health = 70,
    damage = 8,
    attack = "hitscan",
    weap_needed = { assault=true },
    give = { {ammo="bullet",count=50} },
  },

  acolyte_gray =
  {
    id=146,
    r=24,
    h=64,
    level = 1,
    prob = 5,
    density = 0.2,
    health = 70,
    damage = 8,
    attack = "hitscan",
    weap_needed = { assault=true },
    give = { {ammo="bullet",count=50} },
  },

  -- Prevent spamming guard uniform drops
  --[[acolyte_dark_green =
  {
    id=147,
    r=24,
    h=64,
    level = 1,
    prob = 5,
    density = 0.2,
    health = 70,
    damage = 8,
    attack = "hitscan",
    weap_needed = { assault=true },
    give = { {ammo="bullet",count=50} },
  },]]--

  acolyte_gold =
  {
    id=148,
    r=24,
    h=64,
    level = 1,
    prob = 5,
    density = 0.2,
    health = 70,
    damage = 8,
    attack = "hitscan",
    weap_needed = { assault=true },
    give = { {ammo="bullet",count=50} },
  },

  acolyte_light_green =
  {
    id=232,
    r=24,
    h=64,
    level = 1,
    prob = 5,
    density = 0.2,
    health = 70,
    damage = 8,
    attack = "hitscan",
    weap_needed = { assault=true },
    give = { {ammo="bullet",count=50} },
  },

  acolyte_red =
  {
    id=142,
    r=24,
    h=64,
    level = 1,
    prob = 5,
    density = 0.2,
    health = 70,
    damage = 8,
    attack = "hitscan",
    weap_needed = { assault=true },
    give = { {ammo="bullet",count=50} },
  },

  acolyte_rust =
  {
    id=143,
    r=24,
    h=64,
    level = 1,
    prob = 5,
    density = 0.2,
    health = 70,
    damage = 8,
    attack = "hitscan",
    weap_needed = { assault=true },
    give = { {ammo="bullet",count=50} },
  },

  acolyte_shadow =
  {
    id=58,
    r=24,
    h=64,
    level = 3,
    prob = 5,
    density = 0.2,
    health = 70,
    damage = 8,
    attack = "hitscan",
    weap_needed = { assault=true },
    give = { {ammo="bullet",count=50} },
    invis = true
  },

  stalker =
  {
    id=186,
    r=24,
    h=64,
    level = 2,
    prob = 5,
    density = 0.2,
    health = 70,
    damage = 10, -- No idea
    attack = "melee",
    indoor_only = true
  },

  sentinel =
  {
    id=3006,
    r=24,
    h=64,
    level = 4,
    prob = 5,
    density = 0.2,
    health = 100,
    damage = 8, -- No idea
    attack = "hitscan",
  },

  reaver =
  {
    id=3001,
    r=24,
    h=64,
    level = 5,
    prob = 5,
    density = 0.2,
    health = 150,
    damage = 10, -- No idea
    attack = "hitscan",
  },

  templar =
  {
    id=3003,
    r=24,
    h=64,
    level = 6,
    prob = 5,
    density = 0.2,
    health = 300,
    damage = 20, -- No idea
    attack = "hitscan",
  },

  crusader =
  {
    id=3005,
    r=24,
    h=64,
    level = 7,
    prob = 5,
    density = 0.2,
    health = 400,
    damage = 20, -- No idea
    attack = "missile",
  },


--- BOSSES ---

  inquisitor =
  {
    id=16,
    r=24,
    h=64,
    level = 9,
    prob = 5,
    boss_type = "minor",
    boss_prob = 50,
    density = 0.2,
    health = 1000,
    damage = 25, -- No idea
    attack = "hitscan",
    float = true
  },

  programmer =
  {
    id=71,
    r=24,
    h=64,
    level = 9,
    prob = 5,
    boss_type = "tough",
    boss_prob = 50,
    density = 0.2,
    health = 1100,
    damage = 25, -- No idea
    attack = "hitscan",
    float = true
  },

  bishop =
  {
    id=187,
    r=24,
    h=64,
    level = 9,
    prob = 5,
    boss_type = "tough",
    boss_prob = 50,
    density = 0.2,
    health = 1700, -- Plus Spectre
    damage = 30, -- No idea
    attack = "missile",
  },

  loremaster =
  {
    id=12,
    r=24,
    h=64,
    level = 9,
    prob = 5,
    boss_type = "tough",
    boss_prob = 50,
    density = 0.2,
    health = 2800, -- Plus Spectre
    damage = 30, -- No idea
    attack = "melee",
  },

}

