--
-- Wall with vertical gap
--

UNFINISHED.Wall_vertgap =
{
  file   = "wall/vert_gap.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "vert_gap",

  env    = "outdoor",
  where  = "edge",

  deep   = 16,
--height = 24,

  bound_z1 = 0,
  bound_z2 = 24,

  z_fit  = "top",
}


UNFINISHED.Wall_vertgap_diag =
{
  file   = "wall/vert_gap.wad",
  map    = "MAP02",

  prob   = 50,
  group  = "vert_gap",

  env    = "outdoor",
  where  = "diagonal",

  deep   = 16,
--height = 64,

  bound_z1 = 0,
  bound_z2 = 24,

  z_fit  = "top",
}

