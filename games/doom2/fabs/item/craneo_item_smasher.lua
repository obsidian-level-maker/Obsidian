--[[PREFABS.Item_craneo_smasher_tech =
{
  file  = "item/craneo_item_smasher.wad",
  map = "MAP01",

  prob = 7,
  theme = "!hell",

  style = "traps",

  where = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_craneo_smasher_alt_tech =
{
  template = "Item_craneo_smasher_tech",

  map = "MAP02",
}

PREFABS.Item_craneo_smasher_gothic =
{
  template = "Item_craneo_smasher_tech",

  theme = "hell",

  flat_FLAT23 = "CEIL5_2",
  flat_FLOOR1_1 = "",
  tex_SUPPORT2 = "METAL",
  tex_CEMENT8 = "GSTGARG",
  tex_DOORSTOP = "METAL",
}

PREFABS.Item_craneo_smasher_alt_gothic =
{
  template = "Item_craneo_smasher_tech",

  map = "MAP02",

  theme = "hell",

  flat_FLAT23 = "CEIL5_2",
  tex_SUPPORT2 = "METAL",
  tex_CEMENT8 = "GSTGARG",
  tex_DOORSTOP = "METAL",
}
]]
