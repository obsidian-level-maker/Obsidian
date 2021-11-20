--
-- "arrow slit" style windows
--

PREFABS.Window_slits =
{
  file   = "window/slits.wad",
  map    = "MAP01",

  group  = "slits",

  prob   = 50,

  where  = "edge",
  seed_w = 1,

  deep   = 16,
  over   = 16,
  height = 112,

  bound_z1 = 0,
  bound_z2 = 112,
}


PREFABS.Window_slits2 =
{
  template = "Window_slits",

  map      = "MAP02",

  seed_w   = 2,
}


PREFABS.Window_slits3 =
{
  template = "Window_slits",

  map      = "MAP03",

  seed_w   = 3,
}

