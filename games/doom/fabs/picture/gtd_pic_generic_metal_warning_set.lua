PREFABS.Pic_metal_warning_gate =
{
  file   = "picture/gtd_pic_generic_metal_warning_set.wad",
  map    = "MAP01",

  prob   = 50,
  theme = "!hell",

  group = "gtd_wall_metal_warning",

  texture_pack = "armaetus",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",
  z_fit = { 40,88 },
}

PREFABS.Pic_metal_warning_pillars =
{
  template = "Pic_metal_warning_gate",
  map = "MAP02",

  theme = "any",

  x_fit = { 40,56 , 104,152 , 200,216 },
}

PREFABS.Pic_metal_warning_lite5 =
{
  template = "Pic_metal_warning_gate",
  map = "MAP03",

  theme = "!hell",
}

PREFABS.Pic_metal_warning_lite5_hell =
{
  template = "Pic_metal_warning_gate",
  map = "MAP03",

  theme = "hell",

  tex_LITE5 = "RDWAL01",
}

--

PREFABS.Pic_metal_warning_bottom_comp =
{
  template = "Pic_metal_warning_gate",
  map = "MAP04",

  theme = "!hell",
  group = "gtd_wall_metal_warning_bottom",

  x_fit = "frame",
  z_fit = "top",

  tex_COMPSTA1 =
  {
    COMPSTA1 = 1,
    COMPSTA2 = 1,
    COMPSTA3 = 1,
    COMPSTA4 = 1,
    COMPSTA5 = 1,
    COMPSTA6 = 1,
    COMPSTA7 = 1,
    COMPSTA8 = 1,
    COMPSTA9 = 1,
    COMPSTAA = 1,
    COMPSTAB = 1
  }
}

PREFABS.Pic_metal_warning_bottom_comp_hell =
{
  template = "Pic_metal_warning_gate",
  map = "MAP05",

  rank = 1,
  theme = "hell",

  group = "gtd_wall_metal_warning_bottom"
}
