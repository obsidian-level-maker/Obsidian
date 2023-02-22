--
-- Tech outdoor walls
--

PREFABS.Wall_tech_outdoor_accent_flat_plain =
{
  file   = "wall/gtd_wall_tech_exterior_1.wad",
  map    = "MAP01",

  prob   = 35,
  env   = "!building",
  theme = "tech",

  where  = "edge",
  height = 128,

  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "bottom",
}

PREFABS.Wall_tech_outdoor_accent_flat_piped =
{
  template = "Wall_tech_outdoor_accent_flat_plain",
  map      = "MAP02",

  prob = 10,

  tex_METAL4 =
  {
    METAL1 = 1,
    METAL3 = 4,
    METAL4 = 4,
    METAL5 = 4,
  },

  z_fit = { 24,88 },
}

PREFABS.Wall_tech_top_electric_board_thing =
{
  template = "Wall_tech_outdoor_accent_flat_plain",
  map    = "MAP03",

  prob = 5,

  z_fit = "bottom",

  tex_COMPTALL =
  {
    METAL3 = 1,
    COMPTALL = 1,
    COMPSPAN = 3,
  },
}

PREFABS.Wall_tech_top_vanilla_vents =
{
  template = "Wall_tech_outdoor_accent_flat_plain",
  map    = "MAP04",

  prob = 5,

  z_fit = "bottom",

  tex_METAL5 =
  {
    METAL5 = 4,
    BLAKWAL2 = 1,
  },
}

PREFABS.Wall_tech_bottom_vent =
{
  template = "Wall_tech_outdoor_accent_flat_plain",
  map = "MAP05",

  prob = 10,

  z_fit = "top",

  tex_COMPWERD =
  {
    COMPTALL = 1,
    COMPWERD = 1,
    METAL5 = 2,
  },
}

PREFABS.Wall_tech_single_brace =
{
  template = "Wall_tech_outdoor_accent_flat_plain",
  map    = "MAP06",

  prob = 35,

  z_fit = "frame",

  can_flip = true,
}

PREFABS.Wall_tech_top_metal =
{
  template = "Wall_tech_outdoor_accent_flat_plain",
  map = "MAP07",

  prob = 20,

  z_fit = "bottom",

  tex_METAL2 =
  {
    METAL2 = 5,
    METAL3 = 1,
    METAL5 = 2,
  },
}

PREFABS.Wall_tech_bottom_metal_half =
{
  template = "Wall_tech_outdoor_accent_flat_plain",
  map = "MAP08",

  prob = 8,

  z_fit = "top",

  tex_METAL2 =
  {
    METAL2 = 4,
    METAL3 = 1,
    METAL5 = 1,
    COMPWERD = 1,
  },
}
