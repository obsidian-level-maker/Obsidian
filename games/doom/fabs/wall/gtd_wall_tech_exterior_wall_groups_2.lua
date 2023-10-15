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

  tex_CITY06N = "BRONZE1"
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
  map = "MAP11",

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
  map = "MAP11",

  height = 120,
  port = "any",

  group = "tech_o_letter_G",

  z_fit = "top",

  tex_SDOM_WL2 = "PIPEWAL1"
}
