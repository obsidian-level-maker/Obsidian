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

--[[
PREFABS.Decor_frozsoul_097_nukage_pond1 =
{
  template = "Decor_frozsoul_097_water_pond1",
  flat_FWATER1 = "NUKAGE1",
}

PREFABS.Decor_frozsoul_097_nukage_pond2 =
{
  template = "Decor_frozsoul_097_water_pond1",
  map      = "MAP02",
  flat_FWATER1 = "NUKAGE1",
}

PREFABS.Decor_frozsoul_097_blood_pond1 =
{
  template = "Decor_frozsoul_097_water_pond1",
  theme = "!tech",
  flat_FWATER1 = "BLOOD1",
}

PREFABS.Decor_frozsoul_097_blood_pond2 =
{
  template = "Decor_frozsoul_097_water_pond1",
  map      = "MAP02",
  theme = "!tech",
  flat_FWATER1 = "BLOOD1",
}

PREFABS.Decor_frozsoul_097_lava_pond1 =
{
  template = "Decor_frozsoul_097_water_pond1",
  theme = "hell",
  flat_FWATER1 = "LAVA1",
}

PREFABS.Decor_frozsoul_097_lava_pond2 =
{
  template = "Decor_frozsoul_097_water_pond1",
  map      = "MAP02",
  theme = "hell",
  flat_FWATER1 = "LAVA1",
}
]]
