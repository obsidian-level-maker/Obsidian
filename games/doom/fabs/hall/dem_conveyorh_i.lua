--
-- 2-seed-wide hallway : straight piece
--

PREFABS.Hallway_conveyorh_i1 =
{
  file   = "hall/dem_conveyorh_i.wad",
  map    = "MAP01",
  engine = "zdoom",

  theme  = "hell",

  group  = "conveyorh",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  texture_pack = "armaetus",

}

PREFABS.Hallway_conveyorh_i2 =
{
  template  = "Hallway_conveyorh_i1",
  map    = "MAP02",
  style  = "cages",

}

PREFABS.Hallway_conveyorh_i3 =
{
  template  = "Hallway_conveyorh_i1",
  map    = "MAP03",
  style  = "cages",

}

PREFABS.Hallway_conveyorh_i4 =
{
  template  = "Hallway_conveyorh_i1",
  map    = "MAP04",

}

PREFABS.Hallway_conveyorh_i5 =
{
  template  = "Hallway_conveyorh_i1",
  map    = "MAP05",

}

PREFABS.Hallway_conveyorh_i6 =
{
  template  = "Hallway_conveyorh_i1",
  map    = "MAP06",

}

PREFABS.Hallway_conveyorh_i7 =
{
  template  = "Hallway_conveyorh_i1",
  map    = "MAP07",

}

PREFABS.Hallway_conveyorh_i8 =
{
  template  = "Hallway_conveyorh_i1",
  map    = "MAP08",
  style  = "traps",
  prob   = 100,

  filter = "crushers",
}

PREFABS.Hallway_conveyorh_i9 =
{
  template  = "Hallway_conveyorh_i1",
  map    = "MAP09",

}

PREFABS.Hallway_conveyorh_i10 =
{
  template  = "Hallway_conveyorh_i1",
  map    = "MAP10",
  style  = "traps",
  prob   = 100,

}
