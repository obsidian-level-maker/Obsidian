--
-- Large keyed door
--

PREFABS.Locked_joiner_red =
{
  file   = "joiner/key_large.wad"
  where  = "seeds"
  shape  = "I"

  key    = "k_red"

  seed_w = 2
  seed_h = 1

  x_fit  = "frame"

  nearby_h = 160

  prob   = 100

  flat_FLOOR7_2 = "BIGDOOR3"

  -- texture is already "DOORRED"
  -- line special is already #33
}


PREFABS.Locked_joiner_blue =
{
  template = "Locked_joiner_red"
  key      = "k_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}


PREFABS.Locked_joiner_yellow =
{
  template = "Locked_joiner_red"
  key      = "k_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}

