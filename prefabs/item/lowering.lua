--
--  Lowering pedestal (via remote switch)
--

PREFABS.Item_lowering_remote1 =
{
  file   = "item/lowering.wad"
  map    = "MAP01"

  prob   = 1
  key    = "lowering"
  item_kind = "key"

  where  = "point"

  tag_1  = "?lock_tag"
  action = "S1_LowerFloor"
}


PREFABS.Item_lowering_remote2 =
{
  template = "Item_lowering_remote1"
  map      = "MAP02"

  prob   = 80

  height = 144
}

