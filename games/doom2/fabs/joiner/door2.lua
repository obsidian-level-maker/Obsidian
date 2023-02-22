--
-- Joiner with opening door
--

PREFABS.Joiner_door2 =
{
  file   = "joiner/door2.wad",
  map    = "MAP01",

  prob   = 200,
  theme  = "urban",
  style  = "doors",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  sector_1  = { [0]=70, [1]=15, [2]=5, [3]=5, [8]=10, [12]=7, [13]=7 },

}

PREFABS.Joiner_door2_urban2 =
{
  template = "Joiner_door2",
  map      = "MAP01",
  prob     = 100,

  theme  = "urban",

tex_BIGDOOR4 = "BIGDOOR3",
flat_FLOOR0_1 = "BIGDOOR3",

}

PREFABS.Joiner_door2_urban3 =
{
  template = "Joiner_door2",
  map      = "MAP01",
  prob     = 75,

  theme  = "urban",

tex_BIGDOOR4 = "BIGDOOR2",
flat_FLOOR0_1 = "FLAT20",

}

PREFABS.Joiner_door2_urban4 =
{
  template = "Joiner_door2",
  map      = "MAP01",

  theme  = "urban",

tex_BIGDOOR4 = { BIGDOOR5=50, BIGDOOR6=50, BIGDOOR7=50, WOODMET2=50 },
flat_FLOOR0_1 = "CEIL5_2",

}


PREFABS.Joiner_door2_tech1 =
{
  template = "Joiner_door2",
  map      = "MAP03",

  theme  = "tech",

  flat_FLOOR0_3 = { FLOOR0_3=50, FLAT5_4=50, CEIL3_5=50, FLAT1=50 },

}

PREFABS.Joiner_door2_tech2 =
{
  template = "Joiner_door2",
  map      = "MAP03",

  theme  = "tech",

tex_BIGDOOR2 = "BIGDOOR3",
flat_FLAT20 = "FLOOR7_2",

flat_FLOOR0_3 = { FLOOR0_3=50, FLAT5_4=50, CEIL3_5=50, FLAT1=50 },

}

PREFABS.Joiner_door2_tech3 =
{
  template = "Joiner_door2",
  map      = "MAP03",

  theme  = "tech",

tex_BIGDOOR2 = "BIGDOOR4",
flat_FLAT20 = "FLOOR7_1",

  flat_FLOOR0_3 = { FLOOR0_3=50, FLAT5_4=50, CEIL3_5=50, FLAT1=50 },

}

PREFABS.Joiner_door2_tech4 =
{
  template = "Joiner_door2",
  map      = "MAP03",

  theme  = "tech",

tex_BIGDOOR2 = "TEKBRON1",
flat_FLAT20 = "CRATOP2",

  flat_FLOOR0_3 = { FLOOR0_3=50, FLAT5_4=50, CEIL3_5=50, FLAT1=50 },

}


PREFABS.Joiner_door2_hell =
{
  template = "Joiner_door2",
  map      = "MAP02",

  theme  = "hell",

tex_BIGDOOR6 = { BIGDOOR6=50, BIGDOOR7=50, BIGDOOR5=50, WOODMET2=50 },

tex_STONE2 = "STONE3",
}


PREFABS.Joiner_door2_hell2 =
{
  template = "Joiner_door2",
  map      = "MAP02",
  prob     = 150,

  theme  = "hell",

tex_BIGDOOR6 = { MARBFACE=50, MARBFAC3=50, MARBFAC2=15 },
tex_STONE2 = "STONE3",
flat_CEIL5_2 = "FLOOR7_2",

}

PREFABS.Joiner_door2_hell3 =
{
  template = "Joiner_door2",
  map      = "MAP02",
  prob     = 80,

  theme  = "hell",

tex_BIGDOOR6 = "SKSPINE1",
tex_METAL = "STONE3",
flat_CEIL5_2 = "FLAT5_6",

}

PREFABS.Joiner_door2_hell4 =
{
  template = "Joiner_door2",
  map      = "MAP02",

  theme  = "hell",

tex_BIGDOOR6 = "WOODGARG",
tex_STONE2 = "STONE3",
flat_CEIL5_2 = "FLAT5_2",

}
