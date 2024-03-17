PREFABS.Wall_mscott_window_1 =
{
  file = "wall/gtd_wall_industrial_mscottpaper_set_EPIC.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_mscottpaper",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = { 87,88 }
}

PREFABS.Wall_mscott_window_2 =
{
  template = "Wall_mscott_window_1",
  map = "MAP02",

  prob = 10
}

PREFABS.Wall_mscott_window_3 =
{
  template = "Wall_mscott_window_1",
  map = "MAP03",

  prob = 10
}

PREFABS.Wall_mscott_shelving_1 =
{
  template = "Wall_mscott_window_1",
  map = "MAP04",

  prob = 10,

  z_fit = "top"
}

PREFABS.Wall_mscott_shelving_2 =
{
  template = "Wall_mscott_window_1",
  map = "MAP05",

  prob = 10,

  z_fit = "top"
}
