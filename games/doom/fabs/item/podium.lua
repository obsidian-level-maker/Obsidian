--
-- Small podium
--

PREFABS.Item_podium =
{
  file  = "item/podium.wad",

  rank  = 2,
  prob  = 100,
  theme = "!tech",

  item_kind = "key",

  where = "point",
  size  = 24,
}


PREFABS.Item_podium_tech =
{
  template = "Item_podium",

  map = "MAP02",

  theme = "tech",
}


PREFABS.Item_podium_lite3 =
{
  template = "Item_podium",

  map = "MAP02",
  prob = 75,

  rank  = 2,
  theme = "tech",

  tex_TEKLITE  = "COMPSPAN",
  flat_CEIL3_1 = "CEIL5_1",

  tex_METAL6   = "LITE3",
}

