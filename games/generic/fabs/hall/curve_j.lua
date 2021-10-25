--
-- 2-seed-wide hallway : terminators
--

PREFABS.Hallway_curve_term =
{
  file   = "hall/curve_j.wad",
  map    = "MAP01",
  kind   = "terminator",

  group  = "curve",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}


PREFABS.Hallway_curve_secret =
{
  template = "Hallway_curve_term",

  map  = "MAP05",
  key  = "secret",
}

