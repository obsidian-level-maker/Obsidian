--
-- Wall with horizontal band
--

GROUPS.wall_mid_band =
{
  env = "indoor"

  theme = "tech"
}


PREFABS.Wall_midband =
{
  file   = "wall/mid_band.wad"
  map    = "MAP01"
  where  = "edge"

  group  = "mid_band"

  long   = 128
  deep   = 16

  height = 64

  bound_z1 = 0
  bound_z2 = 64

  z_fit  = "frame"
}


PREFABS.Wall_midband_diag =
{
  file   = "wall/mid_band.wad"
  map    = "MAP02"
  where  = "diagonal"

  group  = "mid_band"

  long   = 128
  deep   = 16

  height = 64

  bound_z1 = 0
  bound_z2 = 64

  z_fit  = "frame"
}

