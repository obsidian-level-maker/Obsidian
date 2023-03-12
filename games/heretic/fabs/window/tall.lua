--
-- a tall square window
--

PREFABS.Window_tall_1 =
{
  file   = "window/tall.wad",
  map    = "MAP01",

  group  = "tall",
  prob   = 50,


  height = 176,

  where  = "edge",
  seed_w = 1,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 176,
}


PREFABS.Window_tall_2 =
{
  template = "Window_tall_1",

  map      = "MAP02",

  seed_w   = 2,
}


PREFABS.Window_tall_3 =
{
  template = "Window_tall_1",

  map      = "MAP03",

  seed_w   = 3,
}


----- Fallbacks for height-limited spots -------------------


PREFABS.Window_tallish_1 =
{
  template = "Window_tall_1",

  map      = "MAP11",


  height   = 128,
}

PREFABS.Window_tallish_2 =
{
  template = "Window_tall_1",

  map      = "MAP12",
  seed_w   = 2,


  height   = 128,
}

PREFABS.Window_tallish_3 =
{
  template = "Window_tall_1",

  map      = "MAP13",
  seed_w   = 3,


  height   = 128,
}

