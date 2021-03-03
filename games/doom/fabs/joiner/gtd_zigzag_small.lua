PREFABS.Joiner_gtd_zigzag_small =
{
  file   = "joiner/gtd_zigzag_small.wad",
  map    = "MAP01",

  prob   = 200,
  style  = "steepness",

  env      = "!cave",
  neighbor = "!cave",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 64,96 },

  delta_h  = 64,
  nearby_h = 192,
  can_flip = true,
}

PREFABS.Joiner_gtd_zigzag_small_mirrored =
{
  template = "Joiner_gtd_zigzag_small",

  map      = "MAP02",
}
