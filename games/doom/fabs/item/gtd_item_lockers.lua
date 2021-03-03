PREFABS.Item_locker_bin =
{
  file  = "item/gtd_item_lockers.wad",
  map = "MAP01",

  prob = 50,
  theme = "!hell",

  where = "point",

  height = { 128,384 },
  size = 56,

  bound_z1 = 0,
}

PREFABS.Item_locker_bin_keyed =
{
  template = "Item_locker_bin",

  item_kind = "key",
}

PREFABS.Item_locker_cylinder =
{
  template = "Item_locker_bin",
  map = "MAP02",
}

PREFABS.Item_locker_cylinder_keyed =
{
  template = "Item_locker_bin",
  map = "MAP02",

  item_kind = "key",
}

PREFABS.Item_locker_bars =
{
  template = "Item_locker_bin",
  map = "MAP03",
}

PREFABS.Item_locker_bars_keyed =
{
  template = "Item_locker_bin",
  map = "MAP03",

  item_kind = "key",
}
