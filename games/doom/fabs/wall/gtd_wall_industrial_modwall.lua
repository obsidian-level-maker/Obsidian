PREFABS.Wall_industrial_modwall_1 =
{
  file = "wall/gtd_wall_industrial_modwall.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_ind_modwall_1",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_industrial_modwall_1a =
{
  template = "Wall_mining_dirt_fenced",
  map = "MAP02",

  prob = 120
}

PREFABS.Wall_industrial_modwall_1b =
{
  template = "Wall_mining_dirt_fenced",
  map = "MAP03",

  where = "diagonal"
}

PREFABS.Wall_industrial_modwall_2 =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP06",

  group = "gtd_ind_modwall_2"
}

PREFABS.Wall_industrial_modwall_2a =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP07",

  group = "gtd_ind_modwall_2"
}
