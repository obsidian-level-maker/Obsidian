----------------------------------------------------------------
--  GAME DEF : Harmony 1.1
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 Andrew Apted
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

HARMONY = { }

HARMONY.ENTITIES =
{
  --- special stuff ---
  player1 = { id=1, kind="other", r=16,h=56 }
  player2 = { id=2, kind="other", r=16,h=56 }
  player3 = { id=3, kind="other", r=16,h=56 }
  player4 = { id=4, kind="other", r=16,h=56 }

  dm_player     = { id=11, kind="other", r=16,h=56 }
  teleport_spot = { id=14, kind="other", r=16,h=56 }
  
  --- monsters ---
  beastling   = { id=3004, kind="monster", r=20,h=56 }
  follower    = { id=9,    kind="monster", r=20,h=56 }
  critter     = { id=3003, kind="monster", r=24,h=24 }
  centaur     = { id=16,   kind="monster", r=40,h=112 }

  mutant    = { id=65,  kind="monster", r=20,h=56 }
  phage     = { id=68,  kind="monster", r=48,h=64 }
  predator  = { id=66,  kind="monster", r=20,h=56 }
  falling   = { id=64,  kind="monster", r=20,h=56 }
  echidna   = { id=7,   kind="monster", r=128,h=112 }

  --- keys ---
  kc_green   = { id=5,  kind="pickup", r=20,h=16, pass=true }
  kc_yellow  = { id=6,  kind="pickup", r=20,h=16, pass=true }
  kc_purple  = { id=13, kind="pickup", r=20,h=16, pass=true }

  kn_purple  = { id=38, kind="pickup", r=20,h=16, pass=true }
  kn_yellow  = { id=39, kind="pickup", r=20,h=16, pass=true }
  kn_blue    = { id=40, kind="pickup", r=20,h=16, pass=true }

  --- weapons ---
  shotgun    = { id=2001, kind="pickup", r=20,h=16, pass=true }
  minigun    = { id=2002, kind="pickup", r=20,h=16, pass=true }
  launcher   = { id=2003, kind="pickup", r=20,h=16, pass=true }
  entropy    = { id=2004, kind="pickup", r=20,h=16, pass=true }
  h_grenade  = { id=2006, kind="pickup", r=20,h=30, pass=true }

  --- ammo ---
  mini_box   = { id=2048, kind="pickup", r=20,h=16, pass=true }
  shell_box  = { id=2049, kind="pickup", r=20,h=16, pass=true }
  cell_pack  = { id=  17, kind="pickup", r=20,h=16, pass=true }
  grenade    = { id=2010, kind="pickup", r=20,h=16, pass=true }
  nade_belt  = { id=2046, kind="pickup", r=20,h=16, pass=true }

  --- health ---
  mushroom     = { id=2011, kind="pickup", r=20,h=16, pass=true }
  first_aid    = { id=2012, kind="pickup", r=20,h=16, pass=true }
  amazon_armor = { id=2018, kind="pickup", r=20,h=16, pass=true }
  NDF_armor    = { id=2019, kind="pickup", r=20,h=16, pass=true }

  --- powerup ---
  mushroom_wow = { id=2013, kind="pickup", r=20,h=16, pass=true }
  computer_map = { id=2026, kind="pickup", r=20,h=16, pass=true }

  --- scenery ---

  -- TODO: SIZES and PASSIBILITY

  bridge = { id=118, kind="scenery",  r=20,h=16 }
  barrel = { id=2035, kind="scenery", r=20,h=56 }
  flames = { id=36, kind="scenery",   r=20,h=56 }
  amira  = { id=32, kind="scenery",   r=20,h=56 }

  solid_shroom = { id=30, kind="scenery", r=20,h=56 }
  truck_pipe   = { id=31, kind="scenery", r=20,h=56 }
  sculpture    = { id=33, kind="scenery", r=20,h=56 }
  dead_tree    = { id=54, kind="scenery", r=20,h=56 }
  water_drip   = { id=42, kind="scenery", r=20,h=56 }
  dope_fish    = { id=45, kind="scenery", r=20,h=56 }

  tall_lamp  = { id=48, kind="scenery", r=20,h=56 }
  laser_lamp = { id=2028, kind="scenery", r=20,h=56 }
  candle     = { id=34, kind="scenery", r=20,h=56 }
  fire       = { id=55, kind="scenery", r=20,h=56 }
  fire_box   = { id=57, kind="scenery", r=20,h=56 }

  flies       = { id=2007, kind="scenery", r=20,h=56, pass=true }
  nuke_splash = { id=46, kind="scenery", r=20,h=56 }
  ceil_sparks = { id=56, kind="scenery", r=20,h=56 }
  brazier     = { id=63, kind="scenery", r=20,h=56, ceil=true }
  missile     = { id=27, kind="scenery", r=20,h=56 }

  vine_thang   = { id=28, kind="scenery", r=20,h=56 }
  skeleton     = { id=19, kind="scenery", r=20,h=56 }
  hang_chains  = { id=73, kind="scenery", r=20,h=56 }
  minigun_rack = { id=74, kind="scenery", r=20,h=88 }
  shotgun_rack = { id=75, kind="scenery", r=20,h=64 }

  dead_amazon = { id=15, kind="scenery", r=20,h=16, pass=true }
  dead_beast  = { id=21, kind="scenery", r=20,h=16, pass=true }
}


HARMONY.PARAMETERS =
{
  rails = true
  switches = true
  light_brushes = true

  jump_height = 24

  max_name_length = 28

  skip_monsters = { 10,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
  monster_factor = 0.75
}


----------------------------------------------------------------

HARMONY.MATERIALS =
{
  -- FIXME!!! very incomplete

  -- special materials --

  _ERROR = { t="METAL3", f="DEM1_6" }
  _SKY   = { t="METAL3", f="F_SKY1" }


  -- general purpose --

  METAL  = { t="METAL3",   f="DEM1_6" }

  DOORTRAK = { t="DOORTRAK", f="CEIL5_1" }


  -- walls --

  ORANJE3 = { t="0ORANJE3", f="FLOOR0_3" }


  -- floors --

  FLOOR4_8 = { f="FLOOR4_8", t="SILVER3" }

  GRASS2 = { f="GRASS2", t="ZZWOLF11" }

  ROCKS = { f="TLITE6_4", t="ZZWOLF9" }



  -- switches --


  -- rails --

  LADDER       = { t="0LADDER",  rail_h=128 }
  LASER_BEAM   = { t="0LASER4",  rail_h=8 }
  ELECTRICITY  = { t="ROCKRED1", rail_h=48 }

  RED_WIRING   = { t="MODWALL1", rail_h=128 }
  BLUE_WIRING  = { t="CEMENT7",  rail_h=128 }
  FANCY_WINDOW = { t="ZELDOOR", rail_h=128 }

  GRATE_HOLE   = { t="STUCCO3", rail_h=64 }
  RUSTY_GRATE  = { t="MIDGRATE", rail_h=128 }
  METAL_BAR1   = { t="0MBAR1",  rail_h=16 }
  METAL_BAR2   = { t="0MBAR2",  rail_h=64 }

  R_LIFT1   = { t="1LIFT1", rail_h=128 }
  R_LIFT3   = { t="1LIFT3", rail_h=128 }
  R_LIFT4   = { t="1LIFT4", rail_h=128 }
  R_PRED    = { t="0PRED",  rail_h=128 }

  BAR_MUSIC = { t="SP_DUDE7", rail_h=128 }
  NO_WAR    = { t="0GRAFFI",  rail_h=128 }
  LAST_DOPE = { t="0DOPE",    rail_h=64  }
  THE_END   = { t="0END2",    rail_h=128 }

  BIG_BRIDGE_L = { t="SKINMET2", rail_h=128 }
  BIG_BRIDGE_R = { t="SKINSCAB", rail_h=128 }

  GLASS       = { t="SLOPPY1", rail_h=128 }
  GLASS_SMASH = { t="SLOPPY2", rail_h=128 }
  GLASS_BLUE  = { t="0BLUEGL", rail_h=128 }

  BLUE_PEAK   = { t="0ARK1", rail_h=128 }
  METAL_ARCH  = { t="0ARCH", rail_h=128 }

  STONE_ARCH   = { t="ZZWOLF3",  rail_h=64 }
  STONE_PEAK   = { t="0DRIEHK1", rail_h=32 }
  STONE_CURVE1 = { t="0CURVE1",  rail_h=128 }
  STONE_CURVE2 = { t="0CURVE2",  rail_h=128 }

  IRIS_DOOR1  = { t="0IRIS1", rail_h=128 }
  IRIS_DOOR2  = { t="0IRIS2", rail_h=128 }
  IRIS_DOOR3  = { t="0IRIS3", rail_h=128 }
  IRIS_DOOR4  = { t="0IRIS4", rail_h=128 }
  IRIS_FRAME1 = { t="0IRIS5", rail_h=128 }
  IRIS_FRAME2 = { t="0IRIS7", rail_h=128 }


  -- liquids --

  WATER   = { f="FWATER1", t="SFALL1"   }
  W_ICE   = { f="NUKAGE1", t="SFALL1"   }
  W_ROCK  = { f="SLIME05", t="SFALL1"   }
  W_STEEL = { f="BLOOD1",  t="GSTFONT1" }
                          
  LAVA    = { f="SLIME01", t="0ROOD02"  }  -- NOTE: texture not animated
  NUKAGE  = { f="SLIME09", t="BFALL1"   }

  TELEPORT = { f="FLOOR5_3", t="PANEL8" }

  -- other --

--FIXME:
--  O_PILL   = { t="HW313", f="O_PILL",   sane=1 }
--  O_BOLT   = { t="HW316", f="O_BOLT",   sane=1 }
--  O_RELIEF = { t="HW329", f="O_RELIEF", sane=1 }
--  O_CARVE  = { t="HW309", f="O_CARVE",  sane=1 }
}


HARMONY.RAILS =
{
  -- TODO
}


--[[ FIXME: incorporate these colors
0ARCH , color=0x2a2114
0ARCH2 , color=0x292115
0ARCH3 , color=0x2a1f12
0ARCHB , color=0x000000
0ARCHB2 , color=0x000000
0ARCHB3 , color=0x000000
0ARK1 , color=0x10192b
0ARK2 , color=0x353842
0ARK3 , color=0x565655
0ARK4 , color=0x292928
0ARK5 , color=0x000000
0BIOHAZ , color=0x514038
0BLOCK1 , color=0x181c38
0BLOCK2 , color=0x181c38
0BLUEGL , color=0x7b87cb
0BLUS01 , color=0x94908d
0CARA1 , color=0x2b2b2f
0CARA2 , color=0x232429
0CARA3 , color=0x232429
0CARA4 , color=0x000000
0CARA4A , color=0x000000
0CARA5 , color=0x000000
0CARA5A , color=0x000000
0CARB1 , color=0x292e25
0CARB2 , color=0x2f342c
0CARB3 , color=0x2f342c
0CARB4 , color=0x3f4136
0CARC1 , color=0x2f2a26
0CARC2 , color=0x2a2420
0CARC3 , color=0x292420
0CARD1 , color=0x191819
0CHE , color=0x912a02
0CONTROL , color=0x4b4d4e
0CRATED , color=0x606360
0CRATFLY , color=0x626561
0CURVE1 , color=0x515052
0CURVE2 , color=0x565554
0DARKBLU , color=0x111a2b
0DOORS1 , color=0x4e4d4d
0DOPE , color=0x464646
0DRIEHK1 , color=0x5b5b5b
0DRIEHK2 , color=0x000000
0DROCK1 , color=0x150f0b
0ELEKT , color=0x323a58
0ELEKT2 , color=0x638ca1
0END1 , color=0x24150b
0END2 , color=0x060402
0END3 , color=0x000000
0ENDBOAT , color=0x874022
0ENLIST , color=0x434a4d
0EXPLOS , color=0x51210b
0EYE , color=0x1d2240
0FLAG , color=0x243c39
0FLOORS , color=0x363a4a
0GLASS1 , color=0xbfbfbf
0GRAFFI , color=0x220022
0GROENI2 , color=0x1f331f
0GROENIG , color=0x636760
0HALF1 , color=0x2b2b2a
0HAWK01 , color=0x969391
0HAWK02 , color=0x565453
0HAWK03 , color=0x000000
0HAWK04 , color=0x979694
0HAWK05 , color=0x979694
0HAWK06 , color=0x969594
0HAWK07 , color=0x969594
0HAWK08 , color=0x93918f
0HAWK09 , color=0x61605f
0HOSPIT , color=0x644f41
0IMP , color=0x312115
0IRIS1 , color=0x131313
0IRIS2 , color=0x121111
0IRIS3 , color=0x0f0f0f
0IRIS4 , color=0x090909
0IRIS5 , color=0x28251c
0IRIS6 , color=0x000000
0IRIS7 , color=0x3b230f
0KAPOT0 , color=0x969391
0KAPOT1 , color=0x8c8b8a
0KAPOT2 , color=0x8c8b8a
0KAPOT3 , color=0x928f8e
0LAB1 , color=0x665a52
0LADDER , color=0x261c17
0LASER1 , color=0x221a15
0LASER2 , color=0x5b1704
0LASER3 , color=0x575457
0LASER3B , color=0x564c48
0LASER4 , color=0x8535e9
0LITE , color=0x9e9d93
0LITE2 , color=0xab91cc
0LITEYL1 , color=0x815d33
0LITEYL2 , color=0x5b493e
0LOGO1 , color=0x873300
0LOGO2 , color=0x5b5c68
0MAP1 , color=0x937963
0MBAR1 , color=0x24180f
0MBAR2 , color=0x25170c
0MBAR3 , color=0x25170d
0MIRROR , color=0x3b2d23
0MONGER , color=0x081117
0MONIT1 , color=0x141c20
0MORG , color=0x666666
0NINET , color=0x39426c
0NOSE1 , color=0x525151
0ORANJE , color=0x574e47
0ORANJE2 , color=0x937963
0ORANJE3 , color=0x554d45
0ORANJE4 , color=0x937963
0PAARS , color=0x626266
0PIJL1 , color=0x28211c
0PRED , color=0x4a433f
0PROTECT , color=0xb45c22
0PTFLY , color=0x989899
0RECORD1 , color=0x0c1b21
0RECORD2 , color=0x03161e
0RECORD3 , color=0x041821
0RECORD4 , color=0x26211e
0ROCKLIT , color=0x31241d
0ROOD01 , color=0x645043
0ROOD02 , color=0xbe3812
0ROOD03 , color=0x534842
0SBAR1 , color=0x261a11
0SCOOP , color=0x222222
0SHUT0 , color=0x656565
0SHUT1 , color=0x979797
0SHUT2 , color=0x9c9c9c
0SSHIP1 , color=0x000000
0STRIPE1 , color=0x2a2e42
0TECH1 , color=0x505656
0TEETHD , color=0xdddddd
0TEETHU , color=0xdddddd
0TRAIN0 , color=0x1c1c1c
0TRAIN1 , color=0x4e1000
0TRAIN2 , color=0x421204
0TRAIN3 , color=0x4e1101
0TRAIN4 , color=0x571403
0TRAIN5 , color=0x573a22
0TRUCK1 , color=0x2d271d
0TRUCK2 , color=0x282016
0TRUCK3 , color=0x1e231c
0TRUCK4 , color=0x181b24
0TRUCK5 , color=0x253023
0TRUCK6 , color=0x292216
0TRUCK7 , color=0x2d271d
0TRUCM1 , color=0x000000
0TRUCM2 , color=0x000000
0TRUCM4 , color=0x000000
0TTT , color=0x1d1a17
0WALL01 , color=0x33261f
1BABY , color=0x613613
1BIGDOOR , color=0x382615
1BOAT1 , color=0x999694
1BOAT2 , color=0x969391
1BOMVIN , color=0x2e2e2e
1DESK , color=0x2c2019
1DOORK1 , color=0x3d4040
1DOORQ1 , color=0x595756
1DOORQ2 , color=0x5a5857
1DOORT1 , color=0x191f30
1FUNGUS1 , color=0x192729
1FUNGUS2 , color=0x3f653f
1GREEN , color=0x3f653f
1KAST1 , color=0x2f231a
1KAST2 , color=0x3b2f26
1KAST3 , color=0x000000
1LIFT1 , color=0x382a20
1LIFT2 , color=0x312218
1LIFT3 , color=0x24180f
1LIFT4 , color=0x392a20
1RADIO1 , color=0x3e4055
1STOEL , color=0x554d3a
1STOEL2 , color=0x1a1009
1STOEL3 , color=0x0f0904
1STOEL4 , color=0x2c1f16
3ART1 , color=0x694223
3STONE , color=0x695e53
ASHWALL2 , color=0x1d1d1d
ASHWALL3 , color=0x434343
ASHWALL4 , color=0x6b625b
ASHWALL6 , color=0x2d231c
ASHWALL7 , color=0x000000
BFALL1 , color=0x2b4a2b
BFALL2 , color=0x2a492a
BFALL3 , color=0x2a482a
BFALL4 , color=0x2a4a2a
BIGBRIK1 , color=0x2c2520
BIGBRIK2 , color=0x4e4b41
BIGBRIK3 , color=0x232e50
BIGDOOR1 , color=0x696867
BIGDOOR2 , color=0x535454
BIGDOOR3 , color=0x423730
BIGDOOR4 , color=0x4e4d4d
BIGDOOR5 , color=0x937963
BIGDOOR6 , color=0x927964
BIGDOOR7 , color=0x31313e
BLAKWAL1 , color=0x000000
BLAKWAL2 , color=0x3c3633
BLODRIP1 , color=0x573a22
BLODRIP2 , color=0x573a22
BLODRIP3 , color=0x573a22
BLODRIP4 , color=0x573a22
BRICK1 , color=0x2c251c
BRICK10 , color=0x100e0c
BRICK11 , color=0x171b1f
BRICK12 , color=0x575757
BRICK2 , color=0x1c130b
BRICK3 , color=0x4e311e
BRICK4 , color=0x484f41
BRICK5 , color=0x171a24
BRICK6 , color=0x3a3731
BRICK7 , color=0x514940
BRICK8 , color=0x271e18
BRICK9 , color=0x211a16
BRICKLIT , color=0x403116
BRNPOIS , color=0x22211d
BRNSMAL1 , color=0x27201b
BRNSMAL2 , color=0x27201b
BRNSMALC , color=0x28211c
BRNSMALL , color=0x937963
BRNSMALR , color=0x937963
BRONZE1 , color=0x2a1b0e
BRONZE2 , color=0x1e1209
BRONZE3 , color=0x161616
BRONZE4 , color=0x546960
BROVINE2 , color=0x21201d
BROWN1 , color=0x947a63
BROWN144 , color=0x977b63
BROWN96 , color=0x3b332c
BROWNGRN , color=0x201f1c
BROWNHUG , color=0x947a63
BROWNPIP , color=0x514943
BRWINDOW , color=0x282119
BSTONE1 , color=0x201e21
BSTONE2 , color=0x484341
BSTONE3 , color=0x33251c
CEMENT1 , color=0x505050
CEMENT2 , color=0x6b370c
CEMENT3 , color=0x555453
CEMENT4 , color=0x646464
CEMENT5 , color=0x494949
CEMENT6 , color=0x463a32
CEMENT7 , color=0x272e4d
CEMENT8 , color=0x1d1f3d
CEMENT9 , color=0x575857
COMPBLUE , color=0x947a63
COMPSPAN , color=0x947a63
COMPSTA1 , color=0x937963
COMPSTA2 , color=0x937963
COMPTALL , color=0x947a63
COMPWERD , color=0x947a63
CRACKLE2 , color=0x542e14
CRACKLE4 , color=0x4a4540
CRATE1 , color=0x947a63
CRATE2 , color=0x947a63
CRATE3 , color=0x947a63
CRATELIT , color=0x947a63
CRATINY , color=0xa08368
CRATWIDE , color=0x947c66
DBRAIN1 , color=0x372414
DBRAIN2 , color=0x372414
DBRAIN3 , color=0x372414
DBRAIN4 , color=0x372414
DOOR1 , color=0x937963
DOOR3 , color=0x937963
DOORBLU , color=0x967762
DOORBLU2 , color=0x90755e
DOORRED , color=0x967762
DOORRED2 , color=0x90755e
DOORSTOP , color=0x927460
DOORTRAK , color=0x252525
DOORYEL , color=0x967762
DOORYEL2 , color=0x90755e
EXITDOOR , color=0x957a63
EXITSIGN , color=0x353a7c
EXITSTON , color=0x6a6077
FIREBLU1 , color=0x937963
FIREBLU2 , color=0x937963
FIRELAV2 , color=0x937963
FIRELAV3 , color=0x937963
FIRELAVA , color=0x937963
FIREMAG1 , color=0x151f24
FIREMAG2 , color=0x141e23
FIREMAG3 , color=0x141e23
FIREWALA , color=0x937963
FIREWALB , color=0x937963
FIREWALL , color=0x937963
GRAY1 , color=0x947a63
GRAY2 , color=0x987b64
GRAY4 , color=0x947a63
GRAY5 , color=0x927963
GRAY7 , color=0x947862
GRAYBIG , color=0x937962
GRAYPOIS , color=0x977b63
GRAYTALL , color=0x957a63
GRAYVINE , color=0x947a65
GSTFONT1 , color=0x282e41
GSTFONT2 , color=0x272e41
GSTFONT3 , color=0x272d40
GSTGARG , color=0x201815
GSTLION , color=0x937963
GSTONE1 , color=0x947a63
GSTONE2 , color=0x947a63
GSTSATYR , color=0x937963
GSTVINE1 , color=0x947a63
GSTVINE2 , color=0x947a63
ICKWALL1 , color=0x947a63
ICKWALL2 , color=0x947a63
ICKWALL3 , color=0x937963
ICKWALL4 , color=0x947a63
ICKWALL5 , color=0x947a63
ICKWALL7 , color=0x937963
LITE3 , color=0x997865
LITE5 , color=0x9a7b69
LITEBLU1 , color=0x927460
LITEBLU4 , color=0x9a7b69
MARBFAC2 , color=0xad754d
MARBFAC3 , color=0x3c3b38
MARBFAC4 , color=0x080808
MARBFACE , color=0xad7e5d
MARBGRAY , color=0x434248
MARBLE1 , color=0x1e203d
MARBLE2 , color=0x6c625b
MARBLE3 , color=0x6c2f2a
MARBLOD1 , color=0x2c3a3d
METAL , color=0x24150b
METAL1 , color=0x947a63
METAL2 , color=0x24201d
METAL3 , color=0x2f2823
METAL4 , color=0x626262
METAL5 , color=0x403935
METAL6 , color=0x2e3028
METAL7 , color=0x261d18
MIDBARS1 , color=0x1b2442
MIDBARS3 , color=0xbc3112
MIDBRN1 , color=0x937963
MIDBRONZ , color=0x3b2817
MIDGRATE , color=0x1f170d
MIDSPACE , color=0x1f170d
MODWALL1 , color=0x3b0b00
MODWALL2 , color=0x121a31
MODWALL3 , color=0x403e48
MODWALL4 , color=0x2d2722
NUKE24 , color=0x937963
NUKEDGE1 , color=0x977b63
NUKEPOIS , color=0x967b63
PANBLACK , color=0x212947
PANBLUE , color=0x212948
PANBOOK , color=0x41423e
PANBORD1 , color=0x927e50
PANBORD2 , color=0x6f5533
PANCASE1 , color=0x414040
PANCASE2 , color=0x211b17
PANEL1 , color=0x57392a
PANEL2 , color=0x575655
PANEL3 , color=0x4b4c50
PANEL4 , color=0x272e40
PANEL5 , color=0x000000
PANEL6 , color=0x492911
PANEL7 , color=0x2b1e16
PANEL8 , color=0x271d17
PANEL9 , color=0x656565
PANRED , color=0x2e2d2b
PIPE1 , color=0x947a63
PIPE2 , color=0x947a63
PIPE4 , color=0x947a63
PIPE6 , color=0x280525
PIPES , color=0x584d45
PIPEWAL1 , color=0x000000
PIPEWAL2 , color=0x383838
PLAT1 , color=0x170f09
REDWALL , color=0x5f1300
ROCK1 , color=0x672e0f
ROCK2 , color=0x6f6f6f
ROCK3 , color=0x41362e
ROCK4 , color=0x64564b
ROCK5 , color=0x6f5e52
ROCKRED1 , color=0x4a90b0
ROCKRED2 , color=0x5698b8
ROCKRED3 , color=0x5797b6
RSKY1B , color=0x434c7b
RSKY1C , color=0x444d7d
RSKY1D , color=0x444d7c
RW15_1 , color=0x57392a
RW15_2 , color=0x575655
RW15_3 , color=0x4b4c50
SFALL1 , color=0x39426d
SFALL2 , color=0x39436e
SFALL3 , color=0x38416c
SFALL4 , color=0x39436e
SHAWN1 , color=0x686766
SHAWN2 , color=0x937963
SHAWN3 , color=0x937963
SILVER1 , color=0x666666
SILVER2 , color=0x3b281a
SILVER3 , color=0x232323
SKIN2 , color=0x947a63
SKINCUT , color=0x3b2f24
SKINEDGE , color=0x947a63
SKINFACE , color=0x947a63
SKINLOW , color=0x947a63
SKINMET1 , color=0x43352b
SKINMET2 , color=0x36281d
SKINSCAB , color=0x36281d
SKINSYMB , color=0x947a63
SKSNAKE1 , color=0x51453d
SKSNAKE2 , color=0x54524f
SKSPINE1 , color=0x937963
SKSPINE2 , color=0x947a63
SKY1 , color=0x444d7d
SKY2 , color=0x937963
SKY3 , color=0x937963
SK_LEFT , color=0x524a31
SK_RIGHT , color=0x242424
SLADPOIS , color=0x947a63
SLADSKUL , color=0x947a63
SLADWALL , color=0x937963
SLOPPY1 , color=0xbfbfbf
SLOPPY2 , color=0xc0c0c0
SPACEW2 , color=0x1d1a17
SPACEW3 , color=0x937963
SPACEW4 , color=0x4a513d
SPCDOOR1 , color=0x937963
SPCDOOR2 , color=0x606360
SPCDOOR3 , color=0x3b3b3b
SPCDOOR4 , color=0x4e3f35
SP_DUDE1 , color=0x572f10
SP_DUDE2 , color=0x4a2608
SP_DUDE4 , color=0x999187
SP_DUDE5 , color=0x937963
SP_DUDE7 , color=0x522169
SP_DUDE8 , color=0x3b003b
SP_FACE1 , color=0x937963
SP_FACE2 , color=0x937963
SP_HOT1 , color=0x947a63
SP_ROCK1 , color=0x937963
STARBR2 , color=0x947a63
STARG1 , color=0x947a63
STARG2 , color=0x947a63
STARG3 , color=0x947a63
STARGR1 , color=0x947a63
STARGR2 , color=0x947a63
STARTAN2 , color=0x947a63
STARTAN3 , color=0x947a63
STEP1 , color=0x987f69
STEP2 , color=0x9d8168
STEP3 , color=0x967560
STEP4 , color=0x967560
STEP5 , color=0x967560
STEP6 , color=0x302e2f
STEPLAD1 , color=0x1c1008
STEPTOP , color=0x9d8168
STONE , color=0x977a62
STONE2 , color=0x947a63
STONE3 , color=0x947a63
STONE4 , color=0x6d6258
STONE5 , color=0x273431
STONE6 , color=0x513925
STONE7 , color=0x23372f
STUCCO , color=0x29221a
STUCCO1 , color=0x646464
STUCCO2 , color=0x513b29
STUCCO3 , color=0x1c130c
SUPPORT2 , color=0x937963
SUPPORT3 , color=0x937963
SW1BLUE , color=0x957a63
SW1BRCOM , color=0x3c342d
SW1BRIK , color=0x4d4a40
SW1BRN1 , color=0x3c342d
SW1BRN2 , color=0x4d4248
SW1BRNGN , color=0x212020
SW1BROWN , color=0x3d342d
SW1CMT , color=0x595755
SW1COMM , color=0x605f5e
SW1COMP , color=0x252423
SW1DIRT , color=0x2f2722
SW1EXIT , color=0x4e3e31
SW1GARG , color=0x28180e
SW1GRAY , color=0x5f5e5d
SW1GRAY1 , color=0x4d4147
SW1GSTON , color=0x947a63
SW1HOT , color=0x947a63
SW1LION , color=0x28180e
SW1MARB , color=0x22233e
SW1MET2 , color=0x261f1b
SW1METAL , color=0x4d4248
SW1MOD1 , color=0x1f213d
SW1PANEL , color=0x251e19
SW1PIPE , color=0x947a63
SW1ROCK , color=0x6a3112
SW1SATYR , color=0x28180e
SW1SKIN , color=0x947a63
SW1SKULL , color=0x322b2a
SW1SLAD , color=0x446441
SW1STARG , color=0x3c342d
SW1STON1 , color=0x63554a
SW1STON2 , color=0x3c342d
SW1STON6 , color=0x26170d
SW1STONE , color=0x3c342d
SW1STRTN , color=0x64564b
SW1TEK , color=0x1a2441
SW1VINE , color=0x413944
SW1WDMET , color=0x2b1d14
SW1WOOD , color=0x937963
SW1ZIM , color=0x61605f
SW2BLUE , color=0x957a63
SW2BRCOM , color=0x3b342d
SW2BRIK , color=0x4c4a41
SW2BRN1 , color=0x3b342d
SW2BRN2 , color=0x46444f
SW2BRNGN , color=0x202021
SW2BROWN , color=0x3d342d
SW2CMT , color=0x595755
SW2COMM , color=0x5f5f60
SW2COMP , color=0x232424
SW2DIRT , color=0x2d2723
SW2EXIT , color=0x423f3a
SW2GARG , color=0x28180e
SW2GRAY , color=0x5d5e5e
SW2GRAY1 , color=0x45444f
SW2GSTON , color=0x947a63
SW2HOT , color=0x947a63
SW2LION , color=0x28180e
SW2MARB , color=0x22233e
SW2MET2 , color=0x251f1b
SW2METAL , color=0x45444f
SW2MOD1 , color=0x1e213e
SW2PANEL , color=0x251e19
SW2PIPE , color=0x947a63
SW2ROCK , color=0x6a3112
SW2SATYR , color=0x28180e
SW2SKIN , color=0x947a63
SW2SKULL , color=0x372c28
SW2SLAD , color=0x416443
SW2STARG , color=0x3b342d
SW2STON1 , color=0x5e564e
SW2STON2 , color=0x3b342d
SW2STON6 , color=0x24170f
SW2STONE , color=0x3b342d
SW2STRTN , color=0x5e564e
SW2TEK , color=0x192542
SW2VINE , color=0x393c4c
SW2WDMET , color=0x2a1d16
SW2WOOD , color=0x937963
SW2ZIM , color=0x61605f
TANROCK2 , color=0x716458
TANROCK3 , color=0x36281d
TANROCK4 , color=0x9c9997
TANROCK5 , color=0x24160c
TANROCK7 , color=0x20232f
TANROCK8 , color=0x4d5746
TEKBRON1 , color=0x403934
TEKBRON2 , color=0x937963
TEKGREN1 , color=0x080604
TEKGREN2 , color=0x182441
TEKGREN3 , color=0x212120
TEKGREN4 , color=0x574336
TEKGREN5 , color=0x243b22
TEKLITE , color=0x142013
TEKLITE2 , color=0x52332f
TEKWALL1 , color=0x937963
TEKWALL4 , color=0x000000
TEKWALL6 , color=0x947a63
W73A_1 , color=0x937963
W73A_2 , color=0x937963
W73B_1 , color=0x937963
WOOD1 , color=0x947a63
WOOD10 , color=0x937963
WOOD12 , color=0x37281e
WOOD3 , color=0x947a63
WOOD4 , color=0x937963
WOOD5 , color=0x947a63
WOOD6 , color=0x362f29
WOOD7 , color=0x4e433c
WOOD8 , color=0x38312a
WOOD9 , color=0x38302a
WOODGARG , color=0x947a63
WOODMET1 , color=0x2c1c0f
WOODMET2 , color=0x161e22
WOODMET3 , color=0x231811
WOODMET4 , color=0x000000
WOODVERT , color=0x302a23
ZDOORB1 , color=0x4c4038
ZDOORF1 , color=0x1f2341
ZELDOOR , color=0x17213e
ZIMMER1 , color=0x5f5f5f
ZIMMER2 , color=0x5d5d5d
ZIMMER3 , color=0x2b1c10
ZIMMER4 , color=0x5f3105
ZIMMER5 , color=0x221309
ZIMMER7 , color=0x000000
ZIMMER8 , color=0x727272
ZZWOLF1 , color=0x3c342e
ZZWOLF10 , color=0x00071b
ZZWOLF11 , color=0x2c281c
ZZWOLF12 , color=0x50351f
ZZWOLF13 , color=0x5f5f5f
ZZWOLF2 , color=0x303547
ZZWOLF3 , color=0x454446
ZZWOLF4 , color=0x000000
ZZWOLF5 , color=0x3f342c
ZZWOLF6 , color=0x4c4b4a
ZZWOLF7 , color=0x474648
ZZWOLF9 , color=0x372414
ZZZFACE1 , color=0x4d4540
ZZZFACE2 , color=0x937963
ZZZFACE3 , color=0x937963
ZZZFACE4 , color=0x464857
ZZZFACE5 , color=0xab7b5a
ZZZFACE6 , color=0x000000
ZZZFACE7 , color=0x000000
ZZZFACE8 , color=0x261e19
ZZZFACE9 , color=0x3d392c

BLOOD1 , color=0x282e41
BLOOD2 , color=0x272e41
BLOOD3 , color=0x272d40
CEIL1_1 , color=0x836658
CEIL1_2 , color=0x554f56
CEIL1_3 , color=0x665b56
CEIL3_1 , color=0x35394c
CEIL3_2 , color=0x836759
CEIL3_4 , color=0x60554d
CEIL3_5 , color=0x1f331f
CEIL4_1 , color=0x1d1813
CEIL4_2 , color=0x3a4470
CEIL4_3 , color=0x505656
CEIL5_1 , color=0x1d1d1d
CEIL5_2 , color=0x393025
COMP01 , color=0x161515
CONS1_1 , color=0x16120c
CONS1_5 , color=0x3b3d38
CONS1_7 , color=0x544d48
CRATOP2 , color=0x1d1d1d
DEM1_1 , color=0x595959
DEM1_2 , color=0x404839
DEM1_3 , color=0x302112
DEM1_4 , color=0x6f6054
DEM1_5 , color=0x1d2240
DEM1_6 , color=0x36281d
FLAT1 , color=0x2d2d2d
FLAT10 , color=0x968980
FLAT14 , color=0x182441
FLAT17 , color=0x0f0f0f
FLAT18 , color=0x1f2440
FLAT19 , color=0x151514
FLAT1_1 , color=0x4e311e
FLAT1_2 , color=0x4b4039
FLAT1_3 , color=0x626262
FLAT2 , color=0x3d2b35
FLAT20 , color=0x241d16
FLAT22 , color=0x726559
FLAT23 , color=0x676767
FLAT4 , color=0x121212
FLAT5 , color=0x4d5c61
FLAT5_1 , color=0x2d241b
FLAT5_2 , color=0x4a3320
FLAT5_3 , color=0x20201c
FLAT5_4 , color=0x5a5a5a
FLAT5_5 , color=0x63564c
FLAT5_6 , color=0x120e08
FLAT5_8 , color=0x2d2d2a
FLAT8 , color=0x180c04
FLAT9 , color=0x131312
FLOOR0_1 , color=0xbc8b69
FLOOR0_2 , color=0x53463c
FLOOR0_3 , color=0x6a625c
FLOOR0_5 , color=0x615c58
FLOOR0_6 , color=0x665a52
FLOOR0_7 , color=0x273431
FLOOR1_1 , color=0x343231
FLOOR1_6 , color=0x5e1300
FLOOR1_7 , color=0x141313
FLOOR3_3 , color=0x4e3726
FLOOR4_1 , color=0x3f653f
FLOOR4_5 , color=0x170e06
FLOOR4_6 , color=0x000000
FLOOR4_8 , color=0x232323
FLOOR5_1 , color=0x626262
FLOOR5_2 , color=0x23372f
FLOOR5_3 , color=0x4c3010
FLOOR5_4 , color=0x2e2e2e
FLOOR6_1 , color=0x672e0f
FLOOR6_2 , color=0x5d534a
FLOOR7_1 , color=0x2e2620
FLOOR7_2 , color=0x3d2919
FWATER1 , color=0x333d66
FWATER2 , color=0x333d66
FWATER3 , color=0x323c64
FWATER4 , color=0x323b63
GATE1 , color=0x4d4333
GATE2 , color=0x262d4b
GATE3 , color=0x5e5552
GATE4 , color=0x444553
GRASS1 , color=0x58473c
GRASS2 , color=0x23251d
GRNLITE1 , color=0x423324
GRNROCK , color=0x182441
LAVA1 , color=0x2d231c
LAVA2 , color=0x2d231c
LAVA3 , color=0x2d231c
LAVA4 , color=0x2d231c
MFLR8_1 , color=0x41362e
MFLR8_2 , color=0x46311f
MFLR8_3 , color=0x26284e
MFLR8_4 , color=0x0f192b
NUKAGE1 , color=0x474f71
NUKAGE2 , color=0x464e71
NUKAGE3 , color=0x454d6e
RROCK02 , color=0x513220
RROCK03 , color=0x443b33
RROCK04 , color=0x5b4b3f
RROCK05 , color=0x342a22
RROCK06 , color=0x342a22
RROCK07 , color=0x342a22
RROCK08 , color=0x342a22
RROCK09 , color=0x6d5d51
RROCK10 , color=0x342a22
RROCK11 , color=0x342a22
RROCK12 , color=0x231e1a
RROCK13 , color=0x281d15
RROCK14 , color=0x3a3a3a
RROCK19 , color=0x2a2e41
RROCK20 , color=0x2f1d15
SFLR6_1 , color=0x3a3835
SFLR6_4 , color=0x733c0e
SFLR7_4 , color=0x130c07
SLIME01 , color=0xbd3811
SLIME02 , color=0xbd3910
SLIME03 , color=0xbd3a10
SLIME04 , color=0xbd3910
SLIME05 , color=0x404144
SLIME06 , color=0x404144
SLIME07 , color=0x404043
SLIME08 , color=0x404043
SLIME09 , color=0x264226
SLIME10 , color=0x264226
SLIME11 , color=0x254125
SLIME12 , color=0x244024
SLIME13 , color=0xbe3812
SLIME14 , color=0x2e3421
SLIME15 , color=0x24201d
SLIME16 , color=0x6a625c
STEP1 , color=0xab91cc
STEP2 , color=0x2b1e16
TLITE6_1 , color=0x111e11
TLITE6_4 , color=0x2d231c
TLITE6_5 , color=0x3b0b00
TLITE6_6 , color=0x654c2b
--]]


HARMONY.LIQUIDS =
{
  water   = { mat="WATER",   light=0.50, special=0 }
  w_steel = { mat="W_STEEL", light=0.50, special=0 }
  w_rock  = { mat="W_ROCK",  light=0.50, special=0 }
  w_ice   = { mat="W_ICE",   light=0.50, special=0 }

  lava    = { mat="LAVA",    light=0.75, special=16 }
  nukage  = { mat="NUKAGE",  light=0.65, special=16 }
}


----------------------------------------------------------------

HARMONY.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_switch =
  {
    _prefab = "EXIT_PILLAR",

    switch = "BROWNHUG"
    exit = "METAL"
    exitside = "METAL"
    special = 11
    tag = 0
  }


  ----| STAIRS |----

  Stair_Up1 =
  {
    _prefab = "STAIR_6"
    _where  = "chunk"
    _deltas = { 32,48,48,64,64,80 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "chunk"
    _deltas = { -32,-48,-64,-64,-80,-96 }
  }


  ---| LOCKED DOORS |---

  Locked_kz_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kz_blue"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    door = "HD6"
    key = "HW512"
    track = "DOORTRAK"

    special = 32
    tag = 0  -- kind_mult=26
  }

  Locked_kz_yellow =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kz_yellow"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "HD6"
    key = "HW511"
    track = "DOORTRAK"

    special = 34
    tag = 0  -- kind_mult=27
  }

  Locked_kz_red =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kz_red"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "HD6"
    key = "HW510"
    track = "DOORTRAK"

    special = 33
    tag = 0  -- kind_mult=28
  }


  ---| SWITCHED DOORS |---

  Door_SW_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_blue"
    _long = 192
    _deep = 32

    w = 128
    h = 112

    door = "LITE2"
    track = "DOORTRAK"

    door_h = 112
    special = 0
  }

  Switch_blue1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "chunk"
    _switch = "sw_blue"

    switch_h = 64
    switch = "SW1CMT"
    side = "LITE2"
    base = "LITE2"
    x_offset = 0
    y_offset = 50
    special = 103
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _prefab = "TELEPORT_PAD"
    _where  = "chunk"

    tele = "TELEPORT"
    side = "TELEPORT"

    x_offset = 0
    y_offset = 0
    peg = 1

    special = 97
    effect = 8
    light = 255
  }


}


----------------------------------------------------------------

HARMONY.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_switch = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50 }

--!!  keys = { kn_blue=50, kn_purple=50, kn_yellow=50 }

--!!  switch_doors = { Door_SW_blue = 50 }

--!!  lock_doors = { Locked_kz_blue=50, Locked_kz_red=50, Locked_kz_yellow=50 }

  teleporters = { Teleporter1 = 50 }

}


HARMONY.ROOM_THEMES =
{
  Tech_generic =
  {
    walls =
    {
      ORANJE3=50,
    }

    floors =
    {
      ORANJE3=50,
    }

    ceilings =
    {
      FLOOR4_8=50,
    }
  }

  Cave_generic =
  {
    naturals =
    {
      ROCKS=50
    }
  }

  Outdoors_generic =
  {
    floors =
    {
      ORANJE3=50,
    }

    naturals =
    {
      GRASS2=50, ROCKS=10
    }
  }
}


HARMONY.LEVEL_THEMES =
{
  harm_tech1 =
  {
    prob = 50

    liquids = { water=90, nukage=30, lava=10 }

    buildings = { Tech_generic=50 }

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }
  }
}


------------------------------------------------------------

HARMONY.MONSTERS =
{
  -- FIXME: heaps of guesswork here

  -- FIXME: need entry for 'falling'

  beastling =
  {
    level = 1
    prob = 35
    health = 150
    attack = "melee"
    damage = 25
  }

  critter =
  {
    level = 4
    prob = 15
    health = 100
    attack = "melee"
    damage = 15
  }

  follower =
  {
    level = 1
    prob = 50
    health = 30
    attack = "hitscan"
    damage = 10
--??  give = { {weapon="shotgun"}, {ammo="shell",count=4} }
  }

  predator =
  {
    level = 2
    prob = 60
    health = 60
    attack = "missile"
    damage = 20
  }

  centaur =
  {
    level = 5
    prob = 60
    skip_prob = 90
    crazy_prob = 40
    health = 500
    attack = "missile"
    damage = 45
    density = 0.7
  }

  mutant =
  {
    level = 3
    prob = 20
    health = 70
    attack = "hitscan"
    damage = 50
--??  give = { {weapon="minigun"}, {ammo="bullet",count=10} }
  }

  phage =
  {
    level = 6
    prob = 25
    health = 500
    attack = "missile"
    damage = 70
    density = 0.8
  }


  --- BOSS ---

  echidna =
  {
    level = 9
    prob = 20
    crazy_prob = 18
    skip_prob = 150
    health = 3000
    attack = "hitscan"
    damage = 70
    density = 0.2
  }
}


HARMONY.WEAPONS =
{
  -- FIXME: most of these need to be checked, get new firing rates (etc etc)

  blow_uppa_ya_face =
  {
    attack = "missile"
    rate = 0.7
    damage = 20
  }

  pistol =
  {
    pref = 5
    attack = "missile"
    rate = 2.0
    damage = 20
    ammo = "cell"
    per = 1
  }

  minigun =
  {
    pref = 70
    add_prob = 35
    start_prob = 40
    attack = "hitscan"
    rate = 8.5
    damage = 10
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=20} }
  }

  shotgun =
  {
    pref = 70
    add_prob = 10
    start_prob = 60
    attack = "hitscan"
    rate = 0.9
    damage = 70
    splash = { 0,10 }
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=8} }
  }

  launcher =
  {
    pref = 40
    add_prob = 25
    start_prob = 15
    attack = "missile"
    rate = 1.7
    damage = 80
    splash = { 50,20,5 }
    ammo = "grenade"
    per = 1
    give = { {ammo="grenade",count=2} }
  }

  entropy =
  {
    pref = 25
    add_prob = 13
    start_prob = 7
    rate = 11
    damage = 20
    attack = "missile"
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=40} }
  }
}


HARMONY.PICKUPS =
{
  -- HEALTH --

  mushroom_wow =
  {
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  first_aid =
  {
    prob = 100
    cluster = { 1,3 }
    give = { {health=25} }
  }

  mushroom_wow =
  {
    prob = 3
    big_item = true
    give = { {health=150} }
  }

  -- ARMOR --

  amazon_armor =
  {
    prob = 5
    armor = true
    big_item = true
    give = { {health=30} }
  }

  NDF_armor =
  {
    prob = 2
    armor = true
    big_item = true
    give = { {health=90} }
  }

  -- AMMO --

  mini_box =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="bullet", count=40} }
  }

  shell_box =
  {
    prob = 40
    cluster = { 1,4 }
    give = { {ammo="shell",count=10} }
  }

  cell_pack =
  {
    prob = 40
    give = { {ammo="cell",count=100} }
  }

  grenade =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="grenade",count=1} }
  }

  nade_belt =
  {
    prob = 40
    cluster = { 1,2 }
    give = { {ammo="grenade",count=5} }
  }
}


HARMONY.PLAYER_MODEL =
{
  harmony =
  {
    stats   = { health=0 }
    weapons = { pistol=1, blow_uppa_ya_face=1 }
  }
}


------------------------------------------------------------

function HARMONY.setup()
  -- nothing needed
end


function HARMONY.get_levels()
  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

  local EP_NUM = 1
  if MAP_NUM > 11 then EP_NUM = 2 end
  if MAP_NUM > 30 then EP_NUM = 3 end

  -- create episode info...

  for ep_index = 1,EP_NUM do
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  for map = 1,MAP_NUM do
    -- determine episode from map number
    local ep_index
    local ep_along

    if map >= 31 then
      ep_index = 2 ; ep_along = 0.35
    elseif map >= 21 then
      ep_index = 3 ; ep_along = (map - 20) / 10
    elseif map >= 12 then
      ep_index = 2 ; ep_along = (map - 11) / 9
    else
      ep_index = 1 ; ep_along = map / 11
    end

    local EPI = GAME.episodes[ep_index]
    assert(EPI)

    if OB_CONFIG.length == "single" then
      ep_along = rand.pick{ 0.2, 0.3, 0.4, 0.6, 0.8 }
    elseif OB_CONFIG.length == "few" then
      ep_along = map / MAP_NUM
    end

    local LEV =
    {
      episode = EPI

      name  = string.format("MAP%02d", map)
      patch = string.format("CWILV%02d", map-1)

      ep_along = ep_along
    }

    if map == 31 or map == 32 then
      -- secret levels are easy
      LEV.mon_along = 0.35
    elseif OB_CONFIG.length == "single" then
      LEV.mon_along = ep_along
    else
      -- difficulty ramps up over whole wad
      LEV.mon_along = map * 1.2 / math.min(MAP_NUM, 20)
    end

    -- secret levels
    if map == 31 or map == 32 then
      -- FIXME
    end

    table.insert( EPI.levels, LEV)
    table.insert(GAME.levels, LEV)
  end
end


function HARMONY.make_cool_gfx()
  local GREEN =
  {
    0, 7, 127, 126, 125, 124, 123,
    122, 120, 118, 116, 113
  }

  local BRONZE_2 =
  {
    0, 2, 191, 189, 187, 235, 233,
    223, 221, 219, 216, 213, 210
  }

  local RED =
  {
    0, 2, 188,185,184,183,182,181,
    180,179,178,177,176,175,174,173
  }

  local GOLD = { 0,47,44, 167,166,165,164,163,162,161,160, 225 }

  local SILVER = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 }


  local colmaps =
  {
    BRONZE_2, GREEN, RED, GOLD, SILVER
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, colmaps[4])

--[[ FIXME

  -- patches : HW313, HW316, HW329, HW309
  gui.wad_logo_gfx("RW23_1", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("RW25_3", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("RW33_2", "p", "RELIEF", 128,128, 3)
  gui.wad_logo_gfx("RW24_1", "p", "CARVE",  128,128, 4)

  -- flats
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)
--]]
end


function HARMONY.all_done()
  HARMONY.make_cool_gfx()
end


------------------------------------------------------------

UNFINISHED["harmony"] =
{
  label = "Harmony"

  format = "doom"

  tables = { HARMONY }

  hooks =
  {
    setup      = HARMONY.setup
    get_levels = HARMONY.get_levels
    all_done   = HARMONY.all_done
  }
}


OB_THEMES["harm_tech"] =
{
  label = "Tech"
  for_games = { harmony=1 }
  name_theme = "TECH"
  mixed_prob = 50
}

