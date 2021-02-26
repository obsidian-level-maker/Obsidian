--
-- 2-seed-wide hallway : terminators
--

PREFABS.Hallway_deuce_term =
{
  file   = "hall/deuce_j.wad",
  map    = "MAP01",
  kind   = "terminator",

  group  = "deuce",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}


PREFABS.Hallway_deuce_secret =
{
  template = "Hallway_deuce_term",

  map  = "MAP05",
  key  = "secret",
}

