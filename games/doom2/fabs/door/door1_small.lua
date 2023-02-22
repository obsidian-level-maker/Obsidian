PREFABS.Door_small_vanilla =
{
  file = "door/door1.wad",

  map  = "MAP01",

  theme = "!hell",

  prob = 200,

  style = "doors",

  kind  = "arch",
  where = "edge",
  seed_w = 2,

  deep = 32,
  over = 32,

  x_fit = "frame",

  bound_z1 = 0,
  bound_z2 = 128,

  flat_TLITE6_6 = { TLITE6_6=50, TLITE6_5=50 },

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 },

  tex_DOOR3 =
  {
    DOOR3 = 50,
    DOOR1 = 50,
    SPCDOOR1 = 25,
    SPCDOOR2 = 25,
    SPCDOOR3 = 50,
    SPCDOOR4 = 25,
  }
}

PREFABS.Door_small_vanilla_gothic =
{
  template = "Door_small_vanilla",

  theme = "hell",

  flat_FLAT23 = "CEIL5_2",

  tex_DOOR3 =
  {
    WOODGARG = 1,
    WOODMET1 = 1,
    WOODMET2 = 1,
    DOOR3 = 1,
    SW1PANEL = 1,
    SW1GARG = 0.3,
    SW1LION = 0.3,
    SW1SATYR = 0.3,
    SW1WOOD = 0.3,
  }
}
