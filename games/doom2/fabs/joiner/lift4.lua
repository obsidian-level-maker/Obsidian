--
-- Large joiner with lift
--

PREFABS.Joiner_lift4 =
{
  file   = "joiner/lift4.wad",

  prob   = 15,
  style  = "steepness",
  theme  = "tech",

  env      = "!cave",
  neighbor = "!cave",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  delta_h  = 128,
  nearby_h = 128,
}


PREFABS.Joiner_lift4_hell =
{
  template = "Joiner_lift4",

  theme = "!tech",

  tex_SUPPORT2  = "SUPPORT3",
  tex_TEKWALL4  = "STONE3",
  flat_MFLR8_2  = "MFLR8_1",
  flat_TLITE6_5 = "TLITE6_6",
}

