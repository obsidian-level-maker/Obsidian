PREFABS.Wall_gtd_sewer_set_3 =
{
  file   = "wall/gtd_wall_industrial_sewer_3_set.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "gtd_sewer_set_3",

  where  = "edge",

  deep   = 16,

  height = 120,

  bound_z1 = 0,
  bound_z2 = 120,

  z_fit = "top",

  tex_STARTAN3 = 
  {
    STARTAN3 = 4,
    SLIME01 = 1,
  }
}

PREFABS.Wall_gtd_sewer_set_3_alt =
{
  template = "Wall_gtd_sewer_set_3",
  map = "MAP02",

  prob = 4,
  height = 96,

  bound_z2 = 96,

  z_fit = { 68,70 }
}

PREFABS.Wall_gtd_sewer_set_3_alt_slimefalls =
{
  template = "Wall_gtd_sewer_set_3",
  map = "MAP02",

  prob = 4,
  height = 96,

  bound_z2 = 96,

  tex_PIPES = "SLIME01",
  flat_FLOOR3_3 = "SLIME01",

  z_fit = { 68,70 }
}

PREFABS.Wall_gtd_sewer_set_3_diag =
{
  template = "Wall_gtd_sewer_set_3",
  map = "MAP03",

  where = "diagonal",
}
