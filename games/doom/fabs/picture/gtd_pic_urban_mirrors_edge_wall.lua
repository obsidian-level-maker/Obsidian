-- plain single colored wall inspired by Mirror's Edge interior design

PREFABS.Pic_urban_mirrors_edge_wall =
{
  file   = "picture/gtd_pic_urban_mirrors_edge_wall.wad",
  map    = "MAP01",

  prob   = 150,
  theme = "urban",

  env = "building",

  where  = "seeds",

  height = 96,

  seed_w = 1,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 96,

  deep   =  16,

  x_fit = { 32,96 },
  y_fit = "top",

  tex_REDWALL =
  {
    COMPBLUE = 50,
    REDWALL = 50,
  },
}

PREFABS.Pic_urban_mirrors_edge_wall_EPIC =
{
  file   = "picture/gtd_pic_urban_mirrors_edge_wall.wad",
  map    = "MAP01",

  prob   = 150,
  theme = "urban",

  env = "building",

  texture_pack = "armaetus",
  replaces = "Pic_urban_mirrors_edge_wall",

  where  = "seeds",

  height = 96,

  seed_w = 1,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 96,

  deep   =  16,

  x_fit = { 32,96 },
  y_fit = "top",

  tex_REDWALL =
  {
    COMPBLUE = 50,
    COMPGREN = 50,
    COMPRED = 50,
    COMPBLAK = 20,
    COLLITE1 = 50,
    COLLITE2 = 50,
    COLLITE3 = 50,
    RDWAL01 = 35,

    TEKWALL8 = 20,
    TEKWALL9 = 20,
    TEKWALLA = 20,
    TEKWALLB = 20,
    TEKWALLC = 20,
    TEKWALLD = 20,
    TEKWALLE = 20,
  },
}
