--
-- Props for urban and tech
--

-- a basketball hoop
PREFABS.Decor_basketball_hoop =
{
  file   = "decor/dem_props.wad",
  map    = "MAP01",

  prob   = 3500,
  theme  = "urban",
  env    = "outdoor",

  where  = "point",
  size   = 96,
  height = 184,

  bound_z1 = 0,
  bound_z2 = 184,

  face_open = true,
}

-- a trash bin
PREFABS.Decor_trash_bin =
{
  template = "Decor_basketball_hoop",
  map    = "MAP02",

  theme  = "!hell",

  size   = 52,
  height = 40,

  bound_z1 = 0,
  bound_z2 = 40,

  sink_mode = "never_liquids",
}

-- a mailbox
PREFABS.Decor_mailbox =
{
  template = "Decor_basketball_hoop",
  map    = "MAP03",

  size   = 48,
  height = 56,

  bound_z1 = 0,
  bound_z2 = 56,

  sink_mode = "never_liquids",
}

-- litter1,
PREFABS.Decor_litter1 =
{
  file   = "decor/dem_props.wad",
  map    = "MAP04",

  prob   = 2500,
  theme  = "!hell",
  env    = "!cave",

  texture_pack = "armaetus",

  can_be_on_roads = true,

  where  = "point",
  size   = 64,
  height = 32,

  bound_z1 = 0,

  sink_mode = "never",

  face_open = true,
}

PREFABS.Decor_litter2 =
{
  template = "Decor_litter1",
  map    = "MAP05",
}

PREFABS.Decor_litter3 =
{
  template = "Decor_litter1",
  map    = "MAP06",
}

PREFABS.Decor_litter4 =
{
  template = "Decor_litter1",
  map    = "MAP07",
}

PREFABS.Decor_litter5 =
{
  template = "Decor_litter1",
  map    = "MAP08",
}

PREFABS.Decor_litter6 =
{
  template = "Decor_litter1",
  map    = "MAP09",
}

-- Drug deal gone bad
PREFABS.Decor_deal =
{
  file   = "decor/dem_props.wad",
  map    = "MAP10",

  port = "zdoom",

  prob   = 3500,
  theme  = "urban",
  env    = "!cave",

  texture_pack = "armaetus",

  where  = "point",
  size   = 256,
  height = 32,

  bound_z1 = 0,

  sink_mode = "never",

  face_open = true,
}

PREFABS.Decor_guardhouse_secret =
{
  file   = "decor/dem_props.wad",
  map    = "MAP11",

  port = "zdoom",

  prob   = 2000,
  theme  = "urban",
  env    = "building",

  texture_pack = "armaetus",

  style = "secrets",

  where  = "point",
  size   = 64,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",

  sink_mode = "never"
}

PREFABS.Decor_urban_newsstand_secret =
{
  file   = "decor/dem_props.wad",
  map    = "MAP12",

  port = "zdoom",

  prob   = 2000,
  theme  = "urban",
  env    = "building",

  texture_pack = "armaetus",

  jump_crouch = true,

  style = "secrets",

  where  = "point",
  size   = 64,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",

  sink_mode = "never"
}

-- advert board
PREFABS.Decor_advert_board1 =
{
  template = "Decor_basketball_hoop",
  map    = "MAP13",

  size   = 64,
  height = 256,

  texture_pack = "armaetus",

  sink_mode = "never_liquids",

  tex_CRGNRCK2 =
  {

    CRGNRCK2 = 50,
    ADVCR1 = 50,
    ADVCR2 = 50,
    ADVCR4 = 50,
    ADVDE1 = 50,
    ADVDE2 = 50,
    ADVDE3 = 50,
    ADVDE5 = 50
  }

}

-- ground advert board
PREFABS.Decor_advert_board2 =
{
  template = "Decor_basketball_hoop",
  map    = "MAP14",

  size   = 256,
  height = 128,

  texture_pack = "armaetus",

  sink_mode = "never_liquids",

  tex_SHAWN1 =
  {

    SHAWN1 = 50,
    ADVCR1 = 50,
    ADVCR2 = 50,
    ADVCR4 = 50,
    ADVDE1 = 50,
    ADVDE2 = 50,
    ADVDE3 = 50,
    ADVDE5 = 50
  }

}

-- small advert board
PREFABS.Decor_advert_board3 =
{
  template = "Decor_basketball_hoop",
  map    = "MAP15",

  size   = 64,
  height = 256,

  texture_pack = "armaetus",

  sink_mode = "never_liquids",

  tex_CRGNRCK2 =
  {

    CRGNRCK2 = 50,
    ADVCR3 = 50,
    ADVCR5 = 50,
    ADVDE4 = 50
  }

}

-- small ground advert board
PREFABS.Decor_advert_board4 =
{
  template = "Decor_basketball_hoop",
  map    = "MAP16",

  prob   = 1500,

  size   = 128,
  height = 128,

  texture_pack = "armaetus",

  sink_mode = "never_liquids",

  tex_COMPSC1 =
  {

    COMPSC1 = 50,
    ADVCR3 = 50,
    ADVCR5 = 50,
    ADVDE4 = 50
  }

}
