PREFABS.Pic_mining_dirt_fenced =
{
  file = "picture/gtd_pic_industrial_mine.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_mining_set",

  where  = "seeds",
  height = 96,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  x_fit = { 20,236 },
  y_fit = "top",
  z_fit = { 24,26 },

  tex_STONE7 =
  {
    BSTONE1 = 1,
    STONE6 = 3,
    STONE7 = 3,
    ZIMMER5 = 1
  }
}

PREFABS.Pic_mining_dirt_fenced_driller =
{
  template = "Pic_mining_dirt_fenced",
  map = "MAP02",

  line_85 =
  {
    [85] = 4,
    [0] = 1,
  },

  y_fit = "top",
  x_fit = { 20,72 , 168,220 }
}

PREFABS.Pic_mining_dirt_fenced_radium =
{
  template = "Pic_mining_dirt_fenced",
  map = "MAP01",

  texture_pack = "armaetus",

  tex_STONE7 =
  {
    GRNSTONE = 1
  },

  tex_RROCK18 =
  {
    GRNRKF = 1
  }
}

PREFABS.Pic_mining_dirt_fenced_driller_radium =
{
  template = "Pic_mining_dirt_fenced",
  map = "MAP02",

  line_85 =
  {
    [85] = 4,
    [0] = 1,
  },

  y_fit = "top",
  x_fit = { 20,72 , 168,220 },

  texture_pack = "armaetus",

  tex_STONE7 =
  {
    GRNSTONE = 1
  },

  tex_RROCK18 =
  {
    GRNRKF = 1
  }
}

--

PREFABS.Pic_mining_dirt_fenced_broken =
{
  template = "Pic_mining_dirt_fenced",
  map = "MAP03",

  x_fit = { 20,72 , 168,220 }

}PREFABS.Pic_mining_dirt_fenced_some_more_radium =
{
  template = "Pic_mining_dirt_fenced",
  map = "MAP04",

  texture_pack = "armaetus",

  x_fit = { 20,72 , 168,220 }
}
