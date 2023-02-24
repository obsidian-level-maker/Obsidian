PREFABS.Pic_tech_comp_console_1 =
{
  file = "picture/gtd_pic_tech_comp_set.wad",
  map = "MAP01",

  prob = 5000,

  group = "gtd_computers",

  where = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = { 124,132 },
  y_fit = { 16,72 }
}

PREFABS.Pic_tech_comp_console_compshawn =
{
  template = "Pic_tech_comp_console_1",
  map = "MAP02",

  group = "gtd_computers_shawn",

  y_fit = { 20,108 }
}

PREFABS.Pic_tech_comp_console_compstation =
{
  template = "Pic_tech_comp_console_1",
  map = "MAP03",

  group = "gtd_computers_compsta",

  y_fit = { 20,108 },

  tex_COMPSTA3 =
  {
    COMPSTA3 = 1,
    COMPSTA4 = 1,
    COMPSTA5 = 1,
    COMPSTA6 = 1,
    COMPSTA7 = 1,
    COMPSTA8 = 1,
    COMPSTA9 = 1,
    COMPSTAA = 1,
    COMPSTAB = 1
  },

  tex_COMPSTA4 =
  {
    COMPSTA3 = 1,
    COMPSTA4 = 1,
    COMPSTA5 = 1,
    COMPSTA6 = 1,
    COMPSTA7 = 1,
    COMPSTA8 = 1,
    COMPSTA9 = 1,
    COMPSTAA = 1,
    COMPSTAB = 1
  },

  tex_COMPSTA5 =
  {
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
