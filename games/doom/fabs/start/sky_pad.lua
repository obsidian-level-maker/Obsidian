--
-- Outdoor start platform
--

PREFABS.Start_sky_pad =
{
  file   = "start/sky_pad.wad",
  map    = "MAP01",

  rank   = 2,
  prob   = 100,
  theme  = "tech",

  env    = "outdoor",
  open_to_sky = 1,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  x_fit  = { 72,80, 176,184 },

  thing_2028 =
  {
  lamp = 50,
  mercury_lamp = 50,
  mercury_small = 50,
  },

  tex_STARBR2 = { SHAWN2=50, METAL2=50, STARBR2=50, TEKWALL4=50, STARGR1=50, STONE=50 },
  flat_FLOOR4_1 = { FLOOR4_1=50, FLOOR4_5=50, FLOOR4_6=50 },

}


PREFABS.Start_sky_pad_hell =
{
  template = "Start_sky_pad",

  theme  = "hell",

  -- replace the lamps
  thing_2028 =
  {
  red_torch = 50,
  blue_torch = 50,
  green_torch = 50,
  candelabra = 50,
  evil_eye = 50,
  skull_cairn = 50,
  },

  -- texture replacements
  tex_STEP1   = "STEP4",
  tex_STARBR2 = { GSTONE1=50, GSTVINE1=50, GSTVINE2=50, SP_HOT1=50, ASHWALL2=50, ASHWALL4=50, ASHWALL6=50, ASHWALL7=50 },
  tex_BROWN1  = { STONE2=50, STONE3=50, STONE4=50 },

  flat_FLOOR4_1 = "FLAT1",
}

PREFABS.Start_sky_pad_urban =
{
  template = "Start_sky_pad",

  theme  = "urban",

  thing_2028 =
  {
  lamp = 50,
  mercury_lamp = 50,
  mercury_small = 50,
  red_torch = 50,
  blue_torch = 50,
  green_torch = 50,
  candelabra = 50,
  burning_barrel = 50,
  },

  -- texture replacements
  tex_STEP1   = "STEP4",
  tex_STARBR2 = { GSTONE1=50, GSTVINE1=50, GSTVINE2=50, SP_HOT1=50 },
  tex_BROWN1  = { STONE2=50, STONE3=50, STONE4=50, STONE5=50 },

  flat_FLOOR4_1 = "FLAT1",
}
