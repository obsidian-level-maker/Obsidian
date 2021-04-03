HACX.PICKUPS =
{
  -- HEALTH --

  dampener =
  {
    id = 2014,
    prob = 20,
    cluster = { 4,7 },
    give = { {health=1} }
  },

  microkit =
  {
    id = 2011,
    prob = 60,
    cluster = { 2,5 },
    give = { {health=10} }
  },

  hypo =
  {
    id = 2012,
    prob = 100,
    cluster = { 1,3 },
    give = { {health=25} }
  },

  smart_drug =
  {
    id = 2013,
    prob = 3,
    big_item = true,
    give = { {health=150} }
  },

  -- ARMOR --

  inhaler =
  {
    id = 2015,
    prob = 10,
    armor = true,
    cluster = { 4,7 },
    give = { {health=1} }
  },

  kevlar_armor =
  {
    id = 2018,
    prob = 5,
    armor = true,
    big_item = true,
    give = { {health=30} }
  },

  super_armor =
  {
    id = 2019,
    prob = 2,
    armor = true,
    big_item = true,
    give = { {health=90} }
  },

  -- AMMO --

  bullets =
  {
    id = 2007,
    prob = 10,
    cluster = { 2,5 },
    give = { {ammo="bullet",count=10} }
  },

  bullet_box =
  {
    id = 2048,
    prob = 40,
    cluster = { 1,3 },
    give = { {ammo="bullet", count=50} }
  },

  shells =
  {
    id = 2008,
    prob = 20,
    cluster = { 2,5 },
    give = { {ammo="shell",count=4} }
  },

  shell_box =
  {
    id = 2049,
    prob = 40,
    cluster = { 1,3 },
    give = { {ammo="shell",count=20} }
  },

  torpedos =
  {
    id = 2010,
    prob = 10,
    cluster = { 4,7 },
    give = { {ammo="torpedo",count=1} }
  },

  torpedo_box =
  {
    id = 2046,
    prob = 40,
    cluster = { 1,3 },
    give = { {ammo="torpedo",count=5} }
  },

  molecules =
  {
    id = 2047,
    prob = 20,
    cluster = { 2,5 },
    give = { {ammo="molecule",count=20} }
  },

  mol_tank =
  {
    id = 17,
    prob = 40,
    cluster = { 1,2 },
    give = { {ammo="molecule",count=100} }
  }
}

HACX.NICE_ITEMS =
{

  smart_drug =
  {
    id = 2013,
    prob = 3,
    big_item = true,
    give = { {health=150} }
  },
  
  super_armor =
  {
    id = 2019,
    prob = 2,
    armor = true,
    big_item = true,
    give = { {health=90} }
  },

}

