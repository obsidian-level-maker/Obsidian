PREFABS.Wall_tech_oven_1 =
{
  file = "wall/gtd_wall_tech_oven_set_EPIC.wad",
  map = "MAP01",

  prob = 50,

  group = "gtd_wall_tech_oven",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",
}

PREFABS.Wall_tech_oven_2 =
{
  template = "Wall_tech_oven_1",
  map = "MAP02",

  prob = 15
}

PREFABS.Wall_tech_oven_diag =
{
  template = "Wall_tech_oven_1",
  map = "MAP03",

  where = "diagonal"
}
