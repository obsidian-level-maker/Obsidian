--
-- vent piece : locked terminators
--

PREFABS.Hallway_vent_locked_red =
{
  file   = "hall/vent_k.wad"
  map    = "MAP01"

  kind   = "terminator"
  key    = "k_red"

  where  = "seeds"
  shape  = "I"

  prob   = 50

  deep   = 16
}


PREFABS.Hallway_vent_locked_blue =
{
  template = "Hallway_vent_locked_red"

  key    = "k_blue"

  tex_DOORRED = "DOORBLU"
  line_33     = 32
}


PREFABS.Hallway_vent_locked_yellow =
{
  template = "Hallway_vent_locked_red"

  key    = "k_yellow"

  tex_DOORRED = "DOORYEL"
  line_33     = 34
}


-- TODO : hell versions


----------------------------------------------------------------


PREFABS.Hallway_vent_barred =
{
  file   = "hall/vent_k.wad"
  map    = "MAP03"

  kind   = "terminator"
  key    = "barred"

  where  = "seeds"
  shape  = "I"

  prob   = 50

  deep   = 16
}

