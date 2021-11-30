--
-- Wall with gap at bottom
--

PREFABS.Wall_low_gap =
{
  file   = "wall/low_gap.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "low_gap",

  where  = "edge",
  deep   = 16,
  height = 64,

  bound_z1 = 0,
  bound_z2 = 64,

  z_fit  = "top",
}


PREFABS.Wall_low_gap_diag =
{
  file   = "wall/low_gap.wad",
  map    = "MAP02",

  prob   = 50,
  group  = "low_gap",

  where  = "diagonal",
  height = 64,

  bound_z1 = 0,
  bound_z2 = 64,

  z_fit  = "top",
}


PREFABS.Wall_low_gap_innerdiag =
{
  file = "wall/low_gap.wad",
  map = "MAP04",

  prob = 50,
  group = "low_gap",

  where = "inner_diagonal",
  height = 64,

  bound_z1 = 0,
  bound_z2 = 64,

  z_fit = "top",
}


PREFABS.Wall_low_gap2 =
{
  template = "Wall_low_gap",

  group = "low_gap2",
}

PREFABS.Wall_low_gap2_diag =
{
  template = "Wall_low_gap_diag",
  map = "MAP03",

  group = "low_gap2",
}