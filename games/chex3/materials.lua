CHEX3.LIQUIDS =
{
  water  = { mat="FWATER1", light_add=16, special=0 },
  slime0 = { mat="BLOOD1", light_add=16, special=16, damage=20 },
  slime1 = { mat="NUKAGE1", light_add=16, special=16, damage=20 },
  slime2   = { mat="LAVA1", light_add=24, special=16, damage=20 }    
}

CHEX3.MATERIALS =
{
  -- special materials --
  _DEFAULT = { t="COMPSPAN", f="CEIL5_1" },
  _ERROR = { t="COMPSPAN", f="CEIL5_1" },
  _SKY   = { t="COMPSPAN", f="F_SKY1" },
  _LIQUID = { t="GSTFONT1", f="FWATER1" },
  XEMPTY = { t="-", f="-" },

  -- general purpose --

  COMPBLUE  = { t="COMPBLUE", f="STEP1" },
  STEP1  = { t="COMPBLUE", f="STEP1" },
  SKSNAKE2   = { t="SKSNAKE2", f="CEIL3_1" },
  CEIL3_1   = { t="SKSNAKE2", f="CEIL3_1" },
  ASHWALL   = { t="ASHWALL",  f="FLOOR0_3" },
  SW2SATYR  = { t="SW2SATYR", f="FLAT5_6" },
  FLOOR0_1   = { f="FLOOR0_1", t="TEKWALL5" },


  -- walls --
  WOOD4 = { t="WOOD4", f="CJFFLEM2"},
  GRAY2 = { t="GRAY2", f="ENDFLAT2"},
  SEWERA = { t="SEWERA", f="ENDFLAT2" },
  NICEWALL = { t="NICEWALL", f="MUFLOOR2" },
  WINDOH2 = { t="WINDOH2", f="MUFLOOR2" },
  CITYWALL = { t="CITYWALL", f="CEIL5_1" },
  WINDOH = { t="WINDOH", f="CEIL5_1" },
  GRAY5 = { t="GRAY5", f="CEIL5_1" },
  STONE = { t="STONE", f="CEIL5_1" },

  SKSNAKE1 = { t="SKSNAKE1", f="STEP1" },

  SP_DUDE2    = { t="SP_DUDE2", f="FLOOR0_2" },
  SLADSKUL = { t="SLADSKUL", f="FLOOR0_2" },
  SKINMET1  = { t="SKINMET1", f="FLOOR0_2" },

  GRAY_PIPES   = { t="STONE",    f="FLAT5_6" },
  STONE3  = { t="STONE3",   f="FLAT5_6" },
  GRAY_LITE    = { t="LITESTON", f="FLAT5_6" },
  GRAY7  = { t="GRAY7",    f="FLAT5_6" },

  STARG3   = { t="STARG3",   f="FLAT2" },
  COMPUTE3    = { t="COMPUTE3", f="FLAT2" },
  SKINMET2 = { t="SKINMET2", f="FLAT2" },
  DOOR3  = { t="DOOR3",    f="FLAT2" },
  CEMENT4 = { t="CEMENT4",  f="FLAT2" },
  CEMENT6 = { t="CEMENT6",  f="FLAT2" },

  CEMPOIS   = { t="CEMPOIS",  f="FLAT2" },
  BRNSMALL  = { t="BRNSMALL", f="FLAT2" },
  BRNSMALR   = { t="BRNSMALR", f="FLAT2" },
  BROWN96    = { t="BROWN96",  f="FLAT2" },

  CEMENT1      = { t="CEMENT1",  f="CEIL3_2" },
  CEMENT5      = { t="CEMENT5",  f="CEIL3_2" },
  LITE96  = { t="LITE96",   f="CEIL3_2" },
  REDWALL1 = { t="REDWALL1", f="CEIL3_2" },

  CEMENT2  = { t="CEMENT2", f="FLAT5_6" },

  TEKWALL5      = { t="TEKWALL5", f="FLAT1" },
  BROWN      = { t="BROWN1",   f="BROWN" },
  BROWN1      = { t="BROWN1",   f="FLAT1" },
  LITE2  = { t="LITE2",    f="FLAT1" },
  BRNSMAL1 = { t="BRNSMAL1", f="FLAT1" },
  BROVINE  = { t="BROVINE",  f="FLAT1" },

  COMP2 = { t="COMP2",    f="FLAT5_6" },
  COMPUTE2 = { t="COMPUTE2", f="FLAT5_6" },
  COMPWERD  = { t="COMPWERD", f="FLAT5_6" },
  COMPSPAN = { t="COMPSPAN", f="FLAT5_6" },

  BRNBIGC = { t="BRNBIGC",  f="FLAT1" },

  BLODRIP2    = { t="BLODRIP2", f="CEIL3_1" },
  SKULWAL3    = { t="SKULWAL3", f="CEIL3_1" },
  STARTAN2   = { t="STARTAN2", f="CEIL3_1" },
  PIPE6 = { t="PIPE6",    f="CEIL3_2" },

  SKINCUT  = { t="SKINCUT",  f="CEIL4_1" },
  EXITDOOR = { t="EXITDOOR", f="CEIL4_1" },
  TEKWALL4  = { t="TEKWALL4", f="CEIL4_1" },
  SLADWALL  = { t="SLADWALL", f="CEIL4_1" },

  SLADRIP1 = { t="SLADRIP1", f="FLAT5_6" },

  SP_DUDE4 = { t="SP_DUDE4", f="STEP1" },

  -- floors --
  
  FLOOR0_6 = { t="GRAYTALL", f="FLOOR0_6" },
  FLAT1 = { t="STARG3", f="FLAT1" },
  CEIL5_1 = { t="COMPSPAN", f="CEIL5_1" },
  CEIL4_2 = { t="COMPSPAN", f="CEIL4_2" },
  FLOOR0_2 = { t="SP_DUDE2", f="FLOOR0_2" },

  ENDFLAT2 = { f="ENDFLAT2", t="GRAY2"},

  CEIL3_5 = { f="CEIL3_5",  t="SW2SATYR" },

  CEIL4_1 = { f="CEIL4_1",  t="SP_DUDE2" },
  FLOOR1_1  = { f="FLOOR1_1", t="SP_DUDE2" },
  FLAT14  = { f="FLAT14",   t="SP_DUDE2" },

  FLAT19 = { f="FLAT19", t="SKSNAKE2" },

  GATE1 = { f="GATE1", t="SP_DUDE4" },

  -- NOTE: these two floor logos don't exist as flats in Chex 3,
  --       but they _do_ exist as single textures.
  DEM1_1 = { f="DEM1_1", t="SP_DUDE2" },
  DEM1_2 = { f="DEM1_2", t="SP_DUDE2" },
  DEM1_3 = { f="DEM1_3", t="SP_DUDE2" },
  DEM1_4 = { f="DEM1_4", t="SP_DUDE2" },

  FLAT3 = { f="FLAT3", t="COMPSPAN" },
  FLAT4 = { f="FLAT4", t="COMPSPAN" },
  FLAT8 = { f="FLAT8", t="COMPSPAN" },
  FLAT9 = { f="FLAT9", t="COMPSPAN" },


  -- doors --

  COMPSTA1 = { t="COMPSTA1", f="STEP1" },

  BIGDOOR1 = { t="BIGDOOR1", f="FLAT5_6" },
  DOOR1  = { t="DOOR1",    f="FLAT5_6" },
  DOORBLU2 = { t="DOORBLU2", f="FLAT5_6" },

  BRNBIGR   = { t="BRNBIGR",  f="FLAT5_6" },
  BRNBIGL    = { t="BRNBIGL",  f="FLAT5_6" },
  BRNSMAL2 = { t="BRNSMAL2", f="FLAT5_6" },

  BIGDOOR2   = { t="BIGDOOR2", f="ENDFLAT1" },
  BIGDOOR4   = { t="BIGDOOR4", f="FLAT5_6" },
  BIGDOOR5 = { t="BIGDOOR5", f="FLAT2" },
  BIGDOOR6 = { t="BIGDOOR6", f="FLAT2" },

  STARTAN3 = { t="STARTAN3", f="FLAT1" },
  SKINFACE = { t="SKINFACE", f="FLAT1" },

  SKINSCAB = { t="SKINSCAB", f="CEIL5_1" },
  SKINSYMB = { t="SKINSYMB", f="FLAT5_6" },
  SKINTEK1 = { t="SKINTEK1", f="FLAT5_6" },

  DOORRED    = { t="DOORRED", f="CEIL4_1" },
  DOORBLU   = { t="DOORBLU", f="CEIL4_1" },
  DOORYEL = { t="DOORYEL", f="CEIL4_1" },


  -- switches --

  SW2BLUE   = { t="SW2BLUE",  f="STEP1" },
  SW1BRCOM    = { t="SW1BRCOM", f="CEIL3_2" },
  SW1BRN2  = { t="SW1BRN2",  f="FLAT1" },
  SW1METAL     = { t="SW1METAL", f="FLAT1"  },

  SW1COMM    = { t="SW1COMM",  f="FLAT5_6" },
  SW1COMP = { t="SW1COMP",  f="FLAT5_6"  },
  SW1STON1   = { t="SW1STON1", f="FLAT5_6"  },


  -- rails --
  GSTVINE1 = { t="GSTVINE1", rail_h=128 },
  MIDVINE1  = { t="MIDVINE1", rail_h=128 },
  VINE2  = { t="MIDVINE2", rail_h=128 },
  LITE4  = { t="LITE4", rail_h=128 },


  -- liquids --

  FWATER1  = { t="GSTFONT1", f="FWATER1", sane=1 },
  BLOOD1 = { t="FIREMAG1", f="BLOOD1", sane=1 },
  NUKAGE1 = { t="FIREMAG1", f="NUKAGE1", sane=1 },
  LAVA1 = { t="FIREMAG1", f="LAVA1",   sane=1 },


---===========>>


  -- Chex 1 compatibility --

  BLODGR1  = { t="BLODGR1",  f="CEIL4_1" },

  PIPE4 = { t="PIPE4",    f="CEIL3_1" },
  MARBLE2 = { t="MARBLE2",  f="CEIL3_1" },
  STARGR1 = { t="STARGR1",  f="CEIL3_1" },
  NUKEDGE1  = { t="NUKEDGE1", f="CEIL3_1" },
  NUKEPOIS  = { t="NUKEPOIS", f="CEIL3_1" },

  COMPTALL   = { t="COMPTALL", f="FLAT5_6" },

  SLADPOIS  = { t="SLADPOIS", f="CEIL4_1" },
  MARBFAC3 = { t="MARBFAC3", f="FLAT2" },

  SW2WOOD    = { t="SW2WOOD", f="CEIL3_2" },  -- Note: different size!

  HYDROPO1 = { t="HYDROPO1", f="FLAT1" },
  HYDROPO2 = { t="HYDROPO2", f="FLAT1" },
  HYDROPO3 = { t="HYDROPO3", f="FLAT1" },



  CSTOOREST = { f="STOOREST", t="COMPSPAN" },

  -- better tops on these
  CRATE1   = { t="CRATE1",   f="CRATOP2" },
  CRATE2   = { t="CRATE2",   f="CRATOP1" },
  CRATELIT = { t="CRATELIT", f="CRATOP1" },
  CRATWIDE = { t="CRATWIDE", f="CRATOP1" },

  ---- these two textures are not present in Chex 3
  -- GRAY_FLOWER1 = { t="STONE3", f="FLAT5_6" }
  -- GRAY_FLOWER2 = { t="STONE3", f="FLAT5_6" }


  -- Chex 2 compatibility --

  HEDGE  = { t="HEDGE",  f="HEDGEF" },
  HEDGEF  = { t="HEDGE",  f="HEDGEF" },
  MUSEUM  = { t="MUSEUM", f="BROWN" },

  SEWER1  = { t="SEWER1",   f="ENDFLAT2" },
  SEWER2 = { t="SEWER2",   f="ENDFLAT2" },
  SEWER4   = { t="SEWER4",   f="ENDFLAT2" },
  WORMHOL3  = { t="WORMHOL3", f="ENDFLAT2" },

  BROWN144  = { t="BROWN144", f="CEIL5_1" }, -- no good flat!
  PLUSH    = { t="PLUSH", f="CFLAT2" },  -- texture not present in Chex 3

  THEAWALL = { t="THEAWALL", f="CFLAT2" },

  MOVIE2A    = { t="MOVIE2A", f="CEIL5_1" },
  MOVIE1A   = { t="MOVIE1A", f="CEIL5_1" },
  MOVIE3A = { t="MOVIE3A", f="CEIL5_1" },

  CHEXAD1 = { t="CHEXAD1", f="CEIL5_1" },
  CHEXAD2 = { t="CHEXAD2", f="CEIL5_1" },
  HUNGRY = { t="HUNGRY",  f="FLAT1" },

  MONA    = { t="MONA",     f="CEIL5_1" },
  VENUSHS   = { t="VENUSHS",  f="CEIL5_1" },
  VINCENT = { t="VINCENT",  f="CEIL5_1" },
  MUNCH  = { t="MUNCH",    f="CEIL5_1" },
  SW1STRTN     = { t="SW1STRTN", f="CEIL5_1" },
  ART2  = { t="ART2",     f="CEIL5_1" },

  CHEXCITY    = { t="CHEXCITY", f="CEIL5_1" },  -- Note: now has windows on top
  SPDOOR = { t="SPDOOR",   f="CEIL5_1" },
  SPACPORT = { t="SPACPORT", f="CEIL5_1" }, -- Note: now has windows on top
  NUKE24 = { t="NUKE24",   f="CEIL5_1" },

  DINESIGN    = { t="DINESIGN", f="CEIL5_1" },  -- Note: now has windows on top
  MUSEUM2   = { t="MUSEUM2",  f="CEIL5_1" },
  SEWER3    = { t="SEWER3",   f="ENDFLAT2" },
  CINEMA   = { t="CINEMA",   f="CEIL5_1" },

  POSTER1 = { t="POSTER1", f="FLOOR1_1" },
  POSTER2 = { t="POSTER2", f="FLOOR1_1" },
  POSTER3 = { t="POSTER3", f="FLOOR1_1" },
  CARPET_A   = { t="CARPET_A", f="FLOOR1_1" },  -- texture not present

  THEATRE1 = { t="THEATRE1", f="FLOOR1_1" }, --\
  THEATRE2 = { t="THEATRE2", f="FLOOR1_1" },  -- Note: on blue walls now
  THEATRE3 = { t="THEATRE3", f="FLOOR1_1" },  --/
  FOODMENU     = { t="FOODMENU", f="FLAT2" },

  CANDY   = { t="CANDY",   f="CEIL5_1" },
  POPCORN = { t="POPCORN", f="CEIL5_1" },

  MUFLOOR2 = { f="MUFLOOR2", t="COMPSPAN" },
  CEIL3_2 = { f="CEIL3_2",  t="SW2SATYR" }, -- flat not present
  SLUGBRIK = { f="SLUGBRIK", t="SEWER1" },


  --- new Chex 1 / 2 stuff ---

  PLUSH = { t="PLUSH", f="CFLAT2" },

  ROCKRED1 = { t="ROCKRED1", f="CEIL5_1" },

  BAZOIK = { t="BAZOIK", f="CEIL3_1" },

  SEWER_A = { t="SEWER_A", f="ENDFLAT2" },
  SEWER_B = { t="SEWER_B", f="ENDFLAT2" },

  ART1  = { t="ART1",  f="CEIL5_1" },

  STONPOIS = { t="STONPOIS", f="FLAT5_6" },  -- NB: 256 units tall
  SUPPORT2 = { t="SUPPORT2", f="FLAT5_6" },  -- 

  STORAGE  = { t="STORAGE",  f="FLAT1" },
  WORMHOL1 = { t="WORMHOL1", f="CEIL3_2" },

  GSTONE2  = { t="GSTONE2", f="FLAT5_6" },

  CJHYDRO1 = { t="CJHYDRO1", f="FLAT5_6" },


  ---- TOTALLY NEW STUFF ----

  -- walls --

  PLAT2 = { t="PLAT2", f="FLOOR1_1" },

  PIPE2 = { t="PIPE2", f="FLAT2" },

  BROWNHUG  = { t="BROWNHUG", f="FLAT5_6" },
  SP_DUDE1   = { t="SP_DUDE1", f="BROWN" },
  ICKDOOR1 = { t="ICKDOOR1", f="BROWN" },
  WOOD1  = { t="WOOD1",    f="BROWN" },

  FIREBLU1 = { t="FIREBLU1", f="CEIL5_1" },
  FIREWALB  = { t="FIREWALB", f="LABFLAT" },
  FIRELAV3  = { t="FIRELAV3", f="FLOOR0_3" },

  ICKWALL3 = { t="ICKWALL3", f="CJFSHIP1" },
  ICKWALL4 = { t="ICKWALL4", f="CJFSHIP1" },

  CJBLUDR0 = { t="CJBLUDR0", f="CJFLOD02" },
  CJCELR01 = { t="CJCELR01", f="CJFLOD01" },
  CJCLIF01 = { t="CJCLIF01", f="CJFCRA03" },
  CJCLIF02 = { t="CJCLIF02", f="CJFCRA03" },
  CJCRAT01 = { t="CJCRAT01", f="CJFCRA03" },
  CJCRAT02 = { t="CJCRAT02", f="CJFCRA03" },
  CJCRAT03 = { t="CJCRAT03", f="CJFCRA03" },
  CJCRAT04 = { t="CJCRAT04", f="CJFCRA03" },
  CJCRAT05 = { t="CJCRAT05", f="CJFCRA03" },

  CJCOMM01 = { t="CJCOMM01", f="CJFCOMM1" },
  CJCOMM02 = { t="CJCOMM02", f="CJFCOMM4" },
  CJCOMM03 = { t="CJCOMM03", f="CJFCOMM1" },
  CJCOMM04 = { t="CJCOMM04", f="CJFCOMM1" },
  CJCOMM05 = { t="CJCOMM05", f="CJFCOMM1" },
  CJCOMM06 = { t="CJCOMM06", f="CJFCOMM1" },
  CJCOMM07 = { t="CJCOMM07", f="CJFCOMM1" },
  CJCOMM08 = { t="CJCOMM08", f="CJFCOMM1" },
  CJCOMM09 = { t="CJCOMM09", f="CJFCOMM1" },
  CJCOMM10 = { t="CJCOMM10", f="CJFCOMM4" },

  CJCOMM11 = { t="CJCOMM11", f="CJFCOMM1" },
  CJCOMM12 = { t="CJCOMM12", f="CJFCOMM1" },
  CJCOMM13 = { t="CJCOMM13", f="CJFCOMM1" },
  CJCOMM14 = { t="CJCOMM14", f="CJFCOMM1" },
  CJCOMM15 = { t="CJCOMM15", f="CJFCOMM1" },
  CJCOMM16 = { t="CJCOMM16", f="CJFCOMM1" },
  CJCOMM17 = { t="CJCOMM17", f="CJFCOMM1" },
  CJCOMM18 = { t="CJCOMM18", f="CJFCOMM1" },
  CJCOMM19 = { t="CJCOMM19", f="CJFCOMM1" },
  CJCOMM20 = { t="CJCOMM20", f="CJFCOMM1" },
  CJCOMM21 = { t="CJCOMM21", f="CJFCOMM1" },
  CJCOMM22 = { t="CJCOMM22", f="CJFCOMM1" },
  CJCOMM23 = { t="CJCOMM23", f="CJFCOMM1" },

  CJDOOR01 = { t="CJDOOR01", f="CJFCOMM3" },
  CJDOOR02 = { t="CJDOOR02", f="CJFCOMM3" },
  CJDOOR03 = { t="CJDOOR03", f="CJFCOMM3" },
  CJDOOR04 = { t="CJDOOR04", f="CJFCOMM3" },
  CJFLDR01 = { t="CJFLDR01", f="CJFFLEM2" },
  CJFLDR02 = { t="CJFLDR02", f="CJFFLEM2" },
  CJFLDR03 = { t="CJFLDR03", f="CJFFLEM2" },
  CJFLDR04 = { t="CJFLDR04", f="CJFFLEM2" },
  CJFLDR05 = { t="CJFLDR05", f="CJFFLEM2" },

  CJLODG01 = { t="CJLODG01", f="CJFLOD02" },
  CJLODG02 = { t="CJLODG02", f="CJFLOD02" },
  CJLODG03 = { t="CJLODG03", f="CJFLOD02" },
  CJLODG04 = { t="CJLODG04", f="CJFLOD02" },
  CJLODG05 = { t="CJLODG05", f="CJFLOD02" },
  CJLODG06 = { t="CJLODG06", f="CJFLOD02" },
  CJLODG07 = { t="CJLODG07", f="CJFLOD02" },
  CJLODG08 = { t="CJLODG08", f="CJFLOD02" },
  CJLODG09 = { t="CJLODG09", f="CJFLOD02" },
  CJLODG10 = { t="CJLODG10", f="CJFLOD02" },
  CJLODG11 = { t="CJLODG11", f="CJFLOD02" },
  CJLODG12 = { t="CJLODG12", f="CJFLOD02" },
  CJLODG13 = { t="CJLODG13", f="CJFLOD02" },
  CJLODG14 = { t="CJLODG14", f="CJFLOD02" },
  CJLODG15 = { t="CJLODG15", f="CJFLOD02" },
  CJLODG16 = { t="CJLODG16", f="CJFLOD02" },
  CJLODG17 = { t="CJLODG17", f="CJFLOD02" },

  CJMETE01 = { t="CJMETE01", f="CJFFLEM1" },
  CJMINE01 = { t="CJMINE01", f="CJFMINE1" },
  CJMINE02 = { t="CJMINE02", f="CJFMINE1" },
  CJREDDR0 = { t="CJREDDR0", f="CJFLOD02" },
  CJSHIP01 = { t="CJSHIP01", f="CJFFLEM2" },
  CJSHIP02 = { t="CJSHIP02", f="CJFSHIP1" },
  CJSHIP03 = { t="CJSHIP03", f="CJFSHIP1" },
  CJSHIP04 = { t="CJSHIP04", f="CJFFLEM2" },
  CJSHIP05 = { t="CJSHIP05", f="CJFFLEM2" },

  CJSPLAT1 = { t="CJSPLAT1", f="CJFCRA02" },
  CJSW1_1  = { t="CJSW1_1",  f="CJFCRA02" },
  CJSW1_2  = { t="CJSW1_2",  f="BROWN" },
  CJTRAI01 = { t="CJTRAI01", f="FLOOR0_6" },
  CJTRAI02 = { t="CJTRAI02", f="FLOOR0_6" },
  CJTRAI03 = { t="CJTRAI03", f="FLOOR0_6" },
  CJTRAI04 = { t="CJTRAI04", f="FLOOR0_6" },
  CJYELDR0 = { t="CJYELDR0", f="CJFLOD02" },

  CJVILL01 = { t="CJVILL01", f="CJFVIL02" },
  CJVILL02 = { t="CJVILL02", f="CJFVIL02" },
  CJVILL03 = { t="CJVILL03", f="CJFVIL02" },
  CJVILL04 = { t="CJVILL04", f="CJFVIL01" },
  CJVILL05 = { t="CJVILL05", f="CJFVIL01" },
  CJVILL06 = { t="CJVILL06", f="CJFVIL02" },
  CJVILL07 = { t="CJVILL07", f="CJFVIL02" },
  CJVILL09 = { t="CJVILL09", f="CJFVIL02" },
  CJVILL10 = { t="CJVILL10", f="CJFVIL02" },
  CJVILL11 = { t="CJVILL11", f="CJFVIL02" },

  CJCOMM24 = { t="CJCOMM24", f="CJFCOMM2" },
  CJCITY01 = { t="CJCITY01", f="CJFCOMM4" },
  CJLOGO1  = { t="CJLOGO1",  f="FLOOR0_2" },
  CJLOGO2  = { t="CJLOGO2",  f="FLOOR0_2" },
  CJSHIPBG = { t="CJSHIPBG", f="CJFSHIP2" },

  -- floors --

  BOOTHF1 = { f="BOOTHF1", t="TEKWALL1" },
  BOOTHF2 = { f="BOOTHF2", t="TEKWALL1" },
  BOOTHF3 = { f="BOOTHF3", t="TEKWALL1" },
  BOOTHF4 = { f="BOOTHF4", t="TEKWALL1" },

  CJFCOMM1 = { f="CJFCOMM1", t="CJCOMM01" },
  CJFCOMM2 = { f="CJFCOMM2", t="CJCOMM04" },
  CJFCOMM3 = { f="CJFCOMM3", t="CJCOMM02" },
  CJFCOMM4 = { f="CJFCOMM4", t="CJCOMM02" },
  CJFCOMM5 = { f="CJFCOMM5", t="SP_FACE1" },
  CJFCOMM6 = { f="CJFCOMM6", t="CJCOMM15" },
  CJFCOMM7 = { f="CJFCOMM7", t="CJCOMM15" },

  CJFCRA01 = { f="CJFCRA01", t="CJCRAT03" },
  CJFCRA02 = { f="CJFCRA02", t="CJCRAT03" },
  CJFCRA03 = { f="CJFCRA03", t="CJCRAT04" },
  CJFFLEM1 = { f="CJFFLEM1", t="CJMETE01" },
  CJFFLEM2 = { f="CJFFLEM2", t="CJMETE01" },
  CJFFLEM3 = { f="CJFFLEM3", t="CJMETE01" },
  CJFGRAS1 = { f="CJFGRAS1", t="CJMETE01" },

  CJFLOD01 = { f="CJFLOD01", t="CJCELR01" },
  CJFLOD02 = { f="CJFLOD02", t="CJLODG03" },
  CJFLOD03 = { f="CJFLOD03", t="CJLODG03" },
  CJFLOD04 = { f="CJFLOD04", t="CJLODG03" },
  CJFLOD05 = { f="CJFLOD05", t="GRAYPOIS" },
  CJFLOD06 = { f="CJFLOD06", t="STONE3" },
  CJFLOD07 = { f="CJFLOD07", t="GRAYPOIS" },
  CJFLOD08 = { f="CJFLOD08", t="CJSHIP02" },
  CJFMINE1 = { f="CJFMINE1", t="CJMINE02" },
  CJFSHIP1 = { f="CJFSHIP1", t="CJSHIP02" },
  CJFSHIP2 = { f="CJFSHIP2", t="CJSHIP02" },
  CJFSHIP3 = { f="CJFSHIP3", t="CJSHIP05" },

  CJFTRA01 = { f="CJFTRA01", t="CJCOMM11" },
  CJFTRA02 = { f="CJFTRA02", t="STEEL64" },
  CJFTRA03 = { f="CJFTRA03", t="GRAYTALL" },
  CJFTRA04 = { f="CJFTRA04", t="GRAYTALL" },
  CJFVIL01 = { f="CJFVIL01", t="CJVILL01" },
  CJFVIL02 = { f="CJFVIL02", t="CJVILL01" },
  CJFVIL03 = { f="CJFVIL03", t="CJVILL01" },
  CJFVIL04 = { f="CJFVIL04", t="CJVILL01" },
  CJFVIL05 = { f="CJFVIL05", t="CJVILL01" },
  CJFVIL06 = { f="CJFVIL06", t="CJVILL01" },

  BAZOIK1 = { f="ENDFLAT3", t="BAZOIK1" },

  FLAT1_1 = { f="FLAT1_1", t="GRAYTALL" },
  FLAT5_8   = { f="FLAT5_8", t="SP_ROCK2" },

  LABFLAT = { f="LABFLAT", t="FIREWALL" },

  STEEL32 = { f="STEEL32", t="SP_DUDE5" },
  STEEL64 = { f="STEEL64", t="SP_DUDE5" },


  -- rails --

  CJVILL08   = { t="CJVILL08", rail_h=128, line_flags=1 },
  TI_GRATE    = { t="TI_GRATE", rail_h=64  },
  LITEMET = { t="LITEMET",  rail_h=128 },
  DOORSTOP = { t="DOORSTOP", rail_h=64},

  SKSPINE1 = { t="SKSPINE1", rail_h=128 },
  STARG1 = { t="STARG1",   rail_h=128 },


  -- other --

  O_BOLT   = { t="SP_ROCK1", f="O_BOLT",   sane=1 },
  O_PILL   = { t="SP_ROCK2", f="O_PILL",   sane=1 },
  O_RELIEF = { t="MIDBRN1",  f="O_RELIEF", sane=1 },
  O_CARVE  = { t="NUKESLAD", f="O_CARVE",  sane=1 },
  O_NEON   = { t="TEKWALL2", f="CEIL4_1",  sane=1 },

}

CHEX3.PREFAB_FIELDS = 
{

}

CHEX3.SKIN_DEFAULTS =
{

}
