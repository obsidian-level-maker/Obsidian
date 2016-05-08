--
-- Double lighting niche
--

GROUPS.wall_lite2 =
{
  env = "building"

  theme = "tech"
}


PREFABS.Wall_lite2_blue =
{
  file   = "wall/lite_2.wad"
  map    = "MAP01"

  where  = "edge"
  height = 128
  deep   = 16

  group  = "lite2"

  x_fit  = "frame"
  z_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128
}


------------------------------------------------------------

-- TODO : color variations

UNFINISHED.Pic_lite2_white =
{
  template = "Wall_lite2_blue"

  tex_LITEBLU4 = "LITE5"
}


UNFINISHED.Pic_lite2_red =
{
  template = "Wall_lite2_blue"

  tex_LITEBLU4 = "REDWALL"
}

