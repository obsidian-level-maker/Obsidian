PREFABS.Window_pencil_hole_1 =
{
  file   = "window/gtd_window_pencil_hole.wad",
  map    = "MAP01",

  group  = "gtd_window_pencil_holes",
  prob   = 50,

  passable = true,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = {28,48},
}

PREFABS.Window_pencil_hole_2 =
{
  template = "Window_pencil_hole_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_pencil_hole_3 =
{
  template = "Window_pencil_hole_1",
  map      = "MAP03",

  seed_w   = 3,
}
