--
-- Tall keyed door
--

PREFABS.Locked_joiner_key1_tall =
{
  file   = "joiner/key_tall.wad",
  map    = "MAP01",

  prob   = 40,

  key    = "k_red",
  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  nearby_h = 160,
}

PREFABS.Locked_joiner_key2_tall =
{
  template = "Locked_joiner_key1_tall",

  key = "k_blue",

  tex_DOORRED = "DOORBLU",

  line_33 = 32
}

PREFABS.Locked_joiner_key3_tall =
{
  template = "Locked_joiner_key1_tall",

  key = "k_yellow",

  tex_DOORRED = "DOORYEL",

  line_33 = 34
}

--

PREFABS.Locked_joiner_key1_tall_funnel =
{
  template = "Locked_joiner_key1_tall",
  map = "MAP02",

  seed_w = 2
}

PREFABS.Locked_joiner_key2_tall_funnel =
{
  template = "Locked_joiner_key1_tall",
  map = "MAP02",

  seed_w = 2,

  key = "k_blue",

  tex_DOORRED = "DOORBLU",

  line_33 = 32
}

PREFABS.Locked_joiner_key3_tall_funnel =
{
  template = "Locked_joiner_key1_tall",
  map = "MAP02",

  seed_w = 2,

  key = "k_yellow",

  tex_DOORRED = "DOORYEL",

  line_33 = 34
}
