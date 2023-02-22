--
-- Joiner with lift
--

PREFABS.Joiner_lift3 =
{
  file   = "joiner/lift3.wad",

  prob   = 40,
  style  = "steepness",
  theme  = "tech",

  env      = "!cave",
  neighbor = "!cave",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 96,112 },

  delta_h  = 104,
  can_flip = true,

  tex_PLAT1    = { PLAT1=50, SUPPORT2=50 },
  tex_SUPPORT3 = "TEKWALL4",
  tex_METAL    = "TEKWALL1",

}

PREFABS.Joiner_lift3_hell =
{
  template   = "Joiner_lift3",
  theme      = "hell",

  tex_PLAT1 = "SUPPORT3",
  tex_SUPPORT3 = "MARBLE1",
  flat_TLITE6_5 = "TLITE6_6",

}

PREFABS.Joiner_lift3_urban =
{
  template   = "Joiner_lift3",
  theme      = "urban",

  tex_PLAT1    = { PLAT1=50, SUPPORT2=50, SUPPORT3=50 },
  flat_TLITE6_5 = { TLITE6_6=50, TLITE6_5=50 },

}
