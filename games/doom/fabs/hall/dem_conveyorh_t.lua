--
-- 2-seed-wide hallway : T shape piece
--

PREFABS.Hallway_conveyorh_t1 =
{
  file   = "hall/dem_conveyorh_t.wad",
  map    = "MAP01",
  engine = "zdoom",

  theme  = "hell",

  group  = "conveyorh",
  prob   = 50,

  where  = "seeds",
  shape  = "T",

  seed_w = 2,
  seed_h = 2,


  texture_pack = "armaetus",

}

PREFABS.Hallway_conveyorh_t2 =
{
  template  = "Hallway_conveyorh_t1",
  map    = "MAP02",
  style  = "cages",

}

PREFABS.Hallway_conveyorh_t3 =
{
  template  = "Hallway_conveyorh_t1",
  map    = "MAP03",

}

PREFABS.Hallway_conveyorh_t4 =
{
  template  = "Hallway_conveyorh_t1",
  map    = "MAP04",

}

PREFABS.Hallway_conveyorh_t5 =
{
  template  = "Hallway_conveyorh_t1",
  map    = "MAP05",

}

PREFABS.Hallway_conveyorh_t6 =
{
  template  = "Hallway_conveyorh_t1",
  map    = "MAP06",
  style  = "traps",
  prob   = 100,

}
