--
-- Outdoor ponds based on Oblige 0.97,
--

PREFABS.Decor_frozsoul_097_water_pond =
{
  file   = "decor/frozsoul_097_ponds.wad",
  map    = "MAP01",

  liquid = true,

  -- high probability is needed to have a reasonable chance of appearing
  prob   = 5000,
  env    = "outdoor",

  where  = "point",
  size   = 96,

  bound_z1 = 0,

  sink_mode = "never",
}

PREFABS.Decor_frozsoul_097_water_pond_alt =
{
  template = "Decor_frozsoul_097_water_pond",
  map      = "MAP02",

  size   = 128,
}