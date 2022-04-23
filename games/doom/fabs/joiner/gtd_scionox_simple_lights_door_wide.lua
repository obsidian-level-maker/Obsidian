PREFABS.Joiner_gtd_sc_simple_door_lights =
{
  file = "joiner/gtd_scionox_simple_lights_door_wide.wad",
  map = "MAP01",

  prob = 200,

  theme = "!hell",
  where = "seeds",
  shape = "I",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = 16,

  x_fit = { 72,88 , 96,160 , 168,184 },
  y_fit = "frame",

  tex_SPCDOOR3 = { SPCDOOR1=50, SPCDOOR2=50, SPCDOOR3=50, SPCDOOR4=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLAT14=50, FLOOR0_3=50, FLAT5=50, SLIME14=50, SLIME16=50 },
}

PREFABS.Joiner_gtd_sc_simple_door_lights_hell =
{
  template = "Joiner_gtd_sc_simple_door_lights",
  map = "MAP02",

  theme = "hell",

  thing_2028 = 35

  tex_WOODMET1 = { WOODMET1=50, WOODMET2=50, WOOD4=25, BIGDOOR5=25 },
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 }
}

--

PREFABS.Joiner_gtd_sc_simple_door_lights_k_red =
{
  template = "Joiner_gtd_sc_simple_door_lights",
  map = "MAP03",

  key = "k_red",

  tex_SPCDOOR3 = { SPCDOOR1=50, SPCDOOR2=50, SPCDOOR3=50, SPCDOOR4=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLAT14=50, FLOOR0_3=50, FLAT5=50, SLIME14=50, SLIME16=50 },
}

PREFABS.Joiner_gtd_sc_simple_door_lights_k_yellow =
{
  template = "Joiner_gtd_sc_simple_door_lights",
  map = "MAP03",

  key = "k_yellow",

  tex_SPCDOOR3 = { SPCDOOR1=50, SPCDOOR2=50, SPCDOOR3=50, SPCDOOR4=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLAT14=50, FLOOR0_3=50, FLAT5=50, SLIME14=50, SLIME16=50 },
  tex_DOORRED = "DOORYEL",

  line_33 = 34
}

PREFABS.Joiner_gtd_sc_simple_door_lights_k_blue =
{
  template = "Joiner_gtd_sc_simple_door_lights",
  map = "MAP03",

  key = "k_blue",

  tex_SPCDOOR3 = { SPCDOOR1=50, SPCDOOR2=50, SPCDOOR3=50, SPCDOOR4=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLAT14=50, FLOOR0_3=50, FLAT5=50, SLIME14=50, SLIME16=50 },
  tex_DOORRED = "DOORBLU",

  line_33 = 32
}

--

PREFABS.Joiner_gtd_sc_simple_door_lights_k_red_hell =
{
  template = "Joiner_gtd_sc_simple_door_lights",
  map = "MAP04",

  theme = "hell",
  key = "k_red",

  thing_35 = { [57]=1, [46]=1 },

  tex_WOODMET1 = { WOODMET1=50, WOODMET2=50, WOOD4=25, BIGDOOR5=25 },
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 }
}

PREFABS.Joiner_gtd_sc_simple_door_lights_k_yellow_hell =
{
  template = "Joiner_gtd_sc_simple_door_lights",
  map = "MAP04",

  theme = "hell",
  key = "k_yellow",

  thing_35 = { [56]=1, [45]=1 },

  tex_WOODMET1 = { WOODMET1=50, WOODMET2=50, WOOD4=25, BIGDOOR5=25 },
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },

  line_33 = 34
}

PREFABS.Joiner_gtd_sc_simple_door_lights_k_blue_hell =
{
  template = "Joiner_gtd_sc_simple_door_lights",
  map = "MAP04",

  theme = "hell",
  key = "k_blue",

  thing_35 = { [55]=1, [44]=1 },

  tex_WOODMET1 = { WOODMET1=50, WOODMET2=50, WOOD4=25, BIGDOOR5=25 },
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },

  line_33 = 32
}
