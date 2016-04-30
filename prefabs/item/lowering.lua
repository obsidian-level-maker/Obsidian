--
--  Lowering pedestal (via remote switch)
--

PREFABS.Item_lowering_remote1 =
{
  file   = "item/lowering.wad"
  map    = "MAP01"
  where  = "point"

--!!!  size   = 40

  item_kind = "key"
  key    = "lowering"

  tag_1  = "?lock_tag"
  action = "S1_LowerFloor"

  prob   = 1
}


PREFABS.Item_lowering_remote2 =
{
  template = "Item_lowering_remote1"
  map      = "MAP02"

  height = 144

  prob   = 80
}

