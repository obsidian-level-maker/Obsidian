PREFABS.Door_EPIC_plain_tech =
{
  file   = "door/door1.wad",
  map    = "MAP02",

  texture_pack = "armaetus",

  prob   = 20,
  rank   = 1,

  style  = "doors",

  where  = "edge",
  seed_w = 2,

  theme  = "tech",

  deep   = 32,
  over   = 32,

  x_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 128,

  flat_TLITE6_6 = { TLITE6_6=50, TLITE6_5=50 },

  tex_BIGDOOR_4 =
  {
    BIGDOORA = 50,
    BIGDOORC = 50,
    BIGDOORD = 50,
    BIGDOORF = 50,
    BIGDOORG = 50,
    BIGDOORH = 50,
    BIGDOORL = 50,
  },

  tex_CEIL5_1 =
  {
    CEIL5_1 = 50,
    CEIL5_2 = 50,
  },

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 }
}

PREFABS.Door_EPIC_plain_urban =
{
  template = "Door_EPIC_plain_tech",

  theme  = "urban",

  flat_TLITE6_6 = { TLITE6_6=50, TLITE6_5=50 },

  tex_BIGDOOR_4 =
  {
    BIGDOOR0 = 50,
    BIGDOOR8 = 50,
    BIGDOORE = 50,
    BIGDOORI = 50,
    BIGDOORJ = 50,
    BIGDOORK = 50,
    BIGDOORA = 50,
    BIGDOORC = 50,
    BIGDOORD = 50,
    BIGDOORF = 50,
    BIGDOORG = 50,
    BIGDOORH = 50,
    BIGDOORL = 50,
  }
}

PREFABS.Door_EPIC_plain_hell =
{
  template = "Door_EPIC_plain_tech",

  flat_TLITE6_6 = "_WALL",

  tex_COMPSPAN = "_WALL",

  tex_BIGDOOR_4 =
  {
    BIGDOOR0 = 50,
    BIGDOOR8 = 50,
    BIGDOOR9 = 50,
    BIGDOORE = 50,
    BIGDOORI = 50,
    BIGDOORJ = 50,
    BIGDOORK = 50,
    BIGDOORN = 50,
  }
}
