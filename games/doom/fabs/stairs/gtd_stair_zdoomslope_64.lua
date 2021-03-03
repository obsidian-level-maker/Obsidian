PREFABS.Stair_slope =
{
  file   = "stairs/gtd_stair_zdoomslope_64.wad",
  map    = "MAP01",

  prob   = 100,
  prob_skew = 3,

  style  = "steepness",

  engine = "zdoom",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,

  x_fit  = "stretch",

  bound_z1 = 0,

  delta_h = 64,
  plain_ceiling = true,
}

PREFABS.Stair_slope_2 =
{
  template = "Stair_slope",

  map = "MAP02",

  seed_h = 2,
}

PREFABS.Stair_slope_3 =
{
  template = "Stair_slope",

  map = "MAP03",

  seed_h = 3,
}
