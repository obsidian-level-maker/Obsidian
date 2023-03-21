--
-- wide stair, 3 seeds across
--

PREFABS.Stair_wide_3x1 =
{
  file   = "stairs/wide_3x1.wad",
  map    = "MAP01",

  prob   = 800,

  nolimit_compat = true,

  where  = "seeds",
  shape  = "I",

  seed_w = 3,

  bound_z1 = 0,
  bound_z2 = 32,

  delta_h = 32,
}


PREFABS.Stair_wide_3x1_torch =
{
  file   = "stairs/wide_3x1.wad",
  map    = "MAP02",

  nolimit_compat = true,

  prob  = 400,

  where  = "seeds",
  shape  = "I",

  seed_w = 3,

  bound_z1 = 0,
  bound_z2 = 32,

  delta_h = 32,
}

