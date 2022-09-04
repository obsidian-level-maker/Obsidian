PREFABS.Pic_dem_tags_regulars =
{
  file = "picture/Dem_pic_tags.wad",
  map = "MAP01",

  prob = 25,

  theme = "urban",

  where  = "seeds",
  height = 64,

  seed_w = 1,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 64,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

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
  }

}

PREFABS.dem_tags_logs =
{
  template = "Pic_dem_tags_regulars",

  map = "MAP02",

  prob = 5,

  on_liquids="never",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,


  deep =  64,
  over = -16,


}

