--
-- Single lighting niche
--

GROUPS.wall_lite1 =
{
  env = "building"
  theme = "tech"
}


PREFABS.Wall_lite1 =
{
  file   = "wall/lite_1.wad"
  map    = "MAP01"

  where  = "edge"
  height = 128
  deep   = 16

  group  = "lite1"

  x_fit  = "frame"
  z_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128

  -- sometimes use random-off light FX
  sector_1 = { [0]=50, [1]=20 }
}

