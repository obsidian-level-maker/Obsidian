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
}


DOOM.MATERIALS =
{
  ------------------------------------------
  --- Materials common to all DOOM games ---
  ------------------------------------------


  -- special materials --

  _ERROR   = { t="METAL",  f="FLAT5_1" },
  _DEFAULT = { t="GRAY1",  f="FLAT1" },
  _SKY     = { t="METAL",  f="F_SKY1" },
  F_SKY1     = { t="METAL",  f="F_SKY1" }, -- To make the material checker happy - Dasho

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

  -- these are animated
  FIREBLU1 = { t="FIREBLU1", f="FLOOR6_1" },
  FIREBLU2 = { t="FIREBLU2", f="FLOOR6_1" },
  FIRELAVA = { t="FIRELAVA", f="FLOOR6_1" },
  FIRELAV2 = { t="FIRELAV2", f="FLOOR6_1" },
  FIRELAV3 = { t="FIRELAV3", f="FLOOR6_1" },
  FIREWALL = { t="FIREWALL", f="FLAT5_3" },
  FIREWALA = { t="FIREWALA", f="FLOOR6_1" },
  FIREWALB = { t="FIREWALB", f="FLOOR6_1" },

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
  SW1STARG = { t="SW1STARG",   f="FLAT23" },
  SW1STON1 = { t="SW1STON1", f="MFLR8_1" },
  SW1STON2 = { t="SW1STON2", f="MFLR8_1" },
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
  FLAT5_2  = { f="FLAT5_2", t="WOOD1" },
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
  FLOOR4_5 = { f="FLOOR4_5", t="BROWN1" },
  FLOOR4_6 = { f="FLOOR4_6", t="BROWN96" },
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
  FIREMAG1 = { t="FIREMAG1", f="LAVA1", sane=1 },

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

  -- These materials are unique to DOOM I / Ultimate DOOM...


  -- walls --

  ASHWALL  = { t="ASHWALL",  f="FLOOR6_2" },
  BROVINE  = { t="BROVINE",  f="FLOOR0_1" },
  BRNPOIS2 = { t="BRNPOIS2", f="FLOOR7_1" },
  BROWNWEL = { t="BROWNWEL", f="FLOOR7_1" },

  COMP2    = { t="COMP2",    f="CEIL5_1" },
  COMPOHSO = { t="COMPOHSO", f="FLOOR7_1" },
  COMPTILE = { t="COMPTILE", f="CEIL5_1" },
  COMPUTE1 = { t="COMPUTE1", f="FLAT19" },
  COMPUTE2 = { t="COMPUTE2", f="CEIL5_1" },
  COMPUTE3 = { t="COMPUTE3", f="CEIL5_1" },

  DOORHI   = { t="DOORHI",   f="FLAT19" },
  GRAYDANG = { t="GRAYDANG", f="FLAT19" },
  GSTVINE1 = { t="GSTVINE1", f="FLOOR7_2" },
  ICKDOOR1 = { t="ICKDOOR1", f="FLAT19" },
  ICKWALL6 = { t="ICKWALL6", f="FLAT18" },

  LITE2    = { t="LITE2",    f="FLOOR0_1" },
  LITE4    = { t="LITE4",    f="FLAT19" },
  LITE96   = { t="LITE96",   f="FLOOR7_1" },
  LITEBLU2 = { t="LITEBLU2", f="FLAT23" },
  LITEBLU3 = { t="LITEBLU3", f="FLAT23" },
  LITEMET  = { t="LITEMET",  f="FLOOR4_8" },
  LITERED  = { t="LITERED",  f="FLOOR1_6" },
  LITESTON = { t="LITESTON", f="MFLR8_1" },

  NUKESLAD = { t="NUKESLAD", f="FLOOR7_1" },
  PLANET1  = { t="PLANET1",  f="FLAT23" },
  REDWALL1 = { t="REDWALL1", f="FLOOR1_6" },
  SKINBORD = { t="SKINBORD", f="FLAT5_5" },
  SKINTEK1 = { t="SKINTEK1", f="FLAT5_5" },
  SKINTEK2 = { t="SKINTEK2", f="FLAT5_5" },
  SKULWAL3 = { t="SKULWAL3", f="FLAT5_6" },
  SKULWALL = { t="SKULWALL", f="FLAT5_6" },
  SLADRIP1 = { t="SLADRIP1", f="FLOOR7_1" },

  SP_DUDE6 = { t="SP_DUDE6", f="DEM1_5" },
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" },
  SP_ROCK2 = { t="SP_ROCK2", f="MFLR8_3" },
  STARTAN1 = { t="STARTAN1", f="FLOOR4_1" },
  STONGARG = { t="STONGARG", f="MFLR8_1" },
  STONPOIS = { t="STONPOIS", f="FLAT5_4" },
  TEKWALL2 = { t="TEKWALL2", f="CEIL5_1" },
  TEKWALL3 = { t="TEKWALL3", f="CEIL5_1" },
  TEKWALL5 = { t="TEKWALL5", f="CEIL5_1" },
  WOODSKUL = { t="WOODSKUL", f="FLAT5_2" },


  -- switches --

  SW1BRN1  = { t="SW1BRN1",  f="FLOOR0_1" },
  SW1STARG = { t="SW1STARG", f="FLAT23" },
  SW1STONE = { t="SW1STONE", f="FLAT1" },
  SW1STON2 = { t="SW1STON2", f="MFLR8_1" },


  -- floors --

  FLAT5_6  = { f="FLAT5_6", t="SKULWALL" },
  FLAT5_7  = { f="FLAT5_7", t="ASHWALL" },
  FLAT5_8  = { f="FLAT5_8", t="ASHWALL" },
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL" },
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL" },


  -- flats with different side textures --

  CONS1_1  = { f="CONS1_1", t="COMPWERD" },
  CONS1_5  = { f="CONS1_5", t="COMPWERD" },
  CONS1_7  = { f="CONS1_7", t="COMPWERD" },

  FLAT8    = { f="FLAT8",   t="BROWN1" },
  FLAT10   = { f="FLAT10",  t="BROWNHUG" },
  FLAT1_1  = { f="FLAT1_1", t="BROWN1" },
  FLAT1_2  = { f="FLAT1_2", t="BROWN1" },
  FLAT1_3  = { f="FLAT1_3", t="BROWN1" },
  FLAT5_5  = { f="FLAT5_5", t="BROWN1" },


  -- rails --

  BRNBIGC  = { t="BRNBIGC",  rail_h=128 },

  MIDVINE1 = { t="MIDVINE1", rail_h=128 },
  MIDVINE2 = { t="MIDVINE2", rail_h=128 },

  -- this is the MIDBARS3 texture from FreeDoom
  MIDBARS3 = { t="SP_DUDE3", rail_h=72 },


  -- liquid stuff (using new patches)
  BFALL1   = { t="BLODGR1",  f="BLOOD1", sane=1 },
  BLOOD1   = { t="BLODGR1",  f="BLOOD1", sane=1 },

  SFALL1   = { t="SLADRIP1", f="NUKAGE1", sane=1 },
  NUKAGE1  = { t="SLADRIP1", f="NUKAGE1", sane=1 },

  -- Missing stuff:
  --   CEMENT#  : used by OBLIGE for various logos
  --   ZZZFACE# : not generally useful
  --
  -- Note too that STEP1/2 are ambiguous, the flats are quite
  -- different to the textures, hence renamed the flats as
  -- F_STEP1 and F_STEP2 here.

  -- hex colors used in some Set Line specials - these are NOT actually usable materials
  -- and are just here to suppress warnings regarding them
  ["13131C"] = { t="13131C", f="13131C" },
  ["4548BA"] = { t="4548BA", f="4548BA" },
  ["041C08"] = { t="041C08", f="041C08" },
  ["1F4525"] = { t="1F4525", f="1F4525" },
  ["281F11"] = { t="281F11", f="281F11" },
  ["473618"] = { t="473618", f="473618" },
}


--------------------------------------------------

DOOM.PREFAB_FIELDS =
{
}


DOOM.SKIN_DEFAULTS =
{
}
