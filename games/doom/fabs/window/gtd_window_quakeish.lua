PREFABS.Window_quakeish_1 =
{
  file   = "window/gtd_window_quakeish.wad",
  map    = "MAP01",

  group  = "gtd_window_quakeish",
  engine = "zdoom",

  rank   = 2,
  prob   = 50,

  passable = true,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_quakeish_2 =
{
  template = "Window_quakeish_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_quakeish_3 =
{
  template = "Window_quakeish_1",
  map      = "MAP03",

  seed_w   = 3,
}

-- fallbacks

PREFABS.Window_not_quakeish =
{
  file   = "window/square.wad",
  map    = "MAP01",

  group  = "gtd_window_quakeish",

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

PREFABS.Window_not_quakeish_2 =
{
  template = "Window_not_quakeish",
  map = "MAP02",

  seed_w = 2,
}

PREFABS.Window_not_quakeish_3 =
{
  template = "Window_not_quakeish",
  map = "MAP03",

  seed_w = 3,
}
