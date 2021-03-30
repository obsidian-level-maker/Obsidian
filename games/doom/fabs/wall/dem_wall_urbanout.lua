PREFABS.Wall_trash1 =
{
  file   = "wall/dem_wall_urbanout.wad",
  map    = "MAP01",

  prob   = 20,
  theme = "urban",
  env    = "outdoor",

  texture_pack = "armaetus",

  on_liquids = "never",

  scenic_mode = "never",

  where  = "edge",
  height = 128,
  deep   = 80,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  flat_FLAT5_8 =
  {
    FLAT5_8 = 50,
    SLIME05 = 50,
    BODIESF2 = 50,
    BODIESFL = 50
  }
}

PREFABS.Wall_trash2 =
{
  template = "Wall_trash1",
  map    = "MAP02"
}

PREFABS.Wall_trash3 =
{
  template = "Wall_trash1",
  map    = "MAP03"
}

PREFABS.Wall_dumpsteropen =
{
  template = "Wall_trash1",
  map = "MAP04",

  texture_pack = nil,

  on_liquids = "never",

  scenic_mode = "never",

  deep = 64,

  flat_FLAT5_8 = "FLAT5_8"
}

PREFABS.Wall_dumpsterclosed =
{
  template = "Wall_trash1",
  map = "MAP05",

  texture_pack = nil,

  on_liquids = "never",

  scenic_mode = "never",

  deep = 64
}

PREFABS.Wall_doorstopstep =
{
  file   = "wall/dem_wall_urbanout.wad",
  map    = "MAP06",

  prob   = 20,
  theme = "urban",
  env    = "outdoor",

  on_liquids = "never",

  scenic_mode = "never",

  need_solid_depth = 2,

  where  = "edge",
  height = 128,
  deep   = 56,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_DOOR3 =
  {
    DOOR1 = 50,
    DOOR3 = 50
  }
}

PREFABS.Wall_doorstep =
{
  template = "Wall_doorstopstep",
  map = "MAP07"
}

PREFABS.Wall_boombox =
{
  template = "Wall_trash1",
  map    = "MAP08",

  prob   = 15,

  deep   = 48
}
