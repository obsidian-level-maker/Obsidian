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

--

PREFABS.Decor_gtd_bathwater_crate_1 =
{
  file = "decor/gtd_decor_industrial_water_purifier_set.wad",
  map = "MAP11",

  prob = 5000,
  group = "gtd_bathwater",

  where = "point",
  size = 72,
  height = 65,

  bound_z1 = 0,
  bound_z2 = 64
}

PREFABS.Decor_gtd_bathwater_crate_2 =
{
  template = "Decor_gtd_bathwater_crate_1",
  map = "MAP12",

  size = 104
}

PREFABS.Decor_gtd_bathwater_crate_3 =
{
  template = "Decor_gtd_bathwater_crate_1",
  map = "MAP13",

  height = 129,
  size = 96,

  bound_z2 = 128,

  tex_BATHWTR1 = { BATHWTR1=2, BATHWTR2=1, UACCRT1=2 },
  tex_UACCRT1 = { BATHWTR1=2, BATHWTR2=1, UACCRT1=2 }
}

PREFABS.Decor_gtd_bathwater_crate_4 =
{
  template = "Decor_gtd_bathwater_crate_1",
  map = "MAP14",

  height = 129,
  size = 112,

  bound_z2 = 128,

  tex_BATHWTR1 = { BATHWTR1=2, BATHWTR2=1, UACCRT1=2 },
  tex_UACCRT1 = { BATHWTR1=2, BATHWTR2=1, UACCRT1=2 }
}
