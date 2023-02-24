PREFABS.Wall_armaetus_glass_huge_red =
{
  file   = "wall/armaetus_glass_wall_EPIC_set.wad",
  map    = "MAP01",

  prob   = 50,
  env = "building",

  group = "gtd_tall_glass_epic_red",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "frame",
}

PREFABS.Wall_armaetus_glass_huge_red_diag =
{
  file   = "wall/armaetus_glass_wall_EPIC_set.wad",
  map    = "MAP02",

  prob   = 50,
  group = "gtd_tall_glass_epic_red",

  where  = "diagonal",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "frame",
}

PREFABS.Wall_armaetus_glass_huge_orange =
{
  template = "Wall_armaetus_glass_huge_red",

  prob     = 15,

  group    = "gtd_tall_glass_epic_orange",

  tex_GLASS1 = "GLASS6",
}

PREFABS.Wall_armaetus_glass_huge_orange_diag =
{
  template = "Wall_armaetus_glass_huge_red_diag",

  prob     = 15,

  group    = "gtd_tall_glass_epic_orange",

  tex_GLASS1 = "GLASS6",
}

PREFABS.Wall_armaetus_glass_huge_blue =
{
  template = "Wall_armaetus_glass_huge_red",

  prob     = 15,

  group    = "gtd_tall_glass_epic_blue",

  tex_GLASS1 = "GLASS2",
}

PREFABS.Wall_armaetus_glass_huge_blue_diag =
{
  template = "Wall_armaetus_glass_huge_red_diag",

  prob     = 15,

  group    = "gtd_tall_glass_epic_blue",

  tex_GLASS1 = "GLASS2",
}
