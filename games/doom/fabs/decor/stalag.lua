--
-- Cavey stalagmites & stalactites
--


---- jutting up from floor ----

PREFABS.Decor_stalag1 =
{
  file   = "decor/stalag.wad",
  map    = "MAP01",

  prob   = 5000,
  env    = "cave",

  where  = "point",
  size   = 104,  -- NOTE: a hack, it is really 128,
  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = "stretch",
}

--[[PREFABS.Decor_stalag1_alt1 =
{
  template  = "Decor_stalag1",
  map    = "MAP15",
  prob   = 5000,
}

PREFABS.Decor_stalag1_alt2 =
{
  template  = "Decor_stalag1",
  map    = "MAP16",
  prob   = 5000,
}

PREFABS.Decor_stalag1_alt3 =
{
  template  = "Decor_stalag1",
  map    = "MAP17",
  prob   = 5000,
}

PREFABS.Decor_stalag1_big =
{
  template = "Decor_stalag1",
  map      = "MAP02",

  prob   = 5000,

  z_fit  = "top",
}

PREFABS.Decor_stalag1_big_alt1 =
{
  template = "Decor_stalag1",
  map      = "MAP18",

  prob   = 5000,

  z_fit  = "top",
}

PREFABS.Decor_stalag1_big_alt2 =
{
  template = "Decor_stalag1",
  map      = "MAP19",

  prob   = 5000,

  z_fit  = "top",
}

PREFABS.Decor_stalag1_big_alt3 =
{
  template = "Decor_stalag1",
  map      = "MAP20",

  prob   = 5000,

  z_fit  = "top",
}]]

---- jutting down from ceiling ----

PREFABS.Decor_stalag2 =
{
  template = "Decor_stalag1",
  map      = "MAP04",

  prob   = 5000,

  z_fit  = "stretch",
}

--[[PREFABS.Decor_stalag2_alt1 =
{
  template = "Decor_stalag1",
  map      = "MAP21",

  prob   = 5000,

  z_fit  = "stretch",
}

PREFABS.Decor_stalag2_alt2 =
{
  template = "Decor_stalag1",
  map      = "MAP22",

  prob   = 5000,

  z_fit  = "stretch",
}]]

PREFABS.Decor_stalag2_big =
{
  template = "Decor_stalag1",
  map      = "MAP05",

  prob   = 5000,

  z_fit  = "bottom",
}

--[[PREFABS.Decor_stalag2_big_alt1 =
{
  template = "Decor_stalag1",
  map      = "MAP23",

  prob   = 5000,

  z_fit  = "bottom",
}

PREFABS.Decor_stalag2_big_alt2 =
{
  template = "Decor_stalag1",
  map      = "MAP24",

  prob   = 5000,

  z_fit  = "bottom",
}]]

---- both floor and ceiling ----

PREFABS.Decor_stalag3 =
{
  template = "Decor_stalag1",
  map      = "MAP07",

  prob   = 5000,

  z_fit  = "stretch",
}

--[[PREFABS.Decor_stalag3_alt1 =
{
  template = "Decor_stalag1",
  map      = "MAP25",

  prob   = 5000,

  z_fit  = "stretch",
}

PREFABS.Decor_stalag3_alt2 =
{
  template = "Decor_stalag1",
  map      = "MAP26",

  prob   = 5000,

  z_fit  = "stretch",
}

PREFABS.Decor_stalag3_alt3 =
{
  template = "Decor_stalag1",
  map      = "MAP27",

  prob   = 5000,

  z_fit  = "stretch",
}]]

PREFABS.Decor_stalag3_big =
{
  template = "Decor_stalag1",
  map      = "MAP08",

  prob   = 5000,

  z_fit  = "stretch",
}

--[[PREFABS.Decor_stalag3_big_alt1 =
{
  template = "Decor_stalag1",
  map      = "MAP28",

  prob   = 5000,

  z_fit  = "stretch",
}

PREFABS.Decor_stalag3_big_alt2 =
{
  template = "Decor_stalag1",
  map      = "MAP29",

  prob   = 5000,

  z_fit  = "stretch",
}

PREFABS.Decor_stalag3_big_alt3 =
{
  template = "Decor_stalag1",
  map      = "MAP30",

  prob   = 5000,

  z_fit  = "stretch",
}]]
