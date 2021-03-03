PREFABS.Stairs_128 =
{
  file   = "stairs/gtd_stairs_128.wad",
  map    = "MAP01",

  prob   = 25,
  prob_skew = 3,

  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,

  x_fit  = "stretch",

  bound_z1 = 0,

  delta_h = 128,
}

PREFABS.Stairs_128_2X =
{
  template = "Stairs_128",
  map    = "MAP02",

  prob   = 220,

  seed_h = 2,
}

PREFABS.Stairs_128_3X =
{
  template = "Stairs_128",
  map    = "MAP03",

  prob   = 240,
  seed_h = 3,
}
