--
-- Simple joiner
--

PREFABS.Joiner_simple1 =
{
  file   = "joiner/simple1.wad"
  map    = "MAP01"

  prob   = 100
  theme  = "tech"

  where  = "seeds"
  shape  = "I"

  seed_w = 2
  seed_h = 1

  deep   = 16
  over   = 16

  x_fit = { 96,160 }
  y_fit = { 48,112 }
}


-- a version of above with a little surprise
PREFABS.Joiner_simple1_trappy =
{
  template = "Joiner_simple1"
  map      = "MAP02"

  prob     = 200
  style    = "traps"

  seed_w   = 3
  seed_h   = 1

  x_fit    = "frame"
}


PREFABS.Joiner_simple1_wide =
{
  template = "Joiner_simple1"
  map      = "MAP03"

  prob     = 400

  seed_w   = 3
  seed_h   = 1

  x_fit    = { 176,224 }
}

