PREFABS.Decor_outdoor_freestanding_tower =
{
  file = "decor/gtd_decor_tech_tower.wad",
  map = "MAP01",

  prob = 5000,
  theme = "!hell",
  env = "outdoor",

  where = "point",
  size = 112,
  height = 256,

  bound_z1 = 0,
  bound_z2 = 256,

  z_fit  = { 96-16,96-8 }
}

PREFABS.Decor_outdoor_freestanding_tower_2 =
{
  template = "Decor_outdoor_freestanding_tower",
  map = "MAP02",

  size = 108,

  z_fit = { 90,92 }
}
