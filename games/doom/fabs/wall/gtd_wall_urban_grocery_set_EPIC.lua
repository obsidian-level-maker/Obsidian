PREFABS.Wall_urban_grocery_1 =
{
  file = "wall/gtd_wall_urban_grocery_set_EPIC.wad",
  map = "MAP01",

  prob = 50,

  where = "edge",
  height = 128,

  group = "gtd_grocery",

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_DNSTOR01 =
  {
    DNSTOR01 = 5,
    DNSTOR02 = 5,
    DNSTOR03 = 5,
    DNSTOR04 = 5,
    DNSTOR05 = 5,
    DNSTOR06 = 12
  }
}

PREFABS.Wall_urban_grocery_2 =
{
  template = "Wall_urban_grocery_1",
  map = "MAP02",

  height = 129,

  group = "gtd_grocery_2",

  bound_z2 = 129,

  tex_DNSTOR07 =
  {
    DNSTOR07 = 5,
    DNSTOR08 = 5,
    DNSTOR09 = 5,
    DNSTOR20 = 5,
    DNSTOR12 = 20
  }
}

PREFABS.Wall_urban_grocery_anti_group =
{
  template = "Wall_urban_grocery_1",

  stop_group = "yes",

  prob = 12
}

PREFABS.Wall_urban_grocery_anti_group_2 =
{
  template = "Wall_urban_grocery_1",

  group = "gtd_grocery_2",

  stop_group = "yes",

  prob = 12
}
