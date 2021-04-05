--
-- Pictures : 64x64
--

----| TECH |----

PREFABS.Pic_compwerd =
{
  file   = "wall/pic_64x64.wad"
  where  = "edge"
  long   = 128
  deep   = 16

  x_fit  = "frame"
  y_fit  = "top"
  z_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128

  theme = "tech"
  prob  = 25

  tex_GRAYPOIS = "COMPWERD"
}


PREFABS.Pic_monitor =
{
  file   = "wall/pic_64x64.wad"
  where  = "edge"
  long   = 128
  deep   = 16

  x_fit  = "frame"
  y_fit  = "top"
  z_fit  = "top"

  bound_z1 = 0
  bound_z2 = 128

  theme = "tech"
  prob  = 10

  -- this is mapped to "COMPUTE1" for DOOM 1
  tex_GRAYPOIS = "SPACEW3"
}


----| URBAN |----

PREFABS.Pic_smallface =
{
  file   = "wall/pic_64x64.wad"
  where  = "edge"
  long   = 128
  deep   = 16

  x_fit  = "frame"
  y_fit  = "top"
  z_fit  = "top"

  bound_z1 = 0
  bound_z2 = 128

  theme = "urban"
  prob  = 20

  tex_GRAYPOIS = { GSTGARG=50, GSTLION=50 }
}


PREFABS.Pic_bstone3 =
{
  file   = "wall/pic_64x64.wad"
  where  = "edge"
  long   = 128
  deep   = 16

  x_fit  = "frame"
  y_fit  = "top"
  z_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128

  theme = "urban"
  prob  = 20

  tex_GRAYPOIS = "BSTONE3"
}

