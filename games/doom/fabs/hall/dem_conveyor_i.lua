--
-- 2-seed-wide hallway : I piece
--

PREFABS.Hallway_conveyor_i1 =
{
  file   = "hall/dem_conveyor_i.wad",
  map    = "MAP01",
  engine = "zdoom",

  theme  = "tech",

  group  = "conveyor",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

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

PREFABS.Hallway_conveyor_i2 =
{
  template  = "Hallway_conveyor_i1",
  map    = "MAP02",

}

PREFABS.Hallway_conveyor_i3 =
{
  template  = "Hallway_conveyor_i1",
  map    = "MAP03",

}

PREFABS.Hallway_conveyor_i4 =
{
  template  = "Hallway_conveyor_i1",
  map    = "MAP04",

}

PREFABS.Hallway_conveyor_i5 =
{
  template  = "Hallway_conveyor_i1",
  map    = "MAP05",

}

PREFABS.Hallway_conveyor_i6 =
{
  template  = "Hallway_conveyor_i1",
  map    = "MAP06",

}

PREFABS.Hallway_conveyor_i7 =
{
  template  = "Hallway_conveyor_i1",
  map    = "MAP07",
  style  = "cages",

}

PREFABS.Hallway_conveyor_i8 =
{
  template  = "Hallway_conveyor_i1",
  map    = "MAP08",

}
