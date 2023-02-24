--Piano by Craneo

PREFABS.Cran_piano =
{
  file   = "decor/craneo_pianos.wad",
  map    = "MAP01",

  prob   = 800,
  theme  = "urban",

  where  = "point",
  env    = "!outdoor",
  size   = 88,

  bound_z1 = 0,

  sink_mode = "never_liquids"
}

PREFABS.Cran_piano_haunted =
{
  template = "Cran_piano",
  map    = "MAP02",
 
  theme  = "hell"
}
