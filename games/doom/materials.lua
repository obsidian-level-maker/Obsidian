--------------------------------------------------------------------
--  DOOM MATERIALS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2013 Andrew Apted
--  Copyright (C) 2011,2014 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.PREFAB_DEFAULTS =
{
  -- very common texturing stuff --

   tex_STARTAN3 = "?wall"
  flat_FLOOR5_3 = "?wall"

  tex_BLAKWAL1  = "?outer"

   tex_GRAY5    = "?floor"
  flat_FLOOR0_6 = "?floor"

   tex_STARBR2  = "?ceil"
  flat_CEIL3_1  = "?ceil"

   tex_SFALL3  = "_LIQUID"
  flat_NUKAGE3 = "_LIQUID"

  -- other stuff

  tex_DOORTRAK = "?track"

  thing_5 = "?item"

  -- this allow players to be remapped or removed
  -- (e.g. non-standard players can be removed if not supported)
  thing_1 = "?p1"
  thing_2 = "?p2"
  thing_3 = "?p3"
  thing_4 = "?p4"

  thing_4001 = "?p5"
  thing_4002 = "?p6"
  thing_4003 = "?p7"
  thing_4004 = "?p8"
}


DOOM.SKIN_DEFAULTS =
{
  track = "DOORTRAK"

  big_door = "BIGDOOR7"

  p1 = "player1"
  p2 = "player2"
  p3 = "player3"
  p4 = "player4"

  p5 = "player5"
  p6 = "player6"
  p7 = "player7"
  p8 = "player8"
}


DOOM.LIQUIDS =
{
  water  = { mat="FWATER1", light=156, special=5,  damage=10 }
  blood  = { mat="BLOOD1",  light=172, special=5,  damage=10 }
  nukage = { mat="NUKAGE1", light=172, special=5,  damage=10 }
  lava   = { mat="LAVA1",   light=172, special=16, damage=20 }

  -- Doom II only --
  slime  = { mat="SLIME01", light=156, special=5, damage=10 }
}


DOOM.MATERIALS =
{
  --- These materials are common to all DOOM games...


  -- special materials --

  _ERROR = { t="METAL",    f="CEIL5_2" }
  _SKY   = { t="CEMENT3",  f="F_SKY1" }


  -- general purpose --

  METAL  = { t="METAL",    f="CEIL5_2" }

  SUPPORT2 = { t="SUPPORT2", f="FLAT23" }
  SUPPORT3 = { t="SUPPORT3", f="CEIL5_2" }


  -- walls --

  BIGDOOR1 = { t="BIGDOOR1", f="FLAT23" }
  BIGDOOR2 = { t="BIGDOOR2", f="FLAT1" }
  BIGDOOR3 = { t="BIGDOOR3", f="FLOOR7_2" }
  BIGDOOR4 = { t="BIGDOOR4", f="FLOOR3_3" }
  BIGDOOR5 = { t="BIGDOOR5", f="FLAT5_2" }
  BIGDOOR6 = { t="BIGDOOR6", f="CEIL5_2" }
  BIGDOOR7 = { t="BIGDOOR7", f="CEIL5_2" }

  BROWN1   = { t="BROWN1",   f="FLOOR0_1" }
  BROWN144 = { t="BROWN144", f="FLOOR7_1" }
  BROWN96  = { t="BROWN96",  f="FLOOR7_1" }
  BROWNGRN = { t="BROWNGRN", f="FLOOR7_1" }
  BROWNHUG = { t="BROWNHUG", f="FLOOR7_1" }
  BROWNPIP = { t="BROWNPIP", f="FLOOR0_1" }
  BROVINE2 = { t="BROVINE2", f="FLOOR7_1" }
  BRNPOIS  = { t="BRNPOIS",  f="FLOOR7_1" }

  COMPBLUE = { t="COMPBLUE", f="FLAT14" }
  COMPSPAN = { t="COMPSPAN", f="CEIL5_1" }
  COMPSTA1 = { t="COMPSTA1", f="FLAT23" }
  COMPSTA2 = { t="COMPSTA2", f="FLAT23" }
  COMPTALL = { t="COMPTALL", f="CEIL5_1" }
  COMPWERD = { t="COMPWERD", f="CEIL5_1" }

  CRATE1   = { t="CRATE1",   f="CRATOP2"  }
  CRATE2   = { t="CRATE2",   f="CRATOP1"  }
  CRATELIT = { t="CRATELIT", f="CRATOP1"  }
  CRATINY  = { t="CRATINY",  f="CRATOP1"  }
  CRATWIDE = { t="CRATWIDE", f="CRATOP1"  }

  -- keep locked doors recognisable
  DOORBLU  = { t="DOORBLU",  f="FLAT23",  sane=1 }
  DOORRED  = { t="DOORRED",  f="FLAT23",  sane=1 }
  DOORYEL  = { t="DOORYEL",  f="FLAT23",  sane=1 }
  DOORBLU2 = { t="DOORBLU2", f="CRATOP2", sane=1 }
  DOORRED2 = { t="DOORRED2", f="CRATOP2", sane=1 }
  DOORYEL2 = { t="DOORYEL2", f="CRATOP2", sane=1 }

  DOOR1    = { t="DOOR1",    f="FLAT23" }
  DOOR3    = { t="DOOR3",    f="FLAT23" }
  DOORSTOP = { t="DOORSTOP", f="FLAT23" }
  DOORTRAK = { t="DOORTRAK", f="FLAT23" }

  EXITDOOR = { t="EXITDOOR", f="FLAT5_5", sane=1 }
  EXITSIGN = { t="EXITSIGN", f="CEIL5_1", sane=1 }
  EXITSTON = { t="EXITSTON", f="MFLR8_1" }

  -- these three are animated
  FIREBLU1 = { t="FIREBLU1", f="FLOOR6_1" }
  FIRELAVA = { t="FIRELAVA", f="FLOOR6_1" }
  FIREWALL = { t="FIREWALL", f="FLAT5_3" }

  GRAY1    = { t="GRAY1",    f="FLAT18" }
  GRAY2    = { t="GRAY2",    f="FLAT18" }
  GRAY4    = { t="GRAY4",    f="FLAT18" }
  GRAY5    = { t="GRAY5",    f="FLAT18" }
  GRAY7    = { t="GRAY7",    f="FLAT18" }
  GRAYBIG  = { t="GRAYBIG",  f="FLAT18" }
  GRAYPOIS = { t="GRAYPOIS", f="FLAT18" }
  GRAYTALL = { t="GRAYTALL", f="FLAT18" }
  GRAYVINE = { t="GRAYVINE", f="FLAT1" }

  GSTFONT1 = { t="GSTFONT1", f="FLOOR7_2"  }
  GSTGARG  = { t="GSTGARG",  f="FLOOR7_2"  }
  GSTLION  = { t="GSTLION",  f="FLOOR7_2"  }
  GSTONE1  = { t="GSTONE1",  f="FLOOR7_2"  }
  GSTONE2  = { t="GSTONE2",  f="FLOOR7_2"  }
  GSTSATYR = { t="GSTSATYR", f="FLOOR7_2"  }
  GSTVINE2 = { t="GSTVINE2", f="FLOOR7_2"  }

  ICKWALL1 = { t="ICKWALL1", f="FLAT19"  }
  ICKWALL2 = { t="ICKWALL2", f="FLAT19"  }
  ICKWALL3 = { t="ICKWALL3", f="FLAT19"  }
  ICKWALL4 = { t="ICKWALL4", f="FLAT19"  }
  ICKWALL5 = { t="ICKWALL5", f="FLAT19"  }
  ICKWALL7 = { t="ICKWALL7", f="FLAT19"  }

  LITE3    = { t="LITE3",    f="FLAT19" }
  LITE5    = { t="LITE5",    f="FLAT19" }
  LITEBLU1 = { t="LITEBLU1", f="FLAT23" }
  LITEBLU4 = { t="LITEBLU4", f="FLAT1"  }

  MARBLE1  = { t="MARBLE1",  f="FLOOR7_2" }
  MARBLE2  = { t="MARBLE2",  f="FLOOR7_2" }
  MARBLE3  = { t="MARBLE3",  f="FLOOR7_2" }
  MARBFACE = { t="MARBFACE", f="FLOOR7_2" }
  MARBFAC2 = { t="MARBFAC2", f="FLOOR7_2" }
  MARBFAC3 = { t="MARBFAC3", f="FLOOR7_2" }
  MARBLOD1 = { t="MARBLOD1", f="FLOOR7_2" }

  METAL1   = { t="METAL1",   f="FLOOR4_8" }
  NUKE24   = { t="NUKE24",   f="FLOOR7_1" }
  NUKEDGE1 = { t="NUKEDGE1", f="FLOOR7_1" }
  NUKEPOIS = { t="NUKEPOIS", f="FLOOR7_1" }

  PIPE1    = { t="PIPE1",    f="FLOOR4_5" }
  PIPE2    = { t="PIPE2",    f="FLOOR4_5" }
  PIPE4    = { t="PIPE4",    f="FLOOR4_5" }
  PIPE6    = { t="PIPE6",    f="FLOOR4_5" }
  PLAT1    = { t="PLAT1",    f="FLAT4" }
  REDWALL  = { t="REDWALL",  f="FLAT5_3" }
  ROCKRED1 = { t="ROCKRED1", f="FLOOR6_1" }

  SHAWN1   = { t="SHAWN1",   f="FLAT23" }
  SHAWN2   = { t="SHAWN2",   f="FLAT23" }
  SHAWN3   = { t="SHAWN3",   f="FLAT23" }

  SKIN2    = { t="SKIN2",    f="SFLR6_4" }
  SKINCUT  = { t="SKINCUT",  f="CEIL5_2" }
  SKINEDGE = { t="SKINEDGE", f="SFLR6_4" }
  SKINFACE = { t="SKINFACE", f="SFLR6_4" }
  SKINLOW  = { t="SKINLOW",  f="FLAT5_2" }
  SKINMET1 = { t="SKINMET1", f="CEIL5_2" }
  SKINMET2 = { t="SKINMET2", f="CEIL5_2" }
  SKINSCAB = { t="SKINSCAB", f="CEIL5_2" }
  SKINSYMB = { t="SKINSYMB", f="CEIL5_2" }
  SKSNAKE1 = { t="SKSNAKE1", f="SFLR6_1" }
  SKSNAKE2 = { t="SKSNAKE2", f="SFLR6_4" }
  SKSPINE1 = { t="SKSPINE1", f="FLAT5_6" }
  SKSPINE2 = { t="SKSPINE2", f="FLAT5_6" }

  SLADPOIS = { t="SLADPOIS", f="FLOOR7_1" }
  SLADSKUL = { t="SLADSKUL", f="FLOOR7_1" }
  SLADWALL = { t="SLADWALL", f="FLOOR7_1" }

  SP_DUDE1 = { t="SP_DUDE1", f="DEM1_5" }
  SP_DUDE2 = { t="SP_DUDE2", f="DEM1_5" }
  SP_DUDE4 = { t="SP_DUDE4", f="DEM1_5" }
  SP_DUDE5 = { t="SP_DUDE5", f="DEM1_5" }
  SP_FACE1 = { t="SP_FACE1", f="CRATOP2" }
  SP_HOT1  = { t="SP_HOT1",  f="FLAT5_3" }
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" }

  STARBR2  = { t="STARBR2",  f="FLOOR0_2" }
  STARG1   = { t="STARG1",   f="FLAT23" }
  STARG2   = { t="STARG2",   f="FLAT23" }
  STARG3   = { t="STARG3",   f="FLAT23" }
  STARGR1  = { t="STARGR1",  f="FLAT3" }
  STARGR2  = { t="STARGR2",  f="FLAT3" }
  STARTAN2 = { t="STARTAN2", f="FLOOR4_1" }
  STARTAN3 = { t="STARTAN3", f="FLOOR4_5" }

  STONE    = { t="STONE",  f="FLAT5_4" }
  STONE2   = { t="STONE2", f="MFLR8_1" }
  STONE3   = { t="STONE3", f="MFLR8_1" }

  SKY1     = { t="SKY1", f="FLAT1", sane=1 }
  SKY2     = { t="SKY2", f="FLAT1", sane=1 }
  SKY3     = { t="SKY3", f="FLAT1", sane=1 }

  TEKWALL1 = { t="TEKWALL1",  f="CEIL5_1" }
  TEKWALL4 = { t="TEKWALL4",  f="CEIL5_1" }

  WOOD1    = { t="WOOD1",     f="FLAT5_2" }
  WOOD3    = { t="WOOD3",     f="FLAT5_1" }
  WOOD4    = { t="WOOD4",     f="FLAT5_2" }
  WOOD5    = { t="WOOD5",     f="CEIL5_2" }
  WOODGARG = { t="WOODGARG",  f="FLAT5_2" }


  -- steps --

  -- keep these sane because they are short (won't tile vertically)
  STEP1    = { t="STEP1",    f="FLOOR7_1", sane=1 }
  STEP2    = { t="STEP2",    f="FLOOR4_6", sane=1 }
  STEP3    = { t="STEP3",    f="CEIL5_1",  sane=1 }
  STEP4    = { t="STEP4",    f="FLAT19",   sane=1 }
  STEP5    = { t="STEP5",    f="FLOOR7_1", sane=1 }
  STEP6    = { t="STEP6",    f="FLAT5",    sane=1 }
  STEPLAD1 = { t="STEPLAD1", f="FLOOR7_1", sane=1 }
  STEPTOP  = { t="STEPTOP",  f="FLOOR7_1", sane=1 }


  -- switches --

  SW1BLUE  = { t="SW1BLUE",  f="FLAT14" }
  SW1BRCOM = { t="SW1BRCOM", f="FLOOR7_1" }
  SW1BRN2  = { t="SW1BRN2",  f="FLOOR0_1" }
  SW1BRNGN = { t="SW1BRNGN", f="FLOOR7_1" }
  SW1BROWN = { t="SW1BROWN", f="FLOOR7_1" }
  SW1COMM  = { t="SW1COMM",  f="FLAT23" }
  SW1COMP  = { t="SW1COMP",  f="CEIL5_1" }
  SW1DIRT  = { t="SW1DIRT",  f="FLOOR7_1" }
  SW1EXIT  = { t="SW1EXIT",  f="FLAT19" }
  SW1GARG  = { t="SW1GARG",  f="CEIL5_2" }
  SW1GRAY  = { t="SW1GRAY",  f="FLAT19" }
  SW1GRAY1 = { t="SW1GRAY1", f="FLAT19" }

  SW1GSTON = { t="SW1GSTON", f="FLOOR7_2" }
  SW1HOT   = { t="SW1HOT",   f="FLOOR1_7" }
  SW1LION  = { t="SW1LION",  f="CEIL5_2" }
  SW1METAL = { t="SW1METAL", f="FLOOR4_8" }
  SW1PIPE  = { t="SW1PIPE",  f="FLOOR4_5" }
  SW1SATYR = { t="SW1SATYR", f="CEIL5_2" }
  SW1SKIN  = { t="SW1SKIN",  f="CRATOP2" }
  SW1SLAD  = { t="SW1SLAD",  f="FLOOR7_1" }
  SW1STON1 = { t="SW1STON1", f="MFLR8_1" }
  SW1STRTN = { t="SW1STRTN", f="FLOOR4_1" }
  SW1VINE  = { t="SW1VINE",  f="FLAT1" }
  SW1WOOD  = { t="SW1WOOD",  f="FLAT5_2" }
  

  -- floors --

  CEIL1_1  = { f="CEIL1_1", t="WOOD1" }
  CEIL1_2  = { f="CEIL1_2", t="METAL" }
  CEIL1_3  = { f="CEIL1_3", t="WOOD1" }
  CEIL3_1  = { f="CEIL3_1", t="STARBR2" }
  CEIL3_2  = { f="CEIL3_2", t="STARTAN2" }
  CEIL3_3  = { f="CEIL3_3", t="STARTAN2" }
  CEIL3_4  = { f="CEIL3_4", t="STARTAN2" }
  CEIL3_5  = { f="CEIL3_5", t="STONE2" }
  CEIL3_6  = { f="CEIL3_6", t="STONE2" }

  CEIL4_1  = { f="CEIL4_1", t="COMPBLUE" }
  CEIL4_2  = { f="CEIL4_2", t="COMPBLUE" }
  CEIL4_3  = { f="CEIL4_3", t="COMPBLUE" }
  CEIL5_1  = { f="CEIL5_1", t="COMPSPAN" }
  CEIL5_2  = { f="CEIL5_2", t="METAL" }

  COMP01   = { f="COMP01",  t="GRAY1" }
  CONS1_1  = { f="CONS1_1", t="COMPWERD" }
  CONS1_5  = { f="CONS1_5", t="COMPWERD" }
  CONS1_7  = { f="CONS1_7", t="COMPWERD" }

  DEM1_1   = { f="DEM1_1", t="MARBLE1" }
  DEM1_2   = { f="DEM1_2", t="MARBLE1" }
  DEM1_3   = { f="DEM1_3", t="MARBLE1" }
  DEM1_4   = { f="DEM1_4", t="MARBLE1" }
  DEM1_5   = { f="DEM1_5", t="MARBLE1" }
  DEM1_6   = { f="DEM1_6", t="MARBLE1" }

  FLAT1    = { f="FLAT1",   t="GRAY1" }
  FLAT1_1  = { f="FLAT1_1", t="BROWN1" }
  FLAT1_2  = { f="FLAT1_2", t="BROWN1" }
  FLAT1_3  = { f="FLAT1_3", t="BROWN1" }
  FLAT2    = { f="FLAT2",   t="GRAY1" }
  FLAT3    = { f="FLAT3",   t="GRAY4" }
  FLAT4    = { f="FLAT4",   t="COMPSPAN" }

  FLAT5    = { f="FLAT5",   t="BROWNHUG" }
  FLAT5_1  = { f="FLAT5_1", t="WOOD1" }
  FLAT5_2  = { f="FLAT5_2", t="WOOD1" }
  FLAT5_3  = { f="FLAT5_3", t="REDWALL" }
  FLAT5_4  = { f="FLAT5_4", t="STONE" }
  FLAT5_5  = { f="FLAT5_5", t="BROWN1" }
  FLAT5_6  = { f="FLAT5_6", t="CRACKLE4" }

  FLAT8    = { f="FLAT8",  t="STARBR2" }
  FLAT9    = { f="FLAT9",  t="GRAY4" }
  FLAT10   = { f="FLAT10", t="BROWNHUG" } -- better in DOOM2
  FLAT14   = { f="FLAT14", t="COMPBLUE" }
  FLAT17   = { f="FLAT17", t="GRAY1" }
  FLAT18   = { f="FLAT18", t="GRAY1" }
  FLAT19   = { f="FLAT19", t="GRAY1" }
  FLAT20   = { f="FLAT20", t="SHAWN2" }
  FLAT22   = { f="FLAT22", t="SHAWN2" }
  FLAT23   = { f="FLAT23", t="SHAWN2" }

  FLOOR0_1 = { f="FLOOR0_1", t="STARTAN2" }
  FLOOR0_2 = { f="FLOOR0_2", t="STARBR2" }
  FLOOR0_3 = { f="FLOOR0_3", t="GRAY1" }
  FLOOR0_5 = { f="FLOOR0_5", t="GRAY1" }
  FLOOR0_6 = { f="FLOOR0_6", t="GRAY1" }
  FLOOR0_7 = { f="FLOOR0_7", t="GRAY1" }
  FLOOR1_1 = { f="FLOOR1_1", t="COMPBLUE" }
  FLOOR1_6 = { f="FLOOR1_6", t="REDWALL" }
  FLOOR1_7 = { f="FLOOR1_7", t="REDWALL" }
  FLOOR3_3 = { f="FLOOR3_3", t="BROWN1" }

  FLOOR4_1 = { f="FLOOR4_1", t="STARTAN2" }
  FLOOR4_5 = { f="FLOOR4_5", t="STARTAN2" }
  FLOOR4_6 = { f="FLOOR4_6", t="STARTAN2" }
  FLOOR4_8 = { f="FLOOR4_8", t="METAL1" }
  FLOOR5_1 = { f="FLOOR5_1", t="METAL1" }
  FLOOR5_2 = { f="FLOOR5_2", t="BROWNHUG" }
  FLOOR5_3 = { f="FLOOR5_3", t="BROWNHUG" }
  FLOOR5_4 = { f="FLOOR5_4", t="BROWNHUG" }
  FLOOR6_1 = { f="FLOOR6_1", t="REDWALL" }
  FLOOR7_1 = { f="FLOOR7_1", t="BROWNHUG" }
  FLOOR7_2 = { f="FLOOR7_2", t="MARBLE1" }

  GATE1    = { f="GATE1", t="METAL" }
  GATE2    = { f="GATE2", t="METAL" }
  GATE3    = { f="GATE3", t="METAL" }
  GATE4    = { f="GATE4", t="METAL" }
  
  MFLR8_1  = { f="MFLR8_1", t="STONE2" }
  MFLR8_2  = { f="MFLR8_2", t="BROWNHUG" }
  MFLR8_3  = { f="MFLR8_3", t="SP_ROCK1" }

  SFLR6_1  = { f="SFLR6_1", t="SKSNAKE1" }
  SFLR6_4  = { f="SFLR6_4", t="SKSNAKE2" }
  SFLR7_1  = { f="SFLR7_1", t="SKSNAKE1" }
  SFLR7_4  = { f="SFLR7_4", t="SKSNAKE1" }
  
  F_STEP1  = { f="STEP1", t="SHAWN2" }
  F_STEP2  = { f="STEP2", t="SHAWN2" }

  TLITE6_1 = { f="TLITE6_1", t="METAL" }
  TLITE6_4 = { f="TLITE6_4", t="METAL" }
  TLITE6_5 = { f="TLITE6_5", t="METAL" }
  TLITE6_6 = { f="TLITE6_6", t="METAL" }


  -- rails --

  BRNSMAL1 = { t="BRNSMAL1", rail_h=64 }
  BRNSMAL2 = { t="BRNSMAL2", rail_h=64 }
  BRNSMALC = { t="BRNSMALC", rail_h=64 }

  MIDBRN1  = { t="MIDBRN1",  rail_h=128 }
  MIDGRATE = { t="MIDGRATE", rail_h=128 }


  -- liquid stuff (using new patches)
  WFALL1   = { t="GSTFONT1", f="FWATER1", sane=1 }
  FWATER1  = { t="GSTFONT1", f="FWATER1", sane=1 }

  LFALL1   = { t="FIREMAG1", f="LAVA1", sane=1 }
  LAVA1    = { t="FIREMAG1", f="LAVA1", sane=1 }


  -- other --

  O_PILL   = { t="CEMENT1",  f="O_PILL",   sane=1 }
  O_BOLT   = { t="CEMENT2",  f="O_BOLT",   sane=1 }
  O_RELIEF = { t="CEMENT3",  f="O_RELIEF", sane=1 }
  O_CARVE  = { t="CEMENT4",  f="O_CARVE",  sane=1 }
  O_NEON   = { t="CEMENT6",  f="CEIL5_1",  sane=1 }

  O_BLACK  = { t="CEMENT5",  f="O_BLACK",  sane=1 }

  O_PARROT = { t="ZZWOLF4",  f="CEIL5_2" }


  -- Missing stuff:
  --   CEMENT#  : used by OBLIGE for various logos
  --   ZZZFACE# : not generally useful
  --
  -- Note too that STEP1/2 are ambiguous, the flats are quite
  -- different to the textures, hence renamed the flats as
  -- F_STEP1 and F_STEP2.

}


--------------------------------------------------------------------
--  Ultimate DOOM
--------------------------------------------------------------------

DOOM1.MATERIALS =
{
  -- These materials are unique to DOOM I / Ultimate DOOM...


  -- walls --

  ASHWALL  = { t="ASHWALL",  f="FLOOR6_2" }
  BROVINE  = { t="BROVINE",  f="FLOOR0_1" }
  BRNPOIS2 = { t="BRNPOIS2", f="FLOOR7_1" }
  BROWNWEL = { t="BROWNWEL", f="FLOOR7_1" }

  COMP2    = { t="COMP2",    f="CEIL5_1" }
  COMPOHSO = { t="COMPOHSO", f="FLOOR7_1" }
  COMPTILE = { t="COMPTILE", f="CEIL5_1" }
  COMPUTE1 = { t="COMPUTE1", f="FLAT19" }
  COMPUTE2 = { t="COMPUTE2", f="CEIL5_1" }
  COMPUTE3 = { t="COMPUTE3", f="CEIL5_1" }

  DOORHI   = { t="DOORHI",   f="FLAT19" }
  GRAYDANG = { t="GRAYDANG", f="FLAT19" }
  GSTVINE1 = { t="GSTVINE1", f="FLOOR7_2" }
  ICKDOOR1 = { t="ICKDOOR1", f="FLAT19" }
  ICKWALL6 = { t="ICKWALL6", f="FLAT18" }

  LITE2    = { t="LITE2",    f="FLOOR0_1" }
  LITE4    = { t="LITE4",    f="FLAT19" }
  LITE96   = { t="LITE96",   f="FLOOR7_1" }
  LITEBLU2 = { t="LITEBLU2", f="FLAT23" }
  LITEBLU3 = { t="LITEBLU3", f="FLAT23" }
  LITEMET  = { t="LITEMET",  f="FLOOR4_8" }
  LITERED  = { t="LITERED",  f="FLOOR1_6" }
  LITESTON = { t="LITESTON", f="MFLR8_1" }

  NUKESLAD = { t="NUKESLAD", f="FLOOR7_1" }
  PLANET1  = { t="PLANET1",  f="FLAT23" }
  REDWALL1 = { t="REDWALL1", f="FLOOR1_6" }
  SKINBORD = { t="SKINBORD", f="FLAT5_5" }
  SKINTEK1 = { t="SKINTEK1", f="FLAT5_5" }
  SKINTEK2 = { t="SKINTEK2", f="FLAT5_5" }
  SKULWAL3 = { t="SKULWAL3", f="FLAT5_6" }
  SKULWALL = { t="SKULWALL", f="FLAT5_6" }
  SLADRIP1 = { t="SLADRIP1", f="FLOOR7_1" }

  SP_DUDE6 = { t="SP_DUDE6", f="DEM1_5" }
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" }
  STARTAN1 = { t="STARTAN1", f="FLOOR4_1" }
  STONGARG = { t="STONGARG", f="MFLR8_1" }
  STONPOIS = { t="STONPOIS", f="FLAT5_4" }
  TEKWALL2 = { t="TEKWALL2", f="CEIL5_1" }
  TEKWALL3 = { t="TEKWALL3", f="CEIL5_1" }
  TEKWALL5 = { t="TEKWALL5", f="CEIL5_1" }
  WOODSKUL = { t="WOODSKUL", f="FLAT5_2" }


  -- switches --

  SW1BRN1  = { t="SW1BRN1",  f="FLOOR0_1" }
  SW1STARG = { t="SW1STARG", f="FLAT23" }
  SW1STONE = { t="SW1STONE", f="FLAT1" }
  SW1STON2 = { t="SW1STON2", f="MFLR8_1" }


  -- floors --

  FLAT5_6  = { f="FLAT5_6", t="SKULWALL" }
  FLAT5_7  = { f="FLAT5_7", t="ASHWALL" }
  FLAT5_8  = { f="FLAT5_8", t="ASHWALL" }
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL" }
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL" }


  -- rails --

  BRNBIGC  = { t="BRNBIGC",  rail_h=128 }

  MIDVINE1 = { t="MIDVINE1", rail_h=128 }
  MIDVINE2 = { t="MIDVINE2", rail_h=128 }

  -- this is the MIDBARS3 texture from FreeDoom
  MIDBARS3 = { t="SP_DUDE3", rail_h=72 }


  -- liquid stuff (using new patches)
  BFALL1   = { t="BLODGR1",  f="BLOOD1", sane=1 }
  BLOOD1   = { t="BLODGR1",  f="BLOOD1", sane=1 }

  SFALL1   = { t="SLADRIP1", f="NUKAGE1", sane=1 }
  NUKAGE1  = { t="SLADRIP1", f="NUKAGE1", sane=1 }


  -- compatibility stuff

  ASHWALL2 = { t="ASHWALL",  f="FLOOR6_2" }
  BRICKLIT = { t="LITEMET",  f="CEIL5_1" }
  PIPEWAL1 = { t="COMPWERD", f="CEIL5_1" }
  SPACEW3  = { t="COMPUTE1", f="FLAT1" }
  SILVER3  = { t="PLANET1",  f="FLAT23" }
  WOOD9    = { t="WOOD1",    f="FLAT5_2" }
  WOOD10   = { t="WOOD1",    f="FLAT5_2" }
}

 
--------------------------------------------------------------------
--  DOOM II : Hell on Earth
--------------------------------------------------------------------

DOOM2.MATERIALS =
{
  -- These materials are unique to DOOM II...


  -- walls --

  ASHWALL2 = { t="ASHWALL2", f="MFLR8_4" }
  ASHWALL3 = { t="ASHWALL3", f="FLAT10" }
  ASHWALL4 = { t="ASHWALL4", f="FLAT10" }
  ASHWALL6 = { t="ASHWALL6", f="RROCK20" }
  ASHWALL7 = { t="ASHWALL7", f="RROCK18" }
  BIGBRIK1 = { t="BIGBRIK1", f="RROCK14" }
  BIGBRIK2 = { t="BIGBRIK2", f="MFLR8_1" }
  BIGBRIK3 = { t="BIGBRIK3", f="RROCK14" }
  BLAKWAL1 = { t="BLAKWAL1", f="CEIL5_1" }
  BLAKWAL2 = { t="BLAKWAL2", f="CEIL5_1" }

  BRICK1   = { t="BRICK1",   f="RROCK10" }
  BRICK2   = { t="BRICK2",   f="RROCK10" }
  BRICK3   = { t="BRICK3",   f="FLAT5_5" }
  BRICK4   = { t="BRICK4",   f="FLAT5_5" }
  BRICK5   = { t="BRICK5",   f="RROCK10" }
  BRICK6   = { t="BRICK6",   f="FLOOR5_4" }
  BRICK7   = { t="BRICK7",   f="FLOOR5_4" }
  BRICK8   = { t="BRICK8",   f="FLOOR5_4" }
  BRICK9   = { t="BRICK9",   f="FLOOR5_4" }
  BRICK10  = { t="BRICK10",  f="SLIME13" }
  BRICK11  = { t="BRICK11",  f="FLAT5_3" }
  BRICK12  = { t="BRICK12",  f="FLOOR0_1" }
  BRICKLIT = { t="BRICKLIT", f="RROCK10" }

  BRONZE1  = { t="BRONZE1",  f="FLOOR7_1" }
  BRONZE2  = { t="BRONZE2",  f="FLOOR7_1" }
  BRONZE3  = { t="BRONZE3",  f="FLOOR7_1" }
  BRONZE4  = { t="BRONZE4",  f="FLOOR7_1" }
  BRWINDOW = { t="BRWINDOW", f="RROCK10" }
  BSTONE1  = { t="BSTONE1",  f="RROCK11" }
  BSTONE2  = { t="BSTONE2",  f="RROCK12" }
  BSTONE3  = { t="BSTONE3",  f="RROCK12" }

  CEMENT7  = { t="CEMENT7",  f="FLAT19" }
  CEMENT9  = { t="CEMENT9",  f="FLAT19" }
  CRACKLE2 = { t="CRACKLE2", f="RROCK01" }
  CRACKLE4 = { t="CRACKLE4", f="RROCK02" }
  CRATE3   = { t="CRATE3",   f="CRATOP1" }
  MARBFAC4 = { t="MARBFAC4", f="DEM1_5" }
  MARBGRAY = { t="MARBGRAY", f="DEM1_5" }
  GSTVINE1 = { t="GSTVINE1", f="RROCK16" }

  METAL2   = { t="METAL2",   f="CEIL5_2" }
  METAL3   = { t="METAL3",   f="CEIL5_2" }
  METAL4   = { t="METAL4",   f="CEIL5_2" }
  METAL5   = { t="METAL5",   f="CEIL5_2" }
  METAL6   = { t="METAL6",   f="CEIL5_2" }
  METAL7   = { t="METAL7",   f="CEIL5_2" }

  MODWALL1 = { t="MODWALL1", f="MFLR8_4" }
  MODWALL2 = { t="MODWALL2", f="MFLR8_4" }
  MODWALL3 = { t="MODWALL3", f="FLAT19" }
  MODWALL4 = { t="MODWALL4", f="FLAT18" }

  PANBLACK = { t="PANBLACK", f="RROCK09" }
  PANBLUE  = { t="PANBLUE",  f="RROCK09" }
  PANBOOK  = { t="PANBOOK",  f="RROCK09" }
  PANRED   = { t="PANRED",   f="RROCK09" }
  PANBORD1 = { t="PANBORD1", f="RROCK09" }
  PANBORD2 = { t="PANBORD2", f="RROCK09" }
  PANCASE1 = { t="PANCASE1", f="RROCK09" }
  PANCASE2 = { t="PANCASE2", f="RROCK09" }

  PANEL1   = { t="PANEL1",   f="RROCK09" }
  PANEL2   = { t="PANEL2",   f="RROCK09" }
  PANEL3   = { t="PANEL3",   f="RROCK09" }
  PANEL4   = { t="PANEL4",   f="RROCK09" }
  PANEL5   = { t="PANEL5",   f="RROCK09" }
  PANEL6   = { t="PANEL6",   f="RROCK09" }
  PANEL7   = { t="PANEL7",   f="RROCK09" }
  PANEL8   = { t="PANEL8",   f="RROCK09" }
  PANEL9   = { t="PANEL9",   f="RROCK09" }

  PIPES    = { t="PIPES",    f="FLOOR3_3" }
  PIPEWAL1 = { t="PIPEWAL1", f="RROCK03" }
  PIPEWAL2 = { t="PIPEWAL2", f="RROCK03" }
  ROCK1    = { t="ROCK1",    f="RROCK13" }
  ROCK2    = { t="ROCK2",    f="GRNROCK" }
  ROCK3    = { t="ROCK3",    f="RROCK13" }
  ROCK4    = { t="ROCK4",    f="FLOOR0_2" }
  ROCK5    = { t="ROCK5",    f="RROCK09" }

  SILVER1  = { t="SILVER1",  f="FLAT23" }
  SILVER2  = { t="SILVER2",  f="FLAT22" }
  SILVER3  = { t="SILVER3",  f="FLAT23" }
  SK_LEFT  = { t="SK_LEFT",  f="FLAT5_6" }
  SK_RIGHT = { t="SK_RIGHT", f="FLAT5_6" }
  SLOPPY1  = { t="SLOPPY1",  f="FLAT5_6" }
  SLOPPY2  = { t="SLOPPY2",  f="FLAT5_6" }
  SP_DUDE7 = { t="SP_DUDE7", f="FLOOR5_4" }
  SP_FACE2 = { t="SP_FACE2", f="FLAT5_6" }

  SPACEW2  = { t="SPACEW2",  f="CEIL3_3" }
  SPACEW3  = { t="SPACEW3",  f="CEIL5_1" }
  SPACEW4  = { t="SPACEW4",  f="SLIME16" }

  SPCDOOR1 = { t="SPCDOOR1", f="FLOOR0_1" }
  SPCDOOR2 = { t="SPCDOOR2", f="FLAT19" }
  SPCDOOR3 = { t="SPCDOOR3", f="FLAT19" }
  SPCDOOR4 = { t="SPCDOOR4", f="FLOOR0_1" }

  STONE4   = { t="STONE4",   f="FLAT5_4" }
  STONE5   = { t="STONE5",   f="FLAT5_4" }
  STONE6   = { t="STONE6",   f="RROCK11" }
  STONE7   = { t="STONE7",   f="RROCK11" }
  STUCCO   = { t="STUCCO",   f="FLAT5_5" }
  STUCCO1  = { t="STUCCO1",  f="FLAT5_5" }
  STUCCO2  = { t="STUCCO2",  f="FLAT5_5" }
  STUCCO3  = { t="STUCCO3",  f="FLAT5_5" }

  TANROCK2 = { t="TANROCK2", f="FLOOR3_3" }
  TANROCK3 = { t="TANROCK3", f="RROCK11" }
  TANROCK4 = { t="TANROCK4", f="RROCK09" }
  TANROCK5 = { t="TANROCK5", f="RROCK18" }
  TANROCK7 = { t="TANROCK7", f="RROCK15" }
  TANROCK8 = { t="TANROCK8", f="RROCK09" }

  TEKBRON1 = { t="TEKBRON1", f="FLOOR0_1" }
  TEKBRON2 = { t="TEKBRON2", f="FLOOR0_1" }
  TEKGREN1 = { t="TEKGREN1", f="RROCK20" }
  TEKGREN2 = { t="TEKGREN2", f="RROCK20" }
  TEKGREN3 = { t="TEKGREN3", f="RROCK20" }
  TEKGREN4 = { t="TEKGREN4", f="RROCK20" }
  TEKGREN5 = { t="TEKGREN5", f="RROCK20" }
  TEKLITE  = { t="TEKLITE",  f="FLOOR5_2" }
  TEKLITE2 = { t="TEKLITE2", f="FLOOR5_2" }
  TEKWALL6 = { t="TEKWALL6", f="CEIL5_1" }

  WOOD6    = { t="WOOD6",    f="FLAT5_2" }
  WOOD7    = { t="WOOD7",    f="FLAT5_2" }
  WOOD8    = { t="WOOD8",    f="FLAT5_2" }
  WOOD9    = { t="WOOD9",    f="FLAT5_2" }
  WOOD10   = { t="WOOD10",   f="FLAT5_1" }
  WOOD12   = { t="WOOD12",   f="FLAT5_2" }
  WOODVERT = { t="WOODVERT", f="FLAT5_2" }
  WOODMET1 = { t="WOODMET1", f="CEIL5_2" }
  WOODMET2 = { t="WOODMET2", f="CEIL5_2" }
  WOODMET3 = { t="WOODMET3", f="CEIL5_2" }
  WOODMET4 = { t="WOODMET4", f="CEIL5_2" }

  ZIMMER1  = { t="ZIMMER1",  f="RROCK20" }
  ZIMMER2  = { t="ZIMMER2",  f="RROCK20" }
  ZIMMER3  = { t="ZIMMER3",  f="RROCK18" }
  ZIMMER4  = { t="ZIMMER4",  f="RROCK18" }
  ZIMMER5  = { t="ZIMMER5",  f="RROCK16" }
  ZIMMER7  = { t="ZIMMER7",  f="RROCK20" }
  ZIMMER8  = { t="ZIMMER8",  f="MFLR8_3" }
                          
  ZDOORB1  = { t="ZDOORB1",  f="FLAT23" }
  ZDOORF1  = { t="ZDOORF1",  f="FLAT23" }
  ZELDOOR  = { t="ZELDOOR",  f="FLAT23" }

  ZZWOLF1  = { t="ZZWOLF1",  f="FLAT18" }
  ZZWOLF2  = { t="ZZWOLF2",  f="FLAT18" }
  ZZWOLF3  = { t="ZZWOLF3",  f="FLAT18" }
  ZZWOLF5  = { t="ZZWOLF5",  f="FLAT5_1" }
  ZZWOLF6  = { t="ZZWOLF6",  f="FLAT5_1" }
  ZZWOLF7  = { t="ZZWOLF7",  f="FLAT5_1" }
  ZZWOLF9  = { t="ZZWOLF9",  f="FLAT14" }
  ZZWOLF10 = { t="ZZWOLF10", f="FLAT23" }
  ZZWOLF11 = { t="ZZWOLF11", f="FLAT5_3" }
  ZZWOLF12 = { t="ZZWOLF12", f="FLAT5_3" }
  ZZWOLF13 = { t="ZZWOLF13", f="FLAT5_3" }


  -- switches --

  SW1BRIK  = { t="SW1BRIK",  f="MFLR8_1" }
  SW1MARB  = { t="SW1MARB",  f="DEM1_5" }
  SW1MET2  = { t="SW1MET2",  f="CEIL5_2" }
  SW1MOD1  = { t="SW1MOD1",  f="MFLR8_4" }
  SW1PANEL = { t="SW1PANEL", f="CEIL1_1" }
  SW1ROCK  = { t="SW1ROCK",  f="RROCK13" }
  SW1SKULL = { t="SW1SKULL", f="FLAT5_6" }
  SW1STON6 = { t="SW1STON6", f="RROCK11" }
  SW1TEK   = { t="SW1TEK",   f="RROCK20" }
  SW1WDMET = { t="SW1WDMET", f="CEIL5_2" }
  SW1ZIM   = { t="SW1ZIM",   f="RROCK20" }


  -- floors --

  CONS1_1  = { f="CONS1_1", t="GRAY5" }
  CONS1_5  = { f="CONS1_5", t="GRAY5" }
  CONS1_7  = { f="CONS1_7", t="GRAY5" }

  FLAT1_1  = { f="FLAT1_1",  t="BSTONE2" }
  FLAT1_2  = { f="FLAT1_2",  t="BSTONE2" }
  FLAT1_3  = { f="FLAT1_3",  t="BSTONE2" }
  FLAT10   = { f="FLAT10",   t="ASHWALL4" }
  FLAT22   = { f="FLAT22",   t="SILVER2" }
  FLAT5_5  = { f="FLAT5_5",  t="STUCCO" }
  FLAT5_7  = { f="FLAT5_7",  t="ASHWALL2" }
  FLAT5_8  = { f="FLAT5_8",  t="ASHWALL2" }
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL2" }

  GRASS1   = { f="GRASS1",   t="ZIMMER2" }
  GRASS2   = { f="GRASS2",   t="ZIMMER2" }
  GRNROCK  = { f="GRNROCK",  t="ROCK2" }
  GRNLITE1 = { f="GRNLITE1", t="TEKGREN2" }
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL2" }

  RROCK01  = { f="RROCK01", t="CRACKLE2" }
  RROCK02  = { f="RROCK02", t="CRACKLE4" }
  RROCK03  = { f="RROCK03", t="ASHWALL3" }
  RROCK04  = { f="RROCK04", t="ASHWALL3" }
  RROCK05  = { f="RROCK05", t="ROCKRED1" }  -- animated
  RROCK09  = { f="RROCK09", t="TANROCK4" }
  RROCK10  = { f="RROCK10", t="BRICK1" }
  RROCK11  = { f="RROCK11", t="BSTONE1" }
  RROCK12  = { f="RROCK12", t="BSTONE2" }

  RROCK13  = { f="RROCK13", t="ROCK3" }
  RROCK14  = { f="RROCK14", t="BIGBRIK1" }
  RROCK15  = { f="RROCK15", t="TANROCK7" }
  RROCK16  = { f="RROCK16", t="ZIMMER5" }
  RROCK17  = { f="RROCK17", t="ZIMMER3" }
  RROCK18  = { f="RROCK18", t="ZIMMER3" }
  RROCK19  = { f="RROCK19", t="ZIMMER2" }
  RROCK20  = { f="RROCK20", t="ZIMMER7" }

  SLIME09  = { f="SLIME09", t="ROCKRED1" } -- animated
  SLIME13  = { f="SLIME13", t="BRICK10" }
  SLIME14  = { f="SLIME14", t="METAL2" }
  SLIME15  = { f="SLIME15", t="COMPSPAN" }
  SLIME16  = { f="SLIME16", t="SPACEW4" }


  -- rails --

  DBRAIN1  = { t="DBRAIN1",  rail_h=32 }

  MIDBARS1 = { t="MIDBARS1", rail_h=128 }
  MIDBARS3 = { t="MIDBARS3", rail_h=72  }
  MIDBRONZ = { t="MIDBRONZ", rail_h=128 }
  MIDSPACE = { t="MIDSPACE", rail_h=128 }

  -- scaled MIDVINE2 from FreeDoom
  MIDVINE2 = { t="SP_DUDE8", rail_h=128 }


  -- liquid stuff (keep them recognisable)
  BFALL1   = { t="BFALL1",  f="BLOOD1", sane=1 }
  BLOOD1   = { t="BFALL1",  f="BLOOD1", sane=1 }

  SFALL1   = { t="SFALL1",  f="NUKAGE1", sane=1 }
  NUKAGE1  = { t="SFALL1",  f="NUKAGE1", sane=1 }

  KFALL1   = { t="BLODRIP1", f="SLIME01", sane=1 }  -- new patches
  KFALL5   = { t="BLODRIP1", f="SLIME05", sane=1 }
  SLIME01  = { t="BLODRIP1", f="SLIME01", sane=1 }
  SLIME05  = { t="BLODRIP1", f="SLIME05", sane=1 }
}



--------------------------------------------------------------------
--  Final DOOM
--------------------------------------------------------------------

TNT.MATERIALS =
{
  TNTDOOR  = { t="TNTDOOR",  f="FLAT23" }
  DOC1     = { t="DOC1",     f="FLAT23" }
  DISASTER = { t="DISASTER", f="FLOOR7_1" }
  MTNT1    = { t="MTNT1",    f="FLOOR7_2" }

  BTNTSLVR = { t="BTNTSLVR", f="FLAT23" }
  BTNTMETL = { t="BTNTMETL", f="CEIL5_2" }
  CUBICLE  = { t="CUBICLE",  f="CEIL5_1" }
  M_TEC    = { t="M_TEC",    f="CEIL5_2" }
  YELMETAL = { t="YELMETAL", f="CEIL5_2" }

  METALDR  = { t="METALDR",  f="CEIL5_2" }
  METAL_BD = { t="METAL-BD", f="CEIL5_2" }
  METAL_RM = { t="METAL-RM", f="CEIL5_2" }
  METAL2BD = { t="METAL2BD", f="CEIL5_2" }

  M_RDOOR  = { t="M_RDOOR",  f="FLOOR7_1" }
  M_YDOOR  = { t="M_RDOOR",  f="FLOOR7_1" }

  -- we replace the existing DOOM material for these two
  SUPPORT3 = { t="EGSUPRT3", f="CEIL5_2" }
  ASHWALL2 = { t="ASPHALT",  f="MFLR8_4" }
  MFLR8_4  = { t="ASPHALT",  f="MFLR8_4" }
  FLAT8    = { f="FLAT8",    t="DOKODO1B" }

  CAVERN1  = { t="CAVERN1",  f="RROCK07" }
  CAVERN4  = { t="CAVERN4",  f="MFLR8_3" }
  CAVERN6  = { t="CAVERN6",  f="RROCK17" }
  CAVERN7  = { t="CAVERN7",  f="RROCK16" }

  SMSTONE6 = { t="SMSTONE6", f="RROCK09" }
  STONEW1  = { t="STONEW1",  f="RROCK09" }
  STONEW5  = { t="STONEW5",  f="MFLR8_3" }

  -- All the crates here! --

  -- 64x64 etc
  CR64LB  = { t="CR64LB",  f="CRATOP2" }
  CRLWDS6 = { t="CRLWDS6", f="CRATOP2" } --64x32, not really useful

  -- 64x128
  CRBLWDH6 = { t="CRBLWDH6", f="CRATOP2" }
  CRBWDH64 = { t="CRBWDH64", f="FLAT5_2" }
  CRLWDL6B = { t="CRLWDL6B", f="CRATOP2" }
  CR64HBRM = { t="CR64HBRM", f="CRATOP2" }
  CR64HBBP = { t="CR64HBBP", f="CRATOP2" }
  CR64HGBP = { t="CR64HGBP", f="CRATOP1" }
  CR64SLGB = { t="CR64SLGB", f="CRATOP1" }
  CR64HBG  = { t="CR64HBG",  f="CRATOP2" }
  CR64HBB  = { t="CR64HBB",  f="CRATOP2" }
  CR64HGB  = { t="CR64HGB",  f="CRATOP1" }
  CR64HGG  = { t="CR64HGG",  f="CRATOP1" }
  CRSMB    = { t="CRSMB",    f="CRATOP2" }
  CRWDL64A = { t="CRWDL64A", f="FLAT5_2" }
  CRWDL64B = { t="CRWDL64B", f="FLAT5_2" }
  CRWDL64C = { t="CRWDL64C", f="FLAT5_2" }
  CRWDT32  = { t="CRWDT32",  f="FLAT5_2" }
  CRWDH64  = { t="CRWDH64",  f="FLAT5_2" }
  CRWDH64B = { t="CRWDH64B", f="FLAT5_2" }
  CRWDS64  = { t="CRWDH64",  f="FLAT5_2" }
  CRLWDH6B = { t="CRLWDH6B", f="CRATOP2" }
  CRLWDL6  = { t="CRLWDL6",  f="CRATOP2" }
  CRLWDL6E = { t="CRLWDL6E", f="CRATOP2" }
  CRLWDL6C = { t="CRLWDL6C", f="CRATOP2" }
  CRLWDL6D = { t="CRLWDL6D", f="CRATOP2" }
  CRTINYB  = { t="CRTINYB",  f="CRATOP2" }
  CRLWDH6  = { t="CRLWDH6",  f="CRATOP2" }
  CR64LG   = { t="CR64LG",   f="CRATOP1" }
  CRLWDVS  = { t="CRLWDVS",  f="CRATOP2" }

  -- 128x64
  CR128LG  = { t="CR128LG",  f="CRATOP2" }
  CRBWLBP  = { t="CRBWLBP",  f="CRATOP2" }
  CR128LB  = { t="CR128LB",  f="CRATOP2" }

  -- 128x128
  CRWDL128 = { t="CRWDL128", f="FLAT5_2" }
  CRAWHBP  = { t="CRAWHBP",  f="CRATOP1" }
  CRAWLBP  = { t="CRAWLBP",  f="CRATOP2" }
  CRBWHBP  = { t="CRBWHBP",  f="CRATOP1" }
  CRLWDL12 = { t="CRLWDL12", f="CRATOP2" }
  CRBWDL12 = { t="CRBWDL12", f="FLAT5_2" }
  CR128HGB = { t="CR128HGB", f="CRATOP1" }

  DOGRMSC  = { t="DOGRMSC",  f="RROCK20" }
  DOKGRIR  = { t="DOKGRIR",  f="RROCK09" }
  DOKODO1B = { t="DOKODO1B", f="FLAT5" }
  DOKODO1B = { t="DOKODO2B", f="FLAT5" }
  DOKGRIR  = { t="DOKGRIR",  f="RROCK20" }
  DOPUNK4  = { t="DOPUNK4",  f="CEIL5_1" }
  DORED    = { t="DORES",    f="CEIL5_1" }

  PNK4EXIT = { t="PNK4EXIT", f="CEIL5_1" }

  LITEGRN1 = { t="LITEGRN1", f="FLAT1" }
  LITERED1 = { t="LITERED1", f="FLAT1" }
  LITERED2 = { t="LITERED2", f="FLAT23" }
  LITEYEL1 = { t="LITEYEL1", f="CEIL5_1" }
  LITEYEL2 = { t="LITEYEL2", f="FLAT23" }
  LITEYEL3 = { t="LITEYEL3", f="FLAT23" }

  EGGREENI = { t="EGGREENI", f="RROCK20" }
  EGREDI   = { t="EGREDI",   f="FLAT5_3" }
  ALTAQUA  = { t="ALTAQUA",  f="RROCK20" }

  -- Egypt stuff --

  BIGMURAL = { t="BIGMURAL", f="FLAT1_1" }
  MURAL1   = { t="MURAL1",   f="FLAT1_1" }
  MURAL2   = { t="MURAL2",   f="FLAT1_1" }

  PILLAR   = { t="PILLAR",   f="FLAT1_1" }
  BIGWALL  = { t="BIGWALL",  f="FLAT8"   } --256x128, Egyptian mural decor
  DRSIDE1  = { t="DRSIDE1",  f="FLAT1_1" } --32x128, useful for small supports, doesn't tile too well
  DRSIDE2  = { t="DRSIDE2",  f="FLAT1_1" } --32x128, useful for small supports, doesn't tile too well
  DRTOPFR  = { t="DRTOPFR",  f="FLAT1_1" } --32x65
  DRTOPSID = { t="DRTOPSID", f="FLAT1_1" } --32x65
  LONGWALL = { t="LONGWALL", f="FLAT1_1" } --256x128, Anubis mural
  SKIRTING = { t="SKIRTING", f="FLAT1_1" } --256x43, Egyptian hieroglyphics
  STWALL   = { t="STWALL",   f="CRATOP2" }
  DRFRONT  = { t="DRFRONT",  rail_h=128  } --Transparent in center, not really useful

  -- Transparent openings --

  GRNOPEN = { t="GRNOPEN", rail_h=128 } --SP_ROCK1 64x128 opening
  REDOPEN = { t="REDOPEN", rail_h=128 } --ROCKRED 64x128 opening
  BRNOPEN = { t="BRNOPEN", rail_h=128 } --STONE6 64x128 opening

  -- Rails --

  DOGRID   = { t="DOGRID",   rail_h=128 }
  DOWINDOW = { t="DOWINDOW", rail_h=68 } --Yea, it's 64x68
  DOGLPANL = { t="DOGLPANL", rail_h=128 }
  DOBWIRE  = { t="DOBWIRE",  rail_h=128 }
  DOBWIRE2 = { t="DOBWIRE2", rail_h=128 } --Has no real use, no X flipped variant
  SMGLASS1 = { t="SMGLASS",  rail_h=128  }
  TYIRONLG = { t="TYIRONLG", rail_h=128 }
  TYIRONSM = { t="TYIRONSM", rail_h=72  }
  WEBL = { t="WEBL", rail_h=128 } --Not really useful
  WEBR = { t="WEBR", rail_h=128 } --Not really useful
}


PLUTONIA.MATERIALS =
{
  -- Note the hyphens in the actual texture names, which have been
  -- converted to an underscore for the OBLIGE material names.
  
  A_BRBRK  = { t="A-BRBRK",  f="RROCK18" }
  A_BRBRK2 = { t="A-BRBRK2", f="RROCK16" }
  A_BRICK1 = { t="A-BRICK1", f="MFLR8_1" }
  A_BROWN1 = { t="A-BROWN1", f="RROCK17" }
  A_BROWN2 = { t="A-BROWN2", f="FLAT8" }
  A_BROWN3 = { t="A-BROWN3", f="RROCK03" }
  A_BROWN5 = { t="A-BROWN5", f="RROCK19" }

  A_CAMO1 =  { t="A-CAMO1",  f="GRASS1" }
  A_CAMO2 =  { t="A-CAMO2",  f="SLIME13" }
  A_CAMO3 =  { t="A-CAMO3",  f="SLIME13" }
  A_CAMO4 =  { t="A-CAMO4",  f="FLOOR7_2" }

  A_DBRI1 =  { t="A-DBRI1",  f="FLAT5_4" }
  A_DBRI2 =  { t="A-DBRI2",  f="MFLR8_2" }
  A_DROCK1 = { t="A-DROCK1", f="FLOOR6_2" }
  A_DROCK2 = { t="A-DROCK2", f="MFLR8_2" }

  A_MARBLE = { t="A-MARBLE", f="FLAT1" }
  A_MOSBRI = { t="A-MOSBRI", f="SLIME13" }
  A_MOSROK = { t="A-MOSROK", f="FLAT5_7" }
  A_MOSRK2 = { t="A-MOSRK2", f="SLIME13" }
  A_MOULD =  { t="A-MOULD",  f="RROCK19" }
  A_MUD =    { t="A-MUD",    f="RROCK16" }

  A_MYWOOD = { t="A-MYWOOD", f="FLAT5_1" }
  A_POIS =   { t="A-POIS",   f="CEIL5_2" }
  A_REDROK = { t="A-REDROK", f="FLAT5_3" }
  A_ROCK =   { t="A-ROCK",   f="FLAT5_7" }
  A_TILE =   { t="A-TILE",   f="GRNROCK" }  
  A_VINE3 =  { t="A-VINE3",  f="RROCK12" }
  A_VINE4 =  { t="A-VINE4",  f="RROCK16" }
  A_VINE5 =  { t="A-VINE5",  f="MFLR8_3" }

  A_YELLOW = { t="A-YELLOW", f="FLAT23" }

  -- TODO: A-SKINxxx

  -- this is animated
  AROCK1   = { t="AROCK1",   f="GRNROCK" }
  FIREBLU1 = { t="FIREBLU1", f="GRNROCK" }

  JUNGLE1  = { t="MC10", f="RROCK19" }
  JUNGLE2  = { t="MC2",  f="RROCK19" }

  -- use the TNT name for this
  METALDR  = { t="A-BROWN4", f="CEIL5_2" }

  -- replacement materials
  WOOD1    = { t="A-MYWOOD", f="FLAT5_2" }
  CEIL1_1  = { f="CEIL1_1", t="A-WOOD1", color=0x5b442b }
  CEIL1_3  = { f="CEIL1_3", t="A-WOOD1", color=0x594d3d }
  FLAT5_1  = { f="FLAT5_1", t="A-WOOD1", color=0x503b22 }
  FLAT5_2  = { f="FLAT5_2", t="A-WOOD1", color=0x503c24 }

  STONE   = { t="A-CONCTE", f="FLAT5_4" }
  FLAT5_4 = { t="A-CONCTE", f="FLAT5_4" }

  BIGBRIK2 = { t="A-BRICK1", f="MFLR8_1" }
  BIGBRIK1 = { t="A-BRICK2", f="RROCK14" }
  RROCK14  = { t="A-BRICK2", f="RROCK14" }
  BRICK5   = { t="A-BRICK3", f="RROCK12" }
  BRICJ10  = { t="A-TILE",   f="GRNROCK" }  
  BRICK11  = { t="A-BRBRK",  f="RROCK18" }
  BRICK12  = { t="A-BROCK2", f="FLOOR4_6" }

  ASHWALL4 = { t="A-DROCK2", f="MFLR8_2" }
  ASHWALL7 = { t="A-MUD",    f="RROCK16" }

  -- use Plutonia's waterfall texture instead of our own
  WFALL1   = { t="WFALL1", f="FWATER1", sane=1 }
  FWATER1  = { t="WFALL1", f="FWATER1", sane=1 }


  -- TODO: Rails
  --   A_GRATE = { t="A-GRATE", h=129 }
  --   A_GRATE = { t="A-GRATE", h=129 }
  --   A_RAIL1 = { t="A-RAIL1", h=32 }
  --   A_VINE1 = { t="A-VINE1", h=128 }
  --   A_VINE2 = { t="A-VINE2", h=128 }
}

