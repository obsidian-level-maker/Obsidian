--
-- vent piece : locked terminators
--

PREFABS.Hallway_vent_locked_red =
{
  file   = "hall/vent_k.wad"
  map    = "MAP01"

  kind   = "terminator"
  group  = "vent"
  key    = "k_red"

  prob   = 50

  where  = "seeds"
  shape  = "I"

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


----------------------------------------------------------------


PREFABS.Hallway_vent_barred =
{
  file   = "hall/vent_k.wad"
  map    = "MAP03"

  kind   = "terminator"
  group  = "vent"
  key    = "barred"

  prob   = 50

  where  = "seeds"
  shape  = "I"

  deep   = 16

  tag_1  = "?door_tag"
  door_action = "S1_LowerFloor"
}

