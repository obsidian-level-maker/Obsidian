PREFABS.Locked_keyed_infestation_red =
{
  file   = "joiner/gtd_infestation_keyed.wad",
  map    = "MAP01",

  where  = "seeds",
  shape  = "I",

  key    = "k_red",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  prob   = 30,

  y_fit = "frame",
  x_fit = "frame",

  can_flip = true,
}

PREFABS.Locked_keyed_infestation_blue =
{
  template = "Locked_keyed_infestation_red",

  key      = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_135 = 133,
}

PREFABS.Locked_keyed_infestation_yellow =
{
  template = "Locked_keyed_infestation_red",

  key      = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_135 = 137,
}
