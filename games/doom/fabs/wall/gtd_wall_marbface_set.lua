PREFABS.Wall_hell_marbface_1 =
{
  file   = "wall/gtd_wall_marbface_set.wad",
  map    = "MAP01",

  prob   = 50,
  theme  = "hell",
  env = "building",

  group = "gtd_wall_marbface",

  where  = "edge",
  deep   = 16,
  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = "frame",

  tex_MARBFAC2 =
  {
    MARBFAC2 = 50,
    MARBFAC3 = 50,
    MARBFACE = 50,
  },
}

PREFABS.Wall_hell_marbface_diag =
{
  file   = "wall/gtd_wall_marbface_set.wad",
  map    = "MAP02",

  prob   = 50,
  theme = "hell",
  group = "gtd_wall_marbface",

  where  = "diagonal",

  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = "frame",

  tex_MARBFAC2 =
  {
    MARBFAC2 = 50,
    MARBFAC3 = 50,
    MARBFACE = 50,
  },
}

PREFABS.Wall_hell_marbface_EPIC_1 =
{
  file   = "wall/gtd_wall_marbface_set.wad",
  map    = "MAP01",

  prob   = 50,
  theme  = "hell",
  env = "building",

  replaces = "Wall_hell_marbface_1",
  texture_pack = "armaetus",

  group = "gtd_wall_marbface",

  where  = "edge",
  deep   = 16,
  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = "frame",

  tex_MARBFAC2 =
  {
    MARBFAC2 = 50,
    MARBFAC3 = 50,
    MARBFACE = 50,
    BLAKFAC2 = 50,
    BLAKFAC3 = 50,
    BLAKFACE = 50,
    MARBFAC6 = 50,
    MARBFAC7 = 50,
    MARBFACF = 50,
  },
}

PREFABS.Wall_hell_marbface_diag_EPIC =
{
  file   = "wall/gtd_wall_marbface_set.wad",
  map    = "MAP02",

  prob   = 50,
  theme = "hell",
  group = "gtd_wall_marbface",

  replaces = "Wall_hell_marbface_diag",
  texture_pack = "armaetus",

  where  = "diagonal",

  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = "frame",

  tex_MARBFAC2 =
  {
    MARBFAC2 = 50,
    MARBFAC3 = 50,
    MARBFACE = 50,
    BLAKFAC2 = 50,
    BLAKFAC3 = 50,
    BLAKFACE = 50,
    MARBFAC6 = 50,
    MARBFAC7 = 50,
    MARBFACF = 50,
  },
}
