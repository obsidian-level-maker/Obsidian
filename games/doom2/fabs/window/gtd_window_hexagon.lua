PREFABS.Window_gtd_window_hexagon_1 =
{
  file   = "window/gtd_window_hexagon.wad",
  map    = "MAP01",

  group  = "gtd_window_hexagon",
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

PREFABS.Window_gtd_window_hexagon_2 =
{
  template = "Window_gtd_window_hexagon_1",
  map = "MAP02",

  seed_w = 2,
}

PREFABS.Window_gtd_window_hexagon_3 =
{
  template = "Window_gtd_window_hexagon_1",
  map = "MAP03",

  seed_w = 3,
}
