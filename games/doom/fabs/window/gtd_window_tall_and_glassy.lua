PREFABS.Window_tall_and_glassy_1 =
{
  file   = "window/gtd_window_tall_and_glassy.wad",
  map    = "MAP01",

  group  = "gtd_window_tall_and_glassy",
  engine = "zdoom",

  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 96,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = {28,72},
}

PREFABS.Window_tall_and_glassy_2 =
{
  template = "Window_tall_and_glassy_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_tall_and_glassy_3 =
{
  template = "Window_tall_and_glassy_1",
  map      = "MAP03",

  seed_w   = 3,
}
