--
-- Wall with satanic runes
--

GROUPS.wall_runes1 =
{
  env = "building"

  theme = "hell"
}


PREFABS.Wall_runes1_A =
{
  file   = "wall/runes.wad"
  map    = "MAP01"

  where  = "edge"
  deep   = 16

  height = 128

  group  = "runes1"

  x_fit  = "frame"
  z_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128
}


PREFABS.Wall_runes1_B =
{
  template = "Wall_runes1_A"
  map      = "MAP02"
}


PREFABS.Wall_runes1_C =
{
  template = "Wall_runes1_A"
  map      = "MAP03"
}


PREFABS.Wall_runes1_D =
{
  template = "Wall_runes1_A"
  map      = "MAP04"
}


PREFABS.Wall_runes1_E =
{
  template = "Wall_runes1_A"
  map      = "MAP05"
}


PREFABS.Wall_runes1_F =
{
  template = "Wall_runes1_A"
  map      = "MAP06"
}

