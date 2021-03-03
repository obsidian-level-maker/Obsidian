PREFABS.Item_closet_guts =
{
  file   = "item/gtd_item_closet_hell.wad",
  map    = "MAP01",

  prob   = 75,
  theme  = "hell",
  env    = "!cave",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  sector_1 =  { [0]=20, [8]=20, [12]=50, [13]=30, [21]=10 }
}

PREFABS.Item_closet_hellish_alcove =
{
  template = "Item_closet_guts",
  map      = "MAP02",
}

PREFABS.Item_closet_hellish_furnace =
{
  template = "Item_closet_guts",
  map      = "MAP03",
}

--

PREFABS.Item_closet_guts_big =
{
  template = "Item_closet_guts",
  map = "MAP04",

  prob = 33,
}

PREFABS.Item_closet_hellish_alcove_big =
{
  template = "Item_closet_guts",
  map = "MAP05",

  prob = 33,
}

PREFABS.Item_closet_hellish_furnace_big =
{
  template = "Item_closet_guts",
  map = "MAP06",

  prob = 33,
}
