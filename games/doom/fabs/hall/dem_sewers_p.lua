--
-- sewers piece : 4 ways + junction
--

PREFABS.Hallway_sewers_p1 =
{
  file   = "hall/dem_sewers_p.wad",
  map    = "MAP01",

  group  = "sewers",
  prob   = 50,

  where  = "seeds",
  shape  = "P",
  seed_w = 2,
  seed_h = 2,

  engine = "zdoom",

  sound = "Water_Draining",
}

PREFABS.Hallway_sewers_p2 =
{
  template = "Hallway_sewers_p1",
  map    = "MAP02",
}


PREFABS.Hallway_sewers_p3 =
{
  template = "Hallway_sewers_p1",
  map    = "MAP03",
}


PREFABS.Hallway_sewers_p4 =
{
  template = "Hallway_sewers_p1",
  map    = "MAP04",
}


PREFABS.Hallway_sewers_p5 =
{
  template = "Hallway_sewers_p1",
  map    = "MAP05",
}
