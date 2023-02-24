PREFABS.Item_gtd_key_pedestal_tech =
{
  file  = "item/gtd_item_key_pedestal.wad",
  map = "MAP01",

  rank = 2,
  prob = 300,
  theme = "tech",

  item_kind = "key",

  where = "point",
  size = 32,
}

PREFABS.Item_gtd_key_pedestal_urban =
{
  template = "Item_gtd_key_pedestal_tech",
  map = "MAP02",

  theme = "urban",
}

PREFABS.Item_gtd_key_pedestal_hell =
{
  template = "Item_gtd_key_pedestal_tech",
  map = "MAP03",

  prob = 240,

  theme = "hell",

  size = 24,
}

PREFABS.Item_gtd_key_oh_he_ded =
{
  template = "Item_gtd_key_pedestal_tech",
  map = "MAP04",

  prob = 160,

  theme = "any",

  size = 24,

  thing_15 =
  {
    [15] = 50,
    [10] = 15,
  },

  thing_79 =
  {
    [79] = 50,
    [24] = 50,
    [80] = 25,
    [10] = 25,
    [21] = 5,
    [20] = 5,
    [19] = 5,
    [18] = 5,
  },

  thing_24 =
  {
    [79] = 50,
    [24] = 50,
    [80] = 25,
    [10] = 50,
    [21] = 5,
    [20] = 5,
    [19] = 5,
    [18] = 5,
  }
}
