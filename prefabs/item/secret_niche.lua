--
--  Secret item niche
--

-- the hint here is misaligned texture
PREFABS.Item_secret_niche1 =
{
  file  = "item/secret_niche.wad"

  prob  = 100
  key   = "secret"

  where  = "seeds"
  seed_w = 1
  seed_h = 1

  deep =  16
  over = -16

  x_fit = "frame"
  y_fit = "top"
}


-- this one uses a hint object (usually)
PREFABS.Item_secret_niche2 =
{
  template = "Item_secret_niche1"
  map      = "MAP02"

  prob = 100

  thing_34 =
  {
    nothing = 50
    pool_blood_1 = 30
    pool_blood_2 = 30
    pool_brains = 30
    gibbed_player = 10
    dead_player = 10
    barrel = 20
    candle = 20
  }

  -- prevent monsters stuck in a barrel
  solid_ents = true
}


-- this one gives the player a surprise
PREFABS.Item_secret_trappy =
{
  template = "Item_secret_niche1"
  map      = "MAP03"

  prob  = 20
  style = "traps"

  thing_34 =
  {
    -- always something to give it away
    pool_blood_1 = 20
    pool_blood_2 = 20
    pool_brains = 20
    gibbed_player = 30
    dead_player = 30
    barrel = 10
    candle = 10
  }

  solid_ents = true
}

