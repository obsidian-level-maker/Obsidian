PREFABS.Locked_small_red =
{
  file   = "door/gtd_key_small.wad",
  map    = "MAP01",
  theme  = "!hell",

  prob   = 50,

  where  = "edge",
  key    = "k_red",

  seed_w = 2,

  deep   = 32,
  over   = 32,

  x_fit  = "frame",

  tex_DOOR3 =
  {
    DOOR3 = 50,
    DOOR1 = 50,
    SPCDOOR1 = 25,
    SPCDOOR2 = 25,
    SPCDOOR3 = 50,
    SPCDOOR4 = 25,
  }

  -- texture is already "DOORRED",
  -- line special is already #33,
}


PREFABS.Locked_small_blue =
{
  template = "Locked_small_red",

  key = "k_blue",

  tex_DOORRED = "DOORBLU",

  line_33 = 32,
}

PREFABS.Locked_small_yellow =
{
  template = "Locked_small_red",

  key = "k_yellow",
  tex_DOORRED = "DOORYEL",

  line_33 = 34,
}

PREFABS.Locked_small_red_hell =
{
  template = "Locked_small_red",
  theme = "hell",

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
  },
  flat_TLITE6_6 = "TLITE6_5",
  tex_DOORRED = "DOORRED2",
}

PREFABS.Locked_small_blue_hell =
{
  template = "Locked_small_red",
  theme = "hell",

  key = "k_blue",

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
  },
  flat_TLITE6_6 = "TLITE6_5",
  tex_DOORRED = "DOORBLU2",

  line_33 = 32,
}

PREFABS.Locked_small_yellow_hell =
{
  template = "Locked_small_red",
  theme = "hell",

  key = "k_yellow",

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
  },
  flat_TLITE6_6 = "TLITE6_5",
  tex_DOORRED = "DOORYEL2",

  line_33 = 34,
}
