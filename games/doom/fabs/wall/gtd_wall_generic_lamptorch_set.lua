PREFABS.Wall_generic_gtd_lamp_stubby =
{
  file   = "wall/gtd_wall_generic_lamptorch_set.wad",
  map    = "MAP01",

  prob   = 50,
  group = "gtd_wall_lamp_stubby",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top"
}

PREFABS.Wall_generic_gtd_lamp_stubby_diag =
{
  template = "Wall_generic_gtd_lamp_stubby",
  file = "wall/torches.wad",
  map = "MAP02",

  where = "digonal",

  thing_45 = 2028
}

--

PREFABS.Wall_generic_gtd_lamp_thicc =
{
  template = "Wall_generic_gtd_lamp_stubby",
  group = "gtd_wall_lamp_thicc",

  thing_2028 = 86
}

PREFABS.Wall_generic_gtd_lamp_thicc_diag =
{
  template = "Wall_generic_gtd_lamp_stubby",
  file = "wall/torches.wad",
  map = "MAP02",

  where = "digonal",

  group = "gtd_wall_lamp_thicc",

  thing_45 = 86
}

--

PREFABS.Wall_generic_gtd_lamp_thin =
{
  template = "Wall_generic_gtd_lamp_stubby",
  group = "gtd_wall_lamp_thin",

  thing_2028 = 85
}

PREFABS.Wall_generic_gtd_lamp_thin_diag =
{
  template = "Wall_generic_gtd_lamp_stubby",
  file = "wall/torches.wad",
  map = "MAP02",

  group = "gtd_wall_lamp_thin",

  where = "digonal",

  thing_45 = 85
}

-- TODO: hell versions