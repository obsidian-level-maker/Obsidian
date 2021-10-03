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
  file   = "hall/vent_k.wad",
  map    = "MAP02",

  kind   = "terminator",
  group  = "vent",
  key    = "k_two",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,
}


PREFABS.Hallway_vent_locked_key3 =
{
  file   = "hall/vent_k.wad",
  map    = "MAP03",

  kind   = "terminator",
  group  = "vent",
  key    = "k_three",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,
}


----------------------------------------------------------------


PREFABS.Hallway_vent_barred =
{
  file   = "hall/vent_k.wad",
  map    = "MAP04",

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

