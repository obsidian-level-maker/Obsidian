PREFABS.Joiner_EPIC_door2_tech =
{
  file   = "joiner/door2.wad",
  map    = "MAP03",

  texture_pack = "armaetus",

  prob   = 250,
  theme  = "tech",
  style  = "doors",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  tex_BIGDOOR2 =
  {
    BIGDOORA = 50,
    BIGDOORC = 50,
    BIGDOORD = 50,
    BIGDOORF = 50,
    BIGDOORG = 50,
    BIGDOORH = 50,
    BIGDOORL = 50,
  },

  flat_FLOOR0_3 = { FLOOR0_3=50, FLAT5_4=50, CEIL3_5=50, FLAT1=50 },

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7 },
}

PREFABS.Joiner_EPIC_door2_urban =
{
  template = "Joiner_EPIC_door2_tech",

  map = "MAP01",

  theme = "urban",

  tex_BIGDOOR4 =
  {
    BIGDOOR8 = 50,
    BIGDOOR9 = 50,
    BIGDOOR0 = 50,
    BIGDOORA = 50,
    BIGDOORB = 50,
    BIGDOORC = 50,
    BIGDOORD = 50,
    BIGDOORE = 50,
    BIGDOORF = 50,
    BIGDOORG = 50,
    BIGDOORH = 50,
    BIGDOORI = 50,
    BIGDOORJ = 50,
    BIGDOORK = 50,
    BIGDOORL = 50,
  },
}

PREFABS.Joiner_EPIC_door2_hell =
{
  template = "Joiner_EPIC_door2_tech",

  map = "MAP02",

  theme = "hell",

  tex_BIGDOOR6 =
  {
    BIGDOOR8 = 50,
    BIGDOOR9 = 50,
    BIGDOOR0 = 50,
    BIGDOORA = 50,
    BIGDOORB = 50,
    BIGDOORE = 50,
    BIGDOORI = 50,
    BIGDOORJ = 50,
    BIGDOORK = 50,
  },
}
