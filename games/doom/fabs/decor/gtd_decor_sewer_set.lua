PREFABS.Decor_open_pipe_sewer_group =
{
  file   = "decor/gtd_decor_tech.wad",
  map    = "MAP07",

  prob   = 5000,
  theme  = "!hell",
  env    = "building",

  group = "gtd_wall_sewer",

  where  = "point",
  size   = 64,
  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  tex__LIQUID = "SFALL1",
  flat__LIQUID = "NUKAGE1",

  z_fit  = "top",
  sound = "Water_Tank",
}

--

PREFABS.Decor_bunchy_pipe =
{
  file = "decor/gtd_decor_sewer_set.wad",
  map = "MAP01",

  prob = 5000,
  env = "building",

  group = "gtd_wall_sewer",

  where = "point",
  size = 80,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 96,108 }
}

PREFABS.Decor_pool_thing_whatever_man_nobody_cares =
{
  template = "Decor_bunchy_pipe",
  map = "MAP02",

  z_fit = "top",
}

PREFABS.Decor_treatment_pool =
{
  template = "Decor_bunchy_pipe",
  map = "MAP03",

  prob = 10000,

  size = 96,

  z_fit = "top",
}
