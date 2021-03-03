-- Joiner Outside-to-outside

PREFABS.Joiner_scionox_guardpost_outdoor =
{
  file   = "joiner/scionox_guardpost_outdoor.wad",
  map    = "MAP01",

  prob   = 250,
  theme  = "!hell",
  style  = "doors",

  env    = "outdoor",
  neighbor = "outdoor",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 152,192 },

  tex_SPCDOOR1 = { SPCDOOR1=50, SPCDOOR2=50, SPCDOOR3=50, SPCDOOR4=50 },
  tex_BRONZE1 = { BRONZE1=50, BIGBRIK2=50, BROWNGRN=50, GRAY1=50, MODWALL1=50, SLADWALL=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLOOR1_1=50, FLOOR0_3=50, FLAT5=50 },
  flat_CEIL4_2 = { CEIL5_1=50, CEIL3_3=50, CEIL4_2=50, CEIL5_2=50 },
}

-- Joiner Outside-to-outside Blue

PREFABS.Joiner_scionox_guardpost_outdoor_blue =
{
  template = "Joiner_scionox_guardpost_outdoor",
  map    = "MAP02",

  key    = "k_blue",
}

-- Joiner Outside-to-outside Red

PREFABS.Joiner_scionox_guardpost_outdoor_red =
{
  template = "Joiner_scionox_guardpost_outdoor",
  map    = "MAP02",

  key    = "k_red",
  tex_DOORBLU = "DOORRED",
  line_133     = 135,
}

-- Joiner Outside-to-outside Yellow

PREFABS.Joiner_scionox_guardpost_outdoor_yellow =
{
  template = "Joiner_scionox_guardpost_outdoor",
  map    = "MAP02",

  key    = "k_yellow",
  tex_DOORBLU = "DOORYEL",
  line_133     = 137,
}

-- Joiner Outside-to-outside All

PREFABS.Joiner_scionox_guardpost_outdoor_all =
{
  template = "Joiner_scionox_guardpost_outdoor",
  map    = "MAP03",

  key    = "k_ALL",
}

-- Joiner Outside-to-outside flipped

PREFABS.Joiner_scionox_guardpost_outdoor_2 =
{
  template = "Joiner_scionox_guardpost_outdoor",
  map    = "MAP04",

  y_fit = { 96,136 },
}
