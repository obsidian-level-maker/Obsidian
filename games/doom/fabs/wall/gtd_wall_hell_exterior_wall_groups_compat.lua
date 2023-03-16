PREFABS.Wall_hell_outdoor_huge_overhang_thin = --#
{
  file = "wall/gtd_wall_hell_exterior_wall_groups_compat.wad",
  map = "MAP07",

  group = "hell_o_huge_overhang",

  rank = 1,
  prob = 15,

  where = "edge",
  height = 128,
  deep = 16,

  z_fit = { 20,52 },

  bound_z1 = 0,
  bound_z2 = 128
}

PREFABS.Wall_hell_outdoor_spiny_overhang_thin = --#
{
  template = "Wall_hell_outdoor_huge_overhang_thin",
  map = "MAP08",

  group = "hell_o_spiny_overhang",

  z_fit = { 32,96 },
}

PREFABS.Wall_gothic_flying_alcoves_thin = --#
{
  template = "Wall_hell_outdoor_huge_overhang_thin",
  map = "MAP12",

  group = "hell_o_spiny_overhang",

  z_fit = { 32,96 },

}

PREFABS.Wall_gothic_flying_alcoves_thin = --#
{
  template = "Wall_hell_outdoor_huge_overhang_thin",
  map = "MAP12",

  rank = 1,
  group = "hell_o_flying_alcoves",

  z_fit = "top",
}

PREFABS.Wall_gothic_flying_alcoves_EPIC_thin =
{
  template = "Wall_hell_outdoor_huge_overhang_thin",
  map = "MAP12",

  rank = 1,
  group = "hell_o_flying_alcoves",

  replaces = "Wall_gothic_flying_alcoves_thin",
  texture_pack = "armaetus",

  tex_MIDBRN1 ="MIDWIND7",

  z_fit = "top",
}

PREFABS.Wall_hell_outdoor_dark_banners_thin = --#
{
  template = "Wall_hell_outdoor_huge_overhang_thin",
  map = "MAP14",

  rank = 1,
  height = 160,

  group = "hell_o_dark_banners",

  z_fit = { 16,24 },

  tex_METL03 = "METAL",
  tex_EVILFAC3 =
  {
    GSTGARG = 1,
    GSTLION = 1,
    GSTSATYR = 1,
  },

  bound_z2 = 160,
}

PREFABS.Wall_hell_outdoor_dark_banners_EPIC_thin =
{
  template = "Wall_hell_outdoor_huge_overhang_thin",
  map = "MAP14",

  rank = 1,
  replaces = "Wall_hell_outdoor_dark_banners_thin",
  texture_pack = "armaetus",

  group = "hell_o_dark_banners",

  height = 160,

  tex_METL03 = "METL03",
  tex_EVILFAC3 =
  {
    EVILFAC3 = 1,
    GOTH50 = 1,
    RUSTWAL3 = 1,
    RUSTWAL4 = 1,
    SW1QUAK = 1,
  },

  z_fit = { 16,24 },

  bound_z2 = 160,
}
