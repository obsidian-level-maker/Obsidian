--
-- Techy square pillar
--

PREFABS.Pillar_tech2_A =
{
  file   = "decor/pillar2.wad",
  map    = "MAP02",

  prob   = 3500,
  theme  = "tech",
  env    = "building",

  where  = "point",
  size   = 64,
  height = 136,

  z_fit  = "top",

  bound_z1 = 0,
  bound_z2 = 136,
}


PREFABS.Pillar_tech2_B =
{
  template = "Pillar_tech2_A",

  map = "MAP01",

  prob = 3500,

  -- sector height must equal 128,
  height = { 128,128 },

  bound_z2 = 128,
}


PREFABS.Pillar_tech2_elec =
{
  template = "Pillar_tech2_A",

  map = "MAP03",

  prob = 3500,
  skip_prob = 50,

  height = { 160,192 },

  z_fit  = "top",

  bound_z1 = 0,
  bound_z2 = 160,
}


PREFABS.Pillar_tech2_TEKLITE =
{
  template = "Pillar_tech2_A",

  map = "MAP04",

  prob = 3500,
  skip_prob = 50,

  height = { 160,192 },

  z_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 160,

  -- occasionally flicker the lighting
  sector_1 = { [0]=90, [1]=10 }
}

PREFABS.Pillar_tech3_A =
{
  file   = "decor/pillar2.wad",
  map    = "MAP02",

  prob   = 3500,
  theme  = "tech",
  env    = "building",

  where  = "point",
  size   = 64,
  height = 136,

  bound_z1 = 0,
  bound_z2 = 136,

  z_fit  = "top",

  tex_COMPWERD = "LITE3",

}

PREFABS.Pillar_tech3_B =
{
  template = "Pillar_tech3_A",

  map = "MAP01",

  prob = 3500,

  -- sector height must equal 128,
  height = { 128,128 },

  bound_z2 = 128,
}


PREFABS.Pillar_bodies1_A =
{
  file   = "decor/pillar2.wad",
  map    = "MAP02",

  prob   = 3500,
  theme  = "hell",
  env    = "building",

  where  = "point",
  size   = 64,
  height = 136,

  bound_z1 = 0,
  bound_z2 = 136,

  z_fit  = "top",

  tex_COMPWERD = { SP_DUDE4=50, SP_DUDE5=50, SP_FACE2=10 },
  tex_COMPSPAN = { MARBLE2=50, MARBLE3=50 },
  flat_CEIL5_1 = "FLOOR7_2",

}

PREFABS.Pillar_bodies1_B =
{
  template = "Pillar_bodies1_A",

  map = "MAP01",

  prob = 3500,

  -- sector height must equal 128,
  height = { 128,128 },

  bound_z2 = 128,

}

PREFABS.Pillar_fire1_A =
{
  file   = "decor/pillar2.wad",
  map    = "MAP02",

  prob   = 3500,
  theme  = "hell",
  env    = "building",

  where  = "point",
  size   = 64,
  height = 136,

  bound_z1 = 0,
  bound_z2 = 136,

  z_fit  = "top",

  tex_COMPWERD = { FIREBLU1=50, FIREBLU2=50 },
  tex_COMPSPAN = "SP_HOT1",
  flat_CEIL5_1 = "FLAT5_3",

}

PREFABS.Pillar_fire1_B =
{
  template = "Pillar_fire1_A",

  map = "MAP01",

  prob = 3500,

  -- sector height must equal 128,
  height = { 128,128 },

  bound_z2 = 128,

  tex_COMPSPAN = "SP_HOT1",
  flat_CEIL5_1 = "FLAT5_3",

}
