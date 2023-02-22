--
-- 2-seed-wide hallway : dead-end piece
--

PREFABS.Hallway_deuce_u1 =
{
  file   = "hall/deuce_u.wad",
  map    = "MAP01",
  theme  = "urban",

  group  = "deuce",
  prob   = 50,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 2,

  tex_METAL = "METAL",
  flat_CEIL5_2 = "METAL",

}

PREFABS.Hallway_deuce_u1_hell =
{
  template   = "Hallway_deuce_u1",
  theme = "hell",

  tex_GRAYPOIS = { GSTLION=50, GSTGARG=50, GSTSATYR=50},
  flat_FLOOR0_3 = "FLOOR7_2",

}

PREFABS.Hallway_deuce_u1_tech =
{
  template   = "Hallway_deuce_u1",
  theme = "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",

}
