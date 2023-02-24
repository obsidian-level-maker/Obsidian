PREFABS.Item_closet_urban_fake_shutter =
{
  file   = "item/gtd_item_closet_urban.wad",
  map    = "MAP01",

  prob   = 100,
  theme  = "urban",
  env    = "!cave",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  sector_1 =  { [0]=20, [8]=20, [12]=50, [13]=30, [21]=10 }
}

PREFABS.Item_closet_urban_fake_door =
{
  template = "Item_closet_urban_fake_shutter",
  map      = "MAP02",
}

PREFABS.Item_closet_urban_steal_stuff_right_off_windows_you_bad_person_you =
{
  template = "Item_closet_urban_fake_shutter",
  map      = "MAP03",

  --[[flat_FLOOR5_3 =
  {
    FLOOR5_3 = 1, FLAT1 = 1, FLAT1_1 = 1,
    FLAT20 = 1, FLAT3 = 1, FLAT5 = 1,
    FLAT5_1 = 1, FLAT5_2 = 1, FLAT8 = 1,
    FLOOR0_1 = 1, FLOOR0_2 = 1, FLOOR0_3 = 1,
    FLOOR0_5 = 1, FLOOR4_6 = 1,
  }]]
  tex_BRICK12 =
  {
    BRICK12 = 1, BIGBRIK1 = 1, BRICK1 = 1,
    BRICK10 = 1, BRICK11 = 1, BRICK2 = 1,
    BRICK3 = 1, BRICK4 = 1, BRICK7 = 1,
    STUCCO = 2, STUCCO1 = 2,
    STONE2 = 1,
  }
}

PREFABS.Item_closet_empty_shop =
{
  template = "Item_closet_urban_fake_shutter",
  map = "MAP04",

  seed_h = 2,

  tex_BRONZE3 =
  {
    BRONZE3 = 1, BRICK11 = 1, BRICK12 = 1,
    BRICK5 = 1, BRICK7 = 1, BROWNGRN = 1,
    GRAY1 = 1, GRAY5 = 1, PANCASE2 = 1,
    PANEL6 = 1, STUCCO = 1, STUCCO1 = 1,
    STONE2 = 1, GRAY7 = 1,
  },

  tex_COMPBLUE =
  {
    COMPBLUE = 1, REDWALL = 1,
  }
}
