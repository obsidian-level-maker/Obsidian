PREFABS.Wall_gtd_greywall_1 =
{
  file = "wall/gtd_wall_industrial_greytalls.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_greywall_1",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_gtd_greywall_1_diag =
{
  template = "Wall_gtd_greywall_1",
  map = "MAP02",

  where = "diagonal"
}

--

PREFABS.Wall_gtd_greytall_trim =
{
  template = "Wall_gtd_greywall_1",
  map = "MAP06",

  group = "gtd_greytall_trim"
}

PREFABS.Wall_gtd_greytall_trim_diag =
{
  template = "Wall_gtd_greywall_1",
  map = "MAP07",

  where = "diagonal",

  group = "gtd_greytall_trim"
}
