PREFABS.Wall_gtd_met_warning_wall =
{
  file   = "wall/gtd_wall_generic_metal_warning_set.wad",
  map    = "MAP01",

  prob   = 50,

  group = "gtd_wall_metal_warning",

  where  = "edge",
  deep   = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit  = { 40,56 }
}

PREFABS.Wall_gtd_met_warning_diag =
{
  template = "Wall_gtd_met_warning_wall",
  map    = "MAP02",

  where  = "diagonal"
}

--

PREFABS.Wall_gtd_met_warning_bottom_wall =
{
  template = "Wall_gtd_met_warning_wall",
  map = "MAP03",

  group = "gtd_wall_metal_warning_bottom"
}

PREFABS.Wall_gtd_met_warning_bottom_diag =
{
  template = "Wall_gtd_met_warning_wall",
  map = "MAP04",

  where = "diagonal",

  group = "gtd_wall_metal_warning_bottom"
}
