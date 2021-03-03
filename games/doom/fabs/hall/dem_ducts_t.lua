--
-- duct piece : T junction
--

PREFABS.Hallway_ducts_t1 =
{
  file   = "hall/dem_ducts_t.wad",
  map    = "MAP01",

  group  = "ducts",
  prob   = 50,

  where  = "seeds",
  shape  = "T",

  seed_w = 2,
  seed_h = 2,

}

PREFABS.Hallway_ducts_t2 =
{
  template = "Hallway_ducts_t1",
  map    = "MAP02",
}

PREFABS.Hallway_ducts_t3 =
{
  template = "Hallway_ducts_t1",
  map    = "MAP03",
}

PREFABS.Hallway_ducts_t4 =
{
  template = "Hallway_ducts_t1",
  map    = "MAP04",
}

PREFABS.Hallway_ducts_t5 =
{
  template = "Hallway_ducts_t1",
  map    = "MAP05",
  engine = "zdoom",

  sound = "Indoor_Fan",
}
