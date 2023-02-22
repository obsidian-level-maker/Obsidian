-- big pentagram teleport, slightly inspired by E1,

PREFABS.Teleporter_scionox_penta_teleport =
{
  file   = "teleporter/scionox_penta_teleport.wad",
  map    = "MAP01",
  prob   = 50,

  theme  = "tech",
  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep  =  16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  tex_COMPSTA1 = { COMPSTA1=50, COMPSTA2=50, COMPWERD=50, SPACEW3=50, SILVER2=50, SILVER3=50 },

  sound = "Demonic_Teleporter",
}

PREFABS.Teleporter_scionox_penta_teleport_3 =
{
  template = "Teleporter_scionox_penta_teleport",
  map    = "MAP02",
  theme  = "!tech",

  tex_MARBFACE = { MARBFACE=50, MARBFAC2=50, MARBFAC3=50 },

  thing_25 =
  {
    skull_pole = 50,
    skull_kebab = 50,
    evil_eye   = 50,
    impaled_human = 50,
    impaled_twitch = 50,
    skull_cairn = 50,
    skull_rock = 50,
  },

  thing_26 =
  {
    skull_pole = 50,
    skull_kebab = 50,
    evil_eye   = 50,
    impaled_human = 50,
    impaled_twitch = 50,
    skull_cairn = 50,
    skull_rock = 50,
  },

  thing_27 =
  {
    skull_pole = 50,
    skull_kebab = 50,
    evil_eye   = 50,
    impaled_human = 50,
    impaled_twitch = 50,
    skull_cairn = 50,
    skull_rock = 50,
  },

  thing_28 =
  {
    skull_pole = 50,
    skull_kebab = 50,
    evil_eye   = 50,
    impaled_human = 50,
    impaled_twitch = 50,
    skull_cairn = 50,
    skull_rock = 50,
  },

  thing_29 =
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

-- Point version
PREFABS.Teleporter_scionox_penta_teleport_4 =
{
  file   = "teleporter/scionox_penta_teleport.wad",
  map    = "MAP03",

  prob   = 50,

  where  = "point",
  size   = 64,

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  face_open = true,

  sound = "Demonic_Teleporter",
}
