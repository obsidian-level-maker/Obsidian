--
-- Keyed doors, medium size
--

PREFABS.Locked_medium_red =
{
  file   = "door/key_medium.wad"
  map    = "MAP01"

  where  = "edge"
  key    = "k_red"

  seed_w = 2

  deep   = 32
  over   = 32

  x_fit  = "frame"

  flat_FLAT23 = "BIGDOOR1"

  -- texture is already "DOORRED"
  -- line special is already #33
}

PREFABS.Locked_medium_red_diag =
{
  file   = "door/key_medium.wad"
  map    = "MAP02"

  where  = "diagonal"
  key    = "k_red"

  seed_w = 2
  seed_h = 2

  flat_FLAT23 = "BIGDOOR1"

  -- texture is already "DOORRED"
  -- line special is already #33
}


----------------------------------------------


PREFABS.Locked_medium_blue =
{
  template = "Locked_medium_red"
  key      = "k_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}

PREFABS.Locked_medium_blue_diag =
{
  template = "Locked_medium_red_diag"
  key      = "k_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}


----------------------------------------------


PREFABS.Locked_medium_yellow =
{
  template = "Locked_medium_red"
  key      = "k_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}

PREFABS.Locked_medium_yellow_diag =
{
  template = "Locked_medium_red_diag"
  key      = "k_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}

