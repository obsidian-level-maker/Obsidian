PREFABS.Wall_gtd_computer_wall_1 =
{
  file   = "wall/gtd_wall_comp_set.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "gtd_computers",

  where  = "edge",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_gtd_computer_wall_2 =
{
  template = "Wall_gtd_computer_wall_1",
  map      = "MAP02",
}

PREFABS.Wall_gtd_computer_wall_3 =
{
  template = "Wall_gtd_computer_wall_1",
  map      = "MAP03",
}

PREFABS.Wall_gtd_computer_diag_1 =
{
  file   = "wall/gtd_wall_comp_set.wad",
  map    = "MAP04",

  prob   = 50,
  group  = "gtd_computers",

  where  = "diagonal",

  deep   = 16,

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_gtd_computer_diag_2 =
{
  template = "Wall_gtd_computer_diag_1",
  map      = "MAP05",
}

-- EPIC version using silver computers

PREFABS.Wall_gtd_computer_silver_1 =
{
  template = "Wall_gtd_computer_wall_1",
  map = "MAP02",

  group = "gtd_computers_shawn",

  tex_COMPTALL =
  {
    SHAWCOMP = 50,
    SILVCOMP = 50,
    CONSOLE4 = 50,
  },
}

PREFABS.Wall_gtd_computer_silver_diag_1 =
{
  template = "Wall_gtd_computer_diag_1",
  map = "MAP04",

  group = "gtd_computers_shawn",

  tex_COMPTALL = "SHAWCOMP",
}

PREFABS.Wall_gtd_computer_silver_diag_2 =
{
  template = "Wall_gtd_computer_diag_1",
  map = "MAP05",

  group = "gtd_computers_shawn",

  tex_COMPTALL = "SHAWCOMP",
}

-- EPIC versions using compstation textures

PREFABS.Wall_gtd_computer_compsta_1 =
{
  template = "Wall_gtd_computer_wall_1",
  map = "MAP02",

  group = "gtd_computers_compsta",

  tex_COMPTALL =
  {
    COMPSTA3 = 1,
    COMPSTA4 = 1,
    COMPSTA5 = 1,
    COMPSTA6 = 1,
    COMPSTA7 = 1,
    COMPSTA8 = 1,
    COMPSTA9 = 1,
    COMPSTAA = 1,
    COMPSTAB = 1,
  },
}

PREFABS.Wall_gtd_computer_compsta_diag_1 =
{
  template = "Wall_gtd_computer_diag_1",
  map = "MAP04",

  group = "gtd_computers_compsta",

  tex_COMPTALL = "SHAWCOMP",
}

PREFABS.Wall_gtd_computer_compsta_diag_2 =
{
  template = "Wall_gtd_computer_diag_1",
  map = "MAP05",

  group = "gtd_computers_compsta",

  tex_COMPTALL = "SHAWCOMP",
}
