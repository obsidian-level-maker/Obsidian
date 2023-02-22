PREFABS.Pic_indust_wall_of_guns_1 =
{
  file = "picture/gtd_pic_industrial_wall_of_guns_set_EPIC.wad",
  map = "MAP01",

  prob = 12,
  skip_prob = 50,

  theme = "!hell",
  env = "building",

  texture_pack = "armaetus",

  where = "seeds",
  height = 96,

  seed_h = 1,
  seed_w = 2,

  bound_z1 = 0,
  bound_z2 = 96,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Pic_indust_wall_of_guns_2 =
{
  template = "Pic_indust_wall_of_guns_1",
  map = "MAP02"
}

--

PREFABS.Pic_indust_wall_of_guns_1_grouped =
{
  template = "Pic_indust_wall_of_guns_1",
  skip_prob = 0,

  theme = "any",

  group = "gtd_wall_of_guns"
}

PREFABS.Pic_indust_wall_of_guns_2_grouped =
{
  template = "Pic_indust_wall_of_guns_1",
  map = "MAP02",
  skip_prob = 0,

  theme = "any",

  group = "gtd_wall_of_guns"
}
