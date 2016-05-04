--
-- Double lighting niche
--

GROUPS.wall_lite2 =
{
  env = "indoor"

  theme = "tech"
}


UNFINISHED.Wall_lite2_blue =
{
  file   = "wall/lite_2.wad"
  where  = "edge"

  deep   = 16

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

