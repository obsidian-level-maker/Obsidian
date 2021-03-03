--
-- 2-seed-wide hallway : terminators
--

PREFABS.Hallway_deuce_term =
{
  file   = "hall/deuce_j.wad",
  map    = "MAP01",
  kind   = "terminator",
  theme  = "!tech",

  group  = "deuce",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}

PREFABS.Hallway_deuce_term_tech =
{
  template   = "Hallway_deuce_term",
  map    = "MAP01",
  theme  = "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",
}

-- doorz -MSSP
PREFABS.Hallway_deuce_term_door =
{
  template = "Hallway_deuce_term",
  style = "doors",
}

PREFABS.Hallway_deuce_term_door_tech =
{
  template = "Hallway_deuce_term",
  style = "doors",

  theme = "tech",

  tex_BIGDOOR6 = "BIGDOOR1",
  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",
}


PREFABS.Hallway_deuce_secret =
{
  template = "Hallway_deuce_term",

  map  = "MAP05",
  theme = "!tech",
  key  = "secret",
}

PREFABS.Hallway_deuce_secret_tech =
{
  template = "Hallway_deuce_term",

  map  = "MAP05",
  theme = "tech",
  key  = "secret",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",

}
