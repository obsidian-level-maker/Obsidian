--
-- 2-seed-wide hallway : locked terminators
--

PREFABS.Hallway_oblige_v2_locked_key1 =
{
  file   = "hall/oblige_v2_k.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "oblige_v2",
  key    = "k_one",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}

PREFABS.Hallway_oblige_v2_locked_key2 =
{
  file   = "hall/oblige_v2_k.wad",
  map    = "MAP02",

  kind   = "terminator",
  group  = "oblige_v2",
  key    = "k_two",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}


PREFABS.Hallway_oblige_v2_locked_key3 =
{
  file   = "hall/oblige_v2_k.wad",
  map    = "MAP03",

  kind   = "terminator",
  group  = "oblige_v2",
  key    = "k_three",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}


----------------------------------------------------------------

PREFABS.Hallway_oblige_v2_barred =
{
  file   = "hall/oblige_v2_k.wad",
  map    = "MAP04",

  kind   = "terminator",
  group  = "oblige_v2",
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
