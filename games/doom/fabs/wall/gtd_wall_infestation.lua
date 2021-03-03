--
-- Fancy walls
--

PREFABS.Wall_infestation_guts_on_wall =
{
  file   = "wall/gtd_wall_infestation.wad",
  map    = "MAP01",

  prob   = 1.5,
  env   = "building",
  game  = "doom2",

  on_liquids = "never",

  where  = "edge",
  height = 128,
  deep   = 48,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",
}

PREFABS.Wall_infestation_guts_on_wall_DOOM1 =
{
  template   = "Wall_infestation_guts_on_wall",
  game  = "doom",
  thing_81 = "gibs",
}

PREFABS.Wall_infestation_guts_flowing_down_wall =
{
  file   = "wall/gtd_wall_infestation.wad",
  map    = "MAP02",
  game   = "doom2",

  prob   = 1.5,
  env   = "building",

  on_liquids = "never",

  where  = "edge",
  height = 128,
  deep   = 48,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",
}

PREFABS.Wall_infestation_guts_flowing_down_wall_DOOM1 =
{
  template   = "Wall_infestation_guts_flowing_down_wall",
  game       = "doom",
  thing_79 = "gibs",
 }

PREFABS.Wall_infestation_evil_shrine_eye =
{
  file   = "wall/gtd_wall_infestation.wad",
  map    = "MAP03",

  prob   = 1,
  env   = "building",

  on_liquids = "never",

  where  = "edge",
  height = 128,
  deep   = 64,
  seed_w = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",
}

PREFABS.Wall_infestation_evil_shrine_rune =
{
  file   = "wall/gtd_wall_infestation.wad",
  map    = "MAP04",

  prob   = 1,
  env   = "building",

  on_liquids = "never",

  where  = "edge",
  height = 128,
  deep   = 64,
  seed_w = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",
}
