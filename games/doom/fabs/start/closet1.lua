--
-- Simple start closet
--

PREFABS.Start_closet1 =
{
  file  = "start/closet1.wad",

  prob  = 100,
  theme = "tech",

  where = "seeds",

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  -- door variations
  tex_DOOR1 = { DOOR1=50, DOOR3=50, SPCDOOR1=50, SPCDOOR3=50 },

  -- wall variations
  tex_BROWN1 = { BROWN1=50, BRONZE3=50, BROWNGRN=50, SLADWALL=50, METAL2=50, STARTAN3=50, STARG3=50, STARGR1=50, STARG1=50, TEKGREN2=50, TEKWALL4=50,
                 STONE=50, STONE2=50, STONE3=50, STONE4=50, METAL1=50 },

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=5, [12]=5, [13]=5 },

}

PREFABS.Start_closet1_urban =
{
  template ="Start_closet1",

  prob  = 100,
  theme = "urban",


  -- door variations
  tex_DOOR1 = { WOODMET1=50, WOODMET2=50, WOOD4=20, WOODMET3=20, WOODMET4=15, WOODGARG=50 },
  flat_FLAT1 = "CEIL5_2",
  tex_DOORSTOP = "SUPPORT3",


  -- wall variations
  tex_BROWN1 = { BIGBRIK1=50, BIGBRIK2=50, BRONZE1=50, BROWNHUG=50, CEMENT9=50, METAL2=50, MODWALL1=50, PANCASE2=50, ROCK1=50, ROCK2=50, ROCK3=50,
                 WOOD1=50, WOOD12=50, WOOD3=50, WOOD5=50, ZIMMER4=50, ZIMMER5=50, ZIMMER8=50, BRICK1=50, BRICK10=50, BRICK11=50, BRICK12=50, BRICK2=50,
                 BRICK3=50, BRICK4=50, BRICK5=50, BRICK6=50, BRICK7=50, BRICK8=10, BRICK9=50, MODWALL3=50, PANEL2=50, PANEL3=50, STONE4=50, STONE6=50,
                 STONE2=50, STONE3=50 },

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=5, [12]=5, [13]=5 },
}

PREFABS.Start_closet1_hell =
{
  template ="Start_closet1",

  prob  = 100,
  theme = "hell",


  -- door variations
  tex_DOOR1 = { WOODMET1=40, WOODMET2=30, WOOD4=20, WOODMET3=40, WOODMET4=35, WOODGARG=50 },
  flat_FLAT1 = "CEIL5_2",
  tex_DOORSTOP = "SUPPORT3",


  -- wall variations
  tex_BROWN1 = { ASHWALL2=50, ASHWALL4=50, ASHWALL7=50, BFALL1=50, BRICK10=50, BRICK8=50, BRICK9=50, BROWNHUG=50, BSTONE1=50, BSTONE2=50, CRACKLE2=50, CRACKLE4=50,
                 FIREBLU1=50, GRAYTALL=50, GSTONE1=50, GSTVINE1=50, GSTVINE2=50, MARBGRAY=50, MARBLE1=50, MARBLE2=50, MARBLE3=50, METAL2=50, MODWALL1=50, PANCASE1=50,
                 PANEL2=50, PANEL3=50, REDWALL=50, ROCK1=50, ROCK2=50, ROCK3=50, ROCK4=50, ROCK5=50, ROCKRED1=50, SKIN2=50, SKINCUT=50, SKINMET1=50, SKINMET2=50,
                 SKSNAKE1=50, SKSNAKE2=50, SP_FACE2=50, SP_ROCK1=50, SP_HOT1=50, SLOPPY1=50, SLOPPY2=50, STONE4=50, STONE6=50  },

  sector_1  = { [0]=75, [1]=15, [2]=5, [3]=5, [8]=5, [12]=5, [13]=5 },
}
