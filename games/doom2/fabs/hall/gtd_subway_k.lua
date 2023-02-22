PREFABS.Hallway_subway_basic_keyed_red =
{
  file = "hall/gtd_subway_k.wad",
  map = "MAP01",

  kind = "terminator",

  group = "subway",
  prob = 50,
  key = "k_red",

  where  = "seeds",
  shape  = "I",

  deep = 16,

  seed_w = 2,
  seed_h = 1
}

PREFABS.Hallway_subway_basic_keyed_blue =
{
  template = "Hallway_subway_basic_keyed_red",

  key = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_33 = 32
}

PREFABS.Hallway_subway_basic_keyed_yellow =
{
  template = "Hallway_subway_basic_keyed_red",

  key = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_33 = 34
}

PREFABS.Hallway_subway_basic_keyed_barred =
{
  template = "Hallway_subway_basic_keyed_red",
  map = "MAP02",

  key    = "barred",

  tag_3  = "?door_tag",
  door_action = "S1_LowerFloor"
}
