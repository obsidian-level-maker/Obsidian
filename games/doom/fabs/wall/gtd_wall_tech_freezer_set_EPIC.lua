PREFABS.Wall_tech_freezer_1 =
{
  file = "wall/gtd_wall_tech_freezer_set_EPIC.wad",
  map = "MAP01",

  prob = 15,

  group = "gtd_wall_tech_freezer",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  tex_BIGDOORF =
  {
    BIGDOORF = 20,
    BIGDOORD = 50
  },

  z_fit = "top"
}

PREFABS.Wall_tech_freezer_2 =
{
  template = "Wall_tech_freezer_1",
  map = "MAP02",

  prob = 50
}

PREFABS.Wall_tech_freezer_diag =
{
  template = "Wall_tech_freezer_1",
  map = "MAP03",

  where = "diagonal"
}
