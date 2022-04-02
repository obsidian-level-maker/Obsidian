PREFABS.Wall_gtd_dem_commercial_1 =
{
  file   = "wall/gtd_dem_wall_commercial_set.wad",
  map    = "MAP01",

  prob   = 50,

  group = "dem_wall_commercial",

  where  = "edge",
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",

  texture_pack = "armaetus"
}

PREFABS.Wall_gtd_dem_commercial_1_diag =
{
  template = "Wall_gtd_dem_commercial_1",
  map = "MAP02",

  where = "diagonal"
}
