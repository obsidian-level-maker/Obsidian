PREFABS.Item_closet_tech_doubles =
{
  file   = "item/gtd_item_closet_doubles.wad",
  map    = "MAP01",

  theme  = "!hell",
  prob   = 50,
  env    = "!cave",

  where  = "seeds",
  seed_w = 1,
  seed_h = 2,

  deep =  16,

  x_fit = "frame",
  y_fit = "top",

  sector_1 =  { [0]=20, [8]=20, [12]=50, [13]=30, [21]=10 }
}

PREFABS.Item_closet_tech_doubles_hell =
{
  template = "Item_closet_tech_doubles",

  theme = "hell",

  tex_DOORSTOP = "METAL",
  flat_FLAT2 = "TLITE6_5",
  flat_FLAT19 = "CEIL5_2",
  flat_FLAT23 = "CEIL5_2",
  tex_LITE3 = "CRACKLE4",
  tex_COMPSTA1 = "FIREWALA",
  tex_SUPPORT2 = "METAL",
  tex_GRAY7 = "BRONZE1",
  tex_SHAWN2 = "BRONZE1",
  tex_SHAWN3  = "BRONZE1",
}
