--
-- Wall with vertical gap
--

GROUPS.wall_vert_gap =
{
  env = "indoor"

  theme = "tech"
}


PREFABS.Wall_vertgap =
{
  file   = "wall/vert_gap.wad"
  map    = "MAP01"
  where  = "edge"

  group  = "vert_gap"

  deep   = 16
--height = 24

  bound_z1 = 0
  bound_z2 = 24

  z_fit  = "top"

  prob = 0
  rank = 4
}


PREFABS.Wall_vertgap_diag =
{
  file   = "wall/vert_gap.wad"
  map    = "MAP02"
  where  = "diagonal"

  group  = "vert_gap"

  deep   = 16
--height = 64

  bound_z1 = 0
  bound_z2 = 24

  z_fit  = "top"

  prob = 0
  rank = 4
}

