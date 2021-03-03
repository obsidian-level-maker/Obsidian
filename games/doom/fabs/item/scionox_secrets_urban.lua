--Based on gtd_pic_urban_generic_frontages
PREFABS.Item_generic_frontage_secret =
{
  file = "item/scionox_secrets_urban.wad",
  map = "MAP01",

  prob = 40,
  theme = "urban",

  env = "!nature",

  where = "seeds",
  key = "secret",
  height = 128,

  seed_w = 3,
  seed_h = 2,

  bound_z1 = 0,
  bound_z2 = 128,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",

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
  }
}

PREFABS.Item_generic_frontage_secret_2 =
{
  file = "item/scionox_secrets_urban.wad",
  map = "MAP02",

  prob = 15,
  theme = "urban",

  engine = "zdoom",

  env = "!nature",

  where = "seeds",
  key = "secret",
  height = 128,

  seed_w = 2,
  seed_h = 2,

  bound_z1 = 0,
  bound_z2 = 128,

  deep   =  16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_generic_frontage_secret_3 =
{
  file = "item/scionox_secrets_urban.wad",
  map = "MAP03",

  prob = 40,
  theme = "urban",

  env = "!nature",

  where = "seeds",
  key = "secret",
  height = 128,

  seed_w = 3,
  seed_h = 2,

  bound_z1 = -96,
  bound_z2 = 128,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",
}

--based on gtd_pic_urban_commercial_frontages

PREFABS.Item_commercial_frontage_secret =
{
  file = "item/scionox_secrets_urban.wad",
  map = "MAP04",

  prob = 15,
  theme = "urban",

  env = "!nature",

  where  = "seeds",
  key    = "secret",
  height = 128,

  seed_w = 2,
  seed_h = 2,

  bound_z1 = 0,
  bound_z2 = 128,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_commercial_frontage_secret_2 =
{
  template = "Item_commercial_frontage_secret",
  map    = "MAP05",

  seed_w = 3,

  prob = 40,
}

PREFABS.Item_commercial_frontage_secret_3 =
{
  template = "Item_commercial_frontage_secret",
  map    = "MAP06",

  seed_w = 3,

  prob = 40,
}

PREFABS.Item_commercial_frontage_secret_4 =
{
  template = "Item_commercial_frontage_secret",
  map = "MAP07",

  prob = 20,

  seed_w = 2,
  seed_h = 2,
}

PREFABS.Item_commercial_frontage_secret_5 =
{
  template = "Item_commercial_frontage_secret",
  map = "MAP08",

  prob = 40,

  engine = "zdoom",
  seed_w = 3,
}

PREFABS.Item_commercial_frontage_secret_6 =
{
  template = "Item_commercial_frontage_secret",
  map = "MAP09",

  prob = 35,

  seed_w = 3,
  seed_h = 1,
}

PREFABS.Item_commercial_frontage_secret_7 =
{
  template = "Item_commercial_frontage_secret",
  map = "MAP10",

  prob = 40,

  engine = "zdoom",
  seed_w = 3,

}
