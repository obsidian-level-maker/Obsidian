PREFABS.Decor_crap_house_1 =
{
  file   = "decor/gtd_decor_urban_crap_housing.wad",
  map    = "MAP01",

  prob   = 10000,

  where  = "point",
  theme  = "urban",

  engine = "zdoom",

  env    = "outdoor",
  size   = 144,
  height = 120,

  bound_z1 = 0,
  bound_z2 = 120,

  flat_FLAT14 =
  {
    FLAT14 = 5,
    FLOOR1_6 = 5,
    FLAT4 = 2,
    FLAT1 = 2
  },
}

PREFABS.Decor_crap_house_2 =
{
  template = "Decor_crap_house_1",
  map = "MAP02",

  height = 192,

  bound_z2 = 192
}

PREFABS.Decor_crap_house_3 =
{
  template = "Decor_crap_house_1",
  map = "MAP03"
}

PREFABS.Decor_crap_house_4 =
{
  template = "Decor_crap_house_1",
  map = "MAP04"
}

PREFABS.Decor_crap_house_5 =
{
  template = "Decor_crap_house_1",
  map = "MAP05",

  size = 128,

  height = 200,

  bound_z = 200
}
