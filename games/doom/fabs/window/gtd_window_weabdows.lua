PREFABS.Window_weabdows_1 =
{
  file   = "window/gtd_window_weabdows.wad",
  map    = "MAP01",

  group  = "gtd_window_weabdows",
  engine = "zdoom",

  rank   = 2,
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  y_fit = { 40,44 },

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_weabdows_2 =
{
  template = "Window_weabdows_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_weabdows_3 =
{
  template = "Window_weabdows_1",
  map      = "MAP03",

  seed_w   = 3,
}

-- fallbacks

PREFABS.Window_not_weabdows =
{
  file   = "window/square.wad",
  map    = "MAP01",

  group  = "gtd_window_weabdows",

  rank   = 1,
  prob   = 1,

  passable = true,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_not_weabdows_2 =
{
  template = "Window_not_weabdows",
  map = "MAP02",

  seed_w = 2,
}

PREFABS.Window_not_weabdows_3 =
{
  template = "Window_not_weabdows",
  map = "MAP03",

  seed_w = 3,
}
