PREFABS.Decor_armaetus_crucified_pillar_1 =
{
  file   = "decor/armaetus_crucified.wad",
  map    = "MAP01",

  prob   = 3500,
  theme  = "hell",

  where  = "point",
  size   = 80,
  height = 136,

  bound_z1 = 0,
  bound_z2 = 138,

  tex_SP_DUDE4 = { SP_DUDE4=50, SP_DUDE5=50 }
}

PREFABS.Decor_armaetus_crucified_pillar_1_EPIC =
{
  template   = "Decor_armaetus_crucified_pillar_1",

  texture_pack = "armaetus",
  replaces   = "Decor_armaetus_crucified_pillar_1",

  tex_SP_DUDE4 = { SP_DUDE4=50, SP_DUDE5=50, SPDUDE3=50, SPDUDE6=30 }
}

PREFABS.Decor_armaetus_crucified_pillar_4x =
{
  template = "Decor_armaetus_crucified_pillar_1",
  map    = "MAP02",

  size   = 144,
  height = 136,

  bound_z2 = 138,
}

PREFABS.Decor_armaetus_crucified_pillar_4x_EPIC =
{
  template = "Decor_armaetus_crucified_pillar_1",
  map = "MAP02",

  texture_pack = "armaetus",
  replaces   = "Decor_armaetus_crucified_pillar_4x",

  size   = 144,
  height = 136,

  bound_z2 = 138,

  tex_SP_DUDE4 = { SP_DUDE4=50, SP_DUDE5=50, SPDUDE3=50, SPDUDE6=30 }
}

PREFABS.Decor_armaetus_crucified_pillar_big =
{
  template = "Decor_armaetus_crucified_pillar_1",
  map = "MAP03",

  height = 134,

  size = 112,

  bound_z2 = 112,
}

PREFABS.Decor_armaetus_crucified_pillar_4x_EPIC =
{
  template = "Decor_armaetus_crucified_pillar_1",
  map = "MAP03",

  texture_pack = "armaetus",
  replaces   = "Decor_armaetus_crucified_pillar_big",

  height = 134,

  size = 112,

  bound_z2 = 112,

  tex_SP_DUDE4 = { SP_DUDE4=50, SP_DUDE5=50, SPDUDE3=50, SPDUDE6=30 }
}
