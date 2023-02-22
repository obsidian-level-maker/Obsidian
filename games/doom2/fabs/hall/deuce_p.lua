--
-- 2-seed-wide hallway : four-way "+" junction
--

PREFABS.Hallway_deuce_p1 =
{
  file   = "hall/deuce_p.wad",
  map    = "MAP01",
  theme  = "!tech",

  group  = "deuce",
  prob   = 50,

  where  = "seeds",
  shape  = "P",

  seed_w = 2,
  seed_h = 2,
}

PREFABS.Hallway_deuce_p1_tech =
{
  template  = "Hallway_deuce_p1",
  map    = "MAP01",
  theme  = "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",
}

