--
-- Joiner with rounded walls + stair
--

DOOM.SKINS.Joiner_round_stair =
{
  file = "joiner/round_stair.wad"

  prob = 200

  seed_w = 3
  seed_h = 1

  bound_z1 = 0

  edges =
  {
    n = { f_h=80 }
  }

  north = "nnn"
  south = "..."

  room     = "outdoor"
  neighbor = "outdoor"

  add_sky   = 1
}

