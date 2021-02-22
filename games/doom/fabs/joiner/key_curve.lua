--
-- L_shape keyed door
--

PREFABS.Locked_curve_red =
{
  file   = "joiner/key_curve.wad",
  map    = "MAP01",

  key    = "k_red",
  prob   = 100,

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,

  nearby_h = 160,

  flat_FLAT23 = "BIGDOOR2",

  -- texture is already "DOORRED",
  -- line special is already #33,
}


PREFABS.Locked_curve_blue =
{
  template = "Locked_curve_red",
  key      = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}


PREFABS.Locked_curve_yellow =
{
  template = "Locked_curve_red",
  key      = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}

