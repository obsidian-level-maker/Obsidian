PREFABS.Sidewalk_16_tech =
{
  file   = "stairs/sidewalk_16.wad",

  prob   = 12,
  prob_skew = 1.5,

  map    = "MAP01",
  theme  = "tech",

  where  = "seeds",

  style  = "steepness",
  shape  = "I",

  seed_h = 1,
  seed_w = 1,

  x_fit  = "stretch",
  y_fit  = "stretch",

  bound_z1 = 0,
  bound_z2 = 16,

  delta_h = 16,

  tex_METAL = "STEP4",
  flat_CEIL5_2 = "FLAT19",
}

PREFABS.Sidewalk_16_gothic =
{
  template = "Sidewalk_16_tech",

  theme = "!tech",

  tex_METAL = "METAL",
  flat_CEIL5_2 = "CEIL5_2",
}

-- with lights

PREFABS.Sidewalk_16_lit =
{
  template = "Sidewalk_16_tech",
  map = "MAP02",

  prob = 6,
}

PREFABS.Sidewalk_16_lit_blue =
{
  template = "Sidewalk_16_tech",
  map = "MAP02",

  prob = 6,

  tex_LITE5 = "LITEBLU4",
}
