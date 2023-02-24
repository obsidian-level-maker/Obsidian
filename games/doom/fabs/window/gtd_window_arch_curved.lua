PREFABS.Window_arched_1 =
{
  file   = "window/gtd_window_arch_curved.wad",
  map    = "MAP01",

  group  = "gtd_window_arched",
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

PREFABS.Window_arched_2 =
{
  template = "Window_arched_1",
  map    = "MAP02",

  group  = "gtd_window_arched",

  seed_w = 2,
}

PREFABS.Window_arched_3 =
{
  template = "Window_arched_1",
  map    = "MAP03",

  group  = "gtd_window_arched",

  seed_w = 3,
}

PREFABS.Window_arched_1_tall =
{
  template = "Window_arched_1",
  map = "MAP01",

  group = "gtd_window_arched_tall",

  z_fit = { 26,30 },
}

PREFABS.Window_arched_2_tall =
{
  template = "Window_arched_1",
  map = "MAP02",

  group = "gtd_window_arched_tall",

  seed_w = 2,

  z_fit = { 26,30 },
}

PREFABS.Window_arched_3_tall =
{
  template = "Window_arched_1",
  map = "MAP03",

  group = "gtd_window_arched_tall",

  seed_w = 3,

  z_fit = { 26,30 },
}
