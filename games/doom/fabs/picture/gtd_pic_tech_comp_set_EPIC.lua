PREFABS.Pic_tech_comp_set_1_red =
{
  file = "picture/gtd_pic_tech_comp_set_EPIC.wad",
  map = "MAP01",

  prob = 5000,

  group = "gtd_comptil_plain_red",

  where  = "seeds",
  height = 104,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 104,

  y_fit = "top",
  z_fit = { 90,94 },

  tex_COMPSTA1 =
  {
    COMPSTA1=1,
    COMPSTA2=1,
    COMPSTA3=1,
    COMPSTA4=1,
    COMPSTA5=1,
    COMPSTA6=1,
    COMPSTA7=1,
    COMPSTA8=1,
    COMPSTA9=1,
    COMPSTAA=1,
  }
}

PREFABS.Pic_tech_comp_set_2_red =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP02",

  seed_w = 3,

  x_fit = "frame",
}

--

PREFABS.Pic_tech_comp_set_1_green =
{
  template = "Pic_tech_comp_set_1_red",

  group = "gtd_comptil_plain_green",

  tex_COMPTIL2 = "COMPTIL4"
}

PREFABS.Pic_tech_comp_set_2_green =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP02",

  seed_w = 3,

  group = "gtd_comptil_plain_green",

  x_fit = "frame",

  tex_COMPTIL2 = "COMPTIL4"
}

--

PREFABS.Pic_tech_comp_set_1_yellow =
{
  template = "Pic_tech_comp_set_1_red",

  group = "gtd_comptil_plain_yellow",

  tex_COMPTIL2 = "COMPTIL5"
}

PREFABS.Pic_tech_comp_set_2_yellow =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP02",

  seed_w = 3,

  group = "gtd_comptil_plain_yellow",

  x_fit = "frame",

  tex_COMPTIL2 = "COMPTIL5"
}

--

PREFABS.Pic_tech_comp_set_1_purple =
{
  template = "Pic_tech_comp_set_1_red",

  group = "gtd_comptil_plain_purple",

  tex_COMPTIL2 = "COMPTIL6"
}

PREFABS.Pic_tech_comp_set_2_purple =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP02",

  seed_w = 3,

  group = "gtd_comptil_plain_purple",

  x_fit = "frame",

  tex_COMPTIL2 = "COMPTIL6"
}

--

PREFABS.Pic_tech_comp_set_1_blue =
{
  template = "Pic_tech_comp_set_1_red",

  group = "gtd_comptil_plain_blue",

  tex_COMPTIL2 = "CMPTILE"
}

PREFABS.Pic_tech_comp_set_2_blue =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP02",

  seed_w = 3,

  group = "gtd_comptil_plain_blue",

  x_fit = "frame",

  tex_COMPTIL2 = "CMPTILE"
}

--
--
--

PREFABS.Pic_tech_comptil_lite_red =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP03",

  seed_w = 2,

  group = " gtd_comptil_lite_red",

  x_fit = "frame",
  z_fit = "top"
}

PREFABS.Pic_tech_comptil_lite_red_2 =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP03",

  seed_w = 2,

  group = " gtd_comptil_lite_red",

  x_fit = "frame",
  z_fit = "top",

  forced_offsets =
  {
    [26] = {x=1, y=64}
  }
}

--

PREFABS.Pic_tech_comptil_lite_green =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP03",

  seed_w = 2,

  group = " gtd_comptil_lite_green",

  x_fit = "frame",
  z_fit = "top",

  tex_COMPTIL2 = "COMPTIL4",
  tex_COMPRED = "COMPGREN",
  tex_T_VSLTER = "T_VSLTEG",
}

PREFABS.Pic_tech_comptil_lite_green_2 =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP03",

  seed_w = 2,

  group = " gtd_comptil_lite_green",

  x_fit = "frame",
  z_fit = "top",

  forced_offsets =
  {
    [26] = {x=1, y=64}
  },

  tex_COMPTIL2 = "COMPTIL4",
  tex_COMPRED = "COMPGREN",
  tex_T_VSLTER = "T_VSLTEG",
}

--

PREFABS.Pic_tech_comptil_lite_yellow =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP03",

  seed_w = 2,

  group = " gtd_comptil_lite_yellow",

  x_fit = "frame",
  z_fit = "top",

  tex_COMPTIL2 = "COMPTIL5",
  tex_COMPRED = "COMPYELL",
  tex_T_VSLTER = "T_VSLTEY",
}

PREFABS.Pic_tech_comptil_lite_yellow_2 =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP03",

  seed_w = 2,

  group = " gtd_comptil_lite_yellow",

  x_fit = "frame",
  z_fit = "top",

  forced_offsets =
  {
    [26] = {x=1, y=64}
  },

  tex_COMPTIL2 = "COMPTIL5",
  tex_COMPRED = "COMPYELL",
  tex_T_VSLTER = "T_VSLTEY",
}

--

PREFABS.Pic_tech_comptil_lite_purple =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP03",

  seed_w = 2,

  group = "gtd_comptil_lite_purple",

  x_fit = "frame",
  z_fit = "top",

  tex_COMPTIL2 = "COMPTIL6",
  tex_COMPRED = "COMPBLAK",
  tex_T_VSLTER = "T_VSLTEP",
}

PREFABS.Pic_tech_comptil_lite_purple_2 =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP03",

  seed_w = 2,

  group = "gtd_comptil_lite_purple",

  x_fit = "frame",
  z_fit = "top",

  forced_offsets =
  {
    [26] = {x=1, y=64}
  },

  tex_COMPTIL2 = "COMPTIL6",
  tex_COMPRED = "COMPBLAK",
  tex_T_VSLTER = "T_VSLTEP",
}

--

PREFABS.Pic_tech_comptil_lite_blue =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP03",

  seed_w = 2,

  group = "gtd_comptil_lite_blue",

  x_fit = "frame",
  z_fit = "top",

  tex_COMPTIL2 = "CMPTILE",
  tex_COMPRED = "COMPBLUE",
  tex_T_VSLTER = "LITEBLU4",
}

PREFABS.Pic_tech_comptil_lite_blue_2 =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP03",

  seed_w = 2,

  group = "gtd_comptil_lite_blue",

  x_fit = "frame",
  z_fit = "top",

  forced_offsets =
  {
    [26] = {x=1, y=64}
  },

  tex_COMPTIL2 = "CMPTILE",
  tex_COMPRED = "COMPBLUE",
  tex_T_VSLTER = "LITEBLU4",
}

--

PREFABS.Pic_tech_grntek_blue =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP04",

  height = 112,

  seed_w = 2,

  group = "gtd_comp_grntek_blue",

  x_fit = "frame",
  z_fit = "top",

  bound_z2 = 112
}

--

PREFABS.Pic_gtd_yellow_comp_EPIC =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP05",

  height = 96,

  seed_w = 2,

  group = "gtd_comp_set_yellow_EPIC",

  x_fit = "frame",
  z_fit = "top",

  tex_COMPU1 =
  {
    COMPU1=50,
    COMPU2=50,
    COMPU3=50,
    COMPVENT=50,
    COMPVEN2 = 50
  },

  bound_z2 = 96
}

PREFABS.Pic_gtd_green_comp_EPIC =
{
  template = "Pic_tech_comp_set_1_red",
  map = "MAP06",

  height = 80,

  seed_w = 2,

  group = "gtd_comp_set_green_EPIC",

  x_fit = "frame",
  z_fit = "top",

  bound_z2 = 80,

  sector_1 =
  {
    [0]=10,
    [2]=1,
    [3]=1,
    [21]=1
  }
}
