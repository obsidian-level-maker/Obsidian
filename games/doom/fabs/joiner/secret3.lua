--
-- More secret joiners
--

PREFABS.Joiner_secret3_cage =
{
  file   = "joiner/secret3.wad"
  map    = "MAP01"

  prob   = 50
  env    = "!cave"
  style  = "cages"

  key    = "secret"

  where  = "seeds"
  shape  = "I"

  seed_w = 2
  seed_h = 1

  deep   = 16
  over   = 16

  x_fit  = "frame"
  y_fit  = "top"

  y_fit  = { 128,144 }
}


-- this looks like a small niche with a light
PREFABS.Joiner_secret3_niche =
{
  template = "Joiner_secret3_cage"
  map    = "MAP02"

  prob   = 50
  env    = "building"

  y_fit  = { 16,32 }
}

