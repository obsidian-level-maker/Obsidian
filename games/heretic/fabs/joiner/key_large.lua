--
-- Large keyed door
--

PREFABS.Locked_joiner_green =
{
  file   = "joiner/key_large.wad"
  map    = "MAP01"

  prob   = 100

  key    = "k_green"
  where  = "seeds"
  shape  = "I"

  seed_w = 2
  seed_h = 1

  deep   = 16
  over   = 16

  x_fit  = "frame"
  y_fit  = "frame"

  nearby_h = 160

  -- thing is already #95 (green statue)
  -- line special is already #33
}


PREFABS.Locked_joiner_blue =
{
  template = "Locked_joiner_green"

  key      = "k_blue"

  -- use the blue statue and correct line special
  thing_95 = 94
  line_33  = 32
}


PREFABS.Locked_joiner_yellow =
{
  template = "Locked_joiner_green"

  key      = "k_yellow"

  -- use the yellow statue and correct line special
  thing_95 = 96
  line_33  = 34
}

