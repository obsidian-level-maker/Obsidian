HARMONY.PICKUPS =
{
  -- HEALTH --

  mushroom =
  {
    id = 2011
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  first_aid =
  {
    id = 2012
    prob = 100
    cluster = { 1,3 }
    give = { {health=25} }
  }

  mushroom_wow =
  {
    id = 2013
    prob = 3
    big_item = true
    give = { {health=150} }
  }

  -- ARMOR --

  amazon_armor =
  {
    id = 2018
    prob = 5
    armor = true
    big_item = true
    give = { {health=30} }
  }

  NDF_armor =
  {
    id = 2019
    prob = 2
    armor = true
    big_item = true
    give = { {health=90} }
  }

  -- AMMO --

  mini_box =
  {
    id = 2048
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="bullet", count=40} }
  }

  shell_box =
  {
    id = 2049
    prob = 40
    cluster = { 1,4 }
    give = { {ammo="shell",count=10} }
  }

  cell_pack =
  {
    id = 17
    prob = 40
    give = { {ammo="cell",count=100} }
  }

  grenade =
  {
    id = 2010
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="grenade",count=1} }
  }

  nade_belt =
  {
    id = 2046
    prob = 40
    cluster = { 1,2 }
    give = { {ammo="grenade",count=5} }
  }
}