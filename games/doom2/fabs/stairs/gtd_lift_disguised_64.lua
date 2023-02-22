PREFABS.Lift_gtd_disguised_64 =
{
  file = "stairs/gtd_lift_disguised_64.wad",
  map = "MAP01",

  port = "!limit",

  prob = 10,
  prob_skew = 5,

  style = "steepness",
  env = "building",

  where = "seeds",
  shape = "I",

  seed_h = 1,
  seed_w = 1,

  x_fit = "frame",
  y_fit = "top",

  bound_z1 = 0,

  delta_h = 64,
  plain_ceiling = true,
}

PREFABS.Lift_gtd_disguised_64_limit =
{
  template = "Lift_gtd_disguised_64",

  port = "limit",

  line_13364 = 123
}

--[[PREFABS.Lift_gtd_disguised_64_2h =
{
  template = "Lift_gtd_disguised_64",
  map = "MAP02",

  seed_h = 2,
}

PREFABS.Lift_gtd_disguised_64_3h =
{
  template = "Lift_gtd_disguised_64",
  map = "MAP03",

  seed_h = 3,
}]]
