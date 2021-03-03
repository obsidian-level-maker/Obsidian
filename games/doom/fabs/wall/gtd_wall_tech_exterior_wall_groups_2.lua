PREFABS.Wall_tech_outdoor_hex_inset = --#
{
  file   = "wall/gtd_wall_tech_exterior_wall_groups_2.wad",
  map    = "MAP01",

  prob   = 15,

  group = "tech_o_hex_inset",
  engine = "zdoom",

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

  engine = "any",

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

  engine = "any",

  group = "tech_o_everyone_likes_sewers",

  texture_pack = "armaetus",

  tex_SLADRIP1 =
  {
    SLADRIP1 = 1,
    NUKESLAD = 5
  },

  on_scenics = "never"
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

  engine = "any",

  group = "tech_o_lots_of_cement"
}
