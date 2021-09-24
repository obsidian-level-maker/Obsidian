HARMONY.WEAPONS =
{
  -- FIXME: most of these need to be checked, get new firing rates (etc etc)

  blow_uppa_ya_face =
  {
    attack = "missile",
    rate = 0.7,
    damage = 20
  },

  pistol =
  {
    pref = 5,
    attack = "missile",
    rate = 2.0,
    damage = 20,
    ammo = "cell",
    per = 1
  },

  minigun =
  {
    id = 2002,
    level = 3,
    add_prob = 35,
    start_prob = 40,
    pref = 70,
    attack = "hitscan",
    rate = 8.5,
    damage = 10,
    ammo = "bullet",
    per = 1,
    give = { {ammo="bullet",count=20} }
  },

  shotgun =
  {
    id = 2001,
    add_prob = 10,
    level = 2,
    start_prob = 60,
    pref = 70,
    attack = "hitscan",
    rate = 0.9,
    damage = 70,
    splash = { 0,10 },
    ammo = "shell",
    per = 1,
    give = { {ammo="shell",count=8} }
  },

  launcher =
  {
    id = 2003,
    add_prob = 25,
    level = 4,
    start_prob = 15,
    pref = 40,
    attack = "missile",
    rate = 1.7,
    damage = 80,
    splash = { 50,20,5 },
    ammo = "grenade",
    per = 1,
    give = { {ammo="grenade",count=2} }
  },

  entropy =
  {
    id = 2004,
    add_prob = 13,
    start_prob = 7,
    level = 4,
    pref = 25,
    rate = 11,
    damage = 20,
    attack = "missile",
    ammo = "cell",
    per = 1,
    give = { {ammo="cell",count=40} }
  }

-- FIXME  h_grenade = { id = 2006 }
}
