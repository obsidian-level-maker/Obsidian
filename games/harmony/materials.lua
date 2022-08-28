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
  XEMPTY = { t="-", f="-" },

  -- materials for generic prefab set --
  _LIFT = { t="METAL2", f="SLIME15" },
  _RUNIC = { t="0ROOD02", f="SLIME13" },
  _STAIRS = { t="STEP6", f="FLAT5_4" },
  _VOID = { t="0ARK5", f="XX" },
  _WALLLIT = { t="PANBORD2", f="XX"},  
  _SBARS = { t="0LASER4", f="XX" }, -- Short bars, i.e. railings
  _MBARS = { t="1LIFT1", f="XX" }, -- Medium bars, i.e. barred windows
  _TBARS = { t="1LIFT1", f="XX" }, -- Tall bars, i.e. cage/jail bars
  
  _CRATE   = { t="0EXPLOS",  f="FLOOR6_1" }, -- Crate/box
  _CRATE2  = { t="SPCDOOR2", f="FLOOR4_1" },
  _CRATWID = { t="SPCDOOR2", f="FLOOR4_1" }, -- Wide crates
    
  _SMLDOOR  = { t="BIGDOOR3", f="FLAT8" }, -- Open says me
  _BIGDOOR = { t="BIGDOOR2", f="CEIL5_1" },
  _TALDOOR  = { t="ZIMMER1", f="FLAT23" },
  _DORRAIL = { t="DOORTRAK", f="CEIL5_1" }, -- Inner door slider thingys
  
  _NPIC    = { t="BRICK6", f="XX"}, -- Narrow (non-tiling) pic box insert, 64 pixels wide
  
  _MPIC    = { t="CEMENT4", f="XX"}, -- Medium (or tiling) pic box insert, 128 pixels wide
  
  _WPIC    = { t="ZZZFACE1", f="XX"}, -- Wide (or tiling) pic box insert, 256 pixels wide
  
  _KEYTRM1 = { t="SPACEW4", f="XX" }, -- Trim for locked door, Key 1
  _KEYTRM2 = { t="PANBORD2", f="XX" }, -- Trim for locked door, Key 2
  _KEYTRM3 = { t="0DARKBLU", f="XX" }, -- Trim for locked door, Key 3
  
  _EXITDR = { t="SPCDOOR3", f="CEIL5_1" }, -- Exit door
  _EXITSW = { t="SW1TEK", f="FLAT14" }, -- Exit switch
  _EXITTR = { t="TEKGREN2", f="FLAT14" }, -- Exit switch trim
  _EXITRM = { t="TEKGREN2", f="FLAT14" }, -- Exit switch room
  _EXITSGN = { t="EXITSIGN", f="DEM1_5" }, -- Exit sign
  
  _STRUCT = {t="METAL",   f="DEM1_6" }, -- "Structural" texture (window trim, beams, other areas where a window/floor flat just isn't always right)

  _SW  = { t="SW1COMM", f="FLAT23" }, -- General purpose swtich, 32x32
  _SWTRIM = { t="SILVER1", f="FLAT23" }, -- Trim for switch
  
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
  -- These are used for converting generic locked linedefs --
  
  line_700 = 26,
  line_701 = 27,
  line_702 = 28,
  line_703 = 1,  -- Regular door open
  line_704 = 11, -- Switch, exit
  line_705 = 51, -- Switch, secret exit
  line_706 = 52, -- Walk-over line, exit
  line_707 = 124, -- Walk-over line, secret exit
  line_708 = 97, -- Walk-over line, teleport
  --line_709 = 888, -- Switch (don't think I need this one)
  line_710 = 123, -- Switched, lower lift, wait, raise (fast) -- Is this too specific? - Dasho
  line_711 = 31, -- Door open stay
  line_712 = 109, -- Walk-over, door open stay (fast)
  line_713 = 23, -- Switched, floor lower to nearest floor
  line_714 = 103, -- Switched, door open stay
  line_715 = 126, -- Walk-over line, teleport (monsters only)

  -- These are used for converting generic fab things --
  thing_11000 = 2035, -- Barrel
  thing_11001 = 63, -- Ceiling light
  thing_11002 = 57, -- Standalone light
  thing_11003 = 44, -- Wall light (torch)
  thing_11004 = 2028, -- Short standalone light
  thing_11005 = 48, -- Small pillar
  thing_11006 = 5, -- Key one
  thing_11007 = 6, -- Key two
  thing_11008 = 13, -- Key three
  thing_11009 = 1, -- P1 Start
  thing_11010 = 2, -- P2 Start
  thing_11011 = 3, -- P3 Start
  thing_11012 = 4, -- P4 Start
  thing_11013 = 14, -- Teleport destination
  thing_11014 = 61, -- Passable ceiling decor
}


HARMONY.SKIN_DEFAULTS =
{
}
