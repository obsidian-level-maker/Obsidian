PREFABS.Wall_bank_small_safes =
{
  file = "wall/gtd_wall_industrial_cranbank_set.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_craneo_bank_set",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_bank_large_safes =
{
  template = "Wall_bank_small_safes",
  map = "MAP02",

  prob = 20
}
