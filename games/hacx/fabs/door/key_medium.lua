--
-- Keyed doors, medium size
--

PREFABS.Locked_medium_red =
{
  file   = "door/key_medium.wad",
  map    = "MAP01",

  prob   = 50,

  key    = "kz_red",
  where  = "edge",

  

  seed_w = 2,

  deep   = 32,
  over   = 32,

  x_fit  = "frame",
}


PREFABS.Locked_medium_red_diag =
{
  file   = "door/key_medium.wad",
  map    = "MAP02",

  prob   = 50,

  key    = "kz_red",
  where  = "diagonal",

  

  seed_w = 2,
  seed_h = 2,
}


----------------------------------------------


PREFABS.Locked_medium_blue =
{
  template = "Locked_medium_red",
  key      = "kz_blue",

  line_33  = 32,
  tex_HW510 = "HW512"
}

PREFABS.Locked_medium_blue_diag =
{
  template = "Locked_medium_red_diag",
  key      = "kz_blue",

  line_33  = 32,
  tex_HW510 = "HW512"
}


----------------------------------------------


PREFABS.Locked_medium_yellow =
{
  template = "Locked_medium_red",
  key      = "kz_yellow",

  line_33  = 34,
  tex_HW510 = "HW511"
}

PREFABS.Locked_medium_yellow_diag =
{
  template = "Locked_medium_red_diag",
  key      = "kz_yellow",

  line_33  = 34,
  tex_HW510 = "HW511"
}

