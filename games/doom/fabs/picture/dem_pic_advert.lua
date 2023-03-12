PREFABS.Pic_dem_advert =
{
  file = "picture/dem_pic_advert.wad",
  map = "MAP01",

  prob = 25,
  env = "building",
  theme = "urban",

  texture_pack = "armaetus",

  where = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  sector_17 = { [0]=50, [17]=50 },

  tex_SHAWN1 =
  {

    SHAWN1 = 50,
    ADVCR1 = 50,
    ADVCR2 = 50,
    ADVCR4 = 50,
    ADVDE1 = 50,
    ADVDE2 = 50,
    ADVDE3 = 50,
    ADVDE5 = 50,
    ADVDE7 = 50
  }

}

--

PREFABS.Pic_dem_advert_small =
{
  template = "Pic_dem_advert",
  map = "MAP02",

  prob = 15,

 seed_w = 1,

  tex_COMPSC1 =
  {

    COMPSC1 = 50,
    ADVCR3 = 50,
    ADVCR5 = 50,
    ADVDE4 = 50,
    ADVDE6 = 50
  }

}
