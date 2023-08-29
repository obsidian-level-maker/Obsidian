PREFABS.Wall_tech_gothic_inset_gargoyle =
{
  file = "wall/gtd_wall_tech_gothic_EPIC_set.wad",
  map = "MAP01",

  prob = 15,

  group = "gtd_wall_tech_gothic_inset_gargoyle",

  where = "edge",
  deep = 16,
  height = 97,

  bound_z1 = 0,
  bound_z2 = 97,

  z_fit = "top"
}

PREFABS.Wall_tech_gothic_inset_gargoyle_diag =
{
  template = "Wall_tech_gothic_inset_gargoyle",
  map = "MAP02",

  where = "diagonal"
}

--

PREFABS.Wall_tech_gothic_inset_engine =
{
  template = "Wall_tech_gothic_inset_gargoyle",

  group = "gtd_wall_tech_gothic_inset_engine",

  tex_SD_GTLW1 = "SD_GTLW2",
  tex_SD_GTHW2 = "SD_GTHW3",
  tex_SD_GTHW8 = "SD_GTHW7"
}

PREFABS.Wall_tech_gothic_inset_engine_diag =
{
  template = "Wall_tech_gothic_inset_gargoyle",
  map = "MAP02",

  where = "diagonal",

  group = "gtd_wall_tech_gothic_inset_engine",

  tex_SD_GTLW1 = "SD_GTLW2",
  tex_SD_GTHW2 = "SD_GTHW3",
  tex_SD_GTHW8 = "SD_GTHW7"
}

--

PREFABS.Wall_tech_gothic_inset_red_lites =
{
  template = "Wall_tech_gothic_inset_gargoyle",
  map = "MAP03",

  group = "gtd_wall_tech_gothic_inset_red_lite",

  height = 105,

  bound_z2 = 105
}

PREFABS.Wall_tech_gothic_inset_red_cross =
{
  template = "Wall_tech_gothic_inset_gargoyle",
  map = "MAP04",
  prob = 3,

  group = "gtd_wall_tech_gothic_inset_red_lite",

  height = 105,

  bound_z2 = 105
}

PREFABS.Wall_tech_gothic_inset_red_lites_diag =
{
  template = "Wall_tech_gothic_inset_gargoyle",
  map = "MAP05",

  group = "gtd_wall_tech_gothic_inset_red_lite",

  where = "diagonal",

  height = 105,

  bound_z2 = 105
}
