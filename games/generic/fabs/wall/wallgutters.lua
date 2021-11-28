PREFABS.Wall_wallgutters1 =
{
  file   = "wall/wallgutters.wad",
  map    = "MAP01",

  prob   = 50,
  env = "building",

  group = "wallgutters",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_wallgutters2 =
{
  template = "Wall_wallgutters1",

  map = "MAP02",
}

PREFABS.Wall_wallgutters_diag =
{
  file   = "wall/wallgutters.wad",
  map    = "MAP03",
  game = "!heretic",

  prob   = 50,
  group = "wallgutters",

  where  = "diagonal",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_wallgutters_diag_heretic =
{
  template = "Wall_wallgutters_diag",
  game = "heretic",
  forced_offsets =
  {
    [21] = { x=4, y=8 },
    [29] = { x=4, y=8 },
  }
}