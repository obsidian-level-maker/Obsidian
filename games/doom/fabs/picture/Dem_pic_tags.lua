PREFABS.Pic_dem_tags_regulars =
{
  file = "picture/Dem_pic_tags.wad",
  map = "MAP01",

  prob = 13,

  theme = "urban",

  where  = "seeds",
  height = 64,

  seed_w = 1,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 64,

  deep =  16,

  x_fit = "frame",
  y_fit = "top",

  texture_pack = "armaetus",

  tex_TAG1 =
  {
    TAG1 = 50,
    TAG2 = 50,
    TAG3 = 50,
    TAG4 = 50,
    TAG5 = 50,
    TAG6 = 50,
    TAG7 = 50,
    TAG8 = 50,
    TAG9 = 50,
    TAG10 = 50,
    TAG11 = 50,
    TAG12 = 50
  },

  x_fit = {4,8}
}

PREFABS.dem_tags_logs =
{
  template = "Pic_dem_tags_regulars",

  map = "MAP02",

  on_liquids="never",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  deep =  64,
}

PREFABS.Pic_dem_tags_regulars_right_align =
{
  template = "Pic_dem_tags_regulars",

  x_fit = {120,124}
}

PREFABS.Pic_dem_logs_logs_right_align =
{
  template = "Pic_dem_tags_regulars",

  map = "MAP02",

  on_liquids="never",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = {120,124}
}
