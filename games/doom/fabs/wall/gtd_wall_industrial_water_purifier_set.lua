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
