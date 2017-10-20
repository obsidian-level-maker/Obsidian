--
-- Joiner with opening door
--

PREFABS.Joiner_door2 =
{
  file   = "joiner/door2.wad"
  map    = "MAP01"

  prob   = 200
  theme  = "!hell"
  style  = "doors"

  where  = "seeds"
  shape  = "I"

  seed_w = 2
  seed_h = 1

  deep   = 16
  over   = 16

  x_fit  = "frame"
}


PREFABS.Joiner_door2_hell =
{
  template = "Joiner_door2"
  map      = "MAP02"

  theme  = "hell"
}

