PREFABS.Ladder_128_rustic =
{
  file   = "stairs/gtd_stair_ladder_128.wad",
  map    = "MAP01",

  prob   = 3,
  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  x_fit = "frame",
  y_fit = "bottom",

  bound_z1 = 0,

  delta_h = 128,
  plain_ceiling = true,

  tex_STEPLAD1 = {STEPLAD1=50, STEP1=50, STEP3=50}
}

PREFABS.Ladder_128_techy =
{
  template = "Ladder_128_rustic",

  theme = "!hell",

  tex_STEPLAD1 = "STEP4",
  tex_METAL = "SILVER1",
  tex_SUPPORT3 = {SUPPORT2=50, LITEBLU1=50, SUPPORT3=50},
  flat_CEIL5_2 = "FLAT19"
}

PREFABS.Ladder_128_woody =
{
  template = "Ladder_128_rustic",

  theme = "!tech",

  tex_STEPLAD1 = {STEP2=50, STEP6=50, STEP3=50},
  tex_METAL = "WOOD8",
  tex_SUPPORT3 = "WOOD8",
  flat_CEIL5_2 = "FLAT5_1"
}

PREFABS.Ladder_thin =
{
  file = "stairs/gtd_stair_ladder_128.wad",
  map = "MAP02",

  prob = 9,
  style = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  x_fit = "frame",
  y_fit = "bottom",

  bound_z1 = 0,

  delta_h = 128,
  plain_ceiling = true,

  tex_STEPLAD1 =
  {
    STEPLAD1 = 50,
    STEP1 = 25,
    STEP3 = 25,
    STEPTOP = 50
  }
}
