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

  group = "gtd_comp_set_green_EPIC"

  height = 88,
  bound_z2 = 88
}

PREFABS.Wall_epic_comp_set_green_2 =
{
  template = "Wall_epic_comp_set_yellow_1",
  map = "MAP05",

  prob = 25,
  group = "gtd_comp_set_green_EPIC"

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
