--
-- Simple ceiling light
--

PREFABS.Light_1 =
{
  file   = "decor/ceil_light.wad"
  map    = "MAP02"

  kind   = "light"
  where  = "point"

  env    = "building"
  height = 96

  bound_z1 = -32
  bound_z2 = 0

  prob   = 50

  flat_TLITE6_4 = "TLITE6_6"
}


PREFABS.Light_hanging =
{
  file   = "decor/ceil_light.wad"
  map    = "MAP03"

  kind   = "light"
  where  = "point"

  env    = "building"
  height = 192

  bound_z1 = -64
  bound_z2 = 0

  theme  = "urban"
  prob   = 500
}

