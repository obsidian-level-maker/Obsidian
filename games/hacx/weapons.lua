HACX.WEAPONS =
{
  boot =
  {
    rate = 2.5,
    damage = 5,
    attack = "melee"
  },

  pistol =
  {
    pref = 5,
    rate = 2.0,
    damage = 20,
    attack = "hitscan",
    ammo = "bullet",
    per = 1
  },

  tazer =
  {
    id = 2001,
    level = 1,
    pref = 20,
    add_prob = 10,
    start_prob = 60,
    attack = "hitscan",
    rate = 1.2,
    damage = 70,
    ammo = "shell",
    per = 1,
    give = { {ammo="shell",count=8} }
  },

  cryogun =
  {
    id = 82,
    level = 3,
    pref = 40,
    add_prob = 20,
    attack = "hitscan",
    rate = 0.9,
    damage = 170,
    splash = { 0,30 },
    ammo = "shell",
    per = 2,
    give = { {ammo="shell",count=8} }
  },

  fu2 =
  {
    id = 2002,
    level = 3,
    pref = 40,
    add_prob = 35,
    attack = "hitscan",
    rate = 8.6,
    damage = 10,
    ammo = "bullet",
    per = 1,
    give = { {ammo="bullet",count=20} }
  },

  zooka =
  {
    id = 2003,
    level = 3,
    pref = 20,
    add_prob = 25,
    attack = "missile",
    rate = 1.7,
    damage = 80,
    splash = { 50,20,5 },
    ammo = "torpedo",
    per = 1,
    give = { {ammo="torpedo",count=2} }
  },

  antigun =
  {
    id = 2004,
    level = 5,
    pref = 50,
    add_prob = 13,
    attack = "missile",
    rate = 16,
    damage = 20,
    ammo = "molecule",
    per = 1,
    give = { {ammo="molecule",count=40} }
  },

  nuker =
  {
    id = 2006,
    level = 7,
    pref = 20,
    add_prob = 30,
    attack = "missile",
    rate = 1.4,
    damage = 300,
    splash = {60,60,60,60, 60,60,60,60 },
    ammo = "molecule",
    per = 40,
    give = { {ammo="molecule",count=40} }
  }
}
