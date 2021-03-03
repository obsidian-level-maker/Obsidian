PREFABS.Item_secret_item_shootable_eye =
{
  file   = "item/mogwaltz_item_eye.wad",
  map    = "MAP01",

  prob   = 37,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = { 64,96 },

  -- prevent monsters stuck in a barrel
  solid_ents = true,
}

PREFABS.Item_secret_item_shootable_eye_pair =
{
  template = "Item_secret_item_shootable_eye",
  map = "MAP02",

  prob = 37,
}
