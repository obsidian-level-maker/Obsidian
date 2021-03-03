--
-- Simple joiner II
--

PREFABS.Joiner_simple2 =
{
  file   = "joiner/simple2.wad",
  map    = "MAP01",
  theme  = "!tech",

  prob   = 150,

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit = "frame",
  y_fit = { 24,40 , 120,136 },

  tex_WOODMET4 = { WOODMET2=50, WOOD1=50, WOOD3=50, WOOD4=50, WOODVERT=50, WOODGARG=50, PANRED=50, PANBLUE=50, PANBLACK=50,
                   WOOD6=50, WOOD8=50, WOOD9=50 },
  tex_SHAWN2 = "WOOD1",
  flat_FLAT20 = { FLAT5_1=50, FLAT5_2=50 },

}

PREFABS.Joiner_simple2_urban1 =
{
  template   = "Joiner_simple2",
  theme      = "!tech",

  tex_WOODMET4 = { WOODMET2=50, WOOD1=50, WOOD3=50, WOOD4=50, WOODVERT=50, WOODGARG=50, PANRED=50, PANBLUE=50, PANBLACK=50,
                   WOOD6=50, WOOD8=50, WOOD9=50 },
  tex_SHAWN2 = "WOOD1",
  flat_FLAT20 = { FLAT5_1=50, FLAT5_2=50 },

}

PREFABS.Joiner_simple2_urban2 =
{
  template   = "Joiner_simple2",
  theme      = "urban",

  tex_WOODMET4 = { BIGBRIK1=50, BIGBRIK2=50, BIGBRIK3=50 },

  tex_SHAWN2 = "STONE",
  flat_FLAT20 = "FLAT5_4",

}

PREFABS.Joiner_simple2_urban3 =
{
  template   = "Joiner_simple2",
  theme      = "urban",

  tex_WOODMET4 = { BLAKWAL1=50, BLAKWAL2=50, MODWALL1=50, MODWALL3=50 },
  tex_SHAWN2 = "STONE6",
  flat_FLAT20 = { FLAT8=50, FLOOR0_2=50 },


}

PREFABS.Joiner_simple2_urban4 =
{
  template   = "Joiner_simple2",
  theme      = "!hell",

  tex_WOODMET4 = { CEMENT7=50, CEMENT8=50, CEMENT9=50 },
  tex_SHAWN2 = "CEMENT9",
  flat_FLAT20 = { FLAT5_4=50, FLAT19=50 },

}

PREFABS.Joiner_simple2_urban5 =
{
  template   = "Joiner_simple2",
  theme      = "urban",

  tex_WOODMET4 = { STONE6=50, STUCCO1=50, STUCCO2=50, STUCCO3=50 },
  tex_SHAWN2 = "STUCCO",
  flat_FLAT20 = { FLAT5_5=50, FLAT5=50, FLOOR0_1=50 },
}

PREFABS.Joiner_simple2_tech1 =
{
  template   = "Joiner_simple2",
  theme      = "tech",

  tex_WOODMET4 = { BRONZE1=50, BRONZE2=50, BRONZE3=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "SHAWN2",
  flat_FLAT20 = { FLAT20=50, FLAT23=50 },

}

PREFABS.Joiner_simple2_tech2 =
{
  template   = "Joiner_simple2",
  theme      = "tech",

  tex_WOODMET4 = { STONE=50, STONE2=50, STONE3=50, STONE4=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "STONE",
  flat_FLAT20 = { FLAT5_4=50, FLOOR0_3=50 },

}

PREFABS.Joiner_simple2_tech3 =
{
  template   = "Joiner_simple2",
  theme      = "tech",

  tex_WOODMET4 = { GRAY1=50, GRAY4=50, GRAY5=50, GRAYBIG=50, GRAYTALL=50 },
  tex_SUPOORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "STONE",
  flat_FLAT20 = { FLAT5_4=50, FLOOR0_3=50, FLAT19=50 },

}

PREFABS.Joiner_simple2_tech4 =
{
  template   = "Joiner_simple2",
  theme      = "tech",

  tex_WOODMET4 = { ICKWALL1=50, ICKWALL2=50, ICKWALL3=50, ICKWALL4=50, ICKWALL7=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "STONE4",
  flat_FLAT20 = { FLAT5_4=50, FLOOR0_3=50 },

}

PREFABS.Joiner_simple2_tech5 =
{
  template   = "Joiner_simple2",
  theme      = "tech",

  tex_WOODMET4 = { METAL1=50, METAL2=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "METAL2",
  flat_FLAT20 = { SLIME14=50, SLIME15=50 },

}

PREFABS.Joiner_simple2_tech6 =
{
  template   = "Joiner_simple2",
  theme      = "tech",

  tex_WOODMET4 = { SHAWN2=50, SUPPORT2=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "SHAWN2",
  flat_FLAT20 = { FLAT20=50, FLAT23=50 },

}

PREFABS.Joiner_simple2_tech7 =
{
  template   = "Joiner_simple2",
  theme      = "tech",

  tex_WOODMET4 = { TEKWALL1=50, TEKWALL4=50, TEKLITE=50, TEKLITE2=50, TEKBRON2=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = { TEKWALL4=50, TEKWALL1=50 },
  flat_FLAT20 = "CEIL5_1",

}

PREFABS.Joiner_simple2_hell1 =
{
  template   = "Joiner_simple2",
  theme      = "hell",

  tex_WOODMET4 = { BSTONE1=50, BSTONE2=50 },
  tex_SHAWN2 = { STONE6=50, STONE7=50 },
  flat_FLAT20 = { FLAT5_5=50, FLAT5=50 },

}

PREFABS.Joiner_simple2_hell2 =
{
  template   = "Joiner_simple2",
  theme      = "hell",

  tex_WOODMET4 = { MARBGRAY=50, MARBLE1=50, MARBLE2=50, MARBLE3=50 },
  tex_SHAWN2 = "MARBLE1",
  flat_FLAT20 = { DEM1_5=50, DEM1_6=50, FLOOR7_2=50 },

}

PREFABS.Joiner_simple2_hell3 =
{
  template   = "Joiner_simple2",
  theme      = "hell",

  tex_WOODMET4 = { SKIN2=50, SKINEDGE=50, SKSPINE1=50, SKSNAKE2=50, SLOPPY1=50, SLOPPY2=50, SP_FACE2=50 },
  tex_SHAWN2 = "SKSNAKE1",
  flat_FLAT20 = "SFLR6_1",

}

PREFABS.Joiner_simple2_hell3a =
{
  template   = "Joiner_simple2",
  theme      = "hell",

  tex_WOODMET4 = { SKIN2=50, SKINEDGE=50, SKSPINE1=50, SKSNAKE2=50, SLOPPY1=50, SLOPPY2=50, SP_FACE2=50 },
  tex_SHAWN2 = "SKSNAKE2",
  flat_FLAT20 = "SFLR6_4",

}

PREFABS.Joiner_simple2_hell4 =
{
  template   = "Joiner_simple2",
  theme      = "hell",

  tex_WOODMET4 = { FIREBLU1=50, CRACKLE2=50, CRACKLE4=50 },
  tex_SHAWN2 = "SP_HOT1",
  flat_FLAT20 = "FLAT5_3",

}

PREFABS.Joiner_simple2_hell5 =
{
  template   = "Joiner_simple2",
  theme      = "hell",

  tex_WOODMET4 = { ASHWALL2=50, ASHWALL3=50, ASHWALL4=50, ASHWALL6=50, ASHWALL7=50 },
  tex_SHAWN2 = "METAL",
  flat_FLAT20 = "CEIL5_2",

}


PREFABS.Joiner_simple2_general1 =
{
  template   = "Joiner_simple2",
  theme      = "!tech",

  tex_WOODMET4 = { SW1GARG=50, SW1SATYR=50, SW1LION=50, SUPPORT3=50 },
  tex_SHAWN2 = { STONE4=50, STONE=50 },
  flat_FLAT20 = "FLAT5_4",

}

PREFABS.Joiner_simple2_general2 =
{
  template   = "Joiner_simple2",

  tex_WOODMET4 = { BROWNHUG=50, BROWN144=50, BROWNGRN=50, BROWN96=50, BROWNPIP=50 },
  tex_SHAWN2 = "GRAY1",
  flat_FLAT20 = "FLAT5_4",

}
