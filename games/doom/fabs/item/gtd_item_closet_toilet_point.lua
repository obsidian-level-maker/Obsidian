PREFABS.Item_closet_toilet_point =
{
  file  = "item/gtd_item_closet_toilet_point.wad",

  map   = "MAP01",

  prob  = 20,
  env = "!cave",
  theme = "!hell",

  where = "point",

  height = { 128,368 },
  size  = 96,
}

PREFABS.Item_closet_toilet_point_key_carrier =
{
  template = "Item_closet_toilet_point",


  prob = 75,

  item_kind = "key",
}
