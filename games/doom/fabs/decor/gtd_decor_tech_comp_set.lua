PREFABS.Decor_tech_comp_lite5_1 =
{
  file = "decor/gtd_decor_tech_comp_set.wad",
  map = "MAP01",

  where = "point",

  prob = 5000,
  group = "gtd_computers_lite5",
  
  size = 80,
  height = 88,

  bound_z1 = 0,
  bound_z2 = 88,
}

PREFABS.Decor_tech_comp_lite5_2 =
{
  template = "Decor_tech_comp_lite5_1",
  map = "MAP02",

  height = 96,
  bound_z2 = 96,

  z_fit = { 18,22 }
}

PREFABS.Decor_tech_comp_lite5_big =
{
  template = "Decor_tech_comp_lite5_1",
  map = "MAP03",

  prob = 8000,

  size = 112
}
