--
-- Wooden Barrels
--

PREFABS.Decor_barrels1 =
{
  file   = "decor/barrels.wad",
  map    = "MAP01",

  prob   = 50,
  env    = "building",

  nolimit_compat = true,

  where  = "point",
  size   = 96,

  bound_z1 = 0,
  bound_z2 = 32,

  solid_ents = true,
  sink_mode  = "never",
}


PREFABS.Decor_barrels2 =
{
  template = "Decor_barrels1",
  map      = "MAP02",
}


PREFABS.Decor_barrels3 =
{
  template = "Decor_barrels1",
  map      = "MAP03",
}

PREFABS.Decor_barrels4 =
{
  template = "Decor_barrels1",
  map      = "MAP04",
}

