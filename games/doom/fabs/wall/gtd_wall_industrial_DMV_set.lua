PREFABS.Wall_gtd_DMV =
{
  file = "wall/gtd_wall_industrial_DMV_set.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_DMV_set",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_gtd_DMV_pillared =
{
  template = "Wall_gtd_DMV",
  map = "MAP02",

  prob = 10
}

PREFABS.Wall_gtd_DMV_door =
{
  template = "Wall_gtd_DMV",
  map = "MAP03",

  prob = 8
}

PREFABS.Wall_gtd_DMV_diag =
{
  template = "Wall_gtd_DMV",
  map = "MAP04",

  where = "diagonal"
}
