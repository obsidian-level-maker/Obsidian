PREFABS.Door_armaetus_door1 =
{
  file   = "door/armaetus_door1.wad",
  map    = "MAP01",

  texture_pack = "armaetus",

  prob   = 20,

  theme  = "!hell",

  where  = "edge",
  key    = "barred",

  seed_w = 2,

  deep   = 32,
  over   = 32,

  x_fit  = { 112,144 },

  bound_z1 = 0,
  bound_z2 = 128,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",

  tex_DOORHI =
  {
    DOORHI = 50,
    URBAN6 = 50,
    URBAN8 = 50,
  }
}

PREFABS.Door_armaetus_door_KEYRED =
{
  file   = "door/armaetus_door1.wad",
  map    = "MAP02",

  texture_pack = "armaetus",

  prob   = 50,

  theme  = "!hell",

  where  = "edge",
  key    = "k_red",

  seed_w = 2,

  deep   = 32,
  over   = 32,

  x_fit  = { 112,144 },

  bound_z1 = 0,
  bound_z2 = 128,

  tex_DOORHI =
  {
    DOORHI = 50,
    URBAN6 = 50,
    URBAN8 = 50,
  }
}

PREFABS.Door_armaetus_door_KEYBLUE =
{
  template = "Door_armaetus_door_KEYRED",
  map    = "MAP02",

  key    = "k_blue",

  line_33 = 32,

  tex_DOORRED = "DOORBLU",
}

PREFABS.Door_armaetus_door_KEYYELLOW =
{
  template = "Door_armaetus_door_KEYRED",
  map    = "MAP02",

  key    = "k_yellow",

  line_33 = 34,

  tex_DOORRED = "DOORYEL",
}
