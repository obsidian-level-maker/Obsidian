PREFABS.Hallway_mineshaft_locked_red =
{
  file   = "hall/mineshaft_k.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "mineshaft",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,

  seed_w = 1,
  seed_h = 1,
}

PREFABS.Hallway_mineshaft_locked_blue =
{
  template = "Hallway_mineshaft_locked_red",

  key    = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}

PREFABS.Hallway_mineshaft_locked_yellow =
{
  template = "Hallway_mineshaft_locked_red",

  key    = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}

PREFABS.Hallway_mineshaft_barred =
{
  file   = "hall/mineshaft_k.wad",
  map    = "MAP02",

  kind   = "terminator",
  group  = "mineshaft",
  key    = "barred",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  seed_w = 1,
  seed_h = 1,
}
