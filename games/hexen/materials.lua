------------------------------------------------------------------------
--  HEXEN MATERIALS
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

HEXEN.LIQUIDS =
{
  -- Hexen gets damage from the flat (not a sector special)

  -- water and muck sometimes flow in a direction, but I'll leave that to
  -- later code development.
  water  = { mat="X_005", light_add=16, special=0 },
  muck   = { mat="X_009", light_add=16, special=0 },
  lava   = { mat="X_001", light_add=24, special=0, damage=20 },

  -- Ice isn't really a liquid, but may be placed like one in some ice levels
  icefloor = { mat="F_033", special=0 },
}


HEXEN.MATERIALS =
{
  -- special materials --
  _ERROR = { t="STEEL01", f="F_075" },
  _DEFAULT = { t="STEEL01",  f="F_074" },
  _SKY   = { t="STEEL01", f="F_SKY" },

  -- walls --

  BOOKS01  = { t="BOOKS01",  f="F_092" },
  BOOKS02  = { t="BOOKS02",  f="F_092" },
  BOOKS03  = { t="BOOKS03",  f="F_092" },
  BOOKS04  = { t="BOOKS04",  f="F_092" },
  BRASS1   = { t="BRASS1",   f="F_037" },
  BRASS3   = { t="BRASS3",   f="F_037" },
  BRASS4   = { t="BRASS5",   f="F_037" },
  CASTLE01 = { t="CASTLE01", f="F_012" },
  CASTLE02 = { t="CASTLE02", f="F_012" },
  CASTLE03 = { t="CASTLE03", f="F_012" },
  CASTLE04 = { t="CASTLE04", f="F_012" },
  CASTLE05 = { t="CASTLE05", f="F_012" },
  CASTLE06 = { t="CASTLE06", f="F_012" },
  CASTLE07 = { t="CASTLE07", f="F_057" },
  CASTLE08 = { t="CASTLE08", f="F_057" },
  CASTLE11 = { t="CASTLE11", f="F_073" },

  CAVE01   = { t="CAVE01",   f="F_073" },
  CAVE02   = { t="CAVE02",   f="F_076" },
  CAVE03   = { t="CAVE03",   f="F_039" },
  CAVE04   = { t="CAVE04",   f="F_039" },
  CAVE05   = { t="CAVE05",   f="F_007" },
  CAVE06   = { t="CAVE06",   f="F_039" },
  CAVE07   = { t="CAVE07",   f="F_008" },
  CAVE12   = { t="CAVE12",   f="F_076" },
  CHAP1    = { t="CHAP1",    f="F_082" },
  CHAP2    = { t="CHAP2",    f="F_082" },
  CHAP3    = { t="CHAP3",    f="F_082" },
  CLOCKA   = { t="CLOCKA",   f="F_082" },
  CRATE01  = { t="CRATE01",  f="F_049" },
  CRATE02  = { t="CRATE02",  f="F_051" },
  CRATE03  = { t="CRATE03",  f="F_050" },
  CRATE04  = { t="CRATE04",  f="F_052" },
  CRATE05  = { t="CRATE05",  f="F_053" },

  D_AXE    = { t="D_AXE",    f="F_092" },
  D_BRASS1 = { t="D_BRASS1", f="F_037" },
  D_BRASS2 = { t="D_BRASS2", f="F_037" },
  D_CAST   = { t="D_CAST",   f="F_073" },
  D_CAVE   = { t="D_CAVE",   f="F_073" },
  D_CAVE2  = { t="D_CAVE2",  f="F_007" },
  D_DUNGEO = { t="D_DUNGEO", f="F_092" },
  D_END1   = { t="D_END1",   f="F_073" },
  D_END2   = { t="D_END2",   f="F_073" },
  D_END3   = { t="D_END3",   f="F_092" },
  D_END4   = { t="D_END4",   f="F_092" },
  D_ENDBR  = { t="D_ENDBR",  f="F_037" },
  D_ENDSLV = { t="D_ENDSLV", f="F_082" },
  D_FIRE   = { t="D_FIRE",   f="F_013" },
  D_RUST   = { t="D_RUST",   f="F_073" },
  D_SILKEY = { t="D_SILKEY", f="F_092" },
  D_SILVER = { t="D_SILVER", f="F_073" },
  D_SLV1   = { t="D_SLV1",   f="F_066" },
  D_SLV2   = { t="D_SLV2",   f="F_066" },
  D_STEEL  = { t="D_STEEL",  f="F_065" },
  D_SWAMP  = { t="D_SWAMP",  f="F_018" },
  D_SWAMP2 = { t="D_SWAMP2", f="F_076" },
  D_WASTE  = { t="D_WASTE",  f="F_037" },
  D_WD01   = { t="D_WD01",   f="F_092" },
  D_WD02   = { t="D_WD02",   f="F_092" },
  D_WD03   = { t="D_WD03",   f="F_092" },
  D_WD04   = { t="D_WD04",   f="F_092" },
  D_WD05   = { t="D_WD05",   f="F_051" },
  D_WD06   = { t="D_WD06",   f="F_051" },
  D_WD07   = { t="D_WD07",   f="F_073" },
  D_WD08   = { t="D_WD08",   f="F_073" },
  D_WD09   = { t="D_WD09",   f="F_073" },
  D_WD10   = { t="D_WD10",   f="F_073" },
  D_WINNOW = { t="D_WINNOW", f="F_073" },
  DOOR51   = { t="DOOR51",   f="F_082" },

  FIRE01   = { t="FIRE01",   f="F_032" },
  FIRE02   = { t="FIRE02",   f="F_032" },
  FIRE03   = { t="FIRE03",   f="F_032" },
  FIRE04   = { t="FIRE04",   f="F_032" },
  FIRE05   = { t="FIRE05",   f="F_032" },
  FIRE06   = { t="FIRE06",   f="F_013" },
  FIRE07   = { t="FIRE07",   f="F_013" },
  FIRE08   = { t="FIRE08",   f="F_013" },
  FIRE09   = { t="FIRE09",   f="F_013" },
  FIRE10   = { t="FIRE10",   f="F_013" },
  FIRE11   = { t="FIRE11",   f="F_013" },
  FIRE12   = { t="FIRE12",   f="F_013" },
  FIRE14   = { t="FIRE14",   f="F_032" },
  FIRE15   = { t="FIRE15",   f="F_032" },
  FIRE17   = { t="FIRE17",   f="F_017" },

  FOREST01 = { t="FOREST01", f="F_014" },
  FOREST02 = { t="FOREST02", f="F_038" },
  FOREST03 = { t="FOREST03", f="F_038" },
  FOREST04 = { t="FOREST04", f="F_038" },
  FOREST05 = { t="FOREST05", f="F_048" },
  FOREST07 = { t="FOREST07", f="F_002" },
  FOREST10 = { t="FOREST10", f="F_047" },
  FOREST11 = { t="FOREST11", f="F_038" },
  FORPUZ1  = { t="FORPUZ1",  f="F_005" },
  FORPUZ2  = { t="FORPUZ2",  f="F_038" },
  FORPUZ3  = { t="FORPUZ3",  f="F_041" },

  GEARW    = { t="GEARW",    f="F_074" },
  GEARX    = { t="GEARX",    f="F_074" },
  GEARY    = { t="GEARY",    f="F_074" },
  GEARZ    = { t="GEARZ",    f="F_074" },
  GILO1    = { t="GILO1",    f="F_072" },
  GILO2    = { t="GILO2",    f="F_072" },

  GLASS01  = { t="GLASS01",  f="F_081" },
  GLASS02  = { t="GLASS02",  f="F_081" },
  GLASS03  = { t="GLASS03",  f="F_081" },
  GLASS04  = { t="GLASS04",  f="F_081" },
  GLASS05  = { t="GLASS05",  f="F_081" },
  GLASS06  = { t="GLASS06",  f="F_081" },
  GRAVE01  = { t="GRAVE01",  f="F_009" },
  GRAVE03  = { t="GRAVE03",  f="F_009" },
  GRAVE04  = { t="GRAVE04",  f="F_009" },
  GRAVE05  = { t="GRAVE05",  f="F_009" },
  GRAVE06  = { t="GRAVE06",  f="F_009" },
  GRAVE07  = { t="GRAVE07",  f="F_009" },
  GRAVE08  = { t="GRAVE08",  f="F_009" },

  ICE01    = { t="ICE01",    f="F_033" },
  ICE02    = { t="ICE02",    f="F_040" },
  ICE03    = { t="ICE03",    f="F_040" },
  ICE06    = { t="ICE06",    f="F_040" },
  MONK01   = { t="MONK01",   f="F_027" },
  MONK02   = { t="MONK02",   f="F_025" },
  MONK03   = { t="MONK03",   f="F_025" },
  MONK04   = { t="MONK04",   f="F_025" },
  MONK05   = { t="MONK05",   f="F_025" },
  MONK06   = { t="MONK06",   f="F_025" },
  MONK07   = { t="MONK07",   f="F_031" },
  MONK08   = { t="MONK08",   f="F_031" },
  MONK09   = { t="MONK09",   f="F_025" },
  MONK11   = { t="MONK11",   f="F_025" },
  MONK12   = { t="MONK12",   f="F_025" },
  MONK14   = { t="MONK14",   f="F_029" },
  MONK15   = { t="MONK15",   f="F_029" },
  MONK16   = { t="MONK16",   f="F_028" },
  MONK17   = { t="MONK17",   f="F_028" },
  MONK18   = { t="MONK18",   f="F_028" },
  MONK19   = { t="MONK19",   f="F_028" },
  MONK21   = { t="MONK21",   f="F_028" },
  MONK22   = { t="MONK22",   f="F_028" },
  MONK23   = { t="MONK23",   f="F_025" },

  PILLAR01 = { t="PILLAR01", f="F_037" },
  PILLAR02 = { t="PILLAR02", f="F_044" },
  PLANET1  = { t="PLANET1",  f="F_025" },
  PLANET2  = { t="PLANET2",  f="F_025" },
  PLAT01   = { t="PLAT01",   f="F_045" },
  PLAT02   = { t="PLAT02",   f="F_065" },
  POOT     = { t="POOT",     f="F_048" },
  PRTL02   = { t="PRTL02",   f="F_057" },
  PRTL03   = { t="PRTL03",   f="F_019" },
  PRTL04   = { t="PRTL04",   f="F_044" },
  PRTL05   = { t="PRTL05",   f="F_044" },
  PRTL06   = { t="PRTL06",   f="F_057" },
  PUZZLE1  = { t="PUZZLE1",  f="F_082" },
  PUZZLE10 = { t="PUZZLE10", f="F_091" },
  PUZZLE11 = { t="PUZZLE11", f="F_091" },
  PUZZLE12 = { t="PUZZLE12", f="F_091" },
  PUZZLE2  = { t="PUZZLE2",  f="F_082" },
  PUZZLE3  = { t="PUZZLE3",  f="F_082" },
  PUZZLE4  = { t="PUZZLE4",  f="F_082" },
  PUZZLE5  = { t="PUZZLE5",  f="F_091" },
  PUZZLE6  = { t="PUZZLE6",  f="F_091" },
  PUZZLE7  = { t="PUZZLE7",  f="F_091" },
  PUZZLE8  = { t="PUZZLE8",  f="F_091" },
  PUZZLE9  = { t="PUZZLE9",  f="F_091" },

  SEWER01  = { t="SEWER01",  f="F_018" },
  SEWER02  = { t="SEWER02",  f="F_018" },
  SEWER05  = { t="SEWER05",  f="F_018" },
  SEWER06  = { t="SEWER06",  f="F_018" },
  SEWER07  = { t="SEWER07",  f="F_017" },
  SEWER08  = { t="SEWER08",  f="F_017" },
  SEWER09  = { t="SEWER09",  f="F_017" },
  SEWER10  = { t="SEWER10",  f="F_017" },
  SEWER11  = { t="SEWER11",  f="F_017" },
  SEWER12  = { t="SEWER12",  f="F_017" },
  SEWER13  = { t="SEWER13",  f="F_018" },

  SPAWN01  = { t="SPAWN01",  f="F_042" },
  SPAWN05  = { t="SPAWN05",  f="F_042" },
  SPAWN08  = { t="SPAWN08",  f="F_065" },
  SPAWN10  = { t="SPAWN10",  f="F_065" },
  SPAWN11  = { t="SPAWN11",  f="F_078" },
  SPAWN13  = { t="SPAWN13",  f="F_042" },
  STEEL01  = { t="STEEL01",  f="F_074" },
  STEEL02  = { t="STEEL02",  f="F_075" },
  STEEL05  = { t="STEEL05",  f="F_069" },
  STEEL06  = { t="STEEL06",  f="F_069" },
  STEEL07  = { t="STEEL07",  f="F_070" },
  STEEL08  = { t="STEEL08",  f="F_078" },
  SWAMP01  = { t="SWAMP01",  f="F_019" },
  SWAMP03  = { t="SWAMP03",  f="F_019" },
  SWAMP04  = { t="SWAMP04",  f="F_017" },
  SWAMP06  = { t="SWAMP06",  f="F_017" },

  TOMB01   = { t="TOMB01",   f="F_058" },
  TOMB02   = { t="TOMB02",   f="F_058" },
  TOMB03   = { t="TOMB03",   f="F_058" },
  TOMB04   = { t="TOMB04",   f="F_058" },
  TOMB05   = { t="TOMB05",   f="F_059" },
  TOMB06   = { t="TOMB06",   f="F_059" },
  TOMB07   = { t="TOMB07",   f="F_044" },
  TOMB08   = { t="TOMB08",   f="F_042" },
  TOMB09   = { t="TOMB09",   f="F_042" },
  TOMB10   = { t="TOMB10",   f="F_042" },
  TOMB11   = { t="TOMB11",   f="F_044" },
  TOMB12   = { t="TOMB12",   f="F_059" },
  VALVE1   = { t="VALVE1",   f="F_047" },
  VALVE2   = { t="VALVE2",   f="F_047" },
  VILL01   = { t="VILL01",   f="F_030" },
  VILL04   = { t="VILL04",   f="F_055" },
  VILL05   = { t="VILL05",   f="F_055" },

  WASTE01  = { t="WASTE01",  f="F_005" },
  WASTE02  = { t="WASTE02",  f="F_044" },
  WASTE03  = { t="WASTE03",  f="F_082" },
  WASTE04  = { t="WASTE04",  f="F_037" },
  WINN01   = { t="WINN01",   f="F_047" },
  WINNOW02 = { t="WINNOW02", f="F_022" },
  WOOD01   = { t="WOOD01",   f="F_054" },
  WOOD02   = { t="WOOD02",   f="F_092" },
  WOOD03   = { t="WOOD03",   f="F_092" },
  WOOD04   = { t="WOOD04",   f="F_054" },

  X_FAC01  = { t="X_FAC01",  f="X_001", sane=1 },
  X_FIRE01 = { t="X_FIRE01", f="X_001", sane=1 },
  X_SWMP1  = { t="X_SWMP1",  f="X_009", sane=1 },
  X_SWR1   = { t="X_SWR1",   f="F_018", sane=1 },
  X_WATER1 = { t="X_WATER1", f="X_005", sane=1 },


  -- steps --

  S_01     = { t="S_01",     f="F_047" },
  S_02     = { t="S_02",     f="F_009" },
  S_04     = { t="S_04",     f="F_030" },
  S_05     = { t="S_05",     f="F_057" },
  S_06     = { t="S_06",     f="F_009" },
  S_07     = { t="S_07",     f="F_009" },
  S_09     = { t="S_09",     f="F_047" },
  S_11     = { t="S_11",     f="F_034" },
  S_12     = { t="S_12",     f="F_053" },
  S_13     = { t="S_13",     f="F_057" },
  T2_STEP  = { t="T2_STEP",  f="F_057" },


  -- switches --

  BOSSK1   = { t="BOSSK1",   f="F_071", sane=1 },
  GEAR01   = { t="GEAR01",   f="F_091", sane=1 },
  SW51_OFF = { t="SW51_OFF", f="F_082", sane=1 },
  SW52_OFF = { t="SW52_OFF", f="F_082", sane=1 },
  SW53_UP  = { t="SW53_UP",  f="F_025", sane=1 },
  SW_1_UP  = { t="SW_1_UP",  f="F_048", sane=1 },
  SW_2_UP  = { t="SW_2_UP",  f="F_048", sane=1 },
  SW_EL1   = { t="SW_EL1",   f="F_082", sane=1 },
  SW_OL1   = { t="SW_OL1",   f="F_073", sane=1 },


  -- floors --

  F_001 = { t="WASTE01",  f="F_001" },
  F_002 = { t="WASTE01",  f="F_002" },
  F_003 = { t="WASTE01",  f="F_003" },
  F_004 = { t="WASTE01",  f="F_004" },
  F_005 = { t="WASTE01",  f="F_005" },
  F_006 = { t="WASTE01",  f="F_006" },
  F_007 = { t="CAVE05",   f="F_007" },
  F_008 = { t="CAVE07",   f="F_008" },
  F_009 = { t="PRTL02",   f="F_009" },
  F_010 = { t="PRTL04",   f="F_010" },
  F_011 = { t="FOREST01", f="F_011" },
  F_012 = { t="FIRE06",   f="F_012" },
  F_013 = { t="FIRE06",   f="F_013" },
  F_014 = { t="MONK16",   f="F_014" },
  F_015 = { t="CASTLE01", f="F_015" },
  F_017 = { t="SWAMP04",  f="F_017" },
  F_018 = { t="SEWER01",  f="F_018" },
  F_019 = { t="SWAMP01",  f="F_019" },
  F_020 = { t="SWAMP01",  f="F_020" },
  F_021 = { t="FIRE06",   f="F_021" },
  F_022 = { t="FIRE06",   f="F_022" },
  F_023 = { t="SEWER01",  f="F_023" },
  F_024 = { t="SEWER07",  f="F_024" },
  F_025 = { t="MONK02",   f="F_025" },
  F_027 = { t="MONK01",   f="F_027" },
  F_028 = { t="MONK16",   f="F_028" },
  F_029 = { t="MONK14",   f="F_029" },
  F_030 = { t="VILL01",   f="F_030" },
  F_031 = { t="MONK07",   f="F_031" },
  F_032 = { t="FIRE01",   f="F_032" },
  F_033 = { t="ICE01",    f="F_033" },
  F_034 = { t="FOREST02", f="F_034" },
  F_037 = { t="WASTE04",  f="F_037" },
  F_038 = { t="FOREST02", f="F_038" },
  F_039 = { t="CAVE04",   f="F_039" },
  F_040 = { t="CAVE04",   f="F_040" },
  F_041 = { t="FIRE06",   f="F_041" },
  F_042 = { t="FIRE06",   f="F_042" },
  F_043 = { t="WASTE02",  f="F_043" },
  F_044 = { t="PRTL04",   f="F_044" },
  F_045 = { t="WASTE03",  f="F_045" },
  F_046 = { t="WASTE03",  f="F_046" },
  F_047 = { t="TOMB07",   f="F_047" },
  F_048 = { t="FOREST05", f="F_048" },
  F_049 = { t="CRATE01",  f="F_049" },
  F_050 = { t="CRATE03",  f="F_050" },
  F_051 = { t="CRATE02",  f="F_051" },
  F_052 = { t="CRATE04",  f="F_052" },
  F_053 = { t="CRATE05",  f="F_053" },
  F_054 = { t="WOOD01",   f="F_054" },
  F_055 = { t="WOOD01",   f="F_055" },
  F_057 = { t="CASTLE07", f="F_057" },
  F_058 = { t="TOMB04",   f="F_058" },
  F_059 = { t="TOMB05",   f="F_059" },

  F_061 = { t="TOMB04",   f="F_061" },
  F_062 = { t="TOMB04",   f="F_062" },
  F_063 = { t="TOMB04",   f="F_063" },
  F_064 = { t="TOMB04",   f="F_064" },
  F_065 = { t="STEEL06",  f="F_065" },
  F_066 = { t="STEEL07",  f="F_066" },
  F_067 = { t="STEEL06",  f="F_067" },
  F_068 = { t="STEEL07",  f="F_068" },
  F_069 = { t="STEEL06",  f="F_069" },
  F_070 = { t="STEEL07",  f="F_070" },
  F_071 = { t="STEEL05",  f="F_071" },
  F_072 = { t="STEEL07",  f="F_072" },
  F_073 = { t="CASTLE11", f="F_073" },
  F_074 = { t="STEEL01",  f="F_074" },
  F_075 = { t="STEEL02",  f="F_075" },
  F_076 = { t="CAVE02",   f="F_076" },
  F_077 = { t="VILL01",   f="F_077" },
  F_078 = { t="STEEL06",  f="F_078" },
  F_081 = { t="GLASS05",  f="F_081" },
  F_082 = { t="CASTLE01", f="F_082" },
  F_083 = { t="CASTLE01", f="F_083" },
  F_084 = { t="CASTLE01", f="F_084" },
  F_089 = { t="CASTLE01", f="F_089" },
  F_091 = { t="CASTLE01", f="F_091" },
  F_092 = { t="WOOD01",   f="F_092" },


  -- liquids --

  X_001 = { t="X_FIRE01", f="X_001", sane=1  },
  X_005 = { t="X_WATER1", f="X_005", sane=1  },
  X_009 = { t="X_SWMP1",  f="X_009", sane=1  },
  X_012 = { t="CASTLE01", f="X_012", sane=1  },


  -- rails --

  GATE01  = { t="GATE01", rail_h=72,  line_flags=1 },
  GATE02  = { t="GATE02", rail_h=128, line_flags=1 },
  GATE03  = { t="GATE03", rail_h=64,  line_flags=1 },
  GATE04  = { t="GATE04", rail_h=32,  line_flags=1 },
  GATE51  = { t="GATE51", rail_h=128, line_flags=1 },
  GATE52  = { t="GATE52", rail_h=64,  line_flags=1 },
  GATE53  = { t="GATE53", rail_h=32,  line_flags=1 },

  BAMBOO_6 = { t="VILL06", rail_h=128, line_flags=1 },
  BAMBOO_7 = { t="VILL07", rail_h=64,  line_flags=1 },
  BAMBOO_8 = { t="VILL08", rail_h=96,  line_flags=1 },

  VINES     = { t="FOREST06", rail_h=128 },
  BRK_GLASS = { t="GLASS07",  rail_h=128 },
  BRK_TOMB  = { t="TOMB18",   rail_h=128 },

  H_CASTLE  = { t="CASTLE09", rail_h=128 },
  H_CAVE    = { t="CAVE11",   rail_h=128 },
  H_FIRE    = { t="FIRE16",   rail_h=128 },
  H_FORSET  = { t="FOREST12", rail_h=128 },
  H_MONK    = { t="MONK24",   rail_h=128 },
  H_PRTL    = { t="PRTL07",   rail_h=128 },
  H_SEWER   = { t="SEWER14",  rail_h=128 },
  H_SWAMP   = { t="SWAMP07",  rail_h=128 },
  H_TOMB    = { t="TOMB13",   rail_h=128 },

  R_TPORT1  = { t="TPORT1",  rail_h=128 },
  R_TPORTX  = { t="TPORTX",  rail_h=128 },
  R_VALVE01 = { t="VALVE01", rail_h=32 },
  R_VALVE02 = { t="VALVE02", rail_h=32 },

  SEWER_BAR3 = { t="SEWER03", rail_h=64, line_flags=1 },
  SEWER_BAR4 = { t="SEWER04", rail_h=32, line_flags=1 },

  WEB1_L   = { t="WEB1_L", rail_h=32 },
  WEB1_R   = { t="WEB1_R", rail_h=32 },
  WEB2_L   = { t="WEB2_L", rail_h=32 },
  WEB2_R   = { t="WEB2_R", rail_h=32 },
  WEB3     = { t="WEB3",   rail_h=32 },


  -- other --

  O_BOLT   = { t="SEWER08", f="O_BOLT",  sane=1 },
  O_PILL   = { t="BRASS3",  f="O_PILL",  sane=1 },
  O_CARVE  = { t="BRASS4",  f="O_CARVE", sane=1 },

  -- FIXME: TEMP HACK!!
  STNGLS1  = { t="GLASS01",  f="F_081" },
}


------------------------------------------------------------------------

HEXEN.PREFAB_FIELDS =
{
  -- TODO : compatibility with DOOM prefabs
}


HEXEN.SKIN_DEFAULTS =
{
}

