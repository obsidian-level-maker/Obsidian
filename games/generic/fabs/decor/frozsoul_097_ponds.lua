--
-- Outdoor ponds based on Oblige 0.97,
--

PREFABS.Decor_frozsoul_097_water_pond1 =
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

PREFABS.Decor_frozsoul_097_water_pond2 =
{
  template = "Decor_frozsoul_097_water_pond1",
  map      = "MAP02",

  size   = 128,
}