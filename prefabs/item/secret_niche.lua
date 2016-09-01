--
--  Secret item niche
--

-- the hint here is misaligned texture
PREFABS.Item_secret_niche1 =
{
  file  = "item/secret_niche.wad"
  where = "seeds"

  key   = "secret"

  seed_w = 1
  seed_h = 1

  x_fit = "frame"
  y_fit = "top"

  prob  = 100
}


-- this one uses a hint object (usually)
PREFABS.Item_secret_niche2 =
{
  template = "Item_secret_niche1"
  map = "MAP02"

  prob = 100

  thing_34 =
  {
    nothing = 90
    pool_blood_1 = 30
    pool_blood_2 = 30
    pool_brains = 30
    barrel = 30
    gibbed_player = 10
    dead_player = 10
    candle = 10
  }
}

