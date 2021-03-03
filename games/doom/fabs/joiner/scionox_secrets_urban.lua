--Based on gtd_pic_urban_generic_frontages
PREFABS.Joiner_generic_frontage_secret =
{
  file   = "joiner/scionox_secrets_urban.wad",
  map    = "MAP01",

  prob   = 25,
  theme = "urban",

  env = "!cave",

  where  = "seeds",
  key    = "secret",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  bound_z1 = 0,
  bound_z2 = 128,

  deep   =  16,
  over   =  16,

  x_fit = "frame",
  y_fit = { 256,272 },

  tex_COMPBLUE =
  {
    COMPBLUE = 10,
    LITE5 = 10,
    LITEBLU4 = 10,
    REDWALL = 10,
  },

  tex_MODWALL3 =
  {
    MODWALL3 = 20,
    STEP4 = 10,
    STEP5 = 10,
  },
}

PREFABS.Joiner_generic_frontage_secret_2 =
{
  file   = "joiner/scionox_secrets_urban.wad",
  map    = "MAP02",

  prob   = 25,
  theme = "urban",

  env = "!cave",

  where  = "seeds",
  key    = "secret",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  bound_z1 = 0,
  bound_z2 = 128,

  deep   =  16,
  over   =  16,

  x_fit = "frame",
  y_fit = { 24,40 },
}

--based on gtd_pic_urban_commercial_frontages

PREFABS.Joiner_commercial_frontage_secret =
{
  file   = "joiner/scionox_secrets_urban.wad",
  map    = "MAP03",

  prob   = 25,
  theme = "urban",

  env = "!cave",

  where  = "seeds",
  key    = "secret",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  bound_z1 = 0,
  bound_z2 = 128,

  deep   =  16,
  over   =  16,

  x_fit = "frame",
  y_fit = { 172,180 },
}

PREFABS.Joiner_commercial_frontage_secret_2 =
{
  file   = "joiner/scionox_secrets_urban.wad",
  map    = "MAP04",

  prob   = 25,
  theme = "urban",
  engine = "zdoom",

  env = "!cave",

  where  = "seeds",
  key    = "secret",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep   =  16,
  over   =  16,

  x_fit = "frame",
  y_fit = { 136,152 },
}
