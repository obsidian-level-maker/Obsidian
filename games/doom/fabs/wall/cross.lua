--
-- Wall with hellish cross
--

PREFABS.Wall_cross1 =
{
  file   = "wall/cross.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "cross1",

  where  = "edge",
  deep   = 16,

  height = 128,

  x_fit  = "frame",
  z_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 128,
}


PREFABS.Wall_cross2 =
{
  template = "Wall_cross1",

  group = "cross2",

  tex_REDWALL = "FIREWALL",

  -- disable oscillating light FX
  sector_8 = 0,
}

PREFABS.Wall_cross3 =
{
  template = "Wall_cross1",

  group = "cross3",

  tex_REDWALL = "SP_FACE1",

  -- disable oscillating light FX
  sector_8 = 0,
}

PREFABS.Wall_cross4 =
{
  template = "Wall_cross1",

  group = "cross4",

  tex_REDWALL = "BFALL1",

  -- disable oscillating light FX
  sector_8 = 0,
}

PREFABS.Wall_cross5 =
{
  template = "Wall_cross1",

  group = "cross5",

  tex_REDWALL = "SP_FACE2",

  -- disable oscillating light FX
  sector_8 = 0,
}
