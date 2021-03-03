-- GREEN version

PREFABS.Wall_epic_churchy_glass_1 =
{
  file   = "wall/gtd_wall_churchy_glass_EPIC_set.wad",
  map    = "MAP01",

  prob   = 20,

  group = "gtd_wall_churchy_glass",

  texture_pack = "armaetus",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "bottom",
}

PREFABS.Wall_epic_churchy_glass_2 =
{
  template = "Wall_epic_churchy_glass_1",
  map = "MAP02",

  prob = 20,
}

PREFABS.Wall_epic_churchy_glass_plain =
{
  template = "Wall_epic_churchy_glass_1",
  map = "MAP03",

  prob = 50,
}

PREFABS.Wall_epic_churchy_glass_diagonal =
{
  file   = "wall/gtd_wall_churchy_glass_EPIC_set.wad",
  map    = "MAP04",

  prob   = 50,

  group = "gtd_wall_churchy_glass",

  texture_pack = "armaetus",

  where  = "diagonal",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "bottom",
}
