--
-- More secret joiners
--

PREFABS.Joiner_secret3_cage =
{
  file   = "joiner/secret3.wad"
  map    = "MAP01"

  where  = "seeds"
  shape  = "I"

  key    = "secret"

  seed_w = 2
  seed_h = 1

  x_fit  = "frame"
--y_fit  = "top"

  prob   = 50
}


-- this looks like a small niche with a light
PREFABS.Joiner_secret3_niche =
{
  template = "Joiner_secret3_cage"
  map    = "MAP02"

  env    = "building"
  prob   = 50
}

