-- doors w light objects

PREFABS.Joiner_scionox_simple_lights_door =
{
  file   = "joiner/scionox_simple_lights_door.wad",
  map    = "MAP01",

  prob   = 150,
  theme  = "tech",
  style  = "doors",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  tex_DOOR1 = { DOOR1=50, DOOR3=50, SPCDOOR1=50, SPCDOOR2=50, SPCDOOR3=50, SPCDOOR4=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLAT14=50, FLOOR0_3=50, FLAT5=50, SLIME14=50, SLIME16=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_2 =
{
  template = "Joiner_scionox_simple_lights_door",
  theme  = "urban",
  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_3 =
{
  template = "Joiner_scionox_simple_lights_door",
  theme  = "hell",
  map    = "MAP03",
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_4 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP02",
  key = "sw_metal",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}

PREFABS.Joiner_scionox_simple_lights_door_5 =
{
  template = "Joiner_scionox_simple_lights_door",
  theme  = "urban",
  map    = "MAP02",
  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
  key = "sw_metal",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}

PREFABS.Joiner_scionox_simple_lights_door_6 =
{
  template = "Joiner_scionox_simple_lights_door",
  theme  = "hell",
  map    = "MAP04",
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
  key = "sw_metal",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}

PREFABS.Joiner_scionox_simple_lights_door_7 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP05",
  key = "k_red",
}

PREFABS.Joiner_scionox_simple_lights_door_8 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP05",
  key = "k_blue",
  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}

PREFABS.Joiner_scionox_simple_lights_door_9 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP05",
  key = "k_yellow",
  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}

PREFABS.Joiner_scionox_simple_lights_door_10 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP05",
  key = "k_red",
  theme  = "urban",
  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_11 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP05",
  key = "k_blue",
  tex_DOORRED = "DOORBLU",
  line_33     = 32,
  theme  = "urban",
  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_12 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP05",
  key = "k_yellow",
  tex_DOORRED = "DOORYEL",
  line_33     = 34,
  theme  = "urban",
  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_13 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP06",
  key = "ks_red",
  theme  = "hell",
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
  tex_WOODGARG = { WOODGARG=50, WOOD4=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_14 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP06",
  key = "ks_blue",
  theme  = "hell",
  tex_DOORRED2 = "DOORBLU2",
  line_33     = 32,
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
  tex_WOODGARG = { WOODGARG=50, WOOD4=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_15 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP06",
  key = "ks_yellow",
  theme  = "hell",
  tex_DOORRED2 = "DOORYEL2",
  line_33     = 34,
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
  tex_WOODGARG = { WOODGARG=50, WOOD4=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_16 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP07",

  key    = "k_ALL",
}

PREFABS.Joiner_scionox_simple_lights_door_17 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP07",

  key    = "k_ALL",

  theme  = "urban",

  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_18 =
{
  template = "Joiner_scionox_simple_lights_door",
  map    = "MAP08",

  key    = "k_ALL",

  theme  = "hell",

  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
  tex_WOODGARG = { WOODGARG=50, WOOD4=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_19 =
{
  file   = "joiner/scionox_simple_lights_door.wad",
  map    = "MAP09",

  prob   = 150,
  theme  = "tech",
  style  = "doors",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  tex_BIGDOOR2 = { BIGDOOR2=50, BIGDOOR3=50, BIGDOOR4=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLAT14=50, FLOOR0_3=50, FLAT5=50, SLIME14=50, SLIME16=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_20 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  theme  = "urban",
  thing_2028 = "mercury_small",
  tex_SUPPORT2 = "SUPPORT3",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_21 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  theme  = "hell",
  thing_2028 = "candelabra",
  tex_SUPPORT2 = "SUPPORT3",
  tex_BIGDOOR2 = { BIGDOOR5=50, BIGDOOR7=50, WOODGARG=50, WOODMET2=50 },
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_22 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP10",
  key = "sw_metal",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}

PREFABS.Joiner_scionox_simple_lights_door_23 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  theme  = "urban",
  map    = "MAP10",
  key = "sw_metal",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_24 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  theme  = "hell",
  map    = "MAP10",
  key = "sw_metal",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
  thing_2028 = "candelabra",
  tex_METAL2 = "WOOD8",
  tex_BIGDOOR2 = { BIGDOOR5=50, BIGDOOR7=50, WOODGARG=50, WOODMET2=50 },
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_25 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP11",
  key = "k_red",
}

PREFABS.Joiner_scionox_simple_lights_door_26 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP11",
  key = "k_blue",
  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}

PREFABS.Joiner_scionox_simple_lights_door_27 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP11",
  key = "k_yellow",
  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}

PREFABS.Joiner_scionox_simple_lights_door_28 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP11",
  key = "k_red",
  theme  = "urban",
  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_29 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP11",
  key = "k_blue",
  theme  = "urban",
  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}

PREFABS.Joiner_scionox_simple_lights_door_30 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP11",
  key = "k_yellow",
  theme  = "urban",
  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}

PREFABS.Joiner_scionox_simple_lights_door_31 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP11",
  key = "ks_red",
  theme  = "hell",
  thing_2028 = "candelabra",
  tex_BIGDOOR2 = { BIGDOOR5=50, BIGDOOR7=50, WOODGARG=50, WOODMET2=50 },
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
  tex_DOORRED = "DOORRED2",
}

PREFABS.Joiner_scionox_simple_lights_door_32 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP11",
  key = "ks_blue",
  theme  = "hell",
  thing_2028 = "candelabra",
  tex_BIGDOOR2 = { BIGDOOR5=50, BIGDOOR7=50, WOODGARG=50, WOODMET2=50 },
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
  tex_DOORRED = "DOORBLU2",
  line_33     = 32,
}

PREFABS.Joiner_scionox_simple_lights_door_33 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP11",
  key = "ks_yellow",
  theme  = "hell",
  thing_2028 = "candelabra",
  tex_BIGDOOR2 = { BIGDOOR5=50, BIGDOOR7=50, WOODGARG=50, WOODMET2=50 },
  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
  tex_DOORRED = "DOORYEL2",
  line_33     = 34,
}

PREFABS.Joiner_scionox_simple_lights_door_34 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP12",

  key    = "k_ALL",
}

PREFABS.Joiner_scionox_simple_lights_door_35 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP12",

  key    = "k_ALL",

  theme  = "urban",

  thing_2028 = "mercury_small",
  flat_FLOOR4_6 = { FLAT5_1=50, FLAT19=50, FLAT5_5=50, FLOOR7_1=50, SLIME13=50, RROCK15=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_36 =
{
  template = "Joiner_scionox_simple_lights_door_19",
  map    = "MAP12",

  key    = "k_ALL",

  theme  = "hell",

  thing_2028 = "candelabra",

  flat_FLOOR4_6 = { DEM1_6=50, FLAT1_1=50, FLAT5_3=50, FLOOR7_2=50, RROCK09=50, RROCK11=50 },
  tex_BIGDOOR2 = { BIGDOOR5=50, BIGDOOR7=50, WOODGARG=50, WOODMET2=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_37 =
{
  file   = "joiner/scionox_simple_lights_door.wad",
  map    = "MAP13",

  prob   = 150,
  theme  = "!tech",
  key = "k_red",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = { 132,252 },
  y_fit  = "frame",

  tex_BIGDOOR5 = { BIGDOOR5=50, BIGDOOR7=50 },
  tex_WOOD1 = { WOOD1=50, WOOD12=50, WOOD3=50, WOOD5=50, WOOD6=50, WOODVERT=50 },
  flat_FLAT5_2 = { FLAT5_2=50, FLAT5_1=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_38 =
{
  template = "Joiner_scionox_simple_lights_door_37",
  key = "k_blue",

  thing_46 = "blue_torch",
  thing_57 = "blue_torch_sm",
  line_33     = 32,

  tex_DOORRED2 = "DOORBLU2",
}

PREFABS.Joiner_scionox_simple_lights_door_39 =
{
  template = "Joiner_scionox_simple_lights_door_37",
  key = "k_yellow",

  thing_46 = "green_torch",
  thing_57 = "green_torch_sm",
  line_33     = 34,

  tex_DOORRED2 = "DOORYEL2",
}

PREFABS.Joiner_scionox_simple_lights_door_40 =
{
  template = "Joiner_scionox_simple_lights_door_37",
  map    = "MAP14",

  key    = "k_ALL",
}

PREFABS.Joiner_scionox_simple_lights_door_41 =
{
  file   = "joiner/scionox_simple_lights_door.wad",
  map    = "MAP15",

  prob   = 150,
  theme  = "tech",
  style  = "doors",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = { 40,88 , 168,216 },
  y_fit  = "frame",

  tex_SPCDOOR1 = { SPCDOOR1=50, SPCDOOR2=50, SPCDOOR3=50, SPCDOOR4=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_42 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  theme  = "urban",
  thing_48 =
  {
    mercury_lamp = 50,
    burning_barrel = 25,
  },
}

PREFABS.Joiner_scionox_simple_lights_door_43 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  theme  = "hell",
  thing_48 =
  {
    evil_eye   = 75,
    skull_rock = 25,
    skull_cairn = 25,
    candelabra = 25,
  },
  tex_SPCDOOR1 = { WOODGARG=50, WOOD4=50, WOODMET2=50, SPCDOOR4=50 },
  tex_LITE3 = { FIREWALA=50, FIREBLU1=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_44 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP16",
  key = "sw_metal",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}

PREFABS.Joiner_scionox_simple_lights_door_45 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP16",
  theme  = "urban",
  key = "sw_metal",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
  thing_48 =
  {
    mercury_lamp = 50,
    burning_barrel = 25,
  },
}

PREFABS.Joiner_scionox_simple_lights_door_46 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP16",
  theme  = "hell",
  key = "sw_metal",
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
  thing_48 =
  {
    evil_eye   = 75,
    skull_rock = 25,
    skull_cairn = 25,
    candelabra = 25,
  },
  tex_SPCDOOR1 = { WOODGARG=50, WOOD4=50, WOODMET2=50, SPCDOOR4=50 },
  tex_TEKLITE = { REDWALL=50, METAL=50, SP_FACE2=50 },
}

PREFABS.Joiner_scionox_simple_lights_door_47 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP17",
  key = "k_red",
}

PREFABS.Joiner_scionox_simple_lights_door_48 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP17",
  key = "k_blue",
  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}

PREFABS.Joiner_scionox_simple_lights_door_49 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP17",
  key = "k_yellow",
  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}

PREFABS.Joiner_scionox_simple_lights_door_50 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP17",
  key = "k_red",
  theme  = "urban",
  thing_48 =
  {
    mercury_lamp = 50,
    burning_barrel = 25,
  },
}

PREFABS.Joiner_scionox_simple_lights_door_51 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP17",
  key = "k_blue",
  theme  = "urban",
  thing_48 =
  {
    mercury_lamp = 50,
    burning_barrel = 25,
  },
  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}

PREFABS.Joiner_scionox_simple_lights_door_52 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP17",
  key = "k_yellow",
  theme  = "urban",
  thing_48 =
  {
    mercury_lamp = 50,
    burning_barrel = 25,
  },
  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}

PREFABS.Joiner_scionox_simple_lights_door_53 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP17",
  theme  = "hell",
  key = "ks_red",
  thing_48 =
  {
    evil_eye   = 75,
    skull_rock = 25,
    skull_cairn = 25,
    candelabra = 25,
  },
  tex_SPCDOOR1 = { WOODGARG=50, WOOD4=50, WOODMET2=50, SPCDOOR4=50 },
  tex_DOORRED = "DOORRED2",
}

PREFABS.Joiner_scionox_simple_lights_door_54 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP17",
  theme  = "hell",
  key = "ks_blue",
  thing_48 =
  {
    evil_eye   = 75,
    skull_rock = 25,
    skull_cairn = 25,
    candelabra = 25,
  },
  tex_SPCDOOR1 = { WOODGARG=50, WOOD4=50, WOODMET2=50, SPCDOOR4=50 },
  tex_DOORRED = "DOORBLU2",
  line_33     = 32,
}

PREFABS.Joiner_scionox_simple_lights_door_55 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP17",
  theme  = "hell",
  key = "ks_yellow",
  thing_48 =
  {
    evil_eye   = 75,
    skull_rock = 25,
    skull_cairn = 25,
    candelabra = 25,
  },
  tex_SPCDOOR1 = { WOODGARG=50, WOOD4=50, WOODMET2=50, SPCDOOR4=50 },
  tex_DOORRED = "DOORYEL2",
  line_33     = 34,
}

PREFABS.Joiner_scionox_simple_lights_door_56 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP18",

  key    = "k_ALL",
}

PREFABS.Joiner_scionox_simple_lights_door_57 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP18",

  theme  = "urban",
  key    = "k_ALL",

  thing_48 =
  {
    mercury_lamp = 50,
    burning_barrel = 25,
  },
}

PREFABS.Joiner_scionox_simple_lights_door_58 =
{
  template = "Joiner_scionox_simple_lights_door_41",
  map    = "MAP18",

  theme  = "hell",
  key    = "k_ALL",

  thing_48 =
  {
    evil_eye   = 75,
    skull_rock = 25,
    skull_cairn = 25,
    candelabra = 25,
  },

  tex_SPCDOOR1 = { WOODGARG=50, WOOD4=50, WOODMET2=50, SPCDOOR4=50 },
  tex_DOORRED = "DOORRED2",
  tex_DOORBLU = "DOORBLU2",
  tex_DOORYEL = "DOORYEL2",
}

PREFABS.Joiner_scionox_simple_lights_door_59 =
{
  file   = "joiner/scionox_simple_lights_door.wad",
  map    = "MAP19",

  prob   = 150,
  theme  = "!tech",
  key = "sw_metal",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}
