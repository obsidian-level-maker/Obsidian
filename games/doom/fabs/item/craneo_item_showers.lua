PREFABS.Item_public_showers =
{
  file  = "item/craneo_item_showers.wad",

  map   = "MAP02",

  prob  = 28,
  theme = "!hell",
  env   = "!cave",

  style = "traps",

  texture_pack = "armaetus",

  where = "seeds",

  seed_w = 3,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",
}

--

PREFABS.Item_public_showers_trapped =
{
  template = "Item_public_showers",
  map = "MAP01",

  style = "traps",
}
