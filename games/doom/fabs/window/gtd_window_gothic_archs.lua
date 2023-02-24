PREFABS.Window_gothic_archs_1 =
{
  file = "window/gtd_window_gothic_archs.wad",
  map = "MAP01",

  group = "gtd_window_gothic_archs",
  prob = 50,

  where = "edge",
  seed_w = 1,

  height = 96,
  deep = 16,
  over = 16,

  z_fit = "top",

  bound_z1 = 0,
  bound_z2 = 96,
}

PREFABS.Window_gothic_archs_2 =
{
  template = "Window_gothic_archs_1",
  map = "MAP02",

  seed_w = 2,
}

PREFABS.Window_gothic_archs_3 =
{
  template = "Window_gothic_archs_1",
  map = "MAP03",

  seed_w = 3,
}

--

PREFABS.Window_gothic_archs_2_tall =
{
  template = "Window_gothic_archs_1",
  map = "MAP02",

  seed_w = 2,

  z_fit = { 58,60 , 90,91}
}

PREFABS.Window_gothic_archs_3_tall =
{
  template = "Window_gothic_archs_1",
  map = "MAP03",

  seed_w = 3,

  z_fit = { 58,60 , 90,91}
}
