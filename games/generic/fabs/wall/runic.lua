--
-- Wall with spoopy runes
--

PREFABS.Wall_runicA =
{
  file   = "wall/runic.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "runic",

  where  = "edge",
  deep   = 16,

  height = 128,

  x_fit  = "frame",
  z_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 128
}


PREFABS.Wall_runicB =
{
  template = "Wall_runicA",
  map      = "MAP02"
}


PREFABS.Wall_runicC =
{
  template = "Wall_runicA",
  map      = "MAP03"
}


PREFABS.Wall_runicD =
{
  template = "Wall_runicA",
  map      = "MAP04"
}


PREFABS.Wall_runicE =
{
  template = "Wall_runicA",
  map      = "MAP05"
}


PREFABS.Wall_runicF =
{
  template = "Wall_runicA",
  map      = "MAP06"
}

