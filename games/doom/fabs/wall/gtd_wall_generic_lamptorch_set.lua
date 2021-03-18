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

-- gothic versions

-- candalebra

PREFABS.Wall_generic_gtd_candalebra =
{
  template = "Wall_generic_gtd_lamp_stubby",
  group = "gtd_wall_candalebra",

  thing_2028 = 35
}

PREFABS.Wall_generic_gtd_candalebra_diag =
{
  template = "Wall_generic_gtd_lamp_stubby",
  file = "wall/torches.wad",
  map = "MAP02",

  group = "gtd_wall_candalebra",

  where = "digonal",

  thing_45 = 35
}

-- blue torch

PREFABS.Wall_generic_gtd_blue_torch =
{
  template = "Wall_generic_gtd_lamp_stubby",
  group = "gtd_wall_blue_torch",

  thing_2028 = 44
}

PREFABS.Wall_generic_gtd_blue_torch_diag =
{
  template = "Wall_generic_gtd_lamp_stubby",
  file = "wall/torches.wad",
  map = "MAP02",

  group = "gtd_wall_blue_torch",

  where = "digonal",

  thing_45 = 44
}

-- green torch

PREFABS.Wall_generic_gtd_green_torch =
{
  template = "Wall_generic_gtd_lamp_stubby",
  group = "gtd_wall_green_torch",

  thing_2028 = 45
}

PREFABS.Wall_generic_gtd_green_torch_diag =
{
  template = "Wall_generic_gtd_lamp_stubby",
  file = "wall/torches.wad",
  map = "MAP02",

  group = "gtd_wall_green_torch",

  where = "digonal",

  thing_45 = 45
}

-- red torch

PREFABS.Wall_generic_gtd_red_torch =
{
  template = "Wall_generic_gtd_lamp_stubby",
  group = "gtd_wall_red_torch",

  thing_2028 = 46
}

PREFABS.Wall_generic_gtd_red_torch_diag =
{
  template = "Wall_generic_gtd_lamp_stubby",
  file = "wall/torches.wad",
  map = "MAP02",

  group = "gtd_wall_red_torch",

  where = "digonal",

  thing_45 = 46
}
