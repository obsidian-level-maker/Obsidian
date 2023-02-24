PREFABS.Pic_pic_tall_glass_orange =
{
  file   = "picture/gtd_pic_tall_glass_EPIC.wad",
  map    = "MAP01",

  prob   = 5000,

  group = "gtd_tall_glass_epic_orange",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",
  z_fit = { 24,72 }
}

PREFABS.Pic_pic_tall_glass_red =
{
  template = "Pic_pic_tall_glass_orange",

  group = "gtd_tall_glass_epic_red",

  tex_GLASS6 = "GLASS1",
  tex_GLASS12 = "GLASS13"
}

PREFABS.Pic_pic_tall_glass_blue =
{
  template = "Pic_pic_tall_glass_orange",

  group = "gtd_tall_glass_epic_blue",

  tex_GLASS6 = "GLASS2",
  tex_GLASS12 = "GLASS14"
}

PREFABS.Pic_pic_tall_glass_yellow =
{
  template = "Pic_pic_tall_glass_orange",
 
  group = "gtd_tall_glass_epic_yellow",

  tex_GLASS6 = "GLASS11",
  tex_GLASS12 = "GLASS11"
}

--

PREFABS.Pic_pic_tall_glass_yellow_shrine =
{
  template = "Pic_pic_tall_glass_orange",
  map = "MAP02",

  group = "gtd_tall_glass_epic_yellow",

  z_fit = { 88,96 }
}

PREFABS.Pic_pic_tall_glass_red_shrine =
{
  template = "Pic_pic_tall_glass_orange",
  map = "MAP03",

  group = "gtd_tall_glass_epic_red",

  z_fit = { 88,96 }
}

PREFABS.Pic_pic_tall_glass_blue_shrine =
{
  template = "Pic_pic_tall_glass_orange",
  map = "MAP04",

  group = "gtd_tall_glass_epic_blue",

  z_fit = { 88,96 }
}
