PREFABS.Wall_sewer_plain =
{
  file   = "wall/gtd_wall_sewer_set.wad",
  map    = "MAP01",

  prob   = 75,
  theme  = "!hell",
  env = "building",

  group = "gtd_wall_sewer",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_sewer_sign =
{
  template = "Wall_sewer_plain",
  map = "MAP02",

  prob = 15,
}

PREFABS.Wall_sewer_sludgefall =
{
  template = "Wall_sewer_plain",
  map = "MAP03",

  deep = 32,

  prob = 15,

  sound = "Water_Streaming",
}

PREFABS.Wall_sewer_horizontal_pipes =
{
  template = "Wall_sewer_plain",
  map = "MAP04",

  prob = 15,
}

PREFABS.Wall_sewer_diagonal =
{
  file = "wall/gtd_wall_sewer_set.wad",
  map  = "MAP05",

  theme = "!hell",

  prob = 50,

  height = 128,

  group = "gtd_wall_sewer",
  where = "diagonal",

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",
}
