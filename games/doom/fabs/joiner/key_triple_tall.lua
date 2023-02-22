--
-- Triple keyed door
--

PREFABS.Locked_joiner_triple_tall =
{
  file   = "joiner/key_triple_tall.wad",
  where  = "seeds",
  shape  = "I",

  key    = "k_ALL",
  prob   = 25,

  seed_w = 1,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  nearby_h = 160,

  flat_FLOOR7_1 = "BIGDOOR4",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7 },

}

PREFABS.Locked_joiner_triple2_tall =
{
  template   = "Locked_joiner_triple_tall",

  tex_BIGDOOR4 = "BIGDOOR3",
  flat_FLOOR7_1 = "BIGDOOR3",
}

PREFABS.Locked_joiner_triple3_tall =
{
  template   = "Locked_joiner_triple_tall",

  tex_BIGDOOR4 = "BIGDOOR2",
  flat_FLOOR7_1 = "BIGDOOR2",
}


-- variation for BOOM compatible ports
PREFABS.Locked_joiner_triple_boom_tall =
{
  template = "Locked_joiner_triple_tall",

  map = "MAP02",

  port = "boom",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7 },

}

PREFABS.Locked_joiner_triple_boom2_tall =
{
  template = "Locked_joiner_triple_tall",

  map = "MAP02",

  port = "boom",

  tex_BIGDOOR4 = "BIGDOOR3",
  flat_FLOOR7_1 = "BIGDOOR3",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7 },

}

PREFABS.Locked_joiner_triple_boom3_tall =
{
  template = "Locked_joiner_triple_tall",

  map = "MAP02",

  port = "boom",

  tex_BIGDOOR4 = "BIGDOOR2",
  flat_FLOOR7_1 = "BIGDOOR2",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7 },

}

PREFABS.Locked_joiner_triple_boom_hell1_tall =
{
  template = "Locked_joiner_triple_tall",

  map = "MAP02",
  theme = "hell",

  port = "boom",

  tex_BIGDOOR4 = { BIGDOOR5=50, BIGDOOR7=50, WOODMET2=50 },
  tex_GRAY5 = "MARBLE1",
  flat_FLOOR7_1 = "CEIL5_2",
  flat_SLIME14 = "DEM1_6",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7, [17]=20 },

}

PREFABS.Locked_joiner_triple_boom_hell2_tall =
{
  template = "Locked_joiner_triple_tall",

  map = "MAP02",
  theme = "hell",

  port = "boom",

  tex_BIGDOOR4 = { MARBFACE=50, MARBFAC3=50, MARBFAC2=20 },
  tex_GRAY5 = "MARBLE1",
  flat_FLOOR7_1 = "FLOOR7_2",
  flat_SLIME14 = "DEM1_6",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7, [17]=20 },

}

PREFABS.Locked_joiner_triple_stretchy_tall_tech =
{
  template = "Locked_joiner_triple_tall",
  map = "MAP03",

  prob = 75,

  theme = "!hell",

  seed_w = 2,

  x_fit = "frame"
}

PREFABS.Locked_joiner_triple_stretchy_tall_hell =
{
  template = "Locked_joiner_triple_tall",
  map = "MAP03",

  prob = 75,

  theme = "hell",

  seed_w = 2,

  x_fit = "frame",

  tex_SPCDOOR1 = "WOODMET2"
}

--

PREFABS.Locked_joiner_triple_stretchy2_tall_tech =
{
  template = "Locked_joiner_triple_tall",
  map = "MAP04",

  prob = 75,

  theme = "!hell",

  seed_w = 2,

  x_fit = "frame"
}

PREFABS.Locked_joiner_triple_stretchy2_tall_hell =
{
  template = "Locked_joiner_triple_tall",
  map = "MAP04",

  prob = 75,

  theme = "hell",

  seed_w = 2,

  x_fit = "frame",

  tex_SPCDOOR1 = "WOODGARG"
}
