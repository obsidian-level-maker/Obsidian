PREFABS.Wall_tall_glass_EPIC_yellow =
{
  file   = "wall/gtd_wall_tall_glass_EPIC.wad",
  map    = "MAP01",

  prob   = 50,
  env = "building",

  group = "gtd_tall_glass_epic_yellow",

  where  = "edge",
  deep   = 16,
  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = "frame",
}

PREFABS.Wall_tall_glass_EPIC_yellow_diag =
{
  file   = "wall/gtd_wall_tall_glass_EPIC.wad",
  map    = "MAP02",

  prob   = 50,
  group = "gtd_tall_glass_epic_yellow",

  where  = "diagonal",

  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = "frame",
}

PREFABS.Wall_tall_glass_EPIC_orange =
{
  template = "Wall_tall_glass_EPIC_yellow",

  group = "gtd_tall_glass_epic_orange",

  tex_GLASS11 = "GLASS12",
}

PREFABS.Wall_tall_glass_EPIC_orange_diag =
{
  template = "Wall_tall_glass_EPIC_yellow_diag",

  group = "gtd_tall_glass_epic_orange",

  tex_GLASS11 = "GLASS12",
}

PREFABS.Wall_tall_glass_EPIC_red =
{
  template = "Wall_tall_glass_EPIC_yellow",

  group = "gtd_tall_glass_epic_red",

  tex_GLASS11 = "GLASS13",
}

PREFABS.Wall_tall_glass_EPIC_red_diag =
{
  template = "Wall_tall_glass_EPIC_yellow_diag",

  group = "gtd_tall_glass_epic_red",

  tex_GLASS11 = "GLASS13",
}

PREFABS.Wall_tall_glass_EPIC_blue =
{
  template = "Wall_tall_glass_EPIC_yellow",

  group = "gtd_tall_glass_epic_blue",

  tex_GLASS11 = "GLASS14",
}

PREFABS.Wall_tall_glass_EPIC_blue_diag =
{
  template = "Wall_tall_glass_EPIC_yellow_diag",

  group = "gtd_tall_glass_epic_blue",

  tex_GLASS11 = "GLASS14",
}
