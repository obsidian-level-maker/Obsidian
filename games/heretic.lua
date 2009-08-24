----------------------------------------------------------------
-- GAME DEF : Heretic
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2009 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------
--
--  Big thanks to Sam Trenholme who greatly improved the
--  Heretic theme (including lots of new COMBOs).
--
----------------------------------------------------------------

HERETIC_THINGS =
{
  --- special stuff ---
  player1 = { id=1, kind="other", r=16,h=56 },
  player2 = { id=2, kind="other", r=16,h=56 },
  player3 = { id=3, kind="other", r=16,h=56 },
  player4 = { id=4, kind="other", r=16,h=56 },

  dm_player     = { id=11, kind="other", r=16,h=56 },
  teleport_spot = { id=14, kind="other", r=16,h=56 },

  --- monsters ---
  gargoyle   = { id=66, kind="monster", r=16,h=36 },
  fire_garg  = { id=5,  kind="monster", r=16,h=36 },
  mummy      = { id=68, kind="monster", r=22,h=64 },
  mummy_inv  = { id=69, kind="monster", r=22,h=64 },

  leader     = { id=45, kind="monster", r=22,h=64 },
  leader_inv = { id=46, kind="monster", r=22,h=64 },
  knight     = { id=64, kind="monster", r=24,h=80 },
  knight_inv = { id=65, kind="monster", r=24,h=80 },

  disciple   = { id=15, kind="monster", r=16,h=72 },
  sabreclaw  = { id=90, kind="monster", r=20,h=64 },
  weredragon = { id=70, kind="monster", r=34,h=80 },
  ophidian   = { id=92, kind="monster", r=22,h=72 },

  -- bosses
  Ironlich   = { id=6,  kind="monster", r=40,h=72 },
  Maulotaur  = { id=9,  kind="monster", r=28,h=104 },
  D_Sparil   = { id=7,  kind="monster", r=28,h=104 },

  --- pickups ---
  k_yellow   = { id=80, kind="pickup", r=20,h=16, pass=true },
  k_green    = { id=73, kind="pickup", r=20,h=16, pass=true },
  k_blue     = { id=79, kind="pickup", r=20,h=16, pass=true },

  gauntlets  = { id=2005, kind="pickup", r=20,h=16, pass=true },
  crossbow   = { id=2001, kind="pickup", r=20,h=16, pass=true },
  claw       = { id=53,   kind="pickup", r=20,h=16, pass=true },
  hellstaff  = { id=2004, kind="pickup", r=20,h=16, pass=true },
  phoenix    = { id=2003, kind="pickup", r=20,h=16, pass=true },
  firemace   = { id=2002, kind="pickup", r=20,h=16, pass=true },

  crystal    = { id=10, kind="pickup", r=20,h=16, pass=true },
  geode      = { id=12, kind="pickup", r=20,h=16, pass=true },
  arrow      = { id=18, kind="pickup", r=20,h=16, pass=true },
  quiver     = { id=19, kind="pickup", r=20,h=16, pass=true },
  claw_orb1  = { id=54, kind="pickup", r=20,h=16, pass=true },
  claw_orb2  = { id=55, kind="pickup", r=20,h=16, pass=true },
  runes1     = { id=20, kind="pickup", r=20,h=16, pass=true },
  runes2     = { id=21, kind="pickup", r=20,h=16, pass=true },
  flame_orb1 = { id=22, kind="pickup", r=20,h=16, pass=true },
  flame_orb2 = { id=23, kind="pickup", r=20,h=16, pass=true },
  mace_orb1  = { id=13, kind="pickup", r=20,h=16, pass=true },
  mace_orb2  = { id=16, kind="pickup", r=20,h=16, pass=true },

  h_vial  = { id=81, kind="pickup", r=20,h=16, pass=true },
  h_flask = { id=82, kind="pickup", r=20,h=16, pass=true },
  h_urn   = { id=32, kind="pickup", r=20,h=16, pass=true },
  shield1 = { id=85, kind="pickup", r=20,h=16, pass=true },
  shield2 = { id=31, kind="pickup", r=20,h=16, pass=true },

  bag     = { id=8,  kind="pickup", r=20,h=16, pass=true },
  wings   = { id=23, kind="pickup", r=20,h=16, pass=true },
  ovum    = { id=30, kind="pickup", r=20,h=16, pass=true },
  torch   = { id=33, kind="pickup", r=20,h=16, pass=true },
  bomb    = { id=34, kind="pickup", r=20,h=16, pass=true },
  map     = { id=35, kind="pickup", r=20,h=16, pass=true },
  chaos   = { id=36, kind="pickup", r=20,h=16, pass=true },
  shadow  = { id=75, kind="pickup", r=20,h=16, pass=true },
  ring    = { id=84, kind="pickup", r=20,h=16, pass=true },
  tome    = { id=86, kind="pickup", r=20,h=16, pass=true },

  --- scenery ---
  wall_torch    = { id=50, kind="scenery", r=10,h=64, light=255, pass=true, add_mode="extend" },
  serpent_torch = { id=27, kind="scenery", r=12,h=54, light=255 },
  fire_brazier  = { id=76, kind="scenery", r=16,h=44, light=255 },
  chandelier    = { id=28, kind="scenery", r=31,h=60, light=255, pass=true, ceil=true, add_mode="island" },

  barrel  = { id=44,   kind="scenery", r=12,h=32 },
  pod     = { id=2035, kind="scenery", r=16,h=54 },

  blue_statue   = { id=94, kind="scenery", r=16,h=54 },
  green_statue  = { id=95, kind="scenery", r=16,h=54 },
  yellow_statue = { id=96, kind="scenery", r=16,h=54 },

  moss1   = { id=48, kind="scenery", r=16,h=24, ceil=true, pass=true },
  moss2   = { id=49, kind="scenery", r=16,h=28, ceil=true, pass=true },
  volcano = { id=87, kind="scenery", r=12,h=32 },
  
  small_pillar = { id=29, kind="scenery", r=16,h=36 },
  brown_pillar = { id=47, kind="scenery", r=16,h=128 },
  glitter_red  = { id=74, kind="scenery", r=20,h=16, pass=true },
  glitter_blue = { id=52, kind="scenery", r=20,h=16, pass=true },

  stal_small_F = { id=37, kind="scenery", r=12,h=36 },
  stal_small_C = { id=39, kind="scenery", r=16,h=36, ceil=true },
  stal_big_F   = { id=38, kind="scenery", r=12,h=72 },
  stal_big_C   = { id=40, kind="scenery", r=16,h=72, ceil=true },

  hang_skull_1 = { id=17, kind="scenery", r=20,h=64, ceil=true, pass=true },
  hang_skull_2 = { id=24, kind="scenery", r=20,h=64, ceil=true, pass=true },
  hang_skull_3 = { id=25, kind="scenery", r=20,h=64, ceil=true, pass=true },
  hang_skull_4 = { id=26, kind="scenery", r=20,h=64, ceil=true, pass=true },
  hang_corpse  = { id=51, kind="scenery", r=12,h=104,ceil=true },

  --- ambient sounds ---
  amb_scream = { id=1200, kind="other", r=20,h=16, pass=true },
  amb_squish = { id=1201, kind="other", r=20,h=16, pass=true },
  amb_drip   = { id=1202, kind="other", r=20,h=16, pass=true },
  amb_feet   = { id=1203, kind="other", r=20,h=16, pass=true },
  amb_heart  = { id=1204, kind="other", r=20,h=16, pass=true },
  amb_bells  = { id=1205, kind="other", r=20,h=16, pass=true },
  amb_growl  = { id=1206, kind="other", r=20,h=16, pass=true },
  amb_magic  = { id=1207, kind="other", r=20,h=16, pass=true },
  amb_laugh  = { id=1208, kind="other", r=20,h=16, pass=true },
  amb_run    = { id=1209, kind="other", r=20,h=16, pass=true },

  env_water  = { id=41, kind="other", r=20,h=16, pass=true },
  env_wind   = { id=42, kind="other", r=20,h=16, pass=true },
}


----------------------------------------------------------------

HERETIC_PALETTE =
{
    0,  0,  0,   2,  2,  2,  16, 16, 16,  24, 24, 24,  31, 31, 31,
   36, 36, 36,  44, 44, 44,  48, 48, 48,  55, 55, 55,  63, 63, 63,
   70, 70, 70,  78, 78, 78,  86, 86, 86,  93, 93, 93, 101,101,101,
  108,108,108, 116,116,116, 124,124,124, 131,131,131, 139,139,139,
  146,146,146, 154,154,154, 162,162,162, 169,169,169, 177,177,177,
  184,184,184, 192,192,192, 200,200,200, 207,207,207, 210,210,210,
  215,215,215, 222,222,222, 228,228,228, 236,236,236, 245,245,245,
  255,255,255,  50, 50, 50,  59, 60, 59,  69, 72, 68,  78, 80, 77,
   88, 93, 86,  97,100, 95, 109,112,104, 116,123,112, 125,131,121,
  134,141,130, 144,151,139, 153,161,148, 163,171,157, 172,181,166,
  181,189,176, 189,196,185,  20, 16, 36,  24, 24, 44,  36, 36, 60,
   52, 52, 80,  68, 68, 96,  88, 88,116, 108,108,136, 124,124,152,
  148,148,172, 164,164,184, 180,184,200, 192,196,208, 208,208,216,
  224,224,224,  27, 15,  8,  38, 20, 11,  49, 27, 14,  61, 31, 14,
   65, 35, 18,  74, 37, 19,  83, 43, 19,  87, 47, 23,  95, 51, 27,
  103, 59, 31, 115, 67, 35, 123, 75, 39, 131, 83, 47, 143, 91, 51,
  151, 99, 59, 160,108, 64, 175,116, 74, 180,126, 81, 192,135, 91,
  204,143, 93, 213,151,103, 216,159,115, 220,167,126, 223,175,138,
  227,183,149, 230,190,161, 233,198,172, 237,206,184, 240,214,195,
   62, 40, 11,  75, 50, 16,  84, 59, 23,  95, 67, 30, 103, 75, 38,
  110, 83, 47, 123, 95, 55, 137,107, 62, 150,118, 75, 163,129, 84,
  171,137, 92, 180,146,101, 188,154,109, 196,162,117, 204,170,125,
  208,176,133,  37, 20,  4,  47, 24,  4,  57, 28,  6,  68, 33,  4,
   76, 36,  3,  84, 40,  0,  97, 47,  2, 114, 54,  0, 125, 63,  6,
  141, 75,  9, 155, 83, 17, 162, 95, 21, 169,103, 26, 180,113, 32,
  188,124, 20, 204,136, 24, 220,148, 28, 236,160, 23, 244,172, 47,
  252,187, 57, 252,194, 70, 251,201, 83, 251,208, 97, 251,214,110,
  251,221,123, 250,228,136, 157, 51,  4, 170, 65,  2, 185, 86,  4,
  213,118,  4, 236,164,  3, 248,190,  3, 255,216, 43, 255,255,  0,
   67,  0,  0,  79,  0,  0,  91,  0,  0, 103,  0,  0, 115,  0,  0,
  127,  0,  0, 139,  0,  0, 155,  0,  0, 167,  0,  0, 179,  0,  0,
  191,  0,  0, 203,  0,  0, 215,  0,  0, 227,  0,  0, 239,  0,  0,
  255,  0,  0, 255, 52, 52, 255, 74, 74, 255, 95, 95, 255,123,123,
  255,155,155, 255,179,179, 255,201,201, 255,215,215,  60, 12, 88,
   80,  8,108, 104,  8,128, 128,  0,144, 152,  0,176, 184,  0,224,
  216, 44,252, 224,120,240,  37,  6,129,  60, 33,147,  82, 61,165,
  105, 88,183, 128,116,201, 151,143,219, 173,171,237, 196,198,255,
    2,  4, 41,   2,  5, 49,   6,  8, 57,   2,  5, 65,   2,  5, 79,
    0,  4, 88,   0,  4, 96,   0,  4,104,   2,  5,121,   2,  5,137,
    6,  9,159,  12, 16,184,  32, 40,200,  56, 60,220,  80, 80,253,
   80,108,252,  80,136,252,  80,164,252,  80,196,252,  72,220,252,
   80,236,252,  84,252,252, 152,252,252, 188,252,244,  11, 23,  7,
   19, 35, 11,  23, 51, 15,  31, 67, 23,  39, 83, 27,  47, 99, 35,
   55,115, 43,  63,131, 47,  67,147, 55,  75,159, 63,  83,175, 71,
   91,191, 79,  95,207, 87, 103,223, 95, 111,239,103, 119,255,111,
   23, 31, 23,  27, 35, 27,  31, 43, 31,  35, 51, 35,  43, 55, 43,
   47, 63, 47,  51, 71, 51,  59, 75, 55,  63, 83, 59,  67, 91, 67,
   75, 95, 71,  79,103, 75,  87,111, 79,  91,115, 83,  95,123, 87,
  103,131, 95, 255,223,  0, 255,191,  0, 255,159,  0, 255,127,  0,
  255, 95,  0, 255, 63,  0, 244, 14,  3,  55,  0,  0,  47,  0,  0,
   39,  0,  0,  23,  0,  0,  15, 15, 15,  11, 11, 11,   7,  7,  7,
  255,255,255
}


----------------------------------------------------------------

HERETIC_MATERIALS =
{
  -- special materials --
  _ERROR = { t="WOODWL",  f="FLOOR10" },
  _SKY   = { t="MOSAIC1", f="F_SKY1"  },

  -- textures --

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
  CHAINMAN = { t="CHAINMAN", f="FLAT520" },
  CHAINSD  = { t="CHAINSD",  f="FLAT520" },
  CSTLMOSS = { t="CSTLMOSS", f="FLOOR03" },
  CSTLRCK  = { t="CSTLRCK",  f="FLOOR03" },
  CTYSTCI1 = { t="CTYSTCI1", f="FLOOR11" },
  CTYSTCI2 = { t="CTYSTCI2", f="FLOOR11" },
  CTYSTCI4 = { t="CTYSTCI4", f="FLOOR11" },
  CTYSTUC1 = { t="CTYSTUC1", f="FLOOR11" }, -- poor match
  CTYSTUC2 = { t="CTYSTUC2", f="FLOOR11" }, -- poor match
  CTYSTUC3 = { t="CTYSTUC3", f="FLOOR11" }, -- poor match
  CTYSTUC4 = { t="CTYSTUC4", f="FLOOR11" }, -- poor match
  CTYSTUC5 = { t="CTYSTUC5", f="FLOOR11" }, -- poor match
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
  GRSKULL3 = { t="GRSKULL3", f="FLAT521" },
  GRSTNPB  = { t="GRSTNPB",  f="FLAT520" },
  GRSTNPBV = { t="GRSTNPBV", f="FLAT520" },
  GRSTNPBW = { t="GRSTNPBW", f="FLAT520" },
  HORSES1  = { t="HORSES1",  f="FLAT520" },
  LAVA1    = { t="LAVA1",    f="FLTLAVA1" },
  LAVAFL1  = { t="LAVAFL1",  f="FLATHUH1" },
  LOOSERCK = { t="LOOSERCK", f="FLOOR04" },  -- poor match
  METL1    = { t="METL1",    f="FLOOR29" },
  METL2    = { t="METL2",    f="FLOOR28" },
  MOSAIC1  = { t="MOSAIC1",  f="FLAT502" },
  MOSAIC2  = { t="MOSAIC2",  f="FLAT502" },
  MOSAIC3  = { t="MOSAIC3",  f="FLAT502" },
  MOSAIC4  = { t="MOSAIC4",  f="FLAT502" },
  MOSAIC5  = { t="MOSAIC5",  f="FLAT502" },
  MOSSRCK1 = { t="MOSSRCK1", f="FLOOR05" },
  ORNGRAY  = { t="ORNGRAY",  f="FLAT504" },

  RCKSNMUD = { t="RCKSNMUD", f="FLOOR01" },  -- poor match
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
  SQPEB2   = { t="SQPEB2",   f="FLOOR27" },  -- poor match
  STNGLS1  = { t="STNGLS1",  f="FLOOR30" },  -- poor match
  STNGLS2  = { t="STNGLS2",  f="FLOOR30" },  -- poor match
  STNGLS3  = { t="STNGLS3",  f="FLOOR30" },  -- poor match
  SW1OFF   = { t="SW1OFF",   f="FLOOR28" },
  SW1ON    = { t="SW1ON",    f="FLOOR28" },
  TMBSTON1 = { t="TMBSTON1", f="FLAT521" },
  TMBSTON2 = { t="TMBSTON2", f="FLAT521" },
  TRISTON1 = { t="TRISTON1", f="FLOOR00" },
  TRISTON2 = { t="TRISTON2", f="FLOOR17" },
  WATRWAL1 = { t="WATRWAL1", f="FLTFLWW1" },
  WOODWL   = { t="WOODWL",   f="FLOOR10" },

--- logos???
--GRSKULL2

  -- flats --

  FLAT500  = { t="SQPEB1",   f="FLAT500"  },
  FLAT502  = { t="BLUEFRAG", f="FLAT502"  },
  FLAT503  = { t="SQPEB1",   f="FLAT503"  },
  FLAT504  = { t="SQPEB1",   f="FLAT504"  },
  FLAT506  = { t="ROOTWALL", f="FLAT506"  },
  FLAT507  = { t="DOORWOOD", f="FLAT507"  },
  FLAT508  = { t="DOORWOOD", f="FLAT508"  },
  FLAT509  = { t="LOOSERCK", f="FLAT509"  },  -- poor match
  FLAT510  = { t="BRWNRCKS", f="FLAT510"  },  -- poor match
  FLAT512  = { t="GRNBLOK1", f="FLAT512"  },
  FLAT513  = { t="GRNBLOK1", f="FLAT513"  },
  FLAT516  = { t="LOOSERCK", f="FLAT516"  },  -- poor match
  FLAT517  = { t="BLUEFRAG", f="FLAT517"  },  -- poor match
  FLAT520  = { t="CSTLRCK",  f="FLAT520"  },
  FLAT521  = { t="SQPEB1",   f="FLAT521"  },
  FLAT522  = { t="SNDCHNKS", f="FLAT522"  },
  FLAT523  = { t="GRSTNPB",  f="FLAT523"  },  -- poor match
  FLATHUH1 = { t="LAVAFL1",  f="FLATHUH1" },

  FLOOR00  = { t="TRISTON1", f="FLOOR00"  },
  FLOOR01  = { t="LOOSERCK", f="FLOOR01"  },  -- poor match
  FLOOR03  = { t="CSTLRCK",  f="FLOOR03"  },
  FLOOR04  = { t="CSTLRCK",  f="FLOOR04"  },
  FLOOR05  = { t="MOSSROCK", f="FLOOR05"  },
  FLOOR06  = { t="SANDSQ2",  f="FLOOR06"  },
  FLOOR07  = { t="MOSAIC1",  f="FLOOR07"  },  -- poor match
  FLOOR08  = { t="CHAINSD",  f="FLOOR08"  },
  FLOOR09  = { t="REDWALL",  f="FLOOR09"  },
  FLOOR10  = { t="WOODWL",   f="FLOOR10"  },
  FLOOR11  = { t="WOODWL",   f="FLOOR11"  },
  FLOOR12  = { t="WOODWL",   f="FLOOR12"  },
  FLOOR16  = { t="BLUEFRAG", f="FLOOR16"  },
  FLOOR17  = { t="BRWNRCKS", f="FLOOR17"  },
  FLOOR18  = { t="GRNBLOK1", f="FLOOR18"  },
  FLOOR19  = { t="GRNBLOK1", f="FLOOR19"  },
  FLOOR20  = { t="SQPEB2",   f="FLOOR20"  },
  FLOOR21  = { t="CHAINSD",  f="FLOOR21"  },
  FLOOR22  = { t="CHAINSD",  f="FLOOR22"  },
  FLOOR23  = { t="CHAINSD",  f="FLOOR23"  },
  FLOOR24  = { t="CHAINSD",  f="FLOOR24"  },
  FLOOR25  = { t="SPINE2",   f="FLOOR25"  },
  FLOOR26  = { t="CHAINSD",  f="FLOOR26"  },
  FLOOR27  = { t="SANDSQ2",  f="FLOOR27"  },
  FLOOR28  = { t="METL2",    f="FLOOR28"  },
  FLOOR29  = { t="METL1",    f="FLOOR29"  },
  FLOOR30  = { t="METL1",    f="FLOOR30"  },

  FLTFLWW1 = { t="WATRWAL1", f="FLTFLWW1" },
  FLTLAVA1 = { t="LAVA1",    f="FLTLAVA1" },  -- poor match
  FLTSLUD1 = { t="LAVA1",    f="FLTSLUD1" },  -- poor match
  FLTTELE1 = { t="CHAINSD",  f="FLTTELE1" },
  FLTWAWA1 = { t="WATRWAL1", f="FLTWAWA1" },  -- poor match
}

HERETIC_RAILS =
{
  wdgate = { wall="WDGAT64", w=64, h=64  },

  --!!! TODO
--GATMETL
--GATMETL2
--GATMETL3
--GATMETL4
--GATMETL5
--WEB1_B
--WEB1_F
--WEB2_B
--WEB2_F
--WEB3_M
}

HERETIC_SANITY_MAP =
{
  -- FIXME
}


----------------------------------------------------------------

HERETIC_COMBOS =
{
  ---- INDOOR ------------

  GOLD =
  {
    theme_probs = { CITY=20, EGYPT=20 },
    mat_pri = 6,

    wall  = "SANDSQ2",
    floor = "FLOOR06",
    ceil  = "FLOOR11",

--  void = "SNDBLCKS",
    pillar = "SNDCHNKS",

    scenery = "wall_torch",

    wall_fabs = { wall_pic_GLASS1=30, wall_pic_GLASS2=15, other=10 },
  },

  BLOCK =
  {
    theme_probs = { CITY=20 },
    mat_pri = 7,

    wall  = "GRSTNPB",
    floor = "FLOOR03",
    ceil  = "FLOOR03",

    void = "GRSTNPBW",
    pillar = "WOODWL",

    scenery = "barrel",

  },

  MOSSY =
  {
    theme_probs = { CITY=20, DOME=20 },
    mat_pri = 2,

    wall  = "MOSSRCK1",
    floor = "FLOOR00",
    ceil  = "FLOOR04",

    pillar = "SKULLSB1", -- SPINE1

    scenery = "chandelier",

  },

  WOOD =
  {
    theme_probs = { CITY=20, EGYPT=20 },
    mat_pri = 2,

    wall  = "WOODWL",
    floor = "FLOOR10",
    ceil  = "FLOOR12",

--  void = "CTYSTUC3",

    scenery = "hang_skull_1",

  },

  HUT =
  {
    theme_probs = { CITY=20, DOME=20 },
    mat_pri = 1,
    
    wall  = "CTYSTUC3",
    floor = "FLOOR10",
    ceil  = "FLOOR11",

--  void = "CTYSTUC4",

    scenery = "barrel",

  },

  DISCO1 = 
  {
    theme_probs = { EGYPT=20 },
    mat_pri = 1,
    
    wall  = "SPINE2",
    floor = "FLAT522",
    ceil  = "FLOOR06",
    step  = "SNDBLCKS",

--  void = "CTYSTUC4",

  },
 
  --- Grey-walls, pink/brown floors 
  DISCO2 = 
  {
    theme_probs = { DOME=20 },
    mat_pri = 1,
    
    wall  = "SQPEB1",
    floor = "FLAT522",
    ceil  = "FLOOR06",
    step  = "SPINE2",

--  void = "CTYSTUC4",

  },
  
  PYRAMID =
  {
    theme_probs = { EGYPT=20 },
    mat_pri = 1,
    
    wall  = "SNDPLAIN",
    floor = "FLOOR27",
    ceil  = "FLOOR10",
    step  = "SPINE2",

--  void = "CTYSTUC4",

  },

  PHAROAH =
  {
    theme_probs = { EGYPT=15 },
    mat_pri = 1,
    
    wall  = "TRISTON2",
    floor = "FLAT522",
    ceil  = "FLOOR20",
    step  = "SQPEB2",

--  void = "CTYSTUC4",

  },

  PARLOR =
  {
    theme_probs = { EGYPT=15 },
    mat_pri = 1,
    
    wall  = "SQPEB2",
    floor = "FLOOR06",
    ceil  = "FLOOR06",
    step  = "SQPEB2",

--  void = "CTYSTUC4",

    scenery = "wall_torch",
  },

  SBLOCK =
  {
    theme_probs = { EGYPT=20 },
    mat_pri = 1,
    
    wall  = "SNDBLCKS",
    floor = "FLOOR27",
    ceil  = "FLOOR10",
    step  = "SPINE2",

--  void = "CTYSTUC4",

  },


  CAVE1 = 
  {
    theme_probs = { CAVE=20 },
    mat_pri = 1,
    wall = "LOOSERCK",
    floor = "FLAT516",
    ceil = "FLOOR01",

    scenery = "stal_big_C",
 
  }, 

  CAVE2 = 
  {
    theme_probs = { CAVE=20 },
    mat_pri = 1,
    wall = "LAVA1",
    floor = "FLAT516",
    ceil = "FLAT506",

    scenery = "stal_small_C",
 
  }, 

  CAVE3 =  -- Muddy walls, but one of the few outdoor textures
  {
    theme_probs = { CAVE=20, EGYPT=10 },
    mat_pri = 1,
    wall = "BRWNRCKS",
    floor = "FLOOR01",
    ceil = "FLAT516",

    scenery = "stal_small_C",
 
  }, 

  PURPLE =
  {
    theme_probs = { GARISH=20 },
    mat_pri = 1,

    wall  = "BLUEFRAG",
    floor = "FLOOR07",
    ceil  = "FLOOR07",

--  void = "CTYSTCI4",

  },

  BLUE =
  {
    theme_probs = { GARISH=20 },
    mat_pri = 1,

    wall  = "MOSAIC1",
    floor = "FLAT502",
    ceil  = "FLOOR16",

--  void = "CTYSTCI4",

  },

--- The greens don't look that great in Heretic
  GREEN =
  {
    theme_probs = { UNUSED=20 },
    mat_pri = 1,

    wall  = "GRNBLOK1",
    floor = "FLAT513",
    ceil  = "FLOOR18",

--  void = "CTYSTCI4",

  },

  ICE =
  {
    theme_probs = { GARISH=20 },
    mat_pri = 1,

    wall  = "STNGLS1",
    floor = "FLAT502",
    ceil  = "FLAT517",

--  void = "CTYSTCI4",

  },

  ROOT =
  {
    theme_probs = { CAVE=15 },
    mat_pri = 1,

    wall  = "ROOTWALL",
    floor = "FLAT506",
    ceil  = "FLAT506",

--  void = "CTYSTCI4",

  },

  ---- OUTDOOR ------------

  CAVEO1 = 
  {
    theme_probs = { CAVE=20 },
    mat_pri = 2,
    outdoor = true,
    wall = "LOOSERCK",
    floor = "FLAT516",
    ceil = "FLOOR01",

    scenery = "stal_big_F",
 
  }, 

  CAVEO2 = 
  {
    theme_probs = { CAVE=20 },
    mat_pri = 2,
    outdoor = true,
    wall = "LAVA1",
    floor = "FLAT516",
    ceil = "FLAT506",

    scenery = "stal_small_F",
 
  }, 

  CAVEMUD = 
  {
    theme_probs = { CAVE=15 },
    mat_pri = 2,
    outdoor = true,
    wall = "RCKSNMUD",
    floor = "FLAT510",
    ceil = "FLAT510",

    scenery = "stal_small_F",
 
  }, 


  --- Looks obnoxious outdoors; disabled
  ROOTO =
  {
    theme_probs = { UNUSED=15 },
    mat_pri = 2,
    outdoor = true,

    wall  = "ROOTWALL",
    floor = "FLAT506",
    ceil  = "FLAT506",

--  void = "CTYSTCI4",

  },


  ODISCO1 = 
  {
    theme_probs = { EGYPT=20 },
    mat_pri = 1,
    outdoor = true,
    
    wall  = "SPINE2",
    floor = "FLAT522",
    ceil  = "FLOOR06",
    step  = "SNDBLCKS",

--  void = "CTYSTUC4",

  },

  
  ODISCO2 = 
  {
    theme_probs = { DOME=20 },
    mat_pri = 1,
    outdoor = true,
    
    wall  = "SQPEB1",
    floor = "FLAT522",
    ceil  = "FLOOR06",
    step  = "SPINE2",

--  void = "CTYSTUC4",

  },

  PYRAMIDO =
  {
    theme_probs = { EGYPT=20 },
    mat_pri = 1,
    outdoor = true,
    
    wall  = "SNDPLAIN",
    floor = "FLOOR27",
    ceil  = "FLOOR27",
    step  = "SPINE2",

--  void = "CTYSTUC4",

  },

  PHAROAHO =
  {
    theme_probs = { EGYPT=15 },
    mat_pri = 1,
    outdoor = true,
    
    wall  = "TRISTON2",
    floor = "FLAT521",
    ceil  = "FLAT503",
    step  = "SQPEB2",

--  void = "CTYSTUC4",

  },
  
  WATER =
  {
    theme_probs = { GARISH=20 },
    outdoor = true,
    mat_pri = 1,

    wall  = "WATRWAL1",
    floor = "FLTWAWA1",
    ceil  = "FLTWAWA1",

--  void = "CTYSTCI4",

    liquid_prob = 0,
  },

  PURPLEO =
  {
    theme_probs = { GARISH=20 },
    outdoor = true,
    mat_pri = 1,

    wall  = "REDWALL",
    floor = "FLOOR07",
    ceil  = "FLOOR07",

--  void = "CTYSTCI4",

  },

  GREENO =
  {
    theme_probs = { UNUSED=20 },
    outdoor = true,
    mat_pri = 1,

    wall  = "GRNBLOK1",
    floor = "FLOOR18",
    ceil  = "FLOOR18",

--  void = "CTYSTCI4",

  },

  STONY =
  {
    theme_probs = { CITY=20 },
    outdoor = true,
    mat_pri = 3,

    wall  = "GRSTNPB",
    floor = "FLOOR00",
    ceil  = "FLOOR00",

--  void = "GRSTNPBV",
    scenery = "serpent_torch",
  },

  MUDDY =
  {
    theme_probs = { CITY=20, DOME=20 },
    outdoor = true,
    mat_pri = 3,

    wall  = "CSTLRCK",
    floor = "FLOOR17",
    ceil  = "FLOOR17",

--  void = "SQPEB1",
    pillar = "SPINE1",

    scenery = "fire_brazier",

  },
  
  SANDZ =
  {
    theme_probs = { EGYPT=20 },
    outdoor = true,
    mat_pri = 1,

    wall  = "SNDBLCKS",
    floor = "FLOOR27",
    ceil  = "FLOOR27",

--  void = "CTYSTCI4",

    liquid_prob = 0,
  },

  SANDY =
  {
    theme_probs = { CITY=20, DOME=20 },
    outdoor = true,
    mat_pri = 2,
    
    wall  = "CTYSTUC2",
    floor = "FLOOR27",
    ceil  = "FLOOR27",

--  void = "CTYSTUC3",
    pillar = "SPINE2",

    scenery = "small_pillar",
  },
  
}


HERETIC_EXITS =
{
  METAL =
  {
    mat_pri = 9,

    wall  = "METL2",
    floor = "FLOOR03",
    ceil  = "FLOOR19",

    switch =
    {
      prefab="SWITCH_NICHE_TINY_DEEP",
      add_mode="wall",
      skin =
      {
        switch_w="SW2OFF", wall="METL2",
--      switch_f="FLOOR28",

        switch_h=32, x_offset=16, y_offset=48,
        kind=11, tag=0,
      }
    },
  },
  BLOODY = -- name hardcoded in planner.lua for secret exit
  {
    secret_exit = true,
    mat_pri = 9,

    wall  = "METL2",
    floor = "FLOOR03",
    ceil  = "FLOOR19",

    switch =
    {
      prefab="SWITCH_NICHE_TINY_DEEP",
      add_mode="wall",
      skin =
      {
        switch_w="SW1OFF", wall="METL2",
--      switch_f="FLOOR28",

        switch_h=32, x_offset=16, y_offset=48,
        kind=51, tag=0,
      }
    },
  },
}

HERETIC_HALLWAYS =
{
 
  -- Hall with set stone walls 
  RCKHALL = {
        mat_pri = 0,
	theme_probs = { CITY=20, DOME=20 },
    	wall = "GRSTNPB",
	void = "GRSTNPB",
    	step  = "GRSTNPB",
	pillar = "WOODWL",
	
    floor = "FLOOR03",
    ceil  = "FLOOR03",
	
  },

  -- Hall with natural stone walls
  STHALL = {
        mat_pri = 0,
	theme_probs = { CITY=20, CAVE=20 },
    	wall = "LOOSERCK",
	void = "LOOSERCK",
    	step  = "GRSTNPB",
	pillar = "GRSTNPB",
	
    floor = "FLOOR00",
    ceil  = "FLOOR00",
	
  },

  -- Hall with roots on the walls
  RTHALL = {
        mat_pri = 0,
	theme_probs = { CAVE=20 },
    	wall = "ROOTWALL",
	void = "ROOTWALL",
    	step  = "ROOTWALL",
	pillar = "ROOTWALL",
	
    floor = "FLAT506",
    ceil  = "FLAT506",
	
  },

  -- Hall with sandy walls
  SDHALL = {
        mat_pri = 0,
	theme_probs = { EGYPT=20 },
    	wall = "SNDPLAIN",
	void = "SNDPLAIN",
    	step  = "SPINE2",
	pillar = "SPINE2",
	
    floor = "FLOOR27",
    ceil  = "FLOOR10",
	
  },

  -- Hall with wooden walls
  WDHALL = {
        mat_pri = 0,
	theme_probs = { CITY=20, EGYPT=20 },
    	wall = "SQPEB2",
	void = "SQPEB2",
    	step  = "SQPEB2",
	pillar = "SQPEB2",
	
    floor = "FLOOR06",
    ceil  = "FLOOR06",
	
  },

  -- Garish blue watery hall
  WHALL = {
        mat_pri = 0,
	theme_probs = { GARISH=20, DOME=20 },
    	wall = "MOSAIC1",
	void = "MOSAIC1",
    	step  = "WATRWAL1",
	pillar = "WATRWAL1",
	
    floor = "FLTWAWA1",
    ceil  = "FLAT502",
	
  }
}




--- PEDESTALS --------------

HERETIC_PEDESTALS =
{
  PLAYER =
  {
    wall  = "CTYSTCI4", void = "CTYSTCI4",
    floor = "FLOOR11",   ceil = "FLOOR11",
    h = 8,
  },

  QUEST = -- FIXME
  {
    wall  = "CTYSTCI4", void = "CTYSTCI4",
    floor = "FLOOR11",   ceil = "FLOOR11",
    h = 8,
  },

  WEAPON = -- FIXME
  {
    wall  = "CTYSTCI4", void = "CTYSTCI4",
    floor = "FLOOR11",  ceil = "FLOOR11",
    h = 8,
  },
}

---- OVERHANGS ------------

HERETIC_OVERHANGS =
{
  WOOD =
  {
    ceil = "FLOOR10",
    upper = "CTYSTUC3",
    thin = "WOODWL",
  },
}

---- MISC STUFF ------------

HERETIC_LIQUIDS =
{
  water  = { floor="FLTFLWW1", wall="WATRWAL1" },
  lava   = { floor="FLATHUH1", wall="LAVAFL1", sec_kind=16 },
  magma  = { floor="FLTLAVA1", wall="LAVA1",   sec_kind=5 },
  sludge = { floor="FLTSLUD1", wall="LAVA1",   sec_kind=7 },
}

HERETIC_SWITCHES =
{
  sw_demon =
  {
    switch =
    {
      prefab = "SWITCH_NICHE_TINY",
      add_mode = "island",
      skin =
      {
        wall="GRSKULL1",
        switch_w="SW1OFF", switch_h=32,
        x_offset=16, y_offset=48, kind=103,
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "DOOR",
      skin =
      {
        door_w="DMNMSK", door_c="FLOOR10",
        track_w="METL2",
        door_h=128,
        door_kind=0, tag=0,
      }
    },
  },

  sw_celtic =
  {
    switch =
    {
      prefab="SWITCH_NICHE_TINY",
      add_mode = "island",
      skin =
      {
        wall="CELTIC",
        switch_w="SW1OFF", switch_h=32,
        x_offset=16, y_offset=48, kind=103,
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "DOOR",
      skin =
      {
        door_w="CELTIC", door_c="FLAT522",
        track_w="METL2",
        door_h=128,
        door_kind=0, tag=0,
      }
    },
  },

  sw_green =
  {
    switch =
    {
      prefab = "SWITCH_NICHE_TINY",
      add_mode = "island",
      skin =
      {
        wall="GRNBLOK1",
        switch_w="SW1OFF", switch_h=32,
        x_offset=16, y_offset=48, kind=103,
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "DOOR",
      skin =
      {
        door_w="GRNBLOK4", door_c="FLOOR18",
        track_w="METL2",
        door_h=128,
        door_kind=0, tag=0,
      }
    },
  },
}

HERETIC_DOORS =
{
  d_demon = { prefab="DOOR", w=128, h=128,

               skin =
               {
                 door_w="DMNMSK", door_c="FLOOR10",
                 track_w="METL2",
                 door_h=128,

---              lite_w="LITE5", step_w="STEP1",
---              frame_f="FLAT1", frame_c="TLITE6_6",
               }
             },
  
 d_wood   = { wall="DOORWOOD", w=64,  h=128, ceil="FLOOR10" },
  
--  d_stone  = { wall="DOORSTON", w=64,  h=128 },
}

HERETIC_KEY_DOORS =
{
  k_blue =
  {
    w=128, h=128,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="DOORSTON", door_c="FLOOR28",
      track_w="METL2",
      frame_f="FLOOR04",
      door_h=128, 
      door_kind=32, tag=0,  -- kind_rep=26
    },

    thing = "blue_statue",
  },

  k_green =
  {
    w=128, h=128,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="DOORSTON", door_c="FLOOR28",
      track_w="METL2",
      frame_f="FLOOR04",
      door_h=128, 
      door_kind=33, tag=0, -- kind_rep=28,
    },

    thing = "green_statue",
  },

  k_yellow =
  {
    w=128, h=128,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="DOORSTON", door_c="FLOOR28",
      track_w="METL2",
      frame_f="FLOOR04",
      door_h=128, 
      door_kind=34, tag=0, -- kind_rep=27,
    },

    thing = "yellow_statue",
  },
}

HERETIC_LIFTS =
{
  slow = { kind=62,  walk=88 },
}

HERETIC_DOOR_PREFABS =
{
  d_wood =
  {
    w=128, h=128, prefab="DOOR",

    skin =
    {
      door_w="DOORWOOD", door_c="FLOOR10",
      track="METL2", frame_f="FLOOR04",
      step_w="CHAINSD", key_w="CHAINSD",
      door_h=128,
      line_kind=1, tag=0,
    },

  theme_probs = { CITY=20 },
  },
}

HERETIC_WALL_PREFABS =
{
  wall_pic_GLASS1 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 160,
    skin = { pic_w="STNGLS1", pic_h=128 },
  },

  wall_pic_GLASS2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 160,
    skin = { pic_w="STNGLS2", pic_h=128 },
  },
}

HERETIC_MISC_PREFABS =
{
  pedestal_PLAYER =
  {
    prefab = "PEDESTAL",
    skin = { wall="TMBSTON2", floor="FLOOR26", ped_h=8 },
  },

  pedestal_ITEM =
  {
    prefab = "PEDESTAL",
    skin = { wall="SAINT1", floor="FLAT500", ped_h=12 },
  },

  image_1 =
  {
    prefab = "CRATE",
    add_mode = "island",
    skin = { crate_h=64, crate_w="CHAINSD", crate_f="FLOOR27" },
  },

  image_2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    add_mode = "wall",
    min_height = 144,
    skin = { pic_w="GRSKULL2", pic_h=128 },
  },

  exit_DOOR =
  {
    w=64, h=96, prefab = "DOOR_NARROW",

    skin =
    {
      door_w="DOOREXIT",
      door_h=96,
      door_kind=1, tag=0,
    },
  },

  secret_DOOR =
  {
    w=128, h=128, prefab = "DOOR",

    skin =
    {
      track_w="METL2",
      door_h=128, door_kind=31, tag=0
    },
  },
}


HERETIC_IMAGES =
{
  { wall = "GRSKULL2", w=128, h=128, glow=true },
  { wall = "GRSKULL1", w=64,  h=64,  floor="FLOOR27" }
}

HERETIC_LIGHTS =
{
  round = { floor="FLOOR26",  side="ORNGRAY" },
}

HERETIC_WALL_LIGHTS =
{
  redwall = { wall="REDWALL", w=32 },
}

HERETIC_PICS =
{
  skull3 = { wall="GRSKULL3", w=128, h=128 },
  glass1 = { wall="STNGLS1",  w=128, h=128 },
}

---- QUEST STUFF ----------------


HERETIC_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    room_heights = { [96]=50, [128]=50 },
    door_probs   = { out_diff=75, combo_diff=50, normal=5 },
    window_probs = { out_diff=1, combo_diff=1, normal=1 },
    space_range  = { 20, 65 },
  },
 
  SCENIC =
  {
  },

  -- TODO: check in-game level names for ideas
}

HERETIC_THEMES =
{
  TECH =
  {
    building =
    {
      GOLD=50,
      WOOD=50,
      MOSSY=50,
      BLOCK=50,
      CAVE1=20,
      CAVE2=20,
      HUT=20,
      DISCO2=20,
      PHAROAH=20,
    },

    floors =
    {
      FLOOR00=50,
      FLOOR01=50,
      FLOOR02=50,
      FLOOR03=50,
      FLOOR04=50,
      FLOOR05=50,
    },

    ceilings =
    {
      FLOOR16=50,
      FLOOR17=50,
      FLOOR18=50,
      FLOOR19=50,
    },

    corners =
    {
      METL1=10,
    },

    ceil_lights =
    {
      FLOOR11=50,
    },

    ground =
    {
      CAVEO1=20,
      CAVEO2=20,
      CAVEMUD=20,
      ODISCO1=20,
      ODISCO2=20,
      SANDY=20,
      SANDZ=20,
      MUDDY=20,
      STONY=20,
    },

    hallway =
    {
      walls =
      {
        BROWN1=33, BROWNGRN=50, GRAY1=50, STARBR2=33
      },

      floors =
      {
        FLAT4=50, CEIL5_1=50, FLOOR1_1=50, FLOOR3_3=50
      },

      ceils =
      {
        FLAT4=50, CEIL5_1=50, CEIL3_5=50, CEIL3_3=50
      },
    },

    exit =
    {
      walls =
      {
        METAL2=50,   STARTAN2=50, STARG1=50,
        TEKWALL4=50, PIPEWAL2=50,
        TEKGREN1=50, SPACEW2=50,  STARBR2=50
      },

      floors =
      {
        FLOOR0_3=50, FLOOR5_2=50
      },

      ceils =
      {
        TLITE6_6=50, TLITE6_5=50, FLAT17=50,
        FLOOR1_7=50, GRNLITE1=50, CEIL4_3=50
      },
    },

    room_types =
    {
      -- FIXME
    },

    scenery =
    {
      -- FIXME
    },

    monster_prefs =
    {
    },
  }, -- TECH



--[[ FIXME: good old stuff

  --- City (E1 Castle) is both indoors and outdoors
  CITY =
  {
    room_probs=
    {
      PLAIN=50,
    },
    has_outdoors = true,
  },
  --- Cave (used in Hell) is both outdoors and indoors
  CAVE =
  {
    room_probs=
    {
      PLAIN=50,
    },
    has_outdoors = true,
  },
  --- Dome is a variation on City used in E3
  DOME =
  {
    room_probs=
    {
      PLAIN=50,
    },
    has_outdoors = true,
  },
  --- Egypt is a sandy-looking theme used in E4
  EGYPT =
  {
    room_probs=
    {
      PLAIN=50,
    },
    has_outdoors = true,
  },
  --- Garish is a surrealistic very garish theme of blue and some red;
  --- used in E5
  GARISH =
  {
    room_probs=
    {
      PLAIN=50,
    },
    has_outdoors = true,
  },

--]]
}

HERETIC_QUEST_LEN_PROBS =
{
  ----------  2   3   4   5   6   7   8  9  10  -------

  key    = {  0, 25, 50, 90, 65, 30, 10, 2 },
  exit   = {  0, 25, 50, 90, 65, 30, 10, 2 },

  switch = {  0, 50, 90, 50, 25, 5, 1 },

  weapon = { 25, 90, 50, 10, 2 },
  item   = { 15, 70, 70, 15, 2 },
}


------------------------------------------------------------

HERETIC_MONSTERS =
{
  gargoyle =
  {
    prob=30,
    health=20, damage=5, attack="melee",
    float=true,
  },

  fire_garg =
  {
    prob=10,
    health=80, damage=8, attack="missile",
    float=true,
  },

  mummy =
  {
    prob=60,
    health=80, damage=8, attack="melee",
    give={ {ammo="crystal",count=1} },
  },

  mummy_inv =
  {
    replaces="mummy", replace_prob=15,
    health=80, damage=8, attack="melee",
    give={ {ammo="crystal",count=1} },
    invis=true,
  },

  sabreclaw =  -- MT_CLINK
  {
    prob=25,
    health=150, damage=12, attack="melee",
    give={ {ammo="rune",count=6} },
  },

  knight =
  {
    prob=70,
    health=200, damage=12, attack="missile",
    give={ {ammo="arrow",count=1.6} },
  },

  knight_inv =
  {
    replaces="knight", replace_prob=15,
    health=200, damage=14, attack="missile",
    give={ {ammo="arrow",count=1.6} },
    invis=true,
  },

  leader =
  {
    prob=70, guard_prob=11, trap_prob=11,
    health=100, damage=16, attack="missile",
    give={ {ammo="crystal",count=1} },
  },

  leader_inv =
  {
    replaces="leader", replace_prob=15,
    health=100, damage=16, attack="missile",
    give={ {ammo="crystal",count=1} },
    invis=true,
  },

  disciple =  -- MT_WIZARD
  {
    prob=25,
    health=180, damage=20, attack="missile",
    give={ {ammo="claw_orb",count=3} },
    float=true,
  },

  weredragon =  -- MT_BEAST
  {
    prob=30,
    health=220, damage=25, attack="missile",
    give={ {ammo="arrow",count=3} },
  },

  ophidian =  -- MT_SNAKE
  {
    prob=30,
    health=280, damage=25, attack="missile",
    give={ {ammo="flame_orb",count=1.6} },
  },


  ---| HERETIC_BOSSES |---

  -- FIXME: damage values are crap, need 'attack' type

  Ironlich =  -- MT_HEAD
  {
    health=700, damage=60,
    give={ {ammo="claw_orb",count=3} },
    float=true,
  },

  Maulotaur =
  {
    health=3000, damage=80,
    give={ {ammo="flame_orb",count=3},
           {health=10} },  -- occasionally drops an Urn
  },

  D_Sparil =
  {
    health=2000, damage=100,
  },

  -- NOTES
  --
  -- Most monsters who drop an item after death only do so 33%
  -- of the time (randomly).  The give amounts are therefore
  -- just an average.  Some of them also (but rarely) drop
  -- artifacts (egg/tome) -- this is not modelled.
}


HERETIC_WEAPONS =
{
  staff =
  {
    rate=2.5, damage=12, attack="melee",
  },

  wand =
  {
    pref=10,
    rate=3.1, damage=10, attack="hitscan",
    ammo="crystal", per=1,
  },

  gauntlets =
  {
    pref=10, add_prob=5, start_prob=10,
    rate=5.2, damage=8, attack="melee",
  },

  crossbow =
  {
    pref=90, add_prob=10, start_prob=70,
    rate=1.3, damage=20, attack="missile", splash={0,5},
    ammo="arrow", per=1,
    give={ {ammo="arrow",count=10} },
  },

  claw =  -- aka blaster
  {
    pref=60, add_prob=20, start_prob=20,
    rate=2.9, damage=16, attack="missile",
    ammo="claw_orb", per=1,
    give={ {ammo="claw_orb",count=30} },
  },

  hellstaff =  -- aka skullrod
  {
    pref=50, add_prob=20, start_prob=5,
    rate=8.7, damage=12, attack="missile",
    ammo="rune", per=1,
    give={ {ammo="rune",count=50} },
  },

  phoenix =
  {
    pref=50, add_prob=20, start_prob=5,
    rate=1.7, damage=80, attack="missile",
    ammo="flame_orb", per=1,
    give={ {ammo="flame_orb",count=2} },
  },

  firemace =
  {
    pref=35, add_prob=20, start_prob=5,
    rate=8.7, damage=8, attack="missile",
    ammo="mace_orb", per=1,
    give={ {ammo="mace_orb",count=50} },
  },

  -- NOTES:
  --
  -- No information here about weapons when the Tome-Of-Power is
  -- being used (such as different firing rates and ammo usage).
  -- Since that artifact can be used at any time by the player,
  -- OBLIGE cannot properly model it.
  --
  -- The Firemace can be placed in upto 8 different spots, but
  -- only one is spawned (at a spot chosen randomly) when the
  -- level is loaded.
}


HERETIC_PICKUPS =
{
  -- HEALTH --

  h_vial =
  {
    prob=70, cluster={ 1,4 },
    give={ {health=10} },
  },

  h_flask =
  {
    prob=25,
    give={ {health=25} },
  },

  h_urn =
  {
    -- could actually give upto 99 health points, but the player
    -- will usually waste a lot of it (since their health is
    -- limited to 100).
    prob=5,
    give={ {health=70} },
  },


  -- ARMOR --

  shield1 =
  {
    prob=20,
    give={ {health=50} },
  },

  shield2 =
  {
    prob=5,
    give={ {health=100} },
  },


  -- AMMO --

  crystal =
  {
    prob=20, cluster={ 1,4 },
    give={ {ammo="crystal",count=10} },
  },

  geode =
  {
    prob=40,
    give={ {ammo="crystal",count=50} },
  },

  arrow =
  {
    prob=20, cluster={ 1,3 },
    give={ {ammo="arrow",count=5} },
  },

  quiver =
  {
    prob=40,
    give={ {ammo="arrow",count=20} },
  },

  claw_orb1 =
  {
    prob=20, cluster={ 1,3 },
    give={ {ammo="claw_orb",count=10} },
  },

  claw_orb2 =
  {
    prob=40,
    give={ {ammo="claw_orb",count=25} },
  },

  runes1 =
  {
    prob=20, cluster={ 1,4 },
    give={ {ammo="rune",count=20} },
  },

  runes2 =
  {
    prob=40,
    give={ {ammo="rune",count=100} },
  },

  flame_orb1 =
  {
    prob=20, cluster={ 2,5 },
    give={ {ammo="flame_orb",count=1} },
  },

  flame_orb2 =
  {
    prob=40,
    give={ {ammo="flame_orb",count=10} },
  },

  mace_orb1 =
  {
    prob=20, cluster={ 1,4 },
    give={ {ammo="mace_orb",count=20} },
  },

  mace_orb2 =
  {
    prob=40,
    give={ {ammo="mace_orb",count=100} },
  },
}


HERETIC_ITEMS =
{
  p1 = { pickup="torch", prob=2.0 },
}


HERETIC_PLAYER_MODEL =
{
  cleric =
  {
    stats = { health=0, crystal=0, arrow=0, rune=0,
              claw_orb=0, flame_orb=0, mace_orb=0 },
    weapons = { staff=1, wand=1 },
  }
}


------------------------------------------------------------

HERETIC_EPISODES =
{
  episode1 =
  {
    boss = "Ironlich",
    theme = "CITY",
    sky_light = 0.65,
    secret_exits = { "E1M6" },
  },

  episode2 =
  {
    boss = "Maulotaur",
    theme = "CITY",
    sky_light = 0.75,
    secret_exits = { "E2M4" },
  },

  episode3 =
  {
    boss = "D_sparil",
    theme = "CITY",
    sky_light = 0.75,
    secret_exits = { "E3M4" },
  },

  episode4 =
  {
    boss = "Ironlich",
    theme = "CITY",
    sky_light = 0.50,
    secret_exits = { "E4M4" },
  },

  episode5 =
  {
    boss = "Maulotaur",
    theme = "CITY",
    sky_light = 0.65,
    secret_exits = { "E5M3" },
  },
}


------------------------------------------------------------

function Heretic_setup()

  -- FIXME: temp crap
  GAME.door_fabs["silver_lit"] = GAME.door_fabs["d_wood"]
  GAME.materials["NUKAGE1"] = GAME.materials["FLTSLUD1"]
end


function Heretic_get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "full", 5, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  for episode = 1,EP_NUM do
    local ep_info = HERETIC_EPISODES["episode" .. episode]
    assert(ep_info)

    for map = 1,MAP_NUM do
      local LEV =
      {
        name = string.format("E%dM%d", episode, map),

        episode  = episode,
        ep_along = map / MAP_NUM,
        ep_info  = ep_info,

        key_list = { "foo" },
        switch_list = { "foo" },
        bar_list = { "foo" },
      }

      table.insert(GAME.all_levels, LEV)
    end -- for map

  end -- for episode
end


function Heretic_begin_level()
  -- set the description here
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming_grab_one(LEVEL.name_theme)
  end
end


------------------------------------------------------------

OB_THEMES["hc_city"] =
{
  ref = "CITY",
  label = "City",
  for_games = { heretic=1 },
}

OB_THEMES["hc_cave"] =
{
  ref = "CAVE",
  label = "Cave",
  for_games = { heretic=1 },
}

OB_THEMES["hc_dome"] =
{
  ref = "DOME",
  label = "Dome",
  for_games = { heretic=1 },
}

OB_THEMES["hc_egypt"] =
{
  ref = "EGYPT",
  label = "Egypt",
  for_games = { heretic=1 },
}

OB_THEMES["hc_garish"] =
{
  ref = "GARISH",
  label = "Garish",
  for_games = { heretic=1 },
}


UNFINISHED["heretic"] =
{
  label = "Heretic",

  setup_func = Heretic_setup,
  levels_start_func = Heretic_get_levels,
  begin_level_func = Heretic_begin_level,

  param =
  {
    format = "doom",

    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    infighting  =  true,
    prefer_stairs = true,
    noblaze_door = true,

    no_keys = true,  --!!!! FIXME

    custom_flats = true,

    seed_size = 256,

    max_name_length = 28,

    skip_monsters = { 20,30 },

    mon_time_max = 12,

    mon_damage_max  = 200,
    mon_damage_high = 100,
    mon_damage_low  =   1,

    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  tables =
  {
    "player_model", HERETIC_PLAYER_MODEL,
    
    "things", HERETIC_THINGS,
    "monsters", HERETIC_MONSTERS,
    "weapons",  HERETIC_WEAPONS,
    "pickups",  HERETIC_PICKUPS,

    "materials", HERETIC_MATERIALS,
    "rails", HERETIC_RAILS,

    "combos", HERETIC_COMBOS,
    "exits", HERETIC_EXITS,
    "hallways", HERETIC_HALLWAYS,

    "episodes", HERETIC_EPISODES,
    "themes",   HERETIC_THEMES,
    "rooms",    HERETIC_ROOMS,

    "hangs", HERETIC_OVERHANGS,
    "pedestals", HERETIC_PEDESTALS,

    "liquids", HERETIC_LIQUIDS,
    "switches", HERETIC_SWITCHES,
    "doors", HERETIC_DOORS,
    "key_doors", HERETIC_KEY_DOORS,
    "lifts", HERETIC_LIFTS,

    "pics", HERETIC_PICS,
    "images", HERETIC_IMAGES,
    "lights", HERETIC_LIGHTS,
    "wall_lights", HERETIC_WALL_LIGHTS,

    "door_fabs", HERETIC_DOOR_PREFABS,
    "wall_fabs", HERETIC_WALL_PREFABS,
    "misc_fabs", HERETIC_MISC_PREFABS,
  },
}

