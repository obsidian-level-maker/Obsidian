------------------------------------------------------------------------
--  QUAKE MATERIALS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

QUAKE.LIQUIDS =
{
  water  = { mat="L_WATER0", medium="water", light=0, special=0 }
  slime0 = { mat="L_SLIME0", medium="slime", light=0, special=0, damage=99 }
  slime  = { mat="L_SLIME",  medium="slime", light=0, special=0, damage=99 }
  lava1  = { mat="L_LAVA1",  medium="lava",  light=1, special=0, damage=99, fireballs=1 }
}


QUAKE.MATERIALS =
{
  -- special materials --
  _ERROR = { t="metal1_1" }  -- METAL1_1
  _SKY   = { t="sky4" }

  ADOOR01_2  = { t="adoor01_2" }
  ADOOR02_2  = { t="adoor02_2" }
  ADOOR03_2  = { t="adoor03_2" }
  ADOOR03_3  = { t="adoor03_3" }
  ADOOR03_4  = { t="adoor03_4" }
  ADOOR03_5  = { t="adoor03_5" }
  ADOOR03_6  = { t="adoor03_6" }
  ADOOR09_1  = { t="adoor09_1" }
  ADOOR09_2  = { t="adoor09_2" }
  AFLOOR1_3  = { t="afloor1_3" }
  AFLOOR1_4  = { t="afloor1_4" }
  AFLOOR1_8  = { t="afloor1_8" }
  AFLOOR3_1  = { t="afloor3_1" }
  ALTAR1_1   = { t="altar1_1" }
  ALTAR1_3   = { t="altar1_3" }
  ALTAR1_4   = { t="altar1_4" }
  ALTAR1_6   = { t="altar1_6" }
  ALTAR1_7   = { t="altar1_7" }
  ALTAR1_8   = { t="altar1_8" }
  ALTARB_1   = { t="altarb_1" }
  ALTARB_2   = { t="altarb_2" }
  ALTARC_1   = { t="altarc_1" }
  ARCH7      = { t="arch7" }
  ARROW_M    = { t="arrow_m" }
  AZ1_6      = { t="az1_6" }
  AZFLOOR1_1 = { t="azfloor1_1" }
  AZSWITCH3  = { t="azswitch3" }
  AZWALL1_5  = { t="azwall1_5" }
  AZWALL3_1  = { t="azwall3_1" }
  AZWALL3_2  = { t="azwall3_2" }
  BASEBUTN3  = { t="basebutn3" }
  BLACK      = { t="black" }
  BODIESA2_1 = { t="bodiesa2_1" }
  BODIESA2_4 = { t="bodiesa2_4" }
  BODIESA3_1 = { t="bodiesa3_1" }
  BODIESA3_2 = { t="bodiesa3_2" }
  BODIESA3_3 = { t="bodiesa3_3" }
  BRICKA2_1  = { t="bricka2_1" }
  BRICKA2_2  = { t="bricka2_2" }
  BRICKA2_4  = { t="bricka2_4" }
  BRICKA2_6  = { t="bricka2_6" }
  CARCH02    = { t="carch02" }
  CARCH03    = { t="carch03" }
  CARCH04_1  = { t="carch04_1" }
  CARCH04_2  = { t="carch04_2" }
  CEIL1_1    = { t="ceil1_1" }
  CEILING1_3 = { t="ceiling1_3" }
  CEILING4   = { t="ceiling4" }
  CEILING5   = { t="ceiling5" }
  CHURCH1_2  = { t="church1_2" }
  CHURCH7    = { t="church7" }

  CITY1_4    = { t="city1_4" }
  CITY1_7    = { t="city1_7" }
  CITY2_1    = { t="city2_1" }
  CITY2_2    = { t="city2_2" }
  CITY2_3    = { t="city2_3" }
  CITY2_5    = { t="city2_5" }
  CITY2_6    = { t="city2_6" }
  CITY2_7    = { t="city2_7" }
  CITY2_8    = { t="city2_8" }
  CITY3_2    = { t="city3_2" }
  CITY3_4    = { t="city3_4" }
  CITY4_1    = { t="city4_1" }
  CITY4_2    = { t="city4_2" }
  CITY4_5    = { t="city4_5" }
  CITY4_6    = { t="city4_6" }
  CITY4_7    = { t="city4_7" }
  CITY4_8    = { t="city4_8" }
  CITY5_1    = { t="city5_1" }
  CITY5_2    = { t="city5_2" }
  CITY5_3    = { t="city5_3" }
  CITY5_4    = { t="city5_4" }
  CITY5_6    = { t="city5_6" }
  CITY5_7    = { t="city5_7" }
  CITY5_8    = { t="city5_8" }
  CITY6_3    = { t="city6_3" }
  CITY6_4    = { t="city6_4" }
  CITY6_7    = { t="city6_7" }
  CITY6_8    = { t="city6_8" }
  CITY8_2    = { t="city8_2" }
  CITYA1_1   = { t="citya1_1" }
  CLIP       = { t="clip" }
  COLUMN01_3 = { t="column01_3" }
  COLUMN01_4 = { t="column01_4" }
  COLUMN1_2  = { t="column1_2" }
  COLUMN1_4  = { t="column1_4" }
  COLUMN1_5  = { t="column1_5" }
  COMP1_1    = { t="comp1_1" }
  COMP1_2    = { t="comp1_2" }
  COMP1_3    = { t="comp1_3" }
  COMP1_4    = { t="comp1_4" }
  COMP1_5    = { t="comp1_5" }
  COMP1_6    = { t="comp1_6" }
  COMP1_7    = { t="comp1_7" }
  COMP1_8    = { t="comp1_8" }
  COP1_1     = { t="cop1_1" }
  COP1_2     = { t="cop1_2" }
  COP1_3     = { t="cop1_3" }
  COP1_4     = { t="cop1_4" }
  COP1_5     = { t="cop1_5" }
  COP1_6     = { t="cop1_6" }
  COP1_7     = { t="cop1_7" }
  COP1_8     = { t="cop1_8" }
  COP2_1     = { t="cop2_1" }
  COP2_2     = { t="cop2_2" }
  COP2_3     = { t="cop2_3" }
  COP2_4     = { t="cop2_4" }
  COP2_5     = { t="cop2_5" }
  COP2_6     = { t="cop2_6" }
  COP3_1     = { t="cop3_1" }
  COP3_2     = { t="cop3_2" }
  COP3_4     = { t="cop3_4" }
  COP4_3     = { t="cop4_3" }
  COP4_5     = { t="cop4_5" }

  CRATE0_SIDE = { t="crate0_side" }
  CRATE0_TOP  = { t="crate0_top" }
  CRATE1_SIDE = { t="crate1_side" }
  CRATE1_TOP  = { t="crate1_top" }

  DEM4_1     = { t="dem4_1" }
  DEM4_4     = { t="dem4_4" }
  DEM5_3     = { t="dem5_3" }
  DEMC4_4    = { t="demc4_4" }
  DOOR01_2   = { t="door01_2" }
  DOOR02_1   = { t="door02_1" }
  DOOR02_2   = { t="door02_2" }
  DOOR02_3   = { t="door02_3" }
  DOOR02_7   = { t="door02_7" }
  DOOR03_2   = { t="door03_2" }
  DOOR03_3   = { t="door03_3" }
  DOOR03_4   = { t="door03_4" }
  DOOR03_5   = { t="door03_5" }
  DOOR04_1   = { t="door04_1" }
  DOOR04_2   = { t="door04_2" }
  DOOR05_2   = { t="door05_2" }
  DOOR05_3   = { t="door05_3" }
  DOPEBACK   = { t="dopeback" }
  DOPEFISH   = { t="dopefish" }
  DR01_1     = { t="dr01_1" }
  DR01_2     = { t="dr01_2" }
  DR02_1     = { t="dr02_1" }
  DR02_2     = { t="dr02_2" }
  DR03_1     = { t="dr03_1" }
  DR05_2     = { t="dr05_2" }
  DR07_1     = { t="dr07_1" }
  DUNG01_1   = { t="dung01_1" }
  DUNG01_2   = { t="dung01_2" }
  DUNG01_3   = { t="dung01_3" }
  DUNG01_4   = { t="dung01_4" }
  DUNG01_5   = { t="dung01_5" }
  DUNG02_1   = { t="dung02_1" }
  DUNG02_5   = { t="dung02_5" }
  ECOP1_1    = { t="ecop1_1" }
  ECOP1_4    = { t="ecop1_4" }
  ECOP1_6    = { t="ecop1_6" }
  ECOP1_7    = { t="ecop1_7" }
  ECOP1_8    = { t="ecop1_8" }
  EDOOR01_1  = { t="edoor01_1" }
  ELWALL1_1  = { t="elwall1_1" }
  ELWALL2_4  = { t="elwall2_4" }
  EMETAL1_3  = { t="emetal1_3" }
  ENTER01    = { t="enter01" }
  EXIT01     = { t="exit01" }
  EXIT02_2   = { t="exit02_2" }
  EXIT02_3   = { t="exit02_3" }
  FLOOR01_5  = { t="floor01_5" }

  GRAVE01_1  = { t="grave01_1" }
  GRAVE01_3  = { t="grave01_3" }
  GRAVE02_1  = { t="grave02_1" }
  GRAVE02_2  = { t="grave02_2" }
  GRAVE02_3  = { t="grave02_3" }
  GRAVE02_4  = { t="grave02_4" }
  GRAVE02_5  = { t="grave02_5" }
  GRAVE02_6  = { t="grave02_6" }
  GRAVE02_7  = { t="grave02_7" }
  GRAVE03_1  = { t="grave03_1" }
  GRAVE03_2  = { t="grave03_2" }
  GRAVE03_3  = { t="grave03_3" }
  GRAVE03_4  = { t="grave03_4" }
  GRAVE03_5  = { t="grave03_5" }
  GRAVE03_6  = { t="grave03_6" }
  GRAVE03_7  = { t="grave03_7" }
  GROUND1_1  = { t="ground1_1" }
  GROUND1_2  = { t="ground1_2" }
  GROUND1_5  = { t="ground1_5" }
  GROUND1_6  = { t="ground1_6" }
  GROUND1_7  = { t="ground1_7" }
  GROUND1_8  = { t="ground1_8" }
  KEY01_1    = { t="key01_1" }
  KEY01_2    = { t="key01_2" }
  KEY01_3    = { t="key01_3" }
  KEY02_1    = { t="key02_1" }
  KEY02_2    = { t="key02_2" }
  KEY03_1    = { t="key03_1" }
  KEY03_2    = { t="key03_2" }
  KEY03_3    = { t="key03_3" }
  LGMETAL    = { t="lgmetal" }
  LGMETAL2   = { t="lgmetal2" }
  LGMETAL3   = { t="lgmetal3" }
  LGMETAL4   = { t="lgmetal4" }
  LIGHT1_1   = { t="light1_1" }
  LIGHT1_2   = { t="light1_2" }
  LIGHT1_3   = { t="light1_3" }
  LIGHT1_4   = { t="light1_4" }
  LIGHT1_5   = { t="light1_5" }
  LIGHT1_7   = { t="light1_7" }
  LIGHT1_8   = { t="light1_8" }
  LIGHT3_3   = { t="light3_3" }
  LIGHT3_5   = { t="light3_5" }
  LIGHT3_6   = { t="light3_6" }
  LIGHT3_7   = { t="light3_7" }
  LIGHT3_8   = { t="light3_8" }

  M5_3       = { t="m5_3" }
  M5_5       = { t="m5_5" }
  M5_8       = { t="m5_8" }
  MET5_1     = { t="met5_1" }
  MET5_2     = { t="met5_2" }
  MET5_3     = { t="met5_3" }
  METAL1_1   = { t="metal1_1" }
  METAL1_2   = { t="metal1_2" }
  METAL1_3   = { t="metal1_3" }
  METAL1_4   = { t="metal1_4" }
  METAL1_5   = { t="metal1_5" }
  METAL1_6   = { t="metal1_6" }
  METAL1_7   = { t="metal1_7" }
  METAL2_1   = { t="metal2_1" }
  METAL2_2   = { t="metal2_2" }
  METAL2_3   = { t="metal2_3" }
  METAL2_4   = { t="metal2_4" }
  METAL2_5   = { t="metal2_5" }
  METAL2_6   = { t="metal2_6" }
  METAL2_7   = { t="metal2_7" }
  METAL2_8   = { t="metal2_8" }
  METAL3_2   = { t="metal3_2" }
  METAL4_2   = { t="metal4_2" }
  METAL4_3   = { t="metal4_3" }
  METAL4_4   = { t="metal4_4" }
  METAL4_5   = { t="metal4_5" }
  METAL4_6   = { t="metal4_6" }
  METAL4_7   = { t="metal4_7" }
  METAL4_8   = { t="metal4_8" }
  METAL5_1   = { t="metal5_1" }
  METAL5_2   = { t="metal5_2" }
  METAL5_3   = { t="metal5_3" }
  METAL5_4   = { t="metal5_4" }
  METAL5_5   = { t="metal5_5" }
  METAL5_6   = { t="metal5_6" }
  METAL5_8   = { t="metal5_8" }
  METAL6_1   = { t="metal6_1" }
  METAL6_2   = { t="metal6_2" }
  METAL6_3   = { t="metal6_3" }
  METAL6_4   = { t="metal6_4" }
  METALT1_1  = { t="metalt1_1" }
  METALT1_2  = { t="metalt1_2" }
  METALT1_7  = { t="metalt1_7" }
  METALT2_1  = { t="metalt2_1" }
  METALT2_2  = { t="metalt2_2" }
  METALT2_3  = { t="metalt2_3" }
  METALT2_4  = { t="metalt2_4" }
  METALT2_5  = { t="metalt2_5" }
  METALT2_6  = { t="metalt2_6" }
  METALT2_7  = { t="metalt2_7" }
  METALT2_8  = { t="metalt2_8" }
  METFLOR2_1 = { t="metflor2_1" }
  MMETAL1_1  = { t="mmetal1_1" }
  MMETAL1_2  = { t="mmetal1_2" }
  MMETAL1_3  = { t="mmetal1_3" }
  MMETAL1_5  = { t="mmetal1_5" }
  MMETAL1_6  = { t="mmetal1_6" }
  MMETAL1_7  = { t="mmetal1_7" }
  MMETAL1_8  = { t="mmetal1_8" }
  MSWTCH_2   = { t="mswtch_2" }
  MSWTCH_3   = { t="mswtch_3" }
  MSWTCH_4   = { t="mswtch_4" }
  MUH_BAD    = { t="muh_bad" }
  NMETAL2_1  = { t="nmetal2_1" }
  NMETAL2_6  = { t="nmetal2_6" }
  PLAT_SIDE1 = { t="plat_side1" }
  PLAT_STEM  = { t="plat_stem" }
  PLAT_TOP1  = { t="plat_top1" }
  PLAT_TOP2  = { t="plat_top2" }

  QUAKE      = { t="quake" }
  RAVEN      = { t="raven" }
  ROCK1_2    = { t="rock1_2" }
  ROCK3_2    = { t="rock3_2" }
  ROCK3_7    = { t="rock3_7" }
  ROCK3_8    = { t="rock3_8" }
  ROCK4_1    = { t="rock4_1" }
  ROCK4_2    = { t="rock4_2" }
  ROCK5_2    = { t="rock5_2" }
  RUNE1_1    = { t="rune1_1" }
  RUNE1_4    = { t="rune1_4" }
  RUNE1_5    = { t="rune1_5" }
  RUNE1_6    = { t="rune1_6" }
  RUNE1_7    = { t="rune1_7" }
  RUNE2_1    = { t="rune2_1" }
  RUNE2_2    = { t="rune2_2" }
  RUNE2_3    = { t="rune2_3" }
  RUNE2_4    = { t="rune2_4" }
  RUNE2_5    = { t="rune2_5" }
  RUNE_A     = { t="rune_a" }
  SFLOOR1_2  = { t="sfloor1_2" }
  SFLOOR3_2  = { t="sfloor3_2" }
  SFLOOR4_1  = { t="sfloor4_1" }
  SFLOOR4_2  = { t="sfloor4_2" }
  SFLOOR4_4  = { t="sfloor4_4" }
  SFLOOR4_5  = { t="sfloor4_5" }
  SFLOOR4_6  = { t="sfloor4_6" }
  SFLOOR4_7  = { t="sfloor4_7" }
  SFLOOR4_8  = { t="sfloor4_8" }
  SKILL0     = { t="skill0" }
  SKILL1     = { t="skill1" }
  SKILL2     = { t="skill2" }
  SKILL3     = { t="skill3" }
  SLIP1      = { t="slip1" }
  SLIP2      = { t="slip2" }
  SLIPBOTSD  = { t="slipbotsd" }
  SLIPLITE   = { t="sliplite" }
  SLIPSIDE   = { t="slipside" }
  SLIPTOPSD  = { t="sliptopsd" }
  STONE1_3   = { t="stone1_3" }
  STONE1_5   = { t="stone1_5" }
  STONE1_7   = { t="stone1_7" }
  SWITCH_1   = { t="switch_1" }
  SWTCH1_1   = { t="swtch1_1" }

  TECH01_1   = { t="tech01_1" }
  TECH01_2   = { t="tech01_2" }
  TECH01_3   = { t="tech01_3" }
  TECH01_5   = { t="tech01_5" }
  TECH01_6   = { t="tech01_6" }
  TECH01_7   = { t="tech01_7" }
  TECH01_9   = { t="tech01_9" }
  TECH02_1   = { t="tech02_1" }
  TECH02_2   = { t="tech02_2" }
  TECH02_3   = { t="tech02_3" }
  TECH02_5   = { t="tech02_5" }
  TECH02_6   = { t="tech02_6" }
  TECH02_7   = { t="tech02_7" }
  TECH03_1   = { t="tech03_1" }
  TECH03_2   = { t="tech03_2" }
  TECH04_1   = { t="tech04_1" }
  TECH04_2   = { t="tech04_2" }
  TECH04_3   = { t="tech04_3" }
  TECH04_4   = { t="tech04_4" }
  TECH04_5   = { t="tech04_5" }
  TECH04_6   = { t="tech04_6" }
  TECH04_7   = { t="tech04_7" }
  TECH04_8   = { t="tech04_8" }
  TECH05_1   = { t="tech05_1" }
  TECH05_2   = { t="tech05_2" }
  TECH06_1   = { t="tech06_1" }
  TECH06_2   = { t="tech06_2" }
  TECH07_1   = { t="tech07_1" }
  TECH07_2   = { t="tech07_2" }
  TECH08_1   = { t="tech08_1" }
  TECH08_2   = { t="tech08_2" }
  TECH09_3   = { t="tech09_3" }
  TECH09_4   = { t="tech09_4" }
  TECH10_1   = { t="tech10_1" }
  TECH10_3   = { t="tech10_3" }
  TECH11_1   = { t="tech11_1" }
  TECH11_2   = { t="tech11_2" }
  TECH12_1   = { t="tech12_1" }
  TECH13_2   = { t="tech13_2" }
  TECH14_1   = { t="tech14_1" }
  TECH14_2   = { t="tech14_2" }
  TELE_TOP   = { t="tele_top" }
  TLIGHT01   = { t="tlight01" }
  TLIGHT01_2 = { t="tlight01_2" }
  TLIGHT02   = { t="tlight02" }
  TLIGHT03   = { t="tlight03" }
  TLIGHT05   = { t="tlight05" }
  TLIGHT07   = { t="tlight07" }
  TLIGHT08   = { t="tlight08" }
  TLIGHT09   = { t="tlight09" }
  TLIGHT10   = { t="tlight10" }
  TLIGHT11   = { t="tlight11" }
  TWALL1_1   = { t="twall1_1" }
  TWALL1_2   = { t="twall1_2" }
  TWALL1_4   = { t="twall1_4" }
  TWALL2_1   = { t="twall2_1" }
  TWALL2_2   = { t="twall2_2" }
  TWALL2_3   = { t="twall2_3" }
  TWALL2_5   = { t="twall2_5" }
  TWALL2_6   = { t="twall2_6" }
  TWALL3_1   = { t="twall3_1" }
  TWALL5_1   = { t="twall5_1" }
  TWALL5_2   = { t="twall5_2" }
  TWALL5_3   = { t="twall5_3" }

  UNWALL1_8  = { t="unwall1_8" }
  UWALL1_2   = { t="uwall1_2" }
  UWALL1_3   = { t="uwall1_3" }
  UWALL1_4   = { t="uwall1_4" }
  VINE1_2    = { t="vine1_2" }
  WALL11_2   = { t="wall11_2" }
  WALL11_6   = { t="wall11_6" }
  WALL14_5   = { t="wall14_5" }
  WALL14_6   = { t="wall14_6" }
  WALL16_7   = { t="wall16_7" }
  WALL3_4    = { t="wall3_4" }
  WALL5_4    = { t="wall5_4" }
  WALL9_3    = { t="wall9_3" }
  WALL9_8    = { t="wall9_8" }
  WARCH05    = { t="warch05" }
  WBRICK1_4  = { t="wbrick1_4" }
  WBRICK1_5  = { t="wbrick1_5" }
  WCEILING4  = { t="wceiling4" }
  WCEILING5  = { t="wceiling5" }
  WENTER01   = { t="wenter01" }
  WEXIT01    = { t="wexit01" }
  WGRASS1_1  = { t="wgrass1_1" }
  WGRND1_5   = { t="wgrnd1_5" }
  WGRND1_6   = { t="wgrnd1_6" }
  WGRND1_8   = { t="wgrnd1_8" }
  WINDOW01_1 = { t="window01_1" }
  WINDOW01_2 = { t="window01_2" }
  WINDOW01_3 = { t="window01_3" }
  WINDOW01_4 = { t="window01_4" }
  WINDOW02_1 = { t="window02_1" }
  WINDOW03   = { t="window03" }
  WINDOW1_2  = { t="window1_2" }
  WINDOW1_3  = { t="window1_3" }
  WINDOW1_4  = { t="window1_4" }
  WIZ1_1     = { t="wiz1_1" }
  WIZ1_4     = { t="wiz1_4" }
  WIZMET1_1  = { t="wizmet1_1" }
  WIZMET1_2  = { t="wizmet1_2" }
  WIZMET1_3  = { t="wizmet1_3" }
  WIZMET1_4  = { t="wizmet1_4" }
  WIZMET1_5  = { t="wizmet1_5" }
  WIZMET1_6  = { t="wizmet1_6" }
  WIZMET1_7  = { t="wizmet1_7" }
  WIZMET1_8  = { t="wizmet1_8" }
  WIZWIN1_2  = { t="wizwin1_2" }
  WIZWIN1_8  = { t="wizwin1_8" }
  WIZWOOD1_2 = { t="wizwood1_2" }
  WIZWOOD1_3 = { t="wizwood1_3" }
  WIZWOOD1_4 = { t="wizwood1_4" }
  WIZWOOD1_5 = { t="wizwood1_5" }
  WIZWOOD1_6 = { t="wizwood1_6" }
  WIZWOOD1_7 = { t="wizwood1_7" }
  WIZWOOD1_8 = { t="wizwood1_8" }
  WKEY02_1   = { t="wkey02_1" }
  WKEY02_2   = { t="wkey02_2" }
  WKEY02_3   = { t="wkey02_3" }
  WMET1_1    = { t="wmet1_1" }
  WMET2_1    = { t="wmet2_1" }
  WMET2_2    = { t="wmet2_2" }
  WMET2_3    = { t="wmet2_3" }
  WMET2_4    = { t="wmet2_4" }
  WMET2_6    = { t="wmet2_6" }
  WMET3_1    = { t="wmet3_1" }
  WMET3_3    = { t="wmet3_3" }
  WMET3_4    = { t="wmet3_4" }
  WMET4_2    = { t="wmet4_2" }
  WMET4_3    = { t="wmet4_3" }
  WMET4_4    = { t="wmet4_4" }
  WMET4_5    = { t="wmet4_5" }
  WMET4_6    = { t="wmet4_6" }
  WMET4_7    = { t="wmet4_7" }
  WMET4_8    = { t="wmet4_8" }
  WOOD1_1    = { t="wood1_1" }
  WOOD1_5    = { t="wood1_5" }
  WOOD1_7    = { t="wood1_7" }
  WOOD1_8    = { t="wood1_8" }
  WOODFLR1_2 = { t="woodflr1_2" }
  WOODFLR1_4 = { t="woodflr1_4" }
  WOODFLR1_5 = { t="woodflr1_5" }
  WSWAMP1_2  = { t="wswamp1_2" }
  WSWAMP1_4  = { t="wswamp1_4" }
  WSWAMP2_1  = { t="wswamp2_1" }
  WSWAMP2_2  = { t="wswamp2_2" }
  WSWITCH1   = { t="wswitch1" }
  WWALL1_1   = { t="wwall1_1" }
  WWOOD1_5   = { t="wwood1_5" }
  WWOOD1_7   = { t="wwood1_7" }
  Z_EXIT     = { t="z_exit" }

  -- special stuff
  TRIGGER    = { t="trigger" }

  TELEPORT   = { t="*teleport" }

  L_LAVA1    = { t="*lava1"  }
  L_SLIME    = { t="*slime"  }
  L_SLIME0   = { t="*slime0" }
  L_SLIME1   = { t="*slime1" }
  L_WATER0   = { t="*water0" }
  L_WATER1   = { t="*water1" }
  L_WATER2   = { t="*water2" }

  -- Oblige specific textures
  O_CARVE    = { t="o_carve" }
  O_BOLT     = { t="o_bolt"  }


  BUTTON = { t="+0button" }

  BUTNN  = { t="+0butnn" }

-- TODO:

---  +0basebtn
---  +0butn
---  +0butnn
---  +0floorsw
---  +0light01
---  +0mtlsw
---  +0planet
---  +0shoot
---  +0slip
---  +0slipbot
---  +0sliptop
---  +1basebtn
---  +1butn
---  +1butnn
---  +1button
---  +1floorsw
---  +1light01
---  +1mtlsw
---  +1planet
---  +1shoot
---  +1slip
---  +2butn
---  +2butnn
---  +2button
---  +2floorsw
---  +2light01
---  +2mtlsw
---  +2planet
---  +2shoot
---  +2slip
---  +3butn
---  +3butnn
---  +3button
---  +3floorsw
---  +3mtlsw
---  +3planet
---  +3shoot
---  +3slip
---  +4slip
---  +5slip
---  +6slip
---  +abasebtn
---  +abutn
---  +abutnn
---  +abutton
---  +afloorsw
---  +amtlsw
---  +ashoot

---  *04awater1
---  *04mwat1
---  *04mwat2
---  *04water1
---  *04water2
}


------------------------------------------------------------------------

QUAKE.PREFAB_DEFAULTS =
{
  -- FIXME : QUAKE.PREFAB_DEFAULTS

  thing_1 = "player1"
  thing_2 = "player2"
  thing_3 = "player3"
  thing_4 = "player4"
}


QUAKE.SKIN_DEFAULTS =
{
  -- FIXME : QUAKE.SKIN_DEFAULTS
}

