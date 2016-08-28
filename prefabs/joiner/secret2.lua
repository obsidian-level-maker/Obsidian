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
  y_fit  = "frame"

  prob   = 100

  -- pick some different objects for the hint, often none
  thing_34 =
  {
    nothing = 40
    barrel = 10
    dead_player = 10
    dead_imp = 10
    gibs = 10
    gibbed_player = 5
    pool_brains = 5
  }
}

