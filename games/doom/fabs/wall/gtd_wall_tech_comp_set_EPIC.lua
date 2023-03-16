-- these more consistent-looking wall sets are intended to 
-- replace the overly colorful COMPTIL room themes for Tech
-- from the Obsidian resource pack (currently being done gradually)

PREFABS.Wall_epic_comp_set_yellow_1 =
{
  file = "wall/gtd_wall_tech_comp_set_EPIC.wad",
  map = "MAP01",

  prob = 50,

  group = "gtd_comp_set_yellow_EPIC",

  where  = "edge",
  height = 64,
  deep = 16,

  bound_z1 = 0,
  bound_z2 = 64,

  z_fit = "top"
}

PREFABS.Wall_epic_comp_set_yellow_2 =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP02",

  prob = 25,

  tex_COMPSTA3 =
  {
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

PREFABS.Wall_epic_comp_set_yellow_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP03",

  where = "diagonal"
}

-- green

PREFABS.Wall_epic_comp_set_green_1 =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP04",

  group = "gtd_comp_set_green_EPIC",

  height = 88,
  bound_z2 = 88
}

PREFABS.Wall_epic_comp_set_green_2 =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP05",

  prob = 25,
  group = "gtd_comp_set_green_EPIC",

  height = 88,
  bound_z2 = 88,

  tex_COMPU1 =
  {
    COMPU1=1,
    COMPU2=1,
    COMPU3=1,
    COMPVENT=1,
    COMPVEN2=1
  }
}

PREFABS.Wall_epic_comp_set_green_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP06",

  where = "diagonal",

  group = "gtd_comp_set_green_EPIC",

  height = 88,
  bound_z2 = 88
}

--

PREFABS.Wall_epic_comp_set_red_1 =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP07",

  group = "gtd_comp_set_red_EPIC",

  height = 88,
  bound_z2 = 88,

  z_fit = { 10,22 }
}

PREFABS.Wall_epic_comp_set_red_2 =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP08",

  prob = 25,
  group = "gtd_comp_set_red_EPIC",

  tex_COMPSTA1 =
  {
    COMPSTA1 = 5,
    COMPSTA2 = 5,
    COMPSTA3 = 5,
    COMPSTA4 = 5,
    COMPSTA5 = 5,
    COMPSTA6 = 5,
    COMPSTA7 = 5,
    COMPSTA8 = 5,
    COMPSTA9 = 5,
    COMPSTAA = 5,
  },

  height = 88,
  bound_z2 = 88,

  z_fit = { 10,22 }
}

PREFABS.Wall_epic_comp_set_red_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP09",

  where = "diagonal",

  group = "gtd_comp_set_red_EPIC",

  height = 88,
  bound_z2 = 88,

  z_fit = { 10,22 }
}

--
-- plain
--

PREFABS.Wall_epic_comptil_plain_red =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP50",

  height = 96,
  bound_z2 = 96,

  group = "gtd_comptil_plain_red",

  z_fit = { 34,36 }
}

PREFABS.Wall_epic_comptil_plain_red_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP51",

  height = 96,
  where = "diagonal",
  bound_z2 = 96,

  group = "gtd_comptil_plain_red",

  z_fit = { 34,36 }
}

--

PREFABS.Wall_epic_comptil_plain_green =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP50",

  height = 96,
  bound_z2 = 96,

  group = "gtd_comptil_plain_green",

  tex_COMPTIL2 = "COMPTIL4",

  z_fit = { 34,36 }
}

PREFABS.Wall_epic_comptil_plain_green_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP51",

  height = 96,
  where = "diagonal",
  bound_z2 = 96,

  group = "gtd_comptil_plain_green",

  tex_COMPTIL2 = "COMPTIL4",

  z_fit = { 34,36 }
}

--

PREFABS.Wall_epic_comptil_plain_yellow =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP50",

  height = 96,
  bound_z2 = 96,

  group = "gtd_comptil_plain_yellow",

  tex_COMPTIL2 = "COMPTIL5",

  z_fit = { 34,36 }
}

PREFABS.Wall_epic_comptil_plain_yellow_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP51",

  height = 96,
  where = "diagonal",
  bound_z2 = 96,

  group = "gtd_comptil_plain_yellow",

  tex_COMPTIL2 = "COMPTIL5",

  z_fit = { 34,36 }
}

--

PREFABS.Wall_epic_comptil_plain_purple =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP50",

  height = 96,
  bound_z2 = 96,

  group = "gtd_comptil_plain_purple",

  tex_COMPTIL2 = "COMPTIL6",

  z_fit = { 34,36 }
}

PREFABS.Wall_epic_comptil_plain_purple_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP51",

  height = 96,
  where = "diagonal",
  bound_z2 = 96,

  group = "gtd_comptil_plain_purple",

  tex_COMPTIL2 = "COMPTIL6",

  z_fit = { 34,36 }
}

--

PREFABS.Wall_epic_comptil_plain_blue =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP50",

  height = 96,
  bound_z2 = 96,

  group = "gtd_comptil_plain_blue",

  tex_COMPTIL2 = "CMPTILE",

  z_fit = { 34,36 }
}

PREFABS.Wall_epic_comptil_plain_blue_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP51",

  height = 96,
  where = "diagonal",
  bound_z2 = 96,

  group = "gtd_comptil_plain_blue",

  tex_COMPTIL2 = "CMPTILE",

  z_fit = { 34,36 }
}

--
--
--

PREFABS.Wall_epic_comptil_lite_red =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP52",

  height = 96,
  bound_z2 = 96,

  group = "gtd_comptil_lite_red",

  tex_METAL4 =
  {
    METAL4 = 5,
    METAL2 = 8
  },

  z_fit = { 72,80 }
}

PREFABS.Wall_epic_comptil_lite_red_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP53",

  height = 96,
  where = "diagonal",

  group = "gtd_comptil_lite_red",

  tex_METAL4 =
  {
    METAL4 = 5,
    METAL2 = 8
  },

  bound_z2 = 96,
  z_fit = { 72,80 }
}

--

PREFABS.Wall_epic_comptil_lite_green =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP52",

  height = 96,
  bound_z2 = 96,

  group = "gtd_comptil_lite_green",

  tex_METAL4 =
  {
    METAL4 = 5,
    METAL2 = 8
  },

  tex_COMPTIL2 = "COMPTIL4",
  tex_COMPRED = "COMPGREN",
  tex_T_VSLTER = "T_VSLTEG",

  z_fit = { 72,80 }
}

PREFABS.Wall_epic_comptil_lite_green_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP53",

  height = 96,
  where = "diagonal",

  group = "gtd_comptil_lite_green",

  tex_METAL4 =
  {
    METAL4 = 5,
    METAL2 = 8
  },

  tex_COMPTIL2 = "COMPTIL4",
  tex_COMPRED = "COMPGREN",
  tex_T_VSLTER = "T_VSLTEG",

  bound_z2 = 96,
  z_fit = { 72,80 }
}

--

PREFABS.Wall_epic_comptil_lite_yellow =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP52",

  height = 96,
  bound_z2 = 96,

  group = "gtd_comptil_lite_yellow",

  tex_METAL4 =
  {
    METAL4 = 5,
    METAL2 = 8
  },

  tex_COMPTIL2 = "COMPTIL5",
  tex_COMPRED = "COMPYELL",
  tex_T_VSLTER = "T_VSLTEY",

  z_fit = { 72,80 }
}

PREFABS.Wall_epic_comptil_lite_yellow_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP53",

  height = 96,
  where = "diagonal",

  group = "gtd_comptil_lite_yellow",

  tex_METAL4 =
  {
    METAL4 = 5,
    METAL2 = 8
  },

  tex_COMPTIL2 = "COMPTIL5",
  tex_COMPRED = "COMPYELL",
  tex_T_VSLTER = "T_VSLTEY",

  bound_z2 = 96,
  z_fit = { 72,80 }
}

--

PREFABS.Wall_epic_comptil_lite_purple =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP52",

  height = 96,
  bound_z2 = 96,

  group = "gtd_comptil_lite_purple",

  tex_METAL4 =
  {
    METAL4 = 5,
    METAL2 = 8
  },

  tex_COMPTIL2 = "COMPTIL6",
  tex_COMPRED = "COMPBLAK",
  tex_T_VSLTER = "T_VSLTEP",

  z_fit = { 72,80 }
}

PREFABS.Wall_epic_comptil_lite_purple_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP53",

  height = 96,
  where = "diagonal",

  group = "gtd_comptil_lite_purple",

  tex_METAL4 =
  {
    METAL4 = 5,
    METAL2 = 8
  },

  tex_COMPTIL2 = "COMPTIL6",
  tex_COMPRED = "COMPBLAK",
  tex_T_VSLTER = "T_VSLTEP",

  bound_z2 = 96,
  z_fit = { 72,80 }
}

--

PREFABS.Wall_epic_comptil_lite_blue =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP52",

  height = 96,
  bound_z2 = 96,

  group = "gtd_comptil_lite_blue",

  tex_METAL4 =
  {
    METAL4 = 5,
    METAL2 = 8
  },

  tex_COMPTIL2 = "CMPTILE",
  tex_COMPRED = "COMPBLUE",
  tex_T_VSLTER = "LITEBLU4",

  z_fit = { 72,80 }
}

PREFABS.Wall_epic_comptil_lite_blue_diag =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP53",

  height = 96,
  where = "diagonal",

  group = "gtd_comptil_lite_blue",

  tex_METAL4 =
  {
    METAL4 = 5,
    METAL2 = 8
  },

  tex_COMPTIL2 = "CMPTILE",
  tex_COMPRED = "COMPBLUE",
  tex_T_VSLTER = "LITEBLU4",

  bound_z2 = 96,
  z_fit = { 72,80 }
}

--

PREFABS.Wall_epic_graymet_blue =
{
  file = "wall/gtd_wall_tech_comp_set_EPIC.wad",
  map = "MAP54",

  prob = 50,
  rank = 2,

  group = "gtd_comp_graymet_blue",

  where  = "edge",
  height = 160,
  deep = 16,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit = "bottom"
}

PREFABS.Wall_epic_graymet_blue_short =
{
  template = "Wall_epic_graymet_blue",
  map = "MAP55",

  prob = 1,

  height = 96,
  bound_z2 = 96,

  rank = 1
}

--

PREFABS.Wall_epic_graymet_green =
{
  template = "Wall_epic_graymet_blue",
  map = "MAP54",

  group = "gtd_comp_graymet_green",

  tex_GRAYMET6 = "GRAYMET8"
}

PREFABS.Wall_epic_graymet_green_short =
{
  template = "Wall_epic_graymet_blue",
  map = "MAP55",

  rank = 1,
  prob = 1,

  height = 96,
  bound_z2 = 96,

  group = "gtd_comp_graymet_green",

  tex_GRAYMET6 = "GRAYMET8"
}

--

PREFABS.Wall_epic_graymet_red =
{
  template = "Wall_epic_graymet_blue",
  map = "MAP54",

  group = "gtd_comp_graymet_red",

  tex_GRAYMET6 = "GRAYMET9"
}

PREFABS.Wall_epic_graymet_red_short =
{
  template = "Wall_epic_graymet_blue",
  map = "MAP55",

  rank = 1,
  prob = 1,

  height = 96,
  bound_z2 = 96,

  group = "gtd_comp_graymet_red",

  tex_GRAYMET6 = "GRAYMET9"
}

--

PREFABS.Wall_epic_graymet_orange =
{
  template = "Wall_epic_graymet_blue",
  map = "MAP54",

  group = "gtd_comp_graymet_orange",

  tex_GRAYMET6 = "GRAYMETC"
}

PREFABS.Wall_epic_graymet_orange_short =
{
  template = "Wall_epic_graymet_blue",
  map = "MAP55",

  rank = 1,
  prob = 1,

  height = 96,
  bound_z2 = 96,

  group = "gtd_comp_graymet_orange",

  tex_GRAYMET6 = "GRAYMETC"
}

--

PREFABS.Wall_epic_graymet_purple =
{
  template = "Wall_epic_graymet_blue",
  map = "MAP54",

  group = "gtd_comp_graymet_purple",

  tex_GRAYMET6 = "GRAYMET7"
}

PREFABS.Wall_epic_graymet_purple_short =
{
  template = "Wall_epic_graymet_blue",
  map = "MAP55",

  rank = 1,
  prob = 1,

  height = 96,
  bound_z2 = 96,

  group = "gtd_comp_graymet_purple",

  tex_GRAYMET6 = "GRAYMET7"
}

--

PREFABS.Wall_epic_comp_set_grntek_blue =
{
  file = "wall/gtd_wall_tech_comp_set_EPIC.wad",
  map = "MAP56",

  prob = 50,

  group = "gtd_comp_grntek_blue",

  where  = "edge",
  height = 120,
  deep = 16,

  bound_z1 = 0,
  bound_z2 = 120,

  z_fit = "top"
}

PREFABS.Wall_epic_comp_set_grntek_blue_diag =
{
  template = "Wall_epic_comp_set_grntek_blue",
  map = "MAP57",

  where = "diagonal",

  group = "gtd_comp_grntek_blue",
}
