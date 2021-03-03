PREFABS.Pic_storefront_3x =
{
  file   = "picture/gtd_pic_urban_generic_frontages.wad",
  map    = "MAP01",

  prob   = 80, --35,
  theme = "urban",

  env   = "!cave",

  where  = "seeds",
  height = 128,

  seed_w = 3,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep   =  16,
  over   = -16,

  x_fit = { 72,80 , 304,312 },
  y_fit = "top",

  tex_COMPBLUE =
  {
    COMPBLUE = 10,
    LITE5 = 10,
    LITEBLU4 = 10,
    REDWALL = 10,
  },

  tex_MODWALL3 =
  {
    MODWALL3 = 20,
    STEP4 = 10,
    STEP5 = 10,
  },
}

PREFABS.Pic_storefront_2x =
{
  template = "Pic_storefront_3x",
  map = "MAP02",

  prob = 80,

  seed_w = 2,

  x_fit = { 60,68 },
}

PREFABS.Pic_apartment_row_3x =
{
  file   = "picture/gtd_pic_urban_generic_frontages.wad",
  map    = "MAP03",

  prob   = 120, --35,
  theme = "urban",

  env   = "!cave",

  where  = "seeds",
  height = 128,

  seed_w = 3,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep   =  16,
  over   = -16,

  x_fit = "frame",
  y_fit = "top",
}
