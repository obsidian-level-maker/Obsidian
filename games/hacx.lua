----------------------------------------------------------------
--  GAME DEF : HacX 1.2
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009-2011 Andrew Apted
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

HACX = { }

HACX.ENTITIES =
{
  --- special stuff ---
  player1 = { id=1, kind="other", r=16,h=56 }
  player2 = { id=2, kind="other", r=16,h=56 }
  player3 = { id=3, kind="other", r=16,h=56 }
  player4 = { id=4, kind="other", r=16,h=56 }

  dm_player     = { id=11, kind="other", r=16,h=56 }
  teleport_spot = { id=14, kind="other", r=16,h=56 }

  --- pickups ---
  k_password = { id=5,  kind="pickup", r=20,h=16, pass=true }
  k_ckey     = { id=6,  kind="pickup", r=20,h=16, pass=true }
  k_keycard  = { id=13, kind="pickup", r=20,h=16, pass=true }

  kz_red     = { id=38, kind="pickup", r=20,h=16, pass=true }
  kz_yellow  = { id=39, kind="pickup", r=20,h=16, pass=true }
  kz_blue    = { id=40, kind="pickup", r=20,h=16, pass=true }

  dampener   = { id=2014, kind="pickup", r=20,h=16, pass=true }
  microkit   = { id=2011, kind="pickup", r=20,h=16, pass=true }
  hypo       = { id=2012, kind="pickup", r=20,h=16, pass=true }
  smart_drug = { id=2013, kind="pickup", r=20,h=16, pass=true }

  inhaler      = { id=2015, kind="pickup", r=20,h=16, pass=true }
  kevlar_armor = { id=2018, kind="pickup", r=20,h=16, pass=true }
  super_armor  = { id=2019, kind="pickup", r=20,h=16, pass=true }

  bullets     = { id=2007, kind="pickup", r=20,h=16, pass=true }
  bullet_box  = { id=2048, kind="pickup", r=20,h=16, pass=true }
  shells      = { id=2008, kind="pickup", r=20,h=16, pass=true }
  shell_box   = { id=2049, kind="pickup", r=20,h=16, pass=true }
  torpedos    = { id=2010, kind="pickup", r=20,h=16, pass=true }
  torpedo_box = { id=2046, kind="pickup", r=20,h=16, pass=true }
  molecules   = { id=2047, kind="pickup", r=20,h=16, pass=true }
  mol_tank    = { id=  17, kind="pickup", r=20,h=16, pass=true }

  --- scenery ---
  chair      = { id=35,   kind="scenery", r=24,h=40 }

}


HACX.PARAMETERS =
{
  rails = true
  light_brushes = true

  jump_height = 24

  max_name_length = 28

  skip_monsters = { 10,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
}


----------------------------------------------------------------

HACX.MATERIALS =
{
  -- FIXME!!! very incomplete

  -- special materials --
  _ERROR = { t="HW209", f="RROCK03" }
  _SKY   = { t="HW209", f="F_SKY1" }


  -- general purpose --

  METAL  = { t="HW209", f="RROCK03" }

  LIFT   = { t="HW176", f="DEM1_1" }


  -- walls --

  BROWNHUG = { t="BROWNHUG", f="BLOOD1" }

  DOORTRAK = { t="HW209", f="RROCK03" }

  HD6   = { t="HD6",   f="RROCK03" }
  HW510 = { t="HW510", f="SLIME15" }
  HW511 = { t="HW511", f="SLIME14" }
  HW512 = { t="HW512", f="SLIME13" }
  HW513 = { t="HW513", f="SLIME16" }

  TECHY1 = { t="HW172", f="FLAT5_1" }
  WOODY1 = { t="COMPTALL", f="RROCK14" }
  BLOCKY1 = { t="HW219", f="RROCK11" }
  BLOCKY2 = { t="MIDBRONZ", f="CONS1_1" }

  CAVEY1 = { t="MARBFAC4", f="RROCK12" }
  DIRTY1 = { t="PANCASE1", f="RROCK15" }
  DIRTY2 = { t="PANEL2",   f="RROCK15" }
  STONY1 = { t="PLANET1",  f="GRNROCK" }

  GRAY_ROCK = { t="HW185", f="FLOOR0_1" }

  DARK_CONC = { t="HW205", f="CONS1_5" }


  LITE2 = { t="LITE2", f="DEM1_2" }

  MODWALL3 = { t="MODWALL3", f="CEIL3_3" }


  -- switches --

  SW1CMT = { t="SW1CMT", f="DEM1_2" }


  -- floors --

  GRASS1 = { t="MARBGRAY", f="TLITE6_1" }
  GRASS2 = { t="MARBGRAY", f="CONS1_7" }

  GRAY_BRICK = { f="GRASS2", t="STARTAN3" }
  HERRING_1  = { f="FLAT9", t="HW306" }
  WOOD_TILE  = { f="CEIL5_2", t="MIDBARS1", }

--FLAT14   = { t="STARTAN3", f="FLAT14" }


  -- rails --

  CABLE   = { t="HW167",    rail_h=48 }
  SHARKS  = { t="FIREWALB", rail_h=128 }
  SHELVES = { t="TEKGREN1", rail_h=128 }
  GRILL   = { t="TEKGREN2", rail_h=128 }
  WEB     = { t="HW213",    rail_h=34 }

  CAGE3     = { t="SPACEW3", rail_h=128 }
  CAGE4     = { t="SPACEW4", rail_h=128 }
  CAGE_BUST = { t="HW181",   rail_h=128 }

  FORCE_FIELD = { t="SLADRIP1", rail_h=128 }
  HIGH_BARS   = { t="HW203",    rail_h=128 }
  BRIDGE_RAIL = { t="HW211",    rail_h=128 }
  SUPT_BEAM   = { t="SHAWN2",   rail_h=128 }
  BARRACADE   = { t="HW225",    rail_h=128 }

  DARK_CONC_HOLE = { t="HW204", rail_h=128 }
  GRAY_ROCK_HOLE = { t="HW183", rail_h=128 }
  WASHGTON_HOLE  = { t="HW353", rail_h=128 }


  -- liquids / animated --

  L_ELEC   = { f="NUKAGE1", t="HW177" }
  L_GOO    = { f="LAVA1",   t="HW325" }
  L_WATER  = { f="FWATER1", t="BLODRIP1" }
  L_WATER2 = { f="SLIME05", t="WFALL1" }
  L_LAVA   = { f="SLIME09", t="SFALL1" }
  L_SLIME  = { f="SLIME01", t="BRICK6" }

  TELEPORT = { f="BLOOD1",  t="BRONZE1" }


  -- other --

  O_PILL   = { t="HW313", f="O_PILL",   sane=1 }
  O_BOLT   = { t="HW316", f="O_BOLT",   sane=1 }
  O_RELIEF = { t="HW329", f="O_RELIEF", sane=1 }
  O_CARVE  = { t="HW309", f="O_CARVE",  sane=1 }
}


--[[ FIXME: incorporate these colors
ASHWALL2 , color=0x2a2721
ASHWALL3 , color=0x2c1909
ASHWALL4 , color=0x490601
ASHWALL6 , color=0x1f1106
ASHWALL7 , color=0x34311d
BFALL1 , color=0x272219
BFALL2 , color=0x272219
BFALL3 , color=0x272219
BFALL4 , color=0x282219
BIGBRIK1 , color=0x1e170d
BIGBRIK2 , color=0x262626
BIGBRIK3 , color=0x5c5b5b
BIGDOOR1 , color=0x414141
BIGDOOR2 , color=0x333332
BIGDOOR4 , color=0x262626
BLAKWAL1 , color=0xc60000
BLAKWAL2 , color=0x7b746f
BLODGR1 , color=0x2a2a2a
BLODGR2 , color=0x2a2a2a
BLODGR3 , color=0x2a2a2a
BLODGR4 , color=0x2a2a2a
BLODRIP1 , color=0x7575d8
BLODRIP2 , color=0x7575d8
BLODRIP3 , color=0x7575d8
BLODRIP4 , color=0x7373d7
BRICK1 , color=0x886c6c
BRICK10 , color=0x878787
BRICK11 , color=0x888080
BRICK12 , color=0x8a8a8a
BRICK2 , color=0x897979
BRICK3 , color=0x806954
BRICK4 , color=0xb1b1b1
BRICK5 , color=0x6a6148
BRICK6 , color=0x94735e
BRICK7 , color=0x4c3a29
BRICK8 , color=0x754c2a
BRICK9 , color=0x9f9f9f
BRICKLIT , color=0x8b8b8b
BRNBIGC , color=0x372c1f
BRNBIGL , color=0x231f1b
BRNBIGR , color=0x1e1107
BRNPOIS , color=0x2c2417
BRNPOIS2 , color=0x493f27
BRNSMAL1 , color=0x2d2c28
BRNSMAL2 , color=0x676150
BRNSMALC , color=0x35332a
BRNSMALL , color=0x483c26
BRNSMALR , color=0x0f210b
BRONZE1 , color=0x5a5a5a
BRONZE2 , color=0x5a5a5a
BRONZE3 , color=0xa6a6a6
BRONZE4 , color=0x898989
BROWN1 , color=0x897158
BROWN144 , color=0x897158
BROWN96 , color=0x346824
BROWNGRN , color=0x336022
BROWNHUG , color=0x2f6825
BROWNPIP , color=0xbd1b1a
BRWINDOW , color=0x898989
BSTONE1 , color=0x9d958f
BSTONE2 , color=0x49392c
BSTONE3 , color=0x6e5744
CEMENT7 , color=0x050b03
CEMENT8 , color=0x161408
CEMENT9 , color=0x100f10
COMP2 , color=0x565c40
COMPSPAN , color=0x4d6a49
COMPSTA1 , color=0x7a3c79
COMPSTA2 , color=0x736862
COMPTALL , color=0x5a4633
COMPTILE , color=0x8c603b
COMPUTE1 , color=0x662516
COMPUTE2 , color=0x483c5e
COMPUTE3 , color=0x474233
CRACKLE2 , color=0x211a13
CRACKLE4 , color=0x1a1207
CRATE3 , color=0x1e1809
DBRAIN1 , color=0x211b0f
DBRAIN2 , color=0x211b0f
DBRAIN3 , color=0x211b10
DBRAIN4 , color=0x211b0f
DOOR1 , color=0x393939
DOOR3 , color=0x424341
DOORBLU , color=0x828282
DOORRED , color=0x382420
DOORSTOP , color=0x898989
DOORTRAK , color=0x11100b
DOORYEL , color=0x413d26
EXITDOOR , color=0x575450
EXITSIGN , color=0x5e4128
FIREWALA , color=0x3a3a39
FIREWALB , color=0x3a3939
FIREWALC , color=0x393939
FIREWALD , color=0x3a3a39
FIREWALL , color=0x3a3a3a
GRAY4 , color=0x7c6723
GRAY5 , color=0x000000
GRAY7 , color=0x4c4a41
GRAYTALL , color=0x332e29
GSTFONT1 , color=0x564e79
GSTFONT2 , color=0x544c77
GSTFONT3 , color=0x554e78
HD1 , color=0x17140d
HD2 , color=0x353535
HD3 , color=0x474747
HD4 , color=0x3b2e1d
HD5 , color=0x373431
HD6 , color=0x15110a
HD7 , color=0x18130b
HD8 , color=0x404338
HD9 , color=0x4e3833
HW162 , color=0x655252
HW163 , color=0x675050
HW164 , color=0x727272
HW165 , color=0x432d2d
HW166 , color=0x20211d
HW167 , color=0x544c4a
HW168 , color=0xa3866d
HW169 , color=0x964812
HW170 , color=0x4d2f15
HW171 , color=0x2c1d10
HW172 , color=0x473d34
HW173 , color=0x443a32
HW174 , color=0x494949
HW175 , color=0x454545
HW176 , color=0x515151
HW177 , color=0x4d4d4d
HW178 , color=0x5f5f5f
HW179 , color=0x6a6a6a
HW180 , color=0x352a2a
HW181 , color=0x7e7d7d
HW182 , color=0x242422
HW183 , color=0x282828
HW184 , color=0x292929
HW185 , color=0x282828
HW186 , color=0x382c1f
HW187 , color=0x20170c
HW188 , color=0x1f180f
HW189 , color=0x1e1919
HW190 , color=0x161515
HW191 , color=0x845950
HW192 , color=0x4d3c36
HW193 , color=0x5a4034
HW194 , color=0x272724
HW195 , color=0x282824
HW196 , color=0x2e2e29
HW197 , color=0x302f29
HW198 , color=0x26231d
HW199 , color=0x2f2f2d
HW200 , color=0x3c2c18
HW201 , color=0x3b2c18
HW202 , color=0x211a12
HW203 , color=0x322c22
HW204 , color=0x25241e
HW205 , color=0x282927
HW206 , color=0x646260
HW207 , color=0x807e7c
HW208 , color=0xbdbdbc
HW209 , color=0x2c2619
HW210 , color=0x42403d
HW211 , color=0x404040
HW212 , color=0x545454
HW213 , color=0x545454
HW214 , color=0x6a665f
HW215 , color=0xbdbcbb
HW216 , color=0x28200c
HW217 , color=0x262626
HW218 , color=0x272727
HW219 , color=0x1f190b
HW221 , color=0xb1b1b0
HW222 , color=0x252525
HW223 , color=0x2f2e2a
HW224 , color=0x373737
HW225 , color=0x3d3d3d
HW226 , color=0x472313
HW227 , color=0x202020
HW228 , color=0x202020
HW229 , color=0x322718
HW24 , color=0x534c77
HW300 , color=0x2f2b23
HW301 , color=0x232412
HW302 , color=0x94613a
HW303 , color=0xa75151
HW304 , color=0x636363
HW305 , color=0x464646
HW306 , color=0x806d56
HW307 , color=0x999999
HW308 , color=0x3d242b
HW309 , color=0x413637
HW310 , color=0x1e1e1e
HW311 , color=0x1e1e1b
HW312 , color=0x251d0b
HW313 , color=0x6b6b6b
HW314 , color=0x3e3e3e
HW315 , color=0x616160
HW316 , color=0x74695c
HW317 , color=0x4f3b26
HW318 , color=0x7f6441
HW319 , color=0x715e41
HW320 , color=0x412e19
HW321 , color=0x382715
HW322 , color=0x272313
HW323 , color=0x3e3d28
HW324 , color=0x6f5b43
HW325 , color=0x616161
HW326 , color=0x30302f
HW327 , color=0x3e3e3c
HW328 , color=0x3a3b3a
HW329 , color=0x35322e
HW330 , color=0x382715
HW331 , color=0x5e4a34
HW332 , color=0x413528
HW333 , color=0x655b49
HW334 , color=0x55442f
HW335 , color=0x635543
HW336 , color=0x504b44
HW337 , color=0x4e402b
HW338 , color=0x4e2713
HW339 , color=0x4b3721
HW340 , color=0x594229
HW341 , color=0x5b4127
HW343 , color=0x747474
HW344 , color=0x8b8b8b
HW345 , color=0x696969
HW347 , color=0x5c5c5c
HW348 , color=0x7a7a7a
HW349 , color=0x7b7b7b
HW350 , color=0x7f7f7f
HW351 , color=0x7e7e7e
HW352 , color=0x727272
HW353 , color=0x7e7e7e
HW354 , color=0x828282
HW355 , color=0x818181
HW356 , color=0x7e7e7e
HW357 , color=0x838383
HW358 , color=0x787878
HW361 , color=0xcbcbcb
HW363 , color=0x564733
HW364 , color=0x574935
HW365 , color=0x2c2110
HW366 , color=0x362d1d
HW367 , color=0x48433c
HW500 , color=0x100e0b
HW501 , color=0x272317
HW502 , color=0x282317
HW503 , color=0x2a2417
HW504 , color=0x292418
HW505 , color=0x372612
HW506 , color=0x372612
HW507 , color=0x372612
HW508 , color=0x352511
HW509 , color=0x352511
HW510 , color=0x51140f
HW511 , color=0x6d6729
HW512 , color=0x1a1547
HW513 , color=0x1b1713
HW600 , color=0x464235
HW601 , color=0x4d4736
LITE2 , color=0x3e3f3c
LITE3 , color=0x6b5539
LITE4 , color=0x5a5651
LITE5 , color=0x5c5c5c
LITEBLU1 , color=0x262626
LITEBLU2 , color=0x292b0f
LITEBLU3 , color=0x6a6a6a
LITEBLU4 , color=0x121212
MARBFAC4 , color=0x251b09
MARBGRAY , color=0x1d2614
METAL1 , color=0x514028
METAL2 , color=0x19160f
METAL3 , color=0x372a19
METAL4 , color=0x372e1c
METAL5 , color=0x252524
METAL6 , color=0x292928
METAL7 , color=0x3f3a34
MIDBARS1 , color=0x4d473f
MIDBARS3 , color=0x24201c
MIDBRONZ , color=0x1e1911
MIDSPACE , color=0x959391
MODWALL1 , color=0x20281b
MODWALL2 , color=0x151b0f
MODWALL3 , color=0xa4907b
MODWALL4 , color=0x3e3833
NUKE24 , color=0x454545
NUKEDGE1 , color=0x352511
NUKESLAD , color=0xc2c2c2
PANBLACK , color=0x433216
PANBLUE , color=0x211709
PANBOOK , color=0x392b1b
PANBORD1 , color=0x4a3522
PANBORD2 , color=0x22180e
PANCASE1 , color=0x342819
PANCASE2 , color=0x402f15
PANEL1 , color=0x2f2519
PANEL2 , color=0x2e2418
PANEL3 , color=0x201910
PANEL4 , color=0x281b12
PANEL5 , color=0x271b0d
PANEL6 , color=0x4a3d3c
PANEL7 , color=0x312b25
PANEL8 , color=0x2d2922
PANEL9 , color=0x292216
PANRED , color=0x959595
PIPE2 , color=0x3b2c20
PIPES , color=0x919191
PIPEWAL1 , color=0x5c5b5b
PIPEWAL2 , color=0x85715b
PLANET1 , color=0x4b3822
PLAT1 , color=0x636363
REDWALL1 , color=0x313131
ROCK1 , color=0x7c6b57
ROCK2 , color=0x655740
ROCK3 , color=0x54483b
ROCK4 , color=0xbebfbd
ROCK5 , color=0x747077
SAILBOTA , color=0x751917
SAILBOTB , color=0x5f1712
SAILTOPA , color=0x741917
SAILTOPB , color=0x5f1a13
SFALL1 , color=0xbc4b03
SFALL2 , color=0xba4a03
SFALL3 , color=0xbc4b04
SFALL4 , color=0xbc4b04
SHAWN2 , color=0x373737
SILVER1 , color=0x715d4a
SILVER2 , color=0x5b5c57
SILVER3 , color=0x3e3c3a
SKY1 , color=0x5b4837
SKY2 , color=0x520302
SKY3 , color=0x100302
SK_LEFT , color=0x383737
SK_RIGHT , color=0x3c3c3b
SLADPOIS , color=0x503428
SLADRIP1 , color=0xb82c29
SLADRIP2 , color=0xba2c2a
SLADRIP3 , color=0xbb2d2a
SLADWALL , color=0x584a3c
SLOPPY1 , color=0x322f2c
SLOPPY2 , color=0x413f3c
SPACEW2 , color=0x392f27
SPACEW3 , color=0x797978
SPACEW4 , color=0x7d7d7d
SPCDOOR1 , color=0x50504f
SPCDOOR2 , color=0xb87b53
SPCDOOR3 , color=0x696968
SPCDOOR4 , color=0x7c6d62
SP_DUDE7 , color=0x9f9f9e
SP_DUDE8 , color=0xb49d9d
SP_FACE2 , color=0xc6bdb9
STARG1 , color=0x6d5742
STARG3 , color=0x826647
STARGR1 , color=0x8a7256
STARTAN1 , color=0x182015
STARTAN2 , color=0x383838
GRAY_BRICK , color=0x4a4841
STEP1 , color=0x1b1b14
STEP2 , color=0x19110b
STEP3 , color=0x4b2c13
STEP4 , color=0x110d03
STEP5 , color=0x1f1811
STEP6 , color=0x0a0806
STONE , color=0x1d1d1d
STONE2 , color=0x7e0400
STONE3 , color=0x120b04
STONE4 , color=0xdd7f76
STONE5 , color=0x9d4431
STONE6 , color=0x8181fb
STONE7 , color=0x90605f
STONPOIS , color=0x0e0a07
STUCCO , color=0x5f0d3c
STUCCO1 , color=0xa32e1b
STUCCO2 , color=0xc10202
STUCCO3 , color=0x93655e
SUPPORT2 , color=0x4a4942
SW1BLUE , color=0x5e1916
SW1BRCOM , color=0x504d4d
SW1BRIK , color=0x53524f
SW1BRN1 , color=0x50504f
SW1BRN2 , color=0x4c403b
SW1BRNGN , color=0x493f3e
SW1BROWN , color=0xd3d0cc
SW1CMT , color=0x393126
SW1COMM , color=0x252525
SW1COMP , color=0x3e3833
SW1DIRT , color=0x3e3833
SW1EXIT , color=0x3e3833
SW1GARG , color=0x3e3833
SW1GRAY , color=0x3e3833
SW1GRAY1 , color=0x3e3833
SW1GSTON , color=0x4c4b45
SW1HOT , color=0x504438
SW1LION , color=0x7c5f42
SW1MARB , color=0x7c6041
SW1MET2 , color=0x83674a
SW1METAL , color=0x614c34
SW1MOD1 , color=0x5d5d5c
SW1PANEL , color=0x454545
SW1PIPE , color=0x614c34
SW1ROCK , color=0x292929
SW1SATYR , color=0x7c5f42
SW1SKIN , color=0x7c5f42
SW1SKULL , color=0x333014
SW1SLAD , color=0x614c34
SW1STARG , color=0x614c34
SW1STON1 , color=0x614c34
SW1STON2 , color=0x614c34
SW1STON6 , color=0x6e6e6e
SW1STONE , color=0x614c34
SW1STRTN , color=0x614c34
SW1TEK , color=0x372b13
SW1VINE , color=0x3e3833
SW1WDMET , color=0x6f6f6f
SW1WOOD , color=0x7c5f42
SW1ZIM , color=0x34261a
SW2BLUE , color=0x5e1917
SW2BRCOM , color=0x504e4d
SW2BRIK , color=0x474643
SW2BRN1 , color=0x535150
SW2BRN2 , color=0x493f3e
SW2BRNGN , color=0x32302e
SW2BROWN , color=0xd4d0cc
SW2CMT , color=0x383026
SW2COMM , color=0x202020
SW2COMP , color=0x614c34
SW2DIRT , color=0x614c34
SW2EXIT , color=0x614c34
SW2GARG , color=0x7c5f42
SW2GRAY , color=0x614c34
SW2GRAY1 , color=0x614c34
SW2GSTON , color=0x4c4b45
SW2HOT , color=0x7c5f42
SW2LION , color=0x7c5f42
SW2MARB , color=0x7c6041
SW2MET2 , color=0x83674a
SW2METAL , color=0x614c34
SW2MOD1 , color=0x5d5d5c
SW2PANEL , color=0x454545
SW2PIPE , color=0x816954
SW2ROCK , color=0x292929
SW2SATYR , color=0x7c5f42
SW2SKIN , color=0x7c5f42
SW2SKULL , color=0x342618
SW2SLAD , color=0x614c34
SW2STARG , color=0x614c34
SW2STON1 , color=0x614c34
SW2STON2 , color=0x614c34
SW2STON6 , color=0x6e6e6e
SW2STONE , color=0x1a1a1a
SW2STRTN , color=0x614c34
SW2TEK , color=0x372b13
SW2VINE , color=0x3e3833
SW2WDMET , color=0x6f6f6f
SW2WOOD , color=0x7c5f42
SW2ZIM , color=0x34261a
TANROCK2 , color=0xc30000
TANROCK3 , color=0xf0a0a0
TANROCK4 , color=0x533f2d
TANROCK5 , color=0x1f170f
TANROCK7 , color=0x1f150a
TANROCK8 , color=0x0c0905
TEKBRON1 , color=0x6b5541
TEKBRON2 , color=0x443529
TEKGREN1 , color=0x1d1a15
TEKGREN2 , color=0x4b4841
TEKGREN3 , color=0x303423
TEKGREN4 , color=0x28232b
TEKGREN5 , color=0x2b2b2f
TEKLITE , color=0x393938
TEKLITE2 , color=0x0f0f0e
TEKWALL1 , color=0x302b25
TEKWALL2 , color=0x55443a
TEKWALL3 , color=0x493f27
TEKWALL4 , color=0x28201a
TEKWALL5 , color=0x402e20
TEKWALL6 , color=0x101010
WFALL1 , color=0x0000a2
WFALL2 , color=0x00009d
WFALL3 , color=0x00009e
WFALL4 , color=0x0000a2
WOOD10 , color=0x20201f
WOOD12 , color=0x3e3e3e
WOOD6 , color=0x1c1b1a
WOOD7 , color=0x1c1b1a
WOOD8 , color=0x2c2c2c
WOOD9 , color=0x5a5957
WOODMET1 , color=0x3f342b
WOODMET2 , color=0x3c2522
WOODMET3 , color=0x380d08
WOODMET4 , color=0x31302f
WOODVERT , color=0x504e4a
ZDOORB1 , color=0x18130b
ZDOORF1 , color=0x1a150e
ZELDOOR , color=0x0b0906
ZIMMER1 , color=0x53483a
ZIMMER2 , color=0x272727
ZIMMER3 , color=0x3e3223
ZIMMER4 , color=0x2e2e2e
ZIMMER5 , color=0x27231f
ZIMMER7 , color=0x232222
ZIMMER8 , color=0x222322
ZZWOLF1 , color=0x2e210f
ZZWOLF10 , color=0x2e220f
ZZWOLF11 , color=0x2e220f
ZZWOLF12 , color=0x2f2310
ZZWOLF13 , color=0x51371e
ZZWOLF2 , color=0x253024
ZZWOLF3 , color=0x401d1d
ZZWOLF4 , color=0xa2998f
ZZWOLF5 , color=0x52361b
ZZWOLF6 , color=0x1b1b1b
ZZWOLF7 , color=0x492d2b
ZZWOLF9 , color=0x3b0302
ZZZFACE1 , color=0x0b1809
ZZZFACE2 , color=0x20221e
ZZZFACE3 , color=0x765d48
ZZZFACE4 , color=0x69473d
ZZZFACE5 , color=0x67493f
ZZZFACE6 , color=0x8a6b5d
ZZZFACE7 , color=0x8b6c5d
ZZZFACE8 , color=0x846355
ZZZFACE9 , color=0x97786a

BLOOD1 , color=0x3f533b
BLOOD2 , color=0x394a36
BLOOD3 , color=0x3c4c38
CEIL1_1 , color=0xb8b8b8
CEIL1_2 , color=0x797060
CEIL1_3 , color=0x20211c
CEIL3_1 , color=0x9d9087
CEIL3_2 , color=0x696969
CEIL3_3 , color=0x967e66
CEIL3_4 , color=0x383835
CEIL3_5 , color=0x696969
CEIL3_6 , color=0x615452
CEIL4_1 , color=0xac7e57
CEIL4_2 , color=0x696969
CEIL4_3 , color=0x686868
CEIL5_1 , color=0x524d38
*WOOD_TILE , color=0x725b44
COMP01 , color=0x595754
CONS1_1 , color=0x2a230e
CONS1_5 , color=0x131313
CONS1_7 , color=0x14250f
CRATOP1 , color=0x877a67
CRATOP2 , color=0x7f7b63
DEM1_1 , color=0x6b6b6a
DEM1_2 , color=0x2c2c2c
DEM1_3 , color=0xa08e82
DEM1_4 , color=0x9a928c
DEM1_5 , color=0x9b8371
DEM1_6 , color=0x231d17
FLAT1 , color=0x000000
FLAT10 , color=0x616161
FLAT14 , color=0x2f2f30
FLAT17 , color=0x604443
FLAT18 , color=0x5f5f5e
FLAT19 , color=0x606060
FLAT1_1 , color=0x892b02
FLAT1_2 , color=0x5a4a44
FLAT1_3 , color=0x65482c
FLAT2 , color=0x816c25
FLAT20 , color=0x303e28
FLAT22 , color=0x8d8d8d
FLAT23 , color=0x1e4214
FLAT3 , color=0x980000
FLAT4 , color=0x1d1d33
FLAT5 , color=0x3f1107
FLAT5_1 , color=0x634d3a
FLAT5_2 , color=0x930301
FLAT5_3 , color=0x3b1b0a
FLAT5_4 , color=0x352b20
FLAT5_5 , color=0x362313
FLAT5_6 , color=0x3a342d
FLAT5_7 , color=0x343434
FLAT5_8 , color=0x4f412e
FLAT8 , color=0x474747
*HERRING_1 , color=0x736359
FLOOR0_1 , color=0x343433
FLOOR0_2 , color=0x9f9f9f
FLOOR0_3 , color=0x448d33
FLOOR0_5 , color=0x981e03
FLOOR0_6 , color=0x5a4c3d
FLOOR0_7 , color=0x5f503a
FLOOR1_1 , color=0x353639
FLOOR1_6 , color=0x3e5128
FLOOR1_7 , color=0x373a34
FLOOR3_3 , color=0x3b3639
FLOOR4_1 , color=0x707070
FLOOR4_5 , color=0xcb1717
FLOOR4_6 , color=0xcc8659
FLOOR4_8 , color=0x5c594f
FLOOR5_1 , color=0xcb1717
FLOOR5_2 , color=0x6c1010
FLOOR5_3 , color=0xa2a2a2
FLOOR5_4 , color=0x520303
FLOOR6_1 , color=0x565753
FLOOR6_2 , color=0x918f8d
FLOOR7_1 , color=0x4c4d4a
FLOOR7_2 , color=0x4f504c
FWATER1 , color=0x2323b8
FWATER2 , color=0x2121b2
FWATER3 , color=0x1f1fb0
FWATER4 , color=0x1e1eb7
GATE1 , color=0x5c5558
GATE2 , color=0xaa9c8e
GATE3 , color=0x453b4f
GATE4 , color=0x575755
GRASS1 , color=0x3a3a38
GRASS2 , color=0x4a4841
GRNLITE1 , color=0x24201c
GRNROCK , color=0x362919
LAVA1 , color=0x9b9996
LAVA2 , color=0x989693
LAVA3 , color=0x969492
LAVA4 , color=0x9a9895
MFLR8_1 , color=0x333530
MFLR8_2 , color=0x7e654c
MFLR8_3 , color=0x5c0505
MFLR8_4 , color=0x111161
NUKAGE1 , color=0x565674
NUKAGE2 , color=0x585875
NUKAGE3 , color=0x575777
RROCK01 , color=0x4d4945
RROCK02 , color=0x2a2517
RROCK03 , color=0x272319
RROCK04 , color=0x67635c
RROCK05 , color=0x1e1e1e
RROCK06 , color=0x202020
RROCK07 , color=0x212121
RROCK08 , color=0x212020
RROCK09 , color=0x28200c
RROCK10 , color=0x2e2b23
RROCK11 , color=0x251d0b
RROCK12 , color=0x18130b
RROCK13 , color=0x222210
RROCK14 , color=0x392813
RROCK15 , color=0x352819
SFLR6_1 , color=0xc5c5c5
SFLR6_4 , color=0xc5c5c5
SFLR7_1 , color=0x686445
SFLR7_4 , color=0x2f2f2f
SLIME01 , color=0x584122
SLIME02 , color=0x584122
SLIME03 , color=0x594122
SLIME04 , color=0x584122
SLIME05 , color=0x0000a2
SLIME06 , color=0x00009d
SLIME07 , color=0x00009e
SLIME08 , color=0x0000a2
SLIME09 , color=0xf27314
SLIME10 , color=0xf07214
SLIME11 , color=0xef7113
SLIME12 , color=0xef7113
SLIME13 , color=0x191547
SLIME14 , color=0x6e6729
SLIME15 , color=0x51140f
SLIME16 , color=0x1b1712
STEP1 , color=0x9c836c
STEP2 , color=0x212220
TLITE6_1 , color=0x282e1b
TLITE6_4 , color=0x1f211b
TLITE6_5 , color=0x949494
TLITE6_6 , color=0x31332f
--]]


HACX.LIQUIDS =
{
  water  = { mat="L_WATER",  light=0.65, special=0 }
  water2 = { mat="L_WATER2", light=0.65, special=0 }
  slime  = { mat="L_SLIME",  light=0.65, special=16 }
  goo    = { mat="L_GOO",    light=0.65, special=16 }
  lava   = { mat="L_LAVA",   light=0.75, special=16 }
  elec   = { mat="L_ELEC",   light=0.75, special=16 }
}


----------------------------------------------------------------

HACX.SKINS =
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

  Lift_Up1 =
  {
    _prefab = "LIFT_UP"
    _where  = "chunk"
    _tags   = 1
    _deltas = { 96,128,160,192 }

    lift = "LIFT"
     top = "LIFT"

    walk_kind   = 88
    switch_kind = 62
  }

  Lift_Down1 =
  {
    _prefab = "LIFT_DOWN"
    _where  = "chunk"
    _tags   = 1
    _deltas = { -96,-128,-160,-192 }

    lift = "LIFT"
     top = "LIFT"

    walk_kind   = 88
    switch_kind = 62
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

HACX.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_switch = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
              Lift_Up1 = 10,  Lift_Down1 = 10 }

  keys = { kz_red=50, kz_blue=50, kz_yellow=50 }

  switches = { sw_blue = 50 }

  switch_fabs = { Switch_blue1 = 50 }

  locked_doors = { Locked_kz_blue=50, Locked_kz_red=50, Locked_kz_yellow=50,
                   Door_SW_blue = 50 }

  teleporters = { Teleporter1 = 50 }
}


HACX.NAME_THEMES =
{
}


HACX.ROOM_THEMES =
{
  Urban_generic =
  {
    walls =
    {
      MODWALL3=50, STONY1=50, TECHY1=50, CAVEY1=50, BLOCKY1=50, BLOCKY2=50
    }

    floors =
    {
      MODWALL3=50, STONY1=50, TECHY1=50, CAVEY1=50, BLOCKY1=50, WOODY1=50
      WOOD_TILE=50,
    }

    ceilings =
    {
      MODWALL3=50, STONY1=50, TECHY1=50, CAVEY1=50, BLOCKY1=50, WOODY1=50
    }
  }

  Cave_generic =
  {
    naturals = { GRAY_ROCK=50 }
  }

  Outdoors_generic =
  {
    floors = { HERRING_1=50, GRAY_BRICK=50 }

    naturals = { GRAY_ROCK=50, DIRTY1=50, GRASS1=50 }
  }
}


HACX.LEVEL_THEMES =
{
  hacx_urban1 =
  {
    prob = 50

    liquids = { water=90, water2=50, elec=90, lava=50, slime=20, goo=10 }

    buildings = { Urban_generic=50 }

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

    -- hallways = { blah }

    -- TODO: more stuff
  }

  -- TODO: more themes (e.g. cyberspace)
}


------------------------------------------------------------


HACX.MONSTERS =
{
  thug =
  {
    id = 3004
    r = 21
    h = 72
    level = 1
    prob = 60
    health = 60
    damage = 5
    attack = "hitscan"
  }

  android =
  {
    id = 9
    r = 21
    h = 70
    level = 2
    prob = 50
    health = 75
    damage = 10
    attack = "hitscan"
  }

  stealth =
  {
    id = 58
    r = 32
    h = 68
    level = 1
    prob = 5
    health = 30
    damage = 25
    attack = "melee"
    float = true
    invis = true
    density = 0.25
  }

  -- this thing just blows up on contact
  roam_mine =
  {
    id = 84
    r = 5
    h = 32
    level = 1
    prob = 12
    health = 50
    damage = 5
    attack = "hitscan"
    float = true
    density = 0.5
  }

  phage =
  {
    id = 67
    r = 25
    h = 96
    level = 3
    prob = 40
    health = 150
    damage = 70
    attack = "missile"
  }

  buzzer =
  {
    id = 3002
    r = 25
    h = 68
    level = 3
    prob = 25
    health = 175
    damage = 25
    attack = "melee"
    float = true
  }

  i_c_e =
  {
    id = 3001
    r = 32
    h = 56
    level = 4
    prob = 10
    health = 225
    damage = 7
    attack = "melee"
  }

  d_man =
  {
    id = 3006
    r = 48
    h = 78
    level = 4
    prob = 10
    health = 250
    damage = 7
    attack = "melee"
    float = true
  }

  monstruct =
  {
    id = 65
    r = 35
    h = 88
    level = 5
    prob = 50
    health = 400
    damage = 80
    attack = "missile"
  }

  majong7 =
  {
    id = 71
    r = 31
    h = 56
    level = 5
    prob = 10
    health = 400
    damage = 20
    attack = "missile"
    density = 0.5
    weap_prefs = { launch=0.2 }
  }

  terminatrix =
  {
    id = 3003
    r = 32
    h = 80
    level = 6
    prob = 25
    health = 450
    damage = 40
    attack = "hitscan"
    density = 0.8
  }

  thorn =
  {
    id = 68
    r = 66
    h = 96
    level = 7
    prob = 25
    health = 600
    damage = 70
    attack = "missile"
  }

  mecha =
  {
    id = 69
    r = 24
    h = 96
    level = 8
    prob = 10
    health = 800
    damage = 150
    attack = "missile"
    density = 0.2
  }
}


HACX.WEAPONS =
{
  boot =
  {
    rate = 2.5
    damage = 5
    attack = "melee"
  }

  pistol =
  {
    pref = 5
    rate = 2.0
    damage = 20
    attack = "hitscan"
    ammo = "bullet"
    per = 1
  }

  reznator =
  {
    id = 2005
    level = 1
    pref = 2
    add_prob = 2
    attack = "melee"
    rate = 8.6
    damage = 10
  }

  tazer =
  {
    id = 2001
    level = 1
    pref = 20
    add_prob = 10
    start_prob = 60
    attack = "hitscan"
    rate = 1.2
    damage = 70
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=8} }
  }

  cyrogun =
  {
    id = 82
    level = 3
    pref = 40
    add_prob = 20
    attack = "hitscan"
    rate = 0.9
    damage = 170
    splash = { 0,30 }
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=8} }
  }

  fu2 =
  {
    id = 2002
    level = 3
    pref = 40
    add_prob = 35
    attack = "hitscan"
    rate = 8.6
    damage = 10
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=20} }
  }

  zooka =
  {
    id = 2003
    level = 3
    pref = 20
    add_prob = 25
    attack = "missile"
    rate = 1.7
    damage = 80
    splash = { 50,20,5 }
    ammo = "torpedo"
    per = 1
    give = { {ammo="torpedo",count=2} }
  }

  antigun =
  {
    id = 2004
    level = 5
    pref = 50
    add_prob = 13
    attack = "missile"
    rate = 16
    damage = 20
    ammo = "molecule"
    per = 1
    give = { {ammo="molecule",count=40} }
  }

  nuker =
  {
    id = 2006
    level = 7
    pref = 20
    add_prob = 30
    attack = "missile"
    rate = 1.4
    damage = 300
    splash = {60,60,60,60, 60,60,60,60 }
    ammo = "molecule"
    per = 40
    give = { {ammo="molecule",count=40} }
  }
}


HACX.PICKUPS =
{
  -- HEALTH --

  dampener =
  {
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  microkit =
  {
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  hypo =
  {
    prob = 100
    cluster = { 1,3 }
    give = { {health=25} }
  }

  smart_drug =
  {
    prob = 3
    big_item = true
    give = { {health=150} }
  }

  -- ARMOR --

  inhaler =
  {
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  kevlar_armor =
  {
    prob = 5
    armor = true
    big_item = true
    give = { {health=30} }
  }

  super_armor =
  {
    prob = 2
    armor = true
    big_item = true
    give = { {health=90} }
  }

  -- AMMO --

  bullets =
  {
    prob = 10
    cluster = { 2,5 }
    give = { {ammo="bullet",count=10} }
  }

  bullet_box =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="bullet", count=50} }
  }

  shells =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="shell",count=4} }
  }

  shell_box =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="shell",count=20} }
  }

  torpedos =
  {
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="torpedo",count=1} }
  }

  torpedo_box =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="torpedo",count=5} }
  }

  molecules =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="molecule",count=20} }
  }

  mol_tank =
  {
    prob = 40
    cluster = { 1,2 }
    give = { {ammo="molecule",count=100} }
  }
}


HACX.PLAYER_MODEL =
{
  danny =
  {
    stats   = { health=0 }
    weapons = { pistol=1, boot=1 }
  }
}


------------------------------------------------------------

function HACX.setup()
  -- nothing needed
end


function HACX.get_levels()
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


function HACX.make_cool_gfx()
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
end


function HACX.all_done()
  HACX.make_cool_gfx()
end


------------------------------------------------------------

UNFINISHED["hacx"] =
{
  label = "HacX 1.2"

  format = "doom"

  tables = { HACX }

  hooks =
  {
    setup      = HACX.setup
    get_levels = HACX.get_levels
    all_done   = HACX.all_done
  }
}


OB_THEMES["hacx_urban"] =
{
  label = "Urban"
  for_games = { hacx=1 }
  name_theme = "URBAN"
  mixed_prob = 50
}

