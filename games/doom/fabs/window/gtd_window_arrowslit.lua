PREFABS.Window_arrowslit_1 =
{
  file   = "window/gtd_window_arrowslit.wad",
  map    = "MAP01",

  group  = "gtd_window_arrowslit",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 64,104 },
}

PREFABS.Window_arrowslit_2 =
{
  template = "Window_arrowslit_1",
  map    = "MAP02",

  group  = "gtd_window_arrowslit",

  seed_w = 2,
}

PREFABS.Window_arrowslit_3 =
{
  template = "Window_arrowslit_1",
  map    = "MAP03",

  passable = true,

  group  = "gtd_window_arrowslit",

  seed_w = 3,
}
