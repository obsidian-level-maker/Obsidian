--
--  Lowering pedestal (via remote switch)
--

-- General purpose METAL5,
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
}

PREFABS.Item_lowering_remote1a =
{
  template = "Item_lowering_remote1",
  map      = "MAP02",

  prob   = 80,

  height = 144,
}

-- General purpose, non-Tech wood
PREFABS.Item_lowering_remote7 =
{
  file   = "item/lowering.wad",
  map    = "MAP07",
  theme  = "!tech",

  prob   = 1,
  key    = "barred",
  item_kind = "key",

  where  = "point",

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  tex_TEKWALL1 = "WOOD1",
  tex_COMPSPAN = "WOOD12",
  flat_CEIL5_1 = "FLAT5_1",

}

PREFABS.Item_lowering_remote7a =
{
  template = "Item_lowering_remote7",
  map      = "MAP02",

  prob   = 80,

  height = 144,
}

-- General purpose cement
PREFABS.Item_lowering_remote8 =
{
  file   = "item/lowering.wad",
  map    = "MAP07",

  prob   = 1,
  key    = "barred",
  item_kind = "key",

  where  = "point",

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  tex_TEKWALL1 = "CEMENT9",
  tex_COMPSPAN = "CEMENT7",
  flat_CEIL5_1 = "FLAT19",

}

PREFABS.Item_lowering_remote8a =
{
  template = "Item_lowering_remote8",
  map      = "MAP02",

  prob   = 80,

  height = 144,
}


-- Urban ones here --

PREFABS.Item_lowering_remote2 =
{
  file   = "item/lowering.wad",
  map    = "MAP03",
  theme  = "urban",

  prob   = 1,
  key    = "barred",
  item_kind = "key",

  where  = "point",

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
}

PREFABS.Item_lowering_remote2a =
{
  template = "Item_lowering_remote2",
  map      = "MAP04",
  theme  = "urban",

  prob   = 80,

  height = 144,
}

-- Hell ones here --

PREFABS.Item_lowering_remote3 =
{
  file   = "item/lowering.wad",
  map    = "MAP05",
  theme  = "hell",

  prob   = 1,
  key    = "barred",
  item_kind = "key",

  where  = "point",

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  tex_MARBLE2 = { MARBLE2=50, MARBLE3=50, MARBGRAY=50 }

}

PREFABS.Item_lowering_remote3a =
{
  template = "Item_lowering_remote3",
  map      = "MAP06",
  theme  = "hell",

  prob   = 80,

  height = 144,
}

-- Tech exclusive here --

-- TEKWALL2 and TEKWALL5 are Doom1 only but my edits w/ custom texture pack
-- makes them visible in Doom 2,
PREFABS.Item_lowering_remote4 =
{
  file   = "item/lowering.wad",
  map    = "MAP07",
  theme  = "tech",

  prob   = 1,
  key    = "barred",
  item_kind = "key",

  where  = "point",

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  tex_TEKWALL1 = { TEKWALL1=50, TEKWALL4=50, TEKGREN1=50 }

}

PREFABS.Item_lowering_remote4a =
{
  template = "Item_lowering_remote4",
  map      = "MAP08",
  theme  = "tech",

  prob   = 80,

  height = 144,
}

-- Stoney
PREFABS.Item_lowering_remote6 =
{
  file   = "item/lowering.wad",
  map    = "MAP07",
  theme  = "tech",

  prob   = 1,
  key    = "barred",
  item_kind = "key",

  where  = "point",

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  tex_TEKWALL1 = { BROWN1=50, BROWNGRN=50, STONE6=50 },
  tex_COMPSPAN = "STONE",
  flat_CEIL5_1 = "FLAT5_4",

}

PREFABS.Item_lowering_remote6a =
{
  template = "Item_lowering_remote6",
  map      = "MAP08",
  theme  = "tech",

  prob   = 80,

  height = 144,
}

-- Bluey
PREFABS.Item_lowering_remote9 =
{
  file   = "item/lowering.wad",
  map    = "MAP07",
  theme  = "tech",

  prob   = 1,
  key    = "barred",
  item_kind = "key",

  where  = "point",

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  tex_TEKWALL1 = "COMPBLUE",
  tex_COMPSPAN = "TEKWALL4",

}

PREFABS.Item_lowering_remote6a =
{
  template = "Item_lowering_remote9",
  map      = "MAP08",
  theme  = "tech",

  prob   = 80,

  height = 144,
}
