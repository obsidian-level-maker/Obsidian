------------------------------------------------------------------------
--  BASIC DEFINITIONS
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2020-2021 MsrSgtShooterPerson
--  Copyright (C) 2020-2021 Armaetus
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
------------------------------------------------------------------------

-- important global tables
GAME   = {}
PARAM  = {}
STYLE  = {}
LEVEL  = {}
THEME  = {}
SEEDS  = {}

SCRIPTS = {}

EPISODE = {}
PREFABS = {}
GROUPS  = {}
TEMPLATES = {}


-- a place for unfinished stuff
UNFINISHED = {}


-- tables which interface with GUI code
OB_CONFIG = {}

OB_GAMES   = {}
OB_THEMES  = {}
OB_ENGINES = {}
OB_MODULES = {}

-- internationalization / localization
function _(s) return gui.gettext(s) end


-- the default engine (basically Vanilla + limit removing)
OB_ENGINES["nolimit"] =
{
  label = _("Limit Removing"),
  priority = 99
}


-- special theme types, usable by all games
OB_THEMES["original"] =
{
  label = _("Original"),
  priority = 91
}


OB_THEMES["epi"] =
{
  label = _("Episodic"),
  priority = 85
}


OB_THEMES["jumble"] =
{
  label = _("Jumbled Up"),
  priority = 80
}


OB_THEMES["bit_mixed"] =
{
  label = _("Bit Mixed"),
  priority = 81
}


OB_THEMES["psycho"] =
{
  label = _("Psychedelic"),
  priority = -99  -- bottom most
}


-- choices for Length button
LENGTH_CHOICES =
{
  "single",  _("Single Level"),
  "few",     _("A Few Maps"),
  "episode", _("One Episode"),
  "game",    _("Full Game")
}


-- important constants --

-- size of each seed square
SEED_SIZE = 128

-- highest possible Z coord (and lowest, when negative)
EXTREME_H = 32000


-- special value for merging tables
REMOVE_ME = "__REMOVE__"


-- constants for gui.spots_xxx API functions
SPOT_CLEAR    = 0
SPOT_LOW_CEIL = 1
SPOT_WALL     = 2
SPOT_LEDGE    = 3


-- monster and item stuff
MONSTER_QUANTITIES =
{
  rarest = 0.15,
  rarer  = 0.35,
  rare   = 0.7,
  scarce = 1.0,
  few    = 1.3,
  less   = 1.5,
  normal = 2.0,
  more   = 2.5,
  heaps  = 3.0,
  legions = 3.5,
  insane = 4.0,
  deranged = 4.5,
  nuts   = 5.0,
  chaotic = 5.5,
  unhinged = 6.0,
  ludicrous = 6.66
}

MONSTER_KIND_TAB =
{
  none   = 0.1,
  rarest = 0.25,
  rarer  = 0.5,
  rare   = 0.75,
  scarce = 1.0,
  few    = 1.33,
  less   = 1.6,
  normal = 1.9,
  more   = 2.0,
  heaps  = 2.0,
  legions = 2.0,
  insane = 2.0,
  deranged = 2.0,
  nuts   = 2.0,
  chaotic = 2.0,
  unhinged = 2.0,
  ludicrous = 2.0
}

-- weapon max_damage thresholds
-- larger numbers means more monsters are
-- added to the global palette
MONSTER_KIND_JUMPSTART =
{
  default = 5,
  harder = 40,
  tougher = 80,
  fiercer = 160,
  crazier = 240
}

MONSTER_KIND_JUMPSTART_LEVELS =
{
  default = 0,
  harder = 2,
  tougher = 4,
  fiercer = 8,
  crazier = 12
}

BOSS_FACTORS =
{
  easier = 0.30,
  medium = 0.60,
  harder = 1.00
}

HEALTH_FACTORS =
{
  none     = 0,
  scarce   = 0.4,
  less     = 0.64,
  bit_less = 0.8,
  normal   = 1.0,
  bit_more = 1.15, --1.3
  more     = 1.5, --1.6
  heaps    = 2.5
}

AMMO_FACTORS =
{
  none     = 0,
  scarce   = 0.64,
  less     = 0.8,
  bit_less = 0.9,
  normal   = 1.0,
  bit_more = 1.1,
  more     = 1.25,
  heaps    = 1.6
}

SECRET_BONUS_FACTORS =
{
  none     = 0,
  more     = 0.5,
  heaps    = 1,
  heapser  = 2,
  heapsest = 4
}

--

ROOM_SIZE_MULTIPLIER_MIXED_PROBS =
{
  [0.25] = 1,
  [0.5] = 2,
  [0.75] = 3,
  [1] = 3,
  [1.25] = 3,
  [1.5] = 2,
  [2] = 2,
  [4] = 1.5,
  [6] = 1,
  [8] = 1
}

ROOM_AREA_MULTIPLIER_MIXED_PROBS =
{
  [0.15] = 1,
  [0.5] = 2,
  [0.75] = 2,
  [1] = 3,
  [1.5] = 2,
  [2] = 2,
  [4] = 1
}

SIZE_CONSISTENCY_MIXED_PROBS =
{
  strict = 25,
  normal = 75
}

--

PROC_GOTCHA_MAP_SIZES =
{
  large = 30,
  regular = 26,
  small = 22,
  tiny = 16
}

PROC_GOTCHA_STRENGTH_LEVEL =
{
  none        = 0,
  harder      = 2,
  tougher     = 4,
  crazier     = 8,
  nightmarish = 16
}

PROC_GOTCHA_QUANTITY_MULTIPLIER =
{
  ["-75"] = 0.25,
  ["-50"] = 0.5,
  ["-25"] = 0.75,
  none    = 1,
  ["25"]  = 1.25,
  ["50"]  = 1.5,
  ["100"] = 2,
  ["150"] = 3,
  ["200"] = 4,
  ["400"] = 8
}



--
-- styles control quantities of things in each level
--
GLOBAL_STYLE_LIST =
{
  outdoors    = { none=30, few=30, some=30, heaps=7 },
  caves       = { none=25, few=15, some=15, heaps=5 },
  parks       = { none=7 , few=1 , some=1 , heaps=1 },
  liquids     = { none=0,  few=20, some=25, heaps=50 },

  hallways    = { none=0,  few=60, some=30, heaps=10 },
  big_rooms   = { none=15, few=40, some=30, heaps=20 },
  big_outdoor_rooms = { none=15, few=20, some=50, heaps=35},
  teleporters = { none=35, few=50, some=20, heaps=10 },
  steepness   = { none=0,  few=10, some=70, heaps=40 },

  traps       = { none=0,  few=25, some=65, heaps=20 },
  cages       = { none=10, few=20, some=40, heaps=10 },
  secrets     = { none=0,  few=15, some=70, heaps=25 },
  ambushes    = { none=10, few=20, some=50, heaps=10 },

  doors       = { none=0,  few=30, some=60, heaps=5 },
  windows     = { none=0,  few=20, some=80, heaps=30 },
  switches    = { none=15, few=30, some=50, heaps=15 },
  keys        = { none=5,  few=15, some=40, heaps=60 },
  trikeys     = { none=5,  few=40, some=30, heaps=20 },

  scenics     = { none=5,  few=10, some=40, heaps=40},
  park_detail = { none=0,  few=5,  some=10, heaps=30},

  symmetry    = { none=35, few=60, some=20, heaps=10 },
  pictures    = { none=0,  few=10, some=70, heaps=30 },
  barrels     = { none=10, few=50, some=35, heaps=10 },

  beams       = { none=10, few=10, some=20, heaps=5  },
  porches     = { none=0,  few=10, some=60, heaps=30 },
  fences      = { none=10, few=20, some=30, heaps=15 }
  -- PLANNED or UNFINISHED stuff --

  --[[
  cycles      = { none=50, few=0,  some=50, heaps=50 }
  ex_floors   = { none=0,  few=40, some=60, heaps=20 }
  lakes       = { none=0,  few=60, some=0,  heaps=10 }
  islands     = { none=0,  few=60, some=0,  heaps=40 }
  ]]
}


STYLE_CHOICES =
{
  "none",   _("NONE"),
  "rare",   _("Rare"),
  "few",    _("Few"),
  "less",   _("Less"),
  "some",   _("Some"),
  "more",   _("More"),
  "heaps",  _("Heaps"),
  "mixed",  _("Mix It Up")
}


--
-- default parameters (each game can override these settings)
--
GLOBAL_PARAMETERS =
{
  map_limit = 10000,

  step_height = 16,
  jump_height = 24,

  spot_low_h  = 72,
  spot_high_h = 128
}


--
-- prefab stuff
--
GLOBAL_PREFAB_FIELDS =
{
  -- Note the double underscore, since these materials actually
  -- begin with an underscore (like "_WALL" and "_FLOOR").

   tex__WALL   = "?wall",
  flat__WALL   = "?wall",

   tex__OUTER  = "?outer",
  flat__OUTER  = "?outer",

   tex__FLOOR  = "?floor",
  flat__FLOOR  = "?floor",

   tex__CEIL   = "?ceil",
  flat__CEIL   = "?ceil",

   tex__FLOOR2 = "?floor2",
  flat__FLOOR2 = "?floor2",

   tex__CEIL2  = "?ceil2",
  flat__CEIL2  = "?ceil2",

  thing_8166   = "?object",

  line_888     = "?switch_action",

  offset_301   = "?x_offset1",
  offset_302   = "?x_offset2",
  offset_303   = "?x_offset3",
  offset_304   = "?x_offset4",

  offset_401   = "?y_offset1",
  offset_402   = "?y_offset2",
  offset_403   = "?y_offset3",
  offset_404   = "?y_offset4"
}


GLOBAL_SKIN_DEFAULTS =
{
  wall   = "_ERROR",

  fence  = "?wall",
  floor  = "?wall",
  ceil   = "?wall",

  outer  = "?wall",
  floor2 = "?outer",
  ceil2  = "?outer",

  x_offset1 = "",
  x_offset2 = "",
  x_offset3 = "",
  x_offset4 = "",

  y_offset1 = "",
  y_offset2 = "",
  y_offset3 = "",
  y_offset4 = "",

  -- Doom engine stuff
  tag = "",
  light = "",
  object = "",
  switch_action = "",
  scroller = "",

  -- Quake engine stuff
  style = "",
  message = "",
  wait = "",
  targetname = ""
}


-- GL only stuff

LIGHT_GROUPS =
{
  plain = -- neutral color (white or beige)
  {
    prob = 30,
    shades =
    {
      "neutrals"
    }
  },

  monochrome = -- neutral color and one other color
  {
    prob = 50,
    shades =
    {
      "neutrals",
      "hues"
    }
  },

  bichrome = -- neutral color and two other colors
  {
    prob = 25,
    shades =
    {
      "neutrals",
      "hues",
      "hues"
    }
  },

  single = -- completely random color
  {
    prob = 50,
    shades =
    {
      "hues"
    }
  },

  double = -- two completely random colors
  {
    prob = 25,
    shades =
    {
      "hues",
      "hues"
    }
  },

  all = -- the kitchen sink
  {
    prob = 15,
  }
}

LIGHT_COLORS =
{
  neutrals = -- neutral light colors
  {
    white = 10,
    beige = 10
  },

  hues = -- more vibrant light colors
  {
    blue = 10,
    red = 10,
    orange = 10,
    yellow = 10,
    beige = 6,
    green = 10,
    purple = 2
  }
}


---------------------------------------------
--  LineDef Translation for Hexen / ZDoom
---------------------------------------------

-- specials supported by the engine
XLAT_SPEC =
{
  Polyobj_StartLine = { id=1 },
  Polyobj_RotateLeft = { id=2 },
  Polyobj_RotateRight = { id=3 },
  Polyobj_Move = { id=4 },
  Polyobj_ExplicitLine = { id=5 },
  Polyobj_MoveTimes8 = { id=6 },
  Polyobj_DoorSwing = { id=7 },
  Polyobj_DoorSlide = { id=8 },
  Line_Horizon = { id=9 },
  Door_Close = { id=10 },
  Door_Open = { id=11 },
  Door_Raise = { id=12 },
  Door_LockedRaise = { id=13 },
  Door_Animated = { id=14 },
  Autosave = { id=15 },
  Transfer_WallLight = { id=16 },
  Thing_Raise = { id=17 },
  StartConversation = { id=18 },
  Thing_Stop = { id=19 },
  Floor_LowerByValue = { id=20 },
  Floor_LowerToLowest = { id=21 },
  Floor_LowerToNearest = { id=22 },
  Floor_RaiseByValue = { id=23 },
  Floor_RaiseToHighest = { id=24 },
  Floor_RaiseToNearest = { id=25 },
  Stairs_BuildDown = { id=26 },
  Stairs_BuildUp = { id=27 },
  Floor_RaiseAndCrush = { id=28 },
  Pillar_Build = { id=29 },
  Pillar_Open = { id=30 },
  Stairs_BuildDownSync = { id=31 },
  Stairs_BuildUpSync = { id=32 },
  ForceField = { id=33 },
  ClearForceField = { id=34 },
  Floor_RaiseByValueTimes8 = { id=35 },
  Floor_LowerByValueTimes8 = { id=36 },
  Floor_MoveToValue = { id=37 },
  Ceiling_Waggle = { id=38 },
  Teleport_ZombieChanger = { id=39 },
  Ceiling_LowerByValue = { id=40 },
  Ceiling_RaiseByValue = { id=41 },
  Ceiling_CrushAndRaise = { id=42 },
  Ceiling_LowerAndCrush = { id=43 },
  Ceiling_CrushStop = { id=44 },
  Ceiling_CrushRaiseAndStay = { id=45 },
  Floor_CrushStop = { id=46 },
  Ceiling_MoveToValue = { id=47 },
  Sector_Attach3dMidtex = { id=48 },
  GlassBreak = { id=49 },
  ExtraFloor_LightOnly = { id=50 },
  Sector_SetLink = { id=51 },
  Scroll_Wall = { id=52 },
  Line_SetTextureOffset = { id=53 },
  Sector_ChangeFlags = { id=54 },
  Line_SetBlocking = { id=55 },
  Line_SetTextureScale = { id=56 },
  Sector_SetPortal = { id=57 },
  Sector_CopyScroller = { id=58 },
  Polyobj_OR_MoveToSpot = { id=59 },
  Plat_PerpetualRaise = { id=60 },
  Plat_Stop = { id=61 },
  Plat_DownWaitUpStay = { id=62 },
  Plat_DownByValue = { id=63 },
  Plat_UpWaitDownStay = { id=64 },
  Plat_UpByValue = { id=65 },
  Floor_LowerInstant = { id=66 },
  Floor_RaiseInstant = { id=67 },
  Floor_MoveToValueTimes8 = { id=68 },
  Ceiling_MoveToValueTimes8 = { id=69 },
  Teleport = { id=70 },
  Teleport_NoFog = { id=71 },
  ThrustThing = { id=72 },
  DamageThing = { id=73 },
  Teleport_NewMap = { id=74 },
  Teleport_EndGame = { id=75 },
  TeleportOther = { id=76 },
  TeleportGroup = { id=77 },
  TeleportInSector = { id=78 },
  Thing_SetConversation = { id=79 },
  ACS_Execute = { id=80 },
  ACS_Suspend = { id=81 },
  ACS_Terminate = { id=82 },
  ACS_LockedExecute = { id=83 },
  ACS_ExecuteWithResult = { id=84 },
  ACS_LockedExecuteDoor = { id=85 },
  Polyobj_MoveToSpot = { id=86 },
  Polyobj_Stop = { id=87 },
  Polyobj_MoveTo = { id=88 },
  Polyobj_OR_MoveTo = { id=89 },
  Polyobj_OR_RotateLeft = { id=90 },
  Polyobj_OR_RotateRight = { id=91 },
  Polyobj_OR_Move = { id=92 },
  Polyobj_OR_MoveTimes8 = { id=93 },
  Pillar_BuildAndCrush = { id=94 },
  FloorAndCeiling_LowerByValue = { id=95 },
  FloorAndCeiling_RaiseByValue = { id=96 },
  Ceiling_LowerAndCrushDist = { id=97 },
  Sector_SetTranslucent = { id=98 },
  Floor_RaiseAndCrushDoom = { id=99 },
  Scroll_Texture_Left = { id=100 },
  Scroll_Texture_Right = { id=101 },
  Scroll_Texture_Up = { id=102 },
  Scroll_Texture_Down = { id=103 },
  Light_ForceLightning = { id=109 },
  Light_RaiseByValue = { id=110 },
  Light_LowerByValue = { id=111 },
  Light_ChangeToValue = { id=112 },
  Light_Fade = { id=113 },
  Light_Glow = { id=114 },
  Light_Flicker = { id=115 },
  Light_Strobe = { id=116 },
  Light_Stop = { id=117 },
  Plane_Copy = { id=118 },
  Thing_Damage = { id=119 },
  Radius_Quake = { id=120 },
  Line_SetIdentification = { id=121 },
  Thing_Move = { id=125 },
  Thing_SetSpecial = { id=127 },
  ThrustThingZ = { id=128 },
  UsePuzzleItem = { id=129 },
  Thing_Activate = { id=130 },
  Thing_Deactivate = { id=131 },
  Thing_Remove = { id=132 },
  Thing_Destroy = { id=133 },
  Thing_Projectile = { id=134 },
  Thing_Spawn = { id=135 },
  Thing_ProjectileGravity = { id=136 },
  Thing_SpawnNoFog = { id=137 },
  Floor_Waggle = { id=138 },
  Thing_SpawnFacing = { id=139 },
  Sector_ChangeSound = { id=140 },
  Teleport_NoStop = { id=154 },
  SetGlobalFogParameter = { id=157 },
  FS_Execute = { id=158 },
  Sector_SetPlaneReflection = { id=159 },
  Sector_Set3DFloor = { id=160 },
  Sector_SetContents = { id=161 },
  Ceiling_CrushAndRaiseDist = { id=168 },
  Generic_Crusher2 = { id=169 },
  Sector_SetCeilingScale2 = { id=170 },
  Sector_SetFloorScale2 = { id=171 },
  Plat_UpNearestWaitDownStay = { id=172 },
  NoiseAlert = { id=173 },
  SendToCommunicator = { id=174 },
  Thing_ProjectileIntercept = { id=175 },
  Thing_ChangeTID = { id=176 },
  Thing_Hate = { id=177 },
  Thing_ProjectileAimed = { id=178 },
  ChangeSkill = { id=179 },
  Thing_SetTranslation = { id=180 },
  Plane_Align = { id=181 },
  Line_Mirror = { id=182 },
  Line_AlignCeiling = { id=183 },
  Line_AlignFloor = { id=184 },
  Sector_SetRotation = { id=185 },
  Sector_SetCeilingPanning = { id=186 },
  Sector_SetFloorPanning = { id=187 },
  Sector_SetCeilingScale = { id=188 },
  Sector_SetFloorScale = { id=189 },
  Static_Init = { id=190 },
  SetPlayerProperty = { id=191 },
  Ceiling_LowerToHighestFloor = { id=192 },
  Ceiling_LowerInstant = { id=193 },
  Ceiling_RaiseInstant = { id=194 },
  Ceiling_CrushRaiseAndStayA = { id=195 },
  Ceiling_CrushAndRaiseA = { id=196 },
  Ceiling_CrushAndRaiseSilentA = { id=197 },
  Ceiling_RaiseByValueTimes8 = { id=198 },
  Ceiling_LowerByValueTimes8 = { id=199 },
  Generic_Floor = { id=200 },
  Generic_Ceiling = { id=201 },
  Generic_Door = { id=202 },
  Generic_Lift = { id=203 },
  Generic_Stairs = { id=204 },
  Generic_Crusher = { id=205 },
  Plat_DownWaitUpStayLip = { id=206 },
  Plat_PerpetualRaiseLip = { id=207 },
  TranslucentLine = { id=208 },
  Transfer_Heights = { id=209 },
  Transfer_FloorLight = { id=210 },
  Transfer_CeilingLight = { id=211 },
  Sector_SetColor = { id=212 },
  Sector_SetFade = { id=213 },
  Sector_SetDamage = { id=214 },
  Teleport_Line = { id=215 },
  Sector_SetGravity = { id=216 },
  Stairs_BuildUpDoom = { id=217 },
  Sector_SetWind = { id=218 },
  Sector_SetFriction = { id=219 },
  Sector_SetCurrent = { id=220 },
  Scroll_Texture_Both = { id=221 },
  Scroll_Texture_Model = { id=222 },
  Scroll_Floor = { id=223 },
  Scroll_Ceiling = { id=224 },
  Scroll_Texture_Offsets = { id=225 },
  ACS_ExecuteAlways = { id=226 },
  PointPush_SetForce = { id=227 },
  Plat_RaiseAndStayTx0 = { id=228 },
  Thing_SetGoal = { id=229 },
  Plat_UpByValueStayTx = { id=230 },
  Plat_ToggleCeiling = { id=231 },
  Light_StrobeDoom = { id=232 },
  Light_MinNeighbor = { id=233 },
  Light_MaxNeighbor = { id=234 },
  Floor_TransferTrigger = { id=235 },
  Floor_TransferNumeric = { id=236 },
  ChangeCamera = { id=237 },
  Floor_RaiseToLowestCeiling = { id=238 },
  Floor_RaiseByValueTxTy = { id=239 },
  Floor_RaiseByTexture = { id=240 },
  Floor_LowerToLowestTxTy = { id=241 },
  Floor_LowerToHighest = { id=242 },
  Exit_Normal = { id=243 },
  Exit_Secret = { id=244 },
  Elevator_RaiseToNearest = { id=245 },
  Elevator_MoveToFloor = { id=246 },
  Elevator_LowerToNearest = { id=247 },
  HealThing = { id=248 },
  Door_CloseWaitOpen = { id=249 },
  Floor_Donut = { id=250 },
  FloorAndCeiling_LowerRaise = { id=251 },
  Ceiling_RaiseToNearest = { id=252 },
  Ceiling_LowerToLowest = { id=253 },
  Ceiling_LowerToFloor = { id=254 },
  Ceiling_CrushRaiseAndStaySilA = { id=255 },
}

-- various constants
XC =
{
  CEILWAIT = 150,
  DOORWAIT = 150,
  PLATWAIT = 105,

  ELEVATORSPEED = 32,
  DONUTSPEED    = 4,
  SCROLLSPEED   = 64,

  INIT_GRAVITY = 0,
  INIT_COLOR   = 1,
  INIT_DAMAGE  = 2,
  INIT_SKY     = 255,

  C_SLOW   = 8,
  C_NORMAL = 16,
  C_FAST   = 32,
  C_TURBO  = 64,

  F_SLOW   = 8,
  F_NORMAL = 16,
  F_FAST   = 32,
  F_TURBO  = 64,

  D_SLOW   = 16,
  D_NORMAL = 32,
  D_FAST   = 64,
  D_TURBO  = 128,

  ST_SLOW   = 2,
  ST_NORMAL = 4,
  ST_FAST   = 16,
  ST_TURBO  = 32,

  P_CRAWL  = 4,
  P_SLOW   = 8,
  P_NORMAL = 16,
  P_FAST   = 32,
  P_TURBO  = 64,

  KEY_NONE   = 0,
  KEY_RED    = 129,
  KEY_BLUE   = 130,
  KEY_YELLOW = 131,
}
