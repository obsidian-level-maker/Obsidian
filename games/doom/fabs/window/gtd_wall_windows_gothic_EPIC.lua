PREFABS.Window_gothic_epic_1 =
{
  file   = "window/gtd_wall_windows_gothic_EPIC.wad",
  map    = "MAP01",

  group  = "gtd_window_gothic_epic",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  deep   = 16,
  over   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
}

PREFABS.Window_gothic_epic_2 =
{
  template = "Window_gothic_epic_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_gothic_epic_3 =
{
  template = "Window_gothic_epic_1",

  map      = "MAP03",
  seed_w   = 3,
}
