--
-- a simple square shaped window
--

PREFABS.Window_square1 =
{
  file   = "window/square.wad",
  map    = "MAP01",
  theme  = "!tech",

  group  = "square",

  passable = true,

  prob   = 50,

  where  = "edge",
  seed_w = 1,

  deep   = 16,
  over   = 16,
  height = 112,

  bound_z1 = 0,
  bound_z2 = 112,
}

PREFABS.Window_square1_tech =
{
  template = "Window_square1",
  theme    = "tech",
  map      = "MAP01",

  flat_FLAT1 = "FLAT20",

}


PREFABS.Window_square2 =
{
  template = "Window_square1",
  theme  = "!tech",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_square2_tech =
{
  template = "Window_square1",
  theme    = "tech",
  map      = "MAP02",

  flat_FLAT1 = "FLAT20",
  seed_w = 2,

}


PREFABS.Window_square3 =
{
  template = "Window_square1",
  theme  = "!tech",
  map      = "MAP03",

  seed_w   = 3,
}


PREFABS.Window_square3_tech =
{
  template = "Window_square1",
  theme    = "tech",
  map      = "MAP03",

  flat_FLAT1 = "FLAT20",
  seed_w = 3,
}
