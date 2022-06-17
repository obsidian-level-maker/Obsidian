CHEX3.LIQUIDS =
{
  water  = { mat="WATER", light_add=16, special=0 },
  slime0 = { mat="SLIME0", light_add=16, special=16, damage=20 },
  slime1 = { mat="SLIME1", light_add=16, special=16, damage=20 },
  slime2   = { mat="SLIME2", light_add=24, special=16, damage=20 }    
}

CHEX3.MATERIALS =
{
  -- special materials --
  _DEFAULT = { t="COMPSPAN", f="CEIL5_1" },
  _ERROR = { t="COMPSPAN", f="CEIL5_1" },
  _SKY   = { t="COMPSPAN", f="F_SKY1" },
  _LIQUID = { t="GSTFONT1", f="FWATER1" },

  -- materials for generic prefab set --

  -- The idea is to have one singular default material for these; variants should be specified in theme-specific PREFAB_FIELDS tables as replacements - Dasho
  _RUNIC = { t="GRAYDANG", f="CJFSHIP3" },
  _STAIRS = { t="STEP2", f="FLAT5_6" },
  _VOID = { t="REDWALL", f="XX"}, -- Need to be creative with offsets - Dasho
  _FLATLIT = { t="COMPSPAN", f="LABFLAT" },
  _WALLLIT = { t="FIREWALL", f="XX"},
  _LIFT  = { t="COMPSTA1", f="CJFCOMM3" },
  _SBARS = { t="LITEMET", f="XX" }, -- Short bars, i.e. railings
  _MBARS = { t="BARS", f="XX" }, -- Medium bars, i.e. barred windows
  _TBARS = { t="LITE4", f = "XX" }, -- Tall bars, i.e. cage/jail bars
  
  _CRATE   = { t="CRATE1",   f="CRATOP2" }, -- Crate/box
  _CRATE2  = { t="CRATE2",   f="CRATOP1" },
  _CRATWID = { t="CRATWIDE", f="CRATOP1"}, -- Wide crate
    
  _SMLDOOR = { t="SP_DUDE4", f="STEP1" }, -- 64 units wide, around 64 high (Chex Quest will probably require a lot of offset trickery)
  _BIGDOOR = { t="BIGDOOR1", f="FLAT5_6" }, -- 128x128
  _TALDOOR = { t="SP_DUDE4", f="STEP1" },
  _DORRAIL = { t="COMPSTA1", f="STEP1"}, -- Inner door slider thingys
  
  _NPIC    = { t="FIREWALL", f="XX"}, -- Narrow (non-tiling) pic box insert, 64 pixels wide
  
  _MPIC    = { t="ART1", f="XX"}, -- Medium (or tiling) pic box insert, 128 pixels wide
  
  _WPIC    = { t="CHEXAD1", f="XX"}, -- Wide (or tiling) pic box insert, 256 pixels wide

  _KEYTRM1 = { t="DOORRED", f="XX" }, -- Trim for locked door, Key 1
  _KEYTRM2 = { t="DOORYEL", f="XX" }, -- Trim for locked door, Key 2
  _KEYTRM3 = { t="DOORBLU", f="XX" }, -- Trim for locked door, Key 3
  
  _EXITDR = { t="BIGDOOR7", f="FLAT5_6" }, -- Exit door
  _EXITSW = { t="SW1SLAD", f="STEEL32" }, -- Exit switch
  _EXITTR = { t="CEMENT1", f="STEEL32" },
  _EXITRM = { t="CEMENT1", f="STEEL32" }, -- Exit room walls (to match switch)
  _EXITSGN = { t="CQ3_EXIT", f="CJFCOMM3"},
  
  _SW  = { t="SW1COMP",  f="CEIL5_1" }, -- Switch is roughly 32x32 in size, rest of the texture is 'hidden' (Chex needs its own fabs for this because of its switch dimensions)
  _SWTRIM = { t="COMPSPAN",  f="CEIL5_1" }, -- Trim for switch

  _STRUCT = {t="COMPSPAN", f="CEIL5_1"}, -- "Structural" texture (window trim, beams, other areas where a window/floor flat just isn't always right)
  
  _TELE = { f="GATE1", t="SP_DUDE4" }, -- Teleporter

  -- general purpose --

  METAL  = { t="COMPBLUE", f="STEP1" },
  CAVE   = { t="SKSNAKE2", f="CEIL3_1" },
  VENT   = { t="ASHWALL",  f="FLOOR0_3" },
  WHITE  = { t="SW2SATYR", f="FLAT5_6" },
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

  LIFT = { t="SKSNAKE1", f="STEP1" },

  SP_DUDE2    = { t="SP_DUDE2", f="FLOOR0_2" },
  BLUE_OBSDECK = { t="SLADSKUL", f="FLOOR0_2" },
  BLUE_SLIMED  = { t="SKINMET1", f="FLOOR0_2" },

  GRAY_PIPES   = { t="STONE",    f="FLAT5_6" },
  STONE3  = { t="STONE3",   f="FLAT5_6" },
  GRAY_LITE    = { t="LITESTON", f="FLAT5_6" },
  GRAY7  = { t="GRAY7",    f="FLAT5_6" },

  STARG3   = { t="STARG3",   f="FLAT2" },
  ORANGE_LAB    = { t="COMPUTE3", f="FLAT2" },
  ORANGE_SLIMED = { t="SKINMET2", f="FLAT2" },
  ORANGE_CUPBD  = { t="DOOR3",    f="FLAT2" },
  ORANGE_CABNET = { t="CEMENT4",  f="FLAT2" },
  ORANGE_LOCKER = { t="CEMENT6",  f="FLAT2" },

  ORANGE_MATH   = { t="CEMPOIS",  f="FLAT2" },
  ORANGE_BOOKS  = { t="BRNSMALL", f="FLAT2" },
  ORANGE_DIAG   = { t="BRNSMALR", f="FLAT2" },
  ORANGE_MAP    = { t="BROWN96",  f="FLAT2" },

  STEEL1      = { t="CEMENT1",  f="CEIL3_2" },
  CEMENT5      = { t="CEMENT5",  f="CEIL3_2" },
  STEEL_LITE  = { t="LITE96",   f="CEIL3_2" },
  STEEL_GRATE = { t="REDWALL1", f="CEIL3_2" },

  STARPORT  = { t="CEMENT2", f="FLAT5_6" },

  TEKWALL5      = { t="TEKWALL5", f="FLAT1" },
  BROWN      = { t="BROWN1",   f="BROWN" },
  BROWN1      = { t="BROWN1",   f="FLAT1" },
  TAN_LITE  = { t="LITE2",    f="FLAT1" },
  TAN_GRATE = { t="BRNSMAL1", f="FLAT1" },
  TAN_VINE  = { t="BROVINE",  f="FLAT1" },

  COMPUTE_1 = { t="COMP2",    f="FLAT5_6" },
  COMPUTE_2 = { t="COMPUTE2", f="FLAT5_6" },
  COMP_BOX  = { t="COMPWERD", f="FLAT5_6" },
  COMP_SPAN = { t="COMPSPAN", f="FLAT5_6" },

  CUPBOARD = { t="BRNBIGC",  f="FLAT1" },

  CAVE_GLOW    = { t="BLODRIP2", f="CEIL3_1" },
  CAVE_LITE    = { t="SKULWAL3", f="CEIL3_1" },
  CAVE_CRACK   = { t="STARTAN2", f="CEIL3_1" },
  CAVE_SUPPORT = { t="PIPE6",    f="CEIL3_2" },

  PIC_PLANET  = { t="SKINCUT",  f="CEIL4_1" },
  PIC_DIPLOMA = { t="EXITDOOR", f="CEIL4_1" },
  PIC_PHOTO1  = { t="TEKWALL4", f="CEIL4_1" },
  PIC_PHOTO2  = { t="SLADWALL", f="CEIL4_1" },

  TELE_CHAMBER = { t="SLADRIP1", f="FLAT5_6" },

  MET_SLADS = { t="SP_DUDE4", f="STEP1" },

  STEP1 = { t="STEP1", f="FLAT2" },
  STEP_GRAY   = { t="STEP2",    f="FLAT5_6" },
  STEP_WHITE  = { t="SW2SATYR", f="FLAT5_6" },
  STEP_CAVE   = { t="SKSNAKE2", f="CEIL3_1" },


  -- floors --
  
  FLOOR0_6 = { t="GRAYTALL", f="FLOOR0_6" },
  FLAT1 = { t="STARG3", f="FLAT1" },
  CEIL5_1 = { t="COMPSPAN", f="CEIL5_1" },
  CEIL4_2 = { t="COMPSPAN", f="CEIL4_2" },
  FLOOR0_2 = { t="SP_DUDE2", f="FLOOR0_2" },

  ENDFLAT2 = { f="ENDFLAT2", t="GRAY2"},

  CEIL_LITE = { f="CEIL3_5",  t="SW2SATYR" },

  CEIL4_1 = { f="CEIL4_1",  t="SP_DUDE2" },
  ANOTHER_BLUE  = { f="FLOOR1_1", t="SP_DUDE2" },
  FLAT14  = { f="FLAT14",   t="SP_DUDE2" },

  CAVE_POOL = { f="FLAT19", t="SKSNAKE2" },

  TELE_GATE = { f="GATE1", t="SP_DUDE4" },

  DARK_GRAY = { f="CEIL5_1", t="TEKWALL5" },
  RED_FLOOR = { f="FLAT1",   t="SP_DUDE6" },

  -- NOTE: these two floor logos don't exist as flats in Chex 3,
  --       but they _do_ exist as single textures.
  IGC_LOGO_TL = { f="DEM1_1", t="SP_DUDE2" },
  IGC_LOGO_TR = { f="DEM1_2", t="SP_DUDE2" },
  IGC_LOGO_BL = { f="DEM1_3", t="SP_DUDE2" },
  IGC_LOGO_BR = { f="DEM1_4", t="SP_DUDE2" },

  CAFE_LOGO_TL = { f="FLAT3", t="COMPSPAN" },
  CAFE_LOGO_TR = { f="FLAT4", t="COMPSPAN" },
  CAFE_LOGO_BL = { f="FLAT8", t="COMPSPAN" },
  CAFE_LOGO_BR = { f="FLAT9", t="COMPSPAN" },


  -- doors --

  TRACK = { t="COMPSTA1", f="STEP1" },

  DOOR_GRATE = { t="BIGDOOR1", f="FLAT5_6" },
  DOOR_ALUM  = { t="DOOR1",    f="FLAT5_6" },
  DOOR_METER = { t="DOORBLU2", f="FLAT5_6" },

  DOOR_BLUE   = { t="BRNBIGR",  f="FLAT5_6" },
  DOOR_RED    = { t="BRNBIGL",  f="FLAT5_6" },
  DOOR_YELLOW = { t="BRNSMAL2", f="FLAT5_6" },

  BIGDOOR2   = { t="BIGDOOR2", f="ENDFLAT1" },
  DOOR_LAB   = { t="BIGDOOR4", f="FLAT5_6" },
  DOOR_ARBOR = { t="BIGDOOR5", f="FLAT2" },
  DOOR_HYDRO = { t="BIGDOOR6", f="FLAT2" },

  WDOOR_HANGER1 = { t="STARTAN3", f="FLAT1" },
  WDOOR_HANGER2 = { t="SKINFACE", f="FLAT1" },

  WDOOR_ARBOR = { t="SKINSCAB", f="CEIL5_1" },
  WDOOR_MINES = { t="SKINSYMB", f="FLAT5_6" },
  WDOOR_FRIDGE = { t="SKINTEK1", f="FLAT5_6" },

  LITE_RED    = { t="DOORRED", f="CEIL4_1" },
  LITE_BLUE   = { t="DOORBLU", f="CEIL4_1" },
  LITE_YELLOW = { t="DOORYEL", f="CEIL4_1" },


  -- switches --

  SW_METAL   = { t="SW2BLUE",  f="STEP1" },
  SW_CAVE    = { t="SW1BRCOM", f="CEIL3_2" },
  SW_BROWN2  = { t="SW1BRN2",  f="FLAT1" },
  SW_TAN     = { t="SW1METAL", f="FLAT1"  },

  SW_GRAY    = { t="SW1COMM",  f="FLAT5_6" },
  SW_COMPUTE = { t="SW1COMP",  f="FLAT5_6"  },
  SW_PIPEY   = { t="SW1STON1", f="FLAT5_6"  },


  -- rails --
  MIDVINE1  = { t="MIDVINE1", f="BROWN" },
  GSTVINE1 = { t="GSTVINE1", f="BLOOD1"},
  VINE1  = { t="MIDVINE1", rail_h=128 },
  VINE2  = { t="MIDVINE2", rail_h=128 },
  LITE4_RAIL  = { t="LITE4", rail_h=128 },


  -- liquids --

  WATER  = { t="GSTFONT1", f="FWATER1", sane=1 },
  SLIME0 = { t="FIREMAG1", f="BLOOD1", sane=1 },
  SLIME1 = { t="FIREMAG1", f="NUKAGE1", sane=1 },
  SLIME2 = { t="FIREMAG1", f="LAVA1",   sane=1 },


---===========>>


  -- Chex 1 compatibility --

  BLUE_SFALL  = { t="BLODGR1",  f="CEIL4_1" },

  CAVE_SLIMY1 = { t="PIPE4",    f="CEIL3_1" },
  CAVE_SLIMY2 = { t="MARBLE2",  f="CEIL3_1" },
  CAVE_SLIMY3 = { t="STARGR1",  f="CEIL3_1" },
  CAVE_EDGER  = { t="NUKEDGE1", f="CEIL3_1" },
  CAVE_SPLAT  = { t="NUKEPOIS", f="CEIL3_1" },

  COMPUTE_3   = { t="COMPTALL", f="FLAT5_6" },

  PIC_SLIMED  = { t="SLADPOIS", f="CEIL4_1" },
  PIC_STORAGE = { t="MARBFAC3", f="FLAT2" },

  SW_STEEL    = { t="SW2WOOD", f="CEIL3_2" },  -- Note: different size!

  HYDROPON_1 = { t="HYDROPO1", f="FLAT1" },
  HYDROPON_2 = { t="HYDROPO2", f="FLAT1" },
  HYDROPON_3 = { t="HYDROPO3", f="FLAT1" },



  CRUD_LITE = { f="STOOREST", t="COMPSPAN" },

  -- better tops on these
  CRATE1   = { t="CRATE1",   f="CRATOP2" },
  CRATE2   = { t="CRATE2",   f="CRATOP1" },
  CRATEMIX = { t="CRATELIT", f="CRATOP1" },
  CRATWIDE = { t="CRATWIDE", f="CRATOP1" },

  ---- these two textures are not present in Chex 3
  -- GRAY_FLOWER1 = { t="STONE3", f="FLAT5_6" }
  -- GRAY_FLOWER2 = { t="STONE3", f="FLAT5_6" }


  -- Chex 2 compatibility --

  HEDGE  = { t="HEDGE",  f="HEDGEF" },
  HEDGEF  = { t="HEDGE",  f="HEDGEF" },
  BEIGE  = { t="MUSEUM", f="BROWN" },

  GREEN_BRICK  = { t="SEWER1",   f="ENDFLAT2" },
  GREEN_BORDER = { t="SEWER2",   f="ENDFLAT2" },
  GREEN_SIGN   = { t="SEWER4",   f="ENDFLAT2" },
  GREEN_GRATE  = { t="WORMHOL3", f="ENDFLAT2" },

  MARB_GREEN  = { t="BROWN144", f="CEIL5_1" }, -- no good flat!
  MARB_RED    = { t="PLUSH", f="CFLAT2" },  -- texture not present in Chex 3

  RED_CURTAIN = { t="THEAWALL", f="CFLAT2" },

  MOVIE_PRAM    = { t="MOVIE2A", f="CEIL5_1" },
  MOVIE_MOUSE   = { t="MOVIE1A", f="CEIL5_1" },
  MOVIE_CHARLES = { t="MOVIE3A", f="CEIL5_1" },

  PIC_EAT_EM = { t="CHEXAD1", f="CEIL5_1" },
  PIC_LUV_EM = { t="CHEXAD2", f="CEIL5_1" },
  PIC_HUNGRY = { t="HUNGRY",  f="FLAT1" },

  PIC_MONA    = { t="MONA",     f="CEIL5_1" },
  PIC_VENUS   = { t="VENUSHS",  f="CEIL5_1" },
  PIC_VINCENT = { t="VINCENT",  f="CEIL5_1" },
  PIC_SCREAM  = { t="MUNCH",    f="CEIL5_1" },
  PIC_NUN     = { t="SW1STRTN", f="CEIL5_1" },
  PIC_BORING  = { t="ART2",     f="CEIL5_1" },

  SIGN_ENTER    = { t="CHEXCITY", f="CEIL5_1" },  -- Note: now has windows on top
  SIGN_WELCOME1 = { t="SPDOOR",   f="CEIL5_1" },
  SIGN_WELCOME2 = { t="SPACPORT", f="CEIL5_1" }, -- Note: now has windows on top
  SIGN_GALACTIC = { t="NUKE24",   f="CEIL5_1" },

  SIGN_DINER    = { t="DINESIGN", f="CEIL5_1" },  -- Note: now has windows on top
  SIGN_MUSEUM   = { t="MUSEUM2",  f="CEIL5_1" },
  SIGN_SEWER    = { t="SEWER3",   f="ENDFLAT2" },
  SIGN_CINEMA   = { t="CINEMA",   f="CEIL5_1" },

  BLUE_POSTER1 = { t="POSTER1", f="FLOOR1_1" },
  BLUE_POSTER2 = { t="POSTER2", f="FLOOR1_1" },
  BLUE_POSTER3 = { t="POSTER3", f="FLOOR1_1" },
  BLUE_CUPBD   = { t="CARPET_A", f="FLOOR1_1" },  -- texture not present

  TAN_THEATRE1 = { t="THEATRE1", f="FLOOR1_1" }, --\
  TAN_THEATRE2 = { t="THEATRE2", f="FLOOR1_1" },  -- Note: on blue walls now
  TAN_THEATRE3 = { t="THEATRE3", f="FLOOR1_1" },  --/
  TAN_MENU     = { t="FOODMENU", f="FLAT2" },

  BENCH_CANDY   = { t="CANDY",   f="CEIL5_1" },
  BENCH_POPCORN = { t="POPCORN", f="CEIL5_1" },

  GRAY_FLOOR = { f="CJFCOMM3", t="COMPSPAN" },

  BROWN_TILE = { f="MUFLOOR2", t="COMPSPAN" },
  WHITE_TILE = { f="CEIL3_2",  t="SW2SATYR" }, -- flat not present
  GREEN_TILE = { f="SLUGBRIK", t="SEWER1" },
  RED_TILE   = { f="CJFLOD06", t="STONE3" },  -- flat not present, grrr!


  --- new Chex 1 / 2 stuff ---

  PLUSH = { t="PLUSH", f="CFLAT2" },

  CINEMA_FLASHY = { t="ROCKRED1", f="CEIL5_1" },

  CAVE_ROCKY = { t="BAZOIK", f="CEIL3_1" },

  GREEN_PIPE1 = { t="SEWER_A", f="ENDFLAT2" },
  GREEN_PIPE2 = { t="SEWER_B", f="ENDFLAT2" },

  PIC_PAINTING  = { t="ART1",  f="CEIL5_1" },

  BLUE_SLOPE_DN = { t="STONPOIS", f="FLAT5_6" },  -- NB: 256 units tall
  BLUE_SLOPE_UP = { t="SUPPORT2", f="FLAT5_6" },  -- 

  TAN_STORAGE  = { t="STORAGE",  f="FLAT1" },
  STEEL_GRATE2 = { t="WORMHOL1", f="CEIL3_2" },

  STARPORT_METER  = { t="GSTONE2", f="FLAT5_6" },

  WDOOR_HYDRO1 = { t="CJHYDRO1", f="FLAT5_6" },


  ---- TOTALLY NEW STUFF ----

  -- walls --

  CHEX_METRO = { t="PLAT2", f="FLOOR1_1" },

  PIPE_TALL = { t="PIPE2", f="FLAT2" },

  GRAY_BRICKS  = { t="BROWNHUG", f="FLAT5_6" },
  BRICK_WALL   = { t="SP_DUDE1", f="BROWN" },
  BRICK_W_ARCH = { t="ICKDOOR1", f="BROWN" },
  BRICK_W_COL  = { t="WOOD1",    f="BROWN" },

  ANIM_TRAJECT = { t="FIREBLU1", f="CEIL5_1" },
  ANIM_FLOURO  = { t="FIREWALB", f="LABFLAT" },
  ANIM_PLASMA  = { t="FIRELAV3", f="FLOOR0_3" },

  SHIP_WINDOW1 = { t="ICKWALL3", f="CJFSHIP1" },
  SHIP_WINDOW2 = { t="ICKWALL4", f="CJFSHIP1" },

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
  YELLOWISH   = { f="FLAT5_8", t="SP_ROCK2" },

  FLOURO_LITE = { f="LABFLAT", t="FIREWALL" },

  STEEL32 = { f="STEEL32", t="SP_DUDE5" },
  STEEL64 = { f="STEEL64", t="SP_DUDE5" },


  -- rails --

  VILL_BARS   = { t="CJVILL08", rail_h=128, line_flags=1 },
  TI_GRATE    = { t="TI_GRATE", rail_h=64  },
  BRIDGE_RAIL = { t="LITEMET",  rail_h=128 },
  METAL_FENCE = { t="DOORSTOP", rail_h=64},

  CAVE_COLUMN = { t="SKSPINE1", rail_h=128 },
  ORANGE_HOLE = { t="STARG1",   rail_h=128 },


  -- other --

  O_BOLT   = { t="SP_ROCK1", f="O_BOLT",   sane=1 },
  O_PILL   = { t="SP_ROCK2", f="O_PILL",   sane=1 },
  O_RELIEF = { t="MIDBRN1",  f="O_RELIEF", sane=1 },
  O_CARVE  = { t="NUKESLAD", f="O_CARVE",  sane=1 },
  O_NEON   = { t="TEKWALL2", f="CEIL4_1",  sane=1 },

}

CHEX3.PREFAB_FIELDS = 
{
  -- These are used for converting generic linedefs --
  line_700 = 28, -- Key one
  line_701 = 27, -- Key two
  line_702 = 26, -- Key three
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
  thing_11001 = 46, -- Ceiling light
  thing_11002 = 2028, -- Standalone light 
  thing_11003 = 0, -- Wall light (torch)
  thing_11004 = 34, -- Short standalone light
  thing_11005 = 32, -- Small pillar
  thing_11006 = 13, -- Key one
  thing_11007 = 6, -- Key two
  thing_11008 = 5, -- Key three
  thing_11009 = 1, -- P1 Start
  thing_11010 = 2, -- P2 Start
  thing_11011 = 3, -- P3 Start
  thing_11012 = 4, -- P4 Start
  thing_11013 = 14, -- Teleport destination
  thing_11014 = 60, -- Passable ceiling decor
}

CHEX3.SKIN_DEFAULTS =
{

}
