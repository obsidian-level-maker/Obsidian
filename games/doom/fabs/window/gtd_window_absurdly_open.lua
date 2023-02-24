PREFABS.Window_absurdly_open_1 =
{
  file   = "window/gtd_window_absurdly_open.wad",
  map    = "MAP01",

  group  = "gtd_window_absurdly_open",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 16,
  deep   = 16,
  over   = 16,

  z_fit = { 16,24 },

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_absurdly_open_2 =
{
  template = "Window_absurdly_open_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_absurdly_open_3 =
{
  template = "Window_absurdly_open_1",
  map      = "MAP03",

  seed_w   = 3,
}
