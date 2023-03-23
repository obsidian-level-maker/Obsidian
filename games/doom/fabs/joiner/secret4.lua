--
-- Secret joiners
--

PREFABS.Joiner_secret4_A =
{
  file   = "joiner/secret4.wad",
  map    = "MAP01",

  theme  = "!hell",
  prob   = 10,
  key    = "secret",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = { 40,88 },
  y_fit  = { 64,96 }
}


-- hint is a small gap
PREFABS.Joiner_secret4_B =
{
  template = "Joiner_secret4_A",
  map      = "MAP02",

  prob   = 7
}

--

PREFABS.Joiner_secret4_A_hell =
{
  template = "Joiner_secret4_A",
  map      = "MAP02",

  theme  = "hell",
  prob   = 10,

  thing_48 = 30
}

PREFABS.Joiner_secret4_B_hell =
{
  template = "Joiner_secret4_A",
  map      = "MAP02",

  theme  = "hell",
  prob   = 7,

  thing_48 = 30
}
