-- Simple joiners that use light things

PREFABS.Joiner_scionox_simple_lights =
{
  file   = "joiner/scionox_simple_lights.wad",
  map    = "MAP01",

  prob   = 250,
  theme  = "tech",

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = { 32,96 },
  y_fit  = { 16,24 , 112,136 },

  flat_FLOOR4_6 = { FLOOR4_6=50, FLOOR0_2=50, FLOOR5_2=50, FLAT5=50 },
  flat_CEIL3_3 = { CEIL3_3=50, FLOOR7_1=50 },
}

PREFABS.Joiner_scionox_simple_lights_2 =
{
  template = "Joiner_scionox_simple_lights",
  map    = "MAP02",
  theme  = "urban",

  flat_FLAT5_2 = { FLAT5_2=50, FLAT5_1=50, FLAT5_5=50, RROCK15=50 },
  flat_CEIL1_1 = { CEIL1_1=50, FLOOR7_1=50 },

  y_fit = { 24,56 , 104,136 },
}

PREFABS.Joiner_scionox_simple_lights_3 =
{
  template = "Joiner_scionox_simple_lights",
  map    = "MAP03",
  theme  = "hell",

  x_fit = { 32,96 },
  y_fit = { 24,64 , 96,136 },
}

PREFABS.Joiner_scionox_simple_lights_4 =
{
  file   = "joiner/scionox_simple_lights.wad",
  map    = "MAP04",

  prob   = 250,
  theme  = "tech",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = { 64,192 },
  y_fit  = { 24,48 , 240,264 },
}

PREFABS.Joiner_scionox_simple_lights_5 =
{
  template = "Joiner_scionox_simple_lights_4",
  texture_pack = "armaetus",
  tex_COMPBLUE = "COMPRED",
  flat_FLAT14 = "FLAT15",
  flat_CEIL4_2 = "TEK1",
}

PREFABS.Joiner_scionox_simple_lights_6 =
{
  template = "Joiner_scionox_simple_lights_4",
  texture_pack = "armaetus",
  tex_COMPBLUE = "COMPGREN",
  flat_FLAT14 = "GRENFLOR",
  flat_CEIL4_2 = "TEK2",
}

PREFABS.Joiner_scionox_simple_lights_7 =
{
  template = "Joiner_scionox_simple_lights_4",
  map    = "MAP05",
  theme  = "urban",

  flat_RROCK15 = { RROCK09=50, RROCK10=50, RROCK12=50, RROCK15=50 },

  x_fit = { 40,96 , 160,216 },
  y_fit = { 24,32 , 256,264 },
}

PREFABS.Joiner_scionox_simple_lights_8 =
{
  template = "Joiner_scionox_simple_lights_4",
  map    = "MAP06",
  theme  = "hell",

  x_fit = { 40,216 },
  y_fit = { 20,28 , 260,268 },
}
