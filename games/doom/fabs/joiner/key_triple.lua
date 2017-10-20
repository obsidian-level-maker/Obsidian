--
-- Triple keyed door
--

PREFABS.Locked_joiner_triple =
{
  file   = "joiner/key_triple.wad"
  where  = "seeds"
  shape  = "I"

  key    = "k_ALL"
  prob   = 100

  seed_w = 2
  seed_h = 1

  deep   = 16
  over   = 16

  x_fit  = "frame"
  y_fit  = "frame"

  nearby_h = 160

  flat_FLOOR7_1 = "BIGDOOR4"
}


-- variation for BOOM compatible ports
PREFABS.Locked_joiner_triple_boom =
{
  template = "Locked_joiner_triple"

  map = "MAP02"

  engine = "boom"

  rank = 2
}

