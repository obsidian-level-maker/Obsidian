--
-- Secret joiners
--

PREFABS.Joiner_secret3_A =
{
  file   = "joiner/secret3.wad",
  map    = "MAP01",

  prob   = 150,
  key    = "secret",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 64,96 },
}


-- hint is a small gap
PREFABS.Joiner_secret3_B =
{
  template = "Joiner_secret3_A",
  map      = "MAP02",

  prob   = 50,
}

