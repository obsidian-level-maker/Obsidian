--
-- vent piece : terminators
--

PREFABS.Hallway_vent_plain =
{
  file   = "hall/vent_j.wad"
  map    = "MAP01"

  kind   = "terminator"
  where  = "seeds"
  shape  = "I"

  prob   = 50

  deep   = 16
}


PREFABS.Hallway_vent_secret =
{
  template = "Hallway_vent_plain"

  map    = "MAP05"
  key    = "secret"
}

