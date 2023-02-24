--Based on gtd_pic_tech_controlroom
PREFABS.Joiner_control_room_secret =
{
  file   = "joiner/scionox_secrets_tech.wad",
  map    = "MAP01",

  prob   = 25,
  theme  = "tech",

  env    = "building",
  key    = "secret",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = { 248,264 },

  sector_1  = { [0]=70, [1]=20, [2]=5, [3]=5, [8]=10 },

}

PREFABS.Joiner_control_room_secret_2 =
{
  template = "Joiner_control_room_secret",

  tex_SILVER3 = "COMPSPAN",
  tex_COMPSTA1 = "SPACEW3",
  tex_COMPSTA2 = "SPACEW3",
}

--Based on gtd_pic_tech_wallmachines
PREFABS.Joiner_wallmachines_secret =
{
  file   = "joiner/scionox_secrets_tech.wad",
  map    = "MAP02",

  prob   = 25,
  theme = "!hell",
  env = "!cave",
  style  = "steepness",

  where  = "seeds",
  shape  = "I",
  key    = "secret",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = 16,

  bound_z1 = 0,
  bound_z2 = 200,

  delta_h  = 128,
  nearby_h = 128,

  x_fit = "frame",
  y_fit = { 120,128 },
}

PREFABS.Joiner_wallmachines_secret_2 =
{
  template = "Joiner_wallmachines_secret",
  tex_COMPBLUE = "REDWALL",
  tex_REDWALL = "COMPBLUE",
  flat_FLAT5_3 = "FLAT14",
}

PREFABS.Joiner_wallmachines_secret_3 =
{
  file   = "joiner/scionox_secrets_tech.wad",
  map    = "MAP03",

  prob   = 25,
  theme = "!hell",
  env = "building",

  where  = "seeds",
  shape  = "I",
  key    = "secret",

  seed_w = 4,
  seed_h = 1,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit = { 136,144 },
}
