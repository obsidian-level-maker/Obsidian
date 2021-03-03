PREFABS.Window_open_1 =
{
  file   = "window/gtd_window_full_open.wad",
  map    = "MAP01",

  group  = "gtd_window_full_open",
  prob   = 50,

  passable = true,

  where  = "edge",
  seed_w = 1,

  height = 24,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_open_2 =
{
  template = "Window_open_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_open_3 =
{
  template = "Window_open_1",
  map      = "MAP03",

  seed_w   = 3,
}

PREFABS.Window_open_4 =
{
  template = "Window_open_1",
  map      = "MAP04",

  seed_w   = 4,
}

PREFABS.Window_open_1_tall =
{
  template = "Window_open_1",
  map = "MAP01",

  group = "gtd_window_full_open_tall",

  z_fit = { 26,32 },
}

PREFABS.Window_open_2_tall =
{
  template = "Window_open_1",
  map = "MAP02",

  seed_w = 2,

  group = "gtd_window_full_open_tall",

  z_fit = { 26,32 },
}

PREFABS.Window_open_3_tall =
{
  template = "Window_open_1",
  map = "MAP03",

  seed_w = 3,

  group = "gtd_window_full_open_tall",

  z_fit = { 26,32 },
}

PREFABS.Window_open_4_tall =
{
  template = "Window_open_1",
  map = "MAP04",

  seed_w = 4,

  group = "gtd_window_full_open_tall",

  z_fit = { 26,32 },
}
