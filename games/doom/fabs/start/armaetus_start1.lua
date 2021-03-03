PREFABS.Start_armaetus_start_center_pillar =
{
  file  = "start/armaetus_start1.wad",
  map = "MAP01",

  prob  = 500,
  theme = "!hell",

  where = "seeds",

  seed_w = 2,
  seed_h = 1,

  deep  =  16,

  x_fit = "frame",
  y_fit = "top",

  tex_DOOR3 =
  {
    DOOR1=50,
    DOOR3=50,
  },
}

PREFABS.Start_armaetus_start_center_pillar_hell =
{
  template  = "Start_armaetus_start_center_pillar",
  prob = 500,
  map = "MAP01",
  theme = "hell",

  tex_TEKWALL1 = { SKIN2=50, SKINFACE=50, MARBLE1=50, GSTVINE1=50, GSTVINE2=50, GSTONE1=50, SP_HOT1=50 },
  tex_SHAWN2 = "METAL",
  tex_COMPSPAN = { STONE2=50, STONE3=50 },
  tex_SUPPORT2 = "SUPPORT3",
  flat_FLAT4 = "FLAT1",
  flat_CEIL5_1 = "FLOOR6_2",

  tex_DOOR3 =
  {
    WOODMET1=50,
    WOOD4=50,
  },
}

PREFABS.Start_armaetus_start_lift =
{
  file  = "start/armaetus_start1.wad",
  map = "MAP02",

  prob  = 250,
  theme = "!hell",

  where = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep  =  16,

  x_fit = "frame",
  y_fit = "top",

  tex_DOOR3 =
  {
    DOOR1=50,
    DOOR3=50,
  },
}

PREFABS.Start_armaetus_start_lift_hell =
{
  template  = "Start_armaetus_start_lift",
  map = "MAP02",
  theme = "hell",

  tex_SW1COMM = "SW1DIRT",
  tex_DOORSTOP = "METAL",
  tex_SHAWN2 = "METAL",
  tex_SUPPORT2 = "SUPPORT3",
  tex_TEKWALL4 = { MARBLE2=50, MARBLE3=50 },
  tex_COMPSPAN = { STONE2=50, STONE3=50 },
  flat_FLAT4 = "FLAT1",
  flat_CEIL5_1 = "FLOOR7_2",

  tex_DOOR3 =
  {
    WOODMET1=50,
    WOOD4=50,
  },
}

PREFABS.Start_armaetus_start_lift_downwards =
{
  template = "Start_armaetus_start_lift",
  map = "MAP03",
}

PREFABS.Start_armaetus_start_lift_hell_downwards =
{
  template = "Start_armaetus_start_lift",
  theme = "hell",
  map = "MAP03",

  tex_SW1COMM = "SW1DIRT",
  tex_DOORSTOP = "METAL",
  tex_SHAWN2 = "METAL",
  tex_SUPPORT2 = "SUPPORT3",
  tex_TEKWALL4 = { MARBLE2=50, MARBLE3=50 },
  tex_COMPSPAN = { STONE2=50, STONE3=50 },
  flat_FLAT4 = "FLAT1",
  flat_CEIL5_1 = "FLOOR7_2",

  tex_DOOR3 =
  {
    WOODMET1=50,
    WOOD4=50,
  },
}
