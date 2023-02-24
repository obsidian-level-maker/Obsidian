PREFABS.Switch_scionox_simple_lights =
{
  file   = "switch/scionox_simple_lights.wad",

  map    = "MAP01",
  theme  = "tech",
  key = "sw_metal",

  prob   = 50,

  where  = "point",

  tag_1  = "?switch_tag",
}

PREFABS.Switch_scionox_simple_lights_2 =
{
  template = "Switch_scionox_simple_lights",
  theme  = "urban",

  tex_SW1TEK = "SW1SLAD",
  tex_TEKGREN2 = "SLADWALL",
  thing_2028 = "mercury_small",
}

PREFABS.Switch_scionox_simple_lights_3 =
{
  template = "Switch_scionox_simple_lights",
  theme  = "hell",

  tex_SW1TEK = "SW1PANEL",
  tex_TEKGREN2 = "PANCASE2",
  thing_2028 = "candelabra",
}

PREFABS.Switch_scionox_simple_lights_4 =
{
  template = "Switch_scionox_simple_lights",
  theme  = "urban",
  map    = "MAP02",
  thing_85 =
  {
    mercury_lamp = 50,
    burning_barrel = 25,
    blue_torch   = 15,
    green_torch = 15,
    red_torch = 15,
  },
}

PREFABS.Switch_scionox_simple_lights_5 =
{
  template = "Switch_scionox_simple_lights",
  theme  = "!tech",
  map    = "MAP03",
  thing_46 =
  {
    blue_torch   = 50,
    green_torch = 50,
    red_torch = 50,
  },
  thing_57 =
  {
    blue_torch_sm   = 50,
    green_torch_sm = 50,
    red_torch_sm = 50,
  },
}

PREFABS.Switch_scionox_simple_lights_6 =
{
  template = "Switch_scionox_simple_lights",
  theme  = "hell",
  map    = "MAP04",
  tex_SW1GARG = { SW1GARG=50, SW1LION=50, SW1SATYR=50 },
  thing_41 =
  {
    evil_eye   = 50,
    skull_rock = 50,
    skull_cairn = 50,
  },
}

PREFABS.Switch_scionox_simple_lights_7 =
{
  template = "Switch_scionox_simple_lights",
  theme  = "!tech",
  map    = "MAP05",
}
