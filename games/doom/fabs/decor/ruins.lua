--
-- Ruins (outdoor shapes)
--

PREFABS.Decor_ruins1 =
{
  file   = "decor/ruins.wad",
  map    = "MAP01",

  prob   = 3500,
  theme  = "urban",
  env    = "outdoor",

  where  = "point",
  size   = 80,

  bound_z1 = 0,
  bound_z2 = 128,

  tex_BRICK7 = { BRICK5=50, BRICK6=50, BRICK7=50, BRICK8=50, BRICK9=50 }

}


PREFABS.Decor_ruins2 =
{
  template = "Decor_ruins1",
  map      = "MAP02",
}


PREFABS.Decor_ruins3 =
{
  template = "Decor_ruins1",
  map      = "MAP03",
}



PREFABS.Decor_hellruins1 =
{
  file   = "decor/ruins.wad",
  map    = "MAP01",

  prob   = 3500,
  theme  = "hell",
  env    = "outdoor",

  where  = "point",
  size   = 80,

  bound_z1 = 0,
  bound_z2 = 128,

  tex_BRICK7 = "SP_HOT1",
  flat_FLOOR5_4 = "FLAT5_3",

}

PREFABS.Decor_hellruins2 =
{
  template = "Decor_hellruins1",
  map      = "MAP02",
}


PREFABS.Decor_hellruins3 =
{
  template = "Decor_hellruins1",
  map      = "MAP03",
}


PREFABS.Decor_vineruins1 =
{
  file   = "decor/ruins.wad",
  map    = "MAP01",

  prob   = 3500,
  theme  = "hell",
  env    = "outdoor",

  where  = "point",
  size   = 80,

  bound_z1 = 0,
  bound_z2 = 128,

  tex_BRICK7 = { GSTVINE1=50, GSTVINE2=50 },
  flat_FLOOR5_4 = "FLOOR7_2",

}

PREFABS.Decor_vineruins2 =
{
  template = "Decor_vineruins1",
  map      = "MAP02",
}


PREFABS.Decor_vineruins3 =
{
  template = "Decor_vineruins1",
  map      = "MAP03",
}
