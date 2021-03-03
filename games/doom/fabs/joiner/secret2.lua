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

  -- pick some different objects for the hint, often none
  thing_33 =
  {
    nothing = 20,
    barrel = 10,
    dead_player = 10,
    dead_imp = 10,
    gibs = 10,
    gibbed_player = 5,
    pool_brains = 5,
  },

  -- prevent monsters stuck in a barrel
  solid_ents = true,
}


-- hint is a small gap
PREFABS.Joiner_secret2_B =
{
  template = "Joiner_secret2_A",
  map      = "MAP02",

  prob   = 50,
}


-- this one looks like a picture
PREFABS.Joiner_secret2_C1 =
{
  template = "Joiner_secret2_A",
  map      = "MAP03",

  prob   = 100,
  theme  = "tech",
  env    = "building",
}

PREFABS.Joiner_secret2_C2 =
{
  template = "Joiner_secret2_A",
  map      = "MAP03",

  prob   = 100,
  theme  = "!tech",
  env    = "building",

  tex_SILVER2 = "MARBFAC3",
}

