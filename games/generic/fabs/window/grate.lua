--
-- this window is just grate!
--

PREFABS.Window_low_grate =
{
  file   = "window/grate.wad",
  map    = "MAP01",
  group  = "grate",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,
  z_fit = "top"
}

PREFABS.Window_low_grate_2 =
{
  template = "Window_low_grate",
  map      = "MAP02",
  seed_w   = 2,
}

PREFABS.Window_low_grate_3 =
{
  template = "Window_low_grate",
  map      = "MAP03",
  seed_w   = 3,
}