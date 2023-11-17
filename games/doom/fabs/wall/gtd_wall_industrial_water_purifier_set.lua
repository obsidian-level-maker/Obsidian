PREFABS.Wall_gtd_water_purifier_water_wall =
{
  file = "wall/gtd_wall_industrial_water_purifier_set.wad",
  map = "MAP01",

  port = "zdoom",
  prob = 50,

  group = "gtd_water_purifier",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = { 82,85 , 87,90 }
}

PREFABS.Wall_gtd_water_purifier_water_comp_wall =
{
  template = "Wall_gtd_water_purifier_water_wall",
  map = "MAP02",

  prob = 10,

  tex_COMPSTA1 = 
  {
    COMPSTA1 = 1,
    COMPSTA2 = 1
  }
}

PREFABS.Wall_gtd_water_purifier_water_wall_diag =
{
  template = "Wall_gtd_water_purifier_water_wall",
  map = "MAP03",

  where = "diagonal",
}

--

PREFABS.Wall_gtd_water_purifier_water_wall_limit =
{
  template = "Wall_gtd_water_purifier_water_wall",
  map = "MAP01",

  port = "!zdoom",

  prob = 10,

  line_300 = 0,

  tex_XFWATER = "FWATER1",
  tex_XNUKAGE = "SFALL1"
}

PREFABS.Wall_gtd_water_purifier_water_comp_wall_limit =
{
  template = "Wall_gtd_water_purifier_water_wall",
  map = "MAP02",

  port = "!zdoom",

  line_300 = 0,

  tex_COMPSTA1 = 
  {
    COMPSTA1 = 1,
    COMPSTA2 = 1
  },

  tex_XFWATER = "FWATER1",
  tex_XNUKAGE = "SFALL1"
}

PREFABS.Wall_gtd_water_purifier_water_wall_diag_limit =
{
  template = "Wall_gtd_water_purifier_water_wall",
  map = "MAP03",

  port = "!zdoom",

  line_300 = 0,

  tex_XFWATER = "FWATER1",
  tex_XNUKAGE = "SFALL1"
}

--

PREFABS.Wall_gtd_nukage_aquarium_1 =
{
  file = "wall/gtd_wall_industrial_water_purifier_set.wad",
  map = "MAP11",

  rank = 2,
  port = "zdoom",
  prob = 10,

  group = "gtd_nukage_aquarium",
  texture_pack = "armaetus",

  where = "edge",
  deep = 16,
  height = 80,

  bound_z1 = 0,
  bound_z2 = 80,

  z_fit = "top"
}

PREFABS.Wall_gtd_nukage_aquarium_2 =
{
  template = "Wall_gtd_nukage_aquarium_1",
  map = "MAP12",

  prob = 50
}

PREFABS.Wall_gtd_nukage_aquarium_3 =
{
  template = "Wall_gtd_nukage_aquarium_1",
  map = "MAP13",

  prob = 10
}

PREFABS.Wall_gtd_nukage_aquarium_1_compat =
{
  file = "wall/gtd_wall_industrial_water_purifier_set.wad",
  map = "MAP11",

  rank = 1,
  port = "any",
  prob = 10,

  group = "gtd_nukage_aquarium",

  where = "edge",
  deep = 16,
  height = 80,

  bound_z1 = 0,
  bound_z2 = 80,

  tex_XNUKAGE = "SFALL1"
}

PREFABS.Wall_gtd_nukage_aquarium_2_compat =
{
  template = "Wall_gtd_nukage_aquarium_1_compat",
  map = "MAP12",

  prob = 50,

  tex_XNUKAGE = "SFALL1"
}

PREFABS.Wall_gtd_nukage_aquarium_3_compat =
{
  template = "Wall_gtd_nukage_aquarium_1_compat",
  map = "MAP13",

  prob = 10,

  tex_XNUKAGE = "SFALL1"
}

--

PREFABS.Wall_gtd_bathwater_1 =
{
  file = "wall/gtd_wall_industrial_water_purifier_set.wad",
  map = "MAP21",

  port = "any",
  prob = 50,
  texture_pack = "armaetus",

  group = "gtd_bathwater",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_gtd_bathwater_2 =
{
  template = "Wall_gtd_bathwater_1",
  map = "MAP22",
  prob = 8
}
