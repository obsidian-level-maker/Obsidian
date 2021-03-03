-- red

PREFABS.Wall_generic_doom64_1x=
{
  file   = "wall/gtd_wall_generic_doom64_glow.wad",
  map    = "MAP01",

  prob   = 50,

  group  = "gtd_generic_d64_1x",

  where  = "edge",
  deep   = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = {4,8},
}

PREFABS.Wall_generic_doom64_1x_diag =
{
  template = "Wall_generic_doom64_1x",
  map    = "MAP02",

  where  = "diagonal",
}

-- yellow

PREFABS.Wall_generic_doom64_1x_yellow =
{
  template = "Wall_generic_doom64_1x",
  map = "MAP01",

  group  = "gtd_generic_d64_1x_yellow",

  flat_TLITE6_5 = "TLITE6_6",
}

PREFABS.Wall_generic_doom64_1x_diag_yellow =
{
  template = "Wall_generic_doom64_1x",
  map    = "MAP02",

  where  = "diagonal",

  group  = "gtd_generic_d64_1x_yellow",

  flat_TLITE6_5 = "TLITE6_6",
}

-- blue

PREFABS.Wall_generic_doom64_1x_blue =
{
  template = "Wall_generic_doom64_1x",
  map = "MAP01",

  group  = "gtd_generic_d64_1x_blue",

  flat_TLITE6_5 = "CEIL4_3",
}

PREFABS.Wall_generic_doom64_1x_diag_blue =
{
  template = "Wall_generic_doom64_1x",
  map    = "MAP02",

  where  = "diagonal",

  group  = "gtd_generic_d64_1x_blue",

  flat_TLITE6_5 = "CEIL4_3",
}

--
-- red 2x
--

PREFABS.Wall_generic_doom64_2x =
{
  template = "Wall_generic_doom64_1x",
  map = "MAP03",

  group = "gtd_generic_d64_2x",
}

PREFABS.Wall_generic_doom64_2x_diag =
{
  template = "Wall_generic_doom64_1x",
  map    = "MAP04",

  where  = "diagonal",

  group  = "gtd_generic_d64_2x",
}

-- yellow

PREFABS.Wall_generic_doom64_2x_yellow =
{
  template = "Wall_generic_doom64_1x",
  map = "MAP03",

  group = "gtd_generic_d64_2x_yellow",

  flat_TLITE6_5 = "TLITE6_6",
}

PREFABS.Wall_generic_doom64_2x_diag_yellow =
{
  template = "Wall_generic_doom64_1x",
  map    = "MAP04",

  where  = "diagonal",

  group  = "gtd_generic_d64_2x_yellow",

  flat_TLITE6_5 = "TLITE6_6",
}

-- blue

PREFABS.Wall_generic_doom64_2x_blue =
{
  template = "Wall_generic_doom64_1x",
  map = "MAP03",

  group = "gtd_generic_d64_2x_blue",

  flat_TLITE6_5 = "CEIL4_3",
}

PREFABS.Wall_generic_doom64_2x_diag_blue =
{
  template = "Wall_generic_doom64_1x",
  map    = "MAP04",

  where  = "diagonal",

  group  = "gtd_generic_d64_2x_blue",

  flat_TLITE6_5 = "CEIL4_3",
}
