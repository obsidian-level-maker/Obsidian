PREFABS.Joiner_pillaged_shop =
{
  file   = "joiner/gtd_ruins.wad",
  map    = "MAP01",

  prob   = 850,

  theme  = "urban",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  flat_CEIL4_2 = { CEIL4_2=50, CEIL4_1=50 },
  flat_FLOOR0_1 = { FLOOR0_1=50, FLOOR0_2=50, FLOOR0_3=50,
    FLAT3=50, FLOOR0_5=50, FLOOR0_7=50, FLOOR4_6=50,
    FLOOR5_3=50, FLAT5_1=50, FLAT5_2=50, FLOOR3_3=50,
    FLOOR4_1=50, FLOOR4_8=50, FLOOR5_1=50, FLAT5=50 },

  tex_BROWN1 = { BROWN1=50, BROWNGRN=50, BROWN96=50,
    TEKGREN2=50, BRICK6=50, BRICK7=50, BRICK8=50,
    BRICK9=50, ICKWALL1=50, ICKWALL3=50, MODWALL1=50,
    STONE2=50, STONE3=50, BRICK11=50, BRICK12=50,
    STONE=50 },

  tex_PANEL2 = { PANEL2=50, PANEL3=50 },
  tex_METAL5 = { METAL5=50, METAL4=50 },
  tex_GRAY7 = { GRAY7=50, ICKWALL3=50, ICKWALL7=30 },

  x_fit = "frame",
}

PREFABS.Joiner_bombed_building =
{
  file = "joiner/gtd_ruins.wad",
  map = "MAP02",

  prob = 850,

  theme = "urban",

  env      = "!cave",
  neighbor = "!cave",

  where = "seeds",
  shape = "I",

  style = "steepness",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  delta_h = 104,
  nearby_h = 128,

  tex_BRICK9 = { BRICK9=50, BRICK8=50, BRICK7=50,
    BRICK6=50, BRICK2=50, BRICK12=50, BRICK11=50,
    BRICK1=50, STONE2=50, STONE3=50 },

  flat_FLAT5_2 = { FLAT5_2=50, FLAT5_1=50, FLAT5_5=50,
    FLAT5=50, FLOOR5_3=50, FLOOR4_8=50, FLOOR4_6=50,
    SLIME15=50, SLIME16=50 },

  flat_MFLR8_2 = { MFLR8_2=50, FLAT10=50 },
  flat_FLOOR6_2 = { FLOOR6_2=50, RROCK03=50 },

  can_flip = true,
}
