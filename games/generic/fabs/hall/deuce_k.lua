--
-- 2-seed-wide hallway : locked terminators
--

PREFABS.Hallway_deuce_locked_key1 =
{
  file   = "hall/deuce_k.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "deuce",
  key    = "k_one",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}

PREFABS.Hallway_deuce_locked_key2 =
{
  template  = "Hallway_deuce_locked_key1",
  map    = "MAP01",
  key = "k_two",

  tex__KEYTRM1 = "_KEYTRM2",
  line_700 = 701,
}


PREFABS.Hallway_deuce_locked_key3 =
{
  template = "Hallway_deuce_locked_key1",
  map  = "MAP01",
  key  = "k_three",

  tex__KEYTRM1 = "_KEYTRM3",
  line_700 = 702,
}


----------------------------------------------------------------

PREFABS.Hallway_deuce_barred =
{
  file   = "hall/deuce_k.wad",
  map    = "MAP03",

  kind   = "terminator",
  group  = "deuce",
  key    = "barred",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,
  deep   = 16,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
}
