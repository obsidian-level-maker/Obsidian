PREFABS.Lift_gtd_pistons_128 =
{
  file = "stairs/gtd_lift_pistons_64.wad",
  map = "MAP01",

  theme = "!hell",

  env = "building",

  prob = 10,
  style = "steepness",

  where = "seeds",
  shape = "I",

  seed_h = 1,
  seed_w = 1,

  x_fit = "frame",

  bound_z1 = 0,

  delta_h = 64,
  plain_ceiling = true,
}

PREFABS.Lift_gtd_pistons_128_hell =
{
  template = "Lift_gtd_pistons_128",
  map = "MAP02",

  theme = "hell",
}

PREFABS.Lift_gtd_pistons_128_out =
{
  template = "Lift_gtd_pistons_128",
  map = "MAP03",

  env = "outdoor",

  seed_w = 3,

}

PREFABS.Lift_gtd_pistons_128_outhell =
{
  template = "Lift_gtd_pistons_128",
  map = "MAP04",

  theme = "hell",

  env = "outdoor",

  seed_w = 3,

}
