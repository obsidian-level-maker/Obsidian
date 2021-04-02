--
-- Large keyed door
--

PREFABS.Locked_joiner_key1 =
{
  file   = "joiner/key_large.wad",
  map    = "MAP01",

  prob   = 100,

  key    = "k_one",
  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  nearby_h = 160,

  -- thing is already #95 (green statue)
  -- line special is already #33,
}


PREFABS.Locked_joiner_key2 =
{
  template = "Locked_joiner_key1",

  key      = "k_two",
  tex__KEYTRM1 = "_KEYTRM2",
  
  line_700  = 701,
}


PREFABS.Locked_joiner_key3 =
{
  template = "Locked_joiner_key1",

  key      = "k_three",
  tex__KEYTRM1 = "_KEYTRM3",
  
  line_700  = 702,
}

