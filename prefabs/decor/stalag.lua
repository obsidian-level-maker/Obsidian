--
-- Cavey stalagmite / stalactite
--

PREFABS.Decor_stalag1 =
{
  file   = "decor/stalag.wad"
  map    = "MAP01"

  prob   = 100
  env    = "cave"

  where  = "point"
  size   = 104  -- NOTE: a hack, it is really 128
  height = 160

  bound_z1 = 0
  bound_z2 = 160

  z_fit  = "top"
}


PREFABS.Decor_stalag2 =
{
  template = "Decor_stalag1"
  map      = "MAP02"

  prob   = 100

  z_fit  = "bottom"
}


PREFABS.Decor_stalag3 =
{
  template = "Decor_stalag1"
  map      = "MAP03"

  prob   = 30

  z_fit  = "stretch"
}

