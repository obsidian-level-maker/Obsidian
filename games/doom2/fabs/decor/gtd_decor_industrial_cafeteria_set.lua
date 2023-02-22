PREFABS.Decor_cafeteria_picnic_table =
{
  file = "decor/gtd_decor_industrial_cafeteria_set.wad",
  map = "MAP01",

  prob = 5000,

  group = "gtd_wall_cafeteria_set",

  where = "point",
  size = 32,
  height = 92,

  bound_z1 = 0,
  bound_z2 = 32,
}

PREFABS.Decor_cafeteria_double_long_seats =
{
  template = "Decor_cafeteria_picnic_table",
  map = "MAP02",

  size = 104,
}

PREFABS.Decor_cafeteria_double_long_seats_divided =
{
  template = "Decor_cafeteria_picnic_table",
  map = "MAP03",

  size = 96,
  height = 72,

  bound_z2 = 72,
}
