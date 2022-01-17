PREFABS.Window_gtd_dem_1 =
{
  file   = "window/gtd_dem_windows.wad",
  map    = "MAP01",

  group  = "gtd_dem_windows",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 16,
  deep   = 16,
  over   = 16,

  z_fit = "top",

  bound_z1 = 0,
  bound_z2 = 96
}

PREFABS.Window_gtd_dem_2 =
{
  template = "Window_gtd_dem_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_gtd_dem_3 =
{
  template = "Window_gtd_dem_1",
  map      = "MAP03",

  seed_w   = 3,
}
