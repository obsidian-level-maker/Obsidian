--Based on gtd_pic_hell_alcoves
PREFABS.Item_hell_alcove_tomb_secret =
{
  file   = "item/scionox_secrets_hell.wad",
  map    = "MAP01",

  prob   = 50,
  theme  = "hell",
  env    = "!nature",

  where  = "seeds",
  key    = "secret",
  height = 128,

  seed_w = 2,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_hell_alcove_window_secret =
{
  template = "Item_hell_alcove_tomb_secret",
  map      = "MAP02",
  engine   = "zdoom",
  seed_w = 3,
}
