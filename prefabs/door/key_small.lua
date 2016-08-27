--
-- Keyed doors, small variety
--

PREFABS.Locked_small_red =
{
  file   = "door/key_small.wad"
  map    = "MAP01"

  where  = "edge"
  key    = "k_red"

  deep   = 32
  over   = 32

  -- no x_fit (hence wider doors will use key_medium.wad)

  flat_FLAT23 = "DOOR3"

  -- texture is already "DOORRED"
  -- line special is already #33
}

PREFABS.Locked_small_red_diag =
{
  file   = "door/key_small.wad"
  map    = "MAP02"

  where  = "diagonal"
  key    = "k_red"

  flat_FLAT23 = "DOOR3"

  -- texture is already "DOORRED"
  -- line special is already #33
}


----------------------------------------------


PREFABS.Locked_small_blue =
{
  template = "Locked_small_red"
  key      = "k_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}

PREFABS.Locked_small_blue_diag =
{
  template = "Locked_small_red_diag"
  key      = "k_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}


----------------------------------------------


PREFABS.Locked_small_yellow =
{
  template = "Locked_small_red"
  key      = "k_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}

PREFABS.Locked_small_yellow_diag =
{
  template = "Locked_small_red_diag"
  key      = "k_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}

