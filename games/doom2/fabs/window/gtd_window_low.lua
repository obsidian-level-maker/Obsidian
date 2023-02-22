PREFABS.Window_low_1 =
{
  file   = "window/gtd_window_low.wad",
  map    = "MAP01",

  group  = "gtd_window_low",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 32,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 32,
}

PREFABS.Window_low_2 =
{
  template = "Window_low_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_low_3 =
{
  template = "Window_low_1",
  map      = "MAP03",

  seed_w   = 3,
}

PREFABS.Window_low_2_with_opening =
{
  template = "Window_low_1",
  map = "MAP04",

  prob = 15,

  seed_w = 2,

  height = 112,
  bound_z2 = 112,
}
