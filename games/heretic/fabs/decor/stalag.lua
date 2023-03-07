--
-- Cavey stalagmites & stalactites
--


---- jutting up from floor ----

PREFABS.Decor_stalag1 =
{
  file   = "decor/stalag.wad",
  map    = "MAP01",

  prob   = 150,
  env    = "cave",

  where  = "point",
  size   = 104,  -- NOTE: a hack, it is really 128,
  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = "stretch",
}

PREFABS.Decor_stalag1_big =
{
  template = "Decor_stalag1",
  map      = "MAP02",

  prob   = 100,

  z_fit  = "top",
}


---- jutting down from ceiling ----

PREFABS.Decor_stalag2 =
{
  template = "Decor_stalag1",
  map      = "MAP04",

  prob   = 170,

  z_fit  = "stretch",
}

PREFABS.Decor_stalag2_big =
{
  template = "Decor_stalag1",
  map      = "MAP05",

  prob   = 130,

  z_fit  = "bottom",
}


---- both floor and ceiling ----

PREFABS.Decor_stalag3 =
{
  template = "Decor_stalag1",
  map      = "MAP07",

  prob   = 150,

  z_fit  = "stretch",
}

PREFABS.Decor_stalag3_big =
{
  template = "Decor_stalag1",
  map      = "MAP08",

  prob   = 100,

  z_fit  = "stretch",
}

