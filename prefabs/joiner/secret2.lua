--
-- Secret joiners
--

PREFABS.Joiner_secret2_A =
{
  file   = "joiner/secret2.wad"
  map    = "MAP01"

  where  = "seeds"
  shape  = "I"

  key    = "secret"

  seed_w = 2
  seed_h = 1

  x_fit  = "frame"
  y_fit  = "stretch"

  prob   = 150

  -- pick some different objects for the hint, often none
  thing_33 =
  {
    nothing = 30
    barrel = 10
    dead_player = 10
    dead_imp = 10
    gibs = 10
    gibbed_player = 5
    pool_brains = 5
  }
}


-- hint is a small gap
PREFABS.Joiner_secret2_B =
{
  template = "Joiner_secret2_A"

  map    = "MAP02"
  y_fit  = "top"

  prob   = 50
}


-- this one looks like a picture
PREFABS.Joiner_secret2_C1 =
{
  template = "Joiner_secret2_A"

  map    = "MAP03"
  y_fit  = "top"

  theme  = "tech"
  prob   = 100
}

PREFABS.Joiner_secret2_C2 =
{
  template = "Joiner_secret2_A"

  map    = "MAP03"
  y_fit  = "top"

  theme  = "!tech"
  prob   = 100

  tex_SILVER2 = "MARBFAC3"
}

