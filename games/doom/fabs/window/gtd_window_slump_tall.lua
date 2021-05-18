PREFABS.Window_slump_tall_1 =
{
  file   = "window/gtd_window_slump_tall.wad",
  map    = "MAP01",

  group  = "gtd_window_slump_tall",

  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 96,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = { 56,72 }
}

PREFABS.Window_slump_tall_2 =
{
  template = "Window_slump_tall_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_slump_tall_3 =
{
  template = "Window_slump_tall_1",
  map      = "MAP03",

  seed_w   = 3,
}

PREFABS.Window_slump_tall_4 =
{
  template = "Window_slump_tall_1",
  map      = "MAP04",

  seed_w   = 4,
}
