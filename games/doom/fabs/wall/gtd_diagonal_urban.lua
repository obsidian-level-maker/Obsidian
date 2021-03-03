PREFABS.Wall_urban_diagonal_window_bright =
{
  file = "wall/gtd_diagonal_urban.wad",
  map = "MAP01",

  prob = 50,
  theme = "urban",
  env = "!cave",

  where = "diagonal",
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_urban_diagonal_window_dark =
{
  template = "Wall_urban_diagonal_window_bright",
  map = "MAP02",

  prob = 12,

  z_fit = { 60,68 },

  tex_MODWALL4 =
  {
    MODWALL4=50,
    MODWALL3=50,
    BLAKWAL1=50,
    BLAKWAL2=50,
  },
}

PREFABS.Wall_urban_diagonal_window_dark_top_fit =
{
  template = "Wall_urban_diagonal_window_bright",
  map = "MAP02",

  prob = 25,

  z_fit = "bottom",

  tex_MODWALL4 =
  {
    MODWALL4=50,
    MODWALL3=50,
    BLAKWAL1=50,
    BLAKWAL2=50,
  },
}

PREFABS.Wall_urban_tall_lite5 =
{
  template = "Wall_urban_diagonal_window_bright",
  map = "MAP03",

  theme = "!hell",

  z_fit = { 60,68 },
}
