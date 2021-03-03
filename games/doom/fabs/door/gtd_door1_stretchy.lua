PREFABS.Door_plain_tech_stretchy_silver =
{
  file   = "door/gtd_door1_stretchy.wad",
  map    = "MAP01",

  prob   = 75,

  theme = "!hell",

  kind   = "arch",
  style  = "doors",

  where  = "edge",
  seed_w = 2,

  deep   = 32,
  over   = 32,

  x_fit = {40,56 , 200,216},

  bound_z1 = 0,
  bound_z2 = 128,

  flat_TLITE6_6 = { TLITE6_6=50, TLITE6_5=50 },
  tex_BIGDOOR1 =
  {
    BIGDOOR1 = 1,
    BIGDOOR2 = 1,
  },
  tex_COMPSTA1 =
  {
    SPCDOOR2 = 1,
    SPCDOOR3 = 1,
  },

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=10, [12]=5, [13]=5 }
}

PREFABS.Door_plain_tech_stretchy_brown =
{
  template = "Door_plain_tech_stretchy_silver",

  tex_BIGDOOR1 =
  {
    BIGDOOR3 = 1,
    BIGDOOR4 = 1,
  },
  tex_COMPSTA1 =
  {
    SPCDOOR1 = 1,
    SPCDOOR4 = 1,
  }
}

PREFABS.Door_plain_hell_stretchy =
{
  template = "Door_plain_tech_stretchy_silver",

  theme = "hell",

  tex_BIGDOOR1 =
  {
    BIGDOOR5 = 1,
    BIGDOOR6 = 1,
    BIGDOOR7 = 1,
  },
  tex_COMPSTA1 = "BIGDOOR5",
}
