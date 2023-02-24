PREFABS.Decor_armaetus_flagpole =
{
  file   = "decor/armaetus_EPIC_flagpole.wad",
  map    = "MAP01",

  theme  = "!hell",
  env = "outdoor",

  prob   = 5000,

  where  = "point",
  height = 264,
  size   = 72,

  bound_z1 = 0,
  bound_z2 = 264,

  sink_mode = "never_liquids",

  z_fit = { 5,6 }
}

-- Uses OBLIGE logo!!
PREFABS.Decor_armaetus_flagpole_obaddon_logo_earth =
{
  template = "Decor_armaetus_flagpole",
  map    = "MAP02",

  theme  = "!hell",
  env = "outdoor",

  texture_pack = "armaetus",

  height = 384,
  size   = 56,

  bound_z1 = 0,
  bound_z2 = 384,
}

-- Uses OBLIGE logo!!
PREFABS.Decor_armaetus_flagpole_obaddon_logo_hell =
{
  template = "Decor_armaetus_flagpole",
  map    = "MAP02",

  theme  = "hell",
  env = "outdoor",

  texture_pack = "armaetus",

  height = 384,
  size   = 56,

  bound_z1 = 0,
  bound_z2 = 384,

  tex_OBDNBNR1 =
  {
    OBDNBNR2 = 100,
  }
}
