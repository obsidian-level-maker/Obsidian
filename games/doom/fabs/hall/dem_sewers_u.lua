--
-- duct piece : dead ends
--

PREFABS.Hallway_sewers_u1 =
{
  file   = "hall/dem_sewers_u.wad",
  map    = "MAP01",

  group  = "sewers",
  prob   = 50,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 2,

  engine = "zdoom",

}

PREFABS.Hallway_sewers_u2 =
{
  template = "Hallway_sewers_u1",
  map    = "MAP02",
  style  = "cages",
}

PREFABS.Hallway_sewers_u3 =
{
  template = "Hallway_sewers_u1",
  map    = "MAP03",
  style  = "cages",
}

PREFABS.Hallway_sewers_u4 =
{
  template = "Hallway_sewers_u1",
  map    = "MAP04",
}

PREFABS.Hallway_sewers_u5 =
{
  template = "Hallway_sewers_u1",
  map    = "MAP05",
}

PREFABS.Hallway_sewers_u6 =
{
  template = "Hallway_sewers_u1",
  map    = "MAP06",
  style  = "cages",
}

PREFABS.Hallway_sewers_u7 =
{
  template = "Hallway_sewers_u1",
  map    = "MAP07",

  thing_2014 =
  {
    stimpack = 50,
    bullet_box = 50,
    shell_box = 50,
    green_armor = 50,
  }

}

PREFABS.Hallway_sewers_u8 =
{
  template = "Hallway_sewers_u1",
  map    = "MAP08",
}
