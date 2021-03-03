--
-- 2-seed-wide hallway : corner (L shape)
--

PREFABS.Hallway_conveyor_c1 =
{
  file   = "hall/dem_conveyor_c.wad",
  map    = "MAP01",
  engine = "zdoom",

  theme  = "tech",

  group  = "conveyor",
  prob   = 50,

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,

  texture_pack = "armaetus",

 thing_2035 =
  {
    barrel = 60,
    nothing = 40,
  },

  sound = "Conveyor_Mech",
}

PREFABS.Hallway_conveyor_c2 =
{
  template  = "Hallway_conveyor_c1",
  map    = "MAP02",

}

PREFABS.Hallway_conveyor_c3 =
{
  template  = "Hallway_conveyor_c1",
  map    = "MAP03",

}

PREFABS.Hallway_conveyor_c4 =
{
  template  = "Hallway_conveyor_c1",
  map    = "MAP04",

}

PREFABS.Hallway_conveyor_c5 =
{
  template  = "Hallway_conveyor_c1",
  map    = "MAP05",

}
