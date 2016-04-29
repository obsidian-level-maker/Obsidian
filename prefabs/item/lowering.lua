--
--  Lowering pedestal (via remote switch)
--

PREFABS.Item_lowering_remote =
{
  file   = "item/lowering.wad"
  where  = "point"

--!!!  size   = 40
--!!!  height = 144

  item_kind = "key"
  key    = "lowering"

  tag_1  = "?lock_tag"
  action = "S1_LowerFloor"
}

