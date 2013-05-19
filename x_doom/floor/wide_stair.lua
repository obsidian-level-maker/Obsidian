--
-- Wide staircase
--

DOOM.SKINS.Floor_wide_stair =
{
  file = "floor/wide_stair.wad"

  prob = 99

  seed_w = 3
  seed_h = 1

  edges =
  {
    b = { f_h=40 }
    c = { f_h=48 }
  }

  north  = "bbb"
  south  = "..."
  east   = "c"
  west   = "c"

  complexity = 2
}


DOOM.SKINS.Floor_wide_stair2 =
{
  copy = "Floor_wide_stair"

  file = "floor/wide_stair2.wad"

  prob = 1999
}

