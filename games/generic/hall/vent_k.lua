--
-- vent piece : locked terminators
--

PREFABS.Hallway_vent_locked_key1 =
{
  file   = "hall/vent_k.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "vent",
  key    = "k_one",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,

}


PREFABS.Hallway_vent_locked_key2 =
{
  template = "Hallway_vent_locked_key1",

  key    = "k_two",

  line_34     = 33,
  tex__KEYTRM1 = "_KEYTRM2",
}


PREFABS.Hallway_vent_locked_key3 =
{
  template = "Hallway_vent_locked_key1",

  key    = "k_three",

  line_34     = 32,
  tex__KEYTRM1 = "_KEYTRM3",
}


----------------------------------------------------------------


PREFABS.Hallway_vent_barred =
{
  file   = "hall/vent_k.wad",
  map    = "MAP03",

  kind   = "terminator",
  group  = "vent",
  key    = "barred",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
}

