PREFABS.Joiner_simple_one_pillar =
{
  file   = "joiner/gtd_simple_one_pillar.wad",
  map    = "MAP01",
  theme  = "tech",

  prob   = 150,

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit = "frame",
  y_fit = { 24,40 , 120,136 },

  flat_CEIL5_2 = "FLAT19",
  tex_METAL = "SHAWN2",
  tex_CEMENT8 =
  {
    BRONZE2 = 50,
    BRONZE4 = 50,
    BROWNGRN = 50,
    SLADWALL = 50,
    CEMENT8 = 50,
    COMPBLUE = 50,
    COMPSPAN = 50,
    GRAY1 = 50,
    GRAY4 = 50,
    GRAY5 = 50,
    METAL2 = 20,
    METAL3 = 20,
    METAL4 = 20,
    METAL5 = 20,
    METAL6 = 20,
    METAL7 = 20,
    PIPES = 50,
    PIPEWAL1 = 50,
    SILVER2 = 50,
    SILVER3 = 50,
    TEKBRON2 = 50,
    TEKGREN1 = 50,
    TEKGREN3 = 50,
    TEKGREN5 = 50,
    TEKLITE = 50,
    TEKLITE2 = 50,
  },

  tex_SUPPORT3 = "DOORSTOP",
}

PREFABS.Joiner_simple_one_pillar_urban =
{
  template = "Joiner_simple_one_pillar",
  theme = "urban",

  tex_CEMENT8 =
  {
    BIGBRIK1 = 50,
    BIGBRIK2 = 50,
    BIGBRIK3 = 50,
    BRICK12 = 50,
    BRICK7 = 50,
    BSTONE3 = 50,
    CEMENT8 = 50,
    CEMENT7 = 50,
    CEMENT9 = 50,
    GRAY1 = 50,
    GRAY4 = 50,
    GRAY5 = 50,
    MODWALL1 = 50,
    PIPES = 50,
    PANCASE1 = 50,
    PANEL1 = 50,
    PANEL2 = 50,
    PANEL3 = 50,
    PANBLACK = 50,
    PANBLUE = 50,
    PANRED = 50,
    STONE4 = 50,
    STONE6 = 50,
    STUCCO1 = 50,
    WOOD6 = 50,
    WOOD7 = 50,
    WOOD9 = 50,
    WOODGARG = 50,
    WOODMET1 = 50,
    WOODVERT = 50,
    WOOD4 = 50,
  },
}

PREFABS.Joiner_simple_one_pillar_hell =
{
  template = "Joiner_simple_one_pillar",
  theme = "hell",

  tex_CEMENT8 =
  {
    BRICK10 = 50,
    BSTONE3 = 50,
    CEMENT9 = 50,
    GSTGARG = 50,
    GSTLION = 50,
    GSTSATYR = 50,
    MARBLE2 = 50,
    MARBLE3 = 50,
    MARBGRAY = 50,
    MARBFAC4 = 50,
    PANBLACK = 50,
    PANBLUE = 50,
    PANRED = 50,
    PANCASE1 = 50,
    PANEL1 = 50,
    PANEL2 = 50,
    PANEL4 = 50,
    SKIN2 = 50,
    SKSNAKE1 = 50,
    SKSNAKE2 = 50,
    SKSPINE2 = 50,
    SK_LEFT = 25,
    SK_RIGHT = 25,
    SLADSKUL = 50,
    SP_DUDE4 = 50,
    SP_DUDE5 = 50,
    WOOD4 = 50,
    WOODGARG = 50,
    WOODMET1 = 50,
  },
}
