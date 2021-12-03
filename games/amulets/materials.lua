AMULETS.LIQUIDS =
{
  water = { mat="WATER", special=5 },
  lava   = { mat="LAVA", wall="FIREMAG1", special=16, light=64 },
}

AMULETS.MATERIALS =
{
  -- special materials --
  _ERROR = { t="DGITEX14", f="GRASS2" },
  _SKY   = { t="DGITEX14", f="F_SKY1" },
  _DEFAULT = { t="MARBL02", f="MARBL02" },
  _LIQUID = { f="WATER_01", t="ALTWATR" },

  -- materials for generic prefab set --
  _RUNIC = { t="ERIC1", f="ERIC1" },
  _STAIRS = { t="CRYPT1", f="MARBL02" },
  _VOID = { t="BLACK", f="XX" },
  _WALLLIT = { t="T6", f="XX"},
  _LIFT  = { t="DGITEX45", f="FLAT10" },
  _SBARS = { t="FLAT5_2", f="FLAT5_2" }, -- Short bars, i.e. railings
  _MBARS = { t="FLAT5_2", f="FLAT5_2" }, -- Medium bars, i.e. barred windows
  _TBARS = { t="FLAT5_2", f="FLAT5_2" }, -- Tall bars, i.e. cage/jail bars
  
  _CRATE   = { t="WOOD1",  f="WOOD1" }, -- Crate/box
  _CRATE2  = { t="WOOD5", f="WOOD5" },
  _CRATWID = { t="T00103", f="T00103" },
  
  _SMLDOOR  = { t="FINAL04", f="FINAL04" }, -- Open says me
  _BIGDOOR = { t="FINAL04", f="FINAL04" },
  _DORRAIL = { t="T00114", f="T00114" }, -- Inner door slider thingys
  
  _NPIC    = { t="BLODGRC", f="BLODGRC"}, -- Narrow (non-tiling) pic box insert, 64 pixels wide x 128 high
  
  _MPIC    = { t="DECWAL", f="DECWAL"}, -- Medium (or tiling) pic box insert, 128 pixels wide x 128 high
  
  _WPIC    = { t="ANUTHWAL", f="ANUTHWAL"}, -- Wide (or tiling) pic box insert, 256 pixels wide x 128 high
  
  --_KEYTRM1 = { t="HW510", f="RROCK03" }, -- Trim for locked door, Key 1
  --_KEYTRM2 = { t="HW511", f="RROCK03" }, -- Trim for locked door, Key 2
  --_KEYTRM3 = { t="HW512", f="RROCK03" }, -- Trim for locked door, Key 3
  
  _EXITDR = { t="CLAWDOOR", f="FLAT17" }, -- Exit door
  _EXITSW  = { t="SW2BRN1",  f="FLAT17" }, -- Exit switch
  _EXITTR  = { t="FLAT17",  f="FLAT17" }, -- Exit switch trim
  _EXITRM  = { t="CLNWD",  f="FLAT17" }, -- Exit switch room
  --_EXITSGN = { t="HAC_EXIT", f="CONS1_5"},
  
  _STRUCT = { t="T39", f="T39" }, -- "Structural" texture (window trim, beams, other areas where a window/floor flat just isn't always right)

  _SW  = { t="SWIT1D",  f="DGITEX26" }, -- Switch is roughly 32x32 in size, rest of the texture is 'hidden'
  _SWTRIM = { t="DGITEX26",  f="DGITEX26" }, -- Trim for switch
  
  _TELE = { f="FLAT23",  t="BIGDOOR3" }, -- Teleporter

  -- textures --

  WALL1 = { t="T39", f="T39" },

  ROCK1 = { t="FART3", f="GRASS2" },

  -- flats --

  GRASS2 = { t="DGITEX30", f="GRASS2" },

  -- liquids --

  WATER = { t="ALTWATR", f="WATER_01" },
  LAVA = { t="ALTLAVA", f="LAVAL" }

}

------------------------------------------------------------------------

AMULETS.PREFAB_FIELDS =
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
  line_709 = 888, -- Switch?
  line_710 = 123, -- Switched, lower lift, wait, raise (fast) -- Is this too specific? - Dasho
  line_711 = 31, -- Door open stay
  line_712 = 109, -- Walk-over, door open stay (fast)
  line_713 = 23, -- Switched, floor lower to nearest floor

  -- These are used for converting generic fab things --
  thing_11000 = 2035, -- Barrel
  thing_11001 = 44, -- Ceiling light
  thing_11002 = 57, -- Standalone light
  thing_11003 = 56, -- Wall light (torch)
  thing_11004 = 57, -- Wide standalone light
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


AMULETS.SKIN_DEFAULTS =
{
}
