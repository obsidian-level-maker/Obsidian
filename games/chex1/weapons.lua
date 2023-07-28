CHEX1.WEAPONS =
{
  spoon =
  {
    attack = "melee",
    rate = 1.5,
    damage = 10
  },

  super_bootspork =
  {
    id = 2005,
    level = 2,
    add_prob = 2,
    start_prob = 1,
    pref = 3,
    attack = "melee",
    rate = 8.7,
    damage = 10
  },

  mini_zorcher =
  {
    pref = 5,
    attack = "hitscan",
    rate = 1.8,
    damage = 10,
    ammo = "mzorch",
    per = 1
  },

  rapid_zorcher =
  {
    id = 2002,
    level = 1,
    add_prob = 35,
    start_prob = 40,
    pref = 70,
    attack = "hitscan",
    rate = 8.5,
    damage = 10,
    ammo = "mzorch",
    per = 1,
    give = { {ammo="mzorch",count=20} }
  },

  large_zorcher =
  {
    id = 2001,
    level = 3,
    add_prob = 10,
    start_prob = 60,
    pref = 70,
    attack = "hitscan",
    rate = 0.9,
    damage = 70,
    splash = { 0,10 },
    ammo = "lzorch",
    per = 1,
    give = { {ammo="lzorch",count=8} }
  },

  zorch_propulsor =
  {
    id = 2003,
    level = 3.5,
    add_prob = 25,
    start_prob = 10,
    rarity = 2,
    pref = 50,
    attack = "missile",
    rate = 1.7,
    damage = 80,
    splash = { 50,20,5 },
    ammo = "propulsor",
    per = 1,
    give = { {ammo="propulsor",count=2} }
  },

  phasing_zorcher =
  {
    id = 2004,
    level = 4,
    add_prob = 13,
    start_prob = 5,
    rarity = 2,
    pref = 90,
    attack = "missile",
    rate = 11,
    damage = 20,
    ammo = "phase",
    per = 1,
    give = { {ammo="phase",count=40} }
  },

  laz_device =
  {
    id = 2006,
    level = 4,
    add_prob = 30,
    start_prob = 0.2,
    rarity = 5,
    pref = 30,
    attack = "missile",
    rate = 0.8,
    damage = 300,
    splash = {60,45,30,30,20,10},
    ammo = "phase",
    per = 40,
    give = { {ammo="phase",count=40} }
  }
}
