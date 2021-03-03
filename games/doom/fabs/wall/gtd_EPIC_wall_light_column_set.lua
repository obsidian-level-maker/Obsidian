-- GREEN version

PREFABS.Wall_epic_collite_inset_straight_green =
{
  file   = "wall/gtd_EPIC_wall_light_column_set.wad",
  map    = "MAP01",

  prob   = 50,
  theme  = "!tech",

  group = "gtd_collite_set_green",

  texture_pack = "armaetus",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = { 64-8,64+8 },
}

PREFABS.Wall_epic_collite_inset_diagonal_green =
{
  file   = "wall/gtd_EPIC_wall_light_column_set.wad",
  map    = "MAP02",

  prob   = 50,
  theme  = "!tech",

  group = "gtd_collite_set_green",

  texture_pack = "armaetus",

  where  = "diagonal",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = { 64-8,64+8 },
}

-- tech variant

PREFABS.Wall_epic_collite_inset_straight_green_tech =
{
  template = "Wall_epic_collite_inset_straight_green",

  theme = "tech",

  group = "gtd_collite_set_green",

  tex_SUPPORT3 = "DOORSTOP",
  tex_STEPTOP = "STEP4",
  flat_CEIL5_2 = "FLAT23",
}

PREFABS.Wall_epic_collite_inset_diagonal_green_tech =
{
  template = "Wall_epic_collite_inset_diagonal_green",

  theme = "tech",

  group = "gtd_collite_set_green",

  tex_SUPPORT3 = "DOORSTOP",
  tex_STEPTOP = "STEP4",
  flat_CEIL5_2 = "FLAT23",
}

-- ORANGE version

PREFABS.Wall_epic_collite_inset_straight_orange =
{
  template = "Wall_epic_collite_inset_straight_green",

  group = "gtd_collite_set_orange",

  tex_COLLITE1= "COLLITE2",
}

PREFABS.Wall_epic_collite_inset_diagonal_orange =
{
  template = "Wall_epic_collite_inset_diagonal_green",

  group = "gtd_collite_set_orange",

  tex_COLLITE1= "COLLITE2",
}

-- tech variant

PREFABS.Wall_epic_collite_inset_straight_orange_tech =
{
  template = "Wall_epic_collite_inset_straight_green",

  theme = "tech",

  group = "gtd_collite_set_orange",

  tex_COLLITE1= "COLLITE2",
  tex_SUPPORT3 = "DOORSTOP",
  tex_STEPTOP = "STEP4",
  flat_CEIL5_2 = "FLAT23",
}

PREFABS.Wall_epic_collite_inset_diagonal_orange_tech =
{
  template = "Wall_epic_collite_inset_diagonal_green",

  theme = "tech",

  group = "gtd_collite_set_orange",

  tex_COLLITE1= "COLLITE2",
  tex_SUPPORT3 = "DOORSTOP",
  tex_STEPTOP = "STEP4",
  flat_CEIL5_2 = "FLAT23",
}

-- BLUE version

PREFABS.Wall_epic_collite_inset_straight_blue =
{
  template = "Wall_epic_collite_inset_straight_green",

  group = "gtd_collite_set_blue",

  tex_COLLITE1= "COLLITE3",
}

PREFABS.Wall_epic_collite_inset_diagonal_blue =
{
  template = "Wall_epic_collite_inset_diagonal_green",

  group = "gtd_collite_set_blue",

  tex_COLLITE1= "COLLITE3",
}

-- tech

PREFABS.Wall_epic_collite_inset_straight_blue_tech =
{
  template = "Wall_epic_collite_inset_straight_green",

  theme = "tech",

  group = "gtd_collite_set_blue",

  tex_COLLITE1= "COLLITE3",
  tex_SUPPORT3 = "DOORSTOP",
  tex_STEPTOP = "STEP4",
  flat_CEIL5_2 = "FLAT23",
}

PREFABS.Wall_epic_collite_inset_diagonal_blue_tech =
{
  template = "Wall_epic_collite_inset_diagonal_green",

  theme = "tech",

  group = "gtd_collite_set_blue",

  tex_COLLITE1= "COLLITE3",
  tex_SUPPORT3 = "DOORSTOP",
  tex_STEPTOP = "STEP4",
  flat_CEIL5_2 = "FLAT23",
}

-- RED version

PREFABS.Wall_epic_collite_inset_straight_red =
{
  template = "Wall_epic_collite_inset_straight_green",

  group = "gtd_collite_set_red",

  tex_COLLITE1= "RDWAL01",
}

PREFABS.Wall_epic_collite_inset_diagonal_red =
{
  template = "Wall_epic_collite_inset_diagonal_green",

  group = "gtd_collite_set_red",

  tex_COLLITE1= "RDWAL01",
}

PREFABS.Wall_epic_collite_inset_straight_red_tech =
{
  template = "Wall_epic_collite_inset_straight_green",

  theme = "tech",

  group = "gtd_collite_set_red",

  tex_COLLITE1= "RDWAL01",
  tex_SUPPORT3 = "DOORSTOP",
  tex_STEPTOP = "STEP4",
  flat_CEIL5_2 = "FLAT23",
}

PREFABS.Wall_epic_collite_inset_diagonal_red_tech =
{
  template = "Wall_epic_collite_inset_diagonal_green",

  theme = "tech",

  group = "gtd_collite_set_red",

  tex_COLLITE1= "RDWAL01",
  tex_SUPPORT3 = "DOORSTOP",
  tex_STEPTOP = "STEP4",
  flat_CEIL5_2 = "FLAT23",
}
