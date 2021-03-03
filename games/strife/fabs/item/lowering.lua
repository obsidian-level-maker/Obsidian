--
--  Lowering pedestal (via remote switch)
--

PREFABS.Item_lowering_remote1 =
{
  file   = "item/lowering.wad",
  map    = "MAP01",

  prob   = 1,
  key    = "barred",
  item_kind = "key",

  where  = "point",

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
},
