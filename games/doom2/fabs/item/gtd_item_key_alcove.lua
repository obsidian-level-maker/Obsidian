PREFABS.Item_gtd_alcove2 =
{
  file = "item/gtd_item_key_alcove.wad",
  map = "MAP01",

  rank = 2,
  prob = 200,
  theme = "tech",
  env = "!cave",

  item_kind = "key",

  where = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  sector_12 =  { [0]=20, [8]=20, [12]=50, [13]=30, [21]=10 },

  tex_COMPTALL =
  {
    COMPTALL = 1, COMPBLUE = 1, LITEBLU1 = 1,
    TEKGREN1 = 1, TEKBRON2 = 1, TEKWALL1 = 1,
    TEKWALL4 = 1, SLADWALL = 1,
  },

  bound_z1 = -32,
}

PREFABS.Item_gtd_alcove2_urban =
{
  template = "Item_gtd_alcove2",

  theme = "urban",

  tex_COMPTALL =
  {
    CEMENT9 = 4, BRICK11 = 1, BRICK12 = 1, BRICK7,
    REDWALL = 1, SLADWALL = 1, WOODGARG = 1,
  },
  tex_METAL5 = "BRICKLIT",
  flat_CEIL4_3 = "FLAT5_2",
}

PREFABS.Item_gtd_alcove2_hell =
{
  template = "Item_gtd_alcove2",

  theme = "hell",

  tex_COMPTALL =
  {
    FIRELAVA = 1, FIREBLU1 = 1, FIREMAG1 = 1,
    CRACKLE2 = 1, CRACKLE4 = 1, SLADWALL = 1, WOODGARG = 1,
  },
  tex_METAL5 = "WOOD4",
  flat_CEIL4_3 = "DEM1_6",
}
