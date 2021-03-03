--
-- 2-seed-wide hallway : dead-end piece
--

PREFABS.Hallway_conveyorh_u1 =
{
  file   = "hall/dem_conveyorh_u.wad",
  map    = "MAP01",
  engine = "zdoom",

  theme  = "hell",

  group  = "conveyorh",
  prob   = 50,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 2,

  texture_pack = "armaetus",

}

PREFABS.Hallway_conveyorh_u2 =
{
  template  = "Hallway_conveyorh_u1",
  map    = "MAP02",

}

PREFABS.Hallway_conveyorh_u3 =
{
  template  = "Hallway_conveyorh_u1",
  map    = "MAP03",

}
