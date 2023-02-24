PREFABS.Wall_of_guns_set_straight =
{
  file = "wall/gtd_wall_industrial_wall_of_guns_set_EPIC.wad",
  map = "MAP01",

  prob = 50,

  group = "gtd_wall_of_guns",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",

  tex_CRGNRCK1 =
  {
    CRGNRCK1 = 1,
    CRGNRCK2 = 5,
    CRGNRCK3 = 1
  },

  tex_SHAWN1 =
  {
    SHAWN1 = 5,
    SHAWN5 = 5
  }
}

PREFABS.Wall_of_guns_set_diag =
{
  template = "Wall_of_guns_set_straight",
  map = "MAP02",

  where = "diagonal"
}

--

PREFABS.Wall_of_guns_set_any =
{
  template = "Wall_of_guns_set_straight",

  prob = 15,

  stop_group = "yes",
}
