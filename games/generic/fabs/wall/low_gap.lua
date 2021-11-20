--
-- Wall with gap at bottom
--

PREFABS.Wall_lowgap =
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


PREFABS.Wall_lowgap_diag =
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


PREFABS.Wall_lowgap_innerdiag =
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


PREFABS.Wall_lowgap2 =
{
  template = "Wall_lowgap",

  group = "low_gap2",
}

PREFABS.Wall_lowgap2_diag =
{
  template = "Wall_lowgap_diag",
  map = "MAP03",

  group = "low_gap2",
}