-- MSSP: I would like to pretend this was inspired
-- Memento Mori somehow.

PREFABS.Lift_gtd_disguised_128 =
{
  file = "stairs/gtd_lift_disguised_128.wad",
  map = "MAP01",

  prob = 10,
  prob_skew = 2,

  style = "steepness",
  env = "building",

  where = "seeds",
  shape = "I",

  seed_h = 1,
  seed_w = 1,

  x_fit = "frame",

  bound_z1 = 0,

  delta_h = 128,
  plain_ceiling = true,
}

PREFABS.Lift_gtd_disguised_128_2h =
{
  template = "Lift_gtd_disguised_128",
  map = "MAP02",

  seed_h = 2,
}

PREFABS.Lift_gtd_disguised_128_3h =
{
  template = "Lift_gtd_disguised_128",
  map = "MAP03",

  seed_h = 3,
}
