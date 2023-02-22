--
-- Water Fountain
--


PREFABS.Decor_water_fountain =
{
  file   = "decor/fountain.wad",
  map    = "MAP01",

  prob   = 5000,
  env    = "outdoor",

  where  = "point",
  size   = 128,

  bound_z1 = 0,

  sink_mode = "never_liquids",

  sound = "Water_Streaming",
}

PREFABS.Decor_blood_fountain =
{
  file   = "decor/fountain.wad",
  map    = "MAP02",

  prob   = 5000,
  theme  = "!tech",
  env    = "outdoor",

  where  = "point",
  size   = 128,

  bound_z1 = 0,

  sink_mode = "never_liquids",
}

PREFABS.Decor_lava_fountain =
{
  file   = "decor/fountain.wad",
  map    = "MAP03",

  prob   = 5000,
  theme  = "hell",
  env    = "outdoor",

  where  = "point",
  size   = 128,

  bound_z1 = 0,

  sink_mode = "never_liquids",
}
