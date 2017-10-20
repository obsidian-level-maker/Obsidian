--
-- L-shape joiner with large lift
--

PREFABS.Joiner_lift_curve =
{
  file   = "joiner/lift_curve.wad"
  map    = "MAP01"

  prob   = 30
  style  = "steepness"
  theme  = "tech"

  env      = "!cave"
  neighbor = "!cave"

  where  = "seeds"
  shape  = "L"

  seed_w = 2
  seed_h = 2

  delta_h  = 128
  nearby_h = 128
}


PREFABS.Joiner_lift_curve_urban =
{
  template = "Joiner_lift_curve"

  map    = "MAP02"

  theme  = "urban"
}


PREFABS.Joiner_lift_curve_deimos =
{
  template = "Joiner_lift_curve"

  map    = "MAP01"

  theme  = "deimos"
}


PREFABS.Joiner_lift_curve_hell =
{
  template = "Joiner_lift_curve"

  map    = "MAP04"

  theme  = "hell"
}


PREFABS.Joiner_lift_curve_flesh =
{
  template = "Joiner_lift_curve"

  map    = "MAP04"

  theme  = "flesh"
}

