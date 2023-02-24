PREFABS.Decor_hydroponics_tank_1 =
{
  file   = "decor/gtd_decor_tech_hydroponics_EPIC.wad",
  map    = "MAP01",

  where  = "point",

  group = "gtd_wall_hydroponics",

  prob   = 5000,
  env    = "building",

  size   = 96,
  height = 112,

  face_open = true,

  bound_z1 = 0,
  bound_z2 = 112,

  z_fit = "top",
}

PREFABS.Decor_hydroponics_tank_2 =
{
  template = "Decor_hydroponics_tank_1",
  map = "MAP02",
}

PREFABS.Decor_hydroponics_tank_3 =
{
  template = "Decor_hydroponics_tank_1",
  map = "MAP03",

  prob = 3500,

  size = 68,
}
