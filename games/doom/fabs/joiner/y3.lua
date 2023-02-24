--
-- very cool Y-shapish 3x2 joiner
--

PREFABS.Joiner_y3 =
{
  file   = "joiner/y3.wad",

  prob   = 200,
  theme  = "!tech",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  delta_h  = 32,
  nearby_h = 160,
  can_flip = true,
}

PREFABS.Joiner_y3a =
{
  template = "Joiner_y3",

  theme = "hell",

  thing_35 = "skull_kebab",
  thing_46 = "green_torch",

  tex_WOODMET1 = "SP_HOT1",
  tex_REDWALL = "FIREBLU1",
  tex_BROWN1 = "ASHWALL2",
  tex_STEP5 = "STEP3",
  flat_FLOOR0_1 = "FLOOR6_2",
  flat_CEIL3_5 = "FLAT10",
}

PREFABS.Joiner_y3b =
{
  template = "Joiner_y3",

  theme = "hell",

  thing_35 = "skull_pole",
  thing_46 = "blue_torch",

  tex_WOODMET1 = { GSTONE1=50, GSTVINE1=30, GSTVINE2=30 },
  tex_REDWALL = "FIREBLU2",
  tex_BROWN1 = "MARBLE1",
  tex_STEP5 = "MARBLE1",
  flat_FLOOR0_1 = { DEM1_6=50, DEM1_5=50 },
  flat_CEIL3_5 = { FLOOR7_2=50, DEM1_5=50 },
}

PREFABS.Joiner_y3c =
{
  template = "Joiner_y3",

  theme = "urban",

  thing_35 = "evil_eye",

  tex_WOODMET1 = { WOOD1=50, WOOD3=50, WOOD5=50, WOODVERT=50, WOOD12=50 },
  tex_REDWALL = "SUPPORT3",
  tex_BROWN1 = "STONE",
  tex_STEP5 = "STEP4",
  tex_SW2SKIN = { PANEL2=50, PANEL3=50, PANRED=50, PANBLUE=50, PANBLACK=50 },
  flat_FLOOR0_1 = "FLAT5_4",
  flat_CEIL3_5 = "FLAT18",
}

PREFABS.Joiner_y3c1 =
{
  template = "Joiner_y3",

  theme = "urban",

  thing_35 = "evil_eye",
  thing_46 = "blue_torch",

  tex_WOODMET1 = { WOOD1=50, WOOD3=50, WOOD5=50, WOODVERT=50, WOOD12=50 },
  tex_REDWALL = "SUPPORT3",
  tex_BROWN1 = "STONE",
  tex_STEP5 = "STEP4",
  tex_SW2SKIN = { PANEL2=50, PANEL3=50, PANRED=50, PANBLUE=50, PANBLACK=50 },
  flat_FLOOR0_1 = "FLAT5_4",
  flat_CEIL3_5 = "FLAT18",
}
