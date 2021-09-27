HARMONY.LIQUIDS =
{
  water   = { mat="WATER",   light=0.50, special=0 },
  w_steel = { mat="W_STEEL", light=0.50, special=0 },
  w_rock  = { mat="W_ROCK",  light=0.50, special=0 },
  w_ice   = { mat="W_ICE",   light=0.50, special=0 },

  lava    = { mat="LAVA",    light=0.75, special=16 },
  nukage  = { mat="NUKAGE",  light=0.65, special=16 }
}

HARMONY.MATERIALS =
{
  -- FIXME!!! very incomplete

  -- special materials --

  _DEFAULT = { t="METAL3",   f="DEM1_6" },
  _ERROR = { t="METAL3", f="DEM1_6" },
  _SKY   = { t="METAL3", f="F_SKY1" },

  -- materials for generic prefab set --  
  _SBARS = { t="0LASER4", f="XX" }, -- Short bars, i.e. railings
  _SBARS2 = { t="0DRIEHK2", f="XX" },
  _MBARS = { t="ROCKRED1", f="XX" }, -- Medium bars, i.e. barred windows
  _TBARS = { t="1LIFT1", f="XX" }, -- Tall bars, i.e. cage/jail bars
  
  _CRATE   = { t="0EXPLOS",  f="FLOOR6_1" }, -- Crate/box
  _CRATE2  = { t="SPCDOOR2", f="FLOOR4_1" },
  _CRATWID = { t="SPCDOOR2", f="FLOOR4_1" }, -- Wide crates
  
  _WATER   = { f="FWATER1", t="SFALL1"   }, -- "Standing water", sorta
  _WTRFALL = { f="FWATER1", t="SFALL1"   }, -- "Flowing water", sorta
    
  _DOOR  = { t="WOODMET3", f="CEIL5_1" }, -- Open says me
  _DOOR2 = { t="ZIMMER1", f="CEIL5_1" },
  _DORRAIL = { t="DOORTRAK", f="CEIL5_1" }, -- Inner door slider thingys
  
  _NPIC    = { t="BRICK6", f="XX"}, -- Narrow (non-tiling) pic box insert, 64 pixels wide
  _NPIC2    = { t="BRICK4", f="XX"},
  _NPIC3    = { t="STONE5", f="XX"},
  
  _MPIC    = { t="CEMENT4", f="XX"}, -- Medium (or tiling) pic box insert, 128 pixels wide
  _MPIC2    = { t="MARBLE3", f="XX"},
  _MPIC3    = { t="SP_DUDE1", f="XX"},
  _MPIC4    = { t="CEMENT3", f="XX"},
  _MPIC5    = { t="1BABY", f="XX"},
  _MPIC6    = { t="0IMP", f="XX"},
  _MPIC7    = { t="0MONIT1", f="XX"},
  
  _WPIC    = { t="ZZZFACE1", f="XX"}, -- Wide (or tiling) pic box insert, 256 pixels wide
  _WPIC2    = { t="ZZZFACE4", f="XX"},
  _WPIC3    = { t="SKINMET1", f="XX"},
  
  _KEYTRM1 = { t="SPACEW4", f="XX" }, -- Trim for locked door, Key 1
  _KEYTRM2 = { t="PANBORD2", f="XX" }, -- Trim for locked door, Key 2
  _KEYTRM3 = { t="0DARKBLU", f="XX" }, -- Trim for locked door, Key 3
  
  _EXITDR1 = { t="BIGDOOR2", f="CEIL5_1" }, -- Exit door
  _EXITSW1  = { t="SW1MET2", f="CEIL5_1" }, -- Exit switch
  _EXITRM1  = { t="0TTT", f="CEIL5_1" }, -- Exit switch
  
  _STRUCT = {t="METAL3",   f="DEM1_6" }, -- "Structural" texture (window trim, beams, other areas where a window/floor flat just isn't always right)

  _SW1  = { t="SW1MET2",  f="DEM1_6" }, -- General purpose swtich, full size
  _SW1TRIM = { t="METAL3",  f="DEM1_6" }, -- Trim for switch
  
  _TELE = { f="FLOOR5_3", t="PANEL8" }, -- Teleporter
  
  -- general purpose --

  METAL  = { t="METAL3",   f="DEM1_6" },

  DOORTRAK = { t="DOORTRAK", f="CEIL5_1" },

  LIFT  = { t="1LIFT2", f="STEP2" },

  YELLOWLITE = { t="PANBORD2", f="FLOOR4_8" },


  -- walls --

  ORANJE3 = { t="0ORANJE3", f="FLOOR0_3" },
  STOEL4  = { t="1STOEL4",  f="RROCK13" },

  LOGO_1 = { t="0IMP", f="FLOOR4_8" },

  BIGDOOR3 = { t="BIGDOOR3", f="FLOOR4_8" },
  BIGDOOR4 = { t="BIGDOOR4", f="FLOOR4_8" },

  GREENWALL = { t="1GREEN", f="FLOOR4_1" },
  PURPLE_UGH = { t="SP_DUDE8", f="DEM1_5" },

  GRAY1 = { t="ZZWOLF7", f="FLAT5_4" },


  -- floors --

  DIRT  = { f="MFLR8_2", t="STONE6" },

  FLOOR4_8 = { f="FLOOR4_8", t="SILVER3" },

  GRASS2 = { f="GRASS2", t="ZZWOLF11" },

  ROCKS = { f="TLITE6_4", t="ZZWOLF9" },


  -- switches --

  SW2COMM = { t="SW2COMM", f="FLOOR4_8" },

  SW2SLAD = { t="SW2SLAD", f="FLOOR4_1" },

  EXITSIGN = { t="EXITSIGN", f="DEM1_5" },


  -- rails --

  LADDER       = { t="0LADDER",  rail_h=128 },
  LASER_BEAM   = { t="0LASER4",  rail_h=8 },
  ELECTRICITY  = { t="ROCKRED1", rail_h=48 },

  RED_WIRING   = { t="MODWALL1", rail_h=128 },
  BLUE_WIRING  = { t="CEMENT7",  rail_h=128 },
  FANCY_WINDOW = { t="ZELDOOR", rail_h=128 },

  GRATE_HOLE   = { t="STUCCO3", rail_h=64 },
  RUSTY_GRATE  = { t="MIDGRATE", rail_h=128 },
  METAL_BAR1   = { t="0MBAR1",  rail_h=16 },
  METAL_BAR2   = { t="0MBAR2",  rail_h=64 },

  R_LIFT1   = { t="1LIFT1", rail_h=128 },
  R_LIFT3   = { t="1LIFT3", rail_h=128 },
  R_LIFT4   = { t="1LIFT4", rail_h=128 },
  R_PRED    = { t="0PRED",  rail_h=128 },

  BAR_MUSIC = { t="SP_DUDE7", rail_h=128 },
  NO_WAR    = { t="0GRAFFI",  rail_h=128 },
  LAST_DOPE = { t="0DOPE",    rail_h=64  },
  THE_END   = { t="0END2",    rail_h=128 },

  BIG_BRIDGE_L = { t="SKINMET2", rail_h=128 },
  BIG_BRIDGE_R = { t="SKINSCAB", rail_h=128 },

  GLASS       = { t="SLOPPY1", rail_h=128 },
  GLASS_SMASH = { t="SLOPPY2", rail_h=128 },
  GLASS_BLUE  = { t="0BLUEGL", rail_h=128 },

  BLUE_PEAK   = { t="0ARK1", rail_h=128 },
  METAL_ARCH  = { t="0ARCH", rail_h=128 },

  STONE_ARCH   = { t="ZZWOLF3",  rail_h=64 },
  STONE_PEAK   = { t="0DRIEHK1", rail_h=32 },
  STONE_CURVE1 = { t="0CURVE1",  rail_h=128 },
  STONE_CURVE2 = { t="0CURVE2",  rail_h=128 },

  IRIS_DOOR1  = { t="0IRIS1", rail_h=128 },
  IRIS_DOOR2  = { t="0IRIS2", rail_h=128 },
  IRIS_DOOR3  = { t="0IRIS3", rail_h=128 },
  IRIS_DOOR4  = { t="0IRIS4", rail_h=128 },
  IRIS_FRAME1 = { t="0IRIS5", rail_h=128 },
  IRIS_FRAME2 = { t="0IRIS7", rail_h=128 },


  -- liquids --

  WATER   = { f="FWATER1", t="SFALL1"   },
  W_ICE   = { f="NUKAGE1", t="SFALL1"   },
  W_ROCK  = { f="SLIME05", t="SFALL1"   },
  W_STEEL = { f="BLOOD1",  t="GSTFONT1" },
                          
  LAVA    = { f="SLIME01", t="0ROOD02"  },  -- NOTE: texture not animated
  NUKAGE  = { f="SLIME09", t="BFALL1"   },

  TELEPORT = { f="FLOOR5_3", t="PANEL8" }

  -- other --

--FIXME:
--  O_PILL   = { t="HW313", f="O_PILL",   sane=1 }
--  O_BOLT   = { t="HW316", f="O_BOLT",   sane=1 }
--  O_RELIEF = { t="HW329", f="O_RELIEF", sane=1 }
--  O_CARVE  = { t="HW309", f="O_CARVE",  sane=1 }
}

HARMONY.PREFAB_FIELDS =
{
  -- TODO : compatibility with DOOM prefabs
}


HARMONY.SKIN_DEFAULTS =
{
}
