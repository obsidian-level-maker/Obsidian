--
-- a simple square shaped window
--

PREFABS.Window_square1 =
{
  file   = "window/square.wad",
  map    = "MAP01",

  group  = "square",

  prob   = 50,

  where  = "edge",
  seed_w = 1,

  deep   = 16,
  over   = 16,
  height = 112,

  bound_z1 = 0,
  bound_z2 = 112,
}


PREFABS.Window_square2 =
{
  template = "Window_square1",

  map      = "MAP02",

  seed_w   = 2,
}


PREFABS.Window_square3 =
{
  template = "Window_square1",

  map      = "MAP03",

  seed_w   = 3,
}

