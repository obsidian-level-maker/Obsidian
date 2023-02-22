PREFABS.Wall_urban_diagonal_windows =
{
  file   = "wall/gtd_wall_urban_diagonal_EPIC.wad",
  map    = "MAP01",

  env = "outdoor",

  prob   = 75,
  prob_skew = 2,

  theme = "urban",

  where  = "diagonal",
  height = 192,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 192,

  z_fit = "top",

  tex_CITY01 =
  {
    BRWINDOW = 5,
    MODWALL3 = 3,
    MODWALL2 = 3,
    MODWALL4 = 3,
    BLAKWAL1 = 5,
    BLAKWAL2 = 5,
  },
}

PREFABS.Wall_urban_diagonal_windows_EPIC =
{
  template = "Wall_urban_diagonal_windows",

  texture_pack = "armaetus",
  replaces = "Wall_urban_diagonal_windows",

  tex_CITY01 =
  {
    BRWINDOW = 10,
    MODWALL3 = 3,
    MODWALL2 = 3,
    MODWALL4 = 3,
    BLAKWAL1 = 5,
    BLAKWAL2 = 5,
    CITY01 = 10,
    CITY02 = 10,
    CITY03 = 10,
    CITY04 = 10,
    CITY05 = 10,
    CITY06 = 10,
    CITY07 = 10,
    CITY11 = 10,
    CITY12 = 10,
    CITY13 = 10,
    CITY14 = 10,
  },
}
