PREFABS.Wall_generic_half_floor =
{
  file   = "wall/gtd_wall_generic_half_floor.wad",
  map    = "MAP01",

  prob   = 50,

  group = "gtd_generic_half_floor",

  where  = "edge",
  deep   = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",
}

PREFABS.Wall_generic_half_floor_diag =
{
  file   = "wall/gtd_wall_generic_half_floor.wad",
  map    = "MAP02",

  prob   = 50,

  group = "gtd_generic_half_floor",

  where  = "diagonal",

  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",
}

--

PREFABS.Wall_generic_half_floor_no_trim =
{
  template = "Wall_generic_half_floor",
  map = "MAP03",

  group = "gtd_generic_half_floor_no_trim",
}

PREFABS.Wall_generic_half_floor_no_trim_diag =
{
  template = "Wall_generic_half_floor_diag",
  map = "MAP04",

  group = "gtd_generic_half_floor_no_trim",
}

--

PREFABS.Wall_generic_half_floor_inverted_braced =
{
  template = "Wall_generic_half_floor",
  map = "MAP05",

  group = "gtd_generic_half_floor_inverted_braced",
}

PREFABS.Wall_generic_half_floor_inverted_braced_diag =
{
  template = "Wall_generic_half_floor_diag",
  map = "MAP06",

  group = "gtd_generic_half_floor_inverted_braced",
}
