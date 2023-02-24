--
-- Secret joiners
--

PREFABS.Joiner_secret4_A =
{
  file   = "joiner/secret4.wad",
  map    = "MAP01",

  prob   = 50,
  key    = "secret",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = { 40,88 },
  y_fit  = { 64,96 },
}


-- hint is a small gap
PREFABS.Joiner_secret4_B =
{
  template = "Joiner_secret4_A",
  map      = "MAP02",

  prob   = 35,
}

