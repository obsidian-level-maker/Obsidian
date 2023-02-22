PREFABS.Window_gtd_dem_1 =
{
  file = "window/gtd_window_dem.wad",
  map = "MAP01",

  group = "gtd_window_dem",
  prob = 50,
  theme = "urban",

  where = "edge",
  seed_w = 1,

  height = 16,
  deep   = 16,
  over   = 16,

  z_fit = "top",

  bound_z1 = 0,
  bound_z2 = 112,

  passable =  true
}

PREFABS.Window_gtd_dem_2 =
{
  template = "Window_gtd_dem_1",
  map = "MAP02",

  seed_w = 2,
}

PREFABS.Window_gtd_dem_3 =
{
  template = "Window_gtd_dem_1",
  map = "MAP03",

  seed_w = 3,
}

--

PREFABS.Window_gtd_dem_1_tech =
{
  template = "Window_gtd_dem_1",
  map = "MAP04",

  theme = "tech"
}

PREFABS.Window_gtd_dem_2_tech =
{
  template = "Window_gtd_dem_1",
  map = "MAP05",

  theme = "tech",

  seed_w = 2
}

PREFABS.Window_gtd_dem_3_tech =
{
  template = "Window_gtd_dem_1",
  map = "MAP06",

  theme = "tech",

  seed_w = 3
}

--

PREFABS.Window_gtd_dem_1_hell =
{
  template = "Window_gtd_dem_1",
  map = "MAP07",

  theme = "hell"
}

PREFABS.Window_gtd_dem_2_hell =
{
  template = "Window_gtd_dem_1",
  map = "MAP08",

  theme = "hell",

  seed_w = 2
}

PREFABS.Window_gtd_dem_3_hell =
{
  template = "Window_gtd_dem_1",
  map = "MAP09",

  theme = "hell",

  seed_w = 3
}
