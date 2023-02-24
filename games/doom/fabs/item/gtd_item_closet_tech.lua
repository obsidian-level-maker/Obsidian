PREFABS.Item_closet_simple1 =
{
  file   = "item/gtd_item_closet_tech.wad",
  map    = "MAP01",

  prob   = 75,
  theme  = "tech",
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

PREFABS.Item_closet_simple2 =
{
  template = "Item_closet_simple1",
  map    = "MAP02",

  sector_1 = { [0]=1 }
}

PREFABS.Item_closet_simple3 =
{
  template = "Item_closet_simple1",
  map    = "MAP03",
}

--

PREFABS.Item_closet_complex1 =
{
  template = "Item_closet_simple1",
  map    = "MAP04",

  prob = 33,
}

PREFABS.Item_closet_complex2 =
{
  template = "Item_closet_simple1",
  map    = "MAP05",

  prob = 33,

  sector_1 = { [0]=1 }
}

PREFABS.Item_closet_complex3 =
{
  template = "Item_closet_simple1",
  map    = "MAP06",

  prob = 33,
}
