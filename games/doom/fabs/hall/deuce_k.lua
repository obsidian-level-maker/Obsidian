--
-- 2-seed-wide hallway : locked terminators
--

PREFABS.Hallway_deuce_locked_red =
{
  file   = "hall/deuce_k.wad",
  map    = "MAP01",
  theme  = "!tech",

  kind   = "terminator",
  group  = "deuce",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}

PREFABS.Hallway_deuce_locked_red_tech =
{
  template  = "Hallway_deuce_locked_red",
  map    = "MAP01",
  theme  = "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",
}


PREFABS.Hallway_deuce_locked_blue =
{
  template = "Hallway_deuce_locked_red",

  key  = "k_blue",
  theme = "!tech",

  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}

PREFABS.Hallway_deuce_locked_blue_tech =
{
  template = "Hallway_deuce_locked_red",

  key  = "k_blue",
  theme = "tech",

  tex_DOORRED = "DOORBLU",
  line_33     = 32,

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",
}


PREFABS.Hallway_deuce_locked_yellow =
{
  template = "Hallway_deuce_locked_red",

  key  = "k_yellow",
  theme = "!tech",

  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}

PREFABS.Hallway_deuce_locked_yellow_tech =
{
  template = "Hallway_deuce_locked_red",

  key  = "k_yellow",
  theme = "tech",

  tex_DOORRED = "DOORYEL",
  line_33     = 34,

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",
}


----------------------------------------------------------------

PREFABS.Hallway_deuce_barred =
{
  file   = "hall/deuce_k.wad",
  map    = "MAP03",

  kind   = "terminator",
  group  = "deuce",
  key    = "barred",
  theme  = "!tech",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,
  deep   = 16,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
}

PREFABS.Hallway_deuce_barred_tech =
{
  template   = "Hallway_deuce_barred",
  map    = "MAP03",

  theme  = "tech",

  tex_SKINMET1 = "SHAWN2",
  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",

}
