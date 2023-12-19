PREFABS.Wall_tech_outdoor_hex_inset = --#
{
  file   = "wall/gtd_wall_tech_exterior_wall_groups_2.wad",
  map    = "MAP01",

  prob   = 15,

  group = "tech_o_hex_inset",
  port = "zdoom",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top"
}

PREFABS.Wall_tech_outdoor_grated_greenwall = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP02",

  port = "any",

  group = "tech_o_grated_greenwall",

  tex_PIPEWAL1 =
  {
    PIPEWAL1 = 1,
    PIPEWAL2 = 5
  }
}

PREFABS.Wall_tech_outdoor_sewer_hatches = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP03",

  port = "any",

  group = "tech_o_everyone_likes_sewers",

  texture_pack = "armaetus",

  tex_SLADRIP1 =
  {
    SLADRIP1 = 1,
    NUKESLAD = 5
  },

  scenic_mode = "never"
}

PREFABS.Wall_tech_outdoor_red_wall = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP04",

  group = "tech_o_red_wall",

  tex_SHAWN3 =
  {
    SHAWN3 = 1,
    EXITDOOR = 3
  }
}

PREFABS.Wall_tech_outdoor_blue_wall = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP04",

  group = "tech_o_blue_wall",

  tex_SHAWN3 =
  {
    SHAWN3 = 1,
    EXITDOOR = 3
  },

  tex_REDWALL = "COMPBLUE"
}

PREFABS.Wall_tech_outdoor_lots_of_cement = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP05",

  port = "any",

  group = "tech_o_lots_of_cement"
}

PREFABS.Wall_tech_outdoor_letter_A_tekgreen = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP06",

  height = 128,

  port = "any",

  group = "tech_o_letter_A",

  z_fit = { 38,39 , 121,122 }
}

PREFABS.Wall_tech_outdoor_letter_B = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP07",

  height = 120,

  port = "any",
  rank = 1,
  texture_pack = "armaetus",

  group = "tech_o_letter_B",

  z_fit = "top"
}

PREFABS.Wall_tech_outdoor_letter_B_compat =
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP07",

  height = 120,

  port = "any",

  group = "tech_o_letter_B",

  tex_COLLITE3 = "COMPBLUE",

  z_fit = "top"
}

PREFABS.Wall_tech_outdoor_letter_C = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP08",

  height = 104,

  port = "any",
  rank = 1,
  texture_pack = "armaetus",

  group = "tech_o_letter_C",

  z_fit = {30,31 , 73,74},
}

PREFABS.Wall_tech_outdoor_letter_C_compat =
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP08",

  height = 104,

  port = "any",

  group = "tech_o_letter_C",

  z_fit = {12,14 , 58,60},

  tex_SHAWN10E = "SHAWN2"
}

PREFABS.Wall_tech_outdoor_letter_D = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP09",

  height = 104,

  rank = 1,
  port = "any",
  texture_pack = "armaetus",

  group = "tech_o_letter_D",

  z_fit = {7,8 , 96,97},

  tex_CITY06N =
  {
    CITY06N = 5,
    CITY05N = 1, 
  }
}

PREFABS.Wall_tech_outdoor_letter_D_compat =
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP09",

  height = 104,

  port = "any",

  group = "tech_o_letter_D",

  z_fit = {7,8 , 96,97},

  tex_CITY06N = "BRONZE1",
  tex_METAL8 = "METAL"
}

PREFABS.Wall_tech_outdoor_letter_E = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP10",

  height = 128,
  port = "any",

  group = "tech_o_letter_E",

  z_fit = "stretch"
}

PREFABS.Wall_tech_outdoor_letter_F = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP11",

  height = 120,
  port = "any",

  group = "tech_o_letter_F",

  z_fit = { 39,40 , 88,89 },
  tex_CRATE2 = 
  {
    CRATE1 = 1,
    CRATE2 = 5
  }
}

PREFABS.Wall_tech_outdoor_letter_G = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP12",

  rank = 1,
  texture_pack = "armaetus",
  height = 120,
  port = "any",

  group = "tech_o_letter_G",

  z_fit = "top"
}

PREFABS.Wall_tech_outdoor_letter_G_compat =
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP12",

  height = 120,
  port = "any",

  group = "tech_o_letter_G",

  z_fit = "top",

  tex_SDOM_WL2 = "PIPEWAL1"
}

PREFABS.Wall_tech_outdoor_letter_H = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP13",

  height = 96,
  group = "tech_o_letter_H",

  bound_z2 = 96,

  z_fit = {23,24 , 64,66}
}

PREFABS.Wall_tech_outdoor_letter_I = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP14",

  height = 96,
  group = "tech_o_letter_I",

  bound_z2 = 96,

  z_fit = { 24,73 }
}

PREFABS.Wall_tech_outdoor_letter_J = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP15",

  height = 96,
  group = "tech_o_letter_J",

  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_tech_outdoor_letter_K_epic = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP16",

  rank = 2,
  height = 96,
  group = "tech_o_letter_K",

  texture_pack = "armaetus",

  bound_z2 = 96,

  z_fit = {26,27}
}

PREFABS.Wall_tech_outdoor_letter_K_compat =
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP16",

  rank = 1,
  height = 96,
  group = "tech_o_letter_K",

  bound_z2 = 96,

  z_fit = {26,27},

  flat_BMARB1 = "CEIL5_1",
  tex_BRONZEG1 = "BRONZE3",
  tex_BRONZEG3 = "BRONZE3",
  tex_DARKMET1 = "BRONZE3",
  tex_RDWAL01 = "SUPPORT2",

  line_340 = 0,
  line_341 = 0
}

PREFABS.Wall_tech_outdoor_letter_L_epic = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP17",

  rank = 2,
  height = 96,
  group = "tech_o_letter_L",

  texture_pack = "armaetus",

  bound_z2 = 96,

  z_fit = {63,64 , 65,66}
}

PREFABS.Wall_tech_outdoor_letter_L_compat =
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP17",

  rank = 1,
  height = 96,
  group = "tech_o_letter_L",

  bound_z2 = 96,

  z_fit = {63,64 , 65,66},

  tex_LITESTON = "STONE2"
}

PREFABS.Wall_tech_outdoor_letter_M = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP18",

  rank = 2,
  height = 96,
  group = "tech_o_letter_M",

  texture_pack = "armaetus",

  bound_z2 = 96,

  z_fit = {70,72 , 80,81}
}

PREFABS.Wall_tech_outdoor_letter_M = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP18",

  rank = 1,
  height = 96,
  group = "tech_o_letter_M",

  bound_z2 = 96,

  z_fit = {70,72 , 80,81},

  tex_PIPESV1 = "SUPPORT3",
  tex_SHAWSH04 = "SHAWN2",
  tex_COMPRED = "REDWALL",

  line_344 = 0
}

PREFABS.Wall_tech_outdoor_letter_N = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP19",

  height = 128,
  group = "tech_o_letter_N",

  bound_z2 = 128,

  z_fit = {48, 49}
}

PREFABS.Wall_tech_outdoor_letter_N_compat =
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP19",

  engine = "!zdoom",
  height = 128,
  group = "tech_o_letter_N",

  bound_z2 = 128,

  z_fit = {48, 49},

  line_281 = 0,
  line_345 = 0
}

PREFABS.Wall_tech_outdoor_letter_O = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP20",

  height = 128,
  group = "tech_o_letter_O",

  bound_z2 = 128,

  z_fit = {34, 36}
}

PREFABS.Wall_tech_outdoor_letter_O_compat =
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP20",

  engine = "!zdoom",
  height = 128,
  group = "tech_o_letter_O",

  bound_z2 = 128,

  z_fit = {34, 36},

  line_281 = 0
}

PREFABS.Wall_tech_outdoor_letter_P = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP21",

  rank = 2,
  texture_pack = "armaetus",
  height = 96,
  group = "tech_o_letter_P",

  bound_z2 = 96,

  z_fit = {30, 32 , 47,48}
}

PREFABS.Wall_tech_outdoor_letter_P_compat = 
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP21",

  rank = 1,
  height = 96,
  group = "tech_o_letter_P",

  bound_z2 = 96,

  z_fit = {30, 32 , 47,48},

  tex_URBAN8 = "GRAY7",
  tex_PIPESV1 = "GRAY5",
  tex_SHASH04 = "GRAY7",

  line_345 = 0
}

PREFABS.Wall_tech_outdoor_letter_Q = --#
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP22",

  texture_pack = "armaetus",
  rank = 2,
  height = 96,
  group = "tech_o_letter_Q",

  bound_z2 = 96,
  tex_RDLITE01 = 
  {
    RDLITE01 = 1,
    GRAY7 = 5
  },

  z_fit = {23,24 , 26,28 , 72,73}
}

PREFABS.Wall_tech_outdoor_letter_Q_compat =
{
  template = "Wall_tech_outdoor_hex_inset",
  map = "MAP22",

  rank = 1,
  height = 96,
  group = "tech_o_letter_Q",

  bound_z2 = 96,

  z_fit = {23,24 , 26,28 , 72,73},
  tex_RDLITE01 =
  {
    REDWALL = 1,
    GRAY7 = 5
  },
  tex_GOTH41 = "BROWN144",

  line_345 = 0
}
