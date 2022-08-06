PREFABS.Item_broken_crate =
{
  file  = "item/gtd_item_crates.wad",
  where = "point",
  theme = "!hell",

  map  = "MAP01",

  size = 64,
  prob = 75,
}

PREFABS.Item_broken_crate2 =
{
  template = "Item_broken_crate",

  map = "MAP02",
  theme = "!hell"
}

PREFABS.Item_generic_hell_broken_crate =
{
  template = "Item_broken_crate",

  map = "MAP03",
  game = "doomish",
  theme = "hell"
}
