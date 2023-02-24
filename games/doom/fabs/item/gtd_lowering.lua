PREFABS.Item_gtd_lowering_skin_cage =
{
  file   = "item/gtd_lowering.wad",
  map    = "MAP01",

  theme  = "hell",

  prob   = 150,
  key    = "barred",
  item_kind = "key",

  where  = "point",
  height = 116,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
}

PREFABS.Item_gtd_lowering_uac_cage =
{
  template = "Item_gtd_lowering_skin_cage",
  map      = "MAP02",

  theme = "tech",

  height = 88,
}

PREFABS.Item_gtd_lowering_wood_cage =
{
  template = "Item_gtd_lowering_skin_cage",
  map      = "MAP03",

  theme    = "urban",

  height   = 48,
}
