--
-- 2-seed-wide hallway : locked terminators
--

PREFABS.Hallway_deuce_locked_yellow =
{
  file   = "hall/deuce_k.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "deuce",
  key    = "kz_yellow",

  

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}

PREFABS.Hallway_deuce_locked_red =
{
  template  = "Hallway_deuce_locked_yellow",
  map    = "MAP01",
  key = "kz_red",

  line_34 = 33,
  tex_HW511 = "HW510",
}


PREFABS.Hallway_deuce_locked_blue =
{
  template = "Hallway_deuce_locked_yellow",
  map  = "MAP01",
  key  = "kz_blue",

  line_34 = 32,
  tex_HW511 = "HW512",
}


----------------------------------------------------------------

PREFABS.Hallway_deuce_barred =
{
  file   = "hall/deuce_k.wad",
  map    = "MAP03",

  

  kind   = "terminator",
  group  = "deuce",
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
