-- overhangs

PREFABS.Wall_tech_outdoor_overhanging_braced_vent_thin = --#
{
  file = "wall/gtd_wall_tech_exterior_wall_groups_compat.wad",
  map = "MAP08",


  prob = 15,
  group = "tech_o_overhanging_braced_vent",

  where  = "edge",
  height = 128,
  deep = 16,

  z_fit = { 34,48 },

  bound_z1 = 0,
  bound_z2 = 128
}

PREFABS.Wall_tech_outdoor_overhanging_lite_platform_thin = --#
{
  template = "Wall_tech_outdoor_overhanging_braced_vent_thin",
  map = "MAP09",


  group = "tech_o_overhanging_lite_platform",

  z_fit = { 12,20 }
}

PREFABS.Wall_tech_hadleys_hope_sort_of_wall_thin = --#
{
  template = "Wall_tech_outdoor_overhanging_braced_vent_thin",
  map = "MAP11",


  group = "tech_o_hadleys_hope",

  z_fit = "bottom",
}

PREFABS.Wall_tech_overhanging_lights_thin = --#
{
  template = "Wall_tech_outdoor_overhanging_braced_vent_thin",
  map = "MAP12",


  group = "tech_o_overhanging_lights",

  z_fit = "top"
}

PREFABS.Wall_outdoor_shiny_silver_overhang_thin = --#
{
  template = "Wall_tech_outdoor_overhanging_braced_vent_thin",
  map = "MAP13",


  group = "tech_o_shiny_silver_overhang",

  height = 160,

  tex_GRAYMET4 = "GRAY7",
  tex_GRAYMET3 = "METAL2",
  tex_SHAWN5 = "GRAY5",
  tex_MIDSPAC5 = "MIDSPACE",
  tex_COLLITE3 = "LITEBLU4",

  z_fit = "bottom",

  bound_z2 = 160
}

PREFABS.Wall_outdoor_shiny_silver_overhang_EPIC_thin =
{
  template = "Wall_tech_outdoor_overhanging_braced_vent_thin",
  map = "MAP13",

  texture_pack = "armaetus",
  replaces = "Wall_outdoor_shiny_silver_overhang_thin",


  group = "tech_o_shiny_silver_overhang",

  height = 160,

  tex_GRAYMET4 =
  {
    GRAYMET4 = 50,
    GRAYMET2 = 8
  },
  tex_GRAYMET3 = "GRAYMET3",
  tex_SHAWN5 = "SHAWN5",
  tex_MIDSPAC5 = "MIDSPAC5",
  tex_COLLITE3 = "COLLITE3",

  z_fit = "bottom",

  bound_z2 = 160
}

PREFABS.Wall_tech_outdoor_black_mesa_overlook_thin = -- #
{
  template = "Wall_tech_outdoor_overhanging_braced_vent_thin",
  map = "MAP18",


  height = 192,

  deep = 64,

  group = "tech_o_black_mesa_overlook",

  z_fit = { 120,164 },

  bound_z2 = 192
}
