PREFABS.Decor_power_plant_generator =
{
  file = "decor/gtd_decor_industrial_power_plant_set.wad",
  map = "MAP01",

  prob = 7500,
  group = "gtd_power_plant_set",

  where = "point",
  size = 120,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",

  sector_1 =
  {
    [0] = 8,
    [12] = 1,
    [21] = 1
  }
}

PREFABS.Wall_power_plant_generator_thin =
{
  template = "Decor_power_plant_generator",
  map = "MAP02",

  prob = 2000,

  size = 96
}
