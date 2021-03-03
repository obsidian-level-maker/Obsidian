--
-- Secret joiners
--

PREFABS.Joiner_secret2_A =
{
  file   = "joiner/secret2.wad",
  map    = "MAP01",

  prob   = 150,
  key    = "secret",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 64,96 },
}


-- hint is a small gap
PREFABS.Joiner_secret2_B =
{
  template = "Joiner_secret2_A",
  map      = "MAP02",

  prob   = 50,
}

