CHEX3.PICKUPS =
{
  -- HEALTH --

  water =
  {
    id = 2014,
    prob = 20,
    cluster = { 4,7 },
    give = { {health=1} }
  },

  fruit =
  {
    id = 2011,
    prob = 60,
    cluster = { 2,5 },
    give = { {health=10} }
  },

  vegetables =
  {
    id = 2012,
    prob = 100,
    cluster = { 1,3 },
    give = { {health=25} }
  },

  supercharge =
  {
    id = 2013,
    prob = 3,
    big_item = true,
    give = { {health=150} }
  },

  -- ARMOR --

  repellent =
  {
    id = 2015,
    prob = 10,
    armor = true,
    cluster = { 4,7 },
    give = { {health=1} }
  },

  armor =
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

  mini_zorch =
  {
    id = 2007,
    prob = 10,
    cluster = { 2,5 },
    give = { {ammo="mzorch",count=10} }
  },

  mini_pack =
  {
    id = 2048,
    prob = 40,
    cluster = { 1,3 },
    give = { {ammo="mzorch", count=50} }
  },

  large_zorch =
  {
    id = 2008,
    prob = 20,
    cluster = { 2,5 },
    give = { {ammo="lzorch",count=4} }
  },

  large_pack =
  {
    id = 2049,
    prob = 40,
    cluster = { 1,3 },
    give = { {ammo="lzorch",count=20} }
  },

  propulsor_zorch =
  {
    id = 2010,
    prob = 10,
    cluster = { 4,7 },
    give = { {ammo="propulsor",count=1} }
  },

  propulsor_pack =
  {
    id = 2046,
    prob = 40,
    cluster = { 1,3 },
    give = { {ammo="propulsor",count=5} }
  },

  phasing_zorch =
  {
    id = 2047,
    prob = 20,
    cluster = { 2,5 },
    give = { {ammo="phase",count=20} }
  },

  phasing_pack =
  {
    id = 17,
    prob = 40,
    cluster = { 1,2 },
    give = { {ammo="phase",count=100} }
  }
}
