--
-- Wall with hellish cross
--

GROUPS.wall_cross1 =
{
  env = "building"

  theme = "hell"
}


PREFABS.Wall_cross1 =
{
  file   = "wall/cross.wad"
  map    = "MAP01"

  where  = "edge"
  deep   = 16

  height = 128

  group  = "cross1"

  x_fit  = "frame"
  z_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128
}


PREFABS.Wall_cross2 =
{
  template = "Wall_cross1"

  group = "cross2"

  tex_REDWALL = "FIREWALL"

  -- disable oscillating light FX
  sector_8 = 0
}

