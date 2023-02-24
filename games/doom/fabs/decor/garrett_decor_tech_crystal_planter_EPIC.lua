PREFABS.Decor_garrett_hell_crystal_analyser_thing_EPIC =
{
  file   = "decor/garrett_decor_tech_crystal_planter_EPIC.wad",
  map = "MAP01",

  prob   = 5000,
  theme  = "tech",
  env    = "building",

  texture_pack = "armaetus",

  where  = "point",

  height = 192,
  size   = 96,

  bound_z1 = 0,
  bound_z2 = 192,

  z_fit = { 48,136 }
}

PREFABS.Decor_gtd_hell_crystal_analyser_thing_2_EPIC =
{
  template = "Decor_garrett_hell_crystal_analyser_thing_EPIC",
  map = "MAP02",

  height = 128,
  size = 104,

  face_open = true,

  bound_z2 = 128,

  z_fit = "top",
}

PREFABS.Decor_gtd_hell_crystal_analyser_thing_3_EPIC =
{
  template = "Decor_garrett_hell_crystal_analyser_thing_EPIC",
  map = "MAP03",

  prob = 8000,

  height = 128,
  size = 112,

  face_open = true,

  bound_z2 = 128,

  z_fit = "top",
}
