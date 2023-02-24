PREFABS.Lift_gtd_slumpish_64 =
{
  file = "stairs/gtd_slumpish_stairs_64.wad",
  map = "MAP01",

  prob = 5,
  prob_skew = 2.5,
  style = "steepness",

  port = "zdoom",

  where = "seeds",
  shape = "I",

  seed_h = 1,
  seed_w = 1,

  x_fit = "stretch",
  y_fit = "stretch",

  bound_z1 = 0,

  delta_h = 64,
}

PREFABS.Lift_gtd_slumpish_64_frame =
{
  template = "Lift_gtd_slumpish_64",

  x_fit = "frame",
}

--

PREFABS.Lift_gtd_slumpish_64_limit =
{
  template = "Lift_gtd_slumpish_64",

  port = "!zdoom",

  line_261 = 0
}

PREFABS.Lift_gtd_slumpish_64_framelimit =
{
  template = "Lift_gtd_slumpish_64",

  port = "!zdoom",

  line_261 = 0,

  x_fit = "frame"
}
