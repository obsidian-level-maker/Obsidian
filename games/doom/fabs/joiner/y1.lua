--
-- large Y-shaped joiner
--

PREFABS.Joiner_y1 =
{
  file   = "joiner/y1.wad",

  prob   = 65,
  theme  = "!tech",
  map    = "MAP01",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  delta_h  = 24,
  nearby_h = 128,
  can_flip = true,
}

PREFABS.Joiner_y1a =
{
  template = "Joiner_y1",
  prob   = 65,

  tex_PIPEWAL2 = "STONE4",
  tex_STONE = "STONE5",
  flat_FLAT1 = "FLAT5_4",

}

PREFABS.Joiner_y1b =
{
  template = "Joiner_y1",
  prob   = 65,

  theme  = "tech",
  map    = "MAP02",

  tex_PIPEWAL2 = "STARTAN3",
  tex_STONE = "STEP4",
  flat_FLAT1 = "FLOOR4_8",

}

PREFABS.Joiner_y1b1 =
{
  template = "Joiner_y1",
  prob   = 65,

  theme  = "tech",
  map    = "MAP02",

  tex_PIPEWAL2 = "BROWN1",
  tex_STONE = "STEP6",
  flat_FLAT1 = "FLOOR0_1",

}

PREFABS.Joiner_y1b2 =
{
  template = "Joiner_y1",
  prob   = 65,

  theme  = "tech",
  map    = "MAP02",

  tex_PIPEWAL2 = "STARTAN3",
  tex_STONE = "STEP4",
  flat_FLAT1 = "FLOOR4_8",

}

PREFABS.Joiner_y1b3 =
{
  template = "Joiner_y1",
  prob   = 65,

  theme  = "!hell",

  tex_PIPEWAL2 = "CEMENT9",
  tex_STONE = "STEP6",
  flat_FLAT1 = "FLOOR5_4",

}

PREFABS.Joiner_y1b4 =
{
  template = "Joiner_y1",
  prob   = 65,
  theme  = "tech",

  tex_PIPEWAL2 = "TEKGREN2",
  tex_STONE = "STEP4",
  flat_FLAT1 = "FLAT14",
  map    = "MAP02",

}


PREFABS.Joiner_y1c =
{
  template = "Joiner_y1",
  prob   = 65,
  theme  = "tech",

  tex_PIPEWAL2 = "STARG3",
  tex_STONE = "STEP4",
  flat_FLAT1 = "FLOOR4_8",
  map    = "MAP02",

}

PREFABS.Joiner_y1c1a1 =
{
  template = "Joiner_y1",
  prob   = 65,
  theme  = "tech",
  map    = "MAP02",

}

PREFABS.Joiner_y1d =
{
  template = "Joiner_y1",
  prob   = 100,
  theme = "urban",

  tex_PIPEWAL2 = "PANCASE2",
  tex_STONE = "STEP6",
  flat_FLAT1 = "FLAT5_5",

}

PREFABS.Joiner_y1e =
{
  template = "Joiner_y1",
  prob   = 65,
  theme = "urban",

  tex_PIPEWAL2 = "WOODVERT",
  tex_STONE = "STEPTOP",
  flat_FLAT1 = "FLAT5_1",

}

PREFABS.Joiner_y1e1a =
{
  template = "Joiner_y1",
  prob   = 100,
  theme = "urban",

  tex_PIPEWAL2 = "WOOD1",
  tex_STONE = "STEP6",
  flat_FLAT1 = "FLAT5_2",

}

PREFABS.Joiner_y1e2 =
{
  template = "Joiner_y1",
  prob   = 65,
  theme = "urban",

  tex_PIPEWAL2 = "BSTONE2",
  tex_STONE = "STEP6",
  flat_FLAT1 = "FLAT5_2",

}

PREFABS.Joiner_y1f =
{
  template = "Joiner_y1",
  prob   = 65,
  theme = "urban",

  tex_PIPEWAL2 = { PANEL6=50, PANEL8=50, PANEL9=50 },
  tex_STONE = "STEP6",
  flat_FLAT1 = "FLAT5_5",

}

PREFABS.Joiner_y1g =
{
  template = "Joiner_y1",
  prob   = 120,

  theme = "hell",

  tex_PIPEWAL2 = { GSTVINE1=50, GSTVINE2=50 },
  tex_STONE = "STONE6",
  flat_FLAT1 = "RROCK09",

}

PREFABS.Joiner_y1h =
{
  template = "Joiner_y1",
  prob   = 120,

  theme = "hell",

  tex_PIPEWAL2 = "SP_HOT1",
  tex_STONE = "ASHWALL2",
  flat_FLAT1 = "FLOOR6_2",

}

PREFABS.Joiner_y1ha =
{
  template = "Joiner_y1",
  prob   = 120,

  theme = "hell",

  tex_PIPEWAL2 = "GSTONE1",
  tex_STONE = "ASHWALL2",
  flat_FLAT1 = "FLOOR6_2",

}

PREFABS.Joiner_y1i =
{
  template = "Joiner_y1",
  prob   = 120,

  theme = "hell",

  tex_PIPEWAL2 = { SKINMET1=50, SKINMET2=50, SKINCUT=50, SKINSCAB=50 },
  tex_STONE = "SUPPORT3",
  flat_FLAT1 = "CEIL5_2",

}

PREFABS.Joiner_y1i1 =
{
  template = "Joiner_y1",
  prob   = 120,

  theme = "hell",

  tex_PIPEWAL2 = "SKIN2",
  tex_STONE = "SUPPORT3",
  flat_FLAT1 = "CEIL5_2",

}

PREFABS.Joiner_y1j =
{
  template = "Joiner_y1",
  prob   = 120,

  theme = "hell",

  tex_PIPEWAL2 = { WOODMET1=20, WOODMET4=75 },
  tex_STONE = "SUPPORT3",
  flat_FLAT1 = "CEIL5_2",

}
