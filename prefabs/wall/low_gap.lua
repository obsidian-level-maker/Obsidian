--
-- Wall with gap at bottom
--

GROUPS.wall_low_gap =
{
  env = "building"

  theme = "tech"
}


PREFABS.Wall_lowgap =
{
  file   = "wall/low_gap.wad"
  map    = "MAP01"
  where  = "edge"

  group  = "low_gap"

  long   = 128
  deep   = 16

  height = 64

  bound_z1 = 0
  bound_z2 = 64

  z_fit  = "top"
}


PREFABS.Wall_lowgap_diag =
{
  file   = "wall/low_gap.wad"
  map    = "MAP02"
  where  = "diagonal"

  group  = "low_gap"

  long   = 128
  deep   = 16

  height = 64

  bound_z1 = 0
  bound_z2 = 64

  z_fit  = "top"
}

