--
-- Joiner with rounded walls + stair
--

DOOM.SKINS.Joiner_round_stair =
{
  file   = "joiner/round_stair.wad"

  prob   = 200

  room_kind = "outdoor"
  neighbor  = "outdoor"

  bound_z1  = 0
  add_sky   = 1

  north = "nnn"
  south = "..."

  edges =
  {
    n = { f_h=80 }
  }
}

