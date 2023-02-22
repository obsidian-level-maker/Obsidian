PREFABS.Wall_armaetus_catacomb_straight =
{
  file   = "wall/armaetus_catacomb_set.wad",
  map    = "MAP01",
  theme  = "hell",

  prob   = 50,
  env = "building",

  texture_pack = "armaetus",

  group = "armaetus_catacomb_wall_set",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "frame",

  tex_CATACMB1 = { CATACMB1=50, CATACMB4=50 },
}

PREFABS.Wall_armaetus_catacomb_diagonal =
{
  template = "Wall_armaetus_catacomb_straight",
  theme = "hell",

  map      = "MAP02",

  where    = "diagonal",

  tex_CATACMB1 = { CATACMB1=50, CATACMB4=50 },
}

-- Brown catacombs

PREFABS.Wall_armaetus_catacomb_brown =
{
  template = "Wall_armaetus_catacomb_straight",
  theme = "hell",
  group = "armaetus_catacombs_brown",

  map      = "MAP01",

  tex_CATACMB1 = "CATACMB4",
}

PREFABS.Wall_armaetus_catacomb_brown_diagonal =
{
  template = "Wall_armaetus_catacomb_straight",
  theme = "hell",
  group = "armaetus_catacombs_brown",

  map      = "MAP02",

  where = "diagonal",

  tex_CATACMB1 = "CATACMB4",
}
