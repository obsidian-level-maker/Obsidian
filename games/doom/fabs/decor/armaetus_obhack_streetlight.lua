PREFABS.Decor_obhack_streetlight =
{
  file   = "decor/armaetus_obhack_streetlight.wad",
  map    = "MAP01",

  prob   = 5000,
  skip_prob = 35,

  theme  = "!hell",
  env    = "outdoor",

  where  = "point",
  size   = 160,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 20,78 }
}

PREFABS.Decor_obhack_streetlight_2 =
{
  template = "Decor_obhack_streetlight",
  map = "MAP02",
}

PREFABS.Decor_obhack_streetlight_3 =
{
  template = "Decor_obhack_streetlight",
  map = "MAP03",
}
