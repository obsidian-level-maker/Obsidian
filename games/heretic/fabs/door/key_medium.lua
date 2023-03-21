--
-- Keyed doors, medium size
--

PREFABS.Locked_medium_green =
{
  file   = "door/key_medium.wad",
  map    = "MAP01",

  prob   = 50,

  key    = "k_green",
  where  = "edge",

  nolimit_compat = true,

  seed_w = 2,

  deep   = 32,
  over   = 32,

  x_fit  = "frame",

  solid_ents = true

  -- thing is already #95 (green statue)
  -- line special is already #33,
}


PREFABS.Locked_medium_green_diag =
{
  file   = "door/key_medium.wad",
  map    = "MAP02",

  prob   = 50,

  key    = "k_green",
  where  = "diagonal",

  nolimit_compat = true,

  seed_w = 2,
  seed_h = 2,

  solid_ents = true

  -- thing is already #95 (green statue)
  -- line special is already #33,
}


----------------------------------------------


PREFABS.Locked_medium_blue =
{
  template = "Locked_medium_green",
  key      = "k_blue",

  -- use the blue statue and correct line special
  thing_95 = 94,
  line_33  = 32,
}

PREFABS.Locked_medium_blue_diag =
{
  template = "Locked_medium_green_diag",
  key      = "k_blue",

  -- use the blue statue and correct line special
  thing_95 = 94,
  line_33  = 32,
}


----------------------------------------------


PREFABS.Locked_medium_yellow =
{
  template = "Locked_medium_green",
  key      = "k_yellow",

  -- use the yellow statue and corresponding line special
  thing_95 = 96,
  line_33  = 34,
}

PREFABS.Locked_medium_yellow_diag =
{
  template = "Locked_medium_green_diag",
  key      = "k_yellow",

  -- use the yellow statue and corresponding line special
  thing_95 = 96,
  line_33  = 34,
}

