PREFABS.Decor_urban_pools_pillar =
{
  file   = "decor/gtd_decor_urban_pools_set.wad",
  map    = "MAP01",

  prob   = 5000,
  group = "gtd_pools",

  where  = "point",
  size   = 64,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Decor_urban_pools_square =
{
  template = "Decor_urban_pools_pillar",
  map = "MAP02",

  size = 96,

  delta = 32
}

PREFABS.Decor_urban_pools_round =
{
  template = "Decor_urban_pools_pillar",
  map = "MAP03",

  size = 96,

  delta = 8
}
