--
--  Large gothic item balcony
--

PREFABS.Item_gothic_balcony =
{
  file   = "item/gothic1.wad",

  rank   = 3,
  prob   = 200,
  theme  = "!tech",
  env    = "!cave",

  item_kind = "key",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep =  16,
  over = -16,

  x_fit = "frame",
}

PREFABS.Item_gothic_balcony2 =
{
  template = "Item_gothic_balcony",
  theme  = "!tech",

  tex_MARBGRAY = "SUPPORT3",
  flat_DEM1_5 = "CEIL5_2",

}

PREFABS.Item_tech_balcony =
{
  template = "Item_gothic_balcony",
  theme  = "tech",

  env    = "indoor",
  tex_MARBGRAY = "TEKWALL1",
  flat_DEM1_5 = "CEIL5_1",
  tex_STEP5 = "STEP4",

}

PREFABS.Item_tech_balcony2 =
{
  template = "Item_gothic_balcony",
  theme  = "tech",

  env    = "indoor",
  tex_MARBGRAY = "TEKWALL4",
  flat_DEM1_5 = "CEIL5_1",
  tex_STEP5 = "STEP4",

}

PREFABS.Item_urban_balcony =
{
  template = "Item_gothic_balcony",
  theme  = "urban",

  env    = "indoor",
  tex_MARBGRAY = "BIGBRIK2",
  flat_DEM1_5 = "FLAT5_4",
  tex_STEP5 = "STEP6",

}

PREFABS.Item_urban_balcony2 =
{
  template = "Item_gothic_balcony",
  theme  = "urban",

  env    = "indoor",
  tex_MARBGRAY = "BSTONE2",
  flat_DEM1_5 = "RROCK12",
  tex_STEP5 = "STEP4",

}

PREFABS.Item_general_balcony =
{
  template = "Item_gothic_balcony",

  env    = "indoor",
  tex_MARBGRAY = "STONE4",
  flat_DEM1_5 = "FLAT5_4",

}
