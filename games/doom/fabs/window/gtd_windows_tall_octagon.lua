PREFABS.Window_tall_octagon_1 =
{
  file   = "window/gtd_windows_tall_octagon.wad",
  map    = "MAP01",

  group  = "gtd_window_tall_octagon",
  port = "zdoom",

  prob   = 50,

  passable = true,
  rank = 1,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  z_fit = { 54,90 },

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_tall_octagon_2 =
{
  template = "Window_tall_octagon_1",
  map = "MAP02",

  seed_w = 2,
}

PREFABS.Window_tall_octagon_3 =
{
  template = "Window_tall_octagon_1",
  map = "MAP03",

  seed_w = 3,
}

--

PREFABS.Window_tall_octagon_1_limit =
{
  file   = "window/gtd_windows_tall_octagon.wad",
  map    = "MAP01",

  group  = "gtd_window_tall_octagon",
  port = "!zdoom",

  prob   = 50,

  passable = true,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  z_fit = { 54,90 },

  bound_z1 = 0,
  bound_z2 = 128,

  line_345 = 0
}

PREFABS.Window_tall_octagon_2_limit =
{
  template = "Window_tall_octagon_1_limit",
  map = "MAP02",

  port = "!zdoom",

  seed_w = 2,

  line_345 = 0
}

PREFABS.Window_tall_octagon_3_limit =
{
  template = "Window_tall_octagon_1_limit",
  map = "MAP03",

  port = "!zdoom",

  seed_w = 3,

  line_345 = 0
}
