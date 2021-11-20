PREFABS.Wall_generic_half_floor =
{
  file   = "wall/half_floor.wad",
  map    = "MAP01",

  prob   = 50,

  group = "half_floor",

  where  = "edge",
  deep   = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",
}

PREFABS.Wall_generic_half_floor_diag =
{
  file   = "wall/half_floor.wad",
  map    = "MAP02",

  prob   = 50,

  group = "half_floor",

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

  group = "half_floor_no_trim",
}

PREFABS.Wall_generic_half_floor_no_trim_diag =
{
  template = "Wall_generic_half_floor_diag",
  map = "MAP04",

  group = "half_floor_no_trim",
}

--

PREFABS.Wall_generic_half_floor_inverted_braced =
{
  template = "Wall_generic_half_floor",
  map = "MAP05",

  group = "half_floor_inverted_braced",
}

PREFABS.Wall_generic_half_floor_inverted_braced_diag =
{
  template = "Wall_generic_half_floor_diag",
  map = "MAP06",

  group = "half_floor_inverted_braced",
}
