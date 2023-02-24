PREFABS.Wall_hell_square_brace =
{
  file   = "wall/gtd_wall_hell_exterior.wad",
  map    = "MAP01",

  prob   = 50,
  theme = "!tech",

  env = "outdoor",

  where  = "edge",
  height = 128,

  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 24,88 },
}

PREFABS.Wall_hell_square_brace_double =
{
  template = "Wall_hell_square_brace",
  map = "MAP02",
}

PREFABS.Wall_hell_square_brace_arched =
{
  template = "Wall_hell_square_brace",
  map = "MAP03",

  z_fit = { 8,64 },
}
