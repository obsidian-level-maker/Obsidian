-- Bodies in the wall

PREFABS.Wall_epic_wallbodies =
{
  file   = "wall/gtd_EPIC_wall_light_column_set.wad",
  map    = "MAP01",

  prob   = 50,
  theme  = "hell",

  group = "armaetus_wallbodies",

  texture_pack = "armaetus",

  tex_COLLITE1 = "BODIES1",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = { 64-8,64+8 },
}

PREFABS.Wall_epic_wallbodies_diagonal =
{
  file   = "wall/gtd_EPIC_wall_light_column_set.wad",
  map    = "MAP02",

  prob   = 50,
  theme  = "hell",

  group = "armaetus_wallbodies",

  texture_pack = "armaetus",

  tex_COLLITE1 = "BODIES1",

  where  = "diagonal",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = { 64-8,64+8 },
}

-- BLOODY version

PREFABS.Wall_epic_wallbodies2 =
{
  template = "Wall_epic_wallbodies",

  group = "armaetus_wallbodies_bloody",

  tex_COLLITE1 = "BODIESB",
}

PREFABS.Wall_epic_wallbodies_diagonal2 =
{
  template = "Wall_epic_wallbodies",

  group = "armaetus_wallbodies_bloody",

  tex_COLLITE1 = "BODIESB",
}

-- OLD version

PREFABS.Wall_epic_wallbodies3 =
{
  template = "Wall_epic_wallbodies",

  group = "armaetus_wallbodies_old",

  tex_COLLITE1 = "BODIESC",
}

PREFABS.Wall_epic_wallbodies_diagonal3 =
{
  template = "Wall_epic_wallbodies",

  group = "armaetus_wallbodies_old",

  tex_COLLITE1 = "BODIESC",
}

-- BONES version

PREFABS.Wall_epic_wallbodies4 =
{
  template = "Wall_epic_wallbodies",

  group = "armaetus_wallbodies_bones",

  tex_COLLITE1 = "BONES3",
}

PREFABS.Wall_epic_wallbodies_diagonal4 =
{
  template = "Wall_epic_wallbodies",

  group = "armaetus_wallbodies_bones",

  tex_COLLITE1 = "BONES3",
}
