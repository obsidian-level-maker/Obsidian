--
-- Outdoor start platform
--

PREFABS.Start_sky_pad =
{
  file   = "start/sky_pad.wad"
  map    = "MAP01"

  rank   = 2
  prob   = 50
  theme  = "tech"

  env    = "outdoor"
  open_to_sky = 1

  where  = "seeds"
  seed_w = 2
  seed_h = 2

  x_fit  = { 72,80, 176,184 }
}


PREFABS.Start_sky_pad_hell =
{
  template = "Start_sky_pad"

  theme  = "!tech"

  -- replace the lamps
  thing_2028 = "candelabra"

  -- texture replacements
  tex_STEP1   = "STEP4"
  tex_STARBR2 = "GSTONE1"
  tex_BROWN1  = "STONE2"

  flat_FLOOR4_1 = "MFLR8_1"
}

