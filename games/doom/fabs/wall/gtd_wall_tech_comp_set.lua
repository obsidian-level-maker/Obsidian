PREFABS.Wall_gtd_computer_wall_1 =
{
  file   = "wall/gtd_wall_tech_comp_set.wad",
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
  file   = "wall/gtd_wall_tech_comp_set.wad",
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

--

PREFABS.Wall_gtd_computer_lite5_1 =
{
  template = "Wall_gtd_computer_wall_1",
  map = "MAP08",

  prob = 100,

  height = 96,
  group = "gtd_computers_lite5",

  bound_z2 = 96,

  sector_1 = {[0] = 10, [1] = 1, [3] = 1, [21] = 1},

  forced_offsets =
  {
    [26] = {x=96, y=1}
  }
}

PREFABS.Wall_gtd_computer_lite5_2 =
{
  template = "Wall_gtd_computer_wall_1",
  map = "MAP08",

  height = 96,
  group = "gtd_computers_lite5",

  bound_z2 = 96,

  sector_1 = {[0] = 10, [1] = 1, [3] = 1, [21] = 1},

  forced_offsets =
  {
    [26] = {x=128, y=64}
  }
}

PREFABS.Wall_gtd_computer_lite5_3 =
{
  template = "Wall_gtd_computer_wall_1",
  map = "MAP08",

  height = 96,
  group = "gtd_computers_lite5",

  bound_z2 = 96,

  sector_1 = {[0] = 10, [1] = 1, [3] = 1, [21] = 1},

  forced_offsets =
  {
    [26] = {x=192, y=64}
  }
}

PREFABS.Wall_gtd_computer_lite5_4 =
{
  template = "Wall_gtd_computer_wall_1",
  map = "MAP08",

  height = 96,
  group = "gtd_computers_lite5",

  bound_z2 = 96,

  sector_1 = {[0] = 10, [1] = 1, [3] = 1, [21] = 1},

  forced_offsets =
  {
    [26] = {x=192, y=1}
  }
}

PREFABS.Wall_gtd_computer_lite5_diag =
{
  template = "Wall_gtd_computer_wall_1",
  map = "MAP09",

  where = "diagonal",

  height = 96,
  group = "gtd_computers_lite5",

  bound_z2 = 96,

  sector_1 = {[0] = 10, [1] = 1, [3] = 1, [21] = 1}
}

--

PREFABS.Wall_gtd_computer_blue_shawn =
{
  template = "Wall_gtd_computer_wall_1",
  map = "MAP10",

  height = 112,
  group = "gtd_computers_blue_shawn",

  bound_z2 = 112
}

PREFABS.Wall_gtd_computer_blue_shawn_2 =
{
  template = "Wall_gtd_computer_wall_1",
  map = "MAP11",

  height = 112,
  group = "gtd_computers_blue_shawn",

  bound_z2 = 112
}

PREFABS.Wall_gtd_computer_blue_shawn_diag =
{
  template = "Wall_gtd_computer_wall_1",
  map = "MAP12",

  where = "diagonal",
  height = 112,
  group = "gtd_computers_blue_shawn",

  bound_z2 = 112
}
