--
-- Hellish pentagram
--

PREFABS.Item_pentagram =
{
  file  = "item/pentagram.wad",

  rank  = 2,
  prob  = 100,
  theme = "hell",

  item_kind = "key",

  where = "point",
  size  = 90   -- actually bigger, but won't block movement
}

PREFABS.Item_pentagram2 =
{
  file  = "item/pentagram.wad",

  rank  = 2,
  prob  = 100,
  theme = "hell",

  item_kind = "key",

  where = "point",
  size  = 90,   -- actually bigger, but won't block movement

  tex_ROCKRED1 = "REDWALL",
  flat_FLOOR1_6 = "FLAT5_3",
}


PREFABS.Item_pentagram3 =
{
  file  = "item/pentagram.wad",

  rank  = 2,
  prob  = 70,
  theme = "hell",

  item_kind = "key",

  where = "point",
  size  = 90,   -- actually bigger, but won't block movement

  tex_ROCKRED1 = "BFALL1",
  flat_FLOOR1_6 = "BLOOD1",
}


PREFABS.Item_pentagram4 =
{
  file  = "item/pentagram.wad",

  rank  = 2,
  prob  = 50,
  theme = "hell",

  item_kind = "key",

  where = "point",
  size  = 90,  -- actually bigger, but won't block movement

  tex_ROCKRED1 = "LFALL1",
  flat_FLOOR1_6 = "LAVA1",
}

-- Rare tech pentagram, because hell influence
PREFABS.Item_pentagram5 =
{
  file  = "item/pentagram.wad",

  rank  = 2,
  prob  = 12,
  theme = "tech",

  item_kind = "key",

  where = "point",
  size  = 90,   -- actually bigger, but won't block movement

  tex_ROCKRED1 = "COMPBLUE",
  flat_FLOOR1_6 = "CEIL4_2",
}
