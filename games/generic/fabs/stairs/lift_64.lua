--
-- basic lift, 64 units high
--

PREFABS.Lift_64 =
{
  file   = "stairs/lift_64.wad",
  game = "!hexen",

  prob   = 15,
  style  = "steepness",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,

  x_fit  = "stretch",

  bound_z1 = 0,

  delta_h = 64,
  plain_ceiling = true,
}