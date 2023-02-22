PREFABS.Item_closet_hellish_loo =
{
  file   = "item/gtd_item_closet_toilet_hell.wad",
  map    = "MAP01",

  rank   = 2,
  prob   = 125,
  theme  = "hell",
  env    = "outdoor",
  open_to_sky = true,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  item_kind = "key",

  x_fit = "frame",
}

PREFABS.Item_closet_hellish_loo_shittier =
{
  template = "Item_closet_hellish_loo",

  map = "MAP02",
}
