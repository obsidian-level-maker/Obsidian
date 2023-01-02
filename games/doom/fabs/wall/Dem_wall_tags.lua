--
-- Walls with tags
--

PREFABS.Wall_Dem_tags_reg =
{
  file   = "wall/Dem_wall_tags.wad",
  map    = "MAP01",

  prob   = 5,

  theme = "urban",

  where  = "edge",
  height = 128,
  deep   = 20,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  texture_pack = "armaetus",

  tex_TAG1 =
  {
    TAG1 = 50,
    TAG2 = 50,
    TAG4 = 50,
    TAG6 = 50,
    TAG9 = 50,
    TAG10 = 50,
    TAG11 = 50,
    TAGCR1 = 50,
    TAGCR4 = 50,
    TAGCR5 = 50,
    TAGCR6 = 50,
    TAGCR7 = 50,
    TAGCR9 = 50,
    TAGCR10 = 50,
    TAGCR11 = 50,
    TAGCR12 = 50,
    TAGCR15 = 50,
    TAGCR16 = 50,

  },
}


PREFABS.Dem_wall_tagswide =
{
  template = "Wall_Dem_tags_reg",
  map    = "MAP02",

  prob   = 3,

  x_fit = "stretch",

  tex_TAG1 =
  {
   TAG3 = 50,
   TAG5 = 50,
   TAG7 = 50,
   TAG8 = 50,
   TAGCR2 = 50,
   TAGCR3 = 50,
   TAGCR8 = 50,
   TAGCR13 = 50,
   TAGCR14 = 50,
  },
}

PREFABS.Dem_wall_tagslogs =
{
  template = "Wall_Dem_tags_reg",
  map    = "MAP03",

  prob   = 5,

  on_liquids = "never",

  deep   = 64,
}
