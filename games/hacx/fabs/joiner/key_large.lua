--
-- Large keyed door
--

PREFABS.Locked_joiner_red =
{
  file   = "joiner/key_large.wad",
  map    = "MAP01",

  prob   = 100,

  

  key    = "kz_red",
  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  nearby_h = 160,
}


PREFABS.Locked_joiner_blue =
{
  template = "Locked_joiner_red",

  key = "kz_blue",

  line_33 = 32,
  tex_HW510 = "HW512",
}


PREFABS.Locked_joiner_yellow =
{
  template = "Locked_joiner_red",

  key = "kz_yellow",

  line_33 = 34,
  tex_HW510 = "HW511",
}

