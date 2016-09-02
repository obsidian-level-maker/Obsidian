--
-- Wall with satanic runes
--

GROUPS.wall_runes =
{
  env = "building"

  theme = "hell"
}


PREFABS.Wall_runes1 =
{
  file   = "wall/runes.wad"
  map    = "MAP01"

  where  = "edge"
  deep   = 16

  height = 128

  group  = "runes"

  x_fit  = "frame"
  z_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128
}


PREFABS.Wall_runes2 =
{
  template = "Wall_runes1"
  map      = "MAP02"
}


PREFABS.Wall_runes3 =
{
  template = "Wall_runes1"
  map      = "MAP03"
}


PREFABS.Wall_runes4 =
{
  template = "Wall_runes1"
  map      = "MAP04"
}


PREFABS.Wall_runes5 =
{
  template = "Wall_runes1"
  map      = "MAP05"
}


PREFABS.Wall_runes6 =
{
  template = "Wall_runes1"
  map      = "MAP06"
}

