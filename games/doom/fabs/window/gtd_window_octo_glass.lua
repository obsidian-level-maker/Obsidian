PREFABS.Window_octo_glass_1 =
{
  file   = "window/gtd_window_octo_glass.wad",
  map    = "MAP01",

  group  = "gtd_window_octo_glass",
  prob   = 50,



  port = "zdoom",

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",
}

PREFABS.Window_octo_glass_2 =
{
  template = "Window_octo_glass_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_octo_glass_3 =
{
  template = "Window_octo_glass_1",
  map      = "MAP03",

  seed_w   = 3,
}

--

PREFABS.Window_octo_glass_alt_1 =
{
  template = "Window_gtd_window_hexagon_1",

  port = "!zdoom",
  group = "gtd_window_octo_glass",


}

PREFABS.Window_octo_glass_alt_2 =
{
  template = "Window_gtd_window_hexagon_1",
  map = "MAP02",

  seed_w = 2,

  port = "!zdoom",
  group = "gtd_window_octo_glass",


}

PREFABS.Window_octo_glass_alt_3 =
{
  template = "Window_gtd_window_hexagon_1",
  map = "MAP03",

  seed_w = 3,

  port = "!zdoom",
  group = "gtd_window_octo_glass",


}
