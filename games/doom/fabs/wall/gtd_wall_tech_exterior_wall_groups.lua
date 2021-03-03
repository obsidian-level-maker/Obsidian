PREFABS.Wall_tech_outdoor_caution_strip = --#
{
  file   = "wall/gtd_wall_tech_exterior_wall_groups.wad",
  map    = "MAP01",

  prob   = 15,

  group = "tech_o_caution_strip",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = {24,32}
}

PREFABS.Wall_tech_outdoor_orange_light_stack = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map      = "MAP02",

  group = "tech_o_orange_light_stack",

  z_fit    = "stretch"
}

-- LITE strips

PREFABS.Wall_tech_outdoor_lite_strip_white = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map    = "MAP03",

  group = "tech_o_lite_strip_white",

  z_fit = "bottom"
}

PREFABS.Wall_tech_outdoor_lite_strip_blue = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map    = "MAP03",

  group = "tech_o_lite_strip_blue",

  z_fit = "bottom",

  tex_LITE3 = "LITEBLU4"
}

-- teklite inset

PREFABS.Wall_tech_outdoor_inset_teklite = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map      = "MAP04",

  group = "tech_o_inset_teklite",

  z_fit    = "top"
}

PREFABS.Wall_tech_outdoor_inset_teklite2 = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map      = "MAP04",

  group = "tech_o_inset_teklite2",

  tex_TEKLITE = "TEKLITE2",

  z_fit    = "top"
}

-- green light

PREFABS.Wall_tech_outdoor_halfbase_green_light = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map      = "MAP05",

  group = "tech_o_halfbase_green_light",

  z_fit    = {40,56}
}

PREFABS.Wall_tech_outdoor_halfbase_blue_triangle = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map      = "MAP05",

  group = "tech_o_halfbase_blue_triangle",

  tex_TEKGREN5 = "TEKGREN3",

  z_fit     = "top"
}

-- because you need to be constantly reminded how the UAC screwed everything up

PREFABS.Wall_tech_outdoor_giant_UAC_sign = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP06",

  group = "tech_o_giant_UAC_sign",

  z_fit = "bottom",

  tex_SHAWN1 =
  {
    SHAWN1 = 1,
    SHAWN2 = 3
  },

  sector_1 = { [0]=80, [1]=15 }
}

-- vents

PREFABS.Wall_tech_outdoor_double_hanging_vents = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP07",

  group = "tech_o_double_hanging_vents",

  tex_METAL2 =
  {
    METAL5 = 50,
    METAL3 = 10
  },

  z_fit = "bottom"
}

-- overhangs

PREFABS.Wall_tech_outdoor_overhanging_braced_vent = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP08",

  group = "tech_o_overhanging_braced_vent",

  height = 192,
  deep = 48,

  z_fit = { 48,56 },

  bound_z2 = 192
}

PREFABS.Wall_tech_outdoor_overhanging_lite_platform = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP09",

  group = "tech_o_overhanging_lite_platform",

  deep = 64,

  z_fit = { 12,20 }
}

PREFABS.Wall_tech_outdoor_pipe_junctions = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP10",

  group = "tech_o_pipe_junctions",

  height = 192,

  tex_PIPES =
  {
    PIPES = 15,
    TEKWALL6 = 50
  },

  z_fit = { 32,96 },

  bound_z2 = 192
}

PREFABS.Wall_tech_hadleys_hope_sort_of_wall = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP11",

  group = "tech_o_hadleys_hope",

  height = 192,

  deep = 64,

  engine = "zdoom",

  z_fit = "bottom",

  bound_z2 = 192
}

PREFABS.Wall_tech_overhanging_lights = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP12",

  group = "tech_o_overhanging_lights",

  deep = 64,

  engine = "zdoom",

  z_fit = "top"
}

PREFABS.Wall_outdoor_shiny_silver_overhang = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP13",

  group = "tech_o_shiny_silver_overhang",

  height = 160,
  deep = 80,

  tex_GRAYMET4 = "GRAY7",
  tex_GRAYMET3 = "METAL2",
  tex_SHAWN5 = "GRAY5",
  tex_MIDSPAC5 = "MIDSPACE",
  tex_COLLITE3 = "LITEBLU4",

  z_fit = "bottom",

  bound_z2 = 160
}

PREFABS.Wall_outdoor_shiny_silver_overhang_EPIC =
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP13",

  texture_pack = "armaetus",
  replaces = "Wall_outdoor_shiny_silver_overhang",

  group = "tech_o_shiny_silver_overhang",

  height = 160,
  deep = 80,

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

PREFABS.Wall_tech_caution_bracket_silver_scaffolding = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP14",

  group = "tech_o_silver_scaffolding",

  z_fit = { 56,72 },

  tex_SHAWVEN2 = "SILVER2",
  tex_SHAWN4 = "SHAWN2",
  tex_WARNSTEP = "METAL",
  flat_WARN2 = "CEIL5_2"
}

PREFABS.Wall_tech_caution_bracket_silver_scaffolding_EPIC =
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP14",

  group = "tech_o_silver_scaffolding",

  replaces = "Wall_tech_caution_bracket_silver_scaffolding",
  texture_pack = "armaetus",

  z_fit = { 56,72 }
}

PREFABS.Wall_tech_outdoor_concrete_brace = --#
{
  template = "Wall_tech_outdoor_caution_strip",

  map = "MAP15",

  engine = "zdoom",

  group = "tech_o_concrete_base",

  z_fit = { 0,32 , 48,56 }
}

PREFABS.Wall_tech_fence_lights_uac_thing = --#
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP16",

  texture_pack = "armaetus",

  group = "tech_o_fence_lights_uac_thing",

  z_fit = { 10,14 },

  tex_TEKGRDR = "TEKGREN2",
  tex_BROWN2 = "GRAY7",
  tex_FENCE2 = "MIDBARS1"
}

PREFABS.Wall_tech_fence_lights_uac_thing_EPIC =
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP16",

  replaces = "Wall_tech_fence_lights_uac_thing",
  texture_pack = "armaetus",

  group = "tech_o_fence_lights_uac_thing",

  z_fit = { 10,14 },

  tex_TEKGRDR =
  {
    TEKGRDR = 1,
    TEKGRBLU = 5
  }
}

PREFABS.Wall_tech_outdoor_tekgren_grates_thing = --#
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP17",

  group = "tech_o_tekgren_grates_thing",

  z_fit = "top",

  tex_FENCE3 = "MIDBARS3"
}

PREFABS.Wall_tech_outdoor_tekgren_grates_thing_EPIC =
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP17",

  group = "tech_o_tekgren_grates_thing",

  replaces = "Wall_tech_outdoor_tekgren_grates_thing",

  texture_pack = "armaetus",

  z_fit = "top"
}

PREFABS.Wall_tech_outdoor_black_mesa_overlook = -- #
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP18",

  engine = "zdoom",

  height = 192,

  deep = 64,

  group = "tech_o_black_mesa_overlook",

  z_fit = { 120,164 },

  bound_z2 = 192
}

PREFABS.Wall_tech_outdoor_black_mesa_overlook_EPIC =
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP18",

  engine = "zdoom",
  replaces = "Wall_tech_outdoor_black_mesa_overlook",

  height = 192,

  deep = 64,

  group = "tech_o_black_mesa_overlook",

  tex_COMPBLUE = "COLLITE3",

  z_fit = { 120,164 },

  bound_z2 = 192
}

PREFABS.Wall_tech_outdoor_compblue_tall_EPIC = --#
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP19",

  replaces = "Wall_tech_outdoor_compblue_tall",

  texture_pack = "armaetus",

  group = "tech_o_compblue_tall",

  z_fit = { 28,60 }
}

PREFABS.Wall_tech_outdoor_compblue_tall =
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP19",

  group = "tech_o_compblue_tall",

  tex_SILVBLU1 = "SHAWN2",

  z_fit = { 28,60 }
}

PREFABS.Wall_tech_outdoor_grey_metal_sloped_EPIC = --#
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP20",

  engine = "zdoom",

  texture_pack = "armaetus",

  replaces = "Wall_tech_outdoor_grey_metal_sloped",

  group = "tech_o_grey_metal_sloped",

  z_fit = { 20,68 }
}

PREFABS.Wall_tech_outdoor_grey_metal_sloped =
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP20",

  engine = "zdoom",

  group = "tech_o_grey_metal_sloped",

  z_fit = { 20,68 },

  tex_URBAN8 = "SHAWN2",
  tex_GRAYMET4 = "GRAY7",
  tex_BIGDOORC = "DOORSTOP"
}

PREFABS.Wall_tech_outdoor_tall_light = --#
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP21",

  group = "tech_o_tall_light",

  z_fit = "top"
}

PREFABS.Wall_tech_outdoor_tall_light_alt_color = --#
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP21",

  group = "tech_o_tall_light_alt",

  tex_COMPBLUE = "REDWALL",
  tex_CEIL4_3 = "FLOOR1_6",

  z_fit = "top"
}

PREFABS.Wall_hexagon_uac_spotlights = --#
{
  template = "Wall_tech_outdoor_caution_strip",
  map = "MAP22",

  texture_pack = "armaetus",

  group = "tech_o_hexagon_uac_spotlights",

  z_fit = { 64,72  }
}
