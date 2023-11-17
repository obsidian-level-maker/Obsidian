PREFABS.Pic_gtd_water_purifier =
{
  file = "picture/gtd_pic_industrial_water_purifier_set.wad",
  map = "MAP01",

  prob = 100,
  port = "zdoom",

  group = "gtd_water_purifier",

  where = "seeds",
  height = 96,
  deep = 16,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 96,

  x_fit = { 20,64 , 192,236 },
  y_fit = "top",
  z_fit = { 82,85 , 87,90 }
}

PREFABS.Pic_gtd_water_purifier_limit =
{
  template = "Pic_gtd_water_purifier",

  port = "!zdoom",

  line_300 = 0,

  tex_XFWATER = "FWATER1",
  tex_XNUKAGE = "SFALL1"
}

--

PREFABS.Pic_gtd_bathwater_warehouse =
{
  file = "picture/gtd_pic_industrial_water_purifier_set.wad",
  map = "MAP21",

  prob = 100,
  port = "zdoom",

  texture_pack = "armaetus",

  group = "gtd_bathwater",

  where = "seeds",
  height = 96,
  deep = 16,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 96,

  x_fit = { 68,82 },
  z_fit = { 64,65 },
  y_fit = "top",

  tex_CRATE2 = { BATHWTR1=5, BATHWTR2=4, UACCRT1=1 },
  tex_BATHWTR1 = { BATHWTR1=5, BATHWTR2=4, UACCRT1=1 },
  tex_BATHWTR2 = { BATHWTR1=5, BATHWTR2=4, UACCRT1=1 },
  tex_UACCRT1 = { BATHWTR1=5, BATHWTR2=4, UACCRT1=1 }
}

PREFABS.Pic_gtd_bathwater_warehouse_2 =
{
  template = "Pic_gtd_bathwater_warehouse",

  x_fit = { 184,188 }
}

PREFABS.Pic_gtd_bathwater_processing =
{
  template = "Pic_gtd_bathwater_warehouse",
  map = "MAP22",

  tex_BATHWTR2 = "BATHWTR2",

  z_fit = { 123,126 },
  x_fit = "frame"
}
