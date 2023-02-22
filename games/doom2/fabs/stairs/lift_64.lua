--
-- basic lift, 64 units high
--

PREFABS.Lift_64 =
{
  file   = "stairs/lift_64.wad",

  prob   = 15,
  theme  = "!hell",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,

  x_fit  = "stretch",

  bound_z1 = 0,

  delta_h = 64,
  plain_ceiling = true,
}

PREFABS.Lift_64_other =
{
  template = "Lift_64",

  theme  = "!tech",
  tex_SUPPORT2 = "SUPPORT3",
}
