
---------------------------------------------
--  LineDef Translation for Hexen / ZDoom
---------------------------------------------

-- specials supported by the engine
XLAT_SPEC =
{
  Polyobj_StartLine = { id=1 }
  Polyobj_RotateLeft = { id=2 }
  Polyobj_RotateRight = { id=3 }
  Polyobj_Move = { id=4 }
  Polyobj_ExplicitLine = { id=5 }
  Polyobj_MoveTimes8 = { id=6 }
  Polyobj_DoorSwing = { id=7 }
  Polyobj_DoorSlide = { id=8 }
  Line_Horizon = { id=9 }
  Door_Close = { id=10 }
  Door_Open = { id=11 }
  Door_Raise = { id=12 }
  Door_LockedRaise = { id=13 }
  Door_Animated = { id=14 }
  Autosave = { id=15 }
  Transfer_WallLight = { id=16 }
  Thing_Raise = { id=17 }
  StartConversation = { id=18 }
  Thing_Stop = { id=19 }
  Floor_LowerByValue = { id=20 }
  Floor_LowerToLowest = { id=21 }
  Floor_LowerToNearest = { id=22 }
  Floor_RaiseByValue = { id=23 }
  Floor_RaiseToHighest = { id=24 }
  Floor_RaiseToNearest = { id=25 }
  Stairs_BuildDown = { id=26 }
  Stairs_BuildUp = { id=27 }
  Floor_RaiseAndCrush = { id=28 }
  Pillar_Build = { id=29 }
  Pillar_Open = { id=30 }
  Stairs_BuildDownSync = { id=31 }
  Stairs_BuildUpSync = { id=32 }
  ForceField = { id=33 }
  ClearForceField = { id=34 }
  Floor_RaiseByValueTimes8 = { id=35 }
  Floor_LowerByValueTimes8 = { id=36 }
  Floor_MoveToValue = { id=37 }
  Ceiling_Waggle = { id=38 }
  Teleport_ZombieChanger = { id=39 }
  Ceiling_LowerByValue = { id=40 }
  Ceiling_RaiseByValue = { id=41 }
  Ceiling_CrushAndRaise = { id=42 }
  Ceiling_LowerAndCrush = { id=43 }
  Ceiling_CrushStop = { id=44 }
  Ceiling_CrushRaiseAndStay = { id=45 }
  Floor_CrushStop = { id=46 }
  Ceiling_MoveToValue = { id=47 }
  Sector_Attach3dMidtex = { id=48 }
  GlassBreak = { id=49 }
  ExtraFloor_LightOnly = { id=50 }
  Sector_SetLink = { id=51 }
  Scroll_Wall = { id=52 }
  Line_SetTextureOffset = { id=53 }
  Sector_ChangeFlags = { id=54 }
  Line_SetBlocking = { id=55 }
  Line_SetTextureScale = { id=56 }
  Sector_SetPortal = { id=57 }
  Sector_CopyScroller = { id=58 }
  Polyobj_OR_MoveToSpot = { id=59 }
  Plat_PerpetualRaise = { id=60 }
  Plat_Stop = { id=61 }
  Plat_DownWaitUpStay = { id=62 }
  Plat_DownByValue = { id=63 }
  Plat_UpWaitDownStay = { id=64 }
  Plat_UpByValue = { id=65 }
  Floor_LowerInstant = { id=66 }
  Floor_RaiseInstant = { id=67 }
  Floor_MoveToValueTimes8 = { id=68 }
  Ceiling_MoveToValueTimes8 = { id=69 }
  Teleport = { id=70 }
  Teleport_NoFog = { id=71 }
  ThrustThing = { id=72 }
  DamageThing = { id=73 }
  Teleport_NewMap = { id=74 }
  Teleport_EndGame = { id=75 }
  TeleportOther = { id=76 }
  TeleportGroup = { id=77 }
  TeleportInSector = { id=78 }
  Thing_SetConversation = { id=79 }
  ACS_Execute = { id=80 }
  ACS_Suspend = { id=81 }
  ACS_Terminate = { id=82 }
  ACS_LockedExecute = { id=83 }
  ACS_ExecuteWithResult = { id=84 }
  ACS_LockedExecuteDoor = { id=85 }
  Polyobj_MoveToSpot = { id=86 }
  Polyobj_Stop = { id=87 }
  Polyobj_MoveTo = { id=88 }
  Polyobj_OR_MoveTo = { id=89 }
  Polyobj_OR_RotateLeft = { id=90 }
  Polyobj_OR_RotateRight = { id=91 }
  Polyobj_OR_Move = { id=92 }
  Polyobj_OR_MoveTimes8 = { id=93 }
  Pillar_BuildAndCrush = { id=94 }
  FloorAndCeiling_LowerByValue = { id=95 }
  FloorAndCeiling_RaiseByValue = { id=96 }
  Ceiling_LowerAndCrushDist = { id=97 }
  Sector_SetTranslucent = { id=98 }
  Floor_RaiseAndCrushDoom = { id=99 }
  Scroll_Texture_Left = { id=100 }
  Scroll_Texture_Right = { id=101 }
  Scroll_Texture_Up = { id=102 }
  Scroll_Texture_Down = { id=103 }
  Light_ForceLightning = { id=109 }
  Light_RaiseByValue = { id=110 }
  Light_LowerByValue = { id=111 }
  Light_ChangeToValue = { id=112 }
  Light_Fade = { id=113 }
  Light_Glow = { id=114 }
  Light_Flicker = { id=115 }
  Light_Strobe = { id=116 }
  Light_Stop = { id=117 }
  Plane_Copy = { id=118 }
  Thing_Damage = { id=119 }
  Radius_Quake = { id=120 }
  Line_SetIdentification = { id=121 }
  Thing_Move = { id=125 }
  Thing_SetSpecial = { id=127 }
  ThrustThingZ = { id=128 }
  UsePuzzleItem = { id=129 }
  Thing_Activate = { id=130 }
  Thing_Deactivate = { id=131 }
  Thing_Remove = { id=132 }
  Thing_Destroy = { id=133 }
  Thing_Projectile = { id=134 }
  Thing_Spawn = { id=135 }
  Thing_ProjectileGravity = { id=136 }
  Thing_SpawnNoFog = { id=137 }
  Floor_Waggle = { id=138 }
  Thing_SpawnFacing = { id=139 }
  Sector_ChangeSound = { id=140 }
  Teleport_NoStop = { id=154 }
  SetGlobalFogParameter = { id=157 }
  FS_Execute = { id=158 }
  Sector_SetPlaneReflection = { id=159 }
  Sector_Set3DFloor = { id=160 }
  Sector_SetContents = { id=161 }
  Ceiling_CrushAndRaiseDist = { id=168 }
  Generic_Crusher2 = { id=169 }
  Sector_SetCeilingScale2 = { id=170 }
  Sector_SetFloorScale2 = { id=171 }
  Plat_UpNearestWaitDownStay = { id=172 }
  NoiseAlert = { id=173 }
  SendToCommunicator = { id=174 }
  Thing_ProjectileIntercept = { id=175 }
  Thing_ChangeTID = { id=176 }
  Thing_Hate = { id=177 }
  Thing_ProjectileAimed = { id=178 }
  ChangeSkill = { id=179 }
  Thing_SetTranslation = { id=180 }
  Plane_Align = { id=181 }
  Line_Mirror = { id=182 }
  Line_AlignCeiling = { id=183 }
  Line_AlignFloor = { id=184 }
  Sector_SetRotation = { id=185 }
  Sector_SetCeilingPanning = { id=186 }
  Sector_SetFloorPanning = { id=187 }
  Sector_SetCeilingScale = { id=188 }
  Sector_SetFloorScale = { id=189 }
  Static_Init = { id=190 }
  SetPlayerProperty = { id=191 }
  Ceiling_LowerToHighestFloor = { id=192 }
  Ceiling_LowerInstant = { id=193 }
  Ceiling_RaiseInstant = { id=194 }
  Ceiling_CrushRaiseAndStayA = { id=195 }
  Ceiling_CrushAndRaiseA = { id=196 }
  Ceiling_CrushAndRaiseSilentA = { id=197 }
  Ceiling_RaiseByValueTimes8 = { id=198 }
  Ceiling_LowerByValueTimes8 = { id=199 }
  Generic_Floor = { id=200 }
  Generic_Ceiling = { id=201 }
  Generic_Door = { id=202 }
  Generic_Lift = { id=203 }
  Generic_Stairs = { id=204 }
  Generic_Crusher = { id=205 }
  Plat_DownWaitUpStayLip = { id=206 }
  Plat_PerpetualRaiseLip = { id=207 }
  TranslucentLine = { id=208 }
  Transfer_Heights = { id=209 }
  Transfer_FloorLight = { id=210 }
  Transfer_CeilingLight = { id=211 }
  Sector_SetColor = { id=212 }
  Sector_SetFade = { id=213 }
  Sector_SetDamage = { id=214 }
  Teleport_Line = { id=215 }
  Sector_SetGravity = { id=216 }
  Stairs_BuildUpDoom = { id=217 }
  Sector_SetWind = { id=218 }
  Sector_SetFriction = { id=219 }
  Sector_SetCurrent = { id=220 }
  Scroll_Texture_Both = { id=221 }
  Scroll_Texture_Model = { id=222 }
  Scroll_Floor = { id=223 }
  Scroll_Ceiling = { id=224 }
  Scroll_Texture_Offsets = { id=225 }
  ACS_ExecuteAlways = { id=226 }
  PointPush_SetForce = { id=227 }
  Plat_RaiseAndStayTx0 = { id=228 }
  Thing_SetGoal = { id=229 }
  Plat_UpByValueStayTx = { id=230 }
  Plat_ToggleCeiling = { id=231 }
  Light_StrobeDoom = { id=232 }
  Light_MinNeighbor = { id=233 }
  Light_MaxNeighbor = { id=234 }
  Floor_TransferTrigger = { id=235 }
  Floor_TransferNumeric = { id=236 }
  ChangeCamera = { id=237 }
  Floor_RaiseToLowestCeiling = { id=238 }
  Floor_RaiseByValueTxTy = { id=239 }
  Floor_RaiseByTexture = { id=240 }
  Floor_LowerToLowestTxTy = { id=241 }
  Floor_LowerToHighest = { id=242 }
  Exit_Normal = { id=243 }
  Exit_Secret = { id=244 }
  Elevator_RaiseToNearest = { id=245 }
  Elevator_MoveToFloor = { id=246 }
  Elevator_LowerToNearest = { id=247 }
  HealThing = { id=248 }
  Door_CloseWaitOpen = { id=249 }
  Floor_Donut = { id=250 }
  FloorAndCeiling_LowerRaise = { id=251 }
  Ceiling_RaiseToNearest = { id=252 }
  Ceiling_LowerToLowest = { id=253 }
  Ceiling_LowerToFloor = { id=254 }
  Ceiling_CrushRaiseAndStaySilA = { id=255 }
}

-- various constants
XC =
{
  CEILWAIT = 150
  DOORWAIT = 150
  PLATWAIT = 105

  ELEVATORSPEED = 32
  DONUTSPEED    = 4
  SCROLLSPEED   = 64

  INIT_GRAVITY = 0
  INIT_COLOR   = 1
  INIT_DAMAGE  = 2
  INIT_SKY     = 255

  C_SLOW   = 8
  C_NORMAL = 16
  C_FAST   = 32
  C_TURBO  = 64
 
  F_SLOW   = 8
  F_NORMAL = 16
  F_FAST   = 32
  F_TURBO  = 64

  D_SLOW   = 16
  D_NORMAL = 32
  D_FAST   = 64
  D_TURBO  = 128
 
  ST_SLOW   = 2
  ST_NORMAL = 4
  ST_FAST   = 16
  ST_TURBO  = 32
 
  P_SLOW   = 8
  P_NORMAL = 16
  P_FAST   = 32
  P_TURBO  = 64

  KEY_NONE   = 0
  KEY_RED    = 129
  KEY_BLUE   = 130
  KEY_YELLOW = 131
}

-- translation from DOOM specials
XLAT =
{
  [  1] = { act="SRm",name="Door_Raise", (0, XC.D_SLOW, XC.DOORWAIT, tag) }
  [  2] = { act="W",  name="Door_Open", (tag, XC.D_SLOW) }
  [  3] = { act="W",  name="Door_Close", (tag, XC.D_SLOW) }
  [  4] = { act="Wm", name="Door_Raise", (tag, XC.D_SLOW, XC.DOORWAIT) }
  [  5] = { act="W",  name="Floor_RaiseToLowestCeiling", (tag, XC.F_SLOW) }
  [  6] = { act="W",  name="Ceiling_CrushAndRaiseA", (tag, XC.C_NORMAL, XC.C_NORMAL, 10) }
  [  7] = { act="S",  name="Stairs_BuildUpDoom", (tag, XC.ST_SLOW, 8) }
  [  8] = { act="W",  name="Stairs_BuildUpDoom", (tag, XC.ST_SLOW, 8) }
  [  9] = { act="S",  name="Floor_Donut", (tag, XC.DONUTSPEED, XC.DONUTSPEED) }
  [ 10] = { act="Wm", name="Plat_DownWaitUpStayLip", (tag, XC.P_FAST, XC.PLATWAIT, 0) }
  [ 11] = { act="S",  name="Exit_Normal", (0) }
  [ 12] = { act="W",  name="Light_MaxNeighbor", (tag) }
  [ 13] = { act="W",  name="Light_ChangeToValue", (tag, 255) }
  [ 14] = { act="S",  name="Plat_UpByValueStayTx", (tag, XC.P_SLOW/2, 4) }
  [ 15] = { act="S",  name="Plat_UpByValueStayTx", (tag, XC.P_SLOW/2, 3) }
  [ 16] = { act="W",  name="Door_CloseWaitOpen", (tag, XC.D_SLOW, 240) }
  [ 17] = { act="W",  name="Light_StrobeDoom", (tag, 5, 35) }
  [ 18] = { act="S",  name="Floor_RaiseToNearest", (tag, XC.F_SLOW) }
  [ 19] = { act="W",  name="Floor_LowerToHighest", (tag, XC.F_SLOW, 128) }
  [ 20] = { act="S",  name="Plat_RaiseAndStayTx0", (tag, XC.P_SLOW/2) }
  [ 21] = { act="S",  name="Plat_DownWaitUpStayLip", (tag, XC.P_FAST, XC.PLATWAIT) }
  [ 22] = { act="W",  name="Plat_RaiseAndStayTx0", (tag, XC.P_SLOW/2) }
  [ 23] = { act="S",  name="Floor_LowerToLowest", (tag, XC.F_SLOW) }
  [ 24] = { act="G",  name="Floor_RaiseToLowestCeiling", (tag, XC.F_SLOW) }
  [ 25] = { act="W",  name="Ceiling_CrushAndRaiseA", (tag, XC.C_SLOW, XC.C_SLOW, 10) }
  [ 26] = { act="SR", name="Door_LockedRaise", (0, XC.D_SLOW, XC.DOORWAIT, XC.KEY_BLUE, tag) }
  [ 27] = { act="SR", name="Door_LockedRaise", (0, XC.D_SLOW, XC.DOORWAIT, XC.KEY_YELLOW, tag) }
  [ 28] = { act="SR", name="Door_LockedRaise", (0, XC.D_SLOW, XC.DOORWAIT, XC.KEY_RED, tag) }
  [ 29] = { act="S",  name="Door_Raise", (tag, XC.D_SLOW, XC.DOORWAIT) }
  [ 30] = { act="W",  name="Floor_RaiseByTexture", (tag, XC.F_SLOW) }
  [ 31] = { act="S",  name="Door_Open", (0, XC.D_SLOW, tag) }
  [ 32] = { act="Sm", name="Door_LockedRaise", (0, XC.D_SLOW, 0, XC.KEY_BLUE, tag) }
  [ 33] = { act="Sm", name="Door_LockedRaise", (0, XC.D_SLOW, 0, XC.KEY_RED, tag) }
  [ 34] = { act="Sm", name="Door_LockedRaise", (0, XC.D_SLOW, 0, XC.KEY_YELLOW, tag) }
  [ 35] = { act="W",  name="Light_ChangeToValue", (tag, 35) }
  [ 36] = { act="W",  name="Floor_LowerToHighest", (tag, XC.F_FAST, 136) }
  [ 37] = { act="W",  name="Floor_LowerToLowestTxTy", (tag, XC.F_SLOW) }
  [ 38] = { act="W",  name="Floor_LowerToLowest", (tag, XC.F_SLOW) }
  [ 39] = { act="Wm", name="Teleport", (0, tag) }
  [ 40] = { act="W",  name="Generic_Ceiling", (tag, XC.C_SLOW, 0, 1, 8) }
  [ 41] = { act="S",  name="Ceiling_LowerToFloor", (tag, XC.C_SLOW) }
  [ 42] = { act="SR", name="Door_Close", (tag, XC.D_SLOW) }
  [ 43] = { act="SR", name="Ceiling_LowerToFloor", (tag, XC.C_SLOW) }
  [ 44] = { act="W",  name="Ceiling_LowerAndCrush", (tag, XC.C_SLOW, 0, 2) }
  [ 45] = { act="SR", name="Floor_LowerToHighest", (tag, XC.F_SLOW, 128) }
  [ 46] = { act="GRm",name="Door_Open", (tag, XC.D_SLOW) }
  [ 47] = { act="G",  name="Plat_RaiseAndStayTx0", (tag, XC.P_SLOW/2) }
  [ 48] = { act="",   name="Scroll_Texture_Left", (XC.SCROLLSPEED) }
  [ 49] = { act="S",  name="Ceiling_CrushAndRaiseDist", (tag, 8, XC.C_SLOW, 10) }
  [ 50] = { act="S",  name="Door_Close", (tag, XC.D_SLOW) }
  [ 51] = { act="S",  name="Exit_Secret", (0) }
  [ 52] = { act="W",  name="Exit_Normal", (0) }
  [ 53] = { act="W",  name="Plat_PerpetualRaiseLip", (tag, XC.P_SLOW, XC.PLATWAIT, 0) }
  [ 54] = { act="W",  name="Plat_Stop", (tag) }
  [ 55] = { act="S",  name="Floor_RaiseAndCrushDoom", (tag, XC.F_SLOW, 10, 2) }
  [ 56] = { act="W",  name="Floor_RaiseAndCrushDoom", (tag, XC.F_SLOW, 10, 2) }
  [ 57] = { act="W",  name="Ceiling_CrushStop", (tag) }
  [ 58] = { act="W",  name="Floor_RaiseByValue", (tag, XC.F_SLOW, 24) }
  [ 59] = { act="W",  name="Floor_RaiseByValueTxTy", (tag, XC.F_SLOW, 24) }
  [ 60] = { act="SR", name="Floor_LowerToLowest", (tag, XC.F_SLOW) }
  [ 61] = { act="SR", name="Door_Open", (tag, XC.D_SLOW) }
  [ 62] = { act="SR", name="Plat_DownWaitUpStayLip", (tag, XC.P_FAST, XC.PLATWAIT, 0) }
  [ 63] = { act="SR", name="Door_Raise", (tag, XC.D_SLOW, XC.DOORWAIT) }
  [ 64] = { act="SR", name="Floor_RaiseToLowestCeiling", (tag, XC.F_SLOW) }
  [ 65] = { act="SR", name="Floor_RaiseAndCrushDoom", (tag, XC.F_SLOW, 10, 2) }
  [ 66] = { act="SR", name="Plat_UpByValueStayTx", (tag, XC.P_SLOW/2, 3) }
  [ 67] = { act="SR", name="Plat_UpByValueStayTx", (tag, XC.P_SLOW/2, 4) }
  [ 68] = { act="SR", name="Plat_RaiseAndStayTx0", (tag, XC.P_SLOW/2) }
  [ 69] = { act="SR", name="Floor_RaiseToNearest", (tag, XC.F_SLOW) }
  [ 70] = { act="SR", name="Floor_LowerToHighest", (tag, XC.F_FAST, 136) }
  [ 71] = { act="S",  name="Floor_LowerToHighest", (tag, XC.F_FAST, 136) }
  [ 72] = { act="WR", name="Ceiling_LowerAndCrush", (tag, XC.C_SLOW, 0, 2) }
  [ 73] = { act="WR", name="Ceiling_CrushAndRaiseA", (tag, XC.C_SLOW, XC.C_SLOW, 10) }
  [ 74] = { act="WR", name="Ceiling_CrushStop", (tag) }
  [ 75] = { act="WR", name="Door_Close", (tag, XC.D_SLOW) }
  [ 76] = { act="WR", name="Door_CloseWaitOpen", (tag, XC.D_SLOW, 240) }
  [ 77] = { act="WR", name="Ceiling_CrushAndRaiseA", (tag, XC.C_NORMAL, XC.C_NORMAL, 10) }
  [ 78] = { act="SR", name="Floor_TransferNumeric", (tag)  }
  [ 79] = { act="WR", name="Light_ChangeToValue", (tag, 35) }
  [ 80] = { act="WR", name="Light_MaxNeighbor", (tag) }
  [ 81] = { act="WR", name="Light_ChangeToValue", (tag, 255) }
  [ 82] = { act="WR", name="Floor_LowerToLowest", (tag, XC.F_SLOW) }
  [ 83] = { act="WR", name="Floor_LowerToHighest", (tag, XC.F_SLOW, 128) }
  [ 84] = { act="WR", name="Floor_LowerToLowestTxTy", (tag, XC.F_SLOW) }
  [ 85] = { act="",   name="Scroll_Texture_Right", (XC.SCROLLSPEED) }
  [ 86] = { act="WR", name="Door_Open", (tag, XC.D_SLOW) }
  [ 87] = { act="WR", name="Plat_PerpetualRaiseLip", (tag, XC.P_SLOW, XC.PLATWAIT, 0) }
  [ 88] = { act="WRm",name="Plat_DownWaitUpStayLip", (tag, XC.P_FAST, XC.PLATWAIT, 0) }
  [ 89] = { act="WR", name="Plat_Stop", (tag) }
  [ 90] = { act="WR", name="Door_Raise", (tag, XC.D_SLOW, XC.DOORWAIT) }
  [ 91] = { act="WR", name="Floor_RaiseToLowestCeiling", (tag, XC.F_SLOW) }
  [ 92] = { act="WR", name="Floor_RaiseByValue", (tag, XC.F_SLOW, 24) }
  [ 93] = { act="WR", name="Floor_RaiseByValueTxTy", (tag, XC.F_SLOW, 24) }
  [ 94] = { act="WR", name="Floor_RaiseAndCrushDoom", (tag, XC.F_SLOW, 10, 2) }
  [ 95] = { act="WR", name="Plat_RaiseAndStayTx0", (tag, XC.P_SLOW/2) }
  [ 96] = { act="WR", name="Floor_RaiseByTexture", (tag, XC.F_SLOW) }
  [ 97] = { act="WRm",name="Teleport", (0, tag) }
  [ 98] = { act="WR", name="Floor_LowerToHighest", (tag, XC.F_FAST, 136) }
  [ 99] = { act="SR", name="Door_LockedRaise", (tag, XC.D_FAST, 0, XC.KEY_BLUE) }
  [100] = { act="W",  name="Stairs_BuildUpDoom", (tag, XC.ST_TURBO, 16, 0, 0) }
  [101] = { act="S",  name="Floor_RaiseToLowestCeiling", (tag, XC.F_SLOW) }
  [102] = { act="S",  name="Floor_LowerToHighest", (tag, XC.F_SLOW, 128) }
  [103] = { act="S",  name="Door_Open", (tag, XC.D_SLOW) }
  [104] = { act="W",  name="Light_MinNeighbor", (tag) }
  [105] = { act="WR", name="Door_Raise", (tag, XC.D_FAST, XC.DOORWAIT) }
  [106] = { act="WR", name="Door_Open", (tag, XC.D_FAST) }
  [107] = { act="WR", name="Door_Close", (tag, XC.D_FAST) }
  [108] = { act="W",  name="Door_Raise", (tag, XC.D_FAST, XC.DOORWAIT) }
  [109] = { act="W",  name="Door_Open", (tag, XC.D_FAST) }
  [110] = { act="W",  name="Door_Close", (tag, XC.D_FAST) }
  [111] = { act="S",  name="Door_Raise", (tag, XC.D_FAST, XC.DOORWAIT) }
  [112] = { act="S",  name="Door_Open", (tag, XC.D_FAST) }
  [113] = { act="S",  name="Door_Close", (tag, XC.D_FAST) }
  [114] = { act="SR", name="Door_Raise", (tag, XC.D_FAST, XC.DOORWAIT) }
  [115] = { act="SR", name="Door_Open", (tag, XC.D_FAST) }
  [116] = { act="SR", name="Door_Close", (tag, XC.D_FAST) }
  [117] = { act="SR", name="Door_Raise", (0, XC.D_FAST, XC.DOORWAIT, tag) }
  [118] = { act="S",  name="Door_Open", (0, XC.D_FAST, tag) }
  [119] = { act="W",  name="Floor_RaiseToNearest", (tag, XC.F_SLOW) }
  [120] = { act="WR", name="Plat_DownWaitUpStayLip", (tag, XC.P_TURBO, XC.PLATWAIT, 0) }
  [121] = { act="W",  name="Plat_DownWaitUpStayLip", (tag, XC.P_TURBO, XC.PLATWAIT, 0) }
  [122] = { act="S",  name="Plat_DownWaitUpStayLip", (tag, XC.P_TURBO, XC.PLATWAIT, 0) }
  [123] = { act="SR", name="Plat_DownWaitUpStayLip", (tag, XC.P_TURBO, XC.PLATWAIT, 0) }
  [124] = { act="W",  name="Exit_Secret", (0) }
  [125] = { act="n",  name="Teleport", (0, tag) }
  [126] = { act="Rn", name="Teleport", (0, tag) }
  [127] = { act="S",  name="Stairs_BuildUpDoom", (tag, XC.ST_TURBO, 16, 0, 0) }
  [128] = { act="WR", name="Floor_RaiseToNearest", (tag, XC.F_SLOW) }
  [129] = { act="WR", name="Floor_RaiseToNearest", (tag, XC.F_FAST) }
  [130] = { act="W",  name="Floor_RaiseToNearest", (tag, XC.F_FAST) }
  [131] = { act="S",  name="Floor_RaiseToNearest", (tag, XC.F_FAST) }
  [132] = { act="SR", name="Floor_RaiseToNearest", (tag, XC.F_FAST) }
  [133] = { act="S",  name="Door_LockedRaise", (tag, XC.D_FAST, 0, XC.KEY_BLUE) }
  [134] = { act="SR", name="Door_LockedRaise", (tag, XC.D_FAST, 0, XC.KEY_RED) }
  [135] = { act="S",  name="Door_LockedRaise", (tag, XC.D_FAST, 0, XC.KEY_RED) }
  [136] = { act="SR", name="Door_LockedRaise", (tag, XC.D_FAST, 0, XC.KEY_YELLOW) }
  [137] = { act="S",  name="Door_LockedRaise", (tag, XC.D_FAST, 0, XC.KEY_YELLOW) }
  [138] = { act="SR", name="Light_ChangeToValue", (tag, 255) }
  [139] = { act="SR", name="Light_ChangeToValue", (tag, 35) }
  [140] = { act="S",  name="Floor_RaiseByValueTimes8", (tag, XC.F_SLOW, 64) }
  [141] = { act="W",  name="Ceiling_CrushAndRaiseSilentA", (tag, XC.C_SLOW, XC.C_SLOW, 10) }
  [142] = { act="W",  name="Floor_RaiseByValueTimes8", (tag, XC.F_SLOW, 64) }
  [143] = { act="W",  name="Plat_UpByValueStayTx", (tag, XC.P_SLOW/2, 3) }
  [144] = { act="W",  name="Plat_UpByValueStayTx", (tag, XC.P_SLOW/2, 4) }
  [145] = { act="W",  name="Ceiling_LowerToFloor", (tag, XC.C_SLOW) }
  [146] = { act="W",  name="Floor_Donut", (tag, XC.DONUTSPEED, XC.DONUTSPEED) }
  [147] = { act="WR", name="Floor_RaiseByValueTimes8", (tag, XC.F_SLOW, 64) }
  [148] = { act="WR", name="Plat_UpByValueStayTx", (tag, XC.P_SLOW/2, 3) }
  [149] = { act="WR", name="Plat_UpByValueStayTx", (tag, XC.P_SLOW/2, 4) }
  [150] = { act="WR", name="Ceiling_CrushAndRaiseSilentA", (tag, XC.C_SLOW, XC.C_SLOW, 10) }
  [151] = { act="WR", name="FloorAndCeiling_LowerRaise", (tag, XC.F_SLOW, XC.C_SLOW) }
  [152] = { act="WR", name="Ceiling_LowerToFloor", (tag, XC.C_SLOW) }
  [153] = { act="W",  name="Floor_TransferTrigger", (tag) }
  [154] = { act="WR", name="Floor_TransferTrigger", (tag) }
  [155] = { act="WR", name="Floor_Donut", (tag, XC.DONUTSPEED, XC.DONUTSPEED) }
  [156] = { act="WR", name="Light_StrobeDoom", (tag, 5, 35) }
  [157] = { act="WR", name="Light_MinNeighbor", (tag) }
  [158] = { act="S",  name="Floor_RaiseByTexture", (tag, XC.F_SLOW) }
  [159] = { act="S",  name="Floor_LowerToLowestTxTy", (tag, XC.F_SLOW) }
  [160] = { act="S",  name="Floor_RaiseByValueTxTy", (tag, XC.F_SLOW, 24) }
  [161] = { act="S",  name="Floor_RaiseByValue", (tag, XC.F_SLOW, 24) }
  [162] = { act="S",  name="Plat_PerpetualRaiseLip", (tag, XC.P_SLOW, XC.PLATWAIT, 0) }
  [163] = { act="S",  name="Plat_Stop", (tag) }
  [164] = { act="S",  name="Ceiling_CrushAndRaiseA", (tag, XC.C_NORMAL, XC.C_NORMAL, 10) }
  [165] = { act="S",  name="Ceiling_CrushAndRaiseSilentA", (tag, XC.C_SLOW, XC.C_SLOW, 10) }
  [166] = { act="S",  name="FloorAndCeiling_LowerRaise", (tag, XC.F_SLOW, XC.C_SLOW, 1998) }
  [167] = { act="S",  name="Ceiling_LowerAndCrush", (tag, XC.C_SLOW, 0, 2) }
  [168] = { act="S",  name="Ceiling_CrushStop", (tag) }
  [169] = { act="S",  name="Light_MaxNeighbor", (tag) }
  [170] = { act="S",  name="Light_ChangeToValue", (tag, 35) }
  [171] = { act="S",  name="Light_ChangeToValue", (tag, 255) }
  [172] = { act="S",  name="Light_StrobeDoom", (tag, 5, 35) }
  [173] = { act="S",  name="Light_MinNeighbor", (tag) }
  [174] = { act="Sm", name="Teleport", (0, tag) }
  [175] = { act="S",  name="Door_CloseWaitOpen", (tag, XC.D_SLOW, 240) }
  [176] = { act="SR", name="Floor_RaiseByTexture", (tag, XC.F_SLOW) }
  [177] = { act="SR", name="Floor_LowerToLowestTxTy", (tag, XC.F_SLOW) }
  [178] = { act="SR", name="Floor_RaiseByValueTimes8", (tag, XC.F_SLOW, 64) }
  [179] = { act="SR", name="Floor_RaiseByValueTxTy", (tag, XC.F_SLOW, 24) }
  [180] = { act="SR", name="Floor_RaiseByValue", (tag, XC.F_SLOW, 24) }
  [181] = { act="SR", name="Plat_PerpetualRaiseLip", (tag, XC.P_SLOW, XC.PLATWAIT, 0) }
  [182] = { act="SR", name="Plat_Stop", (tag) }
  [183] = { act="SR", name="Ceiling_CrushAndRaiseA", (tag, XC.C_NORMAL, XC.C_NORMAL, 10) }
  [184] = { act="SR", name="Ceiling_CrushAndRaiseA", (tag, XC.C_SLOW, XC.C_SLOW, 10) }
  [185] = { act="SR", name="Ceiling_CrushAndRaiseSilentA", (tag, XC.C_SLOW, XC.C_SLOW, 10) }
  [186] = { act="SR", name="FloorAndCeiling_LowerRaise", (tag, XC.F_SLOW, XC.C_SLOW, 1998) }
  [187] = { act="SR", name="Ceiling_LowerAndCrush", (tag, XC.C_SLOW, 0, 2) }
  [188] = { act="SR", name="Ceiling_CrushStop", (tag) }
  [189] = { act="S",  name="Floor_TransferTrigger", (tag) }
  [190] = { act="SR", name="Floor_TransferTrigger", (tag) }
  [191] = { act="SR", name="Floor_Donut", (tag, XC.DONUTSPEED, XC.DONUTSPEED) }
  [192] = { act="SR", name="Light_MaxNeighbor", (tag) }
  [193] = { act="SR", name="Light_StrobeDoom", (tag, 5, 35) }
  [194] = { act="SR", name="Light_MinNeighbor", (tag) }
  [195] = { act="SRm",name="Teleport", (0, tag) }
  [196] = { act="SR", name="Door_CloseWaitOpen", (tag, XC.D_SLOW, 240) }
  [197] = { act="G",  name="Exit_Normal", (0) }
  [198] = { act="G",  name="Exit_Secret", (0) }
  [199] = { act="W",  name="Ceiling_LowerToLowest", (tag, XC.C_SLOW) }
  [200] = { act="W",  name="Ceiling_LowerToHighestFloor", (tag, XC.C_SLOW) }
  [201] = { act="WR", name="Ceiling_LowerToLowest", (tag, XC.C_SLOW) }
  [202] = { act="WR", name="Ceiling_LowerToHighestFloor", (tag, XC.C_SLOW) }
  [203] = { act="S",  name="Ceiling_LowerToLowest", (tag, XC.C_SLOW) }
  [204] = { act="S",  name="Ceiling_LowerToHighestFloor", (tag, XC.C_SLOW) }
  [205] = { act="SR", name="Ceiling_LowerToLowest", (tag, XC.C_SLOW) }
  [206] = { act="SR", name="Ceiling_LowerToHighestFloor", (tag, XC.C_SLOW) }
  [207] = { act="Wm", name="Teleport_NoFog", (0, 0, tag, 1) }
  [208] = { act="WRm",name="Teleport_NoFog", (0, 0, tag, 1) }
  [209] = { act="Sm", name="Teleport_NoFog", (0, 0, tag, 1) }
  [210] = { act="SRm",name="Teleport_NoFog", (0, 0, tag, 1) }
  [211] = { act="SR", name="Plat_ToggleCeiling", (tag) }
  [212] = { act="WR", name="Plat_ToggleCeiling", (tag) }
  [213] = { act="",   name="Transfer_FloorLight", (tag) }
  [214] = { act="",   name="Scroll_Ceiling", (tag, 6, 0, 0, 0) }
  [215] = { act="",   name="Scroll_Floor", (tag, 6, 0, 0, 0) }
  [216] = { act="",   name="Scroll_Floor", (tag, 6, 1, 0, 0) }
  [217] = { act="",   name="Scroll_Floor", (tag, 6, 2, 0, 0) }
  [218] = { act="",   name="Scroll_Texture_Model", (lineid, 2) }
  [219] = { act="W",  name="Floor_LowerToNearest", (tag, XC.F_SLOW) }
  [220] = { act="WR", name="Floor_LowerToNearest", (tag, XC.F_SLOW) }
  [221] = { act="S",  name="Floor_LowerToNearest", (tag, XC.F_SLOW) }
  [222] = { act="SR", name="Floor_LowerToNearest", (tag, XC.F_SLOW) }
  [223] = { act="",   name="Sector_SetFriction", (tag, 0) }
  [224] = { act="",   name="Sector_SetWind", (tag, 0, 0, 1) }
  [225] = { act="",   name="Sector_SetCurrent", (tag, 0, 0, 1) }
  [226] = { act="",   name="PointPush_SetForce", (tag, 0, 0, 1) }
  [227] = { act="W",  name="Elevator_RaiseToNearest", (tag, XC.ELEVATORSPEED) }
  [228] = { act="WR", name="Elevator_RaiseToNearest", (tag, XC.ELEVATORSPEED) }
  [229] = { act="S",  name="Elevator_RaiseToNearest", (tag, XC.ELEVATORSPEED) }
  [230] = { act="SR", name="Elevator_RaiseToNearest", (tag, XC.ELEVATORSPEED) }
  [231] = { act="W",  name="Elevator_LowerToNearest", (tag, XC.ELEVATORSPEED) }
  [232] = { act="WR", name="Elevator_LowerToNearest", (tag, XC.ELEVATORSPEED) }
  [233] = { act="S",  name="Elevator_LowerToNearest", (tag, XC.ELEVATORSPEED) }
  [234] = { act="SR", name="Elevator_LowerToNearest", (tag, XC.ELEVATORSPEED) }
  [235] = { act="W",  name="Elevator_MoveToFloor", (tag, XC.ELEVATORSPEED) }
  [236] = { act="WR", name="Elevator_MoveToFloor", (tag, XC.ELEVATORSPEED) }
  [237] = { act="S",  name="Elevator_MoveToFloor", (tag, XC.ELEVATORSPEED) }
  [238] = { act="SR", name="Elevator_MoveToFloor", (tag, XC.ELEVATORSPEED) }
  [239] = { act="W",  name="Floor_TransferNumeric", (tag) }
  [240] = { act="WR", name="Floor_TransferNumeric", (tag) }
  [241] = { act="S",  name="Floor_TransferNumeric", (tag) }
  [242] = { act="",   name="Transfer_Heights", (tag) }
  [243] = { act="Wm", name="Teleport_Line", (tag, tag, 0) }
  [244] = { act="WRm",name="Teleport_Line", (tag, tag, 0) }
  [245] = { act="",   name="Scroll_Ceiling", (tag, 5, 0, 0, 0) }
  [246] = { act="",   name="Scroll_Floor", (tag, 5, 0, 0, 0) }
  [247] = { act="",   name="Scroll_Floor", (tag, 5, 1, 0, 0) }
  [248] = { act="",   name="Scroll_Floor", (tag, 5, 2, 0, 0) }
  [249] = { act="",   name="Scroll_Texture_Model", (lineid, 1) }
  [250] = { act="",   name="Scroll_Ceiling", (tag, 4, 0, 0, 0) }
  [251] = { act="",   name="Scroll_Floor", (tag, 4, 0, 0, 0) }
  [252] = { act="",   name="Scroll_Floor", (tag, 4, 1, 0, 0) }
  [253] = { act="",   name="Scroll_Floor", (tag, 4, 2, 0, 0) }
  [254] = { act="",   name="Scroll_Texture_Model", (lineid, 0) }
  [255] = { act="",   name="Scroll_Texture_Offsets", () }
  [256] = { act="WR", name="Stairs_BuildUpDoom", (tag, XC.ST_SLOW, 8, 0, 0) }
  [257] = { act="WR", name="Stairs_BuildUpDoom", (tag, XC.ST_TURBO, 16, 0, 0) }
  [258] = { act="SR", name="Stairs_BuildUpDoom", (tag, XC.ST_SLOW, 8, 0, 0) }
  [259] = { act="SR", name="Stairs_BuildUpDoom", (tag, XC.ST_TURBO, 16, 0, 0) }
  [260] = { act="",   name="TranslucentLine", (lineid, 168)  }
  [261] = { act="",   name="Transfer_CeilingLight", (tag) }
  [262] = { act="Wm", name="Teleport_Line", (tag, tag, 1) }
  [263] = { act="WRm",name="Teleport_Line", (tag, tag, 1) }
  [264] = { act="n",  name="Teleport_Line", (tag, tag, 1) }
  [265] = { act="Rn", name="Teleport_Line", (tag, tag, 1) }
  [266] = { act="n",  name="Teleport_Line", (tag, tag, 0) }
  [267] = { act="Rn", name="Teleport_Line", (tag, tag, 0) }
  [268] = { act="n",  name="Teleport_NoFog", (0, 0, tag, 1) }
  [269] = { act="Rn", name="Teleport_NoFog", (0, 0, tag, 1) }
  [270] = { act="WR", name="XC.FS_Execute", (tag) }
  [271] = { act="",   name="Static_Init", (tag, XC.INIT_SKY, 0) }
  [272] = { act="",   name="Static_Init", (tag, XC.INIT_SKY, 1) }
  [273] = { act="WR", name="XC.FS_Execute", (tag, 1) }
  [274] = { act="W",  name="XC.FS_Execute", (tag) }
  [275] = { act="W",  name="XC.FS_Execute", (tag, 1) }
  [276] = { act="SR", name="XC.FS_Execute", (tag) }
  [277] = { act="S",  name="XC.FS_Execute", (tag) }
  [278] = { act="GR", name="XC.FS_Execute", (tag) }
  [279] = { act="G",  name="XC.FS_Execute", (tag) }
  [280] = { act="",   name="Transfer_Heights", (tag, 12) }
  [281] = { act="",   name="Sector_Set3DFloor", (tag, 1, 0, 255) }
  [282] = { act="",   name="Static_Init", (tag, 1) }
  [284] = { act="",   name="TranslucentLine", (lineid, 128, 0) }
  [285] = { act="",   name="TranslucentLine", (lineid, 192, 0) }
  [286] = { act="",   name="TranslucentLine", (lineid, 48, 0) }
  [287] = { act="",   name="TranslucentLine", (lineid, 128, 1) }
  [288] = { act="",   name="TranslucentLine", (lineid, 255, 0) }
  [289] = { act="",   name="Sector_Set3DFloor", (tag, 1, 1, 255) }
  [300] = { act="",   name="Sector_Set3DFloor", (tag, 1, 1, 127) }
  [301] = { act="",   name="Sector_Set3DFloor", (tag, 2, 2, 127) }
  [302] = { act="",   name="Sector_Set3DFloor", (tag, 3, 6, 127) }
  [303] = { act="",   name="Sector_Set3DFloor", (tag, 3) }
  [304] = { act="",   name="Sector_Set3DFloor", (tag, 2, 2, 255) }
  [305] = { act="",   name="Sector_Set3DFloor", (tag, 3, 2) }
  [306] = { act="",   name="Sector_Set3DFloor", (tag, 1) }
  [332] = { act="",   name="Sector_Set3DFloor", (tag, 4) }
  [333] = { act="",   name="Static_Init", (tag, XC.INIT_GRAVITY) }
  [334] = { act="",   name="Static_Init", (tag, XC.INIT_COLOR) }
  [335] = { act="",   name="Static_Init", (tag, XC.INIT_DAMAGE) }
  [336] = { act="",   name="Line_Mirror", () }
  [337] = { act="",   name="Line_Horizon", () }
  [338] = { act="W",  name="Floor_Waggle", (tag, 24, 32, 0, 0) }
  [339] = { act="W",  name="Floor_Waggle", (tag, 12, 32, 0, 0) }
  [340] = { act="",   name="Plane_Align", (1, 0)  }
  [341] = { act="",   name="Plane_Align", (0, 1)  }
  [342] = { act="",   name="Plane_Align", (1, 1)  }
  [343] = { act="",   name="Plane_Align", (2, 0)  }
  [344] = { act="",   name="Plane_Align", (0, 2)  }
  [345] = { act="",   name="Plane_Align", (2, 2)  }
  [346] = { act="",   name="Plane_Align", (2, 1)  }
  [347] = { act="",   name="Plane_Align", (1, 2)  }
  [348] = { act="W",  name="Autosave", () }
  [349] = { act="S",  name="Autosave", () }
  [350] = { act="",   name="Transfer_Heights", (tag, 2)  }
  [351] = { act="",   name="Transfer_Heights", (tag, 6)  }
  [352] = { act="",   name="Sector_CopyScroller", (tag, 1)  }
  [353] = { act="",   name="Sector_CopyScroller", (tag, 2)  }
  [354] = { act="",   name="Sector_CopyScroller", (tag, 6)  }
  [400] = { act="",   name="Sector_Set3DFloor", (tag, 1, 0, 255) }
  [401] = { act="",   name="Sector_Set3DFloor", (tag, 1, 16, 255) }
  [402] = { act="",   name="Sector_Set3DFloor", (tag, 1, 32, 255) }
  [403] = { act="",   name="Sector_Set3DFloor", (tag, 2, 2, 255) }
  [404] = { act="",   name="Sector_Set3DFloor", (tag, 2, 2, 204) }
  [405] = { act="",   name="Sector_Set3DFloor", (tag, 2, 2, 153) }
  [406] = { act="",   name="Sector_Set3DFloor", (tag, 2, 2, 102) }
  [407] = { act="",   name="Sector_Set3DFloor", (tag, 2, 2, 51) }
  [408] = { act="",   name="Sector_Set3DFloor", (tag, 2, 2) }
  [413] = { act="",   name="Sector_Set3DFloor", (tag, 1, 8, 255) }
  [414] = { act="",   name="Sector_Set3DFloor", (tag, 1, 8, 204) }
  [415] = { act="",   name="Sector_Set3DFloor", (tag, 1, 8, 153) }
  [416] = { act="",   name="Sector_Set3DFloor", (tag, 1, 8, 102) }
  [417] = { act="",   name="Sector_Set3DFloor", (tag, 1, 8, 51) }
  [409] = { act="",   name="TranslucentLine", (lineid, 204)  }
  [410] = { act="",   name="TranslucentLine", (lineid, 153)  }
  [411] = { act="",   name="TranslucentLine", (lineid, 101)  }
  [412] = { act="",   name="TranslucentLine", (lineid, 50)  }
  [422] = { act="",   name="Scroll_Texture_Right", (XC.SCROLLSPEED) }
  [423] = { act="",   name="Scroll_Texture_Up", (XC.SCROLLSPEED) }
  [424] = { act="",   name="Scroll_Texture_Down", (XC.SCROLLSPEED) }
  [425] = { act="",   name="Scroll_Texture_Both", (0, XC.SCROLLSPEED, 0, 0, XC.SCROLLSPEED) }
  [426] = { act="",   name="Scroll_Texture_Both", (0, XC.SCROLLSPEED, 0, XC.SCROLLSPEED, 0) }
  [427] = { act="",   name="Scroll_Texture_Both", (0, 0, XC.SCROLLSPEED, 0, XC.SCROLLSPEED) }
  [428] = { act="",   name="Scroll_Texture_Both", (0, 0, XC.SCROLLSPEED, XC.SCROLLSPEED, 0) }
  [434] = { act="S",  name="Floor_RaiseByValue", (tag, XC.F_SLOW, 2) }
  [435] = { act="SR", name="Floor_RaiseByValue", (tag, XC.F_SLOW, 2) }
  [436] = { act="W",  name="Floor_RaiseByValue", (tag, XC.F_SLOW, 2) }
  [437] = { act="WR", name="Floor_RaiseByValue", (tag, XC.F_SLOW, 2) }
  [438] = { act="G",  name="Floor_RaiseByValue", (tag, XC.F_SLOW, 2) }
  [439] = { act="GR", name="Floor_RaiseByValue", (tag, XC.F_SLOW, 2) }
}

