--
-- Huge keyed door
--


PREFABS.Locked_huge_red =
{
  file   = "joiner/key_huge.wad"
  map    = "MAP01"

  where  = "seeds"
  shape  = "I"

  key    = "k_red"

  seed_w = 3
  seed_h = 2

  deep   = 16
  over   = 16

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


--------------------------------------------
------- Another huge locked door -----------
--------------------------------------------

PREFABS.Locked_huge3_red =
{
  template = "Locked_huge_red"
  map = "MAP03"

  delta_h  = 0

  -- texture is already "DOORRED"
  -- line special is already #33 (open red door)

  prob = 3000
}


PREFABS.Locked_huge3_blue =
{
  template = "Locked_huge_red"
  map = "MAP03"

  key = "k_blue"

  delta_h  = 0

  tex_DOORRED = "DOORBLU"
  line_33     = 32

  prob = 3000
}


PREFABS.Locked_huge3_yellow =
{
  template = "Locked_huge_red"
  map = "MAP03"

  key = "k_yellow"

  delta_h  = 0

  tex_DOORRED = "DOORYEL"
  line_33     = 34

  prob = 3000
}

