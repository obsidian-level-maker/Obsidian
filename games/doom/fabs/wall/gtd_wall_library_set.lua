PREFABS.Wall_gtd_library_1 =
{
  file   = "wall/gtd_wall_library_set.wad",
  map    = "MAP01",

  prob   = 10,
  group  = "gtd_library",

  where  = "edge",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",
}

PREFABS.Wall_gtd_library_wall_2 =
{
  template = "Wall_gtd_library_1",
  map      = "MAP02",

  prob     = 50,
}

PREFABS.Wall_gtd_library_diag_1 =
{
  file   = "wall/gtd_wall_library_set.wad",
  map    = "MAP03",

  prob   = 50,
  group  = "gtd_library",

  where  = "diagonal",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",
}
