PREFABS.Joiner_gtd_basic_keyed_curve_green =
{
  file   = "joiner/gtd_basic_keyed_L.wad",
  map    = "MAP01",

  prob   = 30,

  key    = "k_green",

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,
}

PREFABS.Joiner_gtd_basic_keyed_curve_blue =
{
  template = "Joiner_gtd_basic_keyed_curve_green",

  key = "k_blue",

  line_33 = 32,
  thing_95 = 94,
}

PREFABS.Joiner_gtd_basic_keyed_curve_yell =
{
  template = "Joiner_gtd_basic_keyed_curve_green",

  key = "k_yellow",

  line_33 = 34,
  thing_95 = 96,
}
