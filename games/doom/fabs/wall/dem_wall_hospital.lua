PREFABS.Wall_hospital1 =
{
  file   = "wall/dem_wall_hospital.wad",
  map    = "MAP01",

rank = 1,

  prob   = 200,
  theme = "!hell",
  env    = "building",

  group = "dem_wall_hospital",

  texture_pack = "armaetus",

  on_liquids = "never",

  scenic_mode = "never",

  where  = "edge",
  height = 128,
  deep   = 20,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

}

PREFABS.Wall_hospital2 =
{
  template = "Wall_hospital1",
  map      = "MAP02",

  prob   = 20,

  deep   = 52,

}

PREFABS.Wall_hospital3 =
{
  template = "Wall_hospital1",
  map      = "MAP03",

  prob   = 20,

  deep   = 52,

}

PREFABS.Wall_hospital4 =
{
  template = "Wall_hospital1",
  map      = "MAP04",

  prob   = 20,

  deep   = 52,

}

