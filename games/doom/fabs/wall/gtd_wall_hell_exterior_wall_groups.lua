PREFABS.Wall_hell_stone_brace = --#
{
  file   = "wall/gtd_wall_hell_exterior_wall_groups.wad",
  map    = "MAP01",

  prob   = 15,
  env = "outdoor",

  group = "hell_o_stone_brace",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "bottom",

  tex_STONE3 = "STONE2",
}

PREFABS.Wall_hell_wood_brace = --#
{
  template = "Wall_hell_stone_brace",

  group = "hell_o_wood_brace",

  tex_STONE2 = "WOODMET2",
  tex_STONE3 = "WOODMET1",
  flat_FLAT1 = "CEIL5_1",
}

PREFABS.Wall_hell_metal_framed_skin = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP02",

  group = "hell_o_metal_framed_skin",

  tex_SKINEDGE =
  {
    SKINEDGE = 50,
    SKSNAKE2 = 50,
    SKSPINE1 = 7,
    SKSPINE2 = 7,
    SKSNAKE1 = 7,
  },

  z_fit = "stretch",
}

PREFABS.Wall_hell_caged_up_corpses = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP03",

  group = "hell_o_caged_up_corpses",

  tex_SLOPPY1 =
  {
    SLOPPY1 = 50,
    SLOPPY2 = 50,
  },
  tex_WOODMET4 =
  {
    WOODMET3 = 50,
    WOODMET4 = 50,
  },

  z_fit = "top",
}

PREFABS.Wall_hell_giant_stone_faces = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP04",

  height = 192,

  group = "hell_o_giant_stone_faces",

  tex_MARBFAC2 =
  {
    MARBFAC2 = 50,
    MARBFAC3 = 50,
  },

  z_fit = { 8,56 },

  bound_z2 = 192,
}

PREFABS.Wall_hell_giant_stone_faces_EPIC =
{
  template = "Wall_hell_stone_brace",
  map = "MAP04",

  height = 192,

  group = "hell_o_giant_stone_faces",

  texture_pack = "armaetus",

  replaces = "Wall_hell_giant_stone_faces",

  tex_MARBFAC2 =
  {
    MARBFAC2 = 50,
    MARBFAC3 = 50,
    MARBFAC6 = 50,
    MARBFAC7 = 50,
    MARBFACF = 50,
  },

  z_fit = { 8,56 },

  bound_z2 = 192,
}

PREFABS.Wall_hell_outdoor_rising_spfaces = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP05",

  engine = "zdoom",

  group = "hell_o_rising_spfaces",

  z_fit = "top",
}

PREFABS.Wall_hell_outdoor_lava_falls = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP06",

  group = "hell_o_lava_falls",

  on_scenics = "never",

  tex_FIREMAG1 =
  {
    FIREMAG1 = 15,
    SLADWALL = 50,
    SLADSKULL = 15,
  },

  z_fit = { 48,72 },
}

PREFABS.Wall_hell_outdoor_huge_overhang = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP07",

  group = "hell_o_huge_overhang",

  deep = 48,

  z_fit = { 20,52 },
}

PREFABS.Wall_hell_outdoor_spiny_overhang = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP08",

  group = "hell_o_spiny_overhang",

  deep = 64,

  z_fit = { 32,96 },
}

PREFABS.Wall_hell_outdoor_red_glass_tall = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP09",

  height = 192,

  group = "hell_o_red_glass_tall",

  tex_GOTH19 = "METAL2",
  tex_GOTH20 = "METAL2",
  tex_GOTH21 = "BRONZE1",
  tex_GOTH36 = "BRONZE1",
  tex_GLASS13 = "REDWALL",

  z_fit = { 40,120 },

  bound_z2 = 192,
}

PREFABS.Wall_hell_outdoor_red_glass_tall_EPIC =
{
  template = "Wall_hell_stone_brace",
  map = "MAP09",

  height = 192,

  group = "hell_o_red_glass_tall",

  texture_pack = "armaetus",

  replaces = "Wall_hell_outdoor_red_glass_tall",

  z_fit = { 40,120 },

  bound_z2 = 192,
}

PREFABS.Wall_hell_outdoor_rising_energy = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP10",

  height = 192,

  group = "hell_o_rising_energy",

  z_fit = { 136,186 },

  bound_z2 = 192,
}

PREFABS.Wall_hell_outdoor_rising_energy_EPIC =
{
  template = "Wall_hell_stone_brace",
  map = "MAP10",

  texture_pack = "armaetus",

  height = 192,

  group = "hell_o_rising_energy",

  replaces = "Wall_hell_outdoor_rising_energy",

  tex_FIREBLU1 = "RDWAL01",
  tex_MARBFAC4 =
  {
    MARBF01 = 50,
    MARBF02 = 50,
    MARBF03 = 50,
  },

  z_fit = { 136,186 },

  bound_z2 = 192,
}

PREFABS.Wall_hell_wooden_palisades = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP11",

  group = "hell_o_wooden_palisades",

  tex_WOODMET3 =
  {
    WOODMET1 = 50,
    WOODMET3 = 10,
    WOODMET4 = 10,
  },
  tex_WOOD10 =
  {
    WOOD5 = 5,
    WOOD6 = 5,
    WOOD7 = 5,
    WOOD8 = 5,
    WOOD9 = 5,
    WOOD10 = 5,
  },

  z_fit = "top",
}

PREFABS.Wall_gothic_flying_alcoves = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP12",

  group = "hell_o_flying_alcoves",

  deep = 64,

  z_fit = "top",
}


PREFABS.Wall_gothic_flying_alcoves_EPIC =
{
  template = "Wall_hell_stone_brace",
  map = "MAP12",

  group = "hell_o_flying_alcoves",

  replaces = "Wall_gothic_flying_alcoves",
  texture_pack = "armaetus",

  deep = 64,

  tex_MIDBRN1 ="MIDWIND7",

  z_fit = "top",
}

PREFABS.Wall_hell_outdoor_torch_fenced = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP13",

  group = "hell_o_torch_fenced",

  z_fit = { 28,32 },

  tex_FENCE4 = "ZZWOLF10",
  tex_METL02 = "METAL",
}

PREFABS.Wall_hell_outdoor_torch_fenced_EPIC =
{
  template = "Wall_hell_stone_brace",
  map = "MAP13",

  replaces = "Wall_hell_outdoor_torch_fenced",
  texture_pack = "armaetus",

  group = "hell_o_torch_fenced",

  tex_FENCE4 = "FENCE4",
  tex_METL02 = "METL02",

  z_fit = { 28,32 },
}

PREFABS.Wall_hell_outdoor_dark_banners = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP14",

  height = 160,
  deep = 56,

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

PREFABS.Wall_hell_outdoor_dark_banners_EPIC =
{
  template = "Wall_hell_stone_brace",
  map = "MAP14",

  replaces = "Wall_hell_outdoor_dark_banners",
  texture_pack = "armaetus",

  group = "hell_o_dark_banners",

  height = 160,
  deep = 56,

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

PREFABS.Wall_hell_dark_cathedral_windows =
{
  template = "Wall_hell_stone_brace",
  map = "MAP15",

  group = "hell_o_dark_cathedral_windows",

  height = 256,

  z_fit = "bottom",

  tex_CITY08 = "BLAKWAL1",
  tex_BRIKS43 = "BRONZE1",
  tex_BRIKS11 = "METAL2",
  tex_KSTGARG = "SUPPORT3",
  flat_CEIL5_1 = "CEIL5_2",

  bound_z2 = 256,
}

PREFABS.Wall_hell_dark_cathedral_windows_EPIC = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP15",

  replaces = "Wall_hell_dark_cathedral_windows",
  texture_pack = "armaetus",

  group = "hell_o_dark_cathedral_windows",

  height = 256,

  z_fit = "bottom",

  bound_z2 = 256,
}

PREFABS.Wall_hell_extruded_arch = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP16",

  group = "hell_o_extruded_arch",

  z_fit = { 40,48 },
}

PREFABS.Wall_hell_gothic_skin_red_EPIC = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP17",

  texture_pack = "armaetus",

  group = "hell_o_gothic_skin_red",

  z_fit = { 36,60 },
}

PREFABS.Wall_hell_marb_icon_bfalls_EPIC = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP18",

  texture_pack = "armaetus",

  group = "hell_o_marb_icon_bfalls",

  z_fit = { 54,58 },
}

PREFABS.Wall_hell_marb_icon_bfalls_EPIC_alt = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP18",

  prob = 25,

  texture_pack = "armaetus",

  group = "hell_o_marb_icon_bfalls",

  z_fit = { 54,58 },

  tex_ICONMRB1 = "MARBLE4",
  tex_BFALL1 = "MARBLE",
  flat_BLOOD1 = "FLOOR7_2",
}

PREFABS.Wall_hell_egyptish_EPIC = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP19",

  texture_pack = "armaetus",

  replaces = "Wall_hell_egyptish",

  group = "hell_o_egyptish",

  tex_MURAL12 =
  {
    MURAL12 = 5,
    DESBRIK6 = 1,
  },

  z_fit = "top",
}

PREFABS.Wall_hell_egyptish =
{
  template = "Wall_hell_stone_brace",
  map = "MAP19",

  group = "hell_o_egyptish",

  tex_DESBRIK3 = "BSTONE2",
  tex_DESMARB2 = "BSTONE2",
  tex_MURAL12 = "BSTONE2",

  z_fit = "top",
}

PREFABS.Wall_hell_blood_ocatgon = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP20",

  group = "hell_o_blood_ocatgon",

  z_fit = "top",
}

PREFABS.Wall_hell_catamet = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP21",

  texture_pack = "armaetus",
  replaces = "Wall_hell_catamet_vanilla",

  group = "hell_o_catamet",

  z_fit = { 40,48 },
}

PREFABS.Wall_hell_catamet_vanilla =
{
  template = "Wall_hell_stone_brace",

  map = "MAP21",

  group = "hell_o_catamet",

  tex_BRIKS41 = "BRICK7",
  tex_METL03 = "SUPPORT3",
  tex_CATACMB5 = "BRWINDOW",

  z_fit = { 40,48 },
}

PREFABS.Wall_hell_crematorium_windows = --#
{
  template = "Wall_hell_stone_brace",
  map = "MAP22",

  group = "hell_o_crematorium_windows",

  z_fit = "bottom",
}
