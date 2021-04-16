PREFABS.Wall_gtd_g99_1 =
{
  file   = "wall/gtd_wall_hell_g99_set.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "gtd_g99",

  where  = "edge",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 56,72 }
}

PREFABS.Wall_gtd_g99_diag_1 =
{
  template = "Wall_gtd_g99_1",
  map    = "MAP02",

  where  = "diagonal"
}
