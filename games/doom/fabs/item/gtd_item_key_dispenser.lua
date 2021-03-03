PREFABS.Item_gtd_key_dispenser =
{
  file   = "item/gtd_item_key_dispenser.wad",
  map = "MAP01",

  rank = 2,
  prob = 30,
  skip_prob = 50,

  theme = "!hell",
  env = "!cave",

  item_kind = "key",

  where = "seeds",
  seed_w = 2,
  seed_h = 1,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_gtd_key_dispenser_hell =
{
  template = "Item_gtd_key_dispenser",
  map = "MAP02",

  texture_pack = "armaetus",

  prob = 50,

  over = 0,

  theme = "hell",
}
