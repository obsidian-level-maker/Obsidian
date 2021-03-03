PREFABS.Wall_gtd_writhing_mass_wall_1 =
{
  file   = "wall/gtd_wall_writhing_mass_set.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "gtd_writhing_mass",

  where  = "edge",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",
}

PREFABS.Wall_gtd_writhing_mass_wall_2 =
{
  template = "Wall_gtd_writhing_mass_wall_1",
  map      = "MAP02",
}

PREFABS.Wall_gtd_writhing_mass_diag_1 =
{
  file   = "wall/gtd_wall_writhing_mass_set.wad",
  map    = "MAP03",

  prob   = 50,
  group  = "gtd_writhing_mass",

  where  = "diagonal",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",
}
