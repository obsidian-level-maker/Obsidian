--
-- huge joiner with a round glowy thing
--

PREFABS.Joiner_y2 =
{
  file   = "joiner/y2.wad",

  prob   = 120,
  theme  = "!hell",
  env    = "!cave",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  flat_CRATOP1 = "FLOOR1_6",

  delta_h  = 32,
  nearby_h = 128,
  can_flip = false
}

PREFABS.Joiner_y2_blue =
{
  template = "Joiner_y2",

  tex_REDWALL = "COMPBLUE",
  flat_CRATOP1 = "CEIL4_2",
}
