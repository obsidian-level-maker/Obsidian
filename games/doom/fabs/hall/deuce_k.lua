--
-- 2-seed-wide hallway : locked terminators
--

PREFABS.Hallway_deuce_locked_red =
{
  file   = "hall/deuce_k.wad"
  map    = "MAP01"

  kind   = "terminator"
  group  = "deuce"
  key    = "k_red"

  prob   = 50

  where  = "seeds"
  shape  = "I"

  seed_w = 2
  seed_h = 1

  deep   = 16
}


PREFABS.Hallway_deuce_locked_blue =
{
  template = "Hallway_deuce_locked_red"

  key  = "k_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}


PREFABS.Hallway_deuce_locked_yellow =
{
  template = "Hallway_deuce_locked_red"

  key  = "k_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}


----------------------------------------------------------------

PREFABS.Hallway_deuce_barred =
{
  file   = "hall/deuce_k.wad"
  map    = "MAP03"

  kind   = "terminator"
  group  = "deuce"
  key    = "barred"

  prob   = 50

  where  = "seeds"
  shape  = "I"

  seed_w = 2
  seed_h = 1
  deep   = 16

  tag_1  = "?door_tag"
  door_action = "S1_LowerFloor"
}

