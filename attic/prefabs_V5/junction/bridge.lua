--
-- Bridge junctions
--

DOOM.SKINS.Junc_bridge1 =
{
  file   = "junction/bridge1.wad"
  shape  = "I"
  group  = "hall_curve"

  prob   = 200

  seed_w = 3
  seed_h = 3

  liquid = 1

  north = "#.#"
  south = "#.#"
}


DOOM.SKINS.Junc_bridge2 =
{
  file   = "junction/bridge2.wad"
  shape  = "C"
  group  = "hall_curve"

  prob   = 400

  seed_w = 3
  seed_h = 3

  south = "#.#"
  west  = "#w#"

  edges =
  {
    w = { f_h=96 }
  }
}

