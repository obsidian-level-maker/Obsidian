-- Joiner Inside-to-outside

PREFABS.Joiner_scionox_guardpost =
{
  file   = "joiner/scionox_guardpost.wad",
  map    = "MAP01",

  prob   = 250,
  theme  = "!hell",
  style  = "doors",

  env    = "building",
  neighbor = "!building",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 72,88 , 168,184 },

  tex_COMPSTA1 = { COMPSTA1=50, COMPSTA2=50 },
  tex_GRAY5 = { GRAY5=50, BIGBRIK2=50, BLAKWAL2=50, MODWALL3=50, METAL2=50, SHAWN2=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLOOR1_1=50, FLOOR0_3=50, FLAT5=50 },
  flat_CEIL5_1 = { CEIL5_1=50, CEIL3_3=50, CEIL4_2=50, CEIL5_2=50 },
}

-- Joiner Outside-to-inside

PREFABS.Joiner_scionox_guard_post2 =
{
  template = "Joiner_scionox_guardpost",
  map    = "MAP02",

  env    = "!building",
  neighbor = "building",

  y_fit  = { 104,120 , 200,216 },
}

-- Joiner Inside-to-outside Blue

PREFABS.Joiner_scionox_guardpost_blue =
{
  template = "Joiner_scionox_guardpost",
  map    = "MAP03",

  key    = "k_blue",
}

-- Joiner Inside-to-outside Red

PREFABS.Joiner_scionox_guardpost_red =
{
  template = "Joiner_scionox_guardpost",
  map    = "MAP03",

  key    = "k_red",
  tex_DOORBLU = "DOORRED",
  line_133     = 135,
}

-- Joiner Inside-to-outside Yellow

PREFABS.Joiner_scionox_guardpost_yellow =
{
  template = "Joiner_scionox_guardpost",
  map    = "MAP03",

  key    = "k_yellow",
  tex_DOORBLU = "DOORYEL",
  line_133     = 137,
}

-- Joiner Inside-to-outside All

PREFABS.Joiner_scionox_guardpost_all =
{
  template = "Joiner_scionox_guardpost",
  map    = "MAP04",

  key    = "k_ALL",

  y_fit = { 68,76 , 184,188 },
}

-- Joiner Inside-to-outside Trapped

PREFABS.Joiner_scionox_guardpost_trapped =
{
  template = "Joiner_scionox_guardpost",
  map    = "MAP05",

  style  = "traps",

  seed_w = 3,
}
