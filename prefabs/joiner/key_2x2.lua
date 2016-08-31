--
-- Large 2x2 keyed joiner
--

PREFABS.Locked_2x2_red =
{
  file   = "joiner/key_2x2.wad"
  map    = "MAP01"

  where  = "seeds"
  shape  = "I"

  key    = "k_red"

  seed_w = 2
  seed_h = 2

  prob   = 70

  delta_h  = 16
  nearby_h = 160

  -- texture is already "DOORRED"
  -- line special is already #135 (open red door)
}


PREFABS.Locked_2x2_blue =
{
  template = "Locked_2x2_red"

  key      = "k_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}


PREFABS.Locked_2x2_yellow =
{
  template = "Locked_2x2_red"

  key      = "k_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}

