--
-- Huge keyed door
--


PREFABS.Locked_huge_red =
{
  file   = "joiner/key_huge.wad"
  where  = "seeds"
  shape  = "I"

  key    = "k_red"

  seed_w = 3
  seed_h = 2

  prob   = 100

  delta_h  = 16
  nearby_h = 160

  -- texture is already "DOORRED"
  -- line special is already #135 (open red door)
}


PREFABS.Locked_huge_blue =
{
  template = "Locked_huge_red"

  key      = "k_blue"

  tex_DOORRED = "DOORBLU"
  line_135    = 133
}


PREFABS.Locked_huge_yellow =
{
  template = "Locked_huge_red"

  key      = "k_yellow"

  tex_DOORRED = "DOORYEL"
  line_135    = 137
}

