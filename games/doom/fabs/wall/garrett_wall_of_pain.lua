PREFABS.Wall_of_pain =
{
  file   = "wall/garrett_wall_of_pain.wad",
  map    = "MAP01",

  prob   = 20,
  theme  = "hell",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top"
}

PREFABS.Wall_of_pain_diagonal =
{
  template = "Wall_of_pain",
  map    = "MAP02",

  where  = "diagonal",
}
