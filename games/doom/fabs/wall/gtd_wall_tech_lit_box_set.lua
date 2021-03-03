PREFABS.Wall_tech_lit_box_blue =
{
  file   = "wall/gtd_wall_tech_lit_box_set.wad",
  map    = "MAP01",

  prob   = 50,

  group = "gtd_wall_lit_box_blue",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = { 24,32 },
}

PREFABS.Wall_tech_lit_box_blue_diagonal =
{
  template   = "Wall_tech_lit_box_blue",
  map    = "MAP02",

  prob   = 50,

  group = "gtd_wall_lit_box_blue",

  where  = "diagonal",
}

PREFABS.Wall_tech_lit_box_red =
{
  template   = "Wall_tech_lit_box_blue",
  map    = "MAP03",

  prob   = 50,

  group = "gtd_wall_lit_box_red",
}

PREFABS.Wall_tech_lit_box_red_diagonal =
{
  template   = "Wall_tech_lit_box_blue",
  map    = "MAP04",

  prob   = 50,

  group = "gtd_wall_lit_box_red",

  where = "diagonal",
}

PREFABS.Wall_tech_lit_box_white =
{
  template   = "Wall_tech_lit_box_blue",
  map    = "MAP05",

  prob   = 50,

  group = "gtd_wall_lit_box_white",
}

PREFABS.Wall_tech_lit_box_white_diagonal =
{
  template   = "Wall_tech_lit_box_blue",
  map    = "MAP06",

  prob   = 50,

  group = "gtd_wall_lit_box_white",

  where  = "diagonal",
}
