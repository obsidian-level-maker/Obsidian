----------------------------------------------------------------
-- GAME DEF : Quake II
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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

QUAKE2_THINGS =
{
  -- players
  player1 = { id="info_player_start", kind="other", r=16,h=56 },
  player2 = { id="info_player_coop",  kind="other", r=16,h=56 },
  player3 = { id="info_player_coop",  kind="other", r=16,h=56 },
  player4 = { id="info_player_coop",  kind="other", r=16,h=56 },

  dm_player = { id="info_player_deathmatch", kind="other", r=16,h=56 },

  -- enemies
  guard      = { id="monster_soldier_light", kind="monster", r=16, h=56, },
  guard_sg   = { id="monster_soldier", kind="monster", r=16, h=56, },
  guard_mg   = { id="monster_soldier_ss",kind="monster", r=16, h=56, },
  enforcer   = { id="monster_infantry",kind="monster", r=16, h=56, },
  beserker   = { id="monster_beserk",  kind="monster", r=16, h=56, },
  grenader   = { id="monster_gunner",  kind="monster", r=16, h=56, },

  tank       = { id="monster_tank",    kind="monster", r=16, h=56, },
  gladiator  = { id="monster_gladiator",kind="monster", r=32, h=88, },
  medic      = { id="monster_medic",   kind="monster", r=16, h=56, },
  maiden     = { id="monster_chick",   kind="monster", r=16, h=56, },
  tank_cmdr  = { id="monster_tank_commander",kind="monster", r=32, h=88, },

  flyer      = { id="monster_flyer",   kind="monster", r=16, h=56, },
  technician = { id="monster_floater", kind="monster", r=16, h=56, },
  icarus     = { id="monster_hover",   kind="monster", r=16, h=56, },
  parasite   = { id="monster_parasite",kind="monster", r=16, h=56, },
  shark      = { id="monster_flipper", kind="monster", r=16, h=56, },
  mutant     = { id="monster_mutant",  kind="monster", r=32, h=56, },
  brain      = { id="monster_brain",   kind="monster", r=16, h=56, },

  -- bosses
  Super_tank = { id="monster_supertank",kind="monster", r=64, h=112, },
  Huge_flyer = { id="monster_boss2",    kind="monster", r=56, h=80,  },
  Jorg       = { id="monster_jorg",     kind="monster", r=80, h=140, },
  Makron     = { id="monster_makron",   kind="monster", r=30, h=90,  },

  -- pickups
  k_blue  = { id="key_blue_key",  kind="pickup", r=16, h=32, pass=true },
  k_red   = { id="key_red_key",   kind="pickup", r=16, h=32, pass=true },
  k_cd    = { id="key_data_cd",   kind="pickup", r=16, h=32, pass=true },
  k_pass  = { id="key_pass",      kind="pickup", r=16, h=32, pass=true },
  k_cube  = { id="key_power_cube",kind="pickup", r=16, h=32, pass=true },
  k_pyr   = { id="key_pyramid",   kind="pickup", r=16, h=32, pass=true },

  shotty   = { id="weapon_shotgun",         kind="pickup", r=16, h=32, pass=true },
  ssg      = { id="weapon_supershotgun",    kind="pickup", r=16, h=32, pass=true },
  machine  = { id="weapon_machinegun",      kind="pickup", r=16, h=32, pass=true },
  chain    = { id="weapon_chaingun",        kind="pickup", r=16, h=32, pass=true },
  grenade  = { id="weapon_grenadelauncher", kind="pickup", r=16, h=32, pass=true },
  launcher = { id="weapon_rocketlauncher",  kind="pickup", r=16, h=32, pass=true },
  hyper    = { id="weapon_hyperblaster",    kind="pickup", r=16, h=32, pass=true },
  rail     = { id="weapon_railgun",         kind="pickup", r=16, h=32, pass=true },
  bfg      = { id="weapon_bfg",             kind="pickup", r=16, h=32, pass=true },

  heal_2     = { id="item_health_small", kind="pickup", r=16, h=32, pass=true },
  heal_10    = { id="item_health",       kind="pickup", r=16, h=32, pass=true },
  heal_25    = { id="item_health_large", kind="pickup", r=16, h=32, pass=true },
  heal_100   = { id="item_health_mega",  kind="pickup", r=16, h=32, pass=true },
  adrenaline = { id="item_adrenaline",   kind="pickup", r=16, h=32, pass=true },

  armor_2    = { id="item_armor_shard",  kind="pickup", r=16, h=32, pass=true },
  armor_25   = { id="item_armor_jacket", kind="pickup", r=16, h=32, pass=true },
  armor_50   = { id="item_armor_combat", kind="pickup", r=16, h=32, pass=true },
  armor_100  = { id="item_armor_body",   kind="pickup", r=16, h=32, pass=true },

  am_bullet  = { id="ammo_bullets", kind="pickup", r=16, h=32, pass=true },
  am_cell    = { id="ammo_cells",   kind="pickup", r=16, h=32, pass=true },
  am_shell   = { id="ammo_shells",  kind="pickup", r=16, h=32, pass=true },
  am_grenade = { id="ammo_grenades",kind="pickup", r=16, h=32, pass=true },
  am_slug    = { id="ammo_slugs",   kind="pickup", r=16, h=32, pass=true },
  am_rocket  = { id="ammo_rockets", kind="pickup", r=16, h=32, pass=true },

  bandolier  = { id="item_bandolier", kind="pickup", r=16, h=32, pass=true },
  breather   = { id="item_breather",  kind="pickup", r=16, h=32, pass=true },
  enviro     = { id="item_enviro",    kind="pickup", r=16, h=32, pass=true },
  invuln     = { id="item_invulnerability", kind="pickup", r=16, h=32, pass=true },
  quad       = { id="item_quad",      kind="pickup", r=16, h=32, pass=true },

  -- scenery
  barrel      = { id="misc_explobox", kind="scenery", r=20, h=40, pass=true },
  dead_dude   = { id="misc_deadsoldier", kind="scenery", r=20, h=60, pass=true },
  insane_dude = { id="misc_insane",  kind="scenery", r=20, h=60, pass=true },
  -- FIXME: varieties of insane_dude!

  -- special

  -- TODO
}


----------------------------------------------------------------

QUAKE2_PALETTE =
{
    0,  0,  0,  15, 15, 15,  31, 31, 31,  47, 47, 47,  63, 63, 63,
   75, 75, 75,  91, 91, 91, 107,107,107, 123,123,123, 139,139,139,
  155,155,155, 171,171,171, 187,187,187, 203,203,203, 219,219,219,
  235,235,235,  99, 75, 35,  91, 67, 31,  83, 63, 31,  79, 59, 27,
   71, 55, 27,  63, 47, 23,  59, 43, 23,  51, 39, 19,  47, 35, 19,
   43, 31, 19,  39, 27, 15,  35, 23, 15,  27, 19, 11,  23, 15, 11,
   19, 15,  7,  15, 11,  7,  95, 95,111,  91, 91,103,  91, 83, 95,
   87, 79, 91,  83, 75, 83,  79, 71, 75,  71, 63, 67,  63, 59, 59,
   59, 55, 55,  51, 47, 47,  47, 43, 43,  39, 39, 39,  35, 35, 35,
   27, 27, 27,  23, 23, 23,  19, 19, 19, 143,119, 83, 123, 99, 67,
  115, 91, 59, 103, 79, 47, 207,151, 75, 167,123, 59, 139,103, 47,
  111, 83, 39, 235,159, 39, 203,139, 35, 175,119, 31, 147, 99, 27,
  119, 79, 23,  91, 59, 15,  63, 39, 11,  35, 23,  7, 167, 59, 43,
  159, 47, 35, 151, 43, 27, 139, 39, 19, 127, 31, 15, 115, 23, 11,
  103, 23,  7,  87, 19,  0,  75, 15,  0,  67, 15,  0,  59, 15,  0,
   51, 11,  0,  43, 11,  0,  35, 11,  0,  27,  7,  0,  19,  7,  0,
  123, 95, 75, 115, 87, 67, 107, 83, 63, 103, 79, 59,  95, 71, 55,
   87, 67, 51,  83, 63, 47,  75, 55, 43,  67, 51, 39,  63, 47, 35,
   55, 39, 27,  47, 35, 23,  39, 27, 19,  31, 23, 15,  23, 15, 11,
   15, 11,  7, 111, 59, 23,  95, 55, 23,  83, 47, 23,  67, 43, 23,
   55, 35, 19,  39, 27, 15,  27, 19, 11,  15, 11,  7, 179, 91, 79,
  191,123,111, 203,155,147, 215,187,183, 203,215,223, 179,199,211,
  159,183,195, 135,167,183, 115,151,167,  91,135,155,  71,119,139,
   47,103,127,  23, 83,111,  19, 75,103,  15, 67, 91,  11, 63, 83,
    7, 55, 75,   7, 47, 63,   7, 39, 51,   0, 31, 43,   0, 23, 31,
    0, 15, 19,   0,  7, 11,   0,  0,  0, 139, 87, 87, 131, 79, 79,
  123, 71, 71, 115, 67, 67, 107, 59, 59,  99, 51, 51,  91, 47, 47,
   87, 43, 43,  75, 35, 35,  63, 31, 31,  51, 27, 27,  43, 19, 19,
   31, 15, 15,  19, 11, 11,  11,  7,  7,   0,  0,  0, 151,159,123,
  143,151,115, 135,139,107, 127,131, 99, 119,123, 95, 115,115, 87,
  107,107, 79,  99, 99, 71,  91, 91, 67,  79, 79, 59,  67, 67, 51,
   55, 55, 43,  47, 47, 35,  35, 35, 27,  23, 23, 19,  15, 15, 11,
  159, 75, 63, 147, 67, 55, 139, 59, 47, 127, 55, 39, 119, 47, 35,
  107, 43, 27,  99, 35, 23,  87, 31, 19,  79, 27, 15,  67, 23, 11,
   55, 19, 11,  43, 15,  7,  31, 11,  7,  23,  7,  0,  11,  0,  0,
    0,  0,  0, 119,123,207, 111,115,195, 103,107,183,  99, 99,167,
   91, 91,155,  83, 87,143,  75, 79,127,  71, 71,115,  63, 63,103,
   55, 55, 87,  47, 47, 75,  39, 39, 63,  35, 31, 47,  27, 23, 35,
   19, 15, 23,  11,  7,  7, 155,171,123, 143,159,111, 135,151, 99,
  123,139, 87, 115,131, 75, 103,119, 67,  95,111, 59,  87,103, 51,
   75, 91, 39,  63, 79, 27,  55, 67, 19,  47, 59, 11,  35, 47,  7,
   27, 35,  0,  19, 23,  0,  11, 15,  0,   0,255,  0,  35,231, 15,
   63,211, 27,  83,187, 39,  95,167, 47,  95,143, 51,  95,123, 51,
  255,255,255, 255,255,211, 255,255,167, 255,255,127, 255,255, 83,
  255,255, 39, 255,235, 31, 255,215, 23, 255,191, 15, 255,171,  7,
  255,147,  0, 239,127,  0, 227,107,  0, 211, 87,  0, 199, 71,  0,
  183, 59,  0, 171, 43,  0, 155, 31,  0, 143, 23,  0, 127, 15,  0,
  115,  7,  0,  95,  0,  0,  71,  0,  0,  47,  0,  0,  27,  0,  0,
  239,  0,  0,  55, 55,255, 255,  0,  0,   0,  0,255,  43, 43, 35,
   27, 27, 23,  19, 19, 15, 235,151,127, 195,115, 83, 159, 87, 51,
  123, 63, 27, 235,211,199, 199,171,155, 167,139,119, 135,107, 87,
  159, 91, 83                                         
}


----------------------------------------------------------------

QUAKE2_MATERIALS =
{
  airduc1_1  = { "e1u3/airduc1_1" },
  airduc1_2  = { "e1u3/airduc1_2" },
  airduc1_3  = { "e1u3/airduc1_3" },
  alarm0     = { "e1u1/alarm0" },
  alarm1     = { "e1u1/alarm1" },
  alarm2     = { "e1u1/alarm2" },
  alarm3     = { "e1u1/alarm3" },
  angle1_1   = { "e1u2/angle1_1" },
  angle1_2   = { "e1u2/angle1_2" },
  arrow0     = { "e1u1/arrow0" },
  arrow1     = { "e1u1/arrow1" },
  arrow2     = { "e1u1/arrow2" },
  arrow3     = { "e1u1/arrow3" },
  arrow4     = { "e1u1/arrow4" },
  arrowup3   = { "e1u1/arrowup3" },
  arvnt1_4   = { "e3u3/arvnt1_4" },
  awater     = { "e3u3/awater" },
  bannerc    = { "e3u1/bannerc" },
  bannerd    = { "e3u1/bannerd" },
  bannere    = { "e3u1/bannere" },
  bannerf    = { "e3u1/bannerf" },
  baselt_2   = { "e1u1/baselt_2" },
  baselt_3   = { "e1u1/baselt_3" },
  baselt_4   = { "e1u1/baselt_4" },
  baselt_5   = { "e1u1/baselt_5" },
  baselt_6   = { "e2u3/baselt_6" },
  baselt_7   = { "e1u1/baselt_7" },
  baselt_b   = { "e1u1/baselt_b" },
  baselt_blu = { "e2u3/baselt_blu" },
  baselt_c   = { "e1u1/baselt_c" },
  baselt_d   = { "e2u3/baselt_d" },
  baselt_wht = { "e2u3/baselt_wht" },
  baselt_whte = { "e2u3/baselt_whte" },
  basemap    = { "e1u1/basemap" },
  basic1_2   = { "e1u2/basic1_2" },
  basic1_3   = { "e1u2/basic1_3" },
  basic1_5   = { "e1u2/basic1_5" },
  basic1_8   = { "e1u2/basic1_8" },
  baslt3_1   = { "e1u1/baslt3_1" },
  bed01_1    = { "e3u2/bed01_1" },
  bed02_2    = { "e3u2/bed02_2" },
  bed3_2     = { "e3u2/bed3_2" },
  bed3_3     = { "e3u2/bed3_3" },
  bed3_4     = { "e3u2/bed3_4" },
  bed4_3     = { "e3u2/bed4_3" },
  bed4_4     = { "e3u2/bed4_4" },
  bed4_7     = { "e3u2/bed4_7" },
  belt1_2    = { "e1u1/belt1_2" },
  belt2_1    = { "e2u2/belt2_1" },
  belt2_2    = { "e2u2/belt2_2" },
  belt2_3    = { "e2u2/belt2_3" },
  belt2_4    = { "e2u1/belt2_4" },
  belt2_5    = { "e2u2/belt2_5" },
  bigmet1_1  = { "e2u1/bigmet1_1" },
  bigmet1_2  = { "e1u2/bigmet1_2" },
  bigred1_1  = { "e3u1/bigred1_1" },
  bigred1_2  = { "e3u1/bigred1_2" },
  bigred8_1  = { "e3u1/bigred8_1" },
  black      = { "e1u1/black" },
  blank      = { "e2u1/blank" },
  blbk1_1    = { "e2u3/blbk1_1" },
  blbk1_2    = { "e2u3/blbk1_2" },
  blbk2_1    = { "e2u1/blbk2_1" },
  block1_5   = { "e3u2/block1_5" },
  block1_6   = { "e3u2/block1_6" },
  block1_7   = { "e3u2/block1_7" },
  blood1     = { "e1u3/blood1" },
  blood2     = { "e1u3/blood2" },
  bluekeypad = { "e1u1/bluekeypad" },
  bluelite   = { "e3u3/bluelite" },
  blum11_1   = { "e2u3/blum11_1" },
  blum12_1   = { "e2u3/blum12_1" },
  blum12_2   = { "e2u3/blum12_2" },
  blum13_1   = { "e2u3/blum13_1" },
  blum15_1   = { "e2u3/blum15_1" },
  blume3_1   = { "e2u3/blume3_1" },
  blume4_1   = { "e2u3/blume4_1" },
  blume4_2   = { "e2u3/blume4_2" },
  blume5_1   = { "e2u3/blume5_1" },
  blume5_2   = { "e2u3/blume5_2" },
  blume6_1   = { "e2u3/blume6_1" },
  blume6_2   = { "e2u3/blume6_2" },
  blume7_2   = { "e2u3/blume7_2" },
  blume8_1   = { "e2u3/blume8_1" },
  blume9_1   = { "e2u3/blume9_1" },
  blume9_2   = { "e2u3/blume9_2" },
  blumt2_6   = { "e2u3/blumt2_6" },
  bluwter    = { "e1u1/bluwter" },
  bmetal11_1 = { "e2u1/bmetal11_1" },
  bmetal11_2 = { "e2u2/bmetal11_2" },
  bmetal12_1 = { "e2u2/bmetal12_1" },
  bmetal13_1 = { "e2u2/bmetal13_1" },
  bmetal13_2 = { "e2u2/bmetal13_2" },
  bmtb13_1   = { "e2u3/bmtb13_1" },
  bossdr1    = { "e2u3/bossdr1" },
  bossdr2    = { "e2u3/bossdr2" },
  box02_3    = { "e1u2/box02_3" },
  box1_1     = { "e1u1/box1_1" },
  box1_2     = { "e1u2/box1_2" },
  box1_3     = { "e1u1/box1_3" },
  box1_4     = { "e1u1/box1_4" },
  box1_5     = { "e1u1/box1_5" },
  box1_6     = { "e1u1/box1_6" },
  box3_1     = { "e1u1/box3_1" },
  box3_2     = { "e1u1/box3_2" },
  box3_3     = { "e1u1/box3_3" },
  box3_4     = { "e1u1/box3_4" },
  box3_5     = { "e1u1/box3_5" },
  box3_6     = { "e1u1/box3_6" },
  box3_7     = { "e1u1/box3_7" },
  box3_8     = { "e1u1/box3_8" },
  box4_1     = { "e1u2/box4_1" },
  box4_2     = { "e1u2/box4_2" },
  box4_3     = { "e1u2/box4_3" },
  box4_4     = { "e1u2/box4_4" },
  brick1_1   = { "e3u1/brick1_1" },
  brick1_2   = { "e3u1/brick1_2" },
  brlava     = { "e1u1/brlava" },
  broken1_1  = { "e1u1/broken1_1" },
  broken2_1  = { "e1u1/broken2_1" },
  broken2_2  = { "e1u1/broken2_2" },
  broken2_3  = { "e1u1/broken2_3" },
  broken2_4  = { "e1u1/broken2_4" },
  brwater    = { "e1u1/brwater" },
  brwind5_2  = { "e1u2/brwind5_2" },
  btactmach  = { "e1u1/btactmach" },
  btactmach0 = { "e1u1/btactmach0" },
  btactmach1 = { "e1u1/btactmach1" },
  btactmach2 = { "e1u1/btactmach2" },
  btactmach3 = { "e1u1/btactmach3" },
  btdoor     = { "e1u1/btdoor" },
  btdoor_op  = { "e1u1/btdoor_op" },
  btelev     = { "e1u1/btelev" },
  btelev_dn  = { "e1u1/btelev_dn" },
  btelev_dn3 = { "e1u1/btelev_dn3" },
  btelev_up3 = { "e1u1/btelev_up3" },
  btf_off    = { "e2u1/btf_off" },
  butn01_1   = { "e1u3/butn01_1" },

  cable1_1   = { "e1u2/cable1_1" },
  caution1_1 = { "e1u2/caution1_1" },
  ceil1_1    = { "e1u1/ceil1_1" },
  ceil1_11   = { "e2u3/ceil1_11" },
  ceil1_12   = { "e1u2/ceil1_12" },
  ceil1_13   = { "e2u3/ceil1_13" },
  ceil1_14   = { "e3u1/ceil1_14" },
  ceil1_15   = { "e1u2/ceil1_15" },
  ceil1_16   = { "e1u3/ceil1_16" },
  ceil1_17   = { "e1u3/ceil1_17" },
  ceil1_2    = { "e1u1/ceil1_2" },
  ceil1_21   = { "e1u3/ceil1_21" },
  ceil1_22   = { "e1u2/ceil1_22" },
  ceil1_23   = { "e1u2/ceil1_23" },
  ceil1_24   = { "e3u1/ceil1_24" },
  ceil1_25   = { "e1u2/ceil1_25" },
  ceil1_27   = { "e3u3/ceil1_27" },
  ceil1_28   = { "e1u1/ceil1_28" },
  ceil1_3    = { "e1u1/ceil1_3" },
  ceil1_4    = { "e1u1/ceil1_4" },
  ceil1_5    = { "e1u3/ceil1_5" },
  ceil1_6    = { "e1u3/ceil1_6" },
  ceil1_7    = { "e1u1/ceil1_7" },
  ceil1_8    = { "e1u1/ceil1_8" },
  cgrbase1_1 = { "e1u1/cgrbase1_1" },
  cindb2_1   = { "e1u3/cindb2_1" },
  cindb2_2   = { "e1u3/cindb2_2" },
  cinder1_2  = { "e1u3/cinder1_2" },
  cinder1_3  = { "e1u3/cinder1_3" },
  cinder1_5  = { "e1u3/cinder1_5" },
  cinder1_6  = { "e1u3/cinder1_6" },
  cinder1_7  = { "e1u3/cinder1_7" },
  cinder1_8  = { "e1u3/cinder1_8" },
  cindr2_1   = { "e1u3/cindr2_1" },
  cindr2_2   = { "e1u3/cindr2_2" },
  cindr3_1   = { "e1u3/cindr3_1" },
  cindr3_2   = { "e1u3/cindr3_2" },
  cindr4_1   = { "e1u3/cindr4_1" },
  cindr4_2   = { "e1u3/cindr4_2" },
  cindr5_1   = { "e1u3/cindr5_1" },
  cindr5_2   = { "e1u3/cindr5_2" },
  cindr6_1   = { "e1u3/cindr6_1" },
  cindr7_1   = { "e1u3/cindr7_1" },
  cindr8_1   = { "e1u3/cindr8_1" },
  cindr8_2   = { "e2u1/cindr8_2" },
  cin_flr1_1 = { "e1u3/cin_flr1_1" },
  cin_flr1_2 = { "e1u3/cin_flr1_2" },
  citlit1_1  = { "e3u1/citlit1_1" },
  citlit1_4  = { "e3u1/citlit1_4" },
  citycomp1  = { "e3u1/citycomp1" },
  citycomp2  = { "e3u1/citycomp2" },
  citycomp3  = { "e3u1/citycomp3" },
  clip_mon   = { "e1u1/clip_mon" },
  c_met10_1  = { "e3u3/c_met10_1" },
  c_met11_2  = { "e1u1/c_met11_2" },
  c_met14_1  = { "e2u1/c_met14_1" },
  c_met5_1   = { "e1u1/c_met5_1" },
  c_met51a   = { "e1u1/c_met51a" },
  c_met51b   = { "e1u1/c_met51b" },
  c_met51c   = { "e1u1/c_met51c" },
  c_met5_2   = { "e1u1/c_met5_2" },
  c_met52a   = { "e1u1/c_met52a" },
  c_met7_1   = { "e1u1/c_met7_1" },
  c_met7_2   = { "e1u1/c_met7_2" },
  c_met8_2   = { "e1u1/c_met8_2" },
  color1_2   = { "e1u1/color1_2" },
  color1_2   = { "e3u3/color1_2" },
  color1_3   = { "e1u1/color1_3" },
  color1_4   = { "e1u1/color1_4" },
  color1_4   = { "e3u3/color1_4" },
  color1_5   = { "e1u1/color1_5" },
  color1_5   = { "e3u3/color1_5" },
  color1_6   = { "e1u1/color1_6" },
  color1_7   = { "e1u1/color1_7" },
  color1_7   = { "e3u3/color1_7" },
  color1_8   = { "e1u1/color1_8" },
  color1_8   = { "e3u3/color1_8" },
  color2_4   = { "e1u1/color2_4" },
  comp1_1    = { "e1u1/comp1_1" },
  comp1_2    = { "e1u1/comp1_2" },
  comp1_4    = { "e1u1/comp1_4" },
  comp1_5    = { "e1u1/comp1_5" },
  comp1_7    = { "e1u1/comp1_7" },
  comp1_8    = { "e1u1/comp1_8" },
  comp2_1    = { "e1u1/comp2_1" },
  comp2_1    = { "e1u2/comp2_1" },
  comp2_3    = { "e1u1/comp2_3" },
  comp2_3    = { "e1u2/comp2_3" },
  comp2_4    = { "e1u2/comp2_4" },
  comp2_5    = { "e1u1/comp2_5" },
  comp2_6    = { "e2u2/comp2_6" },
  comp2_d    = { "e1u3/comp2_d" },
  comp3_1    = { "e1u1/comp3_1" },
  comp3_2    = { "e1u1/comp3_2" },
  comp3_3    = { "e1u1/comp3_3" },
  comp3_4    = { "e1u1/comp3_4" },
  comp3_5    = { "e1u1/comp3_5" },
  comp3_6    = { "e1u1/comp3_6" },
  comp3_7    = { "e1u1/comp3_7" },
  comp3_8    = { "e1u1/comp3_8" },
  comp4_1    = { "e1u1/comp4_1" },
  comp4_2    = { "e1u1/comp4_2" },
  comp4_3    = { "e1u3/comp4_3" },
  comp5_1    = { "e1u1/comp5_1" },
  comp5_2    = { "e1u1/comp5_2" },
  comp5_3    = { "e1u1/comp5_3" },
  comp5_4    = { "e1u1/comp5_4" },
  comp7_1    = { "e1u1/comp7_1" },
  comp7_2    = { "e2u1/comp7_2" },
  comp7_3    = { "e2u1/comp7_3" },
  comp8_1    = { "e1u1/comp8_1" },
  comp9_1    = { "e1u1/comp9_1" },
  comp9_2    = { "e1u1/comp9_2" },
  comp9_3    = { "e1u1/comp9_3" },
  compu1_2   = { "e2u1/compu1_2" },
  compu1_3   = { "e2u2/compu1_3" },
  compu2_1   = { "e2u1/compu2_1" },
  con1_1     = { "e1u3/con1_1" },
  con1_1     = { "e2u3/con1_1" },
  con1_2     = { "e1u3/con1_2" },
  con_flr1_1 = { "e1u3/con_flr1_1" },
  con_flr1_2 = { "e1u3/con_flr1_2" },
  coolant    = { "e3u3/coolant" },
  core1_1    = { "e2u3/core1_1" },
  core1_3    = { "e2u3/core1_3" },
  core1_4    = { "e2u3/core1_4" },
  core2_3    = { "e2u3/core2_3" },
  core2_4    = { "e2u3/core2_4" },
  core3_1    = { "e2u3/core3_1" },
  core3_3    = { "e2u3/core3_3" },
  core5_1    = { "e2u3/core5_1" },
  core5_3    = { "e2u3/core5_3" },
  core5_4    = { "e2u3/core5_4" },
  core6_1    = { "e2u3/core6_1" },
  core6_3    = { "e2u3/core6_3" },
  core7_3    = { "e2u3/core7_3" },
  core7_4    = { "e2u3/core7_4" },
  crate1_1   = { "e1u1/crate1_1" },
  crate1_3   = { "e1u1/crate1_3" },
  crate1_4   = { "e1u1/crate1_4" },
  crate1_5   = { "e1u2/crate1_5" },
  crate1_6   = { "e1u1/crate1_6" },
  crate1_7   = { "e1u1/crate1_7" },
  crate1_8   = { "e1u2/crate1_8" },
  crate2_2   = { "e1u2/crate2_2" },
  crate2_6   = { "e1u2/crate2_6" },
  crush1_1   = { "e2u1/crush1_1" },
  crush1_2   = { "e2u1/crush1_2" },
  crys1_1    = { "e2u1/crys1_1" },
  crys1_2    = { "e2u1/crys1_2" },
  crys1_3    = { "e2u1/crys1_3" },
  ctylt1_1   = { "e3u1/ctylt1_1" },
  cur_0      = { "e2u1/cur_0" },

  damage1_1  = { "e1u1/damage1_1" },
  damage1_2  = { "e1u1/damage1_2" },
  damn1_1    = { "e3u1/damn1_1" },
  darkmet1_1 = { "e3u1/darkmet1_1" },
  darkmet1_2 = { "e3u1/darkmet1_2" },
  darkmet2_1 = { "e3u1/darkmet2_1" },
  darkmet2_2 = { "e3u1/darkmet2_2" },
  dfloor10_1 = { "e3u1/dfloor10_1" },
  dfloor10_2 = { "e3u1/dfloor10_2" },
  dfloor1_1  = { "e3u1/dfloor1_1" },
  dfloor1_2  = { "e3u1/dfloor1_2" },
  dfloor1_3  = { "e3u1/dfloor1_3" },
  dfloor1_4  = { "e3u1/dfloor1_4" },
  dfloor2_1  = { "e3u1/dfloor2_1" },
  dfloor2_2  = { "e3u1/dfloor2_2" },
  dfloor4_1  = { "e3u1/dfloor4_1" },
  dfloor5_2  = { "e3u1/dfloor5_2" },
  dfloor6_1  = { "e3u1/dfloor6_1" },
  dfloor6_2  = { "e3u1/dfloor6_2" },
  dfloor7_1  = { "e3u1/dfloor7_1" },
  dfloor7_2  = { "e3u1/dfloor7_2" },
  dfloor8_1  = { "e3u1/dfloor8_1" },
  dfloor8_2  = { "e3u1/dfloor8_2" },
  doom       = { "e3u1/doom" },
  door01     = { "e2u3/door01" },
  door2_2    = { "e3u1/door2_2" },
  doorbot    = { "e1u1/doorbot" },
  doorfc1_1  = { "e1u3/doorfc1_1" },
  doorfc1_3  = { "e1u3/doorfc1_3" },
  doorfc1_4  = { "e1u3/doorfc1_4" },
  doorswt0   = { "e1u1/doorswt0" },
  doorswt1   = { "e1u1/doorswt1" },
  doorswt2   = { "e1u1/doorswt2" },
  doorswt3   = { "e1u1/doorswt3" },
  dopfish    = { "e2u3/dopfish" },
  dr01_2     = { "e3u3/dr01_2" },
  dr02_1     = { "e1u1/dr02_1" },
  dr02_2     = { "e1u1/dr02_2" },
  dr03_1     = { "e2u3/dr03_1" },
  dr03_2     = { "e2u3/dr03_2" },
  dr04_1     = { "e1u1/dr04_1" },
  drag1_1    = { "e3u1/drag1_1" },
  drag1_2    = { "e3u1/drag1_2" },
  drag1_3    = { "e3u1/drag1_3" },
  drag2_1    = { "e3u1/drag2_1" },
  drag2_2    = { "e3u1/drag2_2" },
  drag2_3    = { "e3u1/drag2_3" },
  drag3_2    = { "e3u1/drag3_2" },
  drag3_3    = { "e3u1/drag3_3" },
  drag3_4    = { "e3u1/drag3_4" },
  drag4_1    = { "e3u1/drag4_1" },
  drag4_3    = { "e3u1/drag4_3" },
  drag4_4    = { "e3u1/drag4_4" },
  drsew1_1   = { "e2u3/drsew1_1" },
  drsew2_1   = { "e2u3/drsew2_1" },
  drsew2_2   = { "e2u3/drsew2_2" },
  dump1_1    = { "e2u3/dump1_1" },
  dump1_2    = { "e2u3/dump1_2" },
  dump3_1    = { "e2u3/dump3_1" },
  dump3_2    = { "e2u3/dump3_2" },
  elevdoor   = { "e3u3/elevdoor" },
  elev_dr1   = { "e1u2/elev_dr1" },
  elev_dr2   = { "e1u2/elev_dr2" },
  endsign1_1 = { "e1u2/endsign1_1" },
  endsign1_2 = { "e1u2/endsign1_2" },
  endsign1_7 = { "e1u2/endsign1_7" },
  endsign1_8 = { "e1u2/endsign1_8" },
  endsign1_9 = { "e1u2/endsign1_9" },
  endsign2   = { "e1u1/endsign2" },
  endsign3   = { "e1u1/endsign3" },
  endsign5   = { "e1u1/endsign5" },
  endsign6   = { "e1u1/endsign6" },
  exit1      = { "e1u1/exit1" },
  exitdr01_1 = { "e1u1/exitdr01_1" },
  exitdr01_2 = { "e1u1/exitdr01_2" },
  exitsin1_1 = { "e1u3/exitsin1_1" },
  exitsymbol2 = { "e1u1/exitsymbol2" },

  face       = { "e1u1/face" },
  flat1_1    = { "e1u1/flat1_1" },
  flat1_2    = { "e1u1/flat1_2" },
  flesh1_1   = { "e2u2/flesh1_1" },
  floor1_1   = { "e1u3/floor1_1" },
  floor1_2   = { "e2u3/floor1_2" },
  floor1_3   = { "e1u1/floor1_3" },
  floor1_3   = { "e2u2/floor1_3" },
  floor1_3   = { "e2u3/floor1_3" },
  floor1_4   = { "e2u3/floor1_4" },
  floor1_5   = { "e2u3/floor1_5" },
  floor1_6   = { "e2u3/floor1_6" },
  floor1_7   = { "e2u2/floor1_7" },
  floor1_7   = { "e2u3/floor1_7" },
  floor1_8   = { "e2u3/floor1_8" },
  floor2_2   = { "e3u1/floor2_2" },
  floor2_4   = { "e2u2/floor2_4" },
  floor2_7   = { "e2u2/floor2_7" },
  floor2_7   = { "e2u3/floor2_7" },
  floor2_8   = { "e2u3/floor2_8" },
  floor3_1   = { "e1u1/floor3_1" },
  floor3_2   = { "e1u1/floor3_2" },
  floor3_3   = { "e1u1/floor3_3" },
  floor3_3   = { "e2u3/floor3_3" },
  floor3_5   = { "e2u3/floor3_5" },
  floor3_6   = { "e2u3/floor3_6" },
  floor3_7   = { "e2u1/floor3_7" },
  floorsw0   = { "e1u1/floorsw0" },
  floorsw1   = { "e1u1/floorsw1" },
  floorsw2   = { "e1u1/floorsw2" },
  floorsw3   = { "e1u1/floorsw3" },
  florr1_1   = { "e2u1/florr1_1" },
  florr1_4   = { "e2u1/florr1_4" },
  florr1_5   = { "e1u1/florr1_5" },
  florr1_6   = { "e1u1/florr1_6" },
  florr1_8   = { "e1u1/florr1_8" },
  florr2_5   = { "e2u1/florr2_5" },
  florr2_6   = { "e2u1/florr2_6" },
  florr2_8   = { "e1u1/florr2_8" },
  flr1_1     = { "e2u1/flr1_1" },
  flr1_2     = { "e2u1/flr1_2" },
  flr1_3     = { "e2u1/flr1_3" },
  fmet1_2    = { "e1u3/fmet1_2" },
  fmet1_2    = { "e1u4/fmet1_2" },
  fmet1_3    = { "e1u3/fmet1_3" },
  fmet1_4    = { "e1u3/fmet1_4" },
  fmet2_2    = { "e1u3/fmet2_2" },
  fmet2_3    = { "e1u3/fmet2_3" },
  fmet2_4    = { "e1u3/fmet2_4" },
  fmet3_1    = { "e1u3/fmet3_1" },
  fmet3_2    = { "e1u3/fmet3_2" },
  fmet3_3    = { "e3u2/fmet3_3" },
  fmet3_4    = { "e1u3/fmet3_4" },
  fmet3_5    = { "e1u3/fmet3_5" },
  fmet3_6    = { "e1u3/fmet3_6" },
  fmet3_7    = { "e1u3/fmet3_7" },
  fuse1_1    = { "e1u2/fuse1_1" },
  fuse1_2    = { "e1u2/fuse1_2" },
  fuse1_3    = { "e1u2/fuse1_3" },
  fuse1_4    = { "e1u2/fuse1_4" },
  fusedr1    = { "e1u2/fusedr1" },
  fusedr2    = { "e1u2/fusedr2" },

  geolitc1_1 = { "e3u1/geolitc1_1" },
  geowal_02  = { "e3u1/geowal_02" },
  geowal_06  = { "e3u1/geowal_06" },
  geowal_10  = { "e3u1/geowal_10" },
  geowaldg   = { "e3u1/geowaldg" },
  geowaldi_1 = { "e3u1/geowaldi_1" },
  geowaldi_2 = { "e3u1/geowaldi_2" },
  geowalj1_4 = { "e3u1/geowalj1_4" },
  geowalm1_1 = { "e3u1/geowalm1_1" },
  geowalm1_2 = { "e3u1/geowalm1_2" },
  geowaln1_2 = { "e3u1/geowaln1_2" },
  geowalo1_1 = { "e3u1/geowalo1_1" },
  geowalp1_1 = { "e3u1/geowalp1_1" },
  ggrat12_2  = { "e1u1/ggrat12_2" },
  ggrat12_4  = { "e1u1/ggrat12_4" },
  ggrat2_1   = { "e1u1/ggrat2_1" },
  ggrat2_2   = { "e1u1/ggrat2_2" },
  ggrat2_7   = { "e1u1/ggrat2_7" },
  ggrat4_1   = { "e1u1/ggrat4_1" },
  ggrat4_2   = { "e1u1/ggrat4_2" },
  ggrat4_3   = { "e1u1/ggrat4_3" },
  ggrat4_4   = { "e1u1/ggrat4_4" },
  ggrat5_1   = { "e1u1/ggrat5_1" },
  ggrat5_2   = { "e1u1/ggrat5_2" },
  ggrat6_1   = { "e1u1/ggrat6_1" },
  ggrat6_2   = { "e1u1/ggrat6_2" },
  ggrate7_1  = { "e1u1/ggrate7_1" },
  ggrate8_1  = { "e1u1/ggrate8_1" },
  ggrate9_2  = { "e1u1/ggrate9_2" },
  glocrys_1  = { "e3u1/glocrys_1" },
  glocrys_2  = { "e3u1/glocrys_2" },
  grass1_2   = { "e3u1/grass1_2" },
  grass1_3   = { "e1u1/grass1_3" },
  grass1_4   = { "e1u1/grass1_4" },
  grass1_5   = { "e1u3/grass1_5" },
  grass1_6   = { "e3u3/grass1_6" },
  grass1_7   = { "e1u1/grass1_7" },
  grass1_8   = { "e1u1/grass1_8" },
  grate1_1   = { "e1u1/grate1_1" },
  grate1_2   = { "e1u1/grate1_2" },
  grate1_3   = { "e1u1/grate1_3" },
  grate1_4   = { "e1u1/grate1_4" },
  grate1_5   = { "e1u1/grate1_5" },
  grate1_6   = { "e1u1/grate1_6" },
  grate1_8   = { "e1u3/grate1_8" },
  grate2_1   = { "e1u1/grate2_1" },
  grate2_2   = { "e1u1/grate2_2" },
  grate2_3   = { "e1u1/grate2_3" },
  grate2_4   = { "e1u1/grate2_4" },
  grate2_5   = { "e1u1/grate2_5" },
  grate2_6   = { "e1u1/grate2_6" },
  grate2_7   = { "e1u1/grate2_7" },
  grate2_8   = { "e1u1/grate2_8" },
  green0_1   = { "e2u3/green0_1" },
  green0_2   = { "e2u3/green0_2" },
  green2_1   = { "e2u3/green2_1" },
  green2_2   = { "e2u3/green2_2" },
  green2_3   = { "e2u3/green2_3" },
  green3_1   = { "e2u3/green3_1" },
  green3_2   = { "e2u3/green3_2" },
  green3_3   = { "e2u3/green3_3" },
  green3_4   = { "e2u3/green3_4" },
  grey1_3    = { "e1u1/grey1_3" },
  grey_p1_3  = { "e1u1/grey_p1_3" },
  grlt1_1    = { "e1u1/grlt1_1" },
  grlt2_1    = { "e1u1/grlt2_1" },
  grndoor1   = { "e1u1/grndoor1" },
  grnmt1_1   = { "e1u1/grnmt1_1" },
  grnmt2_2   = { "e1u1/grnmt2_2" },
  grnx1_1    = { "e1u1/grnx1_1" },
  grnx1_2    = { "e1u1/grnx1_2" },
  grnx2_1    = { "e1u1/grnx2_1" },
  grnx2_2    = { "e1u1/grnx2_2" },
  grnx2_3    = { "e1u1/grnx2_3" },
  grnx2_4    = { "e1u3/grnx2_4" },
  grnx2_5    = { "e1u1/grnx2_5" },
  grnx2_6    = { "e1u1/grnx2_6" },
  grnx2_7    = { "e1u1/grnx2_7" },
  grnx2_8    = { "e1u1/grnx2_8" },
  grnx2_9    = { "e1u1/grnx2_9" },
  grnx3_1    = { "e1u1/grnx3_1" },
  grnx3_2    = { "e1u1/grnx3_2" },
  grnx3_3    = { "e1u1/grnx3_3" },
  hall01_1   = { "e3u2/hall01_1" },
  hall01_2   = { "e3u2/hall01_2" },
  hall01_3   = { "e3u2/hall01_3" },
  hall07_2   = { "e3u2/hall07_2" },
  hall07_3   = { "e3u2/hall07_3" },
  hall08_4   = { "e3u2/hall08_4" },
  hbut1_1    = { "e3u2/hbut1_1" },
  hbut1_2    = { "e3u2/hbut1_2" },
  hdoor1_1   = { "e2u1/hdoor1_1" },
  hdoor1_2   = { "e2u1/hdoor1_2" },
  head1_1    = { "e2u3/head1_1" },
  hvy_dr1_2  = { "e1u2/hvy_dr1_2" },
  hvy_dr2_1  = { "e1u2/hvy_dr2_1" },
  hvy_dr3_1  = { "e1u2/hvy_dr3_1" },
  hvy_dr3_2  = { "e1u2/hvy_dr3_2" },
  hvy_dr4_1  = { "e1u2/hvy_dr4_1" },

  jaildr03_1 = { "e3u1/jaildr03_1" },
  jaildr03_2 = { "e3u1/jaildr03_2" },
  jaildr1_1  = { "e1u3/jaildr1_1" },
  jaildr1_2  = { "e1u3/jaildr1_2" },
  jaildr1_3  = { "e1u1/jaildr1_3" },
  jaildr2_1  = { "e1u3/jaildr2_1" },
  jaildr2_2  = { "e1u3/jaildr2_2" },
  jaildr2_2  = { "e1u4/jaildr2_2" },
  jaildr2_3  = { "e1u1/jaildr2_3" },
  jaildr2_3  = { "e3u2/jaildr2_3" },
  jsign1_1   = { "e1u3/jsign1_1" },
  jsign2_1   = { "e1u3/jsign2_1" },
  kcsign4    = { "e1u1/kcsign4" },
  keydr1_1   = { "e1u1/keydr1_1" },
  keydran2_1 = { "e1u2/keydran2_1" },
  keysign1   = { "e1u3/keysign1" },
  keysign2   = { "e1u1/keysign2" },
  labsign1   = { "e3u3/labsign1" },
  labsign2   = { "e3u3/labsign2" },
  laserbut0  = { "e1u1/laserbut0" },
  laserbut1  = { "e1u1/laserbut1" },
  laserbut2  = { "e1u1/laserbut2" },
  laserbut3  = { "e1u1/laserbut3" },
  laserside  = { "e1u3/laserside" },
  lbutt5_3   = { "e1u1/lbutt5_3" },
  lbutt5_4   = { "e2u3/lbutt5_4" },
  lead1_2    = { "e2u3/lead1_2" },
  lead2_1    = { "e2u3/lead2_1" },
  lever1     = { "e3u3/lever1" },
  lever2     = { "e1u1/lever2" },
  lever3     = { "e1u1/lever3" },
  lever6     = { "e3u3/lever6" },
  lever7     = { "e1u1/lever7" },
  lever8     = { "e1u1/lever8" },
  light03_1  = { "e1u3/light03_1" },
  light03_2  = { "e1u2/light03_2" },
  light03_5  = { "e1u3/light03_5" },
  light03_6  = { "e1u3/light03_6" },
  light03_8  = { "e1u2/light03_8" },
  light2_2   = { "e1u2/light2_2" },
  lnum1_1    = { "e3u2/lnum1_1" },
  lnum1_2    = { "e3u2/lnum1_2" },
  location   = { "e1u3/location" },
  lsign1_1   = { "e3u2/lsign1_1" },
  lsign1_2   = { "e3u2/lsign1_2" },
  lsign1_3   = { "e3u2/lsign1_3" },
  lsrlt1     = { "e2u1/lsrlt1" },
  lzr01_1    = { "e2u1/lzr01_1" },
  lzr01_2    = { "e2u1/lzr01_2" },
  lzr01_4    = { "e2u1/lzr01_4" },
  lzr01_5    = { "e2u1/lzr01_5" },
  lzr02_1    = { "e2u1/lzr02_1" },
  lzr02_2    = { "e2u1/lzr02_2" },
  lzr03_1    = { "e2u1/lzr03_1" },

  mach1_1    = { "e1u3/mach1_1" },
  mach1_2    = { "e1u3/mach1_2" },
  mach1_3    = { "e2u2/mach1_3" },
  mach1_5    = { "e2u2/mach1_5" },
  machine1   = { "e2u3/machine1" },
  marble1_4  = { "e3u1/marble1_4" },
  marble1_7  = { "e3u1/marble1_7" },
  met1_1     = { "e1u3/met1_1" },
  met1_2     = { "e1u3/met1_2" },
  met1_3     = { "e1u3/met1_3" },
  met1_4     = { "e1u3/met1_4" },
  met1_5     = { "e1u3/met1_5" },
  met2_1     = { "e1u3/met2_1" },
  met2_2     = { "e1u3/met2_2" },
  met2_3     = { "e1u3/met2_3" },
  met2_4     = { "e1u3/met2_4" },
  met3_1     = { "e1u3/met3_1" },
  met3_2     = { "e1u3/met3_2" },
  met3_3     = { "e1u3/met3_3" },
  met4_1     = { "e1u3/met4_1" },
  met4_2     = { "e1u3/met4_2" },
  met4_3     = { "e1u3/met4_3" },
  met4_4     = { "e1u3/met4_4" },
  met4_5     = { "e1u3/met4_5" },
  metal10_1  = { "e1u2/metal10_1" },
  metal10_3  = { "e1u2/metal10_3" },
  metal1_1   = { "e1u1/metal1_1" },
  metal1_1   = { "e1u2/metal1_1" },
  metal1_1   = { "e2u3/metal1_1" },
  metal11_3  = { "e1u2/metal11_3" },
  metal11_4  = { "e1u2/metal11_4" },
  metal1_2   = { "e1u1/metal1_2" },
  metal1_2   = { "e1u2/metal1_2" },
  metal1_2   = { "e2u3/metal1_2" },
  metal12_1  = { "e1u2/metal12_1" },
  metal12_2  = { "e1u2/metal12_2" },
  metal12_4  = { "e1u2/metal12_4" },
  metal1_3   = { "e1u1/metal1_3" },
  metal1_3   = { "e1u2/metal1_3" },
  metal13_1  = { "e1u2/metal13_1" },
  metal13_2  = { "e1u2/metal13_2" },
  metal13_3  = { "e1u2/metal13_3" },
  metal1_4   = { "e1u1/metal1_4" },
  metal1_4   = { "e1u2/metal1_4" },
  metal14_1  = { "e1u1/metal14_1" },
  metal14_1  = { "e1u2/metal14_1" },
  metal14_2  = { "e1u2/metal14_2" },
  metal14_3  = { "e2u3/metal14_3" },
  metal1_5   = { "e1u1/metal1_5" },
  metal1_5   = { "e1u2/metal1_5" },
  metal15_2  = { "e2u3/metal15_2" },
  metal15_2  = { "e3u3/metal15_2" },
  metal1_6   = { "e1u2/metal1_6" },
  metal1_6   = { "e3u3/metal1_6" },
  metal16_1  = { "e2u2/metal16_1" },
  metal16_1  = { "e2u3/metal16_1" },
  metal16_2  = { "e2u3/metal16_2" },
  metal16_4  = { "e2u2/metal16_4" },
  metal1_7   = { "e1u1/metal1_7" },
  metal1_7   = { "e1u2/metal1_7" },
  metal17_1  = { "e3u3/metal17_1" },
  metal17_2  = { "e2u1/metal17_2" },
  metal17_2  = { "e3u3/metal17_2" },
  metal1_8   = { "e1u1/metal1_8" },
  metal18_1  = { "e2u1/metal18_1" },
  metal18_1  = { "e3u3/metal18_1" },
  metal18_2  = { "e2u2/metal18_2" },
  metal18_2  = { "e2u3/metal18_2" },
  metal18_2  = { "e3u3/metal18_2" },
  metal19_1  = { "e2u2/metal19_1" },
  metal19_1  = { "e3u3/metal19_1" },
  metal19_2  = { "e3u3/metal19_2" },
  metal20_1  = { "e3u3/metal20_1" },
  metal20_2  = { "e3u3/metal20_2" },
  metal2_1   = { "e1u1/metal2_1" },
  metal2_1   = { "e2u3/metal2_1" },
  metal21_1  = { "e3u3/metal21_1" },
  metal21_2  = { "e3u3/metal21_2" },
  metal2_2   = { "e1u1/metal2_2" },
  metal2_2   = { "e2u3/metal2_2" },
  metal22_1  = { "e3u3/metal22_1" },
  metal22_2  = { "e2u2/metal22_2" },
  metal22_2  = { "e3u3/metal22_2" },
  metal2_3   = { "e1u1/metal2_3" },
  metal23_1  = { "e3u3/metal23_1" },
  metal23_2  = { "e3u3/metal23_2" },
  metal23_3  = { "e3u3/metal23_3" },
  metal23_4  = { "e3u3/metal23_4" },
  metal2_4   = { "e1u1/metal2_4" },
  metal24_1  = { "e2u1/metal24_1" },
  metal24_2  = { "e2u2/metal24_2" },
  metal24_3  = { "e2u2/metal24_3" },
  metal24_4  = { "e2u2/metal24_4" },
  metal25_2  = { "e2u2/metal25_2" },
  metal25_3  = { "e2u1/metal25_3" },
  metal27_1  = { "e2u2/metal27_1" },
  metal28_1  = { "e2u2/metal28_1" },
  metal29_2  = { "e2u2/metal29_2" },
  metal3_1   = { "e1u1/metal3_1" },
  metal3_1   = { "e1u2/metal3_1" },
  metal3_1   = { "e2u1/metal3_1" },
  metal3_1   = { "e2u3/metal3_1" },
  metal3_2   = { "e1u1/metal3_2" },
  metal3_2   = { "e1u2/metal3_2" },
  metal3_2   = { "e2u1/metal3_2" },
  metal32_2  = { "e2u1/metal32_2" },
  metal3_3   = { "e1u1/metal3_3" },
  metal3_3   = { "e2u1/metal3_3" },
  metal33_1  = { "e2u2/metal33_1" },
  metal33_2  = { "e2u1/metal33_2" },
  metal3_4   = { "e1u1/metal3_4" },
  metal3_4   = { "e1u2/metal3_4" },
  metal34_2  = { "e2u2/metal34_2" },
  metal3_5   = { "e1u1/metal3_5" },
  metal35_1  = { "e2u1/metal35_1" },
  metal3_6   = { "e1u1/metal3_6" },
  metal36_1  = { "e2u1/metal36_1" },
  metal36_2  = { "e2u1/metal36_2" },
  metal36_3  = { "e2u1/metal36_3" },
  metal36_4  = { "e2u1/metal36_4" },
  metal3_7   = { "e1u1/metal3_7" },
  metal37_1  = { "e2u1/metal37_1" },
  metal37_2  = { "e2u1/metal37_2" },
  metal37_3  = { "e2u1/metal37_3" },
  metal37_4  = { "e2u1/metal37_4" },
  metal4_1   = { "e1u3/metal4_1" },
  metal4_1   = { "e2u3/metal4_1" },
  metal4_1   = { "e3u3/metal4_1" },
  metal4_2   = { "e1u2/metal4_2" },
  metal4_2   = { "e1u3/metal4_2" },
  metal4_2   = { "e2u1/metal4_2" },
  metal4_2   = { "e2u3/metal4_2" },
  metal42_2  = { "e2u2/metal42_2" },
  metal43_2  = { "e2u2/metal43_2" },
  metal4_4   = { "e3u3/metal4_4" },
  metal46_1  = { "e2u1/metal46_1" },
  metal46_4  = { "e2u1/metal46_4" },
  metal47_1  = { "e2u2/metal47_1" },
  metal47_2  = { "e2u2/metal47_2" },
  metal5_1   = { "e1u1/metal5_1" },
  metal5_1   = { "e1u2/metal5_1" },
  metal5_1   = { "e2u3/metal5_1" },
  metal5_1   = { "e3u3/metal5_1" },
  metal5_2   = { "e1u1/metal5_2" },
  metal5_2   = { "e1u2/metal5_2" },
  metal5_2   = { "e2u3/metal5_2" },
  metal5_2   = { "e3u3/metal5_2" },
  metal5_3   = { "e1u2/metal5_3" },
  metal5_4   = { "e1u2/metal5_4" },
  metal5_5   = { "e1u2/metal5_5" },
  metal5_6   = { "e1u2/metal5_6" },
  metal5_7   = { "e1u2/metal5_7" },
  metal5_8   = { "e1u2/metal5_8" },
  metal6_1   = { "e1u1/metal6_1" },
  metal6_1   = { "e1u2/metal6_1" },
  metal6_1   = { "e2u1/metal6_1" },
  metal6_1   = { "e2u3/metal6_1" },
  metal6_1   = { "e3u3/metal6_1" },
  metal6_2   = { "e1u1/metal6_2" },
  metal6_2   = { "e1u2/metal6_2" },
  metal6_2   = { "e3u3/metal6_2" },
  metal6_3   = { "e1u2/metal6_3" },
  metal7_1   = { "e2u3/metal7_1" },
  metal8_1   = { "e1u2/metal8_1" },
  metal8_1   = { "e2u3/metal8_1" },
  metal8_2   = { "e1u2/metal8_2" },
  metal8_3   = { "e1u2/metal8_3" },
  metal8_4   = { "e1u2/metal8_4" },
  metal8_5   = { "e1u2/metal8_5" },
  metal9_1   = { "e1u2/metal9_1" },
  metal9_1   = { "e2u3/metal9_1" },
  metal9_2   = { "e1u2/metal9_2" },
  metal9_3   = { "e1u2/metal9_3" },
  metal9_4   = { "e1u2/metal9_4" },
  metal9_6   = { "e1u2/metal9_6" },
  metals_1   = { "e1u2/metals_1" },
  metals_3   = { "e1u2/metals_3" },
  metl10_2   = { "e2u3/metl10_2" },
  metl5b_1   = { "e2u3/metl5b_1" },
  metl5b_3   = { "e3u1/metl5b_3" },
  mindr1_1   = { "e2u1/mindr1_1" },
  mine02_1   = { "e2u1/mine02_1" },
  mine02_2   = { "e2u1/mine02_2" },
  mine03_1   = { "e2u1/mine03_1" },
  mine03_2   = { "e2u1/mine03_2" },
  mine04_1   = { "e2u1/mine04_1" },
  mine04_2   = { "e2u1/mine04_2" },
  mine05_1   = { "e2u1/mine05_1" },
  mine05_2   = { "e2u1/mine05_2" },
  mine06_1   = { "e2u1/mine06_1" },
  mine06_2   = { "e2u1/mine06_2" },
  mine06_3   = { "e2u1/mine06_3" },
  mine06_4   = { "e2u1/mine06_4" },
  mine07_1   = { "e2u1/mine07_1" },
  mine07_2   = { "e2u1/mine07_2" },
  mine07_3   = { "e2u1/mine07_3" },
  mine07_4   = { "e2u1/mine07_4" },
  mine08_1   = { "e2u1/mine08_1" },
  mine08_3   = { "e2u1/mine08_3" },
  mine08_4   = { "e2u1/mine08_4" },
  mine10_1   = { "e2u1/mine10_1" },
  mine10_2   = { "e2u1/mine10_2" },
  mine13_1   = { "e2u1/mine13_1" },
  mine13_2   = { "e2u1/mine13_2" },
  mine14_1   = { "e2u1/mine14_1" },
  mine9_1    = { "e2u1/mine9_1" },
  minlt1_1   = { "e2u1/minlt1_1" },
  minlt1_2   = { "e2u1/minlt1_2" },
  minlt1_3   = { "e2u1/minlt1_3" },
  minpn3_1   = { "e2u1/minpn3_1" },
  mmtl15_5   = { "e2u1/mmtl15_5" },
  mmtl16_6   = { "e2u1/mmtl16_6" },
  mmtl19_1   = { "e2u1/mmtl19_1" },
  mmtl19_2   = { "e2u1/mmtl19_2" },
  mmtl20_1   = { "e2u1/mmtl20_1" },
  mon1_3     = { "e1u3/mon1_3" },
  mon1_6     = { "e1u3/mon1_6" },
  mont1_1    = { "e2u3/mont1_1" },
  mont1_3    = { "e2u3/mont1_3" },
  mont1_4    = { "e2u3/mont1_4" },
  mont3_1    = { "e2u1/mont3_1" },
  mont3_2    = { "e2u1/mont3_2" },
  mud1_1     = { "e2u1/mud1_1" },
  mvr1_2     = { "e1u2/mvr1_2" },
  mvr1_3     = { "e1u2/mvr1_3" },

  notch1_1   = { "e2u2/notch1_1" },
  notch1_2   = { "e2u2/notch1_2" },
  notch3_2   = { "e2u2/notch3_2" },
  notch4_2   = { "e2u2/notch4_2" },
  or01_1     = { "e3u2/or01_1" },
  or01_2     = { "e3u2/or01_2" },
  or01_3     = { "e3u2/or01_3" },
  or01_4     = { "e3u2/or01_4" },
  or02_1     = { "e3u2/or02_1" },
  or02_2     = { "e3u2/or02_2" },
  or02_3     = { "e3u2/or02_3" },
  ourpic1_1  = { "e2u3/ourpic1_1" },
  ourpic2_1  = { "e2u3/ourpic2_1" },
  ourpic2_2  = { "e2u3/ourpic2_2" },
  ourpic3_1  = { "e2u3/ourpic3_1" },
  ourpic3_2  = { "e2u3/ourpic3_2" },
  ourpic4_1  = { "e2u3/ourpic4_1" },
  ourpic4_2  = { "e2u3/ourpic4_2" },
  ourpic5_1  = { "e2u3/ourpic5_1" },
  ourpic5_2  = { "e2u3/ourpic5_2" },
  ourpic6_1  = { "e2u3/ourpic6_1" },
  ourpic6_2  = { "e2u3/ourpic6_2" },
  ourpic7_1  = { "e2u3/ourpic7_1" },
  palmet10_1 = { "e3u1/palmet10_1" },
  palmet10_2 = { "e3u1/palmet10_2" },
  palmet1_1  = { "e3u1/palmet1_1" },
  palmet12_1 = { "e3u1/palmet12_1" },
  palmet12_2 = { "e3u1/palmet12_2" },
  palmet12_3 = { "e3u1/palmet12_3" },
  palmet13_4 = { "e3u1/palmet13_4" },
  palmet14_1 = { "e3u1/palmet14_1" },
  palmet14_2 = { "e3u1/palmet14_2" },
  palmet14_3 = { "e3u1/palmet14_3" },
  palmet14_4 = { "e3u1/palmet14_4" },
  palmet3_1  = { "e3u1/palmet3_1" },
  palmet3_2  = { "e3u1/palmet3_2" },
  palmet5_2  = { "e3u1/palmet5_2" },
  palmet7_1  = { "e3u1/palmet7_1" },
  palmet9_2  = { "e3u1/palmet9_2" },
  palsup1_5  = { "e3u1/palsup1_5" },
  patwall0_2 = { "e3u1/patwall0_2" },
  pdor1_1    = { "e1u3/pdor1_1" },
  pdor1_2    = { "e1u3/pdor1_2" },
  p_flr_05   = { "e3u1/p_flr_05" },
  p_flr_10   = { "e3u1/p_flr_10" },
  pillar1_1  = { "e1u2/pillar1_1" },
  pillar1_2  = { "e1u2/pillar1_2" },
  pilr01_1   = { "e2u1/pilr01_1" },
  pilr01_2   = { "e2u1/pilr01_2" },
  pilr01_3   = { "e2u1/pilr01_3" },
  pilr02_1   = { "e2u2/pilr02_1" },
  pilr02_2   = { "e2u1/pilr02_2" },
  pilr03_1   = { "e2u1/pilr03_1" },
  pilr03_3   = { "e2u1/pilr03_3" },
  pip01_1    = { "e1u1/pip01_1" },
  pip01_2    = { "e1u1/pip01_2" },
  pip01_4    = { "e1u1/pip01_4" },
  pip02_1    = { "e1u1/pip02_1" },
  pip02_3    = { "e1u3/pip02_3" },
  pip02_4    = { "e1u3/pip02_4" },
  pip02_5    = { "e1u1/pip02_5" },
  pip02_6    = { "e1u1/pip02_6" },
  pip03_1    = { "e3u3/pip03_1" },
  pip03_4    = { "e1u1/pip03_4" },
  PIP04_3    = { "e1u1/PIP04_3" },
  PIP04_4    = { "e1u1/PIP04_4" },
  PIP04_5    = { "e1u1/PIP04_5" },
  PIP04_6    = { "e1u1/PIP04_6" },
  pip05_1    = { "e1u1/pip05_1" },
  pipe1_1    = { "e1u1/pipe1_1" },
  pipe1_2    = { "e1u1/pipe1_2" },
  pipe1_3    = { "e1u1/pipe1_3" },
  pipe1_4    = { "e1u1/pipe1_4" },
  pipe1_4    = { "e2u2/pipe1_4" },
  pipe1_5    = { "e1u1/pipe1_5" },
  pipe1_6    = { "e3u2/pipe1_6" },
  pipe3_2    = { "e2u3/pipe3_2" },
  pipes1_2   = { "e2u3/pipes1_2" },
  plate1_2   = { "e1u2/plate1_2" },
  plate1_3   = { "e1u2/plate1_3" },
  plate1_4   = { "e1u2/plate1_4" },
  plate1_6   = { "e1u2/plate1_6" },
  plate2_1   = { "e2u2/plate2_1" },
  plate2_5   = { "e2u2/plate2_5" },
  plate5_2   = { "e2u1/plate5_2" },
  p_lit_02   = { "e1u1/p_lit_02" },
  p_lit_03   = { "e1u1/p_lit_03" },
  plite1_1   = { "e1u1/plite1_1" },
  plite1_2   = { "e1u3/plite1_2" },
  plite1_3   = { "e1u1/plite1_3" },
  pow10_1    = { "e2u3/pow10_1" },
  pow1_1     = { "e2u3/pow1_1" },
  pow11_2    = { "e3u1/pow11_2" },
  pow1_2     = { "e2u3/pow1_2" },
  pow12_1    = { "e3u1/pow12_1" },
  pow15_1    = { "e2u3/pow15_1" },
  pow15_2    = { "e2u3/pow15_2" },
  pow17_1    = { "e2u3/pow17_1" },
  pow17_2    = { "e2u3/pow17_2" },
  pow18_1    = { "e2u3/pow18_1" },
  pow18_2    = { "e2u3/pow18_2" },
  pow2_1     = { "e2u3/pow2_1" },
  pow3_1     = { "e2u3/pow3_1" },
  pow3_2     = { "e1u3/pow3_2" },
  pow4_2     = { "e2u3/pow4_2" },
  pow5_1     = { "e2u3/pow5_1" },
  pow5_2     = { "e2u3/pow5_2" },
  pow6_2     = { "e2u3/pow6_2" },
  pow8_2     = { "e2u3/pow8_2" },
  powr21_1   = { "e2u3/powr21_1" },
  powr21_2   = { "e2u3/powr21_2" },
  prwlt1_2   = { "e2u3/prwlt1_2" },
  prwlt1_4   = { "e2u3/prwlt1_4" },
  prwlt2_2   = { "e2u3/prwlt2_2" },
  prwlt2_3   = { "e2u3/prwlt2_3" },
  p_swr1_7   = { "e1u1/p_swr1_7" },
  pthnm2_1   = { "e3u1/pthnm2_1" },
  p_tub1_1   = { "e1u1/p_tub1_1" },
  p_tub2_1   = { "e3u3/p_tub2_1" },
  p_tub2_3   = { "e1u1/p_tub2_3" },
  pwpip1_1   = { "e2u3/pwpip1_1" },
  pwpip1_2   = { "e2u3/pwpip1_2" },
  pwr_dr1_1  = { "e2u3/pwr_dr1_1" },
  pwr_dr1_2  = { "e2u3/pwr_dr1_2" },
  pyramid0   = { "e2u3/pyramid0" },
  pyramid1   = { "e2u3/pyramid1" },
  pyramid2   = { "e2u3/pyramid2" },
  pyramid3   = { "e2u3/pyramid3" },

  rcomp1_4   = { "e2u1/rcomp1_4" },
  red1_1     = { "e1u1/red1_1" },
  red1_2     = { "e1u1/red1_2" },
  red1_3     = { "e1u1/red1_3" },
  red1_3     = { "e3u1/red1_3" },
  red1_4     = { "e1u2/red1_4" },
  red1_6     = { "e2u2/red1_6" },
  redcar_2   = { "e3u1/redcar_2" },
  reddr2_1   = { "e3u1/reddr2_1" },
  reddr8_1   = { "e3u1/reddr8_1" },
  reddr8_2   = { "e3u1/reddr8_2" },
  redfield   = { "e1u1/redfield" },
  redkeypad  = { "e1u1/redkeypad" },
  redlt1_1   = { "e2u1/redlt1_1" },
  redlt1_3   = { "e2u1/redlt1_3" },
  redmt1_2   = { "e2u2/redmt1_2" },
  reds1_2    = { "e1u3/reds1_2" },
  refdr1_1   = { "e2u2/refdr1_1" },
  refdr3_1   = { "e1u3/refdr3_1" },
  refdr4_4   = { "e2u2/refdr4_4" },
  refdr9_2   = { "e2u2/refdr9_2" },
  refdr9_3   = { "e2u2/refdr9_3" },
  reflt1_1   = { "e2u2/reflt1_1" },
  reflt1_9   = { "e2u1/reflt1_9" },
  reflt3_10  = { "e2u1/reflt3_10" },
  reflt3_11  = { "e2u1/reflt3_11" },
  reflt3_2   = { "e2u1/reflt3_2" },
  reflt3_5   = { "e2u1/reflt3_5" },
  reflt3_8   = { "e2u3/reflt3_8" },
  reflt3_9   = { "e1u3/reflt3_9" },
  rflr2_1    = { "e2u2/rflr2_1" },
  rlight1_1  = { "e2u3/rlight1_1" },
  rlight1_2  = { "e2u3/rlight1_2" },
  rmetal10_1 = { "e2u3/rmetal10_1" },
  rmetal3_4  = { "e2u3/rmetal3_4" },
  rmetal4_1  = { "e2u3/rmetal4_1" },
  rmetal5_1  = { "e2u3/rmetal5_1" },
  rock0_1    = { "e2u1/rock0_1" },
  rock1_1    = { "e2u1/rock1_1" },
  rock2_1    = { "e2u3/rock2_1" },
  rock25_1   = { "e2u2/rock25_1" },
  rock6_4    = { "e2u1/rock6_4" },
  rocks14_2  = { "e1u3/rocks14_2" },
  rocks15_2  = { "e2u1/rocks15_2" },
  rocks16_1  = { "e1u3/rocks16_1" },
  rocks16_2  = { "e1u1/rocks16_2" },
  rocks17_2  = { "e2u3/rocks17_2" },
  rocks19_1  = { "e1u1/rocks19_1" },
  rocks21_1  = { "e2u1/rocks21_1" },
  rocks22_1  = { "e1u1/rocks22_1" },
  rocks23_2  = { "e2u1/rocks23_2" },
  rocks24_1  = { "e2u2/rocks24_1" },
  rocks24_2  = { "e2u1/rocks24_2" },
  rpip2_1    = { "e2u1/rpip2_1" },
  rpip2_2    = { "e1u1/rpip2_2" },
  rrock1_2   = { "e2u1/rrock1_2" },
  sewer1     = { "e1u1/sewer1" },
  sflr1_1    = { "e1u3/sflr1_1" },
  sflr1_2    = { "e1u3/sflr1_2" },
  sflr1_3    = { "e1u3/sflr1_3" },
  shiny1_6   = { "e1u3/shiny1_6" },
  shooter1   = { "e1u1/shooter1" },
  shooter2   = { "e1u1/shooter2" },
  shutl1_1   = { "e3u3/shutl1_1" },
  shutl21_1  = { "e3u3/shutl21_1" },
  shutl2_2   = { "e3u3/shutl2_2" },
  shutl22_2  = { "e3u3/shutl22_2" },
  shutl22_3  = { "e3u3/shutl22_3" },
  sign1      = { "e3u3/sign1" },
  sign1_1    = { "e1u1/sign1_1" },
  sign1_1    = { "e2u2/sign1_1" },
  sign1_2    = { "e1u1/sign1_2" },
  sign1_4    = { "e2u2/sign1_4" },
  sign2      = { "e3u3/sign2" },
  sign3_1    = { "e1u3/sign3_1" },
  sign3_2    = { "e1u3/sign3_2" },
  slots1_1   = { "e1u3/slots1_1" },
  slots1_2   = { "e1u3/slots1_2" },
  slots1_4   = { "e1u3/slots1_4" },
  slots1_5   = { "e1u3/slots1_5" },
  slots1_6   = { "e1u3/slots1_6" },
  slotwl2_1  = { "e1u3/slotwl2_1" },
  slotwl4_1  = { "e1u3/slotwl4_1" },
  slotwl4_2  = { "e1u3/slotwl4_2" },
  slotwl4_3  = { "e1u3/slotwl4_3" },
  slotwl4_4  = { "e1u3/slotwl4_4" },
  slotwl5_3  = { "e1u3/slotwl5_3" },
  slotwl5_5  = { "e1u3/slotwl5_5" },
  slotwl6_2  = { "e1u3/slotwl6_2" },
  sltfl2_1   = { "e1u3/sltfl2_1" },
  sltfl2_2   = { "e1u3/sltfl2_2" },
  sltfl2_6   = { "e1u3/sltfl2_6" },
  sltfr2_4   = { "e1u3/sltfr2_4" },
  smpow1     = { "e2u3/smpow1" },
  smpow2     = { "e2u3/smpow2" },
  smpow3     = { "e2u3/smpow3" },
  stairs1_1  = { "e1u1/stairs1_1" },
  stairs1_2  = { "e1u3/stairs1_2" },
  stairs1_3  = { "e1u3/stairs1_3" },
  station1   = { "e1u1/station1" },
  station5   = { "e1u1/station5" },
  stflr1_4   = { "e1u3/stflr1_4" },
  stflr1_5   = { "e1u3/stflr1_5" },
  stripe1_1  = { "e1u2/stripe1_1" },
  stripe1_2  = { "e1u2/stripe1_2" },
  subdr1_1   = { "e1u2/subdr1_1" },
  subdr2_1   = { "e1u2/subdr2_1" },
  subdr2_2   = { "e1u2/subdr2_2" },
  subdr3_1   = { "e1u2/subdr3_1" },
  subdr3_2   = { "e1u2/subdr3_2" },
  support1_1 = { "e1u1/support1_1" },
  support1_1 = { "e3u3/support1_1" },
  support1_2 = { "e3u1/support1_2" },
  support1_3 = { "e1u1/support1_3" },
  support1_8 = { "e1u2/support1_8" },
  sym6_2     = { "e1u2/sym6_2" },

  tcmet4_1   = { "e1u3/tcmet4_1" },
  tcmet4_2   = { "e1u3/tcmet4_2" },
  tcmet4_3   = { "e1u3/tcmet4_3" },
  tcmet4_4   = { "e1u3/tcmet4_4" },
  tcmet5_2   = { "e1u3/tcmet5_2" },
  tcmet5_4   = { "e1u3/tcmet5_4" },
  tcmt9_1    = { "e1u3/tcmt9_1" },
  tcmt9_2    = { "e1u3/tcmt9_2" },
  tcmt9_4    = { "e1u3/tcmt9_4" },
  tcmt9_7    = { "e1u3/tcmt9_7" },
  temp1_1    = { "e2u1/temp1_1" },
  temp1_2    = { "e2u3/temp1_2" },
  thinm1_1   = { "e2u1/thinm1_1" },
  thinm1_2   = { "e2u3/thinm1_2" },
  thinm1_3   = { "e2u3/thinm1_3" },
  thinm2_3   = { "e2u3/thinm2_3" },
  timpod     = { "e1u1/timpod" },
  timpod2    = { "e1u1/timpod2" },
  timpod3    = { "e1u1/timpod3" },
  timpod3_1  = { "e2u3/timpod3_1" },
  timpod3_2  = { "e2u3/timpod3_2" },
  timpod4    = { "e1u1/timpod4" },
  timpod5    = { "e1u1/timpod5" },
  timpod5_1  = { "e2u2/timpod5_1" },
  timpod6    = { "e1u1/timpod6" },
  timpod7    = { "e1u1/timpod7" },
  timpod8    = { "e1u1/timpod8" },
  timpod9    = { "e1u1/timpod9" },
  tlava1_3   = { "e2u3/tlava1_3" },
  tlight03   = { "e2u1/tlight03" },
  train1_1   = { "e1u2/train1_1" },
  train1_2   = { "e1u2/train1_2" },
  train1_3   = { "e1u2/train1_3" },
  train1_4   = { "e1u2/train1_4" },
  train1_5   = { "e1u2/train1_5" },
  train1_6   = { "e1u2/train1_6" },
  train1_7   = { "e1u2/train1_7" },
  train1_8   = { "e1u2/train1_8" },
  tram01_1   = { "e1u1/tram01_1" },
  tram01_2   = { "e1u1/tram01_2" },
  tram01_3   = { "e1u1/tram01_3" },
  tram01_4   = { "e1u1/tram01_4" },
  tram01_5   = { "e1u1/tram01_5" },
  tram01_6   = { "e1u1/tram01_6" },
  tram01_8   = { "e1u1/tram01_8" },
  tram02_1   = { "e1u1/tram02_1" },
  tram02_2   = { "e1u1/tram02_2" },
  tram02_3   = { "e1u1/tram02_3" },
  tram03_1   = { "e1u1/tram03_1" },
  tram03_2   = { "e1u1/tram03_2" },
  troof1_1   = { "e1u3/troof1_1" },
  troof1_1   = { "e3u2/troof1_1" },
  troof1_2   = { "e1u3/troof1_2" },
  troof1_3   = { "e1u3/troof1_3" },
  troof1_4   = { "e1u3/troof1_4" },
  troof1_6   = { "e1u3/troof1_6" },
  troof3_1   = { "e1u3/troof3_1" },
  troof3_2   = { "e1u3/troof3_2" },
  troof3_2   = { "e3u2/troof3_2" },
  troof4_1   = { "e1u3/troof4_1" },
  troof4_4   = { "e1u2/troof4_4" },
  troof4_7   = { "e1u2/troof4_7" },
  troof5_1   = { "e3u2/troof5_1" },
  troof5_3   = { "e1u3/troof5_3" },
  troof5_4   = { "e1u3/troof5_4" },
  tunl1_5    = { "e2u1/tunl1_5" },
  tunl1_7    = { "e2u1/tunl1_7" },
  tunl1_8    = { "e2u1/tunl1_8" },
  tunl2_1    = { "e2u1/tunl2_1" },
  tunl2_3    = { "e2u1/tunl2_3" },
  tunl3_1    = { "e2u1/tunl3_1" },
  tunl3_2    = { "e2u1/tunl3_2" },
  tunl3_3    = { "e2u1/tunl3_3" },
  tunl3_4    = { "e2u1/tunl3_4" },
  tunl3_5    = { "e2u1/tunl3_5" },
  tunl3_6    = { "e2u1/tunl3_6" },
  turret2_1  = { "e1u3/turret2_1" },
  turret3_1  = { "e1u3/turret3_1" },
  turret5_1  = { "e1u3/turret5_1" },
  turret6_1  = { "e1u3/turret6_1" },
  turret7_1  = { "e1u3/turret7_1" },
  turret8_1  = { "e1u3/turret8_1" },
  turret9_1  = { "e1u3/turret9_1" },
  twall5_1   = { "e2u1/twall5_1" },
  twr01_1    = { "e2u1/twr01_1" },
  twr03_1    = { "e2u1/twr03_1" },

  wastemap   = { "e2u3/wastemap" },
  water1_8   = { "e1u1/water1_8" },
  water4     = { "e1u1/water4" },
  water7     = { "e3u3/water7" },
  water8     = { "e1u1/water8" },
  watrt1_1   = { "e1u1/watrt1_1" },
  watrt1_2   = { "e1u1/watrt1_2" },
  watrt2_1   = { "e1u1/watrt2_1" },
  watrt2_2   = { "e1u1/watrt2_2" },
  watrt3_1   = { "e3u3/watrt3_1" },
  watrt3_2   = { "e1u1/watrt3_2" },
  watrt4_1   = { "e2u1/watrt4_1" },
  wbasic1_1  = { "e1u1/wbasic1_1" },
  wbasic1_4  = { "e1u1/wbasic1_4" },
  wbasic1_7  = { "e1u1/wbasic1_7" },
  wgrate1_1  = { "e1u1/wgrate1_1" },
  wgrate1_2  = { "e1u1/wgrate1_2" },
  wgrate1_3  = { "e1u1/wgrate1_3" },
  wgrate1_4  = { "e1u1/wgrate1_4" },
  wgrate1_5  = { "e1u1/wgrate1_5" },
  wgrate1_6  = { "e1u1/wgrate1_6" },
  wgrate1_7  = { "e1u1/wgrate1_7" },
  wgrate1_8  = { "e1u1/wgrate1_8" },
  wincomp3_5 = { "e1u1/wincomp3_5" },
  wincomp3_7 = { "e1u1/wincomp3_7" },
  window4_1  = { "e3u1/window4_1" },
  window4_2  = { "e1u2/window4_2" },
  window5_1  = { "e2u3/window5_1" },
  window6_1  = { "e3u2/window6_1" },
  wire1_3    = { "e1u3/wire1_3" },
  wires2_1   = { "e1u3/wires2_1" },
  wires2_2   = { "e1u3/wires2_2" },
  wmetl2_4   = { "e2u1/wmetl2_4" },
  wmtal3_4   = { "e1u3/wmtal3_4" },
  wmtal3_5   = { "e1u1/wmtal3_5" },
  wmtal4_4   = { "e1u3/wmtal4_4" },
  wndow0_1   = { "e1u1/wndow0_1" },
  wndow0_3   = { "e1u1/wndow0_3" },
  wndow1_1   = { "e2u2/wndow1_1" },
  wndow1_2   = { "e1u2/wndow1_2" },
  wndow1_8   = { "e2u2/wndow1_8" },
  wndw01_2   = { "e3u1/wndw01_2" },
  wndw01_3   = { "e3u1/wndw01_3" },
  wndw01_4   = { "e3u1/wndw01_4" },
  wndw01_5   = { "e3u1/wndw01_5" },
  wplat1_1   = { "e1u3/wplat1_1" },
  wplat1_2   = { "e1u1/wplat1_2" },
  wplat1_3   = { "e2u1/wplat1_3" },
  wslt1_1    = { "e1u1/wslt1_1" },
  wslt1_2    = { "e1u1/wslt1_2" },
  wslt1_3    = { "e1u1/wslt1_3" },
  wslt1_4    = { "e1u1/wslt1_4" },
  wslt1_5    = { "e1u1/wslt1_5" },
  wslt1_6    = { "e1u1/wslt1_6" },
  wstfl2_5   = { "e1u3/wstfl2_5" },
  wstfl2_6   = { "e1u3/wstfl2_6" },
  wstlt1_1   = { "e2u3/wstlt1_1" },
  wstlt1_2   = { "e2u3/wstlt1_2" },
  wstlt1_3   = { "e2u3/wstlt1_3" },
  wstlt1_5   = { "e2u3/wstlt1_5" },
  wstlt1_8   = { "e2u3/wstlt1_8" },
  wsupprt1_14 = { "e1u1/wsupprt1_14" },
  wsupprt1_3 = { "e1u1/wsupprt1_3" },
  wsupprt1_5 = { "e1u1/wsupprt1_5" },
  wsupprt1_6 = { "e1u1/wsupprt1_6" },
  wswall1_1  = { "e1u1/wswall1_1" },
  wswall1_2  = { "e1u1/wswall1_2" },
  wtroof1_5  = { "e1u1/wtroof1_5" },
  wtroof4_2  = { "e1u1/wtroof4_2" },
  wtroof4_3  = { "e1u1/wtroof4_3" },
  wtroof4_5  = { "e1u1/wtroof4_5" },
  wtroof4_6  = { "e1u1/wtroof4_6" },
  wtroof4_8  = { "e1u1/wtroof4_8" },
  w_white    = { "e2u1/w_white" },
  yellow1_2  = { "e1u1/yellow1_2" },
  yellow1_4  = { "e1u1/yellow1_4" },
  yellow1_6  = { "e1u1/yellow1_6" },

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

---- e1u1/trigger
---- e1u1/clip
---- e1u1/hint
---- e1u1/origin
---- e1u1/skip
}


----------------------------------------------------------------

QUAKE2_COMBOS =
{
  TECH_BASE =
  {
    wall  = "e1u1/wslt1_1",
    floor = "e1u1/wtroof4_3",
    ceil  = "e1u1/floor3_3",
  },

  TECH_GROUND =
  {
    outdoor = true,

    wall  = "e1u1/rocks16_2",
    ceil  = "e1u1/grass1_4",
    floor = "e1u1/grass1_4",
  },
}

QUAKE2_EXITS =
{
}


QUAKE2_KEY_DOORS =
{
  k_silver = { door_kind="door_silver", door_side=14 },
  k_gold   = { door_kind="door_gold",   door_side=14 },
}

QUAKE2_MISC_PREFABS =
{
}



---- QUEST STUFF ----------------

QUAKE2_QUESTS =
{
  key = { k_red=60, k_blue=30, },

  switch = { },

  weapon = { machine_gun=50, gatling_gun=20, },

  item =
  {
    crown = 50, chest = 50, cross = 50, chalice = 50,
    one_up = 2,
  },

  exit =
  {
    elevator=50
  }
}


QUAKE2_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    scenery = { ceil_light=90 },

    space_range = { 10, 50 },
  },

  STORAGE =
  {
    scenery = { barrel=50, green_barrel=80, }
  },

  TREASURE =
  {
    pickups = { cross=90, chalice=90, chest=20, crown=5 },
    pickup_rate = 90,
  },

  SUPPLIES =
  {
    scenery = { barrel=70, bed=40, },

    pickups = { first_aid=50, good_food=90, clip_8=70 },
    pickup_rate = 66,
  },

  QUARTERS =
  {
    scenery = { table_chairs=70, bed=70, chandelier=70,
                bare_table=20, puddle=20,
                floor_lamp=10, urn=10, plant=10
              },
  },

  BATHROOM =
  {
    scenery = { sink=50, puddle=90, water_well=30, empty_well=30 },
  },

  KITCHEN =
  {
    scenery = { kitchen_stuff=50, stove=50, pots=50,
                puddle=20, bare_table=20, table_chairs=5,
                sink=10, barrel=10, green_barrel=5, plant=2
              },

    pickups = { good_food=15, dog_food=5 },
    pickup_rate = 20,
  },

  TORTURE =
  {
    scenery = { hanging_cage=80, skeleton_in_cage=80,
                skeleton_relax=30, skeleton_flat=40,
                hanged_man=60, spears=10, bare_table=10,
                gibs_1=10, gibs_2=10,
                junk_1=10, junk_2=10,junk_3=10
              },
  },
}

QUAKE2_THEMES =
{
  TECH =
  {
    building =
    {
      TECH_BASE=50,
    },

    ground =
    {
      TECH_GROUND=50,
    },

    hallway =
    {
      -- FIXME
    },

    exit =
    {
      -- FIXME
    },

    scenery =
    {
      -- FIXME
    },
  }, -- TECH
}


----------------------------------------------------------------

QUAKE2_MONSTERS =
{
  guard =
  {
    prob=20, guard_prob=3, trap_prob=3, cage_prob=3,
    health=20, damage=4, attack="missile",
  },

  guard_sg =
  {
    prob=70, guard_prob=11, trap_prob=11, cage_prob=11,
    health=30, damage=10, attack="hitscan",
  },

  guard_mg =
  {
    prob=70, guard_prob=11, trap_prob=11, cage_prob=11,
    health=30, damage=10, attack="hitscan",
  },

  enforcer =
  {
    prob=50, guard_prob=11, trap_prob=11, cage_prob=11,
    health=100, damage=10, attack="hitscan",
  },

  flyer =
  {
    prob=90, guard_prob=11, trap_prob=11,
    health=50, damage=5, attack="missile",
    float=true,
  },

  shark =
  {
    health=50, damage=5, attack="melee",
  },

  parasite =
  {
    prob=10, guard_prob=11, trap_prob=21,
    health=175, damage=10, attack="missile",
  },

  maiden =
  {
    prob=50, guard_prob=21, trap_prob=21, cage_prob=11,
    health=175, damage=30, attack="missile",
  },

  technician =
  {
    prob=50, guard_prob=11, trap_prob=11,
    health=200, damage=8, attack="missile",
    float=true,
  },

  beserker =
  {
    prob=50, guard_prob=11, trap_prob=11, cage_prob=11,
    health=240, damage=18, attack="melee",
  },

  icarus =
  {
    prob=70, guard_prob=11, trap_prob=21,
    health=240, damage=5, attack="missile",
    float=true,
  },

  medic =
  {
    prob=30, guard_prob=11, trap_prob=11, cage_prob=11,
    health=300, damage=21, attack="missile",
  },

  mutant =
  {
    prob=30, guard_prob=11, trap_prob=11, cage_prob=11,
    health=300, damage=24, attack="melee",
  },

  brain =
  {
    prob=20, guard_prob=11, trap_prob=31,
    health=300, damage=17, attack="melee",
  },

  grenader =
  {
    prob=10, guard_prob=11, trap_prob=11, cage_prob=11,
    health=400, damage=30, attack="missile",
  },

  gladiator =
  {
    prob=10, guard_prob=11, trap_prob=11, cage_prob=11,
    health=400, damage=40, attack="missile",
  },

  tank =
  {
    prob=2,
    health=750, damage=160, attack="missile",
  },

  tank_cmdr =
  {
    health=1000, damage=160, attack="missile",
  },

  ---| BOSSES |---

  -- FIXME: damage values and attack kinds?

  Super_tank =
  {
    health=1500, damage=200,
  },

  Huge_flyer =
  {
    health=2000, damage=200,
    -- FIXME: immune to laser (??)
  },

  Jorg =
  {
    health=3000, damage=200,
  },

  Makron =
  {
    health=3000, damage=200,
  },

  -- NOTES:
  --
  -- Dropped items are not endemic to types of monsters, but can
  -- be specified for each monster entity with the "item" keyword.
  -- This could be used for lots of cool stuff (e.g. kill a boss
  -- monster to get a needed key) -- another TODO feature.
}


QUAKE2_WEAPONS =
{
  blaster =
  {
    rate=1.7, damage=10, attack="missile",
  },

  shotty =
  {
    pref=20, add_prob=10, start_prob=40,
    rate=0.6, damage=40, attack="hitscan",
    ammo="shell",  per=1,
    give={ {ammo="shell",count=10} },
  },

  ssg =
  {
    pref=70, add_prob=50, start_prob=10,
    rate=0.8, damage=88, attack="hitscan", splash={0,8},
    ammo="shell", per=2,
    give={ {ammo="shell",count=10} },
  },

  machine =
  {
    pref=20, add_prob=30, start_prob=30,
    rate=6.0, damage=8, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",count=50} },
  },

  chain =
  {
    pref=90, add_prob=15, start_prob=5,
    rate=14, damage=8, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",count=50} },
  },

  grenade =
  {
    pref=15, add_prob=25, start_prob=15,
    rate=0.7, damage=5, attack="missile", splash={60,15,3},
    ammo="grenade", per=1,
    give={ {ammo="grenade",count=5} },
  },

  launcher =
  {
    pref=30, add_prob=20, start_prob=3,
    rate=1.1, damage=90, attack="missile", splash={0,20,6,2},
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=5} },
  },

  rail =
  {
    pref=50, add_prob=10,
    rate=0.6, damage=140, attack="hitscan",
    ammo="slug", per=1, splash={0,25,5},
    give={ {ammo="slug",count=10} },
  },

  hyper =
  {
    pref=60, add_prob=20,
    rate=5.0, damage=20, attack="missile",
    ammo="cell", per=1,
    give={ {ammo="cell",count=50} },
  },

  bfg =
  {
    pref=20, add_prob=15,
    rate=0.3, damage=200, attack="missile", splash={0,50,40,30,20,10,10},
    ammo="cell", per=50,
    give={ {ammo="cell",count=50} },
  },


  -- Notes:
  --
  -- The BFG can damage lots of 'in view' monsters at once.
  -- This is modelled with a splash damage table.
  --
  -- Railgun can pass through multiple enemies.  We assume
  -- the player doesn't manage to do it very often :-).
  --
  -- Grenades don't do any direct damage when they hit a
  -- monster, it's all in the splash baby.
}


QUAKE2_PICKUPS =
{
  -- HEALTH --

  heal_2 =
  {
    prob=10, cluster={ 3,9 },
    give={ {health=2} },
  },

  heal_10 =
  {
    prob=20,
    give={ {health=10} },
  },

  heal_25 =
  {
    prob=50,
    give={ {health=25} },
  },

  heal_100 =
  {
    prob=5,
    give={ {health=70} },
  },

  -- ARMOR --

  armor_2 =
  {
    prob=7, cluster={ 3,9 },
    give={ {health=1} },
  },

  armor_25 =  -- (jacket)
  {
    prob=7,
    give={ {health=8} },
  },

  armor_50 =  -- (combat)
  {
    prob=15,
    give={ {health=25} },
  },

  armor_100 =  -- (body)
  {
    prob=15,
    give={ {health=80} },
  },

  -- AMMO --

  am_bullet =
  {
    give={ {ammo="bullet",count=50} },
  },

  am_shell =
  {
    give={ {ammo="shell",count=10} },
  },

  am_grenade =
  {
    give={ {ammo="grenade",count=5} },
  },

  am_rocket =
  {
    give={ {ammo="rocket",count=5} },
  },

  am_slug = 
  {
    give={ {ammo="slug",count=10} },
  },

  am_cell =
  {
    give={ {ammo="cell",count=50} },
  },

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


QUAKE2_PLAYER_MODEL =
{
  quakeguy =
  {
    stats   = { health=0, bullet=0, shell=0, grenade=0, rocket=0, slug=0, cell=0 },
    weapons = { blaster=1 },
  }
}


------------------------------------------------------------

QUAKE2_EPISODE_THEMES =
{
  { BASE=7, },
  { BASE=6, },
  { BASE=6, },
  { BASE=6, },
}

QUAKE2_KEY_NUM_PROBS =
{
  small   = { 90, 50, 20 },
  regular = { 40, 90, 40 },
  large   = { 20, 50, 90 },
}


------------------------------------------------------------

OB_THEMES["q2_base"] =
{
  label = "Base",
  for_games = { quake2=1 },
}


----------------------------------------------------------------

function Quake2_get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "full", 4, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 7)

  if OB_CONFIG.length == "few" then MAP_NUM = 3 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name = string.format("u%dm%d", episode, map),

        ep_along = map / MAP_NUM,

        theme_ref = "BASE",
      }

      table.insert(GAME.all_levels, LEV)
    end -- for map

  end -- for episode
end

function Quake2_describe_levels()

  -- FIXME handle themes properly !!!

  local desc_list = Naming_generate("TECH", #GAME.all_levels, PARAM.max_level_desc)

  for index,LEV in ipairs(GAME.all_levels) do
    LEV.description = desc_list[index]
  end
end


function Quake2_setup()

  GAME.player_model = QUAKE2_PLAYER_MODEL

  GAME.dm = {}

  Game_merge_tab("things",   QUAKE2_THINGS)
  Game_merge_tab("monsters", QUAKE2_MONSTERS)
  Game_merge_tab("weapons",  QUAKE2_WEAPONS)
  Game_merge_tab("pickups",  QUAKE2_PICKUPS)

  Game_merge_tab("quests",  QUAKE2_QUESTS)

  Game_merge_tab("combos", QUAKE2_COMBOS)
  Game_merge_tab("exits",  QUAKE2_EXITS)

  Game_merge_tab("key_doors", QUAKE2_KEY_DOORS)

  Game_merge_tab("rooms",  QUAKE2_ROOMS)
  Game_merge_tab("themes", QUAKE2_THEMES)

  Game_merge_tab("misc_fabs", QUAKE2_MISC_PREFABS)

end


UNFINISHED["quake2"] =
{
  label = "Quake 2",

  format = "quake2",

  setup_func = Quake2_setup,

  levels_start_func = Quake2_get_levels,

  param =
  {
    -- TODO

    -- dunno if needed by Quake II, but it doesn't hurt
    center_map = true,

    seed_size = 240,

    sky_tex  = "e1u1/sky1",
    sky_flat = "e1u1/sky1",

    -- the name buffer in Quake II is huge, but this value
    -- reflects the on-screen space (in the computer panel)
    max_level_desc = 24,

    palette_mons = 4,
  },

  hooks =
  {
    describe_levels = Quake1_describe_levels,
  },
}

