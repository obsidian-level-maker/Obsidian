--
-- A huge pillar
--

PREFABS.Pillar_tech3 =
{
  file   = "decor/pillar3.wad",
  map    = "MAP01",

  prob   = 25000,
  skip_prob = 65,

  theme  = "tech",
  env    = "building",

  where  = "point",
  size   = 200,
  height = 192,

  bound_z1 = 0,
  bound_z2 = 192,

  z_fit  = { 80,112 }
}

PREFABS.Pillar3_tech2 =
{
  template  = "Pillar_tech3",

  theme  = "tech",

  tex_SILVER2 = { TEKWALL1=50, TEKWALL4=50, TEKLITE=50 }
}

PREFABS.Pillar3_hell1 =
{
  template  = "Pillar_tech3",

  theme  = "hell",

  tex_SILVER2 = "FIREBLU1",
  tex_COMPSPAN = "METAL",
  flat_CEIL5_1 = "CEIL5_2",
}

PREFABS.Pillar3_hell2 =
{
  template  = "Pillar_tech3",

  theme  = "hell",

  tex_SILVER2 = { SLOPPY1=50, SP_FACE2=50 },
  tex_COMPSPAN = "SP_HOT1",
  flat_CEIL5_1 = "FLAT5_3",
}

PREFABS.Pillar3_urban1 =
{
  template  = "Pillar_tech3",

  theme  = "urban",
  skip_prob = 55,

  tex_SILVER2 = "MODWALL1",
  tex_COMPSPAN = "BRICK4",
  flat_CEIL5_1 = "CEIL3_2",
}
