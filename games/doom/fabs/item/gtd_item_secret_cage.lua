-- This is supposed to be a secret-hiding, stretchable version of the original cage fab.

PREFABS.Item_gtd_secret_cage =
{
  file  = "item/gtd_item_secret_cage.wad",
  where = "seeds",

  prob  = 100,
  env   = "building",
  theme = "!hell",

  key   = "secret",

  seed_w = 2,
  seed_h = 2,
  height = 128,

  deep =  16,
  over = -16,

  x_fit = { 68,76 , 180,188 },
  z_fit = { 96,100 }
}

PREFABS.Item_gtd_secret_cage_hell =
{
  template = "Item_gtd_secret_cage",

  theme = "hell",

  tex_LITE3 = "FIREWALL",
}
