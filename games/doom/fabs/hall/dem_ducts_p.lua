--
-- duct piece : 4 ways + junction
--

PREFABS.Hallway_ducts_p1 =
{
  file   = "hall/dem_ducts_p.wad",
  map    = "MAP01",

  group  = "ducts",
  prob   = 50,

  where  = "seeds",
  shape  = "P",
  seed_w = 2,
  seed_h = 2,

}

PREFABS.Hallway_ducts_p2 =
{
  template = "Hallway_ducts_p1",
  map    = "MAP02",
}
