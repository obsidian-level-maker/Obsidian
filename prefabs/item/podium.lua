--
-- Small podium
--

PREFABS.Item_podium =
{
  file  = "item/podium.wad"

  rank  = 2
  prob  = 100
  theme = "!tech"

  item_kind = "key"

  where = "point"
  size  = 24
}


PREFABS.Item_podium_tech =
{
  template = "Item_podium"

  map = "MAP02"

  theme = "tech"
}

