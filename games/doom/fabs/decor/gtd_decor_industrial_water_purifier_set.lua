PREFABS.Decor_gtd_water_purifier =
{
  file = "decor/gtd_decor_industrial_water_purifier_set.wad",
  map = "MAP01",

  prob = 5000,
  group = "gtd_water_purifier",
  port = "zdoom",

  where = "point",
  size = 80,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = { 71,72 , 88,92 }
}

PREFABS.Decor_gtd_water_purifier_limit =
{
  template = "Decor_gtd_water_purifier",

  port = "!zdoom",

  line_424 = 0,
  line_426 = 0,
  line_428 = 0,

  tex_XFWATER = "FWATER1",
  tex_XNUKAGE = "SFALL1"
}

--

PREFABS.Decor_gtd_water_purifier_tank =
{
  template = "Decor_gtd_water_purifier",
  map = "MAP02",

  size = 36,

  z_fit = "top"
}

PREFABS.Decor_gtd_water_purifier_tank_limit =
{
  template = "Decor_gtd_water_purifier",
  map = "MAP02",

  port = "!zdoom",
  size = 36,

  z_fit = "top",

  tex_XFWATER = "FWATER1",
  tex_XNUKAGE = "SFALL1"
}
