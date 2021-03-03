--
-- 2-seed-wide hallway : four-way "+" junction
--

PREFABS.Hallway_conveyorh_p1 =
{
  file   = "hall/dem_conveyorh_p.wad",
  map    = "MAP01",
  engine = "zdoom",

  theme  = "hell",

  group  = "conveyorh",
  prob   = 50,

  where  = "seeds",
  shape  = "P",

  seed_w = 2,
  seed_h = 2,

  texture_pack = "armaetus",

}

PREFABS.Hallway_conveyorh_p2 =
{
  template  = "Hallway_conveyorh_p1",
  map    = "MAP02",

}

PREFABS.Hallway_conveyorh_p3 =
{
  template  = "Hallway_conveyorh_p1",
  map    = "MAP03",

}

