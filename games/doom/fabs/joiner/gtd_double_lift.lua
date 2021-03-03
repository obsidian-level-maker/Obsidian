PREFABS.Joiner_double_lift_tech =
{
  file   = "joiner/gtd_double_lift.wad",

  prob   = 100,
  style  = "steepness",
  theme  = "!hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 56,72 },

  delta_h  = 256,
  neighbor_h = 256+128,
  can_flip = true,
}

PREFABS.Joiner_double_lift_hell =
{
  template   = "Joiner_double_lift_tech",
  map        = "MAP02",

  y_fit  = { 16,24 , 136,144 },

  theme      = "hell",
}
