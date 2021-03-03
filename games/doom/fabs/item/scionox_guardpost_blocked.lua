-- Item dropped by dead marine near locked guardpost entrance

PREFABS.Item_scionox_guardpost_blocked =
{
  file   = "item/scionox_guardpost_blocked.wad",
  map    = "MAP02",

  prob   = 100,
  theme  = "!hell",

  env    = "!building",

  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  tex_COMPSTA1 = { COMPSTA1=50, COMPSTA2=50 },
  tex_GRAY5 = { GRAY5=50, BIGBRIK2=50, BLAKWAL2=50, MODWALL3=50, METAL2=50, SHAWN2=50 },
  tex_STARGR1 = { STARGR1=50, BIGBRIK1=50, BRICK12=50, BRICK7=50, MODWALL1=50, SLADWALL=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLOOR1_1=50, FLOOR0_3=50, FLAT5=50 },
  flat_FLOOR0_3 = { FLOOR4_6=50, FLOOR1_1=50, FLOOR0_3=50, FLAT5=50 },
  flat_CEIL5_1 = { CEIL5_1=50, CEIL3_3=50, CEIL4_2=50, CEIL5_2=50 },
  flat_CEIL5_2 = { CEIL5_1=50, CEIL3_3=50, CEIL4_2=50, CEIL5_2=50 }
}

-- Secret closet inside destroyed guardpost

PREFABS.Item_scionox_guardpost_secret =
{
  file   = "item/scionox_guardpost_blocked.wad",
  map    = "MAP01",

  prob   = 100,
  theme  = "!hell",

  env    = "building",

  where  = "seeds",
  key   = "secret",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  tex_GRAY5 = { GRAY5=50, BIGBRIK2=50, BLAKWAL2=50, MODWALL3=50, METAL2=50, SHAWN2=50 },
  flat_FLOOR4_6 = { FLOOR4_6=50, FLOOR1_1=50, FLOOR0_3=50, FLAT5=50 },
  flat_CEIL5_1 = { CEIL5_1=50, CEIL3_3=50, CEIL4_2=50, CEIL5_2=50 }
}
