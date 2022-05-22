------------------------------------------------------------------------
--  HEXEN MONSTERS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HEXEN.MONSTERS =
{
  ettin =
  {
    id = 10030,
    r = 24,
    h = 64,
    level = 1,
    prob = 60,
    health = 175,
    damage =  16,
    attack = "melee",
  },

  afrit =
  {
    id = 10060,
    r = 24,
    h = 64,
    level = 1,
    prob = 40,
    health = 80,
    damage = 8,
    attack = "missile",
    float = true
  },

  centaur1 =
  {
    id = 107,
    r = 20,
    h = 64,
    level = 2,
    prob = 40,
    health = 200,
    damage = 12,
    attack = "melee",
  },

  centaur2 =
  {
    id = 115,
    r = 20,
    h = 64,
    level = 4,
    prob = 20,
    health = 250,
    damage = 20,
    attack = "missile",
  },

  serpent1 =
  {
    id = 121,
    r = 33,
    h = 64,
    level = 1,
    health = 90,
    damage = 10,
    attack = "melee",
    liquid_only = true
  },

  serpent2 =
  {
    id = 120,
    r = 33,
    h = 64,
    level = 1,
    health = 90,
    damage = 16,
    attack = "missile",
    liquid_only = true
  },
  
  wendigo =  -- iceguy
  {
    id = 8020,
    r = 24,
    h = 80,
    level = 1,
    health = 120,
    damage = 25,
    attack = "missile",
  },

  demon1 =
  {
    id = 31,
    r = 33,
    h = 70,
    level = 3,
    prob = 30,
    health = 250,
    damage = 40,
    attack = "missile",
  },

  demon2 =
  {
    id = 8080,
    r = 33,
    h = 70,
    level = 4,
    health = 250,
    damage = 40,
    attack = "missile",
  },

  bishop =
  {
    id = 114,
    r = 24,
    h = 64,
    level = 6,
    prob = 20,
    health = 130,
    damage = 24,
    attack = "missile",
    float = true
  },

  reiver_b  =
  {
    id = 10011,
    r = 24,
    h = 64,
    level = 6,
    health = 150,
    damage = 50,
    attack = "missile",
    float = true
  },
  
  reiver =
  {
    id = 34,
    r = 24,
    h = 64,
    level = 7,
    prob = 5,
    health = 150,
    damage = 50,
    attack = "missile",
    float = true
  },

  ---| BOSSES |---

  -- FIXME: proper damage and attack fields

  Heresiarch =
  {
    id = 10080,
    r = 40,
    h = 120,
    level = 9,
    boss_type = "tough",
    attack = "missile",
    health = 5000,
    damage = 250,
  },

  Zedek =  -- Fighter_boss
  {
    id = 10100,
    r = 16,
    h = 64,
    level = 9,
    boss_type = "tough",
    attack = "melee",
    health = 800,
    damage = 640, -- Full Quietus hit
  },

  Traductus =  -- Cleric_boss
  {
    id = 10101,
    r = 16,
    h = 64,
    level = 9,
    boss_type = "tough",
    attack = "missile",
    health = 800,
    damage = 128, -- 4 * 32 per wraith from Wraithverge
  },

  Menelkir =  -- Mage_boss
  {
    id = 10102,
    r = 16,
    h = 64,
    level = 9,
    boss_type = "tough",
    attack = "missile",
    health = 800,
    damage = 336, -- 3 * Bloodscourge projectile/blasts
  },

  Korax =
  {
    id = 10200,
    r = 66,
    h = 120,
    level = 9,
    boss_type = "singular",
    attack = "missile",
    health = 5000,
    damage = 500,
  },
}

