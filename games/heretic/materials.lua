------------------------------------------------------------------------
--  HERETIC MATERIALS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.LIQUIDS =
{
  water  = { mat="FLTFLWW1", light_add=16, special=0 }
  water2 = { mat="FLTWAWA1", light_add=16, special=0 }
  sludge = { mat="FLTSLUD1", light_add=16, special=16, damage=20 }
  lava   = { mat="FLATHUH1", light_add=24, special=16, damage=20 }
  magma  = { mat="FLTLAVA1", light_add=16, special=16, damage=20 }
}


HERETIC.MATERIALS =
{
  -- special materials --

  _ERROR   = { t="WOODWL",  f="FLOOR10" }
  _DEFAULT = { t="GRSTNPB", f="FLOOR03" }
  _SKY     = { t="CHAINSD", f="F_SKY1"  }

  -- general purpose --

  METAL    = { t="METL1",    f="FLOOR29" }

  -- walls --

  BANNER1  = { t="BANNER1",  f="FLOOR03" }
  BANNER2  = { t="BANNER2",  f="FLOOR03" }
  BANNER3  = { t="BANNER3",  f="FLAT520" }
  BANNER4  = { t="BANNER4",  f="FLAT520" }
  BANNER5  = { t="BANNER5",  f="FLOOR25" }
  BANNER6  = { t="BANNER6",  f="FLOOR25" }
  BANNER7  = { t="BANNER7",  f="FLOOR00" }
  BANNER8  = { t="BANNER8",  f="FLOOR00" }
  BLUEFRAG = { t="BLUEFRAG", f="FLOOR16" }
  BRWNRCKS = { t="BRWNRCKS", f="FLOOR17" }

  CELTIC   = { t="CELTIC",   f="FLOOR06" }
  CHAINMAN = { t="CHAINMAN", f="FLAT520" }
  CSTLMOSS = { t="CSTLMOSS", f="FLOOR03" }
  CSTLRCK  = { t="CSTLRCK",  f="FLOOR03" }
  CTYSTCI1 = { t="CTYSTCI1", f="FLOOR11" }
  CTYSTCI2 = { t="CTYSTCI2", f="FLOOR11" }
  CTYSTCI4 = { t="CTYSTCI4", f="FLOOR11" }
  CTYSTUC1 = { t="CTYSTUC1", f="FLOOR11" }
  CTYSTUC2 = { t="CTYSTUC2", f="FLOOR11" }
  CTYSTUC3 = { t="CTYSTUC3", f="FLOOR11" }
  CTYSTUC4 = { t="CTYSTUC4", f="FLOOR11" }
  CTYSTUC5 = { t="CTYSTUC5", f="FLOOR11" }

  DMNMSK   = { t="DMNMSK",   f="FLAT521" }
  DOOREXIT = { t="DOOREXIT", f="FLAT520" }
  DOORSTON = { t="DOORSTON", f="FLOOR30" }
  DOORWOOD = { t="DOORWOOD", f="FLAT507" }
  DRIPWALL = { t="DRIPWALL", f="FLOOR27" }

  GRNBLOK1 = { t="GRNBLOK1", f="FLOOR19" }
  GRNBLOK2 = { t="GRNBLOK2", f="FLOOR19" }
  GRNBLOK3 = { t="GRNBLOK3", f="FLOOR19" }
  GRNBLOK4 = { t="GRNBLOK4", f="FLOOR19" }
  GRSKULL1 = { t="GRSKULL1", f="FLAT521" }
  GRSKULL2 = { t="GRSKULL2", f="FLAT521" }
  GRSKULL3 = { t="GRSKULL3", f="FLAT521" }
  GRSTNPB  = { t="GRSTNPB",  f="FLAT520" }
  GRSTNPBV = { t="GRSTNPBV", f="FLAT520" }
  GRSTNPBW = { t="GRSTNPBW", f="FLAT520" }
  HORSES1  = { t="HORSES1",  f="FLAT520" }

  LOOSERCK = { t="LOOSERCK", f="FLOOR04" }
  METL1    = { t="METL1",    f="FLOOR29" }
  METL2    = { t="METL2",    f="FLOOR28" }
  MOSAIC1  = { t="MOSAIC1",  f="FLAT502" }
  MOSAIC2  = { t="MOSAIC2",  f="FLAT502" }
  MOSAIC3  = { t="MOSAIC3",  f="FLAT502" }
  MOSAIC4  = { t="MOSAIC4",  f="FLAT502" }
  MOSAIC5  = { t="MOSAIC5",  f="FLAT502" }
  MOSSRCK1 = { t="MOSSRCK1", f="FLOOR05" }

  ORNGRAY  = { t="ORNGRAY",  f="FLAT504" }
  RCKSNMUD = { t="RCKSNMUD", f="FLOOR01" }
  REDWALL  = { t="REDWALL",  f="FLOOR09" }
  ROOTWALL = { t="ROOTWALL", f="FLAT506" }

  SAINT1   = { t="SAINT1",   f="FLAT523" }
  SANDSQ2  = { t="SANDSQ2",  f="FLOOR06" }
  SKULLSB1 = { t="SKULLSB1", f="FLOOR30" }
  SNDBLCKS = { t="SNDBLCKS", f="FLOOR06" }
  SNDCHNKS = { t="SNDCHNKS", f="FLAT522" }
  SNDPLAIN = { t="SNDPLAIN", f="FLOOR25" }
  SPINE1   = { t="SPINE1",   f="FLOOR25" }
  SPINE2   = { t="SPINE2",   f="FLOOR25" }

  SQPEB1   = { t="SQPEB1",   f="FLAT504" }
  SQPEB2   = { t="SQPEB2",   f="FLOOR27" }
  STNGLS1  = { t="STNGLS1",  f="FLOOR30" }
  STNGLS2  = { t="STNGLS2",  f="FLOOR30" }
  STNGLS3  = { t="STNGLS3",  f="FLOOR30" }

  TMBSTON1 = { t="TMBSTON1", f="FLAT521" }
  TMBSTON2 = { t="TMBSTON2", f="FLAT521" }
  TRISTON1 = { t="TRISTON1", f="FLOOR00" }
  TRISTON2 = { t="TRISTON2", f="FLOOR17" }
  WOODWL   = { t="WOODWL",   f="FLOOR10" }

  -- switches --

  SW1OFF   = { t="SW1OFF",   f="FLOOR28" }
  SW1ON    = { t="SW1ON",    f="FLOOR28" }

  -- floors --

  FLAT500  = { f="FLAT500", t="SQPEB1" }
  FLAT502  = { f="FLAT502", t="BLUEFRAG" }
  FLAT503  = { f="FLAT503", t="SQPEB1" }
  FLAT504  = { f="FLAT504", t="SQPEB1" }
  FLAT506  = { f="FLAT506", t="ROOTWALL" }
  FLAT507  = { f="FLAT507", t="DOORWOOD" }
  FLAT508  = { f="FLAT508", t="DOORWOOD" }
  FLAT509  = { f="FLAT509", t="LOOSERCK" }
  FLAT510  = { f="FLAT510", t="BRWNRCKS" }

  FLAT512  = { f="FLAT512", t="GRNBLOK1" }
  FLAT513  = { f="FLAT513", t="GRNBLOK1" }
  FLAT516  = { f="FLAT516", t="LOOSERCK" }
  FLAT517  = { f="FLAT517", t="BLUEFRAG" }
  FLAT520  = { f="FLAT520", t="CSTLRCK" }
  FLAT521  = { f="FLAT521", t="SQPEB1" }
  FLAT522  = { f="FLAT522", t="SNDCHNKS" }
  FLAT523  = { f="FLAT523", t="GRSTNPB" }

  FLOOR00  = { f="FLOOR00", t="TRISTON1" }
  FLOOR01  = { f="FLOOR01", t="LOOSERCK" }
  FLOOR03  = { f="FLOOR03", t="CSTLRCK" }
  FLOOR04  = { f="FLOOR04", t="CSTLRCK" }
  FLOOR05  = { f="FLOOR05", t="MOSSRCK1" }
  FLOOR06  = { f="FLOOR06", t="SANDSQ2" }
  FLOOR07  = { f="FLOOR07", t="MOSAIC1" }
  FLOOR08  = { f="FLOOR08", t="CHAINSD" }
  FLOOR09  = { f="FLOOR09", t="REDWALL" }
  FLOOR10  = { f="FLOOR10", t="WOODWL" }
  FLOOR11  = { f="FLOOR11", t="WOODWL" }
  FLOOR12  = { f="FLOOR12", t="WOODWL" }
  FLOOR16  = { f="FLOOR16", t="BLUEFRAG" }
  FLOOR17  = { f="FLOOR17", t="BRWNRCKS" }
  FLOOR18  = { f="FLOOR18", t="GRNBLOK1" }
  FLOOR19  = { f="FLOOR19", t="GRNBLOK1" }

  FLOOR20  = { f="FLOOR20", t="SQPEB2" }
  FLOOR21  = { f="FLOOR21", t="CHAINSD" }
  FLOOR22  = { f="FLOOR22", t="CHAINSD" }
  FLOOR23  = { f="FLOOR23", t="CHAINSD" }
  FLOOR24  = { f="FLOOR24", t="CHAINSD" }
  FLOOR25  = { f="FLOOR25", t="SPINE2" }
  FLOOR26  = { f="FLOOR26", t="CHAINSD" }
  FLOOR27  = { f="FLOOR27", t="SANDSQ2" }
  FLOOR28  = { f="FLOOR28", t="METL2" }
  FLOOR29  = { f="FLOOR29", t="METL1" }
  FLOOR30  = { f="FLOOR30", t="METL1" }

  -- rails --

  WOODGATE = { t="WDGAT64", rail_h=64 }

  GATE_BIG = { t="GATMETL",  rail_h=128 }
  GATMETL2 = { t="GATMETL2", rail_h=32 }
  GATMETL3 = { t="GATMETL3", rail_h=32 }
  GATMETL4 = { t="GATMETL4", rail_h=64 }
  GATMETL5 = { t="GATMETL5", rail_h=128 }

  WEB1_B = { t="WEB1_B", rail_h=32 }
  WEB1_F = { t="WEB1_F", rail_h=32 }
  WEB2_B = { t="WEB2_B", rail_h=32 }
  WEB2_F = { t="WEB2_F", rail_h=32 }
  WEB3_M = { t="WEB3_M", rail_h=32 }

  -- liquids / animated --

  -- TODO: simplify this
  LAVA1    = { t="LAVA1",    f="FLAT506" }
  LAVAFL1  = { t="LAVAFL1",  f="FLATHUH1" }
  WATRWAL1 = { t="WATRWAL1", f="FLTFLWW1" }

  FLATHUH1 = { f="FLATHUH1", t="LAVAFL1"  }
  FLTFLWW1 = { f="FLTFLWW1", t="WATRWAL1" }
  FLTLAVA1 = { f="FLTLAVA1", t="LAVA1"    }
  FLTSLUD1 = { f="FLTSLUD1", t="LAVA1"    }
  FLTTELE1 = { f="FLTTELE1", t="CHAINSD"  }
  FLTWAWA1 = { f="FLTWAWA1", t="WATRWAL1" }

  -- other --

  O_PILL   = { t="SKULLSB2", f="O_PILL",  sane=1 }
  O_BOLT   = { t="DOORWOOD", f="O_BOLT",  sane=1 }
  O_CARVE  = { t="CHAINSD",  f="O_CARVE", sane=1 }
}


------------------------------------------------------------------------

HERETIC.PREFAB_FIELDS =
{
  -- compatibility with DOOM prefabs
  tex_DOORTRAK = "METL1"
  tex_DOORSTOP = "METL1"

  flat_CEIL1_2 = "FLOOR11"
  flat_CEIL5_2 = "FLOOR28"
  flat_FLAT1   = "FLAT521"

  line_117 = 1  -- Heretic does not have linetype #117

  thing_4001 = "light"
  thing_4002 = "light"
  thing_4003 = "light"
  thing_4004 = "light"
}


HERETIC.SKIN_DEFAULTS =
{
}

