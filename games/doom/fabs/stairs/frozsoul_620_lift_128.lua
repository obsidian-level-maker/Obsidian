PREFABS.Lift_620_128 =
{
  file   = "stairs/frozsoul_620_lift_128.wad",

  prob   = 10,
  prob_skew = 1.5,

  port = "!limit",

  theme  = "!hell",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  x_fit  = "frame",
  y_fit = "frame",

  bound_z1 = 0,

  delta_h = 128,
  plain_ceiling = true,
}

PREFABS.Lift_620_128_limit =
{
  template = "Lift_620_128",

  port = "limit",

  line_13369 = 120,
  line_13371 = 123
}
