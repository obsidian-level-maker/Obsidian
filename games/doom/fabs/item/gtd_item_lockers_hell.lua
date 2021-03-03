PREFABS.Item_locker_cross_lowering =
{
  file  = "item/gtd_item_lockers_hell.wad",
  map = "MAP01",

  prob = 50,
  theme = "hell",

  where = "point",
  height = 128,
  size = 56,

  bound_z1 = 0,
}

PREFABS.Item_locker_cross_lowering_keyed =
{
  template = "Item_locker_cross_lowering",

  item_kind = "key",
}

PREFABS.Item_locker_gut_crusher =
{
  template = "Item_locker_cross_lowering",
  map = "MAP02",

  height = { 128,384 }
}

PREFABS.Item_locker_gut_crusher_keyed =
{
  template = "Item_locker_cross_lowering",
  map = "MAP02",

  item_kind = "key",

  height = { 128,384 }
}

PREFABS.Item_locker_cage =
{
  template = "Item_locker_cross_lowering",
  map = "MAP03",

  height = { 128,384 },

  size = 96,
}

PREFABS.Item_locker_cage_keyed =
{
  template = "Item_locker_cross_lowering",
  map = "MAP03",

  item_kind = "key",

  height = { 128,384 },

  size = 96,
}
