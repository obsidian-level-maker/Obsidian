--
-- Triple keyed door
--

PREFABS.Locked_joiner_triple =
{
  file   = "joiner/key_triple.wad",
  where  = "seeds",
  shape  = "I",

  key    = "k_ALL",
  prob   = 100,

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  nearby_h = 160,

  flat_FLOOR7_1 = "BIGDOOR4",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7 },

}

PREFABS.Locked_joiner_triple2 =
{
  template   = "Locked_joiner_triple",

  tex_BIGDOOR4 = "BIGDOOR3",
  flat_FLOOR7_1 = "BIGDOOR3",
}

PREFABS.Locked_joiner_triple3 =
{
  template   = "Locked_joiner_triple",

  tex_BIGDOOR4 = "BIGDOOR2",
  flat_FLOOR7_1 = "BIGDOOR2",
}


-- variation for BOOM compatible ports
PREFABS.Locked_joiner_triple_boom =
{
  template = "Locked_joiner_triple",

  map = "MAP02",

  engine = "boom",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7 },

}

PREFABS.Locked_joiner_triple_boom2 =
{
  template = "Locked_joiner_triple",

  map = "MAP02",

  engine = "boom",

  tex_BIGDOOR4 = "BIGDOOR3",
  flat_FLOOR7_1 = "BIGDOOR3",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7 },

}

PREFABS.Locked_joiner_triple_boom3 =
{
  template = "Locked_joiner_triple",

  map = "MAP02",

  engine = "boom",

  tex_BIGDOOR4 = "BIGDOOR2",
  flat_FLOOR7_1 = "BIGDOOR2",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7 },

}

PREFABS.Locked_joiner_triple_boom_hell1 =
{
  template = "Locked_joiner_triple",

  map = "MAP02",
  theme = "hell",

  engine = "boom",

  tex_BIGDOOR4 = { BIGDOOR5=50, BIGDOOR7=50, WOODMET2=50 },
  tex_GRAY5 = "MARBLE1",
  flat_FLOOR7_1 = "CEIL5_2",
  flat_SLIME14 = "DEM1_6",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7, [17]=20 },

}

PREFABS.Locked_joiner_triple_boom_hell2 =
{
  template = "Locked_joiner_triple",

  map = "MAP02",
  theme = "hell",

  engine = "boom",

  tex_BIGDOOR4 = { MARBFACE=50, MARBFAC3=50, MARBFAC2=20 },
  tex_GRAY5 = "MARBLE1",
  flat_FLOOR7_1 = "FLOOR7_2",
  flat_SLIME14 = "DEM1_6",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7, [17]=20 },

}

PREFABS.Locked_joiner_triple_boom_urban1 =
{
  template = "Locked_joiner_triple",

  map = "MAP02",
  theme = "urban",

  engine = "boom",

  tex_BIGDOOR4 = { BIGDOOR5=50, BIGDOOR7=50, WOODMET2=50 },
  tex_GRAY5 = "WOOD1",
  flat_FLOOR7_1 = "CEIL5_2",
  flat_SLIME14 = { FLAT5_1=50, FLAT5_2=25 },

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7, [17]=10 },

}
