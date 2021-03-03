--
-- Large 2x2 keyed joiner
--

PREFABS.Locked_2x2_red =
{
  file   = "joiner/key_2x2.wad",
  map    = "MAP01",
  theme  = "tech",

  where  = "seeds",
  shape  = "I",

  key    = "k_red",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  prob   = 150,

  delta_h  = -40,
  nearby_h = 128,

  y_fit = { 160,168 },
  x_fit = "frame",

  -- texture is already "DOORRED",
  -- line special is already #135 (open red door)

  flat_FLAT23 = "BIGDOOR2",

  can_flip = true,
}


PREFABS.Locked_2x2_blue =
{
  template = "Locked_2x2_red",

  key      = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}


PREFABS.Locked_2x2_yellow =
{
  template = "Locked_2x2_red",

  key      = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}


--Hell version

PREFABS.Locked_2x2_red_hell =
{
  template = "Locked_2x2_red",
  theme    = "hell",

  key      = "k_red",
  tex_DOORRED = "DOORRED",
  tex_BIGDOOR2 = "BIGDOOR7",
  flat_FLAT23  = "CEIL5_2",
  flat_FLAT5_4 = "DEM1_6",
  flat_CEIL3_3 = "FLOOR6_2",
  tex_BRICK4   = "ASHWALL2",
  tex_STONE = "MARBGRAY",

}

PREFABS.Locked_2x2_blue_hell =
{
  template = "Locked_2x2_red",
  theme    = "hell",

  key      = "k_blue",
  tex_DOORRED = "DOORBLU",
  tex_BIGDOOR2 = "BIGDOOR7",
  flat_FLAT23  = "CEIL5_2",
  flat_FLAT5_4 = "DEM1_6",
  flat_CEIL3_3 = "FLOOR6_2",
  tex_BRICK4   = "ASHWALL2",
  tex_STONE = "MARBGRAY",
  line_33     = 32,

}

PREFABS.Locked_2x2_yellow_hell =
{
  template = "Locked_2x2_red",
  theme    = "hell",

  key      = "k_yellow",
  tex_DOORRED = "DOORYEL",
  tex_BIGDOOR2 = "BIGDOOR7",
  flat_FLAT23  = "CEIL5_2",
  flat_FLAT5_4 = "DEM1_6",
  flat_CEIL3_3 = "FLOOR6_2",
  tex_BRICK4   = "ASHWALL2",
  tex_STONE = "MARBGRAY",
  line_33     = 34,

}

--Urban version

PREFABS.Locked_2x2_red_urban =
{
  template = "Locked_2x2_red",
  theme    = "urban",

  key      = "k_red",
  tex_DOORRED = "DOORRED",
  tex_BIGDOOR2 = "BIGDOOR5",
  flat_FLAT23  = "CEIL5_2",
  flat_FLAT5_4 = { FLAT5_1=50, FLAT5_2=50 },
  tex_STONE = "WOOD1",
  flat_CEIL3_3 = "RROCK09",
  tex_BRICK4   = "TANROCK3",

}

PREFABS.Locked_2x2_blue_urban =
{
  template = "Locked_2x2_red",
  theme    = "urban",

  key      = "k_blue",
  tex_DOORRED = "DOORBLU",
  tex_BIGDOOR2 = "BIGDOOR5",
  flat_FLAT23  = "CEIL5_2",
  flat_FLAT5_4 = { FLAT5_1=50, FLAT5_2=50 },
  tex_STONE = "WOOD1",
  flat_CEIL3_3 = "RROCK09",
  tex_BRICK4   = "TANROCK3",
  line_33     = 32,

}

PREFABS.Locked_2x2_yellow_urban =
{
  template = "Locked_2x2_red",
  theme    = "urban",

  key      = "k_yellow",
  tex_DOORRED = "DOORYEL",
  tex_BIGDOOR2 = "BIGDOOR5",
  flat_FLAT23  = "CEIL5_2",
  flat_FLAT5_4 = { FLAT5_1=50, FLAT5_2=50 },
  tex_STONE = "WOOD1",
  flat_CEIL3_3 = "RROCK09",
  tex_BRICK4   = "TANROCK3",
  line_33     = 34,

}
