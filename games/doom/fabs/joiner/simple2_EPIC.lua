--
-- Simple joiner II EPIC
--

PREFABS.Joiner_simple2_epic =
{
  file   = "joiner/simple2_EPIC.wad",
  map    = "MAP01",
  theme  = "!tech",

  prob   = 150, --600,

  where  = "seeds",
  shape  = "I",

  texture_pack = "armaetus",

  seed_w = 3,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit = "frame",
  y_fit = { 24,32 , 128,136 },

  tex_WOODMET4 = { WOODMET2=50, WOOD1=50, WOOD3=50, WOOD4=50, WOODVERT=50, WOODGARG=50, PANRED=50, PANBLUE=50, PANBLACK=50,
                   WOOD6=50, WOOD8=50, WOOD9=50, WOODSKUL=50 },
  tex_SHAWN2 = "WOOD1",
  flat_FLAT20 = { FLAT5_1=50, FLAT5_2=50 },

}

PREFABS.Joiner_simple2_urban1_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "!tech",

  tex_WOODMET4 = { WOODMET2=50, WOOD1=50, WOOD3=50, WOOD4=50, WOODVERT=50, WOODGARG=50, PANRED=50, PANBLUE=50, PANBLACK=50,
                   WOOD6=50, WOOD8=50, WOOD9=50, WOODSKUL=50 },
  tex_SHAWN2 = "WOOD1",
  flat_FLAT20 = { FLAT5_1=50, FLAT5_2=50 },

}

PREFABS.Joiner_simple2_urban2_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "urban",

  tex_WOODMET4 = { BIGBRIK1=50, BIGBRIK2=50, BIGBRIK3=50, STONGARG=50, STONE2=50, STONE3=50 },

  tex_SHAWN2 = "STONE",
  flat_FLAT20 = "FLAT5_4",

}

PREFABS.Joiner_simple2_urban3_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "urban",

  tex_WOODMET4 = { BLAKWAL1=50, BLAKWAL2=50, MODWALL1=50, MODWALL3=50 },
  tex_SHAWN2 = "STONE6",
  flat_FLAT20 = { FLAT8=50, FLOOR0_2=50 },


}

PREFABS.Joiner_simple2_urban4_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "!hell",

  tex_WOODMET4 = { CEMENT7=50, CEMENT8=50, CEMENT9=50 },
  tex_SHAWN2 = "CEMENT9",
  flat_FLAT20 = { FLAT5_4=50, FLAT19=50 },

}

PREFABS.Joiner_simple2_urban5_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "urban",

  tex_WOODMET4 = { STONE6=50, STUCCO1=50, STUCCO2=50, STUCCO3=50 },
  tex_SHAWN2 = "STUCCO",
  flat_FLAT20 = { FLAT5_5=50, FLAT5=50, FLOOR0_1=50 },
}

PREFABS.Joiner_simple2_tech1_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "tech",

  tex_WOODMET4 = { BRONZE1=50, BRONZE2=50, BRONZE3=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "SHAWN2",
  flat_FLAT20 = { FLAT20=50, FLAT23=50 },

}

PREFABS.Joiner_simple2_tech2_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "tech",

  tex_WOODMET4 = { STONE=50, STONE2=50, STONE3=50, STONE4=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "STONE",
  flat_FLAT20 = { FLAT5_4=50, FLOOR0_3=50 },

}

PREFABS.Joiner_simple2_tech3_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "tech",

  tex_WOODMET4 = { GRAY1=50, GRAY4=50, GRAY5=50, GRAYBIG=50, GRAYTALL=50 },
  tex_SUPOORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "STONE",
  flat_FLAT20 = { FLAT5_4=50, FLOOR0_3=50, FLAT19=50 },

}

PREFABS.Joiner_simple2_tech4_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "tech",

  tex_WOODMET4 = { ICKWALL1=50, ICKWALL2=50, ICKWALL3=50, ICKWALL4=50, ICKWALL7=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "STONE4",
  flat_FLAT20 = { FLAT5_4=50, FLOOR0_3=50 },

}

PREFABS.Joiner_simple2_tech5_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "tech",

  tex_WOODMET4 = { METAL1=50, METAL2=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "METAL2",
  flat_FLAT20 = { SLIME14=50, SLIME15=50 },

}

PREFABS.Joiner_simple2_tech6_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "tech",

  tex_WOODMET4 = { SHAWN2=50, SUPPORT2=50, TEKSHAW=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = "SHAWN2",
  flat_FLAT20 = { FLAT20=50, FLAT23=50 },

}

PREFABS.Joiner_simple2_tech7_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "tech",

  tex_WOODMET4 = { TEKWALL1=50, TEKWALL4=50, TEKLITE=50, TEKLITE2=50, TEKBRON2=50, TEKWALL8=50, TEKWALL9=50, TEKWALLA=50, TEKWALLB=50,
                   TEKWALLC=50, TEKWALLD=50, TEKWALLE=50, TEKWALL2=50 },
  tex_SUPPORT3 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_SHAWN2 = { TEKWALL4=50, TEKWALL1=50 },
  flat_FLAT20 = "CEIL5_1",

}

PREFABS.Joiner_simple2_hell1_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "hell",

  tex_WOODMET4 = { BSTONE1=50, BSTONE2=50, BRIKS03=50, BRIKS05=50, BRIKS13=50, BRIKS14=50, BRIKS16=50, BRIKS18=50, BRIKS19=50, BRIKS23=50, BRIKS29=50, BRIKS30=50,
                   BRIKS39=50, BRIKS40=50 },
  tex_SHAWN2 = { STONE6=50, STONE7=50 },
  flat_FLAT20 = { FLAT5_5=50, FLAT5=50 },

}

PREFABS.Joiner_simple2_hell2_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "hell",

  tex_WOODMET4 = { MARBGRAY=50, MARBLE1=50, MARBLE2=50, MARBLE3=50, KMARBLE1=50, KMARBLE2=50, KMARBLE3=50 },
  tex_SHAWN2 = "MARBLE1",
  flat_FLAT20 = { DEM1_5=50, DEM1_6=50, FLOOR7_2=50 },

}

PREFABS.Joiner_simple2_hell3_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "hell",

  tex_WOODMET4 = { SKIN2=50, SKINEDGE=50, SKSPINE1=50, SKSNAKE2=50, SLOPPY1=50, SLOPPY2=50, SP_FACE2=50, BONES1=50, BONES2=50, BONES3=50,
                   SKULLS=50, SKULLS2=50, SKULLS3=50, SKULLS4=50 },
  tex_SHAWN2 = "SKSNAKE1",
  flat_FLAT20 = "SFLR6_1",

}

PREFABS.Joiner_simple2_hell3a_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "hell",

  tex_WOODMET4 = { SKIN2=50, SKINEDGE=50, SKSPINE1=50, SKSNAKE2=50, SLOPPY1=50, SLOPPY2=50, SP_FACE2=50, BONES1=50, BONES2=50, BONES3=50,
                   SKULLS=50, SKULLS2=50, SKULLS3=50, SKULLS4=50 },
  tex_SHAWN2 = "SKSNAKE2",
  flat_FLAT20 = "SFLR6_4",

}

PREFABS.Joiner_simple2_hell4_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "hell",

  tex_WOODMET4 = { FIREBLU1=50, CRACKLE2=50, CRACKLE4=50, LAVBLUE1=50, LAVGREN1=50, LAVWHIT1=50, LAVBLAK1=20 },
  tex_SHAWN2 = "SP_HOT1",
  flat_FLAT20 = "FLAT5_3",

}

PREFABS.Joiner_simple2_hell5_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "hell",

  tex_WOODMET4 = { ASHWALL2=50, ASHWALL3=50, ASHWALL4=50, ASHWALL6=50, ASHWALL7=50, ASH05=50, ASHWALL1=50 },
  tex_SHAWN2 = "METAL",
  flat_FLAT20 = "CEIL5_2",

}

PREFABS.Joiner_simple2_hell6_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "hell",

  tex_WOODMET4 = { RUSTWAL2=50, RUSTWAL3=50, RUSTWAL4=50 },
  tex_SHAWN2 = "HELMET2",
  flat_FLAT20 = "CEIL5_2",

}


PREFABS.Joiner_simple2_general1_epic =
{
  template   = "Joiner_simple2_epic",
  theme      = "!tech",

  tex_WOODMET4 = { SW1GARG=50, SW1SATYR=50, SW1LION=50, SUPPORT3=50, STONGARG=30 },
  tex_SHAWN2 = { STONE4=50, STONE=50 },
  flat_FLAT20 = "FLAT5_4",

}

PREFABS.Joiner_simple2_general2_epic =
{
  template   = "Joiner_simple2_epic",

  tex_WOODMET4 = { BROWNHUG=50, BROWN144=50, BROWNGRN=50, BROWN96=50, BROWNPIP=50 },
  tex_SHAWN2 = "GRAY1",
  flat_FLAT20 = "FLAT5_4",

}
