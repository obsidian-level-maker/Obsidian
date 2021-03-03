PREFABS.Wall_gtd_drywall_1 =
{
  file   = "wall/gtd_wall_drywall_set.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "gtd_drywall",

  where  = "edge",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 64-4,64+4 },
}

PREFABS.Wall_gtd_drywall_wall_2 =
{
  template = "Wall_gtd_drywall_1",
  map      = "MAP02",

  engine = "zdoom",

  z_fit = { 64-4,64+4 },
}

PREFABS.Wall_gtd_drywall_diag_1 =
{
  file   = "wall/gtd_wall_drywall_set.wad",
  map    = "MAP03",

  prob   = 50,
  group  = "gtd_drywall",

  where  = "diagonal",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 64-4,64+4 },
}

PREFABS.Wall_gtd_drywall_3_bars =
{
  template = "Wall_gtd_drywall_1",
  map = "MAP04",
}

PREFABS.Wall_gtd_drywall_hole_in_wall =
{
  template = "Wall_gtd_drywall_1",
  map = "MAP05",

  prob = 15,

  z_fit = { 94,100 },
}
