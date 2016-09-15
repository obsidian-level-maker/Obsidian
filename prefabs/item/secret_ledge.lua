--
-- Closet with a secret item visible from outside
--

PREFABS.Item_secret_ledge =
{
  file  = "item/secret_ledge.wad"
  where = "seeds"

  prob  = 2000
  env   = "!cave"

  key   = "secret"

  seed_w = 3
  seed_h = 1
  height = 160

  deep =  16
  over = -16

  x_fit = "frame"
  y_fit = "top"
}

