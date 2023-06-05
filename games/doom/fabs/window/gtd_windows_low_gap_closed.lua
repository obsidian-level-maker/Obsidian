PREFABS.Window_low_gap_closed_1 =
{
  file   = "window/gtd_windows_low_gap_closed.wad",
  map    = "MAP01",

  group  = "gtd_window_low_gap_closed",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  deep   = 16,
  over   = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  x_fit = "frame"
}

PREFABS.Window_low_gap_closed_2 =
{
  template = "Window_low_gap_closed_1",
  map      = "MAP02",

  seed_w   = 2
}

PREFABS.Window_low_gap_closed_3 =
{
  template = "Window_low_gap_closed_1",

  map      = "MAP03",
  seed_w   = 3
}

PREFABS.Window_low_gap_closed_4 =
{
  template = "Window_low_gap_closed_1",

  map      = "MAP04",
  seed_w   = 4
}
