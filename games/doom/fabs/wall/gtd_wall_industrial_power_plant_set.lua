PREFABS.Wall_power_plant_1 =
{
  file = "wall/gtd_wall_industrial_power_plant_set.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_power_plant_set",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",
}

PREFABS.Wall_power_plant_2 =
{
  template = "Wall_power_plant_1",
  map = "MAP02",

  prob = 15,

  sector_1 =
  {
    [0] = 8,
    [12] = 1,
    [21] = 1
  }
}

PREFABS.Wall_power_plant_diag =
{
  template = "Wall_power_plant_1",
  map = "MAP03",

  where = "diagonal"
}
