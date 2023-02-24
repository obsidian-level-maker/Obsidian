PREFABS.Decor_3x3_bookshelves_thin =
{
  file   = "decor/armaetus_library.wad",
  map    = "MAP01",

  prob   = 3500,

  where  = "point",
  theme  = "!tech",

  env    = "building",

  size   = 144,
  height = 128+32,

  bound_z1 = 0,
  bound_z2 = 128,

  tex_PANBLACK =
  {
    PANBLACK = 50,
    PANBLUE  = 50,
    PANRED   = 50,
  },

  sink_mode = "never_liquids",
}

PREFABS.Decor_3x3_bookshelves_thick =
{
  template = "Decor_3x3_bookshelves_thin",

  map      = "MAP02",

  size     = 208,
}

PREFABS.Decor_3x1_bookshelves =
{
  template = "Decor_3x3_bookshelves_thin",

  map      = "MAP03",

  size     = 144,
}
