--Based on gtd_pic_tech_controlroom
PREFABS.Item_control_room_secret =
{
  file   = "item/scionox_secrets_tech.wad",
  map    = "MAP01",

  prob   = 25,
  theme = "tech",

  env = "building",

  where  = "seeds",
  key    = "secret",
  height = 128,

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",

  sector_1  = { [0]=70, [1]=20, [2]=5, [3]=5, [8]=10 },

  sound = "Computer_Station",
}

PREFABS.Item_control_room_secret_2 =
{
  template = "Item_control_room_secret",

  tex_SILVER3 = "COMPSPAN",
  tex_COMPSTA1 = "SPACEW3",
  tex_COMPSTA2 = "SPACEW3",
}

--Based on gtd_pic_tech_wallmachines
PREFABS.Item_wallmachines_secret =
{
  file   = "item/scionox_secrets_tech.wad",
  map    = "MAP02",

  prob   = 25,
  theme = "!hell",
  env = "building",

  where  = "seeds",
  key    = "secret",
  height = 128,

  seed_w = 3,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = -256,
  bound_z2 = 256,

  x_fit = "frame",
  y_fit = "top",

  sound = "Machine_Air",
}

PREFABS.Item_wallmachines_secret_2 =
{
  file   = "item/scionox_secrets_tech.wad",
  map    = "MAP03",

  prob   = 25,
  theme = "tech",
  env = "building",

  where  = "seeds",
  key    = "secret",
  height = 128,

  seed_w = 2,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_wallmachines_secret_3 =
{
  template = "Item_wallmachines_secret_2",
  map      = "MAP04",

  theme  = "!hell",

  seed_w = 3,

  sound = "Computer_Station",
}

PREFABS.Item_wallmachines_secret_4 =
{
  template = "Item_wallmachines_secret_2",
  map      = "MAP05",

  theme = "!hell",

  seed_w = 4,
  seed_h = 1,
}

PREFABS.Item_wallmachines_secret_5 =
{
  file   = "item/scionox_secrets_tech.wad",
  map    = "MAP06",

  prob   = 10,
  theme = "!hell",
  env = "!nature",

  where  = "seeds",
  key    = "secret",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",

  sound = "Machine_Air",
}

PREFABS.Item_wallmachines_secret_6 =
{
  template = "Item_wallmachines_secret_5",
  tex_COMPBLUE = "REDWALL",
  tex_REDWALL = "COMPBLUE",
  flat_FLAT5_3 = "FLAT14",
}
