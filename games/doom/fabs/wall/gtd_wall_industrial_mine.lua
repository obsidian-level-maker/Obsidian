PREFABS.Wall_mining_dirt_fenced =
{
  file = "wall/gtd_wall_industrial_mine.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_mining_set",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = { 24,26 },

  tex_STONE7 =
  {
    BSTONE1 = 1,
    STONE6 = 3,
    STONE7 = 3,
    ZIMMER5 = 1
  }
}

PREFABS.Wall_mining_dirt_fenced_diag =
{
  template = "Wall_mining_dirt_fenced",
  map = "MAP02",

  where = "diagonal"
}
