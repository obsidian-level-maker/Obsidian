PREFABS.Decor_money_pile_small_EPIC =
{
  file = "decor/gtd_decor_industrial_cranbank_set.wad",
  map = "MAP01",

  prob = 5000,
  group = "gtd_craneo_bank_set",

  texture_pack = "armaetus",

  where = "point",
  size = 64,
  height = 68,

  bound_z1 = 0,
}

PREFABS.Decor_money_pile_medium_EPIC =
{
  template = "Decor_money_pile_small_EPIC",
  map = "MAP02",

  prob = 7500,

  size = 96
}

PREFABS.Decor_money_pile_large_EPIC =
{
  template = "Decor_money_pile_small_EPIC",
  map = "MAP03",

  prob = 10000
}
