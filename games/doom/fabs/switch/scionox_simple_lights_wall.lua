PREFABS.Switch_scionox_simple_lights_wall =
{
  file   = "switch/scionox_simple_lights_wall.wad",
  map = "MAP01",
  prob   = 50,

  theme = "tech",
  where  = "seeds",
  key = "sw_metal",

  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?switch_tag",
  tex_SW1BRN2 = { SW1BRN2=50, SW1BRNGN=50, SW1COMP=50, SW1GRAY=50, SW1GRAY1=50, SW1METAL=50, SW1STRTN=50, SW1TEK=50 },
}

PREFABS.Switch_scionox_simple_lights_wall_2 =
{
  template = "Switch_scionox_simple_lights_wall",
  theme  = "urban",
  tex_SW1BRN2 = { SW1BRIK=50, SW1CMT=50, SW1MOD1=50, SW1GRAY=50, SW1GRAY1=50, SW1SLAD=50, SW1STON1=50, SW1STON6=50, SW1VINE=50 },
}

PREFABS.Switch_scionox_simple_lights_wall_3 =
{
  template = "Switch_scionox_simple_lights_wall",
  theme  = "hell",
  tex_SW1BRN2 = { SW1GARG=50, SW1LION=50, SW1SATYR=50, SW1GSTON=50, SW1HOT=50, SW1WOOD=50, SW1PANEL=50, SW1ROCK=50, SW1SKIN=50, SW1WDMET=50 },
  tex_LITE5 = { FIREWALA=50, FIREBLU1=50, BFALL1=50 },
  tex_DOORSTOP = "METAL",
}

PREFABS.Switch_scionox_simple_lights_wall_4 =
{
  template = "Switch_scionox_simple_lights_wall",
  map = "MAP02",
}

PREFABS.Switch_scionox_simple_lights_wall_5 =
{
  template = "Switch_scionox_simple_lights_wall",
  map = "MAP02",
  theme  = "urban",
  tex_SW1BRN2 = { SW1BRIK=50, SW1CMT=50, SW1MOD1=50, SW1GRAY=50, SW1GRAY1=50, SW1SLAD=50, SW1STON1=50, SW1STON6=50, SW1VINE=50 },
  thing_2028 =
  {
    mercury_lamp = 50,
    mercury_small = 50,
    burning_barrel = 25,
  },
}

PREFABS.Switch_scionox_simple_lights_wall_6 =
{
  template = "Switch_scionox_simple_lights_wall",
  map = "MAP02",
  theme  = "hell",
  tex_SW1BRN2 = { SW1GARG=50, SW1LION=50, SW1SATYR=50, SW1GSTON=50, SW1HOT=50, SW1WOOD=50, SW1PANEL=50, SW1ROCK=50, SW1SKIN=50, SW1WDMET=50 },
  thing_2028 =
  {
    blue_torch   = 50,
    green_torch = 50,
    red_torch = 50,
    blue_torch_sm   = 50,
    green_torch_sm = 50,
    red_torch_sm = 50,
  },
}

PREFABS.Switch_scionox_simple_lights_wall_7 =
{
  template = "Switch_scionox_simple_lights_wall",
  map = "MAP03",
  tex_SUPPORT3 = "SILVER2",
  thing_2028 =
  {
    lamp = 50,
    tech_column = 50,
  },
}

PREFABS.Switch_scionox_simple_lights_wall_8 =
{
  template = "Switch_scionox_simple_lights_wall",
  map = "MAP03",
  theme  = "urban",
  tex_SW1BRN2 = { SW1BRIK=50, SW1CMT=50, SW1MOD1=50, SW1GRAY=50, SW1GRAY1=50, SW1SLAD=50, SW1STON1=50, SW1STON6=50, SW1VINE=50 },
  thing_2028 =
  {
    mercury_lamp = 50,
    mercury_small = 50,
    burning_barrel = 25,
  },
}

PREFABS.Switch_scionox_simple_lights_wall_9 =
{
  template = "Switch_scionox_simple_lights_wall",
  map = "MAP03",
  theme  = "hell",
  tex_SW1BRN2 = { SW1GARG=50, SW1LION=50, SW1SATYR=50, SW1GSTON=50, SW1HOT=50, SW1WOOD=50, SW1PANEL=50, SW1ROCK=50, SW1SKIN=50, SW1WDMET=50 },
  thing_2028 =
  {
    candelabra   = 50,
    skull_rock = 50,
    skull_cairn = 50,
  },
}

PREFABS.Switch_scionox_simple_lights_wall_10 =
{
  template = "Switch_scionox_simple_lights_wall",
  map = "MAP04",
  theme  = "!tech",
}

PREFABS.Switch_scionox_simple_lights_wall_11 =
{
  template = "Switch_scionox_simple_lights_wall",
  map = "MAP05",
  theme  = "urban",
  tex_SW1BRN2 = { SW1BRIK=50, SW1CMT=50, SW1MOD1=50, SW1GRAY=50, SW1GRAY1=50, SW1SLAD=50, SW1STON1=50, SW1STON6=50, SW1VINE=50 },
  thing_2028 =
  {
    mercury_lamp = 50,
    burning_barrel = 50,
    blue_torch   = 25,
    green_torch = 25,
    red_torch = 25,
  },
}

PREFABS.Switch_scionox_simple_lights_wall_12 =
{
  template = "Switch_scionox_simple_lights_wall",
  map = "MAP05",
  theme  = "hell",
  tex_SW1BRN2 = { SW1GARG=50, SW1LION=50, SW1SATYR=50, SW1GSTON=50, SW1HOT=50, SW1WOOD=50, SW1PANEL=50, SW1ROCK=50, SW1SKIN=50, SW1WDMET=50 },
  thing_2028 =
  {
    evil_eye   = 75,
    skull_rock = 25,
    skull_cairn = 25,
    candelabra = 25,
  },
}
