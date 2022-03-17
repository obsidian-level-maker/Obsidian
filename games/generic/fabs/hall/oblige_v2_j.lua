--
-- 2-seed-wide hallway : terminators
--

PREFABS.Hallway_oblige_v2_term =
{
  file   = "hall/oblige_v2_j.wad",
  map    = "MAP01",
  kind   = "terminator",

  group  = "oblige_v2",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}


PREFABS.Hallway_oblige_v2_secret =
{
  template = "Hallway_oblige_v2_term",

  map  = "MAP05",
  key  = "secret",
}

