PREFABS.Wall_urban_pools_1 =
{
  file = "wall/gtd_wall_urban_pools_set.wad",
  map = "MAP01",

  prob = 50,

  where = "edge",
  height = 96,

  group = "gtd_pools",

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  x_fit = "frame",
  z_fit = "top"
}

PREFABS.Wall_urban_pools_2 =
{
  template = "Wall_urban_pools_1",
  map = "MAP02",

  prob = 10
}

PREFABS.Wall_urban_pools_3a =
{
  template = "Wall_urban_pools_1",
  map = "MAP03",

  prob = 5,

  z_fit = "top"
}

PREFABS.Wall_urban_pools_3b =
{
  template = "Wall_urban_pools_1",
  map = "MAP03",

  prob = 5,

  z_fit = "bottom"
}

PREFABS.Wall_urban_pools_3c =
{
  template = "Wall_urban_pools_1",
  map = "MAP03",

  prob = 5,

  z_fit = "frame"
}
