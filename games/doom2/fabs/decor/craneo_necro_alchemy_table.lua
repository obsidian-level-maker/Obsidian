PREFABS.Decor_craneo_chemical_experiments_table =
{
  file  = "decor/craneo_necro_alchemy_table.wad",
  map   = "MAP01",

  prob  = (3500 / 3),

  theme = "!tech",
  env   = "building",

  where = "point",
  size  = 96,

  bound_z1 = 0,
}

PREFABS.Decor_craneo_poisoned_dead_guy_in_a_cage =
{
  template = "Decor_craneo_chemical_experiments_table",
  map  = "MAP02",
}

PREFABS.Decor_craneo_grimmoire =
{
  template = "Decor_craneo_chemical_experiments_table",
  map  = "MAP03",

  size = 80,
}
