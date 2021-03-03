--
-- 2-seed-wide hallway : corner (L shape)
--

PREFABS.Hallway_conveyorh_c1 =
{
  file   = "hall/dem_conveyorh_c.wad",
  map    = "MAP01",
  engine = "zdoom",

  theme  = "hell",

  group  = "conveyorh",
  prob   = 50,

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,

  texture_pack = "armaetus",

}

PREFABS.Hallway_conveyorh_c2 =
{
  template  = "Hallway_conveyorh_c1",
  map    = "MAP02",
  style  = "cages",

}

PREFABS.Hallway_conveyorh_c3 =
{
  template  = "Hallway_conveyorh_c1",
  map    = "MAP03",

}

PREFABS.Hallway_conveyorh_c4 =
{
  template  = "Hallway_conveyorh_c1",
  map    = "MAP04",

}

PREFABS.Hallway_conveyorh_c5 =
{
  template  = "Hallway_conveyorh_c1",
  map    = "MAP05",

}

PREFABS.Hallway_conveyorh_c6 =
{
  template  = "Hallway_conveyorh_c1",
  map    = "MAP06",
  style  = "traps",
  prob   = 100,

  filter = "crushers",
}
