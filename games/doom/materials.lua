--------------------------------------------------------------------
--  DOOM MATERIALS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C) 2011,2017 Armaetus
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.LIQUIDS =
{
  water  = { mat="FWATER1", special=0 },
  blood  = { mat="BLOOD1",  special=0 },
  nukage = { mat="NUKAGE1", light_add=24, special=7,  damage=5 },
  lava   = { mat="LAVA1",   light_add=56, special=5, damage=10 },

  -- Doom II only --
  slime  = { mat="SLIME01", special=0, light_add=8, damage=0 }
}


DOOM.MATERIALS =
{
  ------------------------------------------
  --- Materials common to all DOOM games ---
  ------------------------------------------


  -- special materials --

  _ERROR   = { t="ZZWOLF7",  f="ZZWOLF7" },
  _DEFAULT = { t="GRAY1",  f="FLAT1" },
  _SKY     = { t="METAL",  f="F_SKY1" },


  -- general purpose --

  METAL = { t="METAL", f="CEIL5_2" },

  SUPPORT2 = { t="SUPPORT2", f="FLAT23" },
  SUPPORT3 = { t="SUPPORT3", f="CEIL5_2" },


  -- walls --

  BIGDOOR1 = { t="BIGDOOR1", f="FLAT19" },
  BIGDOOR2 = { t="BIGDOOR2", f="FLAT20" },
  BIGDOOR3 = { t="BIGDOOR3", f="FLOOR7_2" },
  BIGDOOR4 = { t="BIGDOOR4", f="CEIL5_1" },
  BIGDOOR5 = { t="BIGDOOR5", f="CEIL5_2" },
  BIGDOOR6 = { t="BIGDOOR6", f="CEIL5_2" },
  BIGDOOR7 = { t="BIGDOOR7", f="CEIL5_2" },

  BROWN1   = { t="BROWN1",   f="FLOOR0_1" },
  BROWN144 = { t="BROWN144", f="FLOOR7_1" },
  BROWN96  = { t="BROWN96",  f="FLOOR7_1" },
  BROWNGRN = { t="BROWNGRN", f="FLOOR7_1" },
  BROWNHUG = { t="BROWNHUG", f="FLOOR7_1" },
  BROWNPIP = { t="BROWNPIP", f="FLOOR0_1" },
  BROVINE2 = { t="BROVINE2", f="FLOOR7_1" },
  BRNPOIS  = { t="BRNPOIS",  f="FLOOR7_1" },

  COMPBLUE = { t="COMPBLUE", f="FLAT14" },
  COMPSPAN = { t="COMPSPAN", f="CEIL5_1" },
  COMPSTA1 = { t="COMPSTA1", f="FLAT23" },
  COMPSTA2 = { t="COMPSTA2", f="FLAT23" },
  COMPTALL = { t="COMPTALL", f="CEIL5_1" },
  COMPWERD = { t="COMPWERD", f="CEIL5_1" },

  CRATE1   = { t="CRATE1",   f="CRATOP2"  },
  CRATE2   = { t="CRATE2",   f="CRATOP1"  },
  CRATELIT = { t="CRATELIT", f="CRATOP1"  },
  CRATINY  = { t="CRATINY",  f="CRATOP1"  },
  CRATWIDE = { t="CRATWIDE", f="CRATOP1"  },

  -- keep locked doors recognisable
  DOORBLU  = { t="DOORBLU",  f="FLAT23",  sane=1 },
  DOORRED  = { t="DOORRED",  f="FLAT23",  sane=1 },
  DOORYEL  = { t="DOORYEL",  f="FLAT23",  sane=1 },
  DOORBLU2 = { t="DOORBLU2", f="CRATOP2", sane=1 },
  DOORRED2 = { t="DOORRED2", f="CRATOP2", sane=1 },
  DOORYEL2 = { t="DOORYEL2", f="CRATOP2", sane=1 },

  DOOR1    = { t="DOOR1",    f="FLAT23" },
  DOOR3    = { t="DOOR3",    f="FLAT23" },
  DOORSTOP = { t="DOORSTOP", f="FLAT23" },
  DOORTRAK = { t="DOORTRAK", f="FLAT23" },

  EXITDOOR = { t="EXITDOOR", f="FLAT5_5", sane=1 },
  EXITSIGN = { t="EXITSIGN", f="CEIL5_1", sane=1 },
  EXITSTON = { t="EXITSTON", f="MFLR8_1" },

  -- these three are animated
  FIREBLU1 = { t="FIREBLU1", f="FLOOR6_1" },
  FIREBLU2 = { t="FIREBLU2", f="FLOOR6_1" },
  FIRELAVA = { t="FIRELAVA", f="FLOOR6_1" },
  FIREWALL = { t="FIREWALL", f="FLAT5_3" },

  GRAY1    = { t="GRAY1",    f="FLAT18" },
  GRAY2    = { t="GRAY2",    f="FLAT18" },
  GRAY4    = { t="GRAY4",    f="FLAT18" },
  GRAY5    = { t="GRAY5",    f="FLAT18" },
  GRAY7    = { t="GRAY7",    f="FLAT18" },
  GRAYBIG  = { t="GRAYBIG",  f="FLAT18" },
  GRAYPOIS = { t="GRAYPOIS", f="FLAT18" },
  GRAYTALL = { t="GRAYTALL", f="FLAT18" },
  GRAYVINE = { t="GRAYVINE", f="FLAT1" },

  GSTFONT1 = { t="GSTFONT1", f="FLOOR7_2"  },
  GSTGARG  = { t="GSTGARG",  f="FLOOR7_2"  },
  GSTLION  = { t="GSTLION",  f="FLOOR7_2"  },
  GSTONE1  = { t="GSTONE1",  f="FLOOR7_2"  },
  GSTONE2  = { t="GSTONE2",  f="FLOOR7_2"  },
  GSTSATYR = { t="GSTSATYR", f="FLOOR7_2"  },
  GSTVINE2 = { t="GSTVINE2", f="FLOOR7_2"  },

  ICKWALL1 = { t="ICKWALL1", f="FLAT19"  },
  ICKWALL2 = { t="ICKWALL2", f="FLAT19"  },
  ICKWALL3 = { t="ICKWALL3", f="FLAT19"  },
  ICKWALL4 = { t="ICKWALL4", f="FLAT19"  },
  ICKWALL5 = { t="ICKWALL5", f="FLAT19"  },
  ICKWALL7 = { t="ICKWALL7", f="FLAT19"  },

  LITE3    = { t="LITE3",    f="FLAT19" },
  LITE5    = { t="LITE5",    f="FLAT19" },
  LITEBLU1 = { t="LITEBLU1", f="FLAT23" },
  LITEBLU4 = { t="LITEBLU4", f="FLAT1"  },

  MARBLE1  = { t="MARBLE1",  f="FLOOR7_2" },
  MARBLE2  = { t="MARBLE2",  f="FLOOR7_2" },
  MARBLE3  = { t="MARBLE3",  f="FLOOR7_2" },
  MARBFACE = { t="MARBFACE", f="FLOOR7_2" },
  MARBFAC2 = { t="MARBFAC2", f="FLOOR7_2" },
  MARBFAC3 = { t="MARBFAC3", f="FLOOR7_2" },
  MARBLOD1 = { t="MARBLOD1", f="FLOOR7_2" },

  METAL1   = { t="METAL1",   f="FLOOR4_8" },
  NUKE24   = { t="NUKE24",   f="FLOOR7_1" },
  NUKEDGE1 = { t="NUKEDGE1", f="FLOOR7_1" },
  NUKEPOIS = { t="NUKEPOIS", f="FLOOR7_1" },

  PIPE1    = { t="PIPE1",    f="FLOOR4_5" },
  PIPE2    = { t="PIPE2",    f="FLOOR4_5" },
  PIPE4    = { t="PIPE4",    f="FLOOR4_5" },
  PIPE6    = { t="PIPE6",    f="FLOOR4_5" },
  PLAT1    = { t="PLAT1",    f="FLAT4" },
  REDWALL  = { t="REDWALL",  f="FLAT5_3" },
  ROCKRED1 = { t="ROCKRED1", f="FLOOR6_1" },

  SHAWN1   = { t="SHAWN1",   f="FLAT23" },
  SHAWN2   = { t="SHAWN2",   f="FLAT23" },
  SHAWN3   = { t="SHAWN3",   f="FLAT23" },

  SKIN2    = { t="SKIN2",    f="SFLR6_4" },
  SKINCUT  = { t="SKINCUT",  f="CEIL5_2" },
  SKINEDGE = { t="SKINEDGE", f="SFLR6_4" },
  SKINFACE = { t="SKINFACE", f="SFLR6_4" },
  SKINLOW  = { t="SKINLOW",  f="FLAT5_2" },
  SKINMET1 = { t="SKINMET1", f="CEIL5_2" },
  SKINMET2 = { t="SKINMET2", f="CEIL5_2" },
  SKINSCAB = { t="SKINSCAB", f="CEIL5_2" },
  SKINSYMB = { t="SKINSYMB", f="CEIL5_2" },
  SKSNAKE1 = { t="SKSNAKE1", f="SFLR6_1" },
  SKSNAKE2 = { t="SKSNAKE2", f="SFLR6_4" },
  SKSPINE1 = { t="SKSPINE1", f="FLAT5_6" },
  SKSPINE2 = { t="SKSPINE2", f="FLAT5_6" },

  SLADPOIS = { t="SLADPOIS", f="FLOOR7_1" },
  SLADSKUL = { t="SLADSKUL", f="FLOOR7_1" },
  SLADWALL = { t="SLADWALL", f="FLOOR7_1" },

  SP_DUDE1 = { t="SP_DUDE1", f="DEM1_5" },
  SP_DUDE2 = { t="SP_DUDE2", f="DEM1_5" },
  SP_DUDE4 = { t="SP_DUDE4", f="DEM1_5" },
  SP_DUDE5 = { t="SP_DUDE5", f="DEM1_5" },
  SP_FACE1 = { t="SP_FACE1", f="CRATOP2" },
  SP_HOT1  = { t="SP_HOT1",  f="FLAT5_3" },
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" },

  STARBR2  = { t="STARBR2",  f="FLOOR0_2" },
  STARG1   = { t="STARG1",   f="FLAT23" },
  STARG2   = { t="STARG2",   f="FLAT23" },
  STARG3   = { t="STARG3",   f="FLAT23" },
  STARGR1  = { t="STARGR1",  f="FLAT3" },
  STARGR2  = { t="STARGR2",  f="FLAT3" },
  STARTAN2 = { t="STARTAN2", f="FLOOR4_1" },
  STARTAN3 = { t="STARTAN3", f="FLOOR4_5" },

  STONE    = { t="STONE",  f="FLAT5_4" },
  STONE2   = { t="STONE2", f="MFLR8_1" },
  STONE3   = { t="STONE3", f="MFLR8_1" },

  SKY1     = { t="SKY1", f="FLAT1", sane=1 },
  SKY2     = { t="SKY2", f="FLAT1", sane=1 },
  SKY3     = { t="SKY3", f="FLAT1", sane=1 },

  TEKWALL1 = { t="TEKWALL1",  f="CEIL5_1" },
  TEKWALL4 = { t="TEKWALL4",  f="CEIL5_1" },

  WOOD1    = { t="WOOD1",     f="FLAT5_2" },
  WOOD3    = { t="WOOD3",     f="FLAT5_1" },
  WOOD4    = { t="WOOD4",     f="FLAT5_2" },
  WOOD5    = { t="WOOD5",     f="CEIL5_2" },
  WOODGARG = { t="WOODGARG",  f="FLAT5_2" },


  -- steps --

  -- keep these sane because they are short (won't tile vertically)
  STEP1    = { t="STEP1",    f="FLOOR7_1", sane=1 },
  STEP2    = { t="STEP2",    f="FLOOR4_6", sane=1 },
  STEP3    = { t="STEP3",    f="CEIL5_1",  sane=1 },
  STEP4    = { t="STEP4",    f="FLAT19",   sane=1 },
  STEP5    = { t="STEP5",    f="FLOOR7_1", sane=1 },
  STEP6    = { t="STEP6",    f="FLAT5",    sane=1 },
  STEPLAD1 = { t="STEPLAD1", f="FLOOR7_1", sane=1 },
  STEPTOP  = { t="STEPTOP",  f="FLOOR7_1", sane=1 },


  -- switches --

  SW1BLUE  = { t="SW1BLUE",  f="FLAT14" },
  SW1BRCOM = { t="SW1BRCOM", f="FLOOR7_1" },
  SW1BRN2  = { t="SW1BRN2",  f="FLOOR0_1" },
  SW1BRNGN = { t="SW1BRNGN", f="FLOOR7_1" },
  SW1BROWN = { t="SW1BROWN", f="FLOOR7_1" },
  SW1CMT   = { t="SW1CMT",   f="FLAT1" },
  SW1COMM  = { t="SW1COMM",  f="FLAT23" },
  SW1COMP  = { t="SW1COMP",  f="CEIL5_1" },
  SW1DIRT  = { t="SW1DIRT",  f="FLOOR7_1" },
  SW1EXIT  = { t="SW1EXIT",  f="FLAT19" },
  SW1GARG  = { t="SW1GARG",  f="CEIL5_2" },
  SW1GRAY  = { t="SW1GRAY",  f="FLAT19" },
  SW1GRAY1 = { t="SW1GRAY1", f="FLAT19" },

  SW1GSTON = { t="SW1GSTON", f="FLOOR7_2" },
  SW1HOT   = { t="SW1HOT",   f="FLOOR1_7" },
  SW1LION  = { t="SW1LION",  f="CEIL5_2" },
  SW1METAL = { t="SW1METAL", f="FLOOR4_8" },
  SW1PIPE  = { t="SW1PIPE",  f="FLOOR4_5" },
  SW1SATYR = { t="SW1SATYR", f="CEIL5_2" },
  SW1SKIN  = { t="SW1SKIN",  f="CRATOP2" },
  SW1SLAD  = { t="SW1SLAD",  f="FLOOR7_1" },
  SW1STON1 = { t="SW1STON1", f="MFLR8_1" },
  SW1STRTN = { t="SW1STRTN", f="FLOOR4_1" },
  SW1VINE  = { t="SW1VINE",  f="FLAT1" },
  SW1WOOD  = { t="SW1WOOD",  f="FLAT5_2" },


  -- floors --

  CEIL1_1  = { f="CEIL1_1", t="WOOD1" },
  CEIL1_2  = { f="CEIL1_2", t="METAL" },
  CEIL1_3  = { f="CEIL1_3", t="WOOD1" },
  CEIL3_1  = { f="CEIL3_1", t="STARBR2" },
  CEIL3_2  = { f="CEIL3_2", t="STARTAN2" },
  CEIL3_3  = { f="CEIL3_3", t="BROWN1" },
  CEIL3_4  = { f="CEIL3_4", t="STARTAN2" },
  CEIL3_5  = { f="CEIL3_5", t="STONE2" },
  CEIL3_6  = { f="CEIL3_6", t="STONE2" },

  CEIL4_1  = { f="CEIL4_1", t="COMPBLUE" },
  CEIL4_2  = { f="CEIL4_2", t="COMPBLUE" },
  CEIL4_3  = { f="CEIL4_3", t="COMPBLUE" },
  CEIL5_1  = { f="CEIL5_1", t="COMPSPAN" },
  CEIL5_2  = { f="CEIL5_2", t="METAL" },

  COMP01   = { f="COMP01",  t="GRAY1" },

  CRATOP1  = { f="CRATOP1", t="CRATE2" },
  CRATOP2  = { f="CRATOP2", t="CRATE1" },

  DEM1_1   = { f="DEM1_1", t="MARBLE1" },
  DEM1_2   = { f="DEM1_2", t="MARBLE1" },
  DEM1_3   = { f="DEM1_3", t="MARBLE1" },
  DEM1_4   = { f="DEM1_4", t="MARBLE1" },
  DEM1_5   = { f="DEM1_5", t="MARBLE1" },
  DEM1_6   = { f="DEM1_6", t="MARBLE2" },

  FLAT1    = { f="FLAT1",   t="GRAY1" },
  FLAT2    = { f="FLAT2",   t="GRAY1" },
  FLAT3    = { f="FLAT3",   t="GRAY4" },
  FLAT4    = { f="FLAT4",   t="COMPSPAN" },

  FLAT5    = { f="FLAT5",   t="BROWNHUG" },
  FLAT5_1  = { f="FLAT5_1", t="WOOD1" },
  FLAT5_2  = { f="FLAT5_2", t="WOOD12" },
  FLAT5_3  = { f="FLAT5_3", t="REDWALL" },
  FLAT5_4  = { f="FLAT5_4", t="STONE" },
  FLAT5_6  = { f="FLAT5_6", t="CRACKLE4" },

  FLAT8    = { f="FLAT8",  t="BRICK1" },
  FLAT9    = { f="FLAT9",  t="GRAY4" },
  FLAT14   = { f="FLAT14", t="COMPBLUE" },
  FLAT17   = { f="FLAT17", t="GRAY1" },
  FLAT18   = { f="FLAT18", t="SILVER1" },
  FLAT19   = { f="FLAT19", t="GRAY1" },
  FLAT20   = { f="FLAT20", t="SILVER1" },
  FLAT22   = { f="FLAT22", t="SHAWN2" },
  FLAT23   = { f="FLAT23", t="SHAWN2" },

  FLOOR0_1 = { f="FLOOR0_1", t="STARTAN2" },
  FLOOR0_2 = { f="FLOOR0_2", t="STARBR2" },
  FLOOR0_3 = { f="FLOOR0_3", t="GRAY1" },
  FLOOR0_5 = { f="FLOOR0_5", t="GRAY4" },
  FLOOR0_6 = { f="FLOOR0_6", t="GRAY5" },
  FLOOR0_7 = { f="FLOOR0_7", t="GRAY7" },
  FLOOR1_1 = { f="FLOOR1_1", t="COMPBLUE" },
  FLOOR1_6 = { f="FLOOR1_6", t="REDWALL" },
  FLOOR1_7 = { f="FLOOR1_7", t="REDWALL" },
  FLOOR3_3 = { f="FLOOR3_3", t="BROWN1" },

  FLOOR4_1 = { f="FLOOR4_1", t="STARTAN2" },
  FLOOR4_5 = { f="FLOOR4_5", t="BRONZE1" },
  FLOOR4_6 = { f="FLOOR4_6", t="BRONZE3" },
  FLOOR4_8 = { f="FLOOR4_8", t="METAL1" },
  FLOOR5_1 = { f="FLOOR5_1", t="METAL1" },
  FLOOR5_2 = { f="FLOOR5_2", t="BROWNHUG" },
  FLOOR5_3 = { f="FLOOR5_3", t="BROWN1" },
  FLOOR5_4 = { f="FLOOR5_4", t="STARTAN2" },
  FLOOR6_1 = { f="FLOOR6_1", t="REDWALL" },
  FLOOR7_1 = { f="FLOOR7_1", t="BROWNHUG" },
  FLOOR7_2 = { f="FLOOR7_2", t="MARBLE1" },

  GATE1    = { f="GATE1", t="METAL" },
  GATE2    = { f="GATE2", t="METAL" },
  GATE3    = { f="GATE3", t="METAL" },
  GATE4    = { f="GATE4", t="METAL" },

  MFLR8_1  = { f="MFLR8_1", t="STONE2" },
  MFLR8_2  = { f="MFLR8_2", t="BROWNHUG" },
  MFLR8_3  = { f="MFLR8_3", t="SP_ROCK1" },

  SFLR6_1  = { f="SFLR6_1", t="SKSNAKE1" },
  SFLR6_4  = { f="SFLR6_4", t="SKSNAKE2" },
  SFLR7_1  = { f="SFLR7_1", t="SKSNAKE1" },
  SFLR7_4  = { f="SFLR7_4", t="SKSNAKE1" },

  F_STEP1  = { f="STEP1", t="SHAWN2" },
  F_STEP2  = { f="STEP2", t="SHAWN2" },

  TLITE6_1 = { f="TLITE6_1", t="METAL" },
  TLITE6_4 = { f="TLITE6_4", t="METAL" },
  TLITE6_5 = { f="TLITE6_5", t="METAL" },
  TLITE6_6 = { f="TLITE6_6", t="METAL" },


  -- rails --

  BRNSMAL1 = { t="BRNSMAL1", rail_h=64 },
  BRNSMAL2 = { t="BRNSMAL2", rail_h=64 },
  BRNSMALC = { t="BRNSMALC", rail_h=64 },

  MIDBRN1  = { t="MIDBRN1",  rail_h=112 },
  MIDGRATE = { t="MIDGRATE", rail_h=128 },


  -- liquid stuff (using new patches)
  WFALL1   = { t="GSTFONT1", f="FWATER1", sane=1 },
  FWATER1  = { t="GSTFONT1", f="FWATER1", sane=1 },

  LFALL1   = { t="FIREMAG1", f="LAVA1", sane=1 },
  LAVA1    = { t="FIREMAG1", f="LAVA1", sane=1 },


  -- other --

  O_PILL   = { t="CEMENT1",  f="O_PILL",   sane=1 },
  O_BOLT   = { t="CEMENT2",  f="O_BOLT",   sane=1 },
  O_RELIEF = { t="CEMENT3",  f="O_RELIEF", sane=1 },
  O_CARVE  = { t="CEMENT4",  f="O_CARVE",  sane=1 },
  O_NEON   = { t="CEMENT6",  f="O_NEON",  sane=1 },

  O_BLACK  = { t="CEMENT5",  f="O_BLACK",  sane=1 },

  O_INVIST = { t="ZZWOLF10",  f="O_INVIST", sane=1 },

  -- new flat, added by data/lift_flat.wad
  LIFTFLAT = { f="LIFTFLAT", t="SUPPORT2" },


  -- Missing stuff:
  --   CEMENT#  : used by OBLIGE for various logos
  --   ZZZFACE# : not generally useful
  --
  -- Note too that STEP1/2 are ambiguous, the flats are quite
  -- different to the textures, hence renamed the flats as
  -- F_STEP1 and F_STEP2 here.


  -----------------------------------
  --- Materials unique to DOOM II ---
  -----------------------------------

  -- walls --

  ASHWALL2 = { t="ASHWALL2", f="FLOOR6_2" },
  ASHWALL3 = { t="ASHWALL3", f="RROCK03" },
  ASHWALL4 = { t="ASHWALL4", f="FLAT10" },
  ASHWALL6 = { t="ASHWALL6", f="RROCK20" },
  ASHWALL7 = { t="ASHWALL7", f="RROCK18" },
  BIGBRIK1 = { t="BIGBRIK1", f="RROCK14" },
  BIGBRIK2 = { t="BIGBRIK2", f="FLAT5_4" },
  BIGBRIK3 = { t="BIGBRIK3", f="RROCK14" },
  BLAKWAL1 = { t="BLAKWAL1", f="CEIL5_1" },
  BLAKWAL2 = { t="BLAKWAL2", f="CEIL5_1" },

  BRICK1   = { t="BRICK1",   f="RROCK10" },
  BRICK2   = { t="BRICK2",   f="RROCK10" },
  BRICK3   = { t="BRICK3",   f="FLAT5_5" },
  BRICK4   = { t="BRICK4",   f="FLAT5_5" },
  BRICK5   = { t="BRICK5",   f="RROCK10" },
  BRICK6   = { t="BRICK6",   f="FLOOR5_4" },
  BRICK7   = { t="BRICK7",   f="FLOOR5_4" },
  BRICK8   = { t="BRICK8",   f="FLOOR5_4" },
  BRICK9   = { t="BRICK9",   f="FLOOR5_4" },
  BRICK10  = { t="BRICK10",  f="SLIME13" },
  BRICK11  = { t="BRICK11",  f="FLAT5_3" },
  BRICK12  = { t="BRICK12",  f="FLOOR0_1" },
  BRICKLIT = { t="BRICKLIT", f="RROCK10" },

  BRONZE1  = { t="BRONZE1",  f="FLOOR7_1" },
  BRONZE2  = { t="BRONZE2",  f="FLOOR7_1" },
  BRONZE3  = { t="BRONZE3",  f="FLOOR7_1" },
  BRONZE4  = { t="BRONZE4",  f="FLOOR7_1" },
  BRWINDOW = { t="BRWINDOW", f="RROCK10" },
  BSTONE1  = { t="BSTONE1",  f="RROCK11" },
  BSTONE2  = { t="BSTONE2",  f="RROCK12" },
  BSTONE3  = { t="BSTONE3",  f="RROCK12" },

  CEMENT7  = { t="CEMENT7",  f="FLAT19" },
  CEMENT8  = { t="CEMENT8",  f="FLAT19" },
  CEMENT9  = { t="CEMENT9",  f="FLAT19" },
  CRACKLE2 = { t="CRACKLE2", f="RROCK01" },
  CRACKLE4 = { t="CRACKLE4", f="RROCK02" },
  CRATE3   = { t="CRATE3",   f="CRATOP1" },
  MARBFAC4 = { t="MARBFAC4", f="DEM1_5" },
  MARBGRAY = { t="MARBGRAY", f="DEM1_5" },
  GSTVINE1 = { t="GSTVINE1", f="RROCK16" },

  METAL2   = { t="METAL2",   f="CEIL5_2" },
  METAL3   = { t="METAL3",   f="CEIL5_2" },
  METAL4   = { t="METAL4",   f="CEIL5_2" },
  METAL5   = { t="METAL5",   f="CEIL5_2" },
  METAL6   = { t="METAL6",   f="CEIL5_2" },
  METAL7   = { t="METAL7",   f="CEIL5_2" },

  MODWALL1 = { t="MODWALL1", f="MFLR8_4" },
  MODWALL2 = { t="MODWALL2", f="MFLR8_4" },
  MODWALL3 = { t="MODWALL3", f="FLAT19" },
  MODWALL4 = { t="MODWALL4", f="FLAT18" },

  PANBLACK = { t="PANBLACK", f="RROCK09" },
  PANBLUE  = { t="PANBLUE",  f="RROCK09" },
  PANBOOK  = { t="PANBOOK",  f="RROCK09" },
  PANRED   = { t="PANRED",   f="RROCK09" },
  PANBORD1 = { t="PANBORD1", f="RROCK09" },
  PANBORD2 = { t="PANBORD2", f="RROCK09" },
  PANCASE1 = { t="PANCASE1", f="RROCK09" },
  PANCASE2 = { t="PANCASE2", f="RROCK09" },

  PANEL1   = { t="PANEL1",   f="RROCK09" },
  PANEL2   = { t="PANEL2",   f="RROCK09" },
  PANEL3   = { t="PANEL3",   f="RROCK09" },
  PANEL4   = { t="PANEL4",   f="RROCK09" },
  PANEL5   = { t="PANEL5",   f="RROCK09" },
  PANEL6   = { t="PANEL6",   f="RROCK09" },
  PANEL7   = { t="PANEL7",   f="RROCK09" },
  PANEL8   = { t="PANEL8",   f="RROCK09" },
  PANEL9   = { t="PANEL9",   f="RROCK09" },

  PIPES    = { t="PIPES",    f="FLOOR3_3" },
  PIPEWAL1 = { t="PIPEWAL1", f="RROCK03" },
  PIPEWAL2 = { t="PIPEWAL2", f="RROCK03" },
  ROCK1    = { t="ROCK1",    f="RROCK13" },
  ROCK2    = { t="ROCK2",    f="GRNROCK" },
  ROCK3    = { t="ROCK3",    f="RROCK13" },
  ROCK4    = { t="ROCK4",    f="FLOOR0_2" },
  ROCK5    = { t="ROCK5",    f="RROCK09" },

  SILVER1  = { t="SILVER1",  f="FLAT23" },
  SILVER2  = { t="SILVER2",  f="FLAT22" },
  SILVER3  = { t="SILVER3",  f="FLAT23" },
  SK_LEFT  = { t="SK_LEFT",  f="FLAT5_6" },
  SK_RIGHT = { t="SK_RIGHT", f="FLAT5_6" },
  SLOPPY1  = { t="SLOPPY1",  f="FLAT5_6" },
  SLOPPY2  = { t="SLOPPY2",  f="FLAT5_6" },
  SP_DUDE7 = { t="SP_DUDE7", f="FLOOR5_4" },
  SP_FACE2 = { t="SP_FACE2", f="FLAT5_6" },

  SPACEW2  = { t="SPACEW2",  f="CEIL3_3" },
  SPACEW3  = { t="SPACEW3",  f="CEIL5_1" },
  SPACEW4  = { t="SPACEW4",  f="SLIME16" },

  SPCDOOR1 = { t="SPCDOOR1", f="FLOOR0_1" },
  SPCDOOR2 = { t="SPCDOOR2", f="FLAT19" },
  SPCDOOR3 = { t="SPCDOOR3", f="FLAT19" },
  SPCDOOR4 = { t="SPCDOOR4", f="FLOOR0_1" },

  STONE4   = { t="STONE4",   f="FLAT5_4" },
  STONE5   = { t="STONE5",   f="FLAT5_4" },
  STONE6   = { t="STONE6",   f="RROCK11" },
  STONE7   = { t="STONE7",   f="RROCK11" },
  STUCCO   = { t="STUCCO",   f="FLAT5_5" },
  STUCCO1  = { t="STUCCO1",  f="FLAT5_5" },
  STUCCO2  = { t="STUCCO2",  f="FLAT5_5" },
  STUCCO3  = { t="STUCCO3",  f="FLAT5_5" },

  TANROCK2 = { t="TANROCK2", f="FLOOR3_3" },
  TANROCK3 = { t="TANROCK3", f="RROCK11" },
  TANROCK4 = { t="TANROCK4", f="RROCK09" },
  TANROCK5 = { t="TANROCK5", f="RROCK18" },
  TANROCK7 = { t="TANROCK7", f="RROCK15" },
  TANROCK8 = { t="TANROCK8", f="RROCK09" },

  TEKBRON1 = { t="TEKBRON1", f="FLOOR0_1" },
  TEKBRON2 = { t="TEKBRON2", f="FLOOR0_1" },
  TEKGREN1 = { t="TEKGREN1", f="RROCK20" },
  TEKGREN2 = { t="TEKGREN2", f="RROCK20" },
  TEKGREN3 = { t="TEKGREN3", f="RROCK20" },
  TEKGREN4 = { t="TEKGREN4", f="RROCK20" },
  TEKGREN5 = { t="TEKGREN5", f="RROCK20" },
  TEKLITE  = { t="TEKLITE",  f="FLOOR5_2" },
  TEKLITE2 = { t="TEKLITE2", f="FLOOR5_2" },
  TEKWALL6 = { t="TEKWALL6", f="CEIL5_1" },

  WOOD6    = { t="WOOD6",    f="FLAT5_2" },
  WOOD7    = { t="WOOD7",    f="FLAT5_2" },
  WOOD8    = { t="WOOD8",    f="FLAT5_2" },
  WOOD9    = { t="WOOD9",    f="FLAT5_2" },
  WOOD10   = { t="WOOD10",   f="FLAT5_1" },
  WOOD12   = { t="WOOD12",   f="FLAT5_2" },
  WOODVERT = { t="WOODVERT", f="FLAT5_2" },
  WOODMET1 = { t="WOODMET1", f="CEIL5_2" },
  WOODMET2 = { t="WOODMET2", f="CEIL5_2" },
  WOODMET3 = { t="WOODMET3", f="CEIL5_2" },
  WOODMET4 = { t="WOODMET4", f="CEIL5_2" },

  ZIMMER1  = { t="ZIMMER1",  f="RROCK20" },
  ZIMMER2  = { t="ZIMMER2",  f="RROCK20" },
  ZIMMER3  = { t="ZIMMER3",  f="RROCK18" },
  ZIMMER4  = { t="ZIMMER4",  f="RROCK18" },
  ZIMMER5  = { t="ZIMMER5",  f="RROCK16" },
  ZIMMER7  = { t="ZIMMER7",  f="RROCK20" },
  ZIMMER8  = { t="ZIMMER8",  f="MFLR8_3" },

  ZDOORB1  = { t="ZDOORB1",  f="FLAT23" },
  ZDOORF1  = { t="ZDOORF1",  f="FLAT23" },
  ZELDOOR  = { t="ZELDOOR",  f="FLAT23" },

  ZZZFACE4 = { t="ZZZFACE4", f="CEIL5_1" },

  ZZWOLF1  = { t="ZZWOLF1",  f="FLAT18" },
  ZZWOLF2  = { t="ZZWOLF2",  f="FLAT18" },
  ZZWOLF3  = { t="ZZWOLF3",  f="FLAT18" },
  ZZWOLF5  = { t="ZZWOLF5",  f="FLAT5_1" },
  ZZWOLF6  = { t="ZZWOLF6",  f="FLAT5_1" },
  ZZWOLF7  = { t="ZZWOLF7",  f="FLAT5_1" },
  ZZWOLF9  = { t="ZZWOLF9",  f="FLAT14" },
  ZZWOLF10 = { t="ZZWOLF10", f="FLAT23" },
  ZZWOLF11 = { t="ZZWOLF11", f="FLAT5_3" },
  ZZWOLF12 = { t="ZZWOLF12", f="FLAT5_3" },
  ZZWOLF13 = { t="ZZWOLF13", f="FLAT5_3" },


  -- switches --

  SW1BRIK  = { t="SW1BRIK",  f="MFLR8_1" },
  SW1MARB  = { t="SW1MARB",  f="DEM1_5" },
  SW1MET2  = { t="SW1MET2",  f="CEIL5_2" },
  SW1MOD1  = { t="SW1MOD1",  f="MFLR8_4" },
  SW1PANEL = { t="SW1PANEL", f="CEIL1_1" },
  SW1ROCK  = { t="SW1ROCK",  f="RROCK13" },
  SW1SKULL = { t="SW1SKULL", f="FLAT5_6" },
  SW2SKULL = { t="SW2SKULL", f="FLAT5_6" },
  SW1STON6 = { t="SW1STON6", f="RROCK11" },
  SW1TEK   = { t="SW1TEK",   f="RROCK20" },
  SW1WDMET = { t="SW1WDMET", f="CEIL5_2" },
  SW1ZIM   = { t="SW1ZIM",   f="RROCK20" },


  -- floors --

  CONS1_1  = { f="CONS1_1", t="GRAY5" },
  CONS1_5  = { f="CONS1_5", t="GRAY5" },
  CONS1_7  = { f="CONS1_7", t="GRAY5" },

  FLAT10   = { f="FLAT10",   t="ASHWALL4" },
  FLAT1_1  = { f="FLAT1_1",  t="BSTONE2" },
  FLAT1_2  = { f="FLAT1_2",  t="BSTONE2" },
  FLAT1_3  = { f="FLAT1_3",  t="BSTONE2" },
  FLAT5_5  = { f="FLAT5_5",  t="STUCCO" },
  FLAT5_7  = { f="FLAT5_7",  t="ASHWALL2" },
  FLAT5_8  = { f="FLAT5_8",  t="ASHWALL2" },
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL2" },

  GRASS1   = { f="GRASS1",   t="ZIMMER2" },
  GRASS2   = { f="GRASS2",   t="ZIMMER2" },
  GRNROCK  = { f="GRNROCK",  t="ROCK2" },
  GRNLITE1 = { f="GRNLITE1", t="TEKGREN2" },
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL2" },

  RROCK01  = { f="RROCK01", t="ROCKRED1" },
  RROCK02  = { f="RROCK02", t="CRACKLE4" },
  RROCK03  = { f="RROCK03", t="ASHWALL3" },
  RROCK04  = { f="RROCK04", t="ASHWALL3" },
  RROCK05  = { f="RROCK05", t="ROCKRED1" }, -- animated (using 05..08)

  RROCK09  = { f="RROCK09", t="TANROCK4" },
  RROCK10  = { f="RROCK10", t="BRICK1" },
  RROCK11  = { f="RROCK11", t="BSTONE1" },
  RROCK12  = { f="RROCK12", t="BSTONE2" },

  RROCK13  = { f="RROCK13", t="ROCK3" },
  RROCK14  = { f="RROCK14", t="BIGBRIK1" },
  RROCK15  = { f="RROCK15", t="TANROCK7" },
  RROCK16  = { f="RROCK16", t="ZIMMER5" },
  RROCK17  = { f="RROCK17", t="ZIMMER3" },
  RROCK18  = { f="RROCK18", t="ZIMMER3" },
  RROCK19  = { f="RROCK19", t="ZIMMER2" },
  RROCK20  = { f="RROCK20", t="ZIMMER7" },

  SLIME09  = { f="SLIME09", t="ROCKRED1" }, -- animated
  SLIME13  = { f="SLIME13", t="BRICK10" },
  SLIME14  = { f="SLIME14", t="METAL2" },
  SLIME15  = { f="SLIME15", t="METAL2" },
  SLIME16  = { f="SLIME16", t="SPACEW4" },


  -- rails --

  DBRAIN1  = { t="DBRAIN1",  rail_h=32 },

  MIDBARS1 = { t="MIDBARS1", rail_h=128 },
  MIDBARS3 = { t="MIDBARS3", rail_h=72  },
  MIDBRONZ = { t="MIDBRONZ", rail_h=128 },
  MIDSPACE = { t="MIDSPACE", rail_h=128 },

  -- scaled MIDVINE2 from FreeDoom
  MIDVINE2 = { t="SP_DUDE8", rail_h=128 },


  -- liquid stuff (keep them recognisable)
  BFALL1   = { t="BFALL1",  f="BLOOD1", sane=1 },
  BLOOD1   = { t="BFALL1",  f="BLOOD1", sane=1 },

  SFALL1   = { t="SFALL1",  f="NUKAGE1", sane=1 },
  NUKAGE1  = { t="SFALL1",  f="NUKAGE1", sane=1 },

  KFALL1   = { t="BLODRIP1", f="SLIME01", sane=1 },  -- new patches
  KFALL5   = { t="BLODRIP1", f="SLIME05", sane=1 },
  SLIME01  = { t="BLODRIP1", f="SLIME01", sane=1 },
  SLIME05  = { t="BLODRIP1", f="SLIME05", sane=1 },


  -- walls as flats and vice versa --
  XCEIL5_1 = { t="CEIL5_1", f="CEIL5_1" },
  XFLAT14 = { t="FLAT14", f="FLAT14" },
  XFLOOR16 = { t="FLOOR1_6", f="FLOOR1_6" },
  XMETAL3 = { t="METAL3", f="METAL3" },
  XMETAL2 = { t="METAL2", f="METAL3" },
  XSILVER3 = { t="SILVER3", f="SILVER3" },
  XSHAWN2 = { t="SHAWN2", f="SHAWN2" },
  XMETAL3 = { t="METAL3", f="METAL3" },
  XSTEPTOP = { t="STEPTOP", f="STEPTOP" },
  XCRATOP1 = { t="CRATOP1", f="CRATOP1" },
  XDOORTRA = { t="DOORTRAK", f="DOORTRAK" },
  XEMPTY = { t="-", f="-" },
  XTEKGREN = { t="TEKGREN2", f="TEKGREN2" },
  XCEIL3_3 = { t="CEIL3_3", f="CEIL3_3" },
  XMIDVINE  = { t="MIDVINE1", f="MIDVINE1" },
  XFLAT3  = { t="FLAT3", f="FLAT3" },
  XG19  = { t="G19", f="G19" },

  -- Allows compatibility with Egypt theme prefabs (if Prefabs are set to not match Theme)
  MURAL2   = { t="MARBFAC3",   f="FLAT1_1" },
  BIGMURAL = { t="STARTAN3",   f="FLAT1_1" }
}


--------------------------------------------------

DOOM.PREFAB_FIELDS =
{
}


DOOM.SKIN_DEFAULTS =
{
}
