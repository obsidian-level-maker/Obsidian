------------------------------------------------------------------------
--  HERETIC MATERIALS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--  Additions by Dashodanger 2021
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.LIQUIDS =
{
  water  = { mat="FLTFLWW1", light_add=16, special=0 },
  water2 = { mat="FLTWAWA1", light_add=16, special=0 },
  sludge = { mat="FLTSLUD1", light_add=16, special=16, damage=20 },
  lava   = { mat="FLATHUH1", light_add=24, special=16, damage=20 },
  magma  = { mat="FLTLAVA1", light_add=16, special=16, damage=20 },
}


HERETIC.MATERIALS =
{
  -- special materials --

  _ERROR   = { t="WOODWL",  f="FLOOR10" },
  _DEFAULT = { t="GRSTNPB", f="FLOOR03" },
  _SKY     = { t="CHAINSD", f="F_SKY1"  },
  XEMPTY = { t="-", f="-" },
  
  -- materials for generic prefab set --
  _LIFT = { t="SKULLSB1", f="FLOOR30" },
  _RUNIC = { t="REDWALL", f="FLOOR09" },
  _STAIRS = { t="WOODWL", f="FLOOR10" },
  _VOID = { t="STNGLS3", f="XX" }, -- Only works with small areas and exact offsets, but it's the only thing I could find with solid black areas
  _WALLLIT = { t="STNGLS1", f="XX" }, -- Same as above, but for "wall lights"
  _SBARS = { t="GATMETL3", f="FLOOR30" }, -- Short bars, i.e. railings
  _MBARS = { t="GATMETL4", f="FLOOR30" }, -- Medium bars, i.e. barred windows
  _TBARS = { t="GATMETL5", f="FLOOR30" }, -- Tall bars, i.e. cage/jail bars
  
  _CRATE   = { t="DOORWOOD",  f="FLAT507" }, -- Crate/box
  _CRATE2  = { t="CTYSTCI4", f="FLOOR10" },
  _CRATWID = { t="DOORWOOD",  f="FLAT507" }, -- Wide crates
    
  _SMLDOOR  = { t="DOORWOOD", f="FLAT507" }, -- Open says me
  _BIGDOOR = { t="DOORSTON", f="FLOOR30" },
  _TALDOOR = { t="DOORWOOD", f="FLAT507" },
  _DORRAIL = { t="METL2", f="FLOOR28"}, -- Inner door slider thingys
  
  _NPIC    = { t="CELTIC", f="FLOOR06"}, -- Narrow (non-tiling) pic box insert, 64 pixels wide
  
  _MPIC    = { t="CELTIC", f="FLOOR06"}, -- Medium (or tiling) pic box insert, 128 pixels wide
  
  _WPIC    = { t="CHAINMAN", f="FLAT520"}, -- Wide (or tiling) pic box insert, 256 pixels wide
  
  _KEYTRM1 = { t="SPINE1", f="FLOOR25" }, -- Trim for locked door, Key 1
  _KEYTRM2 = { t="GRNBLOK1", f="FLOOR19" }, -- Trim for locked door, Key 2
  _KEYTRM3 = { t="BLUEFRAG", f="FLOOR16" }, -- Trim for locked door, Key 3
  
  _EXITDR = { t="DOOREXIT", f="FLAT520" }, -- Exit door
  _EXITSW  = { t="SW2OFF", f="FLOOR28" }, -- Exit switch
  _EXITTR  = { t="METL2", f="FLOOR28" }, -- Exit switch trim
  _EXITRM  = { t="METL2", f="FLOOR28" }, -- Exit room
  _EXITSGN = { t="HER_EXIT", f="FLOOR04"},
  
  _STRUCT = {t="METL2", f="FLOOR30"}, -- "Structural" texture (window trim, beams, other areas where a window/floor flat just isn't always right)

  _SW  = { t="SW1OFF", f="FLOOR30" }, -- General purpose swtich, full size
  _SWTRIM = { t="METL2", f="FLOOR30" }, -- Trim for switch
  
  _TELE = { t="CHAINSD", f="FLTTELE1" }, -- Teleporter
  

  -- general purpose --

  METAL    = { t="METL1",    f="FLOOR29" },

  -- walls --

  BANNER1  = { t="BANNER1",  f="FLOOR03" },
  BANNER2  = { t="BANNER2",  f="FLOOR03" },
  BANNER3  = { t="BANNER3",  f="FLAT520" },
  BANNER4  = { t="BANNER4",  f="FLAT520" },
  BANNER5  = { t="BANNER5",  f="FLOOR25" },
  BANNER6  = { t="BANNER6",  f="FLOOR25" },
  BANNER7  = { t="BANNER7",  f="FLOOR00" },
  BANNER8  = { t="BANNER8",  f="FLOOR00" },
  BLUEFRAG = { t="BLUEFRAG", f="FLOOR16" },
  BRWNRCKS = { t="BRWNRCKS", f="FLOOR17" },

  CELTIC   = { t="CELTIC",   f="FLOOR06" },
  CHAINSD  = { t="CHAINSD",  f="FLOOR08" },
  CHAINMAN = { t="CHAINMAN", f="FLAT520" },
  CSTLMOSS = { t="CSTLMOSS", f="FLOOR03" },
  CSTLRCK  = { t="CSTLRCK",  f="FLOOR03" },
  CTYSTCI1 = { t="CTYSTCI1", f="FLOOR11" },
  CTYSTCI2 = { t="CTYSTCI2", f="FLOOR11" },
  CTYSTCI4 = { t="CTYSTCI4", f="FLOOR11" },
  CTYSTUC1 = { t="CTYSTUC1", f="FLOOR11" },
  CTYSTUC2 = { t="CTYSTUC2", f="FLOOR11" },
  CTYSTUC3 = { t="CTYSTUC3", f="FLOOR11" },
  CTYSTUC4 = { t="CTYSTUC4", f="FLOOR11" },
  CTYSTUC5 = { t="CTYSTUC5", f="FLOOR11" },

  DMNMSK   = { t="DMNMSK",   f="FLAT521" },
  DOOREXIT = { t="DOOREXIT", f="FLAT520" },
  DOORSTON = { t="DOORSTON", f="FLOOR30" },
  DOORWOOD = { t="DOORWOOD", f="FLAT507" },
  DRIPWALL = { t="DRIPWALL", f="FLOOR27" },

  GRNBLOK1 = { t="GRNBLOK1", f="FLOOR19" },
  GRNBLOK2 = { t="GRNBLOK2", f="FLOOR19" },
  GRNBLOK3 = { t="GRNBLOK3", f="FLOOR19" },
  GRNBLOK4 = { t="GRNBLOK4", f="FLOOR19" },
  GRSKULL1 = { t="GRSKULL1", f="FLAT521" },
  GRSKULL2 = { t="GRSKULL2", f="FLAT521" },
  GRSKULL3 = { t="GRSKULL3", f="FLAT521" },
  GRSTNPB  = { t="GRSTNPB",  f="FLAT520" },
  GRSTNPBV = { t="GRSTNPBV", f="FLAT520" },
  GRSTNPBW = { t="GRSTNPBW", f="FLAT520" },
  HORSES1  = { t="HORSES1",  f="FLAT520" },

  LOOSERCK = { t="LOOSERCK", f="FLOOR04" },
  METL1    = { t="METL1",    f="FLOOR29" },
  METL2    = { t="METL2",    f="FLOOR28" },
  MOSAIC1  = { t="MOSAIC1",  f="FLAT502" },
  MOSAIC2  = { t="MOSAIC2",  f="FLAT502" },
  MOSAIC3  = { t="MOSAIC3",  f="FLAT502" },
  MOSAIC4  = { t="MOSAIC4",  f="FLAT502" },
  MOSAIC5  = { t="MOSAIC5",  f="FLAT502" },
  MOSSRCK1 = { t="MOSSRCK1", f="FLOOR05" },

  ORNGRAY  = { t="ORNGRAY",  f="FLAT504" },
  RCKSNMUD = { t="RCKSNMUD", f="FLOOR01" },
  REDWALL  = { t="REDWALL",  f="FLOOR09" },
  ROOTWALL = { t="ROOTWALL", f="FLAT506" },

  SAINT1   = { t="SAINT1",   f="FLAT523" },
  SANDSQ2  = { t="SANDSQ2",  f="FLOOR06" },
  SKULLSB1 = { t="SKULLSB1", f="FLOOR30" },
  SKULLSB2 = { t="SKULLSB2", f="FLOOR30" },
  SNDBLCKS = { t="SNDBLCKS", f="FLOOR06" },
  SNDCHNKS = { t="SNDCHNKS", f="FLAT522" },
  SNDPLAIN = { t="SNDPLAIN", f="FLOOR25" },
  SPINE1   = { t="SPINE1",   f="FLOOR25" },
  SPINE2   = { t="SPINE2",   f="FLOOR25" },

  SQPEB1   = { t="SQPEB1",   f="FLAT504" },
  SQPEB2   = { t="SQPEB2",   f="FLOOR27" },
  STNGLS1  = { t="STNGLS1",  f="FLOOR30" },
  STNGLS2  = { t="STNGLS2",  f="FLOOR30" },
  STNGLS3  = { t="STNGLS3",  f="FLOOR30" },

  TMBSTON1 = { t="TMBSTON1", f="FLAT521" },
  TMBSTON2 = { t="TMBSTON2", f="FLAT521" },
  TRISTON1 = { t="TRISTON1", f="FLOOR00" },
  TRISTON2 = { t="TRISTON2", f="FLOOR17" },
  WOODWL   = { t="WOODWL",   f="FLOOR10" },

  -- switches --

  SW1OFF   = { t="SW1OFF",   f="FLOOR28" },
  SW1ON    = { t="SW1ON",    f="FLOOR28" },

  -- floors --

  FLAT500  = { f="FLAT500", t="SQPEB1" },
  FLAT502  = { f="FLAT502", t="BLUEFRAG" },
  FLAT503  = { f="FLAT503", t="SQPEB1" },
  FLAT504  = { f="FLAT504", t="SQPEB1" },
  FLAT506  = { f="FLAT506", t="ROOTWALL" },
  FLAT507  = { f="FLAT507", t="DOORWOOD" },
  FLAT508  = { f="FLAT508", t="DOORWOOD" },
  FLAT509  = { f="FLAT509", t="LOOSERCK" },
  FLAT510  = { f="FLAT510", t="BRWNRCKS" },

  FLAT512  = { f="FLAT512", t="GRNBLOK1" },
  FLAT513  = { f="FLAT513", t="GRNBLOK1" },
  FLAT516  = { f="FLAT516", t="LOOSERCK" },
  FLAT517  = { f="FLAT517", t="BLUEFRAG" },
  FLAT520  = { f="FLAT520", t="CSTLRCK" },
  FLAT521  = { f="FLAT521", t="SQPEB1" },
  FLAT522  = { f="FLAT522", t="SNDCHNKS" },
  FLAT523  = { f="FLAT523", t="GRSTNPB" },

  FLOOR00  = { f="FLOOR00", t="TRISTON1" },
  FLOOR01  = { f="FLOOR01", t="LOOSERCK" },
  FLOOR03  = { f="FLOOR03", t="CSTLRCK" },
  FLOOR04  = { f="FLOOR04", t="CSTLRCK" },
  FLOOR05  = { f="FLOOR05", t="MOSSRCK1" },
  FLOOR06  = { f="FLOOR06", t="SANDSQ2" },
  FLOOR07  = { f="FLOOR07", t="MOSAIC1" },
  FLOOR08  = { f="FLOOR08", t="CHAINSD" },
  FLOOR09  = { f="FLOOR09", t="REDWALL" },
  FLOOR10  = { f="FLOOR10", t="WOODWL" },
  FLOOR11  = { f="FLOOR11", t="WOODWL" },
  FLOOR12  = { f="FLOOR12", t="WOODWL" },
  FLOOR16  = { f="FLOOR16", t="BLUEFRAG" },
  FLOOR17  = { f="FLOOR17", t="BRWNRCKS" },
  FLOOR18  = { f="FLOOR18", t="GRNBLOK1" },
  FLOOR19  = { f="FLOOR19", t="GRNBLOK1" },

  FLOOR20  = { f="FLOOR20", t="SQPEB2" },
  FLOOR21  = { f="FLOOR21", t="CHAINSD" },
  FLOOR22  = { f="FLOOR22", t="CHAINSD" },
  FLOOR23  = { f="FLOOR23", t="CHAINSD" },
  FLOOR24  = { f="FLOOR24", t="CHAINSD" },
  FLOOR25  = { f="FLOOR25", t="SPINE2" },
  FLOOR26  = { f="FLOOR26", t="CHAINSD" },
  FLOOR27  = { f="FLOOR27", t="SANDSQ2" },
  FLOOR28  = { f="FLOOR28", t="METL2" },
  FLOOR29  = { f="FLOOR29", t="METL1" },
  FLOOR30  = { f="FLOOR30", t="METL1" },

  -- rails --

  WOODGATE = { t="WDGAT64", rail_h=64 },
  WDGAT64  = { t="WDGAT64", rail_h=64 },

  GATE_BIG = { t="GATMETL",  rail_h=128 },
  GATMETL2 = { t="GATMETL2", rail_h=32 },
  GATMETL3 = { t="GATMETL3", rail_h=32 },
  GATMETL4 = { t="GATMETL4", rail_h=64 },
  GATMETL5 = { t="GATMETL5", rail_h=128 },

  WEB1_B = { t="WEB1_B", rail_h=32 },
  WEB1_F = { t="WEB1_F", rail_h=32 },
  WEB2_B = { t="WEB2_B", rail_h=32 },
  WEB2_F = { t="WEB2_F", rail_h=32 },
  WEB3_M = { t="WEB3_M", rail_h=32 },

  -- liquids / animated --

  -- TODO: simplify this
  LAVA1    = { t="LAVA1",    f="FLAT506" },
  LAVAFL1  = { t="LAVAFL1",  f="FLATHUH1" },
  WATRWAL1 = { t="WATRWAL1", f="FLTFLWW1" },

  FLATHUH1 = { f="FLATHUH1", t="LAVAFL1"  },
  FLTFLWW1 = { f="FLTFLWW1", t="WATRWAL1" },
  FLTLAVA1 = { f="FLTLAVA1", t="LAVA1"    },
  FLTSLUD1 = { f="FLTSLUD1", t="LAVA1"    },
  FLTTELE1 = { f="FLTTELE1", t="CHAINSD"  },
  FLTWAWA1 = { f="FLTWAWA1", t="WATRWAL1" },

  -- other --

  O_BOLT   = { t="DOORWOOD", f="O_BOLT",  sane=1 },
}


------------------------------------------------------------------------

HERETIC.PREFAB_FIELDS =
{
  -- These are used for converting generic locked linedefs --

  line_700 = 27, -- Yellow key door
  line_701 = 28, -- Green key door
  line_702 = 26, -- Blue key door
  line_703 = 1,  -- Regular door open
  line_704 = 11, -- Switch, exit
  line_705 = 51, -- Switch, secret exit
  line_706 = 52, -- Walk-over line, exit
  line_707 = 105, -- Walk-over line, secret exit
  line_708 = 97, -- Walk-over line, teleport
  --line_709 = 888, -- Switch (don't think I need this one)
  line_710 = 62, -- Switched, lower lift, wait, raise
  line_711 = 31, -- Door open stay
  line_712 = 2,  -- Walk-over, door open stay
  line_713 = 23, -- Switched, floor lower to nearest floor
  line_714 = 103, -- Switched, door open stay
  line_715 = 97, -- Walk-over line, teleport (monsters only) (not in Heretic, use normal teleport)

  -- These are used for converting generic fab things --
  thing_11000 = 2035, -- Barrel
  thing_11001 = 28, -- Ceiling light
  thing_11002 = 76, -- Standalone light
  thing_11003 = 50, -- Wall light (torch)
  thing_11004 = 27, -- Short standalone light (Heretic's serpent torch is a little tall, but still)
  thing_11005 = 29, -- Small pillar
  thing_11006 = 80, -- Key one
  thing_11007 = 73, -- Key two
  thing_11008 = 79, -- Key three
  thing_11009 = 1, -- P1 Start
  thing_11010 = 2, -- P2 Start
  thing_11011 = 3, -- P3 Start
  thing_11012 = 4, -- P4 Start
  thing_11013 = 14, -- Teleport destination
  thing_11014 = 49, -- Passable ceiling decor

}


HERETIC.SKIN_DEFAULTS =
{
}

