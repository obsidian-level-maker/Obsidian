-- quake-inspired portal start

PREFABS.Start_scionox_quakeish_portal_start =
{
  file   = "start/scionox_quakeish_portal_start.wad",
  map    = "MAP01",

  prob   = 250,

  theme = "urban",
  engine  = "zdoom",

  where  = "seeds",

  texture_pack = "armaetus",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top",
}

PREFABS.Start_scionox_quakeish_portal_start_2 =
{
  template = "Start_scionox_quakeish_portal_start",
  theme = "hell",
  thing_85 =
  {
    skull_pole = 50,
    skull_kebab = 50,
    evil_eye   = 50,
    impaled_human = 50,
    impaled_twitch = 50,
    skull_cairn = 50,
    skull_rock = 50,
  },
}

PREFABS.Start_scionox_quakeish_portal_start_3 =
{
  template = "Start_scionox_quakeish_portal_start",
  map    = "MAP02",
  tex_BIGDOORJ = { BIGDOORJ=50, BIGDOOR2=50, BIGDOOR5=50,
  BIGDOOR7=50, BIGDOOR8=50, BIGDOORM=50, BIGDOORD=50 },
}

PREFABS.Start_scionox_quakeish_portal_start_4 =
{
  template = "Start_scionox_quakeish_portal_start",
  map    = "MAP02",
  tex_BIGDOORJ = { BIGDOORI=50, BIGDOOR5=50, BIGDOOR7=50,
  BIGDOOR8=50, BIGDOOR9=50, BIGDOORE=50, BIGDOORN=50 },
  theme = "hell",
  thing_85 =
  {
    skull_pole = 50,
    skull_kebab = 50,
    evil_eye   = 50,
    impaled_human = 50,
    impaled_twitch = 50,
    skull_cairn = 50,
    skull_rock = 50,
  },
}
