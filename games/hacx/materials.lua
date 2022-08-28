HACX.LIQUIDS =
{
  water  = { mat="L_WATER",  light=168, special=0 },
  water2 = { mat="L_WATER2", light=168, special=0 },

  slime  = { mat="L_SLIME",  light=168, special=16, damage=20 },
  goo    = { mat="L_GOO",    light=168, special=16, damage=20 },
  lava   = { mat="L_LAVA",   light=192, special=16, damage=20 },
  elec   = { mat="L_ELEC",   light=176, special=16, damage=20 }
}

HACX.MATERIALS =
{
  -- special materials --
  _ERROR = { t="HW209", f="RROCK03" },
  _SKY   = { t="HW209", f="F_SKY1" },
  _DEFAULT = { t="HW209", f="RROCK03" },
  _LIQUID = { f="FWATER1", t="BLODRIP1" },
  XEMPTY = { t="-", f="-" },

  -- materials for generic prefab set --
  _RUNIC = { t="STONE2", f="FLAT5_2" },
  _STAIRS = { t="HW216", f="CONS1_5" },
  _VOID = { t="GRAY5", f="XX" },
  _WALLLIT = { t="HW208", f="XX"},
  _LIFT  = { t="BIGDOOR2", f="CONS1_5" },
  _SBARS = { t="HW211", f="RROCK03" }, -- Short bars, i.e. railings
  _MBARS = { t="TEKGREN2", f="RROCK03" }, -- Medium bars, i.e. barred windows
  _TBARS = { t="HW203", f="RROCK03" }, -- Tall bars, i.e. cage/jail bars
  
  _CRATE   = { t="HW200",  f="RROCK14" }, -- Crate/box
  _CRATE2  = { t="HW200", f="RROCK14" },
  _CRATWID = { t="HW200", f="RROCK14" },
  
  _SMLDOOR  = { t="BIGDOOR1", f="RROCK03" }, -- Open says me
  _BIGDOOR = { t="BIGDOOR2", f="RROCK03" },
  _TALDOOR  = { t="BIGDOOR1", f="RROCK03" },
  _DORRAIL = { t="HW209", f="RROCK03" }, -- Inner door slider thingys
  
  _NPIC    = { t="HW223", f="RROCK03"}, -- Narrow (non-tiling) pic box insert, 64 pixels wide x 128 high
  
  _MPIC    = { t="HW191", f="RROCK03"}, -- Medium (or tiling) pic box insert, 128 pixels wide x 128 high
  
  _WPIC    = { t="HW331", f="RROCK03"}, -- Wide (or tiling) pic box insert, 256 pixels wide x 128 high
  
  _KEYTRM1 = { t="HW510", f="RROCK03" }, -- Trim for locked door, Key 1
  _KEYTRM2 = { t="HW511", f="RROCK03" }, -- Trim for locked door, Key 2
  _KEYTRM3 = { t="HW512", f="RROCK03" }, -- Trim for locked door, Key 3
  
  _EXITDR = { t="DOORRED", f="RROCK02" }, -- Exit door
  _EXITSW  = { t="SW1BRN1",  f="FLOOR0_2" }, -- Exit switch
  _EXITTR  = { t="BRICK10",  f="FLOOR0_2" }, -- Exit switch trim
  _EXITRM  = { t="BRICK10",  f="FLOOR0_2" }, -- Exit switch room
  _EXITSGN = { t="HAC_EXIT", f="CONS1_5"},
  
  _STRUCT = {t="HW209", f="RROCK03"}, -- "Structural" texture (window trim, beams, other areas where a window/floor flat just isn't always right)

  _SW  = { t="SW1BRN1",  f="FLOOR0_2" }, -- Switch is roughly 32x32 in size, rest of the texture is 'hidden'
  _SWTRIM = { t="BRICK10",  f="FLOOR0_2" }, -- Trim for switch
  
  _TELE = { f="BLOOD1",  t="BRONZE1" }, -- Teleporter

  -- general purpose --

  METAL  = { t="HW209", f="RROCK03" },

  LIFT   = { t="HW176", f="DEM1_1" },

  -- walls --

  BROWNHUG = { t="BROWNHUG", f="BLOOD1" },

  DOORTRAK = { t="HW209", f="RROCK03" },

  HD6   = { t="HD6",   f="RROCK03" },
  HW211 = { t="HW211", f="RROCK03" },
  HW510 = { t="HW510", f="SLIME15" },
  HW511 = { t="HW511", f="SLIME14" },
  HW512 = { t="HW512", f="SLIME13" },
  HW513 = { t="HW513", f="SLIME16" },

  TECHY1 = { t="HW172", f="FLAT5_1" },
  WOODY1 = { t="COMPTALL", f="RROCK14" },
  BLOCKY1 = { t="HW219", f="RROCK11" },
  BLOCKY2 = { t="MIDBRONZ", f="CONS1_1" },

  CAVEY1 = { t="MARBFAC4", f="RROCK12" },
  DIRTY1 = { t="PANCASE1", f="RROCK15" },
  DIRTY2 = { t="PANEL2",   f="RROCK15" },
  STONY1 = { t="PLANET1",  f="GRNROCK" },

  GRAY_ROCK = { t="HW185", f="FLOOR0_1" },

  DARK_CONC = { t="HW205", f="CONS1_5" },


  LITE2 = { t="LITE2", f="DEM1_2" },

  MODWALL3 = { t="MODWALL3", f="CEIL3_3" },


  TECH_PIC1 = { t="BRNSMALR", f="RROCK03" },
  TECH_PIC2 = { t="CEMENT7",  f="RROCK03" },

  TECH_COMP = { t="COMPSTA2", f="RROCK03" },

  LOGO_1 = { t="PANEL6", f="RROCK03" },

  -- doors --
  
  BIGDOOR1   = { t="BIGDOOR1",   f="RROCK03" },
  BIGDOOR2 = { t="BIGDOOR2", f="RROCK03" },
  BIGDOOR4 = { t="BIGDOOR4", f="RROCK03" },
  DOOR1 = { t="DOOR1", f="RROCK03" },
  DOOR3 = { t="DOOR3", f="RROCK03" },
  DOORBLU = { t="DOORBLU", f="RROCK03" },
  DOORRED = { t="DOORRED", f="RROCK03" },

  -- switches --

  SW1CMT = { t="SW1CMT", f="DEM1_2" },


  -- floors --

  GRASS1 = { t="MARBGRAY", f="TLITE6_1" },
  GRASS2 = { t="MARBGRAY", f="CONS1_7" },

  GRAY_BRICK = { f="GRASS2", t="STARTAN3" },
  HERRING_1  = { f="FLAT9", t="HW306" },
  WOOD_TILE  = { f="CEIL5_2", t="MIDBARS1", },

--FLAT14   = { t="STARTAN3", f="FLAT14" }


  -- rails --

  CABLE   = { t="HW167",    rail_h=48 },
  SHARKS  = { t="FIREWALB", rail_h=128 },
  SHELVES = { t="TEKGREN1", rail_h=128 },
  GRILL   = { t="TEKGREN2", rail_h=128 },
  WEB     = { t="HW213",    rail_h=34 },

  CAGE3     = { t="SPACEW3", rail_h=128 },
  CAGE4     = { t="SPACEW4", rail_h=128 },
  CAGE_BUST = { t="HW181",   rail_h=128 },

  FORCE_FIELD = { t="SLADRIP1", rail_h=128 },
  HIGH_BARS   = { t="HW203",    rail_h=128 },
  BRIDGE_RAIL = { t="HW211",    rail_h=128 },
  SUPT_BEAM   = { t="SHAWN2",   rail_h=128 },
  BARRACADE   = { t="HW225",    rail_h=128 },

  DARK_CONC_HOLE = { t="HW204", rail_h=128 },
  GRAY_ROCK_HOLE = { t="HW183", rail_h=128 },
  WASHGTON_HOLE  = { t="HW353", rail_h=128 },


  -- liquids / animated --

  L_ELEC   = { f="NUKAGE1", t="HW177" },
  L_GOO    = { f="LAVA1",   t="HW325" },
  L_WATER  = { f="FWATER1", t="BLODRIP1" },
  L_WATER2 = { f="SLIME05", t="WFALL1" },
  L_LAVA   = { f="SLIME09", t="SFALL1" },
  L_SLIME  = { f="SLIME01", t="BRICK6" },

  TELEPORT = { f="BLOOD1",  t="BRONZE1" },


  -- other --

  O_PILL   = { t="HW313", f="O_PILL",   sane=1 },
  O_BOLT   = { t="HW316", f="O_BOLT",   sane=1 },
  O_RELIEF = { t="HW329", f="O_RELIEF", sane=1 },
  O_CARVE  = { t="HW309", f="O_CARVE",  sane=1 }
}

------------------------------------------------------------------------

HACX.PREFAB_FIELDS =
{
  -- Generic locked door conversion --
  line_700 = 28,
  line_701 = 27,
  line_702 = 26,
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
  thing_11001 = 44, -- Ceiling light
  thing_11002 = 57, -- Standalone light
  thing_11003 = 56, -- Wall light (torch)
  thing_11004 = 55, -- Short standalone light
  thing_11005 = 48, -- Small pillar
  thing_11006 = 38, -- Key one
  thing_11007 = 39, -- Key two
  thing_11008 = 40, -- Key three
  thing_11009 = 1, -- P1 Start
  thing_11010 = 2, -- P2 Start
  thing_11011 = 3, -- P3 Start
  thing_11012 = 4, -- P4 Start
  thing_11013 = 14, -- Teleport destination
  thing_11014 = 74, -- Passable ceiling decor
}


HACX.SKIN_DEFAULTS =
{
}
