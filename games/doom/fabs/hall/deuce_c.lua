--
-- 2-seed-wide hallway : corner (L shape)
--

PREFABS.Hallway_deuce_c1 =
{
  file   = "hall/deuce_c.wad",
  map    = "MAP01",
  theme  = "!tech",

  group  = "deuce",
  prob   = 50,

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,
}

PREFABS.Hallway_deuce_c1_tech =
{
  template = "Hallway_deuce_c1",
  map    = "MAP01",
  theme  = "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",
}
