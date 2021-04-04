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


HARMONY.PICKUPS =
{
  -- HEALTH --

  mushroom =
  {
    id = 2011,
    prob = 60,
    cluster = { 2,5 },
    give = { {health=10} }
  },

  first_aid =
  {
    id = 2012,
    prob = 100,
    cluster = { 1,3 },
    give = { {health=25} }
  },

  mushroom_wow =
  {
    id = 2013,
    prob = 3,
    big_item = true,
    give = { {health=150} }
  },

  -- ARMOR --

  amazon_armor =
  {
    id = 2018,
    prob = 5,
    armor = true,
    big_item = true,
    give = { {health=30} }
  },

  NDF_armor =
  {
    id = 2019,
    prob = 2,
    armor = true,
    big_item = true,
    give = { {health=90} }
  },

  -- AMMO --

  mini_box =
  {
    id = 2048,
    prob = 40,
    cluster = { 1,3 },
    give = { {ammo="bullet", count=40} }
  },

  shell_box =
  {
    id = 2049,
    prob = 40,
    cluster = { 1,4 },
    give = { {ammo="shell",count=10} }
  },

  cell_pack =
  {
    id = 17,
    prob = 40,
    give = { {ammo="cell",count=100} }
  },

  grenade =
  {
    id = 2010,
    prob = 20,
    cluster = { 2,5 },
    give = { {ammo="grenade",count=1} }
  },

  nade_belt =
  {
    id = 2046,
    prob = 40,
    cluster = { 1,2 },
    give = { {ammo="grenade",count=5} }
  }
}
