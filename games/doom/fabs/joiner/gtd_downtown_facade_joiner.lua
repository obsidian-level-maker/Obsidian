PREFABS.Joiner_downtown_facade =
{
  file   = "joiner/gtd_downtown_facade_joiner.wad",
  map    = "MAP01",

  prob   = 1500,

  delta_h = 0,
  nearby_h = 256,

  texture_pack = "armaetus",

  theme  = "urban",
  env    = "outdoor",
  neighbor = "building",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  bound_z1 = 0,

  x_fit = { 124,132 },
  y_fit = { 96,136 },

  tex_CITY01 =
  {
    CITY01 = 50,
    CITY02 = 50,
    CITY03 = 50,
    CITY04 = 50,
    CITY05 = 50,
    CITY06 = 50,
    CITY07 = 50,
    CITY08 = 50,
    CITY09 = 50,
    CITY10 = 50,
  },

  flat_TLITE6_6 =
  {
    TLITE5_2 = 25,
    TLITE5_3 = 25,
    TLITE6_5 = 25,
    TLITE6_6 = 25,
    TLITE65B = 25,
    TLITE65G = 25,
    TLITE65O = 25,
    TLITE65W = 25,
    TLITE65Y = 25,
    GLITE04 = 50,
    GLITE06 = 50,
    GLITE07 = 50,
    GLITE08 = 50,
    GLITE09 = 50,
    LIGHTS1 = 50,
    LIGHTS2 = 50,
    LIGHTS3 = 50,
    LIGHTS4 = 50,
  },

  tex_STEP4 =
  {
    STEP1=50,
    STEP2=50,
    STEP3=50,
    STEP4=50,
    STEP5=50,
    STEP6=50,
    STEPLAD1=50,
    COMPBLUE=50,
    REDWALL=50,
  },

}

PREFABS.Joiner_downtown_facade_flipped =
{
  template = "Joiner_downtown_facade",
  map = "MAP02",

  env = "building",
  neighbor = "outdoor",

  y_fit = { 24,64 },
}
