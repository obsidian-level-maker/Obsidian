PREFABS.Cage_sandbag_fort =
{
  file   = "cage/gtd_cage_sandbag.wad",
  map    = "MAP01",

  prob   = 50,

  where  = "point",
  size   = 96,

  bound_z1 = 0,
}

PREFABS.Cage_sandbag_fort_for_two =
{
  file = "cage/gtd_cage_sandbag.wad",
  map      = "MAP02",

  prob     = 50,

  where    = "point",
  size     = 128,

  bound_z1 = 0,
}

PREFABS.Cage_sandbag_fort_EPIC =
{
  file   = "cage/gtd_cage_sandbag.wad",
  map    = "MAP01",

  prob   = 50,

  where    = "point",
  size     = 104,

  replaces = "Cage_sandbag_fort",
  texture_pack = "armaetus",

  tex_BRICK12 = "SANDBAGS",

  bound_z1 = 0,
}

PREFABS.Cage_sandbag_fort_for_two_EPIC =
{
  file     = "cage/gtd_cage_sandbag.wad",
  map      = "MAP02",

  prob     = 50,

  where    = "point",
  size     = 136,

  replaces = "Cage_sandbag_fort_for_two",
  texture_pack = "armaetus",

  tex_BRICK12 = "SANDBAGS",

  bound_z1 = 0,
}

PREFABS.Cage_sandbag_inset =
{
  file = "cage/gtd_cage_sandbag.wad",
  map  = "MAP03",

  prob = 300,

  where = "seeds",
  shape = "U",

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  x_fit = { 84,92 , 164,172 },
  y_fit = "top",
}

PREFABS.Cage_sandbag_inset_EPIC =
{
  file = "cage/gtd_cage_sandbag.wad",
  map  = "MAP03",

  prob = 300,

  replaces = "Cage_sandbag_inset",
  texture_pack = "armaetus",

  where = "seeds",
  shape = "U",

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  x_fit = { 84,92 , 164,172 },
  y_fit = "top",

  tex_BRICK12 = "SANDBAGS",

  tex_MIDBARS1 = "FENCE2",
}
