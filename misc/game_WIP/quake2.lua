----------------------------------------------------------------
-- GAME DEF : Quake II
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2011 Andrew Apted
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

QUAKE2 = { }

QUAKE2.ENTITIES =
{
  -- players
  player1 = { id="info_player_start", r=16, h=56 }
  player2 = { id="info_player_coop",  r=16, h=56 }
  player3 = { id="info_player_coop",  r=16, h=56 }
  player4 = { id="info_player_coop",  r=16, h=56 }

  dm_player = { id="info_player_deathmatch" }

  teleport_spot = { id="info_notnull" }
  teleporter    = { id="misc_teleporter" }
  tele_pad      = { id="misc_teleporter_dest" }

  -- keys
  k_blue  = { id="key_blue_key" }
  k_red   = { id="key_red_key" }
  k_cd    = { id="key_data_cd" }
  k_pass  = { id="key_pass" }
  k_cube  = { id="key_power_cube" }
  k_pyr   = { id="key_pyramid" }

  -- powerups
  adrenaline = { id="item_adrenaline" }
  bandolier  = { id="item_bandolier" }
  breather   = { id="item_breather" }
  enviro     = { id="item_enviro" }
  invuln     = { id="item_invulnerability" }
  quad       = { id="item_quad" }

  -- scenery
  barrel      = { id="misc_explobox", r=20, h=40, pass=true }
  dead_dude   = { id="misc_deadsoldier", r=20, h=60, pass=true }
  insane_dude = { id="misc_insane",  r=20, h=60, pass=true }
  -- FIXME: varieties of insane_dude!

  -- special

  light = { id="light" }
  sun   = { id="oblige_sun" }

  door   = { id="func_door" }
  lift   = { id="func_plat" }
  wall   = { id="func_wall" }
  button = { id="func_button" }

  trigger  = { id="trigger_multiple" }
  trig_key = { id="trigger_key" }
   
  change_lev = { id="target_changelevel" }

  camera = { id="info_player_intermission" }

  -- TODO
}


QUAKE2.PARAMETERS =
{
  map_limit = 8000  -- verified (limit of C/S protocol)

  centre_map = true

  use_spawnflags = true
  entity_delta_z = 24

  -- keys are lost when you open a locked door
  lose_keys = true

  bridges = true
  extra_floors = true
  deep_liquids = true

  jump_height = 58

  -- the name buffer in Quake II is huge, but this value
  -- reflects the on-screen space (in the computer panel)
  max_name_length = 24

  skip_monsters = { 30,50 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
  monster_factor = 0.6
}


----------------------------------------------------------------

QUAKE2.MATERIALS =
{
  -- special materials --
  _ERROR = { t="e1u1/metal1_1" }
  _SKY   = { t="e1u1/sky1" }

  AIRDUC1_1  = { t="e1u3/airduc1_1" }
  AIRDUC1_2  = { t="e1u3/airduc1_2" }
  AIRDUC1_3  = { t="e1u3/airduc1_3" }
  ALARM0     = { t="e1u1/alarm0" }
  ALARM1     = { t="e1u1/alarm1" }
  ALARM2     = { t="e1u1/alarm2" }
  ALARM3     = { t="e1u1/alarm3" }
  ANGLE1_1   = { t="e1u2/angle1_1" }
  ANGLE1_2   = { t="e1u2/angle1_2" }
  ARROW0     = { t="e1u1/arrow0" }
  ARROW1     = { t="e1u1/arrow1" }
  ARROW2     = { t="e1u1/arrow2" }
  ARROW3     = { t="e1u1/arrow3" }
  ARROW4     = { t="e1u1/arrow4" }
  ARROWUP3   = { t="e1u1/arrowup3" }
  ARVNT1_4   = { t="e3u3/arvnt1_4" }
  BANNERC    = { t="e3u1/bannerc" }
  BANNERD    = { t="e3u1/bannerd" }
  BANNERE    = { t="e3u1/bannere" }
  BANNERF    = { t="e3u1/bannerf" }
  BASELT_2   = { t="e1u1/baselt_2" }
  BASELT_3   = { t="e1u1/baselt_3" }
  BASELT_4   = { t="e1u1/baselt_4" }
  BASELT_5   = { t="e1u1/baselt_5" }
  BASELT_6   = { t="e2u3/baselt_6" }
  BASELT_7   = { t="e1u1/baselt_7" }
  BASELT_B   = { t="e1u1/baselt_b" }
  BASELT_BLU = { t="e2u3/baselt_blu" }
  BASELT_C   = { t="e1u1/baselt_c" }
  BASELT_D   = { t="e2u3/baselt_d" }
  BASELT_WHT = { t="e2u3/baselt_wht" }
  BASELT_WHTE = { t="e2u3/baselt_whte" }
  BASEMAP    = { t="e1u1/basemap" }
  BASIC1_2   = { t="e1u2/basic1_2" }
  BASIC1_3   = { t="e1u2/basic1_3" }
  BASIC1_5   = { t="e1u2/basic1_5" }
  BASIC1_8   = { t="e1u2/basic1_8" }
  BASLT3_1   = { t="e1u1/baslt3_1" }
  BED01_1    = { t="e3u2/bed01_1" }
  BED02_2    = { t="e3u2/bed02_2" }
  BED3_2     = { t="e3u2/bed3_2" }
  BED3_3     = { t="e3u2/bed3_3" }
  BED3_4     = { t="e3u2/bed3_4" }
  BED4_3     = { t="e3u2/bed4_3" }
  BED4_4     = { t="e3u2/bed4_4" }
  BED4_7     = { t="e3u2/bed4_7" }
  BELT1_2    = { t="e1u1/belt1_2" }
  BELT2_1    = { t="e2u2/belt2_1" }
  BELT2_2    = { t="e2u2/belt2_2" }
  BELT2_3    = { t="e2u2/belt2_3" }
  BELT2_4    = { t="e2u1/belt2_4" }
  BELT2_5    = { t="e2u2/belt2_5" }
  BIGMET1_1  = { t="e2u1/bigmet1_1" }
  BIGMET1_2  = { t="e1u2/bigmet1_2" }
  BIGRED1_1  = { t="e3u1/bigred1_1" }
  BIGRED1_2  = { t="e3u1/bigred1_2" }
  BIGRED8_1  = { t="e3u1/bigred8_1" }
  BLACK      = { t="e1u1/black" }
  BLANK      = { t="e2u1/blank" }
  BLBK1_1    = { t="e2u3/blbk1_1" }
  BLBK1_2    = { t="e2u3/blbk1_2" }
  BLBK2_1    = { t="e2u1/blbk2_1" }
  BLOCK1_5   = { t="e3u2/block1_5" }
  BLOCK1_6   = { t="e3u2/block1_6" }
  BLOCK1_7   = { t="e3u2/block1_7" }
  BLOOD1     = { t="e1u3/blood1" }
  BLOOD2     = { t="e1u3/blood2" }
  BLUEKEYPAD = { t="e1u1/bluekeypad" }
  BLUELITE   = { t="e3u3/bluelite" }
  BLUM11_1   = { t="e2u3/blum11_1" }
  BLUM12_1   = { t="e2u3/blum12_1" }
  BLUM12_2   = { t="e2u3/blum12_2" }
  BLUM13_1   = { t="e2u3/blum13_1" }
  BLUM15_1   = { t="e2u3/blum15_1" }
  BLUME3_1   = { t="e2u3/blume3_1" }
  BLUME4_1   = { t="e2u3/blume4_1" }
  BLUME4_2   = { t="e2u3/blume4_2" }
  BLUME5_1   = { t="e2u3/blume5_1" }
  BLUME5_2   = { t="e2u3/blume5_2" }
  BLUME6_1   = { t="e2u3/blume6_1" }
  BLUME6_2   = { t="e2u3/blume6_2" }
  BLUME7_2   = { t="e2u3/blume7_2" }
  BLUME8_1   = { t="e2u3/blume8_1" }
  BLUME9_1   = { t="e2u3/blume9_1" }
  BLUME9_2   = { t="e2u3/blume9_2" }
  BLUMT2_6   = { t="e2u3/blumt2_6" }
  BLUWTER    = { t="e1u1/bluwter" }
  BMETAL11_1 = { t="e2u1/bmetal11_1" }
  BMETAL11_2 = { t="e2u2/bmetal11_2" }
  BMETAL12_1 = { t="e2u2/bmetal12_1" }
  BMETAL13_1 = { t="e2u2/bmetal13_1" }
  BMETAL13_2 = { t="e2u2/bmetal13_2" }
  BMTB13_1   = { t="e2u3/bmtb13_1" }
  BOSSDR1    = { t="e2u3/bossdr1" }
  BOSSDR2    = { t="e2u3/bossdr2" }
  BOX02_3    = { t="e1u2/box02_3" }
  BOX1_1     = { t="e1u1/box1_1" }
  BOX1_2     = { t="e1u2/box1_2" }
  BOX1_3     = { t="e1u1/box1_3" }
  BOX1_4     = { t="e1u1/box1_4" }
  BOX1_5     = { t="e1u1/box1_5" }
  BOX1_6     = { t="e1u1/box1_6" }
  BOX3_1     = { t="e1u1/box3_1" }
  BOX3_2     = { t="e1u1/box3_2" }
  BOX3_3     = { t="e1u1/box3_3" }
  BOX3_4     = { t="e1u1/box3_4" }
  BOX3_5     = { t="e1u1/box3_5" }
  BOX3_6     = { t="e1u1/box3_6" }
  BOX3_7     = { t="e1u1/box3_7" }
  BOX3_8     = { t="e1u1/box3_8" }
  BOX4_1     = { t="e1u2/box4_1" }
  BOX4_2     = { t="e1u2/box4_2" }
  BOX4_3     = { t="e1u2/box4_3" }
  BOX4_4     = { t="e1u2/box4_4" }
  BRICK1_1   = { t="e3u1/brick1_1" }
  BRICK1_2   = { t="e3u1/brick1_2" }
  BROKEN1_1  = { t="e1u1/broken1_1" }
  BROKEN2_1  = { t="e1u1/broken2_1" }
  BROKEN2_2  = { t="e1u1/broken2_2" }
  BROKEN2_3  = { t="e1u1/broken2_3" }
  BROKEN2_4  = { t="e1u1/broken2_4" }
  BRWIND5_2  = { t="e1u2/brwind5_2" }
  BTACTMACH  = { t="e1u1/btactmach" }
  BTACTMACH0 = { t="e1u1/btactmach0" }
  BTACTMACH1 = { t="e1u1/btactmach1" }
  BTACTMACH2 = { t="e1u1/btactmach2" }
  BTACTMACH3 = { t="e1u1/btactmach3" }
  BTDOOR     = { t="e1u1/btdoor" }
  BTDOOR_OP  = { t="e1u1/btdoor_op" }
  BTELEV     = { t="e1u1/btelev" }
  BTELEV_DN  = { t="e1u1/btelev_dn" }
  BTELEV_DN3 = { t="e1u1/btelev_dn3" }
  BTELEV_UP3 = { t="e1u1/btelev_up3" }
  BTF_OFF    = { t="e2u1/btf_off" }
  BUTN01_1   = { t="e1u3/butn01_1" }

  CABLE1_1   = { t="e1u2/cable1_1" }
  CAUTION1_1 = { t="e1u2/caution1_1" }
  CEIL1_1    = { t="e1u1/ceil1_1" }
  CEIL1_11   = { t="e2u3/ceil1_11" }
  CEIL1_12   = { t="e1u2/ceil1_12" }
  CEIL1_13   = { t="e2u3/ceil1_13" }
  CEIL1_14   = { t="e3u1/ceil1_14" }
  CEIL1_15   = { t="e1u2/ceil1_15" }
  CEIL1_16   = { t="e1u3/ceil1_16" }
  CEIL1_17   = { t="e1u3/ceil1_17" }
  CEIL1_2    = { t="e1u1/ceil1_2" }
  CEIL1_21   = { t="e1u3/ceil1_21" }
  CEIL1_22   = { t="e1u2/ceil1_22" }
  CEIL1_23   = { t="e1u2/ceil1_23" }
  CEIL1_24   = { t="e3u1/ceil1_24" }
  CEIL1_25   = { t="e1u2/ceil1_25" }
  CEIL1_27   = { t="e3u3/ceil1_27" }
  CEIL1_28   = { t="e1u1/ceil1_28" }
  CEIL1_3    = { t="e1u1/ceil1_3" }
  CEIL1_4    = { t="e1u1/ceil1_4" }
  CEIL1_5    = { t="e1u3/ceil1_5" }
  CEIL1_6    = { t="e1u3/ceil1_6" }
  CEIL1_7    = { t="e1u1/ceil1_7" }
  CEIL1_8    = { t="e1u1/ceil1_8" }
  CGRBASE1_1 = { t="e1u1/cgrbase1_1" }
  CINDB2_1   = { t="e1u3/cindb2_1" }
  CINDB2_2   = { t="e1u3/cindb2_2" }
  CINDER1_2  = { t="e1u3/cinder1_2" }
  CINDER1_3  = { t="e1u3/cinder1_3" }
  CINDER1_5  = { t="e1u3/cinder1_5" }
  CINDER1_6  = { t="e1u3/cinder1_6" }
  CINDER1_7  = { t="e1u3/cinder1_7" }
  CINDER1_8  = { t="e1u3/cinder1_8" }
  CINDR2_1   = { t="e1u3/cindr2_1" }
  CINDR2_2   = { t="e1u3/cindr2_2" }
  CINDR3_1   = { t="e1u3/cindr3_1" }
  CINDR3_2   = { t="e1u3/cindr3_2" }
  CINDR4_1   = { t="e1u3/cindr4_1" }
  CINDR4_2   = { t="e1u3/cindr4_2" }
  CINDR5_1   = { t="e1u3/cindr5_1" }
  CINDR5_2   = { t="e1u3/cindr5_2" }
  CINDR6_1   = { t="e1u3/cindr6_1" }
  CINDR7_1   = { t="e1u3/cindr7_1" }
  CINDR8_1   = { t="e1u3/cindr8_1" }
  CINDR8_2   = { t="e2u1/cindr8_2" }
  CIN_FLR1_1 = { t="e1u3/cin_flr1_1" }
  CIN_FLR1_2 = { t="e1u3/cin_flr1_2" }
  CITLIT1_1  = { t="e3u1/citlit1_1" }
  CITLIT1_4  = { t="e3u1/citlit1_4" }
  CITYCOMP1  = { t="e3u1/citycomp1" }
  CITYCOMP2  = { t="e3u1/citycomp2" }
  CITYCOMP3  = { t="e3u1/citycomp3" }
  CLIP_MON   = { t="e1u1/clip_mon" }
  C_MET10_1  = { t="e3u3/c_met10_1" }
  C_MET11_2  = { t="e1u1/c_met11_2" }
  C_MET14_1  = { t="e2u1/c_met14_1" }
  C_MET5_1   = { t="e1u1/c_met5_1" }
  C_MET51A   = { t="e1u1/c_met51a" }
  C_MET51B   = { t="e1u1/c_met51b" }
  C_MET51C   = { t="e1u1/c_met51c" }
  C_MET5_2   = { t="e1u1/c_met5_2" }
  C_MET52A   = { t="e1u1/c_met52a" }
  C_MET7_1   = { t="e1u1/c_met7_1" }
  C_MET7_2   = { t="e1u1/c_met7_2" }
  C_MET8_2   = { t="e1u1/c_met8_2" }
  COLOR1_2   = { t="e1u1/color1_2" }
  COLOR1_2   = { t="e3u3/color1_2" }
  COLOR1_3   = { t="e1u1/color1_3" }
  COLOR1_4   = { t="e1u1/color1_4" }
  COLOR1_4   = { t="e3u3/color1_4" }
  COLOR1_5   = { t="e1u1/color1_5" }
  COLOR1_5   = { t="e3u3/color1_5" }
  COLOR1_6   = { t="e1u1/color1_6" }
  COLOR1_7   = { t="e1u1/color1_7" }
  COLOR1_7   = { t="e3u3/color1_7" }
  COLOR1_8   = { t="e1u1/color1_8" }
  COLOR1_8   = { t="e3u3/color1_8" }
  COLOR2_4   = { t="e1u1/color2_4" }
  COMP1_1    = { t="e1u1/comp1_1" }
  COMP1_2    = { t="e1u1/comp1_2" }
  COMP1_4    = { t="e1u1/comp1_4" }
  COMP1_5    = { t="e1u1/comp1_5" }
  COMP1_7    = { t="e1u1/comp1_7" }
  COMP1_8    = { t="e1u1/comp1_8" }
  COMP2_1    = { t="e1u1/comp2_1" }
  COMP2_1    = { t="e1u2/comp2_1" }
  COMP2_3    = { t="e1u1/comp2_3" }
  COMP2_3    = { t="e1u2/comp2_3" }
  COMP2_4    = { t="e1u2/comp2_4" }
  COMP2_5    = { t="e1u1/comp2_5" }
  COMP2_6    = { t="e2u2/comp2_6" }
  COMP2_D    = { t="e1u3/comp2_d" }
  COMP3_1    = { t="e1u1/comp3_1" }
  COMP3_2    = { t="e1u1/comp3_2" }
  COMP3_3    = { t="e1u1/comp3_3" }
  COMP3_4    = { t="e1u1/comp3_4" }
  COMP3_5    = { t="e1u1/comp3_5" }
  COMP3_6    = { t="e1u1/comp3_6" }
  COMP3_7    = { t="e1u1/comp3_7" }
  COMP3_8    = { t="e1u1/comp3_8" }
  COMP4_1    = { t="e1u1/comp4_1" }
  COMP4_2    = { t="e1u1/comp4_2" }
  COMP4_3    = { t="e1u3/comp4_3" }
  COMP5_1    = { t="e1u1/comp5_1" }
  COMP5_2    = { t="e1u1/comp5_2" }
  COMP5_3    = { t="e1u1/comp5_3" }
  COMP5_4    = { t="e1u1/comp5_4" }
  COMP7_1    = { t="e1u1/comp7_1" }
  COMP7_2    = { t="e2u1/comp7_2" }
  COMP7_3    = { t="e2u1/comp7_3" }
  COMP8_1    = { t="e1u1/comp8_1" }
  COMP9_1    = { t="e1u1/comp9_1" }
  COMP9_2    = { t="e1u1/comp9_2" }
  COMP9_3    = { t="e1u1/comp9_3" }
  COMPU1_2   = { t="e2u1/compu1_2" }
  COMPU1_3   = { t="e2u2/compu1_3" }
  COMPU2_1   = { t="e2u1/compu2_1" }
  CON1_1     = { t="e1u3/con1_1" }
  CON1_1     = { t="e2u3/con1_1" }
  CON1_2     = { t="e1u3/con1_2" }
  CON_FLR1_1 = { t="e1u3/con_flr1_1" }
  CON_FLR1_2 = { t="e1u3/con_flr1_2" }
  COOLANT    = { t="e3u3/coolant" }
  CORE1_1    = { t="e2u3/core1_1" }
  CORE1_3    = { t="e2u3/core1_3" }
  CORE1_4    = { t="e2u3/core1_4" }
  CORE2_3    = { t="e2u3/core2_3" }
  CORE2_4    = { t="e2u3/core2_4" }
  CORE3_1    = { t="e2u3/core3_1" }
  CORE3_3    = { t="e2u3/core3_3" }
  CORE5_1    = { t="e2u3/core5_1" }
  CORE5_3    = { t="e2u3/core5_3" }
  CORE5_4    = { t="e2u3/core5_4" }
  CORE6_1    = { t="e2u3/core6_1" }
  CORE6_3    = { t="e2u3/core6_3" }
  CORE7_3    = { t="e2u3/core7_3" }
  CORE7_4    = { t="e2u3/core7_4" }
  CRATE1_1   = { t="e1u1/crate1_1" }
  CRATE1_3   = { t="e1u1/crate1_3" }
  CRATE1_4   = { t="e1u1/crate1_4" }
  CRATE1_5   = { t="e1u2/crate1_5" }
  CRATE1_6   = { t="e1u1/crate1_6" }
  CRATE1_7   = { t="e1u1/crate1_7" }
  CRATE1_8   = { t="e1u2/crate1_8" }
  CRATE2_2   = { t="e1u2/crate2_2" }
  CRATE2_6   = { t="e1u2/crate2_6" }
  CRUSH1_1   = { t="e2u1/crush1_1" }
  CRUSH1_2   = { t="e2u1/crush1_2" }
  CRYS1_1    = { t="e2u1/crys1_1" }
  CRYS1_2    = { t="e2u1/crys1_2" }
  CRYS1_3    = { t="e2u1/crys1_3" }
  CTYLT1_1   = { t="e3u1/ctylt1_1" }
  CUR_0      = { t="e2u1/cur_0" }

  DAMAGE1_1  = { t="e1u1/damage1_1" }
  DAMAGE1_2  = { t="e1u1/damage1_2" }
  DAMN1_1    = { t="e3u1/damn1_1" }
  DARKMET1_1 = { t="e3u1/darkmet1_1" }
  DARKMET1_2 = { t="e3u1/darkmet1_2" }
  DARKMET2_1 = { t="e3u1/darkmet2_1" }
  DARKMET2_2 = { t="e3u1/darkmet2_2" }
  DFLOOR10_1 = { t="e3u1/dfloor10_1" }
  DFLOOR10_2 = { t="e3u1/dfloor10_2" }
  DFLOOR1_1  = { t="e3u1/dfloor1_1" }
  DFLOOR1_2  = { t="e3u1/dfloor1_2" }
  DFLOOR1_3  = { t="e3u1/dfloor1_3" }
  DFLOOR1_4  = { t="e3u1/dfloor1_4" }
  DFLOOR2_1  = { t="e3u1/dfloor2_1" }
  DFLOOR2_2  = { t="e3u1/dfloor2_2" }
  DFLOOR4_1  = { t="e3u1/dfloor4_1" }
  DFLOOR5_2  = { t="e3u1/dfloor5_2" }
  DFLOOR6_1  = { t="e3u1/dfloor6_1" }
  DFLOOR6_2  = { t="e3u1/dfloor6_2" }
  DFLOOR7_1  = { t="e3u1/dfloor7_1" }
  DFLOOR7_2  = { t="e3u1/dfloor7_2" }
  DFLOOR8_1  = { t="e3u1/dfloor8_1" }
  DFLOOR8_2  = { t="e3u1/dfloor8_2" }
  DOOM       = { t="e3u1/doom" }
  DOOR01     = { t="e2u3/door01" }
  DOOR2_2    = { t="e3u1/door2_2" }
  DOORBOT    = { t="e1u1/doorbot" }
  DOORFC1_1  = { t="e1u3/doorfc1_1" }
  DOORFC1_3  = { t="e1u3/doorfc1_3" }
  DOORFC1_4  = { t="e1u3/doorfc1_4" }
  DOORSWT0   = { t="e1u1/doorswt0" }
  DOORSWT1   = { t="e1u1/doorswt1" }
  DOORSWT2   = { t="e1u1/doorswt2" }
  DOORSWT3   = { t="e1u1/doorswt3" }
  DOPFISH    = { t="e2u3/dopfish" }
  DR01_2     = { t="e3u3/dr01_2" }
  DR02_1     = { t="e1u1/dr02_1" }
  DR02_2     = { t="e1u1/dr02_2" }
  DR03_1     = { t="e2u3/dr03_1" }
  DR03_2     = { t="e2u3/dr03_2" }
  DR04_1     = { t="e1u1/dr04_1" }
  DRAG1_1    = { t="e3u1/drag1_1" }
  DRAG1_2    = { t="e3u1/drag1_2" }
  DRAG1_3    = { t="e3u1/drag1_3" }
  DRAG2_1    = { t="e3u1/drag2_1" }
  DRAG2_2    = { t="e3u1/drag2_2" }
  DRAG2_3    = { t="e3u1/drag2_3" }
  DRAG3_2    = { t="e3u1/drag3_2" }
  DRAG3_3    = { t="e3u1/drag3_3" }
  DRAG3_4    = { t="e3u1/drag3_4" }
  DRAG4_1    = { t="e3u1/drag4_1" }
  DRAG4_3    = { t="e3u1/drag4_3" }
  DRAG4_4    = { t="e3u1/drag4_4" }
  DRSEW1_1   = { t="e2u3/drsew1_1" }
  DRSEW2_1   = { t="e2u3/drsew2_1" }
  DRSEW2_2   = { t="e2u3/drsew2_2" }
  DUMP1_1    = { t="e2u3/dump1_1" }
  DUMP1_2    = { t="e2u3/dump1_2" }
  DUMP3_1    = { t="e2u3/dump3_1" }
  DUMP3_2    = { t="e2u3/dump3_2" }
  ELEVDOOR   = { t="e3u3/elevdoor" }
  ELEV_DR1   = { t="e1u2/elev_dr1" }
  ELEV_DR2   = { t="e1u2/elev_dr2" }
  ENDSIGN1_1 = { t="e1u2/endsign1_1" }
  ENDSIGN1_2 = { t="e1u2/endsign1_2" }
  ENDSIGN1_7 = { t="e1u2/endsign1_7" }
  ENDSIGN1_8 = { t="e1u2/endsign1_8" }
  ENDSIGN1_9 = { t="e1u2/endsign1_9" }
  ENDSIGN2   = { t="e1u1/endsign2" }
  ENDSIGN3   = { t="e1u1/endsign3" }
  ENDSIGN5   = { t="e1u1/endsign5" }
  ENDSIGN6   = { t="e1u1/endsign6" }
  EXIT1      = { t="e1u1/exit1" }
  EXITDR01_1 = { t="e1u1/exitdr01_1" }
  EXITDR01_2 = { t="e1u1/exitdr01_2" }
  EXITSIN1_1 = { t="e1u3/exitsin1_1" }
  EXITSYMBOL2 = { t="e1u1/exitsymbol2" }

  FACE       = { t="e1u1/face" }
  FLAT1_1    = { t="e1u1/flat1_1" }
  FLAT1_2    = { t="e1u1/flat1_2" }
  FLESH1_1   = { t="e2u2/flesh1_1" }
  FLOOR1_1   = { t="e1u3/floor1_1" }
  FLOOR1_2   = { t="e2u3/floor1_2" }
  FLOOR1_3   = { t="e1u1/floor1_3" }
  FLOOR1_3   = { t="e2u2/floor1_3" }
  FLOOR1_3   = { t="e2u3/floor1_3" }
  FLOOR1_4   = { t="e2u3/floor1_4" }
  FLOOR1_5   = { t="e2u3/floor1_5" }
  FLOOR1_6   = { t="e2u3/floor1_6" }
  FLOOR1_7   = { t="e2u2/floor1_7" }
  FLOOR1_7   = { t="e2u3/floor1_7" }
  FLOOR1_8   = { t="e2u3/floor1_8" }
  FLOOR2_2   = { t="e3u1/floor2_2" }
  FLOOR2_4   = { t="e2u2/floor2_4" }
  FLOOR2_7   = { t="e2u2/floor2_7" }
  FLOOR2_7   = { t="e2u3/floor2_7" }
  FLOOR2_8   = { t="e2u3/floor2_8" }
  FLOOR3_1   = { t="e1u1/floor3_1" }
  FLOOR3_2   = { t="e1u1/floor3_2" }
  FLOOR3_3   = { t="e1u1/floor3_3" }
  FLOOR3_3   = { t="e2u3/floor3_3" }
  FLOOR3_5   = { t="e2u3/floor3_5" }
  FLOOR3_6   = { t="e2u3/floor3_6" }
  FLOOR3_7   = { t="e2u1/floor3_7" }
  FLOORSW0   = { t="e1u1/floorsw0" }
  FLOORSW1   = { t="e1u1/floorsw1" }
  FLOORSW2   = { t="e1u1/floorsw2" }
  FLOORSW3   = { t="e1u1/floorsw3" }
  FLORR1_1   = { t="e2u1/florr1_1" }
  FLORR1_4   = { t="e2u1/florr1_4" }
  FLORR1_5   = { t="e1u1/florr1_5" }
  FLORR1_6   = { t="e1u1/florr1_6" }
  FLORR1_8   = { t="e1u1/florr1_8" }
  FLORR2_5   = { t="e2u1/florr2_5" }
  FLORR2_6   = { t="e2u1/florr2_6" }
  FLORR2_8   = { t="e1u1/florr2_8" }
  FLR1_1     = { t="e2u1/flr1_1" }
  FLR1_2     = { t="e2u1/flr1_2" }
  FLR1_3     = { t="e2u1/flr1_3" }
  FMET1_2    = { t="e1u3/fmet1_2" }
  FMET1_2    = { t="e1u4/fmet1_2" }
  FMET1_3    = { t="e1u3/fmet1_3" }
  FMET1_4    = { t="e1u3/fmet1_4" }
  FMET2_2    = { t="e1u3/fmet2_2" }
  FMET2_3    = { t="e1u3/fmet2_3" }
  FMET2_4    = { t="e1u3/fmet2_4" }
  FMET3_1    = { t="e1u3/fmet3_1" }
  FMET3_2    = { t="e1u3/fmet3_2" }
  FMET3_3    = { t="e3u2/fmet3_3" }
  FMET3_4    = { t="e1u3/fmet3_4" }
  FMET3_5    = { t="e1u3/fmet3_5" }
  FMET3_6    = { t="e1u3/fmet3_6" }
  FMET3_7    = { t="e1u3/fmet3_7" }
  FUSE1_1    = { t="e1u2/fuse1_1" }
  FUSE1_2    = { t="e1u2/fuse1_2" }
  FUSE1_3    = { t="e1u2/fuse1_3" }
  FUSE1_4    = { t="e1u2/fuse1_4" }
  FUSEDR1    = { t="e1u2/fusedr1" }
  FUSEDR2    = { t="e1u2/fusedr2" }

  GEOLITC1_1 = { t="e3u1/geolitc1_1" }
  GEOWAL_02  = { t="e3u1/geowal_02" }
  GEOWAL_06  = { t="e3u1/geowal_06" }
  GEOWAL_10  = { t="e3u1/geowal_10" }
  GEOWALDG   = { t="e3u1/geowaldg" }
  GEOWALDI_1 = { t="e3u1/geowaldi_1" }
  GEOWALDI_2 = { t="e3u1/geowaldi_2" }
  GEOWALJ1_4 = { t="e3u1/geowalj1_4" }
  GEOWALM1_1 = { t="e3u1/geowalm1_1" }
  GEOWALM1_2 = { t="e3u1/geowalm1_2" }
  GEOWALN1_2 = { t="e3u1/geowaln1_2" }
  GEOWALO1_1 = { t="e3u1/geowalo1_1" }
  GEOWALP1_1 = { t="e3u1/geowalp1_1" }
  GGRAT12_2  = { t="e1u1/ggrat12_2" }
  GGRAT12_4  = { t="e1u1/ggrat12_4" }
  GGRAT2_1   = { t="e1u1/ggrat2_1" }
  GGRAT2_2   = { t="e1u1/ggrat2_2" }
  GGRAT2_7   = { t="e1u1/ggrat2_7" }
  GGRAT4_1   = { t="e1u1/ggrat4_1" }
  GGRAT4_2   = { t="e1u1/ggrat4_2" }
  GGRAT4_3   = { t="e1u1/ggrat4_3" }
  GGRAT4_4   = { t="e1u1/ggrat4_4" }
  GGRAT5_1   = { t="e1u1/ggrat5_1" }
  GGRAT5_2   = { t="e1u1/ggrat5_2" }
  GGRAT6_1   = { t="e1u1/ggrat6_1" }
  GGRAT6_2   = { t="e1u1/ggrat6_2" }
  GGRATE7_1  = { t="e1u1/ggrate7_1" }
  GGRATE8_1  = { t="e1u1/ggrate8_1" }
  GGRATE9_2  = { t="e1u1/ggrate9_2" }
  GLOCRYS_1  = { t="e3u1/glocrys_1" }
  GLOCRYS_2  = { t="e3u1/glocrys_2" }
  GRASS1_2   = { t="e3u1/grass1_2" }
  GRASS1_3   = { t="e1u1/grass1_3" }
  GRASS1_4   = { t="e1u1/grass1_4" }
  GRASS1_5   = { t="e1u3/grass1_5" }
  GRASS1_6   = { t="e3u3/grass1_6" }
  GRASS1_7   = { t="e1u1/grass1_7" }
  GRASS1_8   = { t="e1u1/grass1_8" }
  GRATE1_1   = { t="e1u1/grate1_1" }
  GRATE1_2   = { t="e1u1/grate1_2" }
  GRATE1_3   = { t="e1u1/grate1_3" }
  GRATE1_4   = { t="e1u1/grate1_4" }
  GRATE1_5   = { t="e1u1/grate1_5" }
  GRATE1_6   = { t="e1u1/grate1_6" }
  GRATE1_8   = { t="e1u3/grate1_8" }
  GRATE2_1   = { t="e1u1/grate2_1" }
  GRATE2_2   = { t="e1u1/grate2_2" }
  GRATE2_3   = { t="e1u1/grate2_3" }
  GRATE2_4   = { t="e1u1/grate2_4" }
  GRATE2_5   = { t="e1u1/grate2_5" }
  GRATE2_6   = { t="e1u1/grate2_6" }
  GRATE2_7   = { t="e1u1/grate2_7" }
  GRATE2_8   = { t="e1u1/grate2_8" }
  GREEN0_1   = { t="e2u3/green0_1" }
  GREEN0_2   = { t="e2u3/green0_2" }
  GREEN2_1   = { t="e2u3/green2_1" }
  GREEN2_2   = { t="e2u3/green2_2" }
  GREEN2_3   = { t="e2u3/green2_3" }
  GREEN3_1   = { t="e2u3/green3_1" }
  GREEN3_2   = { t="e2u3/green3_2" }
  GREEN3_3   = { t="e2u3/green3_3" }
  GREEN3_4   = { t="e2u3/green3_4" }
  GREY1_3    = { t="e1u1/grey1_3" }
  GREY_P1_3  = { t="e1u1/grey_p1_3" }
  GRLT1_1    = { t="e1u1/grlt1_1" }
  GRLT2_1    = { t="e1u1/grlt2_1" }
  GRNDOOR1   = { t="e1u1/grndoor1" }
  GRNMT1_1   = { t="e1u1/grnmt1_1" }
  GRNMT2_2   = { t="e1u1/grnmt2_2" }
  GRNX1_1    = { t="e1u1/grnx1_1" }
  GRNX1_2    = { t="e1u1/grnx1_2" }
  GRNX2_1    = { t="e1u1/grnx2_1" }
  GRNX2_2    = { t="e1u1/grnx2_2" }
  GRNX2_3    = { t="e1u1/grnx2_3" }
  GRNX2_4    = { t="e1u3/grnx2_4" }
  GRNX2_5    = { t="e1u1/grnx2_5" }
  GRNX2_6    = { t="e1u1/grnx2_6" }
  GRNX2_7    = { t="e1u1/grnx2_7" }
  GRNX2_8    = { t="e1u1/grnx2_8" }
  GRNX2_9    = { t="e1u1/grnx2_9" }
  GRNX3_1    = { t="e1u1/grnx3_1" }
  GRNX3_2    = { t="e1u1/grnx3_2" }
  GRNX3_3    = { t="e1u1/grnx3_3" }
  HALL01_1   = { t="e3u2/hall01_1" }
  HALL01_2   = { t="e3u2/hall01_2" }
  HALL01_3   = { t="e3u2/hall01_3" }
  HALL07_2   = { t="e3u2/hall07_2" }
  HALL07_3   = { t="e3u2/hall07_3" }
  HALL08_4   = { t="e3u2/hall08_4" }
  HBUT1_1    = { t="e3u2/hbut1_1" }
  HBUT1_2    = { t="e3u2/hbut1_2" }
  HDOOR1_1   = { t="e2u1/hdoor1_1" }
  HDOOR1_2   = { t="e2u1/hdoor1_2" }
  HEAD1_1    = { t="e2u3/head1_1" }
  HVY_DR1_2  = { t="e1u2/hvy_dr1_2" }
  HVY_DR2_1  = { t="e1u2/hvy_dr2_1" }
  HVY_DR3_1  = { t="e1u2/hvy_dr3_1" }
  HVY_DR3_2  = { t="e1u2/hvy_dr3_2" }
  HVY_DR4_1  = { t="e1u2/hvy_dr4_1" }

  JAILDR03_1 = { t="e3u1/jaildr03_1" }
  JAILDR03_2 = { t="e3u1/jaildr03_2" }
  JAILDR1_1  = { t="e1u3/jaildr1_1" }
  JAILDR1_2  = { t="e1u3/jaildr1_2" }
  JAILDR1_3  = { t="e1u1/jaildr1_3" }
  JAILDR2_1  = { t="e1u3/jaildr2_1" }
  JAILDR2_2  = { t="e1u3/jaildr2_2" }
  JAILDR2_2  = { t="e1u4/jaildr2_2" }
  JAILDR2_3  = { t="e1u1/jaildr2_3" }
  JAILDR2_3  = { t="e3u2/jaildr2_3" }
  JSIGN1_1   = { t="e1u3/jsign1_1" }
  JSIGN2_1   = { t="e1u3/jsign2_1" }
  KCSIGN4    = { t="e1u1/kcsign4" }
  KEYDR1_1   = { t="e1u1/keydr1_1" }
  KEYDRAN2_1 = { t="e1u2/keydran2_1" }
  KEYSIGN1   = { t="e1u3/keysign1" }
  KEYSIGN2   = { t="e1u1/keysign2" }
  LABSIGN1   = { t="e3u3/labsign1" }
  LABSIGN2   = { t="e3u3/labsign2" }
  LASERBUT0  = { t="e1u1/laserbut0" }
  LASERBUT1  = { t="e1u1/laserbut1" }
  LASERBUT2  = { t="e1u1/laserbut2" }
  LASERBUT3  = { t="e1u1/laserbut3" }
  LASERSIDE  = { t="e1u3/laserside" }
  LBUTT5_3   = { t="e1u1/lbutt5_3" }
  LBUTT5_4   = { t="e2u3/lbutt5_4" }
  LEAD1_2    = { t="e2u3/lead1_2" }
  LEAD2_1    = { t="e2u3/lead2_1" }
  LEVER1     = { t="e3u3/lever1" }
  LEVER2     = { t="e1u1/lever2" }
  LEVER3     = { t="e1u1/lever3" }
  LEVER6     = { t="e3u3/lever6" }
  LEVER7     = { t="e1u1/lever7" }
  LEVER8     = { t="e1u1/lever8" }
  LIGHT03_1  = { t="e1u3/light03_1" }
  LIGHT03_2  = { t="e1u2/light03_2" }
  LIGHT03_5  = { t="e1u3/light03_5" }
  LIGHT03_6  = { t="e1u3/light03_6" }
  LIGHT03_8  = { t="e1u2/light03_8" }
  LIGHT2_2   = { t="e1u2/light2_2" }
  LNUM1_1    = { t="e3u2/lnum1_1" }
  LNUM1_2    = { t="e3u2/lnum1_2" }
  LOCATION   = { t="e1u3/location" }
  LSIGN1_1   = { t="e3u2/lsign1_1" }
  LSIGN1_2   = { t="e3u2/lsign1_2" }
  LSIGN1_3   = { t="e3u2/lsign1_3" }
  LSRLT1     = { t="e2u1/lsrlt1" }
  LZR01_1    = { t="e2u1/lzr01_1" }
  LZR01_2    = { t="e2u1/lzr01_2" }
  LZR01_4    = { t="e2u1/lzr01_4" }
  LZR01_5    = { t="e2u1/lzr01_5" }
  LZR02_1    = { t="e2u1/lzr02_1" }
  LZR02_2    = { t="e2u1/lzr02_2" }
  LZR03_1    = { t="e2u1/lzr03_1" }

  MACH1_1    = { t="e1u3/mach1_1" }
  MACH1_2    = { t="e1u3/mach1_2" }
  MACH1_3    = { t="e2u2/mach1_3" }
  MACH1_5    = { t="e2u2/mach1_5" }
  MACHINE1   = { t="e2u3/machine1" }
  MARBLE1_4  = { t="e3u1/marble1_4" }
  MARBLE1_7  = { t="e3u1/marble1_7" }
  MET1_1     = { t="e1u3/met1_1" }
  MET1_2     = { t="e1u3/met1_2" }
  MET1_3     = { t="e1u3/met1_3" }
  MET1_4     = { t="e1u3/met1_4" }
  MET1_5     = { t="e1u3/met1_5" }
  MET2_1     = { t="e1u3/met2_1" }
  MET2_2     = { t="e1u3/met2_2" }
  MET2_3     = { t="e1u3/met2_3" }
  MET2_4     = { t="e1u3/met2_4" }
  MET3_1     = { t="e1u3/met3_1" }
  MET3_2     = { t="e1u3/met3_2" }
  MET3_3     = { t="e1u3/met3_3" }
  MET4_1     = { t="e1u3/met4_1" }
  MET4_2     = { t="e1u3/met4_2" }
  MET4_3     = { t="e1u3/met4_3" }
  MET4_4     = { t="e1u3/met4_4" }
  MET4_5     = { t="e1u3/met4_5" }
  METAL10_1  = { t="e1u2/metal10_1" }
  METAL10_3  = { t="e1u2/metal10_3" }
  METAL1_1   = { t="e1u1/metal1_1" }
  METAL1_1B  = { t="e1u2/metal1_1" }
  METAL1_1C  = { t="e2u3/metal1_1" }
  METAL11_3  = { t="e1u2/metal11_3" }
  METAL11_4  = { t="e1u2/metal11_4" }
  METAL1_2   = { t="e1u1/metal1_2" }
  METAL1_2B  = { t="e1u2/metal1_2" }
  METAL1_2C  = { t="e2u3/metal1_2" }
  METAL12_1  = { t="e1u2/metal12_1" }
  METAL12_2  = { t="e1u2/metal12_2" }
  METAL12_4  = { t="e1u2/metal12_4" }
  METAL1_3   = { t="e1u1/metal1_3" }
  METAL1_3   = { t="e1u2/metal1_3" }
  METAL13_1  = { t="e1u2/metal13_1" }
  METAL13_2  = { t="e1u2/metal13_2" }
  METAL13_3  = { t="e1u2/metal13_3" }
  METAL1_4   = { t="e1u1/metal1_4" }
  METAL1_4   = { t="e1u2/metal1_4" }
  METAL14_1  = { t="e1u1/metal14_1" }
  METAL14_1  = { t="e1u2/metal14_1" }
  METAL14_2  = { t="e1u2/metal14_2" }
  METAL14_3  = { t="e2u3/metal14_3" }
  METAL1_5   = { t="e1u1/metal1_5" }
  METAL1_5   = { t="e1u2/metal1_5" }
  METAL15_2  = { t="e2u3/metal15_2" }
  METAL15_2  = { t="e3u3/metal15_2" }
  METAL1_6   = { t="e1u2/metal1_6" }
  METAL1_6   = { t="e3u3/metal1_6" }
  METAL16_1  = { t="e2u2/metal16_1" }
  METAL16_1  = { t="e2u3/metal16_1" }
  METAL16_2  = { t="e2u3/metal16_2" }
  METAL16_4  = { t="e2u2/metal16_4" }
  METAL1_7   = { t="e1u1/metal1_7" }
  METAL1_7   = { t="e1u2/metal1_7" }
  METAL17_1  = { t="e3u3/metal17_1" }
  METAL17_2  = { t="e2u1/metal17_2" }
  METAL17_2  = { t="e3u3/metal17_2" }
  METAL1_8   = { t="e1u1/metal1_8" }
  METAL18_1  = { t="e2u1/metal18_1" }
  METAL18_1  = { t="e3u3/metal18_1" }
  METAL18_2  = { t="e2u2/metal18_2" }
  METAL18_2  = { t="e2u3/metal18_2" }
  METAL18_2  = { t="e3u3/metal18_2" }
  METAL19_1  = { t="e2u2/metal19_1" }
  METAL19_1  = { t="e3u3/metal19_1" }
  METAL19_2  = { t="e3u3/metal19_2" }
  METAL20_1  = { t="e3u3/metal20_1" }
  METAL20_2  = { t="e3u3/metal20_2" }
  METAL2_1   = { t="e1u1/metal2_1" }
  METAL2_1   = { t="e2u3/metal2_1" }
  METAL21_1  = { t="e3u3/metal21_1" }
  METAL21_2  = { t="e3u3/metal21_2" }
  METAL2_2   = { t="e1u1/metal2_2" }
  METAL2_2   = { t="e2u3/metal2_2" }
  METAL22_1  = { t="e3u3/metal22_1" }
  METAL22_2  = { t="e2u2/metal22_2" }
  METAL22_2  = { t="e3u3/metal22_2" }
  METAL2_3   = { t="e1u1/metal2_3" }
  METAL23_1  = { t="e3u3/metal23_1" }
  METAL23_2  = { t="e3u3/metal23_2" }
  METAL23_3  = { t="e3u3/metal23_3" }
  METAL23_4  = { t="e3u3/metal23_4" }
  METAL2_4   = { t="e1u1/metal2_4" }
  METAL24_1  = { t="e2u1/metal24_1" }
  METAL24_2  = { t="e2u2/metal24_2" }
  METAL24_3  = { t="e2u2/metal24_3" }
  METAL24_4  = { t="e2u2/metal24_4" }
  METAL25_2  = { t="e2u2/metal25_2" }
  METAL25_3  = { t="e2u1/metal25_3" }
  METAL27_1  = { t="e2u2/metal27_1" }
  METAL28_1  = { t="e2u2/metal28_1" }
  METAL29_2  = { t="e2u2/metal29_2" }
  METAL3_1   = { t="e1u1/metal3_1" }
  METAL3_1   = { t="e1u2/metal3_1" }
  METAL3_1   = { t="e2u1/metal3_1" }
  METAL3_1   = { t="e2u3/metal3_1" }
  METAL3_2   = { t="e1u1/metal3_2" }
  METAL3_2   = { t="e1u2/metal3_2" }
  METAL3_2   = { t="e2u1/metal3_2" }
  METAL32_2  = { t="e2u1/metal32_2" }
  METAL3_3   = { t="e1u1/metal3_3" }
  METAL3_3   = { t="e2u1/metal3_3" }
  METAL33_1  = { t="e2u2/metal33_1" }
  METAL33_2  = { t="e2u1/metal33_2" }
  METAL3_4   = { t="e1u1/metal3_4" }
  METAL3_4   = { t="e1u2/metal3_4" }
  METAL34_2  = { t="e2u2/metal34_2" }
  METAL3_5   = { t="e1u1/metal3_5" }
  METAL35_1  = { t="e2u1/metal35_1" }
  METAL3_6   = { t="e1u1/metal3_6" }
  METAL36_1  = { t="e2u1/metal36_1" }
  METAL36_2  = { t="e2u1/metal36_2" }
  METAL36_3  = { t="e2u1/metal36_3" }
  METAL36_4  = { t="e2u1/metal36_4" }
  METAL3_7   = { t="e1u1/metal3_7" }
  METAL37_1  = { t="e2u1/metal37_1" }
  METAL37_2  = { t="e2u1/metal37_2" }
  METAL37_3  = { t="e2u1/metal37_3" }
  METAL37_4  = { t="e2u1/metal37_4" }
  METAL4_1   = { t="e1u3/metal4_1" }
  METAL4_1   = { t="e2u3/metal4_1" }
  METAL4_1   = { t="e3u3/metal4_1" }
  METAL4_2   = { t="e1u2/metal4_2" }
  METAL4_2   = { t="e1u3/metal4_2" }
  METAL4_2   = { t="e2u1/metal4_2" }
  METAL4_2   = { t="e2u3/metal4_2" }
  METAL42_2  = { t="e2u2/metal42_2" }
  METAL43_2  = { t="e2u2/metal43_2" }
  METAL4_4   = { t="e3u3/metal4_4" }
  METAL46_1  = { t="e2u1/metal46_1" }
  METAL46_4  = { t="e2u1/metal46_4" }
  METAL47_1  = { t="e2u2/metal47_1" }
  METAL47_2  = { t="e2u2/metal47_2" }
  METAL5_1   = { t="e1u1/metal5_1" }
  METAL5_1   = { t="e1u2/metal5_1" }
  METAL5_1   = { t="e2u3/metal5_1" }
  METAL5_1   = { t="e3u3/metal5_1" }
  METAL5_2   = { t="e1u1/metal5_2" }
  METAL5_2   = { t="e1u2/metal5_2" }
  METAL5_2   = { t="e2u3/metal5_2" }
  METAL5_2   = { t="e3u3/metal5_2" }
  METAL5_3   = { t="e1u2/metal5_3" }
  METAL5_4   = { t="e1u2/metal5_4" }
  METAL5_5   = { t="e1u2/metal5_5" }
  METAL5_6   = { t="e1u2/metal5_6" }
  METAL5_7   = { t="e1u2/metal5_7" }
  METAL5_8   = { t="e1u2/metal5_8" }
  METAL6_1   = { t="e1u1/metal6_1" }
  METAL6_1   = { t="e1u2/metal6_1" }
  METAL6_1   = { t="e2u1/metal6_1" }
  METAL6_1   = { t="e2u3/metal6_1" }
  METAL6_1   = { t="e3u3/metal6_1" }
  METAL6_2   = { t="e1u1/metal6_2" }
  METAL6_2   = { t="e1u2/metal6_2" }
  METAL6_2   = { t="e3u3/metal6_2" }
  METAL6_3   = { t="e1u2/metal6_3" }
  METAL7_1   = { t="e2u3/metal7_1" }
  METAL8_1   = { t="e1u2/metal8_1" }
  METAL8_1   = { t="e2u3/metal8_1" }
  METAL8_2   = { t="e1u2/metal8_2" }
  METAL8_3   = { t="e1u2/metal8_3" }
  METAL8_4   = { t="e1u2/metal8_4" }
  METAL8_5   = { t="e1u2/metal8_5" }
  METAL9_1   = { t="e1u2/metal9_1" }
  METAL9_1   = { t="e2u3/metal9_1" }
  METAL9_2   = { t="e1u2/metal9_2" }
  METAL9_3   = { t="e1u2/metal9_3" }
  METAL9_4   = { t="e1u2/metal9_4" }
  METAL9_6   = { t="e1u2/metal9_6" }
  METALS_1   = { t="e1u2/metals_1" }
  METALS_3   = { t="e1u2/metals_3" }
  METL10_2   = { t="e2u3/metl10_2" }
  METL5B_1   = { t="e2u3/metl5b_1" }
  METL5B_3   = { t="e3u1/metl5b_3" }
  MINDR1_1   = { t="e2u1/mindr1_1" }
  MINE02_1   = { t="e2u1/mine02_1" }
  MINE02_2   = { t="e2u1/mine02_2" }
  MINE03_1   = { t="e2u1/mine03_1" }
  MINE03_2   = { t="e2u1/mine03_2" }
  MINE04_1   = { t="e2u1/mine04_1" }
  MINE04_2   = { t="e2u1/mine04_2" }
  MINE05_1   = { t="e2u1/mine05_1" }
  MINE05_2   = { t="e2u1/mine05_2" }
  MINE06_1   = { t="e2u1/mine06_1" }
  MINE06_2   = { t="e2u1/mine06_2" }
  MINE06_3   = { t="e2u1/mine06_3" }
  MINE06_4   = { t="e2u1/mine06_4" }
  MINE07_1   = { t="e2u1/mine07_1" }
  MINE07_2   = { t="e2u1/mine07_2" }
  MINE07_3   = { t="e2u1/mine07_3" }
  MINE07_4   = { t="e2u1/mine07_4" }
  MINE08_1   = { t="e2u1/mine08_1" }
  MINE08_3   = { t="e2u1/mine08_3" }
  MINE08_4   = { t="e2u1/mine08_4" }
  MINE10_1   = { t="e2u1/mine10_1" }
  MINE10_2   = { t="e2u1/mine10_2" }
  MINE13_1   = { t="e2u1/mine13_1" }
  MINE13_2   = { t="e2u1/mine13_2" }
  MINE14_1   = { t="e2u1/mine14_1" }
  MINE9_1    = { t="e2u1/mine9_1" }
  MINLT1_1   = { t="e2u1/minlt1_1" }
  MINLT1_2   = { t="e2u1/minlt1_2" }
  MINLT1_3   = { t="e2u1/minlt1_3" }
  MINPN3_1   = { t="e2u1/minpn3_1" }
  MMTL15_5   = { t="e2u1/mmtl15_5" }
  MMTL16_6   = { t="e2u1/mmtl16_6" }
  MMTL19_1   = { t="e2u1/mmtl19_1" }
  MMTL19_2   = { t="e2u1/mmtl19_2" }
  MMTL20_1   = { t="e2u1/mmtl20_1" }
  MON1_3     = { t="e1u3/mon1_3" }
  MON1_6     = { t="e1u3/mon1_6" }
  MONT1_1    = { t="e2u3/mont1_1" }
  MONT1_3    = { t="e2u3/mont1_3" }
  MONT1_4    = { t="e2u3/mont1_4" }
  MONT3_1    = { t="e2u1/mont3_1" }
  MONT3_2    = { t="e2u1/mont3_2" }
  MVR1_2     = { t="e1u2/mvr1_2" }
  MVR1_3     = { t="e1u2/mvr1_3" }

  NOTCH1_1   = { t="e2u2/notch1_1" }
  NOTCH1_2   = { t="e2u2/notch1_2" }
  NOTCH3_2   = { t="e2u2/notch3_2" }
  NOTCH4_2   = { t="e2u2/notch4_2" }
  OR01_1     = { t="e3u2/or01_1" }
  OR01_2     = { t="e3u2/or01_2" }
  OR01_3     = { t="e3u2/or01_3" }
  OR01_4     = { t="e3u2/or01_4" }
  OR02_1     = { t="e3u2/or02_1" }
  OR02_2     = { t="e3u2/or02_2" }
  OR02_3     = { t="e3u2/or02_3" }
  OURPIC1_1  = { t="e2u3/ourpic1_1" }
  OURPIC2_1  = { t="e2u3/ourpic2_1" }
  OURPIC2_2  = { t="e2u3/ourpic2_2" }
  OURPIC3_1  = { t="e2u3/ourpic3_1" }
  OURPIC3_2  = { t="e2u3/ourpic3_2" }
  OURPIC4_1  = { t="e2u3/ourpic4_1" }
  OURPIC4_2  = { t="e2u3/ourpic4_2" }
  OURPIC5_1  = { t="e2u3/ourpic5_1" }
  OURPIC5_2  = { t="e2u3/ourpic5_2" }
  OURPIC6_1  = { t="e2u3/ourpic6_1" }
  OURPIC6_2  = { t="e2u3/ourpic6_2" }
  OURPIC7_1  = { t="e2u3/ourpic7_1" }
  PALMET10_1 = { t="e3u1/palmet10_1" }
  PALMET10_2 = { t="e3u1/palmet10_2" }
  PALMET1_1  = { t="e3u1/palmet1_1" }
  PALMET12_1 = { t="e3u1/palmet12_1" }
  PALMET12_2 = { t="e3u1/palmet12_2" }
  PALMET12_3 = { t="e3u1/palmet12_3" }
  PALMET13_4 = { t="e3u1/palmet13_4" }
  PALMET14_1 = { t="e3u1/palmet14_1" }
  PALMET14_2 = { t="e3u1/palmet14_2" }
  PALMET14_3 = { t="e3u1/palmet14_3" }
  PALMET14_4 = { t="e3u1/palmet14_4" }
  PALMET3_1  = { t="e3u1/palmet3_1" }
  PALMET3_2  = { t="e3u1/palmet3_2" }
  PALMET5_2  = { t="e3u1/palmet5_2" }
  PALMET7_1  = { t="e3u1/palmet7_1" }
  PALMET9_2  = { t="e3u1/palmet9_2" }
  PALSUP1_5  = { t="e3u1/palsup1_5" }
  PATWALL0_2 = { t="e3u1/patwall0_2" }
  PDOR1_1    = { t="e1u3/pdor1_1" }
  PDOR1_2    = { t="e1u3/pdor1_2" }
  P_FLR_05   = { t="e3u1/p_flr_05" }
  P_FLR_10   = { t="e3u1/p_flr_10" }
  PILLAR1_1  = { t="e1u2/pillar1_1" }
  PILLAR1_2  = { t="e1u2/pillar1_2" }
  PILR01_1   = { t="e2u1/pilr01_1" }
  PILR01_2   = { t="e2u1/pilr01_2" }
  PILR01_3   = { t="e2u1/pilr01_3" }
  PILR02_1   = { t="e2u2/pilr02_1" }
  PILR02_2   = { t="e2u1/pilr02_2" }
  PILR03_1   = { t="e2u1/pilr03_1" }
  PILR03_3   = { t="e2u1/pilr03_3" }
  PIP01_1    = { t="e1u1/pip01_1" }
  PIP01_2    = { t="e1u1/pip01_2" }
  PIP01_4    = { t="e1u1/pip01_4" }
  PIP02_1    = { t="e1u1/pip02_1" }
  PIP02_3    = { t="e1u3/pip02_3" }
  PIP02_4    = { t="e1u3/pip02_4" }
  PIP02_5    = { t="e1u1/pip02_5" }
  PIP02_6    = { t="e1u1/pip02_6" }
  PIP03_1    = { t="e3u3/pip03_1" }
  PIP03_4    = { t="e1u1/pip03_4" }
  PIP04_3    = { t="e1u1/PIP04_3" }
  PIP04_4    = { t="e1u1/PIP04_4" }
  PIP04_5    = { t="e1u1/PIP04_5" }
  PIP04_6    = { t="e1u1/PIP04_6" }
  PIP05_1    = { t="e1u1/pip05_1" }
  PIPE1_1    = { t="e1u1/pipe1_1" }
  PIPE1_2    = { t="e1u1/pipe1_2" }
  PIPE1_3    = { t="e1u1/pipe1_3" }
  PIPE1_4    = { t="e1u1/pipe1_4" }
  PIPE1_4    = { t="e2u2/pipe1_4" }
  PIPE1_5    = { t="e1u1/pipe1_5" }
  PIPE1_6    = { t="e3u2/pipe1_6" }
  PIPE3_2    = { t="e2u3/pipe3_2" }
  PIPES1_2   = { t="e2u3/pipes1_2" }
  PLATE1_2   = { t="e1u2/plate1_2" }
  PLATE1_3   = { t="e1u2/plate1_3" }
  PLATE1_4   = { t="e1u2/plate1_4" }
  PLATE1_6   = { t="e1u2/plate1_6" }
  PLATE2_1   = { t="e2u2/plate2_1" }
  PLATE2_5   = { t="e2u2/plate2_5" }
  PLATE5_2   = { t="e2u1/plate5_2" }
  P_LIT_02   = { t="e1u1/p_lit_02" }
  P_LIT_03   = { t="e1u1/p_lit_03" }
  PLITE1_1   = { t="e1u1/plite1_1" }
  PLITE1_2   = { t="e1u3/plite1_2" }
  PLITE1_3   = { t="e1u1/plite1_3" }
  POW10_1    = { t="e2u3/pow10_1" }
  POW1_1     = { t="e2u3/pow1_1" }
  POW11_2    = { t="e3u1/pow11_2" }
  POW1_2     = { t="e2u3/pow1_2" }
  POW12_1    = { t="e3u1/pow12_1" }
  POW15_1    = { t="e2u3/pow15_1" }
  POW15_2    = { t="e2u3/pow15_2" }
  POW17_1    = { t="e2u3/pow17_1" }
  POW17_2    = { t="e2u3/pow17_2" }
  POW18_1    = { t="e2u3/pow18_1" }
  POW18_2    = { t="e2u3/pow18_2" }
  POW2_1     = { t="e2u3/pow2_1" }
  POW3_1     = { t="e2u3/pow3_1" }
  POW3_2     = { t="e1u3/pow3_2" }
  POW4_2     = { t="e2u3/pow4_2" }
  POW5_1     = { t="e2u3/pow5_1" }
  POW5_2     = { t="e2u3/pow5_2" }
  POW6_2     = { t="e2u3/pow6_2" }
  POW8_2     = { t="e2u3/pow8_2" }
  POWR21_1   = { t="e2u3/powr21_1" }
  POWR21_2   = { t="e2u3/powr21_2" }
  PRWLT1_2   = { t="e2u3/prwlt1_2" }
  PRWLT1_4   = { t="e2u3/prwlt1_4" }
  PRWLT2_2   = { t="e2u3/prwlt2_2" }
  PRWLT2_3   = { t="e2u3/prwlt2_3" }
  P_SWR1_7   = { t="e1u1/p_swr1_7" }
  PTHNM2_1   = { t="e3u1/pthnm2_1" }
  P_TUB1_1   = { t="e1u1/p_tub1_1" }
  P_TUB2_1   = { t="e3u3/p_tub2_1" }
  P_TUB2_3   = { t="e1u1/p_tub2_3" }
  PWPIP1_1   = { t="e2u3/pwpip1_1" }
  PWPIP1_2   = { t="e2u3/pwpip1_2" }
  PWR_DR1_1  = { t="e2u3/pwr_dr1_1" }
  PWR_DR1_2  = { t="e2u3/pwr_dr1_2" }
  PYRAMID0   = { t="e2u3/pyramid0" }
  PYRAMID1   = { t="e2u3/pyramid1" }
  PYRAMID2   = { t="e2u3/pyramid2" }
  PYRAMID3   = { t="e2u3/pyramid3" }

  RCOMP1_4   = { t="e2u1/rcomp1_4" }
  RED1_1     = { t="e1u1/red1_1" }
  RED1_2     = { t="e1u1/red1_2" }
  RED1_3     = { t="e1u1/red1_3" }
  RED1_3     = { t="e3u1/red1_3" }
  RED1_4     = { t="e1u2/red1_4" }
  RED1_6     = { t="e2u2/red1_6" }
  REDCAR_2   = { t="e3u1/redcar_2" }
  REDDR2_1   = { t="e3u1/reddr2_1" }
  REDDR8_1   = { t="e3u1/reddr8_1" }
  REDDR8_2   = { t="e3u1/reddr8_2" }
  REDFIELD   = { t="e1u1/redfield" }
  REDKEYPAD  = { t="e1u1/redkeypad" }
  REDLT1_1   = { t="e2u1/redlt1_1" }
  REDLT1_3   = { t="e2u1/redlt1_3" }
  REDMT1_2   = { t="e2u2/redmt1_2" }
  REDS1_2    = { t="e1u3/reds1_2" }
  REFDR1_1   = { t="e2u2/refdr1_1" }
  REFDR3_1   = { t="e1u3/refdr3_1" }
  REFDR4_4   = { t="e2u2/refdr4_4" }
  REFDR9_2   = { t="e2u2/refdr9_2" }
  REFDR9_3   = { t="e2u2/refdr9_3" }
  REFLT1_1   = { t="e2u2/reflt1_1" }
  REFLT1_9   = { t="e2u1/reflt1_9" }
  REFLT3_10  = { t="e2u1/reflt3_10" }
  REFLT3_11  = { t="e2u1/reflt3_11" }
  REFLT3_2   = { t="e2u1/reflt3_2" }
  REFLT3_5   = { t="e2u1/reflt3_5" }
  REFLT3_8   = { t="e2u3/reflt3_8" }
  REFLT3_9   = { t="e1u3/reflt3_9" }
  RFLR2_1    = { t="e2u2/rflr2_1" }
  RLIGHT1_1  = { t="e2u3/rlight1_1" }
  RLIGHT1_2  = { t="e2u3/rlight1_2" }
  RMETAL10_1 = { t="e2u3/rmetal10_1" }
  RMETAL3_4  = { t="e2u3/rmetal3_4" }
  RMETAL4_1  = { t="e2u3/rmetal4_1" }
  RMETAL5_1  = { t="e2u3/rmetal5_1" }
  ROCK0_1    = { t="e2u1/rock0_1" }
  ROCK1_1    = { t="e2u1/rock1_1" }
  ROCK2_1    = { t="e2u3/rock2_1" }
  ROCK25_1   = { t="e2u2/rock25_1" }
  ROCK6_4    = { t="e2u1/rock6_4" }
  ROCKS14_2  = { t="e1u3/rocks14_2" }
  ROCKS15_2  = { t="e2u1/rocks15_2" }
  ROCKS16_1  = { t="e1u3/rocks16_1" }
  ROCKS16_2  = { t="e1u1/rocks16_2" }
  ROCKS17_2  = { t="e2u3/rocks17_2" }
  ROCKS19_1  = { t="e1u1/rocks19_1" }
  ROCKS21_1  = { t="e2u1/rocks21_1" }
  ROCKS22_1  = { t="e1u1/rocks22_1" }
  ROCKS23_2  = { t="e2u1/rocks23_2" }
  ROCKS24_1  = { t="e2u2/rocks24_1" }
  ROCKS24_2  = { t="e2u1/rocks24_2" }
  RPIP2_1    = { t="e2u1/rpip2_1" }
  RPIP2_2    = { t="e1u1/rpip2_2" }
  RROCK1_2   = { t="e2u1/rrock1_2" }
  SFLR1_1    = { t="e1u3/sflr1_1" }
  SFLR1_2    = { t="e1u3/sflr1_2" }
  SFLR1_3    = { t="e1u3/sflr1_3" }
  SHINY1_6   = { t="e1u3/shiny1_6" }
  SHOOTER1   = { t="e1u1/shooter1" }
  SHOOTER2   = { t="e1u1/shooter2" }
  SHUTL1_1   = { t="e3u3/shutl1_1" }
  SHUTL21_1  = { t="e3u3/shutl21_1" }
  SHUTL2_2   = { t="e3u3/shutl2_2" }
  SHUTL22_2  = { t="e3u3/shutl22_2" }
  SHUTL22_3  = { t="e3u3/shutl22_3" }
  SIGN1      = { t="e3u3/sign1" }
  SIGN1_1    = { t="e1u1/sign1_1" }
  SIGN1_1    = { t="e2u2/sign1_1" }
  SIGN1_2    = { t="e1u1/sign1_2" }
  SIGN1_4    = { t="e2u2/sign1_4" }
  SIGN2      = { t="e3u3/sign2" }
  SIGN3_1    = { t="e1u3/sign3_1" }
  SIGN3_2    = { t="e1u3/sign3_2" }
  SLOTS1_1   = { t="e1u3/slots1_1" }
  SLOTS1_2   = { t="e1u3/slots1_2" }
  SLOTS1_4   = { t="e1u3/slots1_4" }
  SLOTS1_5   = { t="e1u3/slots1_5" }
  SLOTS1_6   = { t="e1u3/slots1_6" }
  SLOTWL2_1  = { t="e1u3/slotwl2_1" }
  SLOTWL4_1  = { t="e1u3/slotwl4_1" }
  SLOTWL4_2  = { t="e1u3/slotwl4_2" }
  SLOTWL4_3  = { t="e1u3/slotwl4_3" }
  SLOTWL4_4  = { t="e1u3/slotwl4_4" }
  SLOTWL5_3  = { t="e1u3/slotwl5_3" }
  SLOTWL5_5  = { t="e1u3/slotwl5_5" }
  SLOTWL6_2  = { t="e1u3/slotwl6_2" }
  SLTFL2_1   = { t="e1u3/sltfl2_1" }
  SLTFL2_2   = { t="e1u3/sltfl2_2" }
  SLTFL2_6   = { t="e1u3/sltfl2_6" }
  SLTFR2_4   = { t="e1u3/sltfr2_4" }
  SMPOW1     = { t="e2u3/smpow1" }
  SMPOW2     = { t="e2u3/smpow2" }
  SMPOW3     = { t="e2u3/smpow3" }
  STAIRS1_1  = { t="e1u1/stairs1_1" }
  STAIRS1_2  = { t="e1u3/stairs1_2" }
  STAIRS1_3  = { t="e1u3/stairs1_3" }
  STATION1   = { t="e1u1/station1" }
  STATION5   = { t="e1u1/station5" }
  STFLR1_4   = { t="e1u3/stflr1_4" }
  STFLR1_5   = { t="e1u3/stflr1_5" }
  STRIPE1_1  = { t="e1u2/stripe1_1" }
  STRIPE1_2  = { t="e1u2/stripe1_2" }
  SUBDR1_1   = { t="e1u2/subdr1_1" }
  SUBDR2_1   = { t="e1u2/subdr2_1" }
  SUBDR2_2   = { t="e1u2/subdr2_2" }
  SUBDR3_1   = { t="e1u2/subdr3_1" }
  SUBDR3_2   = { t="e1u2/subdr3_2" }
  SUPPORT1_1 = { t="e1u1/support1_1" }
  SUPPORT1_1 = { t="e3u3/support1_1" }
  SUPPORT1_2 = { t="e3u1/support1_2" }
  SUPPORT1_3 = { t="e1u1/support1_3" }
  SUPPORT1_8 = { t="e1u2/support1_8" }
  SYM6_2     = { t="e1u2/sym6_2" }

  TCMET4_1   = { t="e1u3/tcmet4_1" }
  TCMET4_2   = { t="e1u3/tcmet4_2" }
  TCMET4_3   = { t="e1u3/tcmet4_3" }
  TCMET4_4   = { t="e1u3/tcmet4_4" }
  TCMET5_2   = { t="e1u3/tcmet5_2" }
  TCMET5_4   = { t="e1u3/tcmet5_4" }
  TCMT9_1    = { t="e1u3/tcmt9_1" }
  TCMT9_2    = { t="e1u3/tcmt9_2" }
  TCMT9_4    = { t="e1u3/tcmt9_4" }
  TCMT9_7    = { t="e1u3/tcmt9_7" }
  TEMP1_1    = { t="e2u1/temp1_1" }
  TEMP1_2    = { t="e2u3/temp1_2" }
  THINM1_1   = { t="e2u1/thinm1_1" }
  THINM1_2   = { t="e2u3/thinm1_2" }
  THINM1_3   = { t="e2u3/thinm1_3" }
  THINM2_3   = { t="e2u3/thinm2_3" }
  TIMPOD     = { t="e1u1/timpod" }
  TIMPOD2    = { t="e1u1/timpod2" }
  TIMPOD3    = { t="e1u1/timpod3" }
  TIMPOD3_1  = { t="e2u3/timpod3_1" }
  TIMPOD3_2  = { t="e2u3/timpod3_2" }
  TIMPOD4    = { t="e1u1/timpod4" }
  TIMPOD5    = { t="e1u1/timpod5" }
  TIMPOD5_1  = { t="e2u2/timpod5_1" }
  TIMPOD6    = { t="e1u1/timpod6" }
  TIMPOD7    = { t="e1u1/timpod7" }
  TIMPOD8    = { t="e1u1/timpod8" }
  TIMPOD9    = { t="e1u1/timpod9" }
  TLIGHT03   = { t="e2u1/tlight03" }
  TRAIN1_1   = { t="e1u2/train1_1" }
  TRAIN1_2   = { t="e1u2/train1_2" }
  TRAIN1_3   = { t="e1u2/train1_3" }
  TRAIN1_4   = { t="e1u2/train1_4" }
  TRAIN1_5   = { t="e1u2/train1_5" }
  TRAIN1_6   = { t="e1u2/train1_6" }
  TRAIN1_7   = { t="e1u2/train1_7" }
  TRAIN1_8   = { t="e1u2/train1_8" }
  TRAM01_1   = { t="e1u1/tram01_1" }
  TRAM01_2   = { t="e1u1/tram01_2" }
  TRAM01_3   = { t="e1u1/tram01_3" }
  TRAM01_4   = { t="e1u1/tram01_4" }
  TRAM01_5   = { t="e1u1/tram01_5" }
  TRAM01_6   = { t="e1u1/tram01_6" }
  TRAM01_8   = { t="e1u1/tram01_8" }
  TRAM02_1   = { t="e1u1/tram02_1" }
  TRAM02_2   = { t="e1u1/tram02_2" }
  TRAM02_3   = { t="e1u1/tram02_3" }
  TRAM03_1   = { t="e1u1/tram03_1" }
  TRAM03_2   = { t="e1u1/tram03_2" }
  TROOF1_1   = { t="e1u3/troof1_1" }
  TROOF1_1   = { t="e3u2/troof1_1" }
  TROOF1_2   = { t="e1u3/troof1_2" }
  TROOF1_3   = { t="e1u3/troof1_3" }
  TROOF1_4   = { t="e1u3/troof1_4" }
  TROOF1_6   = { t="e1u3/troof1_6" }
  TROOF3_1   = { t="e1u3/troof3_1" }
  TROOF3_2   = { t="e1u3/troof3_2" }
  TROOF3_2   = { t="e3u2/troof3_2" }
  TROOF4_1   = { t="e1u3/troof4_1" }
  TROOF4_4   = { t="e1u2/troof4_4" }
  TROOF4_7   = { t="e1u2/troof4_7" }
  TROOF5_1   = { t="e3u2/troof5_1" }
  TROOF5_3   = { t="e1u3/troof5_3" }
  TROOF5_4   = { t="e1u3/troof5_4" }
  TUNL1_5    = { t="e2u1/tunl1_5" }
  TUNL1_7    = { t="e2u1/tunl1_7" }
  TUNL1_8    = { t="e2u1/tunl1_8" }
  TUNL2_1    = { t="e2u1/tunl2_1" }
  TUNL2_3    = { t="e2u1/tunl2_3" }
  TUNL3_1    = { t="e2u1/tunl3_1" }
  TUNL3_2    = { t="e2u1/tunl3_2" }
  TUNL3_3    = { t="e2u1/tunl3_3" }
  TUNL3_4    = { t="e2u1/tunl3_4" }
  TUNL3_5    = { t="e2u1/tunl3_5" }
  TUNL3_6    = { t="e2u1/tunl3_6" }
  TURRET2_1  = { t="e1u3/turret2_1" }
  TURRET3_1  = { t="e1u3/turret3_1" }
  TURRET5_1  = { t="e1u3/turret5_1" }
  TURRET6_1  = { t="e1u3/turret6_1" }
  TURRET7_1  = { t="e1u3/turret7_1" }
  TURRET8_1  = { t="e1u3/turret8_1" }
  TURRET9_1  = { t="e1u3/turret9_1" }
  TWALL5_1   = { t="e2u1/twall5_1" }
  TWR01_1    = { t="e2u1/twr01_1" }
  TWR03_1    = { t="e2u1/twr03_1" }

  WASTEMAP   = { t="e2u3/wastemap" }
  WATRT1_1   = { t="e1u1/watrt1_1" }
  WATRT1_2   = { t="e1u1/watrt1_2" }
  WATRT2_1   = { t="e1u1/watrt2_1" }
  WATRT2_2   = { t="e1u1/watrt2_2" }
  WATRT3_1   = { t="e3u3/watrt3_1" }
  WATRT3_2   = { t="e1u1/watrt3_2" }
  WATRT4_1   = { t="e2u1/watrt4_1" }
  WBASIC1_1  = { t="e1u1/wbasic1_1" }
  WBASIC1_4  = { t="e1u1/wbasic1_4" }
  WBASIC1_7  = { t="e1u1/wbasic1_7" }
  WGRATE1_1  = { t="e1u1/wgrate1_1" }
  WGRATE1_2  = { t="e1u1/wgrate1_2" }
  WGRATE1_3  = { t="e1u1/wgrate1_3" }
  WGRATE1_4  = { t="e1u1/wgrate1_4" }
  WGRATE1_5  = { t="e1u1/wgrate1_5" }
  WGRATE1_6  = { t="e1u1/wgrate1_6" }
  WGRATE1_7  = { t="e1u1/wgrate1_7" }
  WGRATE1_8  = { t="e1u1/wgrate1_8" }
  WINCOMP3_5 = { t="e1u1/wincomp3_5" }
  WINCOMP3_7 = { t="e1u1/wincomp3_7" }
  WINDOW4_1  = { t="e3u1/window4_1" }
  WINDOW4_2  = { t="e1u2/window4_2" }
  WINDOW5_1  = { t="e2u3/window5_1" }
  WINDOW6_1  = { t="e3u2/window6_1" }
  WIRE1_3    = { t="e1u3/wire1_3" }
  WIRES2_1   = { t="e1u3/wires2_1" }
  WIRES2_2   = { t="e1u3/wires2_2" }
  WMETL2_4   = { t="e2u1/wmetl2_4" }
  WMTAL3_4   = { t="e1u3/wmtal3_4" }
  WMTAL3_5   = { t="e1u1/wmtal3_5" }
  WMTAL4_4   = { t="e1u3/wmtal4_4" }
  WNDOW0_1   = { t="e1u1/wndow0_1" }
  WNDOW0_3   = { t="e1u1/wndow0_3" }
  WNDOW1_1   = { t="e2u2/wndow1_1" }
  WNDOW1_2   = { t="e1u2/wndow1_2" }
  WNDOW1_8   = { t="e2u2/wndow1_8" }
  WNDW01_2   = { t="e3u1/wndw01_2" }
  WNDW01_3   = { t="e3u1/wndw01_3" }
  WNDW01_4   = { t="e3u1/wndw01_4" }
  WNDW01_5   = { t="e3u1/wndw01_5" }
  WPLAT1_1   = { t="e1u3/wplat1_1" }
  WPLAT1_2   = { t="e1u1/wplat1_2" }
  WPLAT1_3   = { t="e2u1/wplat1_3" }
  WSLT1_1    = { t="e1u1/wslt1_1" }
  WSLT1_2    = { t="e1u1/wslt1_2" }
  WSLT1_3    = { t="e1u1/wslt1_3" }
  WSLT1_4    = { t="e1u1/wslt1_4" }
  WSLT1_5    = { t="e1u1/wslt1_5" }
  WSLT1_6    = { t="e1u1/wslt1_6" }
  WSTFL2_5   = { t="e1u3/wstfl2_5" }
  WSTFL2_6   = { t="e1u3/wstfl2_6" }
  WSTLT1_1   = { t="e2u3/wstlt1_1" }
  WSTLT1_2   = { t="e2u3/wstlt1_2" }
  WSTLT1_3   = { t="e2u3/wstlt1_3" }
  WSTLT1_5   = { t="e2u3/wstlt1_5" }
  WSTLT1_8   = { t="e2u3/wstlt1_8" }
  WSUPPRT1_14 = { t="e1u1/wsupprt1_14" }
  WSUPPRT1_3 = { t="e1u1/wsupprt1_3" }
  WSUPPRT1_5 = { t="e1u1/wsupprt1_5" }
  WSUPPRT1_6 = { t="e1u1/wsupprt1_6" }
  WSWALL1_1  = { t="e1u1/wswall1_1" }
  WSWALL1_2  = { t="e1u1/wswall1_2" }
  WTROOF1_5  = { t="e1u1/wtroof1_5" }
  WTROOF4_2  = { t="e1u1/wtroof4_2" }
  WTROOF4_3  = { t="e1u1/wtroof4_3" }
  WTROOF4_5  = { t="e1u1/wtroof4_5" }
  WTROOF4_6  = { t="e1u1/wtroof4_6" }
  WTROOF4_8  = { t="e1u1/wtroof4_8" }
  W_WHITE    = { t="e2u1/w_white" }
  YELLOW1_2  = { t="e1u1/yellow1_2" }
  YELLOW1_4  = { t="e1u1/yellow1_4" }
  YELLOW1_6  = { t="e1u1/yellow1_6" }

  
  -- special stuff

  TRIGGER    = { t="e1u1/trigger" }

  L_LAVA1    = { t="e1u1/brlava" }
  L_LAVA2    = { t="e2u3/tlava1_3" }
  L_MUD1     = { t="e2u1/mud1_1" }
  L_MUD2     = { t="e1u1/brwater" }
  L_SLIME    = { t="e1u1/sewer1" }
  L_WATER1   = { t="e1u1/water1_8" }
  L_WATER4   = { t="e1u1/water4" }
  L_WATER6   = { t="e3u3/awater" }
  L_WATER7   = { t="e3u3/water7" }
  L_WATER8   = { t="e1u1/water8" }

  -- Oblige specific textures
  O_CARVE    = { t="o_carve" }
  O_BOLT     = { t="o_carve" }

-- e1u1/+0btshoot1
-- e1u1/+0btshoot2
-- e1u3/+0butn1
-- e1u2/+0butn4
-- e2u2/+0butn8
-- e1u1/+0cgrate1_1
-- e3u1/+0cgrate1_1
-- e1u1/+0cgrate2_1
-- e1u1/+0cgrate3_1
-- e1u1/+0comp10_1
-- e1u1/+0comp11_1
-- e3u2/+0lcomp
-- e3u2/+0lcompa
-- e3u2/+10lcomp
-- e3u2/+11lcomp
-- e3u2/+12lcomp
-- e3u2/+13lcomp
-- e3u2/+14lcomp
-- e3u2/+15lcomp
-- e3u2/+16lcomp
-- e3u2/+17lcomp
-- e3u2/+18lcomp
-- e3u2/+19lcomp
-- e1u1/+1cgrate1_1
-- e1u1/+1comp10_1
-- e1u1/+1comp11_1
-- e3u2/+1lcomp
-- e3u2/+1lcompa
-- e1u1/+2comp10_1
-- e1u1/+2comp11_1
-- e3u2/+2lcomp
-- e1u1/+3comp10_1
-- e1u1/+3comp11_1
-- e1u1/+4comp10_1
-- e1u1/+4comp11_1
-- e1u1/+5comp11_1
-- e3u2/+5lcomp
-- e1u1/+6comp11_1
-- e3u2/+6lcomp
-- e1u1/+7comp11_1
-- e3u2/+7lcomp
-- e1u1/+8comp11_1
-- e3u2/+8lcomp
-- e1u1/+9comp11_1
-- e3u2/+9lcomp
-- e1u1/+abtshoot2
-- e1u1/+abtshoot3

---- e1u1/sky1
---- e3u3/xsky1

---- e1u1/clip
---- e1u1/hint
---- e1u1/origin
---- e1u1/skip
}

QUAKE2.RAILS =
{
}


QUAKE2.LIQUIDS =
{
  water  = { mat="L_WATER4", medium="water", light=0, special=0 }
  mud    = { mat="L_MUD2",   medium="water", light=0, special=0 }
  slime  = { mat="L_SLIME",  medium="slime", light=0, special=0, damage=99 }
  lava   = { mat="L_LAVA1",  medium="lava",  light=1, special=0, damage=99 }
}


----------------------------------------------------------------

QUAKE2.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"
    _where  = "middle"

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_basic =
  {
    _prefab = "QUAKE2_EXIT_PAD"
    _where  = "middle"

    pad  = "DOORSWT2"
    side = "RED1_2"
  }


  ----| PICTURES |----

  Pic_Carve =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "WINCOMP3_7"
    pic_w = 64
    pic_h = 64

    light = 64
  }


  ----| KEY |----

  Item_niche =
  {
    _prefab = "ITEM_NICHE"
    _where  = "edge"
    _long   = 192
    _deep   = 64

    light = 128
    style = 11
  }

  Pedestal_1 =
  {
    _prefab = "PEDESTAL"
    _where  = "middle"

    top  = "WSTLT1_1"   -- LIGHT03_5
    side = "METAL1_1"

    light = 160
    style = 11
  }


  ----| STAIRS |----

  Stair_Up1 =
  {
    _prefab = "STAIR_6"
    _where  = "floor"
    _deltas = { 32,48,64,64,80 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "floor"
    _deltas = { -32,-48,-64,-80,-96 }
  }

  Lift_Up1 =
  {
    _prefab = "QUAKE_LIFT_UP"
    _where  = "floor"
    _deltas = { 96,128,128,160,192 }

    lift = "GRNX2_7"
  }

  Lift_Down1 =
  {
    _prefab = "QUAKE_LIFT_DOWN"
    _where  = "floor"
    _deltas = { -96,-128,-128,-160,-192 }

    lift = "GRNX2_7"
  }


  ----| ARCHES |----

--[[
  Arch1 =
  {
    _prefab = "ARCH"
    _where  = "edge"
    _long   = 192
    _deep   = 64
  }


  ----| DOORS |----

  Door_plain =
  {
    _prefab = "QUAKE_DOOR"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    door = "ADOOR02_2"
  }


--]]

  --- LOCKED DOORS ---

  Locked_red =
  {
    _prefab = "QUAKE2_KEY_DOOR"
    _where  = "edge"
    _key    = "k_red"
    _long = 192
    _deep = 32

    door = "ELEVDOOR"
    item = "key_red_key"
  }

  Locked_blue =
  {
    _prefab = "QUAKE2_KEY_DOOR"
    _where  = "edge"
    _key    = "k_blue"
    _long = 192
    _deep = 32

    door = "ELEVDOOR"
    item = "key_blue_key"
  }


  ----| SWITCHED DOORS |---- 

  Door_SW_1 =
  {
    _prefab = "QUAKE_DOOR"
    _where  = "edge"
    _switch = "sw_foo"
    _long = 192
    _deep = 32

    door = "GRNDOOR1"
    message = "Find the button dude!"
    wait = -1
  }

  Switch_floor1 =
  {
    _prefab = "QUAKE_FLOOR_SWITCH"
    _where  = "middle"
    _switch = "sw_foo"

    switch = "FLOORSW0"
    side   = "METAL1_1"
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _prefab = "QUAKE2_TELEPORTER"
    _where  = "middle"
  }



--[[
  ---| WINDOWS |---

  Window1 =
  {
    _prefab = "WINDOW"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    track = "RUNE2_2"
  }


  ---| FENCES |---

  Fence1 =
  {
    _prefab = "FENCE_STICKS_QUAKE"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    fence = "WIZWOOD1_8"
    metal = "METAL1_1"
  }


  ---| DECORATION |---

  TechLamp =
  {
    _prefab = "QUAKE_TECHLAMP"
    _radius = 24
  }

  RoundPillar =
  {
    _prefab = "ROUND_PILLAR"
    _radius = 32

    pillar = "TECH02_5"
  }
--]]


  ---| HALLWAY PIECES |---

  Hall_Basic_I =
  {
    _prefab = "HALL_BASIC_I"
    _shape  = "I"
  }

  Hall_Basic_C =
  {
    _prefab = "HALL_BASIC_C"
    _shape  = "C"

    torch_ent = "none"
  }

  Hall_Basic_T =
  {
    _prefab = "HALL_BASIC_T"
    _shape  = "T"
  }

  Hall_Basic_P =
  {
    _prefab = "HALL_BASIC_P"
    _shape  = "P"
  }

  Hall_Basic_I_Stair =
  {
    _prefab = "HALL_BASIC_I_STAIR"
    _shape  = "IS"
  }

  Hall_Basic_I_Lift =
  {
    _prefab = "HALL_BASIC_I_LIFT_QUAKE"
    _shape  = "IL"
    _tags   = 1

    lift = "MET5_1"
  }


  Sky_Hall_I =
  {
    _prefab = "SKY_HALL_I"
    _shape  = "I"
    _need_sky = 1
  }

  Sky_Hall_C =
  {
    _prefab = "SKY_HALL_C"
    _shape  = "C"
    _need_sky = 1

    support = "METAL1_1"
    torch_ent = "none"
  }

  Sky_Hall_I_Stair =
  {
    _prefab = "SKY_HALL_I_STAIR"
    _shape  = "IS"
    _need_sky = 1

--??    step = "STEP5"
  }




} -- end of QUAKE2.SKINS


----------------------------------------------------------------


QUAKE2.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_basic = 50 }

  pedestals = { Pedestal_1 = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
              Lift_Up1 = 7,   Lift_Down1 = 7 }

  keys = { k_red=60, k_blue=40 }

  switches = { sw_foo=50 }

  switch_fabs = { Switch_floor1 = 50 }

  locked_doors = { Locked_red = 50, Locked_blue = 50,
                   Door_SW_1 = 50 }

  teleporters = { Teleporter1 = 50 }

  hallway_groups = { basic = 50 }

  mini_halls = { Hall_Basic_I = 50 }

  sky_halls = { skier = 50 }

  logos = { Pic_Carve = 50 }
}


QUAKE2.NAME_THEMES =
{
  -- TODO (especially 'Strogg')
}


QUAKE2.HALLWAY_GROUPS =
{
  basic =
  {
    pieces =
    {
      Hall_Basic_I = 50
      Hall_Basic_C = 50
      Hall_Basic_T = 50
      Hall_Basic_P = 50

      Hall_Basic_I_Stair = 20
      Hall_Basic_I_Lift  = 2
    }
  }

  skier =
  {
    pieces =
    {
      Sky_Hall_I = 50
      Sky_Hall_C = 50
      Sky_Hall_I_Stair = 50

      Hall_Basic_T = 50  -- use indoor versions for these
      Hall_Basic_P = 50  --

      Hall_Basic_I_Lift = 2   -- TODO: sky version
    }
  }
}


QUAKE2.ROOM_THEMES =
{
  Base_generic =
  {
    walls =
    {
      METAL2_1=10, METAL14_1=40,
      WSLT1_1=40, WATRT1_1=10,
      MINE05_1=20, MINE06_3=10, TWALL5_1=10,
      BLUM12_2=10,
    }

    floors =
    {
      FLAT1_2=30, FLOOR3_3=10, METAL1_8=20,
      METAL3_3=20, WTROOF4_2=30,
      WTROOF1_5=20, FLORR1_1=10,
    }

    ceilings =
    {
      WGRATE1_4=50, GRATE1_4=30, BASIC1_7=30,
      GRNX2_5=30, GRNX2_1=30,
    }
  }

  Cave_generic =
  {
    naturals =
    {
      ROCK1_1  = 50, ROCK0_1  = 20, ROCK25_1 = 50,
      ROCKS21_1 = 20, ROCKS24_2 = 50,
      ROCKS22_1 = 50,  -- crystal / ice
    }
  }

  Outdoors_generic =
  {
    floors =
    {
      FLOOR3_1=30, FLOOR3_2=5,
    }

    naturals =
    {
      GRASS1_4=50, ROCKS19_1=50,
      ROCK1_1=20, ROCKS24_2=20,
    }
  }
}


QUAKE2.LEVEL_THEMES =
{
  quake2_base1 =
  {
    prob = 50

    liquids = { slime=50, lava=40 }

    buildings = { Base_generic=50 }

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

  }
}


----------------------------------------------------------------

QUAKE2.MONSTERS =
{
  guard =
  {
    id = "monster_soldier_light"
    r = 16
    h = 56
    level = 1
    prob = 20
    health = 20
    damage = 4
    attack = "missile"
  }

  guard_sg =
  {
    id = "monster_soldier"
    r = 16
    h = 56
    level = 1
    prob = 70
    health = 30
    damage = 10
    attack = "hitscan"
  }

  guard_mg =
  {
    id = "monster_soldier_ss"
    r = 16
    h = 56
    replaces = "guard_sg"
    replace_prob = 50
    health = 30
    damage = 10
    attack = "hitscan"
  }

  enforcer =
  {
    id = "monster_infantry"
    r = 16
    h = 56
    level = 3
    prob = 50
    health = 100
    damage = 10
    attack = "hitscan"
  }

  flyer =
  {
    id = "monster_flyer"
    r = 16
    h = 56
    level = 1
    prob = 70
    health = 50
    damage = 5
    attack = "missile"
    float = true
    weap_prefs = { grenade=0.2 }
  }

  shark =
  {
    id = "monster_flipper"
    r = 16
    h = 56
    -- only appears in water
    health = 50
    damage = 5
    attack = "melee"
    weap_prefs = { grenade=0.2 }
  }

  parasite =
  {
    id = "monster_parasite"
    r = 16
    h = 56
    level = 2
    prob = 5
    health = 175
    damage = 10
    attack = "missile"
    density = 0.25
  }

  maiden =
  {
    id = "monster_chick"
    r = 16
    h = 56
    level = 7
    prob = 50
    health = 175
    damage = 30
    attack = "missile"
  }

  technician =
  {
    id = "monster_floater"
    r = 16
    h = 56
    level = 5
    prob = 50
    health = 200
    damage = 8
    attack = "missile"
    float = true
    weap_prefs = { grenade=0.2 }
  }

  beserker =
  {
    id = "monster_beserk"
    r = 16
    h = 56
    level = 5
    prob = 50
    health = 240
    damage = 18
    attack = "melee"
  }

  icarus =
  {
    id = "monster_hover"
    r = 16
    h = 56
    level = 4
    prob = 70
    health = 240
    damage = 5
    attack = "missile"
    float = true
    weap_prefs = { grenade=0.2 }
  }

  medic =
  {
    id = "monster_medic"
    r = 16
    h = 56
    level = 5
    prob = 30
    health = 300
    damage = 21
    attack = "missile"
  }

  mutant =
  {
    id = "monster_mutant"
    r = 32
    h = 56
    level = 3
    prob = 30
    health = 300
    damage = 24
    attack = "melee"
  }

  brain =
  {
    id = "monster_brain"
    r = 16
    h = 56
    level = 5
    prob = 20
    health = 300
    damage = 17
    attack = "melee"
  }

  grenader =
  {
    id = "monster_gunner"
    r = 16
    h = 56
    level = 5
    prob = 10
    health = 400
    damage = 30
    attack = "missile"
  }

  gladiator =
  {
    id = "monster_gladiator"
    r = 32
    h = 88
    level = 7
    prob = 10
    health = 400
    damage = 40
    attack = "missile"
  }

  tank =
  {
    id = "monster_tank"
    r = 16
    h = 56
    level = 8
    prob = 2
    health = 750
    damage = 160
    attack = "missile"
  }

  tank_cmdr =
  {
    id = "monster_tank_commander"
    r = 32
    h = 88
    level = 9
    health = 1000
    damage = 160
    attack = "missile"
  }

  ---| BOSSES |---

  -- FIXME: damage values and attack kinds?

  Super_tank =
  {
    id = "monster_supertank"
    r = 64
    h = 112
    health = 1500
    damage = 200
  }

  Huge_flyer =
  {
    id = "monster_boss2"
    r = 56
    h = 80
    health = 2000
    damage = 200
  }

  Jorg =
  {
    id = "monster_jorg"
    r = 80
    h = 140
    health = 3000
    damage = 200
  }

  Makron =
  {
    id = "monster_makron"
    r = 30
    h = 90
    health = 3000
    damage = 200
  }

  -- NOTES:
  --
  -- Dropped items are not endemic to types of monsters, but can
  -- be specified for each monster entity with the "item" keyword.
  -- This could be used for lots of cool stuff (e.g. kill a boss
  -- monster to get a needed key) -- another TODO feature.
  --
  -- Huge_flyer seems to be immune to the BFG spray, but not
  -- to the actualy BFG missile.  Since the ball does much more
  -- damage, we don't worry about the splash immunity.
  --
}


QUAKE2.WEAPONS =
{
  blaster =
  {
    rate = 1.7
    damage = 10
    attack = "missile"
  }

  shotty =
  {
    id = "weapon_shotgun"
    level = 1
    pref = 20
    add_prob = 10
    start_prob = 40
    attack = "hitscan"
    rate = 0.6
    damage = 40
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=10} }
  }

  ssg =
  {
    id = "weapon_supershotgun"
    level = 3
    pref = 70
    add_prob = 50
    attack = "hitscan"
    rate = 0.8
    damage = 88
    splash = {0,8}
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=10} }
  }

  machine =
  {
    id = "weapon_machinegun"
    level = 1
    pref = 20
    add_prob = 30
    attack = "hitscan"
    rate = 6.0
    damage = 8
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=50} }
  }

  chain =
  {
    id = "weapon_chaingun"
    level = 4
    pref = 90
    add_prob = 15
    attack = "hitscan"
    rate = 14
    damage = 8
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=50} }
  }

  grenade =
  {
    id = "weapon_grenadelauncher"
    level = 3
    pref = 15
    add_prob = 25
    attack = "missile"
    rate = 0.7
    damage = 5
    splash = {60,15,3}
    ammo = "grenade"
    per = 1
    give = { {ammo="grenade",count=5} }
  }

  launcher =
  {
    id = "weapon_rocketlauncher"
    level = 5
    pref = 30
    add_prob = 20
    attack = "missile"
    rate = 1.1
    damage = 90
    splash = {0,20,6,2}
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=5} }
  }

  rail =
  {
    id = "weapon_railgun"
    level = 5
    pref = 50
    add_prob = 25
    attack = "hitscan"
    rate = 0.6
    damage = 140
    ammo = "slug"
    per = 1
    splash = {0,25,5}
    give = { {ammo="slug",count=10} }
  }

  hyper =
  {
    id = "weapon_hyperblaster"
    level = 4
    pref = 60
    add_prob = 30
    attack = "missile"
    rate = 5.0
    damage = 20
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=50} }
  }

  bfg =
  {
    id = "weapon_bfg"
    level = 7
    pref = 20
    add_prob = 25
    attack = "missile"
    rate = 0.3
    damage = 200
    splash = {0,50,40,30,20,10,10}
    ammo = "cell"
    per = 50
    give = { {ammo="cell",count=50} }
  }


  -- Notes:
  --
  -- The BFG can damage lots of 'in view' monsters at once.
  -- This is modelled with a splash damage table.
  --
  -- Railgun can pass through multiple enemies.  We assume
  -- the player doesn't manage to do it very often :-)
  --
  -- Grenades don't do any direct damage when they hit a
  -- monster, it's all in the splash baby.
}


QUAKE2.PICKUPS =
{
  -- HEALTH --

  heal_2 =
  {
    id = "item_health_small"
    prob = 10
    cluster = { 3,9 }
    give = { {health=2} }
  }

  heal_10 =
  {
    id = "item_health"
    prob = 20
    give = { {health=10} }
  }

  heal_25 =
  {
    id = "item_health_large"
    prob = 50
    give = { {health=25} }
  }

  heal_100 =
  {
    id = "item_health_mega"
    prob = 5
    give = { {health=70} }
  }

  -- ARMOR --

  armor_2 =
  {
    id = "item_armor_shard"
    prob = 7
    cluster = { 3,9 }
    give = { {health=1} }
  }

  armor_25 =
  {
    id = "item_armor_jacket"
    prob = 7
    give = { {health=8} }
  }

  armor_50 =
  {
    id = "item_armor_combat"
    prob = 15
    give = { {health=25} }
  }

  armor_100 =
  {
    id = "item_armor_body"
    prob = 15
    give = { {health=80} }
  }

  -- AMMO --

  am_bullet =
  {
    id = "ammo_bullets"
    prob = 20
    give = { {ammo="bullet",count=50} }
  }

  am_shell =
  {
    id = "ammo_shells"
    prob = 20
    give = { {ammo="shell",count=10} }
  }

  am_grenade =
  {
    id = "ammo_grenades"
    prob = 20
    give = { {ammo="grenade",count=5} }
  }

  am_rocket =
  {
    id = "ammo_rockets"
    prob = 20
    give = { {ammo="rocket",count=5} }
  }

  am_slug = 
  {
    id = "ammo_slugs"
    prob = 20
    give = { {ammo="slug",count=10} }
  }

  am_cell =
  {
    id = "ammo_cells"
    prob = 20
    give = { {ammo="cell",count=50} }
  }

  -- Notes:
  --
  -- Megahealth only gives 70 instead of 100, since excess
  -- health rots away over time.
  --
  -- Each kind of Armor in Quake2 has two protection values, one
  -- for normal attacks (bullets or missiles) and one for energy
  -- attacks (blaster or bfg).  Since very few monsters use an
  -- energy attack (Technician only one??) we only use the normal
  -- protection value.
}


QUAKE2.PLAYER_MODEL =
{
  quakeguy =
  {
    stats   = { health=0 }
    weapons = { blaster=1 }
  }
}


------------------------------------------------------------

QUAKE2.EPISODES =
{
  episode1 =
  {
    theme = "TECH"
    sky_light = 0.75
  }

  episode2 =
  {
    theme = "TECH"
    sky_light = 0.75
  }

  episode3 =
  {
    theme = "TECH"
    sky_light = 0.75
  }
  
  episode4 =
  {
    theme = "TECH"
    sky_light = 0.75
  }

  episode5 =
  {
    theme = "TECH"
    sky_light = 0.75
  }
}


----------------------------------------------------------------

function QUAKE2.setup()
  -- nothing needed
end


function QUAKE2.get_levels()
  local  EP_NUM = (OB_CONFIG.length == "full"   ? 5 ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1 ; 5)

  if OB_CONFIG.length == "few"     then MAP_NUM = 3 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 7 end

  local prefixes = { "base", "ware", "jail", "mine", "fact" }

  for ep_index = 1,EP_NUM do
    -- create episode info...
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = QUAKE2.EPISODES["episode" .. ep_index]
    assert(ep_info)

    local ep_prefix = prefixes[ep_index]

    for map = 1,MAP_NUM do

      -- create level info...
      local LEV =
      {
        episode = EPI

        name     = ep_prefix .. (map)
        next_map = ep_prefix .. (map + 1)

         ep_along = map / MAP_NUM
        mon_along = (map + ep_index - 1) / MAP_NUM
      }

      -- end of episode? Go to next one (with cinematic) or face the Boss
      if map == MAP_NUM then
        if ep_index == 5 then
          LEV.next_map = "boss2"
        else
          LEV.next_map = string.format("eou%d_.cin+*%s1", ep_index, prefixes[ep_index+1])
        end
      end

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end



----------------------------------------------------------------

UNFINISHED["quake2"] =
{
  label = "Quake 2"

  format = "quake2"

  tables =
  {
    QUAKE2
  }

  hooks =
  {
    setup        = QUAKE2.setup
    get_levels   = QUAKE2.get_levels
  }
}


OB_THEMES["quake2_base"] =
{
  label = "Base"
  for_games = { quake2=1 }
  name_theme = "TECH"
  mixed_prob = 50
}

