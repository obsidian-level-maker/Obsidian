--
-- Simple round pillar
--

PREFABS.Pillar_round1 =
{
  file   = "decor/pillar1.wad",
  where  = "point",

  prob   = 5000,
  skip_prob = 25,
  theme  = "!tech",
  env    = "building",

  size   = 80,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = { 56,72 }
}


PREFABS.Pillar_round1_tech =
{
  template = "Pillar_round1",

  theme  = "tech",

  tex_WOOD6     = "TEKLITE",
  tex_WOOD12    = "COMPSPAN",
  flat_FLOOR7_1 = "COMPSPAN",
}

PREFABS.Pillar_round1_tech2 =
{
  template = "Pillar_round1",

  theme  = "tech",

  tex_WOOD6     = { TEKWALL1=50, TEKWALL4=50 },
  tex_WOOD12    = "COMPSPAN",
  flat_FLOOR7_1 = "COMPSPAN",
}

PREFABS.Pillar_round1_marble =
{
  template = "Pillar_round1",

  theme  = "hell",

  tex_WOOD6     = { MARBLE2=50, MARBLE3=50, MARBGRAY=50 },
  tex_WOOD12    = "SUPPORT3",
  flat_FLOOR7_1 = "CEIL5_2",
}

PREFABS.Pillar_round1_metal =
{
  template = "Pillar_round1",

  theme  = "hell",

  tex_WOOD6     = "SUPPORT3",
  tex_WOOD12    = "METAL",
  flat_FLOOR7_1 = "CEIL5_2",
}
