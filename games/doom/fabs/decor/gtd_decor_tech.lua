PREFABS.Decor_light_pillar_helix =
{
  file   = "decor/gtd_decor_tech.wad",
  map    = "MAP01",

  prob   = 5000,
  theme  = "tech",
  env    = "building",

  where  = "point",
  size   = 128,
  height = 160,

  bound_z1 = 0,
  bound_z2 = 160,

  z_fit  = { 120+16,120+32 }
}

PREFABS.Decor_light_pillar_core =
{
  template = "Decor_light_pillar_helix",
  map    = "MAP02",

  size   = 64,
  height = 128,

  bound_z2 = 128,

  z_fit  = { 44,76 }
}

PREFABS.Decor_light_pillar_core2 =
{
  template = "Decor_light_pillar_helix",
  map    = "MAP03",

  size   = 64,
  height = 128,

  bound_z2 = 128,

  z_fit  = { 44,84 }
}

PREFABS.Decor_data_pillar =
{
  template = "Decor_light_pillar_helix",
  map    = "MAP04",

  size   = 64,
  height = 112,

  bound_z2 = 112,

  z_fit  = "top",
}

PREFABS.Decor_computer_tall =
{
  template = "Decor_light_pillar_helix",
  map    = "MAP05",

  size   = 64,
  height = 128,

  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Decor_server_rack =
{
  template = "Decor_light_pillar_helix",
  map    = "MAP06",

  size   = 64,
  height = 96,

  bound_z2 = 96,

  z_fit = "top",

  sink_mode = "never",
}

PREFABS.Decor_open_pipe =
{
  template = "Decor_light_pillar_helix",
  map    = "MAP07",

  liquid = true,

  size   = 64,
  height = 128,

  bound_z2 = 128,

  z_fit  = { 32,88 },

  sound = "Water_Tank",
}

PREFABS.Decor_floor_decal_stripes =
{
  template = "Decor_light_pillar_helix",
  map    = "MAP08",

  theme  = "!hell",

  size   = 64,
  height = 32,

  bound_z2 = 32,

  sink_mode = "never",
}

PREFABS.Decor_sealed_storage =
{
  template = "Decor_light_pillar_helix",
  map    = "MAP09",

  size   = 64,
  height = 128,

  bound_z2 = 128,

  z_fit = "top",
}

PREFABS.Decor_sealed_storage_large =
{
  template = "Decor_light_pillar_helix",
  map    = "MAP10",

  where  = "point",
  height = 128,

  bound_z2 = 128,

  z_fit = "top",
}

PREFABS.Decor_fuel_rods =
{
  template = "Decor_light_pillar_helix",
  map    = "MAP11",

  size   = 64,
  height = 128,

  bound_z2 = 128,

  z_fit = { 60,90 }
}

PREFABS.Decor_beacon_thing =
{
  template = "Decor_light_pillar_helix",
  map = "MAP16",

  env = "outdoor",

  size = 96,
  height = 112,

  z_fit = "top",

  bound_z1 = 0,
  bound_z2 = 128,
}
