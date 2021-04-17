PREFABS.Wall_hell_mindscrew =
{
  file = "wall/gtd_wall_hell_mindscrew.wad",
  map = "MAP01",

  prob = 50,

  group = "gtd_wall_hell_mindscrew",

  where  = "edge",
  height = 128,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",
}

PREFABS.Wall_hell_mindscrew_diag =
{
  template = "Wall_hell_mindscrew",
  map    = "MAP02",

  where  = "diagonal",
}

--

PREFABS.Wall_hell_mindscrew_skywall =
{
  template = "Wall_hell_mindscrew",
  map = "MAP03",

  seed_w = 1,

  group = "gtd_wall_hell_mindscrew_skywall",

  x_fit = { 56,72 },
  z_fit = { 56,72 }
}
