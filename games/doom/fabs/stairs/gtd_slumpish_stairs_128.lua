PREFABS.Lift_gtd_slumpish_128 =
{
  file = "stairs/gtd_slumpish_stairs_128.wad",
  map = "MAP01",

  prob = 5,
  prob_skew = 2.5,
  style = "steepness",
  
  port = "zdoom",

  where = "seeds",
  shape = "I",

  seed_h = 2,
  seed_w = 1,

  x_fit = "stretch",
  y_fit = "stretch",

  bound_z1 = 0,

  delta_h = 128,
}

PREFABS.Lift_gtd_slumpish_128_frame =
{
  template = "Lift_gtd_slumpish_128",

  x_fit = "frame",
}

--

PREFABS.Lift_gtd_slumpish_128_limit =
{
  template = "Lift_gtd_slumpish_128",

  port = "!zdoom",
  
  line_261 = 0
}

PREFABS.Lift_gtd_slumpish_128_frame_limit =
{
  template = "Lift_gtd_slumpish_128",

  port = "!zdoom",

  x_fit = "frame",

  line_261 = 0
}