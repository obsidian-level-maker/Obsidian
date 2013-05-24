--
-- L shapes
--

DOOM.SKINS.Floor_3x3_L1 =
{
  file = "floor/L_shape1.wad"

  prob = 85

  seed_w = 3
  seed_h = 3

  edges =
  {
    b = { f_h=64 }
  }

  north = "bbb"
  south = "..b"

  east  = "bbb"
  west  = "..b"
}


DOOM.SKINS.Floor_3x3_L2 =
{
  file = "floor/L_shape2.wad"

  prob = 50

  seed_w = 3
  seed_h = 3

  edges =
  {
    n = { f_h=40 }
    e = { f_h=72 }
  }

  north = "nnn"
  south = "..."

  east  = "eee"
  west  = "..."
}

