PREFABS.Wall_hell_ossuary_wall_plain =
{
  file = "wall/gtd_wall_hell_ossuary_set.wad",
  map = "MAP01",

  prob = 50,
  env = "building",

  group = "gtd_wall_hell_ossuary",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",
}

PREFABS.Wall_hell_ossuary_wall_diag =
{
  template = "Wall_hell_ossuary_wall_plain",
  map = "MAP02",

  where = "diagonal"
}
