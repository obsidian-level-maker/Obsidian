--
-- Joiner with opening bars
--

PREFABS.Joiner_barred1 =
{
  file   = "joiner/barred1.wad",
  where  = "seeds",
  shape  = "I",

  key    = "barred",
  theme  = "tech",

  prob   = 70, --50,

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",
  tex_TEKLITE2 = { TEKLITE2=50, TEKWALL1=50, TEKWALL4=50 },
  tex_METAL = "TEKWALL4",
  tex_METAL2 = { METAL2=50, BRONZE1=50 },
  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
}

PREFABS.Joiner_barred1_tech2 =
{
  template   = "Joiner_barred1",
  theme      = "tech",

  tex_TEKLITE2 = "LITE3",
  tex_METAL = "TEKWALL4",
  tex_METAL2   = { TEKWALL4=50, TEKWALL1=50 },
  flat_CEIL5_2 = "CEIL5_1",
}

PREFABS.Joiner_barred1_hell =
{
  template   = "Joiner_barred1",
  theme      = "hell",

  tex_TEKLITE2 = { SP_FACE1=50, SP_FACE2=50, GSTVINE1=50, GSTVINE2=50, GSTONE1=50, WOOD1=50, WOOD3=50, WOOD4=50 },
  tex_METAL2   = "WOOD1",
  tex_METAL = { METAL=50, SUPPORT3=50 },
  flat_CEIL5_2 = "FLAT5_2",

}

PREFABS.Joiner_barred1_hell2 =
{
  template   = "Joiner_barred1",
  theme      = "hell",

  tex_TEKLITE2 = { SP_FACE1=50, SP_FACE2=50, GSTVINE1=50, GSTVINE2=50, GSTONE1=50, WOOD1=50, WOOD3=50, WOOD4=50 },
  tex_METAL2   = { SKSNAKE2=50, SKIN2=50 },
  tex_METAL = { METAL=50, SUPPORT3=50 },
  flat_CEIL5_2 = "BLOOD3",

}

PREFABS.Joiner_barred1_urban =
{
  template   = "Joiner_barred1",
  theme      = "urban",

  tex_TEKLITE2 = { WOOD3=50, WOOD4=50, WOOD1=50, WOODVERT=50 },
  tex_METAL = "METAL",
  tex_METAL2   = "PANBORD1",
  flat_CEIL5_2 = "RROCK09",

}

PREFABS.Joiner_barred1_urban2 =
{
  template   = "Joiner_barred1",
  theme      = "urban",

  tex_TEKLITE2 = { BLAKWAL1=50, BLAKWAL2=50 },
  tex_METAL = "METAL",
  tex_METAL2   = "PANBORD1",
  flat_CEIL5_2 = "CEIL5_1",

}
