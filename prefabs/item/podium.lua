--
-- Small podium
--

PREFABS.Item_podium =
{
  file  = "item/podium.wad"
  where = "point"
  size  = 24

  item_kind = "key"

  theme = "!tech"
  prob  = 100
}


PREFABS.Item_podium_tech =
{
  template = "Item_podium"

  map = "MAP02"

  theme = "tech"
}

