--
-- 2-seed-wide hallway : locked terminators
--

PREFABS.Hallway_deuce_locked_green =
{
  file   = "hall/deuce_k.wad"
  map    = "MAP01"

  kind   = "terminator"
  group  = "deuce"
  key    = "k_green"

  prob   = 50

  where  = "seeds"
  shape  = "I"

  seed_w = 2
  seed_h = 1

  deep   = 16
}


PREFABS.Hallway_deuce_locked_blue =
{
  template = "Hallway_deuce_locked_green"

  key  = "k_blue"

  thing_95 = 94
  line_33  = 32
}


PREFABS.Hallway_deuce_locked_yellow =
{
  template = "Hallway_deuce_locked_green"

  key  = "k_yellow"

  thing_95 = 96
  line_33  = 34
}

