PREFABS.Hallway_metro_locked_red =
{
  file   = "hall/metro_k.wad",
  map    = "MAP01",

  engine = "zdoom",

  kind   = "terminator",
  group  = "metro",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Hallway_metro_locked_blue =
{
  template = "Hallway_metro_locked_red",
  key      = "k_blue",
  line_33 = 32,

  tex_DOORRED = "DOORBLU",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Hallway_metro_locked_yellow =
{
  template = "Hallway_metro_locked_red",
  key      = "k_yellow",
  line_33 = 34,

  tex_DOORRED = "DOORYEL",

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Hallway_metro_barred =
{
  file   = "hall/metro_k.wad",
  map    = "MAP02",

  kind   = "terminator",
  group  = "metro",
  key    = "barred",

  engine = "zdoom",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  sector_1  = { [0]=90, [1]=15 }
}

-- slopeless engine fallbacks

PREFABS.Hallway_metro_barred_boxy =
{
  template = "Hallway_metro_barred",
  map = "MAP10",

  engine = "any",
  theme = "!hell",

  prob = 10,

  tex_SPCDOOR2 = "SPCDOOR1",
}

PREFABS.Hallway_metro_barred_boxy_hell =
{
  template = "Hallway_metro_barred",
  map = "MAP10",

  engine = "any",
  theme = "hell",

  prob = 10,

  tex_SPCDOOR1 = "SW1SKIN",
  tex_SPCDOOR2 = "SW2SKIN",
}

---- tech/urban versions

PREFABS.Hallway_metro_locked_red_boxy =
{
  template = "Hallway_metro_locked_red",
  map = "MAP11",

  engine = "any",
  theme = "!hell",

  prob = 10,
}

PREFABS.Hallway_metro_locked_blue_boxy =
{
  template = "Hallway_metro_locked_red",
  map = "MAP11",

  engine = "any",
  theme = "!hell",

  key = "k_blue",
  line_33 = 32,

  tex_DOORRED = "DOORBLU",

  prob = 10,
}

PREFABS.Hallway_metro_locked_yellow_boxy =
{
  template = "Hallway_metro_locked_red",
  map = "MAP11",

  engine = "any",
  theme = "!hell",

  key = "k_yellow",
  line_33 = 34,

  tex_DOORRED = "DOORYEL",

  prob = 10,
}

---- hell versions

PREFABS.Hallway_metro_locked_red_boxy_hell =
{
  template = "Hallway_metro_locked_red",
  map = "MAP11",

  engine = "any",
  theme = "hell",

  tex_BIGDOOR1 = "BIGDOOR6",
  tex_DOORRED = "DOORRED2",
  flat_FLAT23 = "CEIL5_1",

  prob = 10,
}

PREFABS.Hallway_metro_locked_blue_boxy_hell =
{
  template = "Hallway_metro_locked_red",
  map = "MAP11",

  engine = "any",
  theme = "hell",

  key = "k_blue",
  line_33 = 32,

  tex_DOORRED = "DOORBLU2",
  tex_BIGDOOR1 = "BIGDOOR6",
  flat_FLAT23 = "CEIL5_1",

  prob = 10,
}

PREFABS.Hallway_metro_locked_yellow_boxy_hell =
{
  template = "Hallway_metro_locked_red",
  map = "MAP11",

  engine = "any",
  theme = "hell",

  key = "k_yellow",
  line_33 = 34,

  tex_DOORRED = "DOORYEL2",
  tex_BIGDOOR1 = "BIGDOOR6",
  flat_FLAT23 = "CEIL5_1",

  prob = 10,
}
