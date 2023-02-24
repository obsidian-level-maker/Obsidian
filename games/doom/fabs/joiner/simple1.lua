--
-- Simple joiner
--

PREFABS.Joiner_simple1 =
{
  file   = "joiner/simple1.wad",
  map    = "MAP01",

  prob   = 100,
  theme  = "tech",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit = { 96,160 },
  y_fit = { 48,112 },

  tex_METAL = "COMPSPAN",
  tex_GRAY2 = { GRAY2=50, TEKWALL1=50, TEKWALL4=50, CEMENT9=50, CEMENT8=50, METAL1=50 },

  sector_1  = { [0]=55, [1]=35, [2]=10, [3]=10, [8]=10, [17]=5 },

}


PREFABS.Joiner_simple1_urban =
{
  template   = "Joiner_simple1",
  map    = "MAP01",
  prob   = 100,

  theme  = "urban",

  tex_GRAY2 = { WOOD1=50, WOOD4=50 },
  tex_METAL = "METAL2",

  sector_1  = { [0]=55, [1]=35, [2]=10, [3]=10, [8]=10, [17]=5 },

}

PREFABS.Joiner_simple1_hell =
{
  template   = "Joiner_simple1",
  map    = "MAP01",
  prob   = 100,

  theme  = "hell",

  tex_GRAY2 = { MARBGRAY=50, MARBLE2=50, MARBLE3=50 },
  tex_METAL = "SUPPORT3",
  tex_GRAY5 = "ASHWALL2",
  flat_FLAT1 = "FLOOR6_2",

  sector_1  = { [0]=55, [1]=35, [2]=10, [3]=10, [8]=10, [17]=5 },

}

-- a version of above with a little surprise
PREFABS.Joiner_simple1_trappy =
{
  template = "Joiner_simple1",
  map      = "MAP02",
  theme    = "tech",

  prob     = 200,
  style    = "traps",

  seed_w   = 3,
  seed_h   = 1,

  x_fit    = "frame",
  tex_GRAY2 = { GRAY2=50, TEKWALL1=50, TEKWALL4=50, CEMENT9=50, CEMENT8=50, METAL1=50 },

  sector_1  = { [0]=55, [1]=35, [2]=10, [3]=10, [8]=10, [17]=5 },

}

PREFABS.Joiner_simple1_trappy_urban =
{
  template = "Joiner_simple1",
  map      = "MAP02",
  theme    = "urban",

  prob     = 140,
  style    = "traps",

  seed_w   = 3,
  seed_h   = 1,

  x_fit    = "frame",

  tex_GRAY2 = { WOOD1=50, WOOD3=50, WOOD4=50 },
  tex_METAL = "METAL2",

  sector_1  = { [0]=55, [1]=35, [2]=10, [3]=10, [8]=10, [17]=5 },

}

PREFABS.Joiner_simple1_trappy_hell =
{
  template = "Joiner_simple1",
  map      = "MAP02",
  theme    = "hell",

  prob     = 140,
  style    = "traps",

  seed_w   = 3,
  seed_h   = 1,

  x_fit    = "frame",

  tex_GRAY2 = { MARBGRAY=50, MARBLE2=50, MARBLE3=50 },
  tex_GRAY5 = "ASHWALL2",
  tex_METAL = "SUPPORT3",
  flat_FLAT1 = "FLOOR6_2",

  sector_1  = { [0]=55, [1]=35, [2]=10, [3]=10, [8]=10, [17]=5 },

}


PREFABS.Joiner_simple1_wide =
{
  template = "Joiner_simple1",
  map      = "MAP03",
  theme    = "tech",

  prob     = 400,

  seed_w   = 3,
  seed_h   = 1,

  x_fit    = { 176,224 },

  tex_METAL = "COMPSPAN",
  tex_GRAY2 = { GRAY2=50, TEKWALL1=50, TEKWALL4=50, CEMENT9=50, CEMENT8=50, METAL1=50 },

  sector_1  = { [0]=55, [1]=35, [2]=10, [3]=10, [8]=10, [17]=5 },

}

PREFABS.Joiner_simple1_wide_urban =
{
  template = "Joiner_simple1",
  map      = "MAP03",
  theme    = "urban",

  prob     = 250,

  seed_w   = 3,
  seed_h   = 1,

  x_fit    = { 176,224 },

  tex_GRAY2 = { WOOD1=50, WOOD3=50, WOOD4=50 },
  tex_METAL = "METAL2",

  sector_1  = { [0]=55, [1]=35, [2]=10, [3]=10, [8]=10, [17]=5 },

}


PREFABS.Joiner_simple1_wide_hell =
{
  template = "Joiner_simple1",
  map      = "MAP03",
  theme    = "hell",

  prob     = 250,

  seed_w   = 3,
  seed_h   = 1,

  x_fit    = { 176,224 },

  tex_GRAY2 = { MARBGRAY=50, MARBLE2=50, MARBLE3=50 },
  tex_METAL = "SUPPORT3",
  tex_GRAY5 = "ASHWALL2",
  flat_FLAT1 = "FLOOR6_2",

  sector_1  = { [0]=55, [1]=35, [2]=10, [3]=10, [8]=10, [17]=5 },

}
