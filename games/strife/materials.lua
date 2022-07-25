------------------------------------------------------------------------
--  STRIFE MATERIALS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

STRIFE.LIQUIDS =
{
  water = { mat="F_WATR01", light_add=16, special=0 },
}


STRIFE.MATERIALS =
{
  -- special materials --
  _DEFAULT = { t="CONCRT01", f="F_CONCRP" },
  _ERROR = { t="BIGSTN02", f="P_SPLATR" },
  _SKY   = { t="BIGSTN01", f="F_SKY001" },

 -- materials for generic prefab set --
 _LIFT = { t="ELEVTR03", f="F_ELTOP2" },
 _RUNIC = { t="ALNSKN01", f="F_TENTIC" },
 _STAIRS = { t="STAIR09", f="F_OLDWOD" },
 _VOID = { t="BLACK01", f="XX" },
 _WALLLIT = { t="SCAN01", f="XX"},  
 _SBARS = { t="RAIL01", f="XX" }, -- Short bars, i.e. railings
 _MBARS = { t="GRATE04", f="XX" }, -- Medium bars, i.e. barred windows
 _TBARS = { t="GRATE02", f="XX" }, -- Tall bars, i.e. cage/jail bars
 
 _CRATE   = { t="BOXCOM01",  f="F_MBOXTP" }, -- Crate/box
 _CRATE2  = { t="BOXWOD02", f="F_WBOXTP" },
 _CRATWID = { t="BOXWOD03",  f="F_WBOXTP" }, -- Wide crates
   
 _SMLDOOR  = { t="DORWS02", f="F_UNDOOR" }, -- Open says me
 _BIGDOOR = { t="DORWL01", f="F_UNDOOR" },
 _TALDOOR = { t="DORMS01", f="F_UNDOOR" },
 _DORRAIL = { t="DORTRK02", f="F_UNDOOR"}, -- Inner door slider thingys
 
 _NPIC    = { t="BRNSCN02", f="XX"}, -- Narrow (non-tiling) pic box insert, 64 pixels wide
 
 _MPIC    = { t="BANR02", f="XX"}, -- Medium (or tiling) pic box insert, 128 pixels wide
 
 _WPIC    = { t="GLASS05", f="XX"}, -- Wide (or tiling) pic box insert, 256 pixels wide
 
 _KEYTRM1 = { t="WINDW03", f="XX" }, -- Trim for locked door, Key 1
 _KEYTRM2 = { t="WINDW02", f="XX" }, -- Trim for locked door, Key 2
 _KEYTRM3 = { t="WINDW04", f="XX" }, -- Trim for locked door, Key 3
 
 _EXITDR = { t="DORTKS01", f="F_UNDOOR" }, -- Exit door
 _EXITSW  = { t="SWTELP01", f="F_GDCONC" }, -- Exit switch
 _EXITTR  = { t="CONCRT01", f="F_GDCONC" }, -- Exit switch trim
 _EXITRM  = { t="CONCRT01", f="F_GDCONC" }, -- Exit switch
 _EXITSGN  = { t="SWEXIT02", f="F_GDCONC" }, -- Exit switch
 
 _STRUCT = {t="CONCRT01", f="F_CONCRP"}, -- "Structural" texture (window trim, beams, other areas where a window/floor flat just isn't always right)

 _SW  = { t="SWPALM01", f="F_GDCONC" }, -- General purpose swtich, full size
 _SWTRIM = { t="CONCRT01", f="F_GDCONC" }, -- Trim for switch
 
 _TELE = { t="CONCRT01", f="F_TELE1" }, -- Teleporter

  -- textures --

  BRKGRY01 = { t="BRKGRY01", f="F_BRKTOP" },
  BRKGRY17 = { t="BRKGRY17", f="F_BRKTOP" },
  WALCAV01 = { t="WALCAV01", f="F_CAVE01" },
  DORWS02  = { t="DORWS02", f="F_PLYWOD" },
  DORTRK02 = { t="DORTRK02", f="F_PLYWOD" },
  WOOD08   = { t="WOOD08", f="F_PLYWOD" },

  -- flats --

  F_BRKTOP = { t="BRKGRY01", f="F_BRKTOP" },
  F_CAVE01 = { t="WALCAV01", f="F_CAVE01" },

  -- liquids --
  F_WATR01 = { f="F_WATR01", t="WATR01" },

  -- rails --
  RAIL01 = { t="RAIL01", rail_h=32}, -- Short bars, i.e. railings
  RAIL03 = { t="RAIL03", rail_h=32},
  GRATE04 = { t="GRATE04", rail_h=64}, -- Medium bars, i.e. barred windows
  GRATE02 = { t="GRATE02", rail_h=128 }, 

}


------------------------------------------------------------------------

STRIFE.PREFAB_FIELDS =
{
  -- These are used for converting generic locked linedefs --
  
  line_700 = 28,
  line_701 = 26,
  line_702 = 27,
  line_703 = 1,  -- Regular door open
  line_704 = 11, -- Switch, exit
  line_705 = 11, -- Switch, secret exit
  line_706 = 52, -- Walk-over line, exit
  line_707 = 52, -- Walk-over line, secret exit
  line_708 = 97, -- Walk-over line, teleport
  --line_709 = 888, -- Switch (don't think I need this one)
  line_710 = 123, -- Switched, lower lift, wait, raise (fast) -- Is this too specific? - Dasho
  line_711 = 31, -- Door open stay
  line_712 = 109, -- Walk-over, door open stay (fast)
  line_713 = 23, -- Switched, floor lower to nearest floor
  line_714 = 103, -- Switched, door open stay
  line_715 = 126, -- Walk-over line, teleport (monsters only)

  -- These are used for converting generic fab things --
  thing_11000 = 94, -- Barrel
  thing_11001 = 28, -- Ceiling light
  thing_11002 = 2028, -- Standalone light
  thing_11003 = 107, -- Wall light (torch)
  thing_11004 = 34, -- Short standalone light
  thing_11005 = 69, -- Small pillar
  thing_11006 = 40, -- Key one
  thing_11007 = 184, -- Key two
  thing_11008 = 185, -- Key three
  thing_11009 = 1, -- P1 Start
  thing_11010 = 2, -- P2 Start
  thing_11011 = 3, -- P3 Start
  thing_11012 = 4, -- P4 Start
  thing_11013 = 14, -- Teleport destination
  thing_11014 = 0, -- Passable ceiling decor
}


STRIFE.SKIN_DEFAULTS =
{
}

