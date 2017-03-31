ENT_MAP = 
{
  ["func_button"]                = "func_button",
  ["func_door"]                  = "func_door",
  ["func_door_secret"]           = "func_door",
  ["info_intermission"]          = "info_intermission",
  ["info_player_deathmatch"]     = "info_player_deathmatch",
  ["info_player_start"]          = "info_player_start",
  ["info_teleport_destination"]  = "misc_teleporter_dest",
  ["item_armor1"]                = "item_armor1",
  ["item_armor2"]                = "item_armor2",
  ["item_health"]                = "item_health",
  ["item_rockets"]               = "item_rockets",
  ["item_shells"]                = "item_shells",
  ["item_spikes"]                = "item_spikes",
  ["light_flame_large_yellow"]   = "light"
  ["light"]                      = "light",
  ["light_torch_small_walltorch"] = "light",
  ["trigger_changelevel"]        = "trigger_changelevel",
  ["trigger_teleport"]           = "trigger_teleport",
  ["weapon_grenadelauncher"]     = "weapon_grenadelauncher",
  ["weapon_nailgun"]             = "weapon_nailgun",
  ["weapon_supershotgun"]        = "weapon_supershotgun",
}

TEX_MAP = 
{
  ["XX"]                         = "base_trim/dark_tin2",
  ["+0BUTTON"]                   = "e7/e7panelwood",
  ["+0FLOORSW"]                  = "e7/e7panelwood",
  ["BODIESA2_1"]                 = "base_trim/dark_tin2",
  ["BODIESA2_4"]                 = "base_trim/dark_tin2",
  ["BODIESA3_1"]                 = "base_trim/dark_tin2",
  ["BODIESA3_2"]                 = "base_trim/dark_tin2",
  ["BODIESA3_3"]                 = "base_trim/dark_tin2",
  ["BRICKA2_4"]                  = "base_wall/concrete1",  -- redmet
  ["BRICKA2_6"]                  = "base_wall/concrete1",  -- redmet
  ["CITY4_7"]                    = "gothic_block/killblock",
  ["COP1_5"]                     = "gothic_block/killblock",
  ["COP1_6"]                     = "gothic_block/killblock",
  ["COP1_7"]                     = "gothic_block/killblock",
  ["COP2_5"]                     = "gothic_block/killblock",
  ["COP3_4"]                     = "gothic_block/killblock",
  ["DOOR05_3"]                   = "e7/e7panelwood",
  ["DUNG01_1"]                   = "base_trim/deeprust",
  ["DUNG01_2"]                   = "base_trim/deeprust",
  ["DUNG01_3"]                   = "base_trim/deeprust",
  ["DUNG01_4"]                   = "base_trim/deeprust",
  ["DUNG01_5"]                   = "base_trim/deeprust",
  ["DUNG02_1"]                   = "base_trim/deeprust",
  ["DUNG02_5"]                   = "base_trim/deeprust",
  ["*LAVA1"]                     = "liquids/slime1",
  ["METAL1_3"]                   = "gothic_trim/metalsupport4b.jpg",
  ["METAL2_2"]                   = "gothic_trim/metalsupport4b.jpg",
  ["ROOF"]                       = "gothic_trim/metalsupport4b.jpg",
  ["ROOF2"]                      = "gothic_trim/metalsupport4b.jpg",
  ["*TELEPORT"]                  = "liquids/softwater",
  ["TRIGGER"]                    = "TRIGGER",
}

all_entities =
{
  {
    id = ENT_MAP["info_intermission"]
    x = 432
    y = 896
    z = 120
  }
  {
    id = ENT_MAP["info_intermission"]
    angle = 180
    x = 296
    y = 1152
    z = 200
  }
  {
    id = ENT_MAP["trigger_changelevel"]
    map = "dm2"
    link_id = "m1"
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    light = 200
    x = -30
    y = 1466
    z = -92
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 384
    y = 1624
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 432
    y = 1624
    z = -144
  }
  {
    id = ENT_MAP["item_spikes"]
    x = 472
    y = 1464
    z = -144
  }
  {
    id = ENT_MAP["item_spikes"]
    x = 472
    y = 1408
    z = -144
  }
  {
    id = ENT_MAP["weapon_nailgun"]
    x = -560
    y = 1384
    z = 0
  }
  {
    id = ENT_MAP["item_shells"]
    spawnflags = 1
    x = -536
    y = 1000
    z = 0
  }
  {
    id = ENT_MAP["weapon_grenadelauncher"]
    angle = 180
    x = -312
    y = 1088
    z = 48
  }
  {
    id = ENT_MAP["weapon_nailgun"]
    x = 1088
    y = 704
    z = 48
  }
  {
    id = ENT_MAP["item_armor2"]
    x = -392
    y = 1416
    z = 0
  }
  {
    id = ENT_MAP["item_armor1"]
    x = -400
    y = 1112
    z = -144
  }
  {
    id = ENT_MAP["light"]
    x = -368
    y = 1592
    z = 88
    light = 200
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = -694
    y = 1658
    z = 60
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    x = -120
    y = 1496
    z = -48
    light = 100
  }
  {
    id = ENT_MAP["light"]
    color = "#ff0000"
    light = 1.50
    x = -264
    y = 1424
    z = -120
  }
  {
    id = ENT_MAP["light"]
    x = -272
    y = 1592
    z = -120
    light = 250
  }
  {
    id = ENT_MAP["light"]
    x = 482
    y = 658
    z = 16
    light = 150
  }
  {
    id = ENT_MAP["weapon_supershotgun"]
    x = 48
    y = 1152
    z = 0
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = -494
    y = 1398
    z = 60
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 180
    x = 280
    y = 1416
    z = -120
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 225
    x = 1128
    y = 1424
    z = 72
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 90
    x = 104
    y = 1392
    z = 24
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 180
    x = -432
    y = 1596
    z = 24
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 90
    x = -656
    y = 976
    z = 24
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 0
    x = -560
    y = 768
    z = 24
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 0
    x = 576
    y = 752
    z = 24
  }
  {
    id = ENT_MAP["item_shells"]
    x = 304
    y = 1016
    z = 0
  }
  {
    id = ENT_MAP["item_health"]
    x = 200
    y = 1272
    z = 0
  }
  {
    id = ENT_MAP["item_health"]
    x = 152
    y = 1272
    z = 0
  }
  {
    id = ENT_MAP["item_health"]
    x = -672
    y = 1372
    z = 0
  }
  {
    id = ENT_MAP["item_health"]
    x = -672
    y = 1412
    z = 0
  }
  {
    id = ENT_MAP["item_spikes"]
    x = -224
    y = 748
    z = 0
  }
  {
    id = ENT_MAP["item_health"]
    x = 904
    y = 1032
    z = 0
  }
  {
    id = ENT_MAP["item_health"]
    x = 904
    y = 1096
    z = 0
  }
  {
    id = ENT_MAP["item_shells"]
    x = 632
    y = 856
    z = 0
  }
  {
    id = ENT_MAP["item_rockets"]
    spawnflags = 1
    x = 584
    y = 856
    z = 0
  }
  {
    id = ENT_MAP["item_shells"]
    x = -116
    y = 1160
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    x = -248
    y = 692
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    x = -300
    y = 692
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 2
    x = 440
    y = 808
    z = 0
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    x = -16
    y = 1608
    z = -24
    light = 100
  }
  {
    id = ENT_MAP["func_button"]
    lip = 4
    target = "t3"
    angle = "-2"
    link_id = "m2"
    wait = 10
  }
  {
    id = ENT_MAP["func_door"]
    spawnflags = 1
    angle = 180
    sounds = 4
    speed = 175
    targetname = "t3"
    link_id = "m3"
    wait = 8
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = -658
    y = 934
    z = 60
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = -518
    y = 1058
    z = 52
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    x = 372
    y = 1328
    z = -68
    light = 50
  }
  {
    id = ENT_MAP["light"]
    x = 488
    y = 720
    z = -68
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 0
    y = 756
    z = -68
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = -348
    y = 768
    z = -68
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = -348
    y = 1076
    z = -68
    light = 250
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 314
    y = 1410
    z = -92
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = -114
    y = 1298
    z = -92
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 502
    y = 1654
    z = -92
  }
  {
    id = ENT_MAP["light"]
    x = 452
    y = 928
    z = -116
    light = 225
  }
  {
    id = ENT_MAP["light"]
    x = 180
    y = 932
    z = -116
    light = 225
  }
  {
    id = ENT_MAP["light"]
    x = 48
    y = 976
    z = -116
    light = 175
  }
  {
    id = ENT_MAP["light"]
    x = -96
    y = 940
    z = -116
    light = 225
  }
  {
    id = ENT_MAP["light"]
    x = 488
    y = 1248
    z = -92
    light = 200
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 274
    y = 1338
    z = -92
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = -126
    y = 990
    z = -92
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 114
    y = 990
    z = -92
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 386
    y = 990
    z = -92
  }
  {
    id = ENT_MAP["light"]
    x = -304
    y = 1056
    z = 208
  }
  {
    id = ENT_MAP["light"]
    x = -304
    y = 816
    z = 208
  }
  {
    id = ENT_MAP["light"]
    x = 0
    y = 808
    z = 208
  }
  {
    id = ENT_MAP["light"]
    x = 280
    y = 808
    z = 208
  }
  {
    id = ENT_MAP["light"]
    x = 424
    y = 816
    z = 88
    light = 200
  }
  {
    id = ENT_MAP["light_flame_large_yellow"]
    color = "#ffdd11"
    x = 494
    y = 814
    z = 188+16
    light = 300
  }
  {
    id = ENT_MAP["light"]
    x = 880
    y = 728
    z = 128
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = 304
    y = 1128
    z = 128
  }
  {
    id = ENT_MAP["light"]
    x = 224
    y = 992
    z = 128
    light = 250
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 138
    y = 542
    z = 60
    light = 225
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 274
    y = 542
    z = 60
    light = 225
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 410
    y = 542
    z = 60
    light = 225
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 610
    y = 542
    z = 60
    light = 250
  }
  {
    id = ENT_MAP["light"]
    x = 896
    y = 1232
    z = 72
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 560
    y = 896
    z = 112
    light = 250
  }
  {
    id = ENT_MAP["light"]
    x = 856
    y = 928
    z = 112
  }
  {
    id = ENT_MAP["light"]
    x = 640
    y = 856
    z = 112
    light = 250
  }
  {
    id = ENT_MAP["light"]
    x = 560
    y = 1056
    z = 112
    light = 250
  }
  {
    id = ENT_MAP["light"]
    x = 560
    y = 1208
    z = 112
    light = 250
  }
  {
    id = ENT_MAP["light"]
    x = 748
    y = 1056
    z = 260
  }
  {
    id = ENT_MAP["light"]
    x = 748
    y = 1284
    z = 260
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 1146
    y = 682
    z = 108
  }
  {
    id = ENT_MAP["light"]
    x = 1016
    y = 1012
    z = 136
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = 1000
    y = 1320
    z = 116
    light = 200
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 750
    y = 1442
    z = 60
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 606
    y = 794
    z = 60
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 1146
    y = 1054
    z = 108
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    color = "#55aaff"
    x = 1146
    y = 1322
    z = 108
  }
  {
    id = ENT_MAP["light_flame_large_yellow"]
    color = "#ffdd11"
    light = 300
    x = 238
    y = 1378
    z = 220+16
  }
  {
    id = ENT_MAP["light_flame_large_yellow"]
    color = "#ffdd11"
    light = 300
    x = -178
    y = 1374
    z = 220+16
  }
  {
    id = ENT_MAP["light_flame_large_yellow"]
    color = "#ffdd11"
    light = 300
    x = -178
    y = 1646
    z = 220+16
  }
  {
    id = ENT_MAP["light_flame_large_yellow"]
    color = "#ffdd11"
    light = 300
    x = 238
    y = 1646
    z = 220+16
  }
  {
    id = ENT_MAP["light_flame_large_yellow"]
    color = "#ffdd11"
    light = 300
    x = 494
    y = 1070
    z = 220+16
--  light = 200
  }
  {
    id = ENT_MAP["light_flame_large_yellow"]
    color = "#ffdd11"
    light = 300
    x = 494
    y = 1198
    z = 220+16
--  light = 200
  }
  {
    id = ENT_MAP["light_flame_large_yellow"]
    color = "#ffdd11"
    light = 300
    x = 494
    y = 1326
    z = 220+16
--  light = 200
  }
  {
    id = ENT_MAP["light_flame_large_yellow"]
    color = "#ffdd11"
    light = 300
    x = 494
    y = 1454
    z = 220+16
--  light = 200
  }
  {
    id = ENT_MAP["light_flame_large_yellow"]
    color = "#ffdd11"
    light = 300
    x = 494
    y = 1582
    z = 220+16
--  light = 200
  }
  {
    id = ENT_MAP["func_button"]
    target = "t2"
    link_id = "m4"
  }
  {
    id = ENT_MAP["func_door_secret"]
    angle = 180
    link_id = "m5"
  }
  {
    id = ENT_MAP["light"]
    x = -320
    y = 1216
    z = 136
  }
  {
    id = ENT_MAP["trigger_teleport"]
    target = "t1"
    link_id = "m6"
  }
  {
    id = ENT_MAP["info_teleport_destination"]
    x = 448
    y = 1028
    z = 16
    targetname = "t1"
    angle = 90
    light = 250
  }
  {
    id = ENT_MAP["light"]
    x = -520
    y = 736
    z = 136
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    x = -416
    y = 1420
    z = 84
    light = 100
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    x = -128
    y = 1432
    z = 136
    light = 100
  }
  {
    id = ENT_MAP["func_door"]
    sounds = 4
    targetname = "t2"
    link_id = "m7"
    angle = "-2"
  }
  {
    id = ENT_MAP["func_door"]
    angle = "-2"
    targetname = "t2"
    link_id = "m8"
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    light = 100
    style = 2
    x = 224
    y = 1600
    z = -80
  }
  {
    id = ENT_MAP["light"]
    color = "#ff0000"
    light = 1.00
    x = -224
    y = 1496
    z = -72
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    angle = 0
    light = 100
    x = 132
    y = 1500
    z = 224
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    angle = 0
    light = 100
    x = 0
    y = 1504
    z = 224
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    angle = 0
    light = 100
    x = 196
    y = 1404
    z = 88
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    angle = 0
    light = 100
    x = 36
    y = 1396
    z = 88
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    angle = 0
    light = 100
    x = -108
    y = 1548
    z = 88
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    angle = 0
    light = 100
    x = 92
    y = 1556
    z = 88
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    angle = 0
    light = 100
    x = 292
    y = 1556
    z = 88
  }
  {
    id = ENT_MAP["light"]
    color = "#11ff11"
    angle = 0
    light = 130
    x = 448
    y = 1528
    z = 88
  }
  {
    id = ENT_MAP["light"]
    angle = 0
    light = 250
    x = 444
    y = 1348
    z = 84
  }
  {
    id = ENT_MAP["info_player_start"]
    angle = 180
    x = 324
    y = 1156
    z = 24
  }
  {
    id = ENT_MAP["light"]
    angle = 0
    x = -48
    y = 1060
    z = 120
    light = 150
  }
  {
    id = ENT_MAP["light"]
    angle = 0
    x = -56
    y = 1252
    z = 120
    light = 150
  }
  {
    id = ENT_MAP["light"]
    angle = 0
    x = 72
    y = 1152
    z = 112
    light = 200
  }
  {
    id = ENT_MAP["light"]
    angle = 0
    x = 4
    y = 1148
    z = 296
    light = 200
  }
  {
    id = ENT_MAP["light"]
    angle = 0
    x = 132
    y = 1156
    z = 296
    light = 200
  }
  {
    id = ENT_MAP["light"]
    angle = 0
    x = 36
    y = 996
    z = 128
    light = 200
  }
  {
    id = ENT_MAP["light"]
    angle = 0
    x = 28
    y = 1308
    z = 128
    light = 200
  }
  {
    id = ENT_MAP["light"]
    angle = 0
    x = 220
    y = 1308
    z = 128
    light = 200
  }
}

all_brushes =
{
  {
    { m="solid", }
    { x=-336.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { x=-336.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-448.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { x=-448.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=-440.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=-440.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-448.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1368.000, tex=TEX_MAP["METAL1_3"], }
    { x=-448.000, y=1368.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-448.000, y=1464.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1464.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { x=-448.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-352.000, y=1544.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1544.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1640.000, tex=TEX_MAP["METAL1_3"], }
    { x=-352.000, y=1640.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=374.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=382.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=382.000, y=692.000, tex=TEX_MAP["METAL1_3"], }
    { x=374.000, y=692.000, tex=TEX_MAP["METAL1_3"], }
    { t=96.000, tex=TEX_MAP["METAL1_3"], }
    { b=60.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=380.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=692.000, tex=TEX_MAP["METAL1_3"], }
    { x=380.000, y=692.000, tex=TEX_MAP["METAL1_3"], }
    { t=96.000, tex=TEX_MAP["METAL1_3"], }
    { b=88.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-336.000, y=1560.000, tex=TEX_MAP["CITY4_7"], }
    { x=-328.000, y=1560.000, tex=TEX_MAP["CITY4_7"], }
    { x=-328.000, y=1624.000, tex=TEX_MAP["CITY4_7"], }
    { x=-336.000, y=1624.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-144.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-328.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1648.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1648.000, tex=TEX_MAP["METAL1_3"], }
    { t=0.000, tex=TEX_MAP["METAL1_3"], }
    { b=-8.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-488.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-448.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-448.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-488.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-328.000, y=1648.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1648.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-328.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
--    @@@@ FIX BRUSH @ line:95 @@@@
--    @@@@ FIX BRUSH @ line:102 @@@@
  {
    { m="solid", xxdetail=3, }
    { x=-304.000, y=1640.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1640.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1568.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1568.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], }
    { b=120.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-328.000, y=1616.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1616.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1648.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1648.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=104.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-304.000, y=1568.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1568.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=104.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-304.000, y=1544.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1544.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { t=112.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-304.000, y=1648.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1648.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1640.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1640.000, tex=TEX_MAP["METAL1_3"], }
    { t=112.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-328.000, y=1648.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-328.000, y=1536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1648.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=272.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=128.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-328.000, y=1536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1648.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-328.000, y=1648.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-8.000, tex=TEX_MAP["CITY4_7"], }
    { b=-256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="liquid", detail=1, medium="slime", }
    { x=-304.000, y=1360.000, tex="nothing", }
    { x=-240.000, y=1360.000, tex="nothing", }
    { x=-240.000, y=1664.000, tex="nothing", }
    { x=-304.000, y=1664.000, tex="nothing", }
    { t=-128.000, tex=TEX_MAP["*LAVA1"], }
    { b=-256.000, tex="nothing", }
  }
  {
    { m="solid", }
    { x=-328.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-224.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-224.000, y=1696.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-328.000, y=1696.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-240.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-240.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-224.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-224.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-240.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-112.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-328.000, y=1176.000, tex=TEX_MAP["METAL2_2"], }
    { x=-256.000, y=1176.000, tex=TEX_MAP["METAL2_2"], }
    { x=-256.000, y=1336.000, tex=TEX_MAP["METAL2_2"], }
    { x=-328.000, y=1336.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], }
    { b=160.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=132.000, y=1100.000, tex=TEX_MAP["METAL1_3"], }
    { x=108.000, y=1124.000, tex=TEX_MAP["METAL1_3"], }
    { x=100.000, y=1124.000, tex=TEX_MAP["METAL1_3"], }
    { x=124.000, y=1100.000, tex=TEX_MAP["METAL1_3"], }
    { t=0.000, tex=TEX_MAP["METAL1_3"], }
    { b=-16.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=128.000, y=1208.000, tex=TEX_MAP["METAL1_3"], }
    { x=104.000, y=1184.000, tex=TEX_MAP["METAL1_3"], }
    { x=104.000, y=1176.000, tex=TEX_MAP["METAL1_3"], }
    { x=128.000, y=1200.000, tex=TEX_MAP["METAL1_3"], }
    { t=0.000, tex=TEX_MAP["METAL1_3"], }
    { b=-16.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=176.000, y=1204.000, tex=TEX_MAP["METAL1_3"], }
    { x=200.000, y=1180.000, tex=TEX_MAP["METAL1_3"], }
    { x=208.000, y=1180.000, tex=TEX_MAP["METAL1_3"], }
    { x=184.000, y=1204.000, tex=TEX_MAP["METAL1_3"], }
    { t=0.000, tex=TEX_MAP["METAL1_3"], }
    { b=-16.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=180.000, y=1096.000, tex=TEX_MAP["METAL1_3"], }
    { x=204.000, y=1120.000, tex=TEX_MAP["METAL1_3"], }
    { x=204.000, y=1128.000, tex=TEX_MAP["METAL1_3"], }
    { x=180.000, y=1104.000, tex=TEX_MAP["METAL1_3"], }
    { t=0.000, tex=TEX_MAP["METAL1_3"], }
    { b=-16.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=96.000, y=1096.000, tex=TEX_MAP["METAL1_3"], }
    { x=200.000, y=1096.000, tex=TEX_MAP["METAL1_3"], }
    { x=200.000, y=1104.000, tex=TEX_MAP["METAL1_3"], }
    { x=96.000, y=1104.000, tex=TEX_MAP["METAL1_3"], }
    { t=4.000, tex=TEX_MAP["METAL1_3"], }
    { b=-20.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=104.000, y=1096.000, tex=TEX_MAP["METAL1_3"], }
    { x=104.000, y=1208.000, tex=TEX_MAP["METAL1_3"], }
    { x=96.000, y=1208.000, tex=TEX_MAP["METAL1_3"], }
    { x=96.000, y=1096.000, tex=TEX_MAP["METAL1_3"], }
    { t=4.000, tex=TEX_MAP["METAL1_3"], }
    { b=-20.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=200.000, y=1208.000, tex=TEX_MAP["METAL1_3"], }
    { x=200.000, y=1096.000, tex=TEX_MAP["METAL1_3"], }
    { x=208.000, y=1096.000, tex=TEX_MAP["METAL1_3"], }
    { x=208.000, y=1208.000, tex=TEX_MAP["METAL1_3"], }
    { t=4.000, tex=TEX_MAP["METAL1_3"], }
    { b=-20.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=96.000, y=1200.000, tex=TEX_MAP["METAL1_3"], }
    { x=208.000, y=1200.000, tex=TEX_MAP["METAL1_3"], }
    { x=208.000, y=1208.000, tex=TEX_MAP["METAL1_3"], }
    { x=96.000, y=1208.000, tex=TEX_MAP["METAL1_3"], }
    { t=4.000, tex=TEX_MAP["METAL1_3"], }
    { b=-20.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=376.000, y=528.000, tex=TEX_MAP["CITY4_7"], }
    { x=512.000, y=528.000, tex=TEX_MAP["CITY4_7"], }
    { x=512.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { x=376.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=376.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { x=520.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { x=520.000, y=936.000, tex=TEX_MAP["CITY4_7"], }
    { x=376.000, y=936.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-12.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=520.000, y=928.000, tex=TEX_MAP["BODIESA3_3"], }
    { x=520.000, y=864.000, tex=TEX_MAP["BODIESA3_3"], }
    { x=536.000, y=864.000, tex=TEX_MAP["BODIESA3_3"], }
    { x=536.000, y=928.000, tex=TEX_MAP["BODIESA3_3"], }
    { t=176.000, tex=TEX_MAP["BODIESA3_3"], }
    { b=48.000, tex=TEX_MAP["BODIESA3_3"], }
  }
  {
    { m="solid", }
    { x=672.000, y=832.000, tex=TEX_MAP["BODIESA3_2"], }
    { x=608.000, y=832.000, tex=TEX_MAP["BODIESA3_2"], }
    { x=608.000, y=816.000, tex=TEX_MAP["BODIESA3_2"], }
    { x=672.000, y=816.000, tex=TEX_MAP["BODIESA3_2"], }
    { t=176.000, tex=TEX_MAP["BODIESA3_2"], }
    { b=48.000, tex=TEX_MAP["BODIESA3_2"], }
  }
  {
    { m="solid", }
    { x=520.000, y=1232.000, tex=TEX_MAP["BODIESA3_1"], }
    { x=520.000, y=1168.000, tex=TEX_MAP["BODIESA3_1"], }
    { x=536.000, y=1168.000, tex=TEX_MAP["BODIESA3_1"], }
    { x=536.000, y=1232.000, tex=TEX_MAP["BODIESA3_1"], }
    { t=176.000, tex=TEX_MAP["BODIESA3_1"], }
    { b=48.000, tex=TEX_MAP["BODIESA3_1"], }
  }
  {
    { m="solid", }
    { x=520.000, y=1088.000, tex=TEX_MAP["BODIESA2_4"], }
    { x=520.000, y=1024.000, tex=TEX_MAP["BODIESA2_4"], }
    { x=536.000, y=1024.000, tex=TEX_MAP["BODIESA2_4"], }
    { x=536.000, y=1088.000, tex=TEX_MAP["BODIESA2_4"], }
    { t=176.000, tex=TEX_MAP["BODIESA2_4"], }
    { b=48.000, tex=TEX_MAP["BODIESA2_4"], }
  }
  {
    { m="solid", }
    { x=512.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-64.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-128.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", detail=1, }
    { x=480.000, y=800.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=800.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=832.000, tex=TEX_MAP["METAL1_3"], }
    { x=480.000, y=832.000, tex=TEX_MAP["METAL1_3"], }
    { t=176.000, tex=TEX_MAP["METAL1_3"], }
    { b=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
--    @@@@ FIX BRUSH @ line:325 @@@@
--    @@@@ FIX BRUSH @ line:333 @@@@
--    @@@@ FIX BRUSH @ line:341 @@@@
--    @@@@ FIX BRUSH @ line:348 @@@@
  {
    { m="solid", }
    { x=-304.000, y=1464.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1464.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1392.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1392.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], }
    { b=120.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-328.000, y=1440.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1440.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=104.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-304.000, y=1392.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1392.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=104.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-304.000, y=1368.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1368.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { t=112.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-304.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1464.000, tex=TEX_MAP["METAL1_3"], }
    { x=-304.000, y=1464.000, tex=TEX_MAP["METAL1_3"], }
    { t=112.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-328.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-328.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=272.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=128.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-680.000, y=928.000, tex=TEX_MAP["METAL1_3"], }
    { x=-632.000, y=928.000, tex=TEX_MAP["METAL1_3"], }
    { x=-632.000, y=952.000, tex=TEX_MAP["METAL1_3"], }
    { x=-680.000, y=952.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-608.000, y=1064.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-608.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-584.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-584.000, y=1064.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=192.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=128.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-584.000, y=1064.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=1064.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=1056.000, tex=TEX_MAP["METAL1_3"], }
    { x=-584.000, y=1056.000, tex=TEX_MAP["METAL1_3"], }
    { t=112.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-584.000, y=936.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=936.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=928.000, tex=TEX_MAP["METAL1_3"], }
    { x=-584.000, y=928.000, tex=TEX_MAP["METAL1_3"], }
    { t=112.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-584.000, y=960.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=960.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=928.000, tex=TEX_MAP["METAL1_3"], }
    { x=-584.000, y=928.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=104.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-608.000, y=1032.000, tex=TEX_MAP["METAL1_3"], }
    { x=-584.000, y=1032.000, tex=TEX_MAP["METAL1_3"], }
    { x=-584.000, y=1064.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=1064.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=104.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-584.000, y=1032.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=1032.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=960.000, tex=TEX_MAP["METAL1_3"], }
    { x=-584.000, y=960.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], }
    { b=120.000, tex=TEX_MAP["METAL1_3"], }
  }
--    @@@@ FIX BRUSH @ line:459 @@@@
--    @@@@ FIX BRUSH @ line:466 @@@@
--    @@@@ FIX BRUSH @ line:473 @@@@
--    @@@@ FIX BRUSH @ line:480 @@@@
  {
    { m="solid", xxdetail=3, }
    { x=-432.000, y=792.000, tex=TEX_MAP["METAL1_3"], }
    { x=-456.000, y=792.000, tex=TEX_MAP["METAL1_3"], }
    { x=-456.000, y=720.000, tex=TEX_MAP["METAL1_3"], }
    { x=-432.000, y=720.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], }
    { b=120.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-456.000, y=792.000, tex=TEX_MAP["METAL1_3"], }
    { x=-432.000, y=792.000, tex=TEX_MAP["METAL1_3"], }
    { x=-432.000, y=824.000, tex=TEX_MAP["METAL1_3"], }
    { x=-456.000, y=824.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=104.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-432.000, y=720.000, tex=TEX_MAP["METAL1_3"], }
    { x=-456.000, y=720.000, tex=TEX_MAP["METAL1_3"], }
    { x=-456.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=-432.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=104.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-432.000, y=696.000, tex=TEX_MAP["METAL1_3"], }
    { x=-456.000, y=696.000, tex=TEX_MAP["METAL1_3"], }
    { x=-456.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=-432.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { t=112.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-432.000, y=824.000, tex=TEX_MAP["METAL1_3"], }
    { x=-456.000, y=824.000, tex=TEX_MAP["METAL1_3"], }
    { x=-456.000, y=816.000, tex=TEX_MAP["METAL1_3"], }
    { x=-432.000, y=816.000, tex=TEX_MAP["METAL1_3"], }
    { t=112.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-456.000, y=824.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-456.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-432.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-432.000, y=824.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=192.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=128.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=136.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=136.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=192.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=128.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=0.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=0.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=8.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=8.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { t=112.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=128.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=128.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=136.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=136.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { t=112.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=104.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=104.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=136.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=136.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.44721, ny=0.00000, nz=0.89443 }, }
    { b=104.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.44721, ny=0.00000, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=32.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=32.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=0.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=0.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.44721, ny=0.00000, nz=0.89443 }, }
    { b=104.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.44721, ny=0.00000, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=32.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=32.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=104.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=104.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_3"], }
    { b=120.000, tex=TEX_MAP["METAL1_3"], }
  }
--    @@@@ FIX BRUSH @ line:583 @@@@
--    @@@@ FIX BRUSH @ line:590 @@@@
  {
    { m="solid", }
    { x=-280.000, y=1248.000, tex=TEX_MAP["METAL1_3"], }
    { x=-280.000, y=1200.000, tex=TEX_MAP["METAL1_3"], }
    { x=-256.000, y=1200.000, tex=TEX_MAP["METAL1_3"], }
    { x=-256.000, y=1248.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-632.000, y=1200.000, tex=TEX_MAP["METAL1_3"], }
    { x=-632.000, y=928.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=928.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=1200.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-608.000, y=1176.000, tex=TEX_MAP["METAL1_3"], }
    { x=-256.000, y=1176.000, tex=TEX_MAP["METAL1_3"], }
    { x=-256.000, y=1200.000, tex=TEX_MAP["METAL1_3"], }
    { x=-608.000, y=1200.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-512.000, y=1248.000, tex=TEX_MAP["METAL1_3"], }
    { x=-256.000, y=1248.000, tex=TEX_MAP["METAL1_3"], }
    { x=-256.000, y=1272.000, tex=TEX_MAP["METAL1_3"], }
    { x=-512.000, y=1272.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-488.000, y=1248.000, tex=TEX_MAP["METAL1_3"], }
    { x=-488.000, y=1544.000, tex=TEX_MAP["METAL1_3"], }
    { x=-512.000, y=1544.000, tex=TEX_MAP["METAL1_3"], }
    { x=-512.000, y=1248.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-328.000, y=1544.000, tex=TEX_MAP["METAL1_3"], }
    { x=-512.000, y=1544.000, tex=TEX_MAP["METAL1_3"], }
    { x=-512.000, y=1520.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1520.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-704.000, y=1640.000, tex=TEX_MAP["METAL1_3"], }
    { x=-704.000, y=928.000, tex=TEX_MAP["METAL1_3"], }
    { x=-680.000, y=928.000, tex=TEX_MAP["METAL1_3"], }
    { x=-680.000, y=1640.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-704.000, y=1640.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1640.000, tex=TEX_MAP["METAL1_3"], }
    { x=-328.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=-704.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=416.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=448.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=448.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=416.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-24.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=448.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=448.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=160.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=88.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=448.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=448.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=8.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=512.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-280.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-256.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-256.000, y=1272.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-280.000, y=1272.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=176.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=160.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-704.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=-608.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=-608.000, y=1176.000, tex=TEX_MAP["METAL2_2"], }
    { x=-704.000, y=1176.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], }
    { b=160.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=-704.000, y=1176.000, tex=TEX_MAP["METAL2_2"], }
    { x=-328.000, y=1176.000, tex=TEX_MAP["METAL2_2"], }
    { x=-328.000, y=1664.000, tex=TEX_MAP["METAL2_2"], }
    { x=-704.000, y=1664.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], }
    { b=160.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=-608.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-720.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-720.000, y=912.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-608.000, y=912.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-720.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-720.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-704.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-704.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-488.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-328.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-328.000, y=1520.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-488.000, y=1520.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-256.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-184.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-184.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-256.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-160.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-256.000, y=1336.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-488.000, y=1336.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-488.000, y=1272.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-256.000, y=1272.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-160.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-488.000, y=1336.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-256.000, y=1336.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-256.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-488.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-440.000, y=1176.000, tex=TEX_MAP["CITY4_7"], }
    { x=-400.000, y=1176.000, tex=TEX_MAP["CITY4_7"], }
    { x=-400.000, y=1272.000, tex=TEX_MAP["CITY4_7"], }
    { x=-440.000, y=1272.000, tex=TEX_MAP["CITY4_7"], }
    { t=16.000, tex=TEX_MAP["CITY4_7"], }
    { b=0.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-400.000, y=1176.000, tex=TEX_MAP["CITY4_7"], }
    { x=-360.000, y=1176.000, tex=TEX_MAP["CITY4_7"], }
    { x=-360.000, y=1272.000, tex=TEX_MAP["CITY4_7"], }
    { x=-400.000, y=1272.000, tex=TEX_MAP["CITY4_7"], }
    { t=32.000, tex=TEX_MAP["CITY4_7"], }
    { b=16.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-360.000, y=1144.000, tex=TEX_MAP["CITY4_7"], }
    { x=-256.000, y=1144.000, tex=TEX_MAP["CITY4_7"], }
    { x=-256.000, y=1272.000, tex=TEX_MAP["CITY4_7"], }
    { x=-360.000, y=1272.000, tex=TEX_MAP["CITY4_7"], }
    { t=48.000, tex=TEX_MAP["CITY4_7"], }
    { b=32.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-432.000, y=1056.000, tex=TEX_MAP["CITY4_7"], }
    { x=-184.000, y=1056.000, tex=TEX_MAP["CITY4_7"], }
    { x=-184.000, y=1144.000, tex=TEX_MAP["CITY4_7"], }
    { x=-432.000, y=1144.000, tex=TEX_MAP["CITY4_7"], }
    { t=48.000, tex=TEX_MAP["CITY4_7"], }
    { b=32.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=376.000, y=936.000, tex=TEX_MAP["CITY4_7"], }
    { x=344.000, y=904.000, tex=TEX_MAP["CITY4_7"], }
    { x=344.000, y=720.000, tex=TEX_MAP["CITY4_7"], }
    { x=376.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-12.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=672.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=896.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=896.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=220.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=768.000, y=848.000, tex=TEX_MAP["METAL2_2"], }
    { x=768.000, y=808.000, tex=TEX_MAP["METAL2_2"], }
    { x=800.000, y=808.000, tex=TEX_MAP["METAL2_2"], }
    { x=800.000, y=848.000, tex=TEX_MAP["METAL2_2"], }
    { t=60.000, tex=TEX_MAP["METAL2_2"], }
    { b=-56.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=768.000, y=848.000, tex=TEX_MAP["ROOF"], }
    { x=768.000, y=808.000, tex=TEX_MAP["ROOF"], }
    { x=800.000, y=808.000, tex=TEX_MAP["ROOF"], }
    { x=800.000, y=848.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=768.000, y=824.000, tex=TEX_MAP["METAL2_2"], }
    { x=768.000, y=808.000, tex=TEX_MAP["METAL2_2"], }
    { x=800.000, y=808.000, tex=TEX_MAP["METAL2_2"], }
    { x=800.000, y=824.000, tex=TEX_MAP["METAL2_2"], }
    { t=224.000, tex=TEX_MAP["METAL2_2"], }
    { b=48.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=832.000, y=824.000, tex=TEX_MAP["METAL2_2"], }
    { x=832.000, y=808.000, tex=TEX_MAP["METAL2_2"], }
    { x=864.000, y=808.000, tex=TEX_MAP["METAL2_2"], }
    { x=864.000, y=824.000, tex=TEX_MAP["METAL2_2"], }
    { t=224.000, tex=TEX_MAP["METAL2_2"], }
    { b=48.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=832.000, y=848.000, tex=TEX_MAP["ROOF"], }
    { x=832.000, y=808.000, tex=TEX_MAP["ROOF"], }
    { x=864.000, y=808.000, tex=TEX_MAP["ROOF"], }
    { x=864.000, y=848.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=832.000, y=848.000, tex=TEX_MAP["METAL2_2"], }
    { x=832.000, y=808.000, tex=TEX_MAP["METAL2_2"], }
    { x=864.000, y=808.000, tex=TEX_MAP["METAL2_2"], }
    { x=864.000, y=848.000, tex=TEX_MAP["METAL2_2"], }
    { t=60.000, tex=TEX_MAP["METAL2_2"], }
    { b=-56.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=896.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=936.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=936.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=896.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=952.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=952.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=48.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=696.000, y=536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=696.000, y=624.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=624.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=536.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=720.000, y=672.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=624.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=584.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=720.000, y=632.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=672.000, y=624.000, tex=TEX_MAP["CITY4_7"], }
    { x=720.000, y=672.000, tex=TEX_MAP["CITY4_7"], }
    { x=672.000, y=672.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=832.000, y=672.000, tex=TEX_MAP["CITY4_7"], }
    { x=832.000, y=800.000, tex=TEX_MAP["CITY4_7"], }
    { x=672.000, y=800.000, tex=TEX_MAP["CITY4_7"], }
    { x=672.000, y=672.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=672.000, y=800.000, tex=TEX_MAP["CITY4_7"], }
    { x=544.000, y=800.000, tex=TEX_MAP["CITY4_7"], }
    { x=544.000, y=528.000, tex=TEX_MAP["CITY4_7"], }
    { x=672.000, y=528.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=928.000, y=672.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=952.000, y=672.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=952.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=928.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=48.000, tex=TEX_MAP["CITY4_7"], }
    { b=-20.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=832.000, y=672.000, tex=TEX_MAP["METAL1_3"], }
    { x=864.000, y=672.000, tex=TEX_MAP["METAL1_3"], }
    { x=864.000, y=800.000, tex=TEX_MAP["METAL1_3"], }
    { x=832.000, y=800.000, tex=TEX_MAP["METAL1_3"], }
    { t=12.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=864.000, y=672.000, tex=TEX_MAP["METAL1_3"], }
    { x=896.000, y=672.000, tex=TEX_MAP["METAL1_3"], }
    { x=896.000, y=800.000, tex=TEX_MAP["METAL1_3"], }
    { x=864.000, y=800.000, tex=TEX_MAP["METAL1_3"], }
    { t=24.000, tex=TEX_MAP["METAL1_3"], }
    { b=-20.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=896.000, y=672.000, tex=TEX_MAP["METAL1_3"], }
    { x=928.000, y=672.000, tex=TEX_MAP["METAL1_3"], }
    { x=928.000, y=800.000, tex=TEX_MAP["METAL1_3"], }
    { x=896.000, y=800.000, tex=TEX_MAP["METAL1_3"], }
    { t=36.000, tex=TEX_MAP["METAL1_3"], }
    { b=-16.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=448.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=416.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=416.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { x=448.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=496.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=512.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=512.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=496.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=464.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=440.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=440.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=464.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-32.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=496.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=496.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=464.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=464.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.55470, ny=0.00000, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=440.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=440.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=408.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=408.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=0.55470, ny=0.00000, nz=-0.83205 }, }
  }
  {
    { m="solid", }
    { x=544.000, y=536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=952.000, y=536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=952.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=234.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=218.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=632.000, y=928.000, tex=TEX_MAP["ROOF2"], }
    { x=864.000, y=928.000, tex=TEX_MAP["ROOF2"], }
    { x=864.000, y=1360.000, tex=TEX_MAP["ROOF2"], }
    { x=632.000, y=1360.000, tex=TEX_MAP["ROOF2"], }
    { t=320.000, tex=TEX_MAP["ROOF2"], }
    { b=306.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=952.000, y=1256.000, tex=TEX_MAP["ROOF"], }
    { x=952.000, y=1288.000, tex=TEX_MAP["ROOF"], }
    { x=864.000, y=1288.000, tex=TEX_MAP["ROOF"], }
    { x=864.000, y=1256.000, tex=TEX_MAP["ROOF"], }
    { t=248.000, tex=TEX_MAP["ROOF"], }
    { b=202.667, tex=TEX_MAP["ROOF"], slope={ nx=-0.31623, ny=0.00000, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=704.000, y=1448.000, tex=TEX_MAP["ROOF"], }
    { x=672.000, y=1448.000, tex=TEX_MAP["ROOF"], }
    { x=672.000, y=1360.000, tex=TEX_MAP["ROOF"], }
    { x=704.000, y=1360.000, tex=TEX_MAP["ROOF"], }
    { t=248.000, tex=TEX_MAP["ROOF"], }
    { b=202.667, tex=TEX_MAP["ROOF"], slope={ nx=-0.00000, ny=-0.31623, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=832.000, y=1448.000, tex=TEX_MAP["ROOF"], }
    { x=800.000, y=1448.000, tex=TEX_MAP["ROOF"], }
    { x=800.000, y=1360.000, tex=TEX_MAP["ROOF"], }
    { x=832.000, y=1360.000, tex=TEX_MAP["ROOF"], }
    { t=248.000, tex=TEX_MAP["ROOF"], }
    { b=202.667, tex=TEX_MAP["ROOF"], slope={ nx=-0.00000, ny=-0.31623, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=632.000, y=968.000, tex=TEX_MAP["ROOF"], }
    { x=632.000, y=1000.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=1000.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=968.000, tex=TEX_MAP["ROOF"], }
    { t=248.000, tex=TEX_MAP["ROOF"], }
    { b=202.667, tex=TEX_MAP["ROOF"], slope={ nx=0.31623, ny=0.00000, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=632.000, y=1128.000, tex=TEX_MAP["ROOF"], }
    { x=632.000, y=1160.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=1160.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=1128.000, tex=TEX_MAP["ROOF"], }
    { t=248.000, tex=TEX_MAP["ROOF"], }
    { b=202.667, tex=TEX_MAP["ROOF"], slope={ nx=0.31623, ny=0.00000, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=632.000, y=1256.000, tex=TEX_MAP["ROOF"], }
    { x=632.000, y=1288.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=1288.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=1256.000, tex=TEX_MAP["ROOF"], }
    { t=248.000, tex=TEX_MAP["ROOF"], }
    { b=202.667, tex=TEX_MAP["ROOF"], slope={ nx=0.31623, ny=0.00000, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=952.000, y=928.000, tex=TEX_MAP["ROOF"], }
    { x=952.000, y=1360.000, tex=TEX_MAP["ROOF"], }
    { x=864.000, y=1360.000, tex=TEX_MAP["ROOF"], }
    { x=864.000, y=928.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=264.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=632.000, y=928.000, tex=TEX_MAP["ROOF"], }
    { x=632.000, y=1360.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=1360.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=928.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=264.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=952.000, y=928.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=928.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=840.000, tex=TEX_MAP["ROOF"], }
    { x=952.000, y=840.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=264.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1360.000, tex=TEX_MAP["ROOF"], }
    { x=952.000, y=1360.000, tex=TEX_MAP["ROOF"], }
    { x=952.000, y=1448.000, tex=TEX_MAP["ROOF"], }
    { x=544.000, y=1448.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=264.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1360.000, tex=TEX_MAP["ROOF2"], }
    { x=544.000, y=928.000, tex=TEX_MAP["ROOF2"], }
    { x=632.000, y=928.000, tex=TEX_MAP["ROOF2"], }
    { x=632.000, y=1360.000, tex=TEX_MAP["ROOF2"], }
    { t=264.000, tex=TEX_MAP["ROOF2"], }
    { b=248.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=864.000, y=1360.000, tex=TEX_MAP["ROOF2"], }
    { x=864.000, y=928.000, tex=TEX_MAP["ROOF2"], }
    { x=952.000, y=928.000, tex=TEX_MAP["ROOF2"], }
    { x=952.000, y=1360.000, tex=TEX_MAP["ROOF2"], }
    { t=264.000, tex=TEX_MAP["ROOF2"], }
    { b=248.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1360.000, tex=TEX_MAP["ROOF2"], }
    { x=952.000, y=1360.000, tex=TEX_MAP["ROOF2"], }
    { x=952.000, y=1448.000, tex=TEX_MAP["ROOF2"], }
    { x=544.000, y=1448.000, tex=TEX_MAP["ROOF2"], }
    { t=264.000, tex=TEX_MAP["ROOF2"], }
    { b=248.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=544.000, y=840.000, tex=TEX_MAP["ROOF2"], }
    { x=952.000, y=840.000, tex=TEX_MAP["ROOF2"], }
    { x=952.000, y=928.000, tex=TEX_MAP["ROOF2"], }
    { x=544.000, y=928.000, tex=TEX_MAP["ROOF2"], }
    { t=264.000, tex=TEX_MAP["ROOF2"], }
    { b=248.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=1184.000, y=632.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=1184.000, y=1480.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=1152.000, y=1480.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=1152.000, y=632.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=936.000, y=1288.000, tex=TEX_MAP["METAL1_3"], }
    { x=968.000, y=1288.000, tex=TEX_MAP["METAL1_3"], }
    { x=968.000, y=1352.000, tex=TEX_MAP["METAL1_3"], }
    { x=936.000, y=1352.000, tex=TEX_MAP["METAL1_3"], }
    { t=176.000, tex=TEX_MAP["METAL1_3"], }
    { b=168.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=968.000, y=1288.000, tex=TEX_MAP["METAL1_3"], }
    { x=936.000, y=1288.000, tex=TEX_MAP["METAL1_3"], }
    { x=936.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=968.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { t=176.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=152.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=936.000, y=1352.000, tex=TEX_MAP["METAL1_3"], }
    { x=968.000, y=1352.000, tex=TEX_MAP["METAL1_3"], }
    { x=968.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { x=936.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { t=176.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=152.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=936.000, y=1376.000, tex=TEX_MAP["METAL1_3"], }
    { x=968.000, y=1376.000, tex=TEX_MAP["METAL1_3"], }
    { x=968.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { x=936.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { t=192.000, tex=TEX_MAP["METAL1_3"], }
    { b=-24.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=936.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=968.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=968.000, y=1264.000, tex=TEX_MAP["METAL1_3"], }
    { x=936.000, y=1264.000, tex=TEX_MAP["METAL1_3"], }
    { t=192.000, tex=TEX_MAP["METAL1_3"], }
    { b=-16.000, tex=TEX_MAP["METAL1_3"], }
  }
--    @@@@ FIX BRUSH @ line:1164 @@@@
--    @@@@ FIX BRUSH @ line:1171 @@@@
  {
    { m="solid", }
    { x=936.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=968.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=968.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=936.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=176.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=944.000, y=912.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=912.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=944.000, tex=TEX_MAP["METAL2_2"], }
    { x=944.000, y=944.000, tex=TEX_MAP["METAL2_2"], }
    { t=60.000, tex=TEX_MAP["METAL2_2"], }
    { b=-56.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=944.000, y=1000.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=1000.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=1032.000, tex=TEX_MAP["METAL2_2"], }
    { x=944.000, y=1032.000, tex=TEX_MAP["METAL2_2"], }
    { t=60.000, tex=TEX_MAP["METAL2_2"], }
    { b=-56.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=944.000, y=1088.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=1088.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=1120.000, tex=TEX_MAP["METAL2_2"], }
    { x=944.000, y=1120.000, tex=TEX_MAP["METAL2_2"], }
    { t=60.000, tex=TEX_MAP["METAL2_2"], }
    { b=-56.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=944.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=984.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=984.000, y=1120.000, tex=TEX_MAP["ROOF"], }
    { x=944.000, y=1120.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=944.000, y=1000.000, tex=TEX_MAP["ROOF"], }
    { x=984.000, y=1000.000, tex=TEX_MAP["ROOF"], }
    { x=984.000, y=1032.000, tex=TEX_MAP["ROOF"], }
    { x=944.000, y=1032.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=944.000, y=912.000, tex=TEX_MAP["ROOF"], }
    { x=984.000, y=912.000, tex=TEX_MAP["ROOF"], }
    { x=984.000, y=944.000, tex=TEX_MAP["ROOF"], }
    { x=944.000, y=944.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=968.000, y=912.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=912.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=944.000, tex=TEX_MAP["METAL2_2"], }
    { x=968.000, y=944.000, tex=TEX_MAP["METAL2_2"], }
    { t=224.000, tex=TEX_MAP["METAL2_2"], }
    { b=48.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=968.000, y=1000.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=1000.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=1032.000, tex=TEX_MAP["METAL2_2"], }
    { x=968.000, y=1032.000, tex=TEX_MAP["METAL2_2"], }
    { t=224.000, tex=TEX_MAP["METAL2_2"], }
    { b=48.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=968.000, y=1088.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=1088.000, tex=TEX_MAP["METAL2_2"], }
    { x=984.000, y=1120.000, tex=TEX_MAP["METAL2_2"], }
    { x=968.000, y=1120.000, tex=TEX_MAP["METAL2_2"], }
    { t=224.000, tex=TEX_MAP["METAL2_2"], }
    { b=48.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=952.000, y=672.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=1152.000, y=672.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=1152.000, y=1448.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=952.000, y=1448.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=220.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=952.000, y=672.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=1152.000, y=672.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=1152.000, y=1448.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=952.000, y=1448.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=48.000, tex=TEX_MAP["CITY4_7"], }
    { b=-20.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=936.000, y=1448.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=936.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=968.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=968.000, y=1448.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=672.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=720.000, y=672.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=720.000, y=632.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=1152.000, y=632.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=608.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=608.000, y=816.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=816.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=48.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=608.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=608.000, y=816.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=816.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=176.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=608.000, y=816.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=608.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=816.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=672.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=816.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=816.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=736.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=840.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=672.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=736.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=936.000, y=872.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=936.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=968.000, y=800.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=968.000, y=872.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=936.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=936.000, y=1160.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=968.000, y=1160.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=968.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=928.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=968.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=968.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=928.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=48.000, tex=TEX_MAP["CITY4_7"], }
    { b=-20.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=896.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=928.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=928.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { x=896.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { t=36.000, tex=TEX_MAP["METAL1_3"], }
    { b=-16.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=864.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=896.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=896.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { x=864.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { t=24.000, tex=TEX_MAP["METAL1_3"], }
    { b=-20.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=832.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=864.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=864.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { x=832.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { t=12.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=1480.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1480.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1448.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=1152.000, y=1448.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=520.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-128.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=520.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-16.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-64.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-16.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=512.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-16.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=512.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=160.000, tex=TEX_MAP["BRICKA2_4"], }
  }
--    @@@@ FIX BRUSH @ line:1426 @@@@
--    @@@@ FIX BRUSH @ line:1433 @@@@
  {
    { m="solid", xxdetail=3, }
    { x=512.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=1264.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1264.000, tex=TEX_MAP["METAL1_3"], }
    { t=144.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=512.000, y=1376.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=1376.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { t=144.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=512.000, y=1352.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=1352.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1384.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=136.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=544.000, y=1288.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1288.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=1256.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=136.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=512.000, y=1288.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=1288.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=1352.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1352.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=152.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=416.000, y=1000.000, tex=TEX_MAP["COP3_4"], }
    { x=480.000, y=1000.000, tex=TEX_MAP["COP3_4"], }
    { x=480.000, y=1064.000, tex=TEX_MAP["COP3_4"], }
    { x=416.000, y=1064.000, tex=TEX_MAP["COP3_4"], }
    { t=4.000, tex=TEX_MAP["COP3_4"], }
    { b=0.000, tex=TEX_MAP["COP3_4"], }
  }
  {
    { m="solid", }
    { x=952.000, y=1448.000, tex=TEX_MAP["CITY4_7"], }
    { x=512.000, y=1448.000, tex=TEX_MAP["CITY4_7"], }
    { x=512.000, y=800.000, tex=TEX_MAP["CITY4_7"], }
    { x=952.000, y=800.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
--    @@@@ FIX BRUSH @ line:1496 @@@@
--    @@@@ FIX BRUSH @ line:1503 @@@@
  {
    { m="solid", }
    { x=512.000, y=536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=160.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=512.000, y=568.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=568.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=632.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=632.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=152.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=544.000, y=568.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=568.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=536.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=536.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=136.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=512.000, y=632.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=632.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=136.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=512.000, y=656.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=656.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { t=144.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=512.000, y=536.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=536.000, tex=TEX_MAP["METAL1_3"], }
    { x=544.000, y=544.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=544.000, tex=TEX_MAP["METAL1_3"], }
    { t=144.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=512.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-128.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=512.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-64.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=520.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1088.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1088.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1024.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1024.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=48.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1088.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1088.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1024.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1024.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=176.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=864.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=864.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=48.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=864.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=864.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=176.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=864.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=864.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1024.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1024.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1232.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1232.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1168.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1168.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=48.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1232.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1232.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1168.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1168.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=176.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1168.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1168.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1088.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1088.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=520.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=520.000, y=1232.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1232.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1256.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-488.000, y=952.000, tex=TEX_MAP["METAL2_2"], }
    { x=-552.000, y=952.000, tex=TEX_MAP["METAL2_2"], }
    { x=-552.000, y=920.000, tex=TEX_MAP["METAL2_2"], }
    { x=-488.000, y=920.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], }
    { b=160.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-456.000, y=952.000, tex=TEX_MAP["METAL2_2"], }
    { x=-488.000, y=952.000, tex=TEX_MAP["METAL2_2"], }
    { x=-488.000, y=920.000, tex=TEX_MAP["METAL2_2"], }
    { x=-456.000, y=920.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.70711, ny=0.00000, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-552.000, y=952.000, tex=TEX_MAP["METAL2_2"], }
    { x=-584.000, y=952.000, tex=TEX_MAP["METAL2_2"], }
    { x=-584.000, y=920.000, tex=TEX_MAP["METAL2_2"], }
    { x=-552.000, y=920.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.70711, ny=0.00000, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=-456.000, y=1064.000, tex=TEX_MAP["METAL1_3"], }
    { x=-488.000, y=1064.000, tex=TEX_MAP["METAL1_3"], }
    { x=-488.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=-456.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { t=192.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.70711, ny=0.00000, nz=0.70711 }, }
    { b=144.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=-488.000, y=1064.000, tex=TEX_MAP["METAL1_3"], }
    { x=-552.000, y=1064.000, tex=TEX_MAP["METAL1_3"], }
    { x=-552.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=-488.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { t=192.000, tex=TEX_MAP["METAL1_3"], }
    { b=176.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-552.000, y=1064.000, tex=TEX_MAP["METAL1_3"], }
    { x=-584.000, y=1064.000, tex=TEX_MAP["METAL1_3"], }
    { x=-584.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=-552.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { t=192.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.70711, ny=0.00000, nz=0.70711 }, }
    { b=144.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=-400.000, y=1560.000, tex=TEX_MAP["CITY4_7"], }
    { x=-336.000, y=1560.000, tex=TEX_MAP["CITY4_7"], }
    { x=-336.000, y=1624.000, tex=TEX_MAP["CITY4_7"], }
    { x=-400.000, y=1624.000, tex=TEX_MAP["CITY4_7"], }
    { t=-4.000, tex=TEX_MAP["CITY4_7"], }
    { b=-144.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-328.000, y=1176.000, tex=TEX_MAP["CITY4_7"], }
    { x=-328.000, y=1560.000, tex=TEX_MAP["CITY4_7"], }
    { x=-400.000, y=1560.000, tex=TEX_MAP["CITY4_7"], }
    { x=-400.000, y=1176.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-144.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-280.000, y=1276.000, tex=TEX_MAP["CITY4_7"], }
    { x=-320.000, y=1276.000, tex=TEX_MAP["CITY4_7"], }
    { x=-320.000, y=1176.000, tex=TEX_MAP["CITY4_7"], }
    { x=-280.000, y=1176.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-144.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-400.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { x=-400.000, y=1624.000, tex=TEX_MAP["CITY4_7"], }
    { x=-328.000, y=1624.000, tex=TEX_MAP["CITY4_7"], }
    { x=-328.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-144.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-400.000, y=1176.000, tex=TEX_MAP["CITY4_7"], }
    { x=-400.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { x=-584.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { x=-584.000, y=1176.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-144.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-552.000, y=768.000, tex=TEX_MAP["METAL2_2"], }
    { x=-584.000, y=768.000, tex=TEX_MAP["METAL2_2"], }
    { x=-584.000, y=736.000, tex=TEX_MAP["METAL2_2"], }
    { x=-552.000, y=736.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.70711, ny=0.00000, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-456.000, y=768.000, tex=TEX_MAP["METAL2_2"], }
    { x=-488.000, y=768.000, tex=TEX_MAP["METAL2_2"], }
    { x=-488.000, y=736.000, tex=TEX_MAP["METAL2_2"], }
    { x=-456.000, y=736.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.70711, ny=0.00000, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=-488.000, y=768.000, tex=TEX_MAP["METAL2_2"], }
    { x=-552.000, y=768.000, tex=TEX_MAP["METAL2_2"], }
    { x=-552.000, y=736.000, tex=TEX_MAP["METAL2_2"], }
    { x=-488.000, y=736.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], }
    { b=160.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=-456.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-608.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-608.000, y=1064.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-456.000, y=1064.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=192.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-608.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-608.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-584.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-584.000, y=928.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=192.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-584.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-456.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-456.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-584.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=192.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-584.000, y=928.000, tex=TEX_MAP["CITY4_7"], }
    { x=-584.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { x=-704.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { x=-704.000, y=928.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-456.000, y=1064.000, tex=TEX_MAP["CITY4_7"], }
    { x=-584.000, y=1064.000, tex=TEX_MAP["CITY4_7"], }
    { x=-584.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { x=-456.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-376.000, y=1144.000, tex=TEX_MAP["ROOF2"], }
    { x=-376.000, y=744.000, tex=TEX_MAP["ROOF2"], }
    { x=-240.000, y=744.000, tex=TEX_MAP["ROOF2"], }
    { x=-240.000, y=1144.000, tex=TEX_MAP["ROOF2"], }
    { t=256.000, tex=TEX_MAP["ROOF2"], }
    { b=240.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=-240.000, y=744.000, tex=TEX_MAP["ROOF2"], }
    { x=512.000, y=744.000, tex=TEX_MAP["ROOF2"], }
    { x=512.000, y=880.000, tex=TEX_MAP["ROOF2"], }
    { x=-240.000, y=880.000, tex=TEX_MAP["ROOF2"], }
    { t=256.000, tex=TEX_MAP["ROOF2"], }
    { b=240.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=416.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=448.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=448.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { x=416.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=-0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=288.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=320.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=320.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { x=288.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=-0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=160.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { x=160.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=-0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=32.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=64.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=64.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { x=32.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=-0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-104.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=-72.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=-72.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { x=-104.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=-0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-240.000, y=1088.000, tex=TEX_MAP["METAL2_2"], }
    { x=-240.000, y=1056.000, tex=TEX_MAP["METAL2_2"], }
    { x=-184.000, y=1056.000, tex=TEX_MAP["METAL2_2"], }
    { x=-184.000, y=1088.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.32130, ny=-0.00000, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-376.000, y=912.000, tex=TEX_MAP["METAL2_2"], }
    { x=-376.000, y=944.000, tex=TEX_MAP["METAL2_2"], }
    { x=-432.000, y=944.000, tex=TEX_MAP["METAL2_2"], }
    { x=-432.000, y=912.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.32130, ny=0.00000, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-376.000, y=1056.000, tex=TEX_MAP["METAL2_2"], }
    { x=-376.000, y=1088.000, tex=TEX_MAP["METAL2_2"], }
    { x=-432.000, y=1088.000, tex=TEX_MAP["METAL2_2"], }
    { x=-432.000, y=1056.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.32130, ny=0.00000, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-344.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=-376.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=-376.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { x=-344.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-216.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=-248.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=-248.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { x=-216.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-72.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=-104.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=-104.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { x=-72.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=192.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=160.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=160.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=320.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=288.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=288.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { x=320.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { t=160.000, tex=TEX_MAP["METAL2_2"], }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.32130, nz=-0.94698 }, }
  }
  {
    { m="solid", }
    { x=-376.000, y=1144.000, tex=TEX_MAP["METAL2_2"], }
    { x=-432.000, y=1144.000, tex=TEX_MAP["METAL2_2"], }
    { x=-432.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { x=-376.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { t=256.000, tex=TEX_MAP["METAL2_2"], }
    { b=176.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=-376.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { x=-376.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { x=512.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { x=512.000, y=744.000, tex=TEX_MAP["METAL2_2"], }
    { t=256.000, tex=TEX_MAP["METAL2_2"], }
    { b=176.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=-184.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { x=-184.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=512.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=512.000, y=936.000, tex=TEX_MAP["METAL2_2"], }
    { t=256.000, tex=TEX_MAP["METAL2_2"], }
    { b=176.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=-240.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=-184.000, y=880.000, tex=TEX_MAP["METAL2_2"], }
    { x=-184.000, y=1144.000, tex=TEX_MAP["METAL2_2"], }
    { x=-240.000, y=1144.000, tex=TEX_MAP["METAL2_2"], }
    { t=256.000, tex=TEX_MAP["METAL2_2"], }
    { b=176.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=-376.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=744.000, tex=TEX_MAP["METAL1_3"], }
    { x=-376.000, y=744.000, tex=TEX_MAP["METAL1_3"], }
    { t=176.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-376.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { x=-376.000, y=1144.000, tex=TEX_MAP["METAL1_3"], }
    { x=-432.000, y=1144.000, tex=TEX_MAP["METAL1_3"], }
    { x=-432.000, y=688.000, tex=TEX_MAP["METAL1_3"], }
    { t=176.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-240.000, y=1144.000, tex=TEX_MAP["METAL1_3"], }
    { x=-240.000, y=880.000, tex=TEX_MAP["METAL1_3"], }
    { x=-184.000, y=880.000, tex=TEX_MAP["METAL1_3"], }
    { x=-184.000, y=1144.000, tex=TEX_MAP["METAL1_3"], }
    { t=176.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=-184.000, y=880.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=880.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=936.000, tex=TEX_MAP["METAL1_3"], }
    { x=-184.000, y=936.000, tex=TEX_MAP["METAL1_3"], }
    { t=176.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=376.000, y=664.000, tex=TEX_MAP["METAL2_2"], }
    { x=512.000, y=664.000, tex=TEX_MAP["METAL2_2"], }
    { x=512.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { x=376.000, y=688.000, tex=TEX_MAP["METAL2_2"], }
    { t=112.000, tex=TEX_MAP["METAL2_2"], }
    { b=104.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=328.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=328.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=360.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=360.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], }
    { b=160.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=328.000, y=664.000, tex=TEX_MAP["METAL2_2"], }
    { x=328.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=360.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=360.000, y=664.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.00000, ny=0.70711, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.00000, ny=-0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=328.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=328.000, y=536.000, tex=TEX_MAP["METAL2_2"], }
    { x=360.000, y=536.000, tex=TEX_MAP["METAL2_2"], }
    { x=360.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=-0.70711, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=448.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=448.000, y=536.000, tex=TEX_MAP["METAL2_2"], }
    { x=480.000, y=536.000, tex=TEX_MAP["METAL2_2"], }
    { x=480.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=-0.70711, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=448.000, y=664.000, tex=TEX_MAP["METAL2_2"], }
    { x=448.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=480.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=480.000, y=664.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.00000, ny=0.70711, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.00000, ny=-0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=448.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=448.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=480.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=480.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], }
    { b=160.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=192.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=224.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=224.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], }
    { b=160.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=192.000, y=664.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=224.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=224.000, y=664.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.00000, ny=0.70711, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.00000, ny=-0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=192.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=536.000, tex=TEX_MAP["METAL2_2"], }
    { x=224.000, y=536.000, tex=TEX_MAP["METAL2_2"], }
    { x=224.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=-0.70711, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=64.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=64.000, y=536.000, tex=TEX_MAP["METAL2_2"], }
    { x=96.000, y=536.000, tex=TEX_MAP["METAL2_2"], }
    { x=96.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=-0.70711, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=64.000, y=664.000, tex=TEX_MAP["METAL2_2"], }
    { x=64.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=96.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=96.000, y=664.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.00000, ny=0.70711, nz=0.70711 }, }
    { b=128.000, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.00000, ny=-0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=64.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { x=64.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=96.000, y=568.000, tex=TEX_MAP["METAL2_2"], }
    { x=96.000, y=632.000, tex=TEX_MAP["METAL2_2"], }
    { t=176.000, tex=TEX_MAP["METAL2_2"], }
    { b=160.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=0.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { x=0.000, y=632.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=632.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=664.000, tex=TEX_MAP["METAL1_3"], }
    { t=192.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=0.70711, nz=0.70711 }, }
    { b=144.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=-0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=0.000, y=632.000, tex=TEX_MAP["METAL1_3"], }
    { x=0.000, y=568.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=568.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=632.000, tex=TEX_MAP["METAL1_3"], }
    { t=192.000, tex=TEX_MAP["METAL1_3"], }
    { b=176.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=0.000, y=568.000, tex=TEX_MAP["METAL1_3"], }
    { x=0.000, y=536.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=536.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=568.000, tex=TEX_MAP["METAL1_3"], }
    { t=192.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.70711, nz=0.70711 }, }
    { b=144.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=0.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=136.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=136.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-16.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-456.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-432.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-432.000, y=824.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-456.000, y=824.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-16.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-456.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-456.000, y=824.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-432.000, y=824.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-432.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=224.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-328.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-328.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-24.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-24.000, y=512.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=512.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=224.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=512.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=696.000, y=512.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=696.000, y=536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=536.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=224.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-456.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-456.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=224.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=376.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=376.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-16.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=664.000, tex=TEX_MAP["CITY4_7"], }
    { x=0.000, y=536.000, tex=TEX_MAP["CITY4_7"], }
    { x=544.000, y=536.000, tex=TEX_MAP["CITY4_7"], }
    { x=544.000, y=664.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=136.000, y=760.000, tex=TEX_MAP["CITY4_7"], }
    { x=72.000, y=824.000, tex=TEX_MAP["CITY4_7"], }
    { x=0.000, y=824.000, tex=TEX_MAP["CITY4_7"], }
    { x=0.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { x=136.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-456.000, y=824.000, tex=TEX_MAP["CITY4_7"], }
    { x=-456.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { x=0.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { x=0.000, y=824.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-256.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-256.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-344.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-344.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=48.000, tex=TEX_MAP["CITY4_7"], }
    { b=-152.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-256.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-256.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-344.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-344.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=128.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-256.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-256.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-184.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-184.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-152.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-344.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-344.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-456.000, y=1176.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-456.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-152.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=664.000, tex=TEX_MAP["CITY4_7"], }
    { x=136.000, y=664.000, tex=TEX_MAP["CITY4_7"], }
    { x=136.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { x=0.000, y=688.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=136.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=448.000, y=664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=448.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=136.000, y=688.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=224.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-184.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-120.000, y=1144.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-120.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-184.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-8.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-152.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-160.000, y=1064.000, tex=TEX_MAP["METAL2_2"], }
    { x=-136.000, y=1064.000, tex=TEX_MAP["METAL2_2"], }
    { x=-136.000, y=1096.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=1096.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.00000, ny=-0.55470, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-136.000, y=1144.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=1144.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=1096.000, tex=TEX_MAP["METAL2_2"], }
    { x=-136.000, y=1096.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-136.000, y=1008.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=1008.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=-136.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-136.000, y=1008.000, tex=TEX_MAP["METAL2_2"], }
    { x=-136.000, y=1040.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=1040.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=1008.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=0.00000, ny=0.55470, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-136.000, y=1040.000, tex=TEX_MAP["METAL2_2"], }
    { x=-136.000, y=1064.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=1064.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=1040.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-32.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-80.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=-104.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=-104.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=-80.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-32.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-48.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=-48.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=-80.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=-80.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.55470, ny=0.00000, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-48.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=-48.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=-24.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=-24.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-160.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=-136.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=-136.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-104.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=-104.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=-136.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=-136.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=0.55470, ny=0.00000, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=32.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=32.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=0.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=0.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=0.55470, ny=0.00000, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-24.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=-24.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=0.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=0.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=88.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=88.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=112.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=112.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=88.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=88.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=56.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=56.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.55470, ny=0.00000, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=56.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=32.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=32.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=56.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-32.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=192.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=168.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=168.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-32.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=224.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=224.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.55470, ny=0.00000, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=224.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=224.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=248.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=248.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=112.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=112.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=136.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=136.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=168.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=168.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=136.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=136.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=0.55470, ny=0.00000, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=304.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=304.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=272.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=272.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=0.55470, ny=0.00000, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=248.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=248.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=272.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=272.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=360.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=360.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=384.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=384.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=360.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=360.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=328.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=328.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-53.333, tex=TEX_MAP["METAL2_2"], slope={ nx=-0.55470, ny=0.00000, nz=-0.83205 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=328.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=304.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=304.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=328.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-32.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=384.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=408.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=408.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { x=384.000, y=984.000, tex=TEX_MAP["METAL2_2"], }
    { t=-8.000, tex=TEX_MAP["METAL2_2"], }
    { b=-152.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-192.000, y=1088.000, tex=TEX_MAP["METAL2_2"], }
    { x=-192.000, y=1056.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=1056.000, tex=TEX_MAP["METAL2_2"], }
    { x=-160.000, y=1088.000, tex=TEX_MAP["METAL2_2"], }
    { t=32.000, tex=TEX_MAP["METAL2_2"], }
    { b=-24.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=288.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=320.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=320.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=288.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=32.000, tex=TEX_MAP["METAL2_2"], }
    { b=-24.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=160.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=192.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=160.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=32.000, tex=TEX_MAP["METAL2_2"], }
    { b=-24.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=32.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=64.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=64.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=32.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=32.000, tex=TEX_MAP["METAL2_2"], }
    { b=-24.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-104.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=-72.000, y=928.000, tex=TEX_MAP["METAL2_2"], }
    { x=-72.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { x=-104.000, y=960.000, tex=TEX_MAP["METAL2_2"], }
    { t=32.000, tex=TEX_MAP["METAL2_2"], }
    { b=-24.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=352.000, y=1348.000, tex=TEX_MAP["COP2_5"], }
    { x=512.000, y=1348.000, tex=TEX_MAP["COP2_5"], }
    { x=512.000, y=1372.000, tex=TEX_MAP["COP2_5"], }
    { x=352.000, y=1372.000, tex=TEX_MAP["COP2_5"], }
    { t=-16.000, tex=TEX_MAP["COP2_5"], }
    { b=-28.000, tex=TEX_MAP["COP2_5"], }
  }
  {
    { m="solid", }
    { x=480.000, y=1352.000, tex=TEX_MAP["COP1_6"], }
    { x=496.000, y=1352.000, tex=TEX_MAP["COP1_6"], }
    { x=496.000, y=1368.000, tex=TEX_MAP["COP1_6"], }
    { x=480.000, y=1368.000, tex=TEX_MAP["COP1_6"], }
    { t=-24.000, tex=TEX_MAP["COP1_6"], }
    { b=-144.000, tex=TEX_MAP["COP1_6"], }
  }
  {
    { m="solid", }
    { x=376.000, y=1352.000, tex=TEX_MAP["COP1_6"], }
    { x=392.000, y=1352.000, tex=TEX_MAP["COP1_6"], }
    { x=392.000, y=1368.000, tex=TEX_MAP["COP1_6"], }
    { x=376.000, y=1368.000, tex=TEX_MAP["COP1_6"], }
    { t=-24.000, tex=TEX_MAP["COP1_6"], }
    { b=-144.000, tex=TEX_MAP["COP1_6"], }
  }
  {
    { m="solid", }
    { x=252.000, y=1568.000, tex=TEX_MAP["COP1_6"], }
    { x=276.000, y=1568.000, tex=TEX_MAP["COP1_6"], }
    { x=276.000, y=1632.000, tex=TEX_MAP["COP1_6"], }
    { x=252.000, y=1632.000, tex=TEX_MAP["COP1_6"], }
    { t=-128.000, tex=TEX_MAP["COP1_6"], }
    { b=-136.000, tex=TEX_MAP["COP1_6"], }
  }
  {
    { m="solid", }
    { x=252.000, y=1568.000, tex=TEX_MAP["COP1_6"], }
    { x=276.000, y=1568.000, tex=TEX_MAP["COP1_6"], }
    { x=276.000, y=1632.000, tex=TEX_MAP["COP1_6"], }
    { x=252.000, y=1632.000, tex=TEX_MAP["COP1_6"], }
    { t=-24.000, tex=TEX_MAP["COP1_6"], }
    { b=-32.000, tex=TEX_MAP["COP1_6"], }
  }
  {
    { m="solid", }
    { x=252.000, y=1624.000, tex=TEX_MAP["COP1_6"], }
    { x=276.000, y=1624.000, tex=TEX_MAP["COP1_6"], }
    { x=276.000, y=1632.000, tex=TEX_MAP["COP1_6"], }
    { x=252.000, y=1632.000, tex=TEX_MAP["COP1_6"], }
    { t=-24.000, tex=TEX_MAP["COP1_6"], }
    { b=-136.000, tex=TEX_MAP["COP1_6"], }
  }
  {
    { m="solid", }
    { x=252.000, y=1568.000, tex=TEX_MAP["COP1_6"], }
    { x=276.000, y=1568.000, tex=TEX_MAP["COP1_6"], }
    { x=276.000, y=1576.000, tex=TEX_MAP["COP1_6"], }
    { x=252.000, y=1576.000, tex=TEX_MAP["COP1_6"], }
    { t=-24.000, tex=TEX_MAP["COP1_6"], }
    { b=-136.000, tex=TEX_MAP["COP1_6"], }
  }
  {
    { m="solid", }
    { x=264.000, y=1576.000, tex=TEX_MAP["*TELEPORT"], }
    { x=268.000, y=1576.000, tex=TEX_MAP["*TELEPORT"], }
    { x=268.000, y=1624.000, tex=TEX_MAP["*TELEPORT"], }
    { x=264.000, y=1624.000, tex=TEX_MAP["*TELEPORT"], }
    { t=-28.000, tex=TEX_MAP["*TELEPORT"], }
    { b=-132.000, tex=TEX_MAP["*TELEPORT"], }
  }
  {
    { m="solid", }
    { x=192.000, y=1536.000, tex=TEX_MAP["CITY4_7"], }
    { x=208.000, y=1536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=208.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { x=192.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-144.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-184.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-184.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=384.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=176.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=176.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=288.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-148.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=68.000, y=1344.000, tex=TEX_MAP["METAL1_3"], }
    { x=156.000, y=1344.000, tex=TEX_MAP["METAL1_3"], }
    { x=156.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=68.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { t=-40.000, tex=TEX_MAP["METAL1_3"], }
    { b=-44.000, tex=TEX_MAP["METAL1_3"], }
  }
--    @@@@ FIX BRUSH @ line:2623 @@@@
--    @@@@ FIX BRUSH @ line:2631 @@@@
--    @@@@ FIX BRUSH @ line:2639 @@@@
--    @@@@ FIX BRUSH @ line:2646 @@@@
  {
    { m="solid", xxdetail=3, }
    { x=48.000, y=1344.000, tex=TEX_MAP["METAL1_3"], }
    { x=52.000, y=1344.000, tex=TEX_MAP["METAL1_3"], }
    { x=52.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=48.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { t=-56.000, tex=TEX_MAP["METAL1_3"], }
    { b=-144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=172.000, y=1344.000, tex=TEX_MAP["METAL1_3"], }
    { x=176.000, y=1344.000, tex=TEX_MAP["METAL1_3"], }
    { x=176.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=172.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { t=-56.000, tex=TEX_MAP["METAL1_3"], }
    { b=-144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=48.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=208.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=208.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=48.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=272.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-40.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=416.000, y=1672.000, tex=TEX_MAP["DUNG02_5"], }
    { x=480.000, y=1672.000, tex=TEX_MAP["DUNG02_5"], }
    { x=480.000, y=1680.000, tex=TEX_MAP["DUNG02_5"], }
    { x=416.000, y=1680.000, tex=TEX_MAP["DUNG02_5"], }
    { t=192.000, tex=TEX_MAP["DUNG02_5"], }
    { b=64.000, tex=TEX_MAP["DUNG02_5"], }
  }
  {
    { m="solid", detail=1, }
    { x=-160.000, y=1632.000, tex=TEX_MAP["METAL1_3"], }
    { x=-160.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=-192.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=-192.000, y=1632.000, tex=TEX_MAP["METAL1_3"], }
    { t=208.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", detail=1, }
    { x=256.000, y=1632.000, tex=TEX_MAP["METAL1_3"], }
    { x=256.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=224.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=224.000, y=1632.000, tex=TEX_MAP["METAL1_3"], }
    { t=208.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", detail=1, }
    { x=256.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=256.000, y=1392.000, tex=TEX_MAP["METAL1_3"], }
    { x=224.000, y=1392.000, tex=TEX_MAP["METAL1_3"], }
    { x=224.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { t=208.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", detail=1, }
    { x=-160.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { x=-160.000, y=1392.000, tex=TEX_MAP["METAL1_3"], }
    { x=-192.000, y=1392.000, tex=TEX_MAP["METAL1_3"], }
    { x=-192.000, y=1360.000, tex=TEX_MAP["METAL1_3"], }
    { t=208.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=-328.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=48.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=48.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-328.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-328.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-304.000, y=1536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-328.000, y=1536.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-128.000, y=1472.000, tex=TEX_MAP["ROOF2"], }
    { x=224.000, y=1472.000, tex=TEX_MAP["ROOF2"], }
    { x=224.000, y=1536.000, tex=TEX_MAP["ROOF2"], }
    { x=-128.000, y=1536.000, tex=TEX_MAP["ROOF2"], }
    { t=272.000, tex=TEX_MAP["ROOF2"], }
    { b=256.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", detail=1, }
    { x=480.000, y=1568.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1568.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1600.000, tex=TEX_MAP["METAL1_3"], }
    { x=480.000, y=1600.000, tex=TEX_MAP["METAL1_3"], }
    { t=208.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=224.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=288.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=288.000, y=1536.000, tex=TEX_MAP["ROOF"], }
    { x=224.000, y=1536.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=-192.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=-64.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=-64.000, y=1536.000, tex=TEX_MAP["ROOF"], }
    { x=-192.000, y=1536.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=-192.000, y=1408.000, tex=TEX_MAP["ROOF"], }
    { x=288.000, y=1408.000, tex=TEX_MAP["ROOF"], }
    { x=288.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=-192.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=-192.000, y=1536.000, tex=TEX_MAP["ROOF"], }
    { x=288.000, y=1536.000, tex=TEX_MAP["ROOF"], }
    { x=288.000, y=1600.000, tex=TEX_MAP["ROOF"], }
    { x=-192.000, y=1600.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=288.000, y=1408.000, tex=TEX_MAP["ROOF2"], }
    { x=352.000, y=1408.000, tex=TEX_MAP["ROOF2"], }
    { x=352.000, y=1600.000, tex=TEX_MAP["ROOF2"], }
    { x=288.000, y=1600.000, tex=TEX_MAP["ROOF2"], }
    { t=272.000, tex=TEX_MAP["ROOF2"], }
    { b=256.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=-304.000, y=1360.000, tex=TEX_MAP["ROOF2"], }
    { x=352.000, y=1360.000, tex=TEX_MAP["ROOF2"], }
    { x=352.000, y=1408.000, tex=TEX_MAP["ROOF2"], }
    { x=-304.000, y=1408.000, tex=TEX_MAP["ROOF2"], }
    { t=272.000, tex=TEX_MAP["ROOF2"], }
    { b=256.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=-304.000, y=1408.000, tex=TEX_MAP["ROOF2"], }
    { x=-176.000, y=1408.000, tex=TEX_MAP["ROOF2"], }
    { x=-176.000, y=1600.000, tex=TEX_MAP["ROOF2"], }
    { x=-304.000, y=1600.000, tex=TEX_MAP["ROOF2"], }
    { t=272.000, tex=TEX_MAP["ROOF2"], }
    { b=256.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=-304.000, y=1600.000, tex=TEX_MAP["ROOF2"], }
    { x=352.000, y=1600.000, tex=TEX_MAP["ROOF2"], }
    { x=352.000, y=1696.000, tex=TEX_MAP["ROOF2"], }
    { x=-304.000, y=1696.000, tex=TEX_MAP["ROOF2"], }
    { t=272.000, tex=TEX_MAP["ROOF2"], }
    { b=256.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=320.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=320.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-16.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-64.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1472.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1536.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-64.000, y=1536.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=-16.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", detail=1, }
    { x=16.000, y=1376.000, tex=TEX_MAP["XX"], }
    { x=320.000, y=1376.000, tex=TEX_MAP["XX"], }
    { x=320.000, y=1392.000, tex=TEX_MAP["XX"], }
    { x=16.000, y=1392.000, tex=TEX_MAP["XX"], }
    { t=-4.000, tex=TEX_MAP["XX"], }
    { b=-12.000, tex=TEX_MAP["XX"], }
  }
  {
    { m="solid", detail=1, }
    { x=16.000, y=1424.000, tex=TEX_MAP["XX"], }
    { x=320.000, y=1424.000, tex=TEX_MAP["XX"], }
    { x=320.000, y=1440.000, tex=TEX_MAP["XX"], }
    { x=16.000, y=1440.000, tex=TEX_MAP["XX"], }
    { t=-4.000, tex=TEX_MAP["XX"], }
    { b=-12.000, tex=TEX_MAP["XX"], }
  }
  {
    { m="solid", detail=1, }
    { x=-64.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=16.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=16.000, y=1472.000, tex=TEX_MAP["CITY4_7"], }
    { x=-64.000, y=1472.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", detail=1, }
    { x=48.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=64.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=64.000, y=1472.000, tex=TEX_MAP["XX"], }
    { x=48.000, y=1472.000, tex=TEX_MAP["XX"], }
    { t=0.000, tex=TEX_MAP["XX"], }
    { b=-16.000, tex=TEX_MAP["XX"], }
  }
  {
    { m="solid", detail=1, }
    { x=96.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=112.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=112.000, y=1472.000, tex=TEX_MAP["XX"], }
    { x=96.000, y=1472.000, tex=TEX_MAP["XX"], }
    { t=0.000, tex=TEX_MAP["XX"], }
    { b=-16.000, tex=TEX_MAP["XX"], }
  }
  {
    { m="solid", detail=1, }
    { x=144.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=160.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=160.000, y=1472.000, tex=TEX_MAP["XX"], }
    { x=144.000, y=1472.000, tex=TEX_MAP["XX"], }
    { t=0.000, tex=TEX_MAP["XX"], }
    { b=-16.000, tex=TEX_MAP["XX"], }
  }
  {
    { m="solid", detail=1, }
    { x=192.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=208.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=208.000, y=1472.000, tex=TEX_MAP["XX"], }
    { x=192.000, y=1472.000, tex=TEX_MAP["XX"], }
    { t=0.000, tex=TEX_MAP["XX"], }
    { b=-16.000, tex=TEX_MAP["XX"], }
  }
  {
    { m="solid", detail=1, }
    { x=240.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=256.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=256.000, y=1472.000, tex=TEX_MAP["XX"], }
    { x=240.000, y=1472.000, tex=TEX_MAP["XX"], }
    { t=0.000, tex=TEX_MAP["XX"], }
    { b=-16.000, tex=TEX_MAP["XX"], }
  }
  {
    { m="solid", detail=1, }
    { x=288.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=304.000, y=1344.000, tex=TEX_MAP["XX"], }
    { x=304.000, y=1472.000, tex=TEX_MAP["XX"], }
    { x=288.000, y=1472.000, tex=TEX_MAP["XX"], }
    { t=0.000, tex=TEX_MAP["XX"], }
    { b=-16.000, tex=TEX_MAP["XX"], }
  }
  {
    { m="solid", }
    { x=320.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=352.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=352.000, y=1472.000, tex=TEX_MAP["CITY4_7"], }
    { x=320.000, y=1472.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=232.000, y=528.000, tex=TEX_MAP["CITY4_7"], }
    { x=232.000, y=592.000, tex=TEX_MAP["CITY4_7"], }
    { x=208.000, y=592.000, tex=TEX_MAP["CITY4_7"], }
    { x=208.000, y=528.000, tex=TEX_MAP["CITY4_7"], }
    { t=-144.000, tex=TEX_MAP["CITY4_7"], }
    { b=-160.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=544.000, y=608.000, tex=TEX_MAP["CITY4_7"], }
    { x=232.000, y=608.000, tex=TEX_MAP["CITY4_7"], }
    { x=232.000, y=528.000, tex=TEX_MAP["CITY4_7"], }
    { x=544.000, y=528.000, tex=TEX_MAP["CITY4_7"], }
    { t=-144.000, tex=TEX_MAP["CITY4_7"], }
    { b=-160.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=208.000, y=1696.000, tex=TEX_MAP["CITY4_7"], }
    { x=208.000, y=608.000, tex=TEX_MAP["CITY4_7"], }
    { x=544.000, y=608.000, tex=TEX_MAP["CITY4_7"], }
    { x=544.000, y=1696.000, tex=TEX_MAP["CITY4_7"], }
    { t=-144.000, tex=TEX_MAP["CITY4_7"], }
    { b=-160.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=208.000, y=528.000, tex=TEX_MAP["CITY4_7"], }
    { x=208.000, y=1360.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-720.000, y=1360.000, tex=TEX_MAP["CITY4_7"], }
    { x=-720.000, y=528.000, tex=TEX_MAP["CITY4_7"], }
    { t=-144.000, tex=TEX_MAP["CITY4_7"], }
    { b=-160.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=-224.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=320.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=320.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { x=-224.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { t=-144.000, tex=TEX_MAP["CITY4_7"], }
    { b=-160.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=480.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=480.000, y=1680.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=416.000, y=1680.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=416.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=64.000, tex=TEX_MAP["DUNG02_1"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=480.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=480.000, y=1680.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=416.000, y=1680.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=416.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=192.000, tex=TEX_MAP["DUNG02_1"], }
  }
  {
    { m="solid", }
    { x=544.000, y=1680.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=480.000, y=1680.000, tex=TEX_MAP["DUNG02_1"], }
    { x=480.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=416.000, y=1696.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=416.000, y=1680.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1680.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1696.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=416.000, y=1664.000, tex=TEX_MAP["DUNG02_1"], }
    { x=416.000, y=1696.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-720.000, y=1696.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-720.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-64.000, y=1472.000, tex=TEX_MAP["CITY4_7"], }
    { x=192.000, y=1472.000, tex=TEX_MAP["CITY4_7"], }
    { x=192.000, y=1536.000, tex=TEX_MAP["CITY4_7"], }
    { x=-64.000, y=1536.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["CITY4_7"], }
  }
  {
    { m="solid", }
    { x=352.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1696.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1696.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=304.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=192.000, y=1472.000, tex=TEX_MAP["CITY4_7"], }
    { x=352.000, y=1472.000, tex=TEX_MAP["CITY4_7"], }
    { x=352.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { x=192.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-64.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=-32.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=-32.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=-64.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { t=-128.000, tex=TEX_MAP["METAL1_3"], }
    { b=-144.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-32.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=0.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=0.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=-32.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { t=-112.000, tex=TEX_MAP["METAL1_3"], }
    { b=-128.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=0.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=32.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=32.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=0.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { t=-96.000, tex=TEX_MAP["METAL1_3"], }
    { b=-112.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=32.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=64.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=64.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=32.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { t=-80.000, tex=TEX_MAP["METAL1_3"], }
    { b=-96.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=64.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=96.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=96.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=64.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { t=-64.000, tex=TEX_MAP["METAL1_3"], }
    { b=-80.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=96.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=128.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=128.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=96.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { t=-48.000, tex=TEX_MAP["METAL1_3"], }
    { b=-64.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=128.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=160.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=160.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=128.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { t=-32.000, tex=TEX_MAP["METAL1_3"], }
    { b=-48.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=160.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=192.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=192.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { x=160.000, y=1664.000, tex=TEX_MAP["METAL1_3"], }
    { t=-16.000, tex=TEX_MAP["METAL1_3"], }
    { b=-32.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=352.000, y=1504.000, tex=TEX_MAP["CITY4_7"], }
    { x=384.000, y=1504.000, tex=TEX_MAP["CITY4_7"], }
    { x=384.000, y=1632.000, tex=TEX_MAP["CITY4_7"], }
    { x=352.000, y=1632.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", detail=1, }
    { x=480.000, y=1440.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1440.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { x=480.000, y=1472.000, tex=TEX_MAP["METAL1_3"], }
    { t=208.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", detail=1, }
    { x=480.000, y=1312.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1312.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1344.000, tex=TEX_MAP["METAL1_3"], }
    { x=480.000, y=1344.000, tex=TEX_MAP["METAL1_3"], }
    { t=208.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=416.000, y=1600.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1600.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1632.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1632.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=384.000, y=1600.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1600.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1632.000, tex=TEX_MAP["ROOF"], }
    { x=384.000, y=1632.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=480.000, y=1600.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=1600.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=1632.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1632.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=-0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=416.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1504.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1504.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=384.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1504.000, tex=TEX_MAP["ROOF"], }
    { x=384.000, y=1504.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=480.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=1472.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=1504.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1504.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=-0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=416.000, y=1376.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1376.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1408.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1408.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=384.000, y=1376.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1376.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1408.000, tex=TEX_MAP["ROOF"], }
    { x=384.000, y=1408.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=480.000, y=1376.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=1376.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=1408.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1408.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=-0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=480.000, y=992.000, tex=TEX_MAP["ROOF2"], }
    { x=512.000, y=992.000, tex=TEX_MAP["ROOF2"], }
    { x=512.000, y=1664.000, tex=TEX_MAP["ROOF2"], }
    { x=480.000, y=1664.000, tex=TEX_MAP["ROOF2"], }
    { t=304.000, tex=TEX_MAP["ROOF2"], slope={ nx=0.70711, ny=-0.00000, nz=0.70711 }, }
    { b=256.000, tex=TEX_MAP["ROOF2"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=416.000, y=992.000, tex=TEX_MAP["ROOF2"], }
    { x=480.000, y=992.000, tex=TEX_MAP["ROOF2"], }
    { x=480.000, y=1664.000, tex=TEX_MAP["ROOF2"], }
    { x=416.000, y=1664.000, tex=TEX_MAP["ROOF2"], }
    { t=304.000, tex=TEX_MAP["ROOF2"], }
    { b=288.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=384.000, y=992.000, tex=TEX_MAP["ROOF2"], }
    { x=416.000, y=992.000, tex=TEX_MAP["ROOF2"], }
    { x=416.000, y=1664.000, tex=TEX_MAP["ROOF2"], }
    { x=384.000, y=1664.000, tex=TEX_MAP["ROOF2"], }
    { t=304.000, tex=TEX_MAP["ROOF2"], slope={ nx=-0.70711, ny=0.00000, nz=0.70711 }, }
    { b=256.000, tex=TEX_MAP["ROOF2"], slope={ nx=0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=352.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1504.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1504.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=352.000, y=1632.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1632.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=352.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=512.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=512.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { x=352.000, y=1664.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=352.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1600.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1600.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=152.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1536.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1504.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1504.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=136.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=352.000, y=1600.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1600.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1632.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1632.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=136.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=352.000, y=1624.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1624.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1632.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1632.000, tex=TEX_MAP["METAL1_3"], }
    { t=144.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=352.000, y=1504.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1504.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1512.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1512.000, tex=TEX_MAP["METAL1_3"], }
    { t=144.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
--    @@@@ FIX BRUSH @ line:3261 @@@@
--    @@@@ FIX BRUSH @ line:3268 @@@@
  {
    { m="solid", }
    { x=352.000, y=1504.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1504.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1632.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1632.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=160.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=352.000, y=1120.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1120.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1184.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1184.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], }
    { b=152.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=1120.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1120.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1088.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1088.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=136.000, tex=TEX_MAP["METAL1_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=352.000, y=1184.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1184.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1216.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1216.000, tex=TEX_MAP["METAL1_3"], }
    { t=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=136.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", xxdetail=3, }
    { x=352.000, y=1208.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1208.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1216.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1216.000, tex=TEX_MAP["METAL1_3"], }
    { t=144.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=352.000, y=1088.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1088.000, tex=TEX_MAP["METAL1_3"], }
    { x=384.000, y=1096.000, tex=TEX_MAP["METAL1_3"], }
    { x=352.000, y=1096.000, tex=TEX_MAP["METAL1_3"], }
    { t=144.000, tex=TEX_MAP["METAL1_3"], }
    { b=0.000, tex=TEX_MAP["METAL1_3"], }
  }
--    @@@@ FIX BRUSH @ line:3323 @@@@
--    @@@@ FIX BRUSH @ line:3330 @@@@
  {
    { m="solid", }
    { x=352.000, y=1088.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1088.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=160.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=512.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1384.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=544.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1664.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=320.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=-144.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=416.000, y=1280.000, tex=TEX_MAP["COP1_7"], }
    { x=480.000, y=1280.000, tex=TEX_MAP["COP1_7"], }
    { x=480.000, y=1344.000, tex=TEX_MAP["COP1_7"], }
    { x=416.000, y=1344.000, tex=TEX_MAP["COP1_7"], }
    { t=-4.000, tex=TEX_MAP["COP1_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=480.000, y=1280.000, tex=TEX_MAP["CITY4_7"], }
    { x=512.000, y=1280.000, tex=TEX_MAP["CITY4_7"], }
    { x=512.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=480.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=384.000, y=1280.000, tex=TEX_MAP["CITY4_7"], }
    { x=416.000, y=1280.000, tex=TEX_MAP["CITY4_7"], }
    { x=416.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=384.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=376.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=376.000, y=1280.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", detail=1, }
    { x=480.000, y=1184.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1184.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1216.000, tex=TEX_MAP["METAL1_3"], }
    { x=480.000, y=1216.000, tex=TEX_MAP["METAL1_3"], }
    { t=208.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", detail=1, }
    { x=480.000, y=1056.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1056.000, tex=TEX_MAP["METAL1_3"], }
    { x=512.000, y=1088.000, tex=TEX_MAP["METAL1_3"], }
    { x=480.000, y=1088.000, tex=TEX_MAP["METAL1_3"], }
    { t=208.000, tex=TEX_MAP["METAL1_3"], }
    { b=160.000, tex=TEX_MAP["METAL1_3"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=416.000, y=1248.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1248.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1280.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1280.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=384.000, y=1248.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1248.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1280.000, tex=TEX_MAP["ROOF"], }
    { x=384.000, y=1280.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=480.000, y=1248.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=1248.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=1280.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1280.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=-0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=416.000, y=1120.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1120.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1152.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1152.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=384.000, y=1120.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1120.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=1152.000, tex=TEX_MAP["ROOF"], }
    { x=384.000, y=1152.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=480.000, y=1120.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=1120.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=1152.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=1152.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=-0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=416.000, y=960.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=960.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=384.000, y=960.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=960.000, tex=TEX_MAP["ROOF"], }
    { x=416.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { x=384.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=480.000, y=960.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=960.000, tex=TEX_MAP["ROOF"], }
    { x=512.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { x=480.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { t=288.000, tex=TEX_MAP["ROOF"], slope={ nx=0.70711, ny=-0.00000, nz=0.70711 }, }
    { b=240.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.70711, ny=-0.00000, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=384.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=304.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=256.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=384.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=512.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=192.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=208.000, y=936.000, tex=TEX_MAP["CITY4_7"], }
    { x=208.000, y=1096.000, tex=TEX_MAP["CITY4_7"], }
    { x=96.000, y=1096.000, tex=TEX_MAP["CITY4_7"], }
    { x=96.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=384.000, y=1208.000, tex=TEX_MAP["CITY4_7"], }
    { x=208.000, y=1208.000, tex=TEX_MAP["CITY4_7"], }
    { x=208.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=936.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=96.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=96.000, y=1208.000, tex=TEX_MAP["CITY4_7"], }
    { x=384.000, y=1208.000, tex=TEX_MAP["CITY4_7"], }
    { x=384.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=96.000, y=936.000, tex=TEX_MAP["CITY4_7"], }
    { x=96.000, y=1344.000, tex=TEX_MAP["CITY4_7"], }
    { x=-184.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-184.000, y=936.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=0.000, tex=TEX_MAP["CITY4_7"], }
    { b=-16.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-76.000, y=1056.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-28.000, y=1056.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-28.000, y=1064.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-76.000, y=1064.000, tex=TEX_MAP["DUNG01_3"], }
    { t=192.000, tex=TEX_MAP["DUNG01_3"], }
    { b=168.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-76.000, y=1056.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-28.000, y=1056.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-28.000, y=1064.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-76.000, y=1064.000, tex=TEX_MAP["DUNG01_3"], }
    { t=48.000, tex=TEX_MAP["DUNG01_3"], }
    { b=24.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-28.000, y=1056.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1056.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1072.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-28.000, y=1072.000, tex=TEX_MAP["DUNG01_3"], }
    { t=192.000, tex=TEX_MAP["DUNG01_3"], }
    { b=24.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-84.000, y=1056.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-76.000, y=1056.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-76.000, y=1072.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1072.000, tex=TEX_MAP["DUNG01_3"], }
    { t=192.000, tex=TEX_MAP["DUNG01_3"], }
    { b=24.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-84.000, y=1072.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1072.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1088.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1088.000, tex=TEX_MAP["DUNG01_3"], }
    { t=192.000, tex=TEX_MAP["DUNG01_3"], }
    { b=24.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-76.000, y=1064.000, tex=TEX_MAP["DUNG02_5"], }
    { x=-28.000, y=1064.000, tex=TEX_MAP["DUNG02_5"], }
    { x=-28.000, y=1072.000, tex=TEX_MAP["DUNG02_5"], }
    { x=-76.000, y=1072.000, tex=TEX_MAP["DUNG02_5"], }
    { t=192.000, tex=TEX_MAP["DUNG02_5"], }
    { b=24.000, tex=TEX_MAP["DUNG02_5"], }
  }
  {
    { m="solid", }
    { x=-20.000, y=1072.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1072.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1056.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1056.000, tex=TEX_MAP["DUNG01_3"], }
    { t=216.000, tex=TEX_MAP["DUNG01_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=192.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-84.000, y=1072.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1072.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1088.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1088.000, tex=TEX_MAP["DUNG01_3"], }
    { t=216.000, tex=TEX_MAP["DUNG01_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=192.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-28.000, y=1248.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-76.000, y=1248.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-76.000, y=1240.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-28.000, y=1240.000, tex=TEX_MAP["DUNG01_3"], }
    { t=192.000, tex=TEX_MAP["DUNG01_3"], }
    { b=168.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-28.000, y=1248.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-76.000, y=1248.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-76.000, y=1240.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-28.000, y=1240.000, tex=TEX_MAP["DUNG01_3"], }
    { t=48.000, tex=TEX_MAP["DUNG01_3"], }
    { b=24.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-20.000, y=1248.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-28.000, y=1248.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-28.000, y=1232.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1232.000, tex=TEX_MAP["DUNG01_3"], }
    { t=192.000, tex=TEX_MAP["DUNG01_3"], }
    { b=24.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-76.000, y=1248.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1248.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1232.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-76.000, y=1232.000, tex=TEX_MAP["DUNG01_3"], }
    { t=192.000, tex=TEX_MAP["DUNG01_3"], }
    { b=24.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-20.000, y=1232.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1232.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1216.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1216.000, tex=TEX_MAP["DUNG01_3"], }
    { t=192.000, tex=TEX_MAP["DUNG01_3"], }
    { b=24.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-28.000, y=1240.000, tex=TEX_MAP["DUNG02_5"], }
    { x=-76.000, y=1240.000, tex=TEX_MAP["DUNG02_5"], }
    { x=-76.000, y=1232.000, tex=TEX_MAP["DUNG02_5"], }
    { x=-28.000, y=1232.000, tex=TEX_MAP["DUNG02_5"], }
    { t=192.000, tex=TEX_MAP["DUNG02_5"], }
    { b=24.000, tex=TEX_MAP["DUNG02_5"], }
  }
  {
    { m="solid", }
    { x=-84.000, y=1232.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1232.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1248.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1248.000, tex=TEX_MAP["DUNG01_3"], }
    { t=216.000, tex=TEX_MAP["DUNG01_3"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=192.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-20.000, y=1232.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1232.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-84.000, y=1216.000, tex=TEX_MAP["DUNG01_3"], }
    { x=-20.000, y=1216.000, tex=TEX_MAP["DUNG01_3"], }
    { t=216.000, tex=TEX_MAP["DUNG01_3"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=192.000, tex=TEX_MAP["DUNG01_3"], }
  }
  {
    { m="solid", }
    { x=-108.000, y=1032.000, tex=TEX_MAP["DUNG01_2"], }
    { x=4.000, y=1032.000, tex=TEX_MAP["DUNG01_2"], }
    { x=4.000, y=1272.000, tex=TEX_MAP["DUNG01_2"], }
    { x=-108.000, y=1272.000, tex=TEX_MAP["DUNG01_2"], }
    { t=16.000, tex=TEX_MAP["DUNG01_2"], }
    { b=0.000, tex=TEX_MAP["DUNG01_2"], }
  }
  {
    { m="solid", }
    { x=-108.000, y=1024.000, tex=TEX_MAP["DUNG01_4"], }
    { x=4.000, y=1024.000, tex=TEX_MAP["DUNG01_4"], }
    { x=4.000, y=1032.000, tex=TEX_MAP["DUNG01_4"], }
    { x=-108.000, y=1032.000, tex=TEX_MAP["DUNG01_4"], }
    { t=16.000, tex=TEX_MAP["DUNG01_4"], }
    { b=0.000, tex=TEX_MAP["DUNG01_4"], }
  }
  {
    { m="solid", }
    { x=-108.000, y=1272.000, tex=TEX_MAP["DUNG01_4"], }
    { x=4.000, y=1272.000, tex=TEX_MAP["DUNG01_4"], }
    { x=4.000, y=1280.000, tex=TEX_MAP["DUNG01_4"], }
    { x=-108.000, y=1280.000, tex=TEX_MAP["DUNG01_4"], }
    { t=16.000, tex=TEX_MAP["DUNG01_4"], }
    { b=0.000, tex=TEX_MAP["DUNG01_4"], }
  }
  {
    { m="solid", }
    { x=-116.000, y=1024.000, tex=TEX_MAP["DUNG01_4"], }
    { x=-108.000, y=1024.000, tex=TEX_MAP["DUNG01_4"], }
    { x=-108.000, y=1280.000, tex=TEX_MAP["DUNG01_4"], }
    { x=-116.000, y=1280.000, tex=TEX_MAP["DUNG01_4"], }
    { t=16.000, tex=TEX_MAP["DUNG01_4"], }
    { b=0.000, tex=TEX_MAP["DUNG01_4"], }
  }
  {
    { m="solid", }
    { x=4.000, y=1024.000, tex=TEX_MAP["DUNG01_4"], }
    { x=12.000, y=1024.000, tex=TEX_MAP["DUNG01_4"], }
    { x=12.000, y=1280.000, tex=TEX_MAP["DUNG01_4"], }
    { x=4.000, y=1280.000, tex=TEX_MAP["DUNG01_4"], }
    { t=16.000, tex=TEX_MAP["DUNG01_4"], }
    { b=0.000, tex=TEX_MAP["DUNG01_4"], }
  }
  {
    { m="solid", }
    { x=-76.000, y=1088.000, tex=TEX_MAP["DUNG01_5"], }
    { x=-28.000, y=1088.000, tex=TEX_MAP["DUNG01_5"], }
    { x=-28.000, y=1216.000, tex=TEX_MAP["DUNG01_5"], }
    { x=-76.000, y=1216.000, tex=TEX_MAP["DUNG01_5"], }
    { t=192.000, tex=TEX_MAP["DUNG01_5"], }
    { b=176.000, tex=TEX_MAP["DUNG01_5"], }
  }
  {
    { m="solid", }
    { x=-76.000, y=1088.000, tex=TEX_MAP["DUNG01_5"], }
    { x=-28.000, y=1088.000, tex=TEX_MAP["DUNG01_5"], }
    { x=-28.000, y=1216.000, tex=TEX_MAP["DUNG01_5"], }
    { x=-76.000, y=1216.000, tex=TEX_MAP["DUNG01_5"], }
    { t=48.000, tex=TEX_MAP["DUNG01_5"], }
    { b=16.000, tex=TEX_MAP["DUNG01_5"], }
  }
  {
    { m="solid", }
    { x=-68.000, y=1088.000, tex=TEX_MAP["DUNG01_1"], }
    { x=-36.000, y=1088.000, tex=TEX_MAP["DUNG01_1"], }
    { x=-36.000, y=1216.000, tex=TEX_MAP["DUNG01_1"], }
    { x=-68.000, y=1216.000, tex=TEX_MAP["DUNG01_1"], }
    { t=192.000, tex=TEX_MAP["DUNG01_5"], }
    { b=16.000, tex=TEX_MAP["DUNG01_1"], }
  }
  {
    { m="solid", }
    { x=-100.000, y=1040.000, tex=TEX_MAP["DUNG01_5"], }
    { x=-4.000, y=1040.000, tex=TEX_MAP["DUNG01_5"], }
    { x=-4.000, y=1264.000, tex=TEX_MAP["DUNG01_5"], }
    { x=-100.000, y=1264.000, tex=TEX_MAP["DUNG01_5"], }
    { t=24.000, tex=TEX_MAP["DUNG01_5"], }
    { b=16.000, tex=TEX_MAP["DUNG01_5"], }
  }
  {
    { m="solid", }
    { x=352.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1088.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1088.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=352.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1216.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=352.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-184.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-96.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-96.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-184.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=288.000, y=992.000, tex=TEX_MAP["METAL2_2"], }
    { x=320.000, y=992.000, tex=TEX_MAP["METAL2_2"], }
    { x=320.000, y=1008.000, tex=TEX_MAP["METAL2_2"], }
    { x=288.000, y=1008.000, tex=TEX_MAP["METAL2_2"], }
    { t=256.000, tex=TEX_MAP["METAL2_2"], }
    { b=0.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=112.000, y=992.000, tex=TEX_MAP["METAL2_2"], }
    { x=144.000, y=992.000, tex=TEX_MAP["METAL2_2"], }
    { x=144.000, y=1008.000, tex=TEX_MAP["METAL2_2"], }
    { x=112.000, y=1008.000, tex=TEX_MAP["METAL2_2"], }
    { t=256.000, tex=TEX_MAP["METAL2_2"], }
    { b=0.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-64.000, y=992.000, tex=TEX_MAP["METAL2_2"], }
    { x=-32.000, y=992.000, tex=TEX_MAP["METAL2_2"], }
    { x=-32.000, y=1008.000, tex=TEX_MAP["METAL2_2"], }
    { x=-64.000, y=1008.000, tex=TEX_MAP["METAL2_2"], }
    { t=256.000, tex=TEX_MAP["METAL2_2"], }
    { b=0.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=-64.000, y=1296.000, tex=TEX_MAP["METAL2_2"], }
    { x=-32.000, y=1296.000, tex=TEX_MAP["METAL2_2"], }
    { x=-32.000, y=1312.000, tex=TEX_MAP["METAL2_2"], }
    { x=-64.000, y=1312.000, tex=TEX_MAP["METAL2_2"], }
    { t=256.000, tex=TEX_MAP["METAL2_2"], }
    { b=0.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=112.000, y=1296.000, tex=TEX_MAP["METAL2_2"], }
    { x=144.000, y=1296.000, tex=TEX_MAP["METAL2_2"], }
    { x=144.000, y=1312.000, tex=TEX_MAP["METAL2_2"], }
    { x=112.000, y=1312.000, tex=TEX_MAP["METAL2_2"], }
    { t=256.000, tex=TEX_MAP["METAL2_2"], }
    { b=0.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", xxdetail=3, }
    { x=288.000, y=1296.000, tex=TEX_MAP["METAL2_2"], }
    { x=320.000, y=1296.000, tex=TEX_MAP["METAL2_2"], }
    { x=320.000, y=1312.000, tex=TEX_MAP["METAL2_2"], }
    { x=288.000, y=1312.000, tex=TEX_MAP["METAL2_2"], }
    { t=256.000, tex=TEX_MAP["METAL2_2"], }
    { b=0.000, tex=TEX_MAP["METAL2_2"], }
  }
  {
    { m="solid", }
    { x=-128.000, y=1088.000, tex=TEX_MAP["ROOF2"], }
    { x=-64.000, y=1088.000, tex=TEX_MAP["ROOF2"], }
    { x=-64.000, y=1216.000, tex=TEX_MAP["ROOF2"], }
    { x=-128.000, y=1216.000, tex=TEX_MAP["ROOF2"], }
    { t=272.000, tex=TEX_MAP["ROOF2"], }
    { b=256.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=320.000, y=1088.000, tex=TEX_MAP["ROOF2"], }
    { x=384.000, y=1088.000, tex=TEX_MAP["ROOF2"], }
    { x=384.000, y=1216.000, tex=TEX_MAP["ROOF2"], }
    { x=320.000, y=1216.000, tex=TEX_MAP["ROOF2"], }
    { t=272.000, tex=TEX_MAP["ROOF2"], }
    { b=256.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=-96.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=-64.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=-64.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { x=-96.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=320.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=352.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=352.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { x=320.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=-128.000, y=1056.000, tex=TEX_MAP["ROOF"], }
    { x=384.000, y=1056.000, tex=TEX_MAP["ROOF"], }
    { x=384.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=-128.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=-128.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { x=384.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { x=384.000, y=1248.000, tex=TEX_MAP["ROOF"], }
    { x=-128.000, y=1248.000, tex=TEX_MAP["ROOF"], }
    { t=320.000, tex=TEX_MAP["ROOF"], }
    { b=272.000, tex=TEX_MAP["ROOF"], }
  }
  {
    { m="solid", }
    { x=-128.000, y=1088.000, tex=TEX_MAP["ROOF2"], }
    { x=384.000, y=1088.000, tex=TEX_MAP["ROOF2"], }
    { x=384.000, y=1216.000, tex=TEX_MAP["ROOF2"], }
    { x=-128.000, y=1216.000, tex=TEX_MAP["ROOF2"], }
    { t=336.000, tex=TEX_MAP["ROOF2"], }
    { b=320.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=0.000, y=976.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=64.000, y=976.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=64.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=192.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=192.000, y=976.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=256.000, y=976.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=256.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=192.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=192.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=976.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=64.000, y=976.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=64.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=64.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=192.000, y=976.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=256.000, y=976.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=256.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=192.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=64.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=192.000, y=960.000, tex=TEX_MAP["BODIESA3_3"], }
    { x=256.000, y=960.000, tex=TEX_MAP["BODIESA3_3"], }
    { x=256.000, y=976.000, tex=TEX_MAP["BODIESA3_3"], }
    { x=192.000, y=976.000, tex=TEX_MAP["BODIESA3_3"], }
    { t=256.000, tex=TEX_MAP["BODIESA3_3"], }
    { b=0.000, tex=TEX_MAP["BODIESA3_3"], }
  }
  {
    { m="solid", }
    { x=0.000, y=960.000, tex=TEX_MAP["BODIESA2_4"], }
    { x=64.000, y=960.000, tex=TEX_MAP["BODIESA2_4"], }
    { x=64.000, y=976.000, tex=TEX_MAP["BODIESA2_4"], }
    { x=0.000, y=976.000, tex=TEX_MAP["BODIESA2_4"], }
    { t=256.000, tex=TEX_MAP["BODIESA2_4"], }
    { b=0.000, tex=TEX_MAP["BODIESA2_4"], }
  }
  {
    { m="solid", }
    { x=-184.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-184.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=64.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=192.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=192.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=64.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=-128.000, y=992.000, tex=TEX_MAP["ROOF2"], }
    { x=384.000, y=992.000, tex=TEX_MAP["ROOF2"], }
    { x=384.000, y=1088.000, tex=TEX_MAP["ROOF2"], }
    { x=-128.000, y=1088.000, tex=TEX_MAP["ROOF2"], }
    { t=272.000, tex=TEX_MAP["ROOF2"], }
    { b=256.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=-128.000, y=1216.000, tex=TEX_MAP["ROOF2"], }
    { x=384.000, y=1216.000, tex=TEX_MAP["ROOF2"], }
    { x=384.000, y=1312.000, tex=TEX_MAP["ROOF2"], }
    { x=-128.000, y=1312.000, tex=TEX_MAP["ROOF2"], }
    { t=272.000, tex=TEX_MAP["ROOF2"], }
    { b=256.000, tex=TEX_MAP["ROOF2"], }
  }
  {
    { m="solid", }
    { x=-32.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=-64.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=-64.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { x=-32.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { t=256.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], slope={ nx=0.00000, ny=0.31623, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=144.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=112.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=112.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { x=144.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { t=256.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], slope={ nx=0.00000, ny=0.31623, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=320.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=288.000, y=1088.000, tex=TEX_MAP["ROOF"], }
    { x=288.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { x=320.000, y=992.000, tex=TEX_MAP["ROOF"], }
    { t=256.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], slope={ nx=0.00000, ny=0.31623, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=256.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=960.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=256.000, y=992.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=112.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { x=144.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { x=144.000, y=1312.000, tex=TEX_MAP["ROOF"], }
    { x=112.000, y=1312.000, tex=TEX_MAP["ROOF"], }
    { t=256.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.00000, ny=-0.31623, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=288.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { x=320.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { x=320.000, y=1312.000, tex=TEX_MAP["ROOF"], }
    { x=288.000, y=1312.000, tex=TEX_MAP["ROOF"], }
    { t=256.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.00000, ny=-0.31623, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=-64.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { x=-32.000, y=1216.000, tex=TEX_MAP["ROOF"], }
    { x=-32.000, y=1312.000, tex=TEX_MAP["ROOF"], }
    { x=-64.000, y=1312.000, tex=TEX_MAP["ROOF"], }
    { t=256.000, tex=TEX_MAP["ROOF"], }
    { b=208.000, tex=TEX_MAP["ROOF"], slope={ nx=-0.00000, ny=-0.31623, nz=-0.94868 }, }
  }
  {
    { m="solid", }
    { x=192.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=256.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=256.000, y=1328.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=192.000, y=1328.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=192.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=192.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=256.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=256.000, y=1328.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=192.000, y=1328.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=64.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=192.000, y=1328.000, tex=TEX_MAP["BODIESA3_2"], }
    { x=256.000, y=1328.000, tex=TEX_MAP["BODIESA3_2"], }
    { x=256.000, y=1344.000, tex=TEX_MAP["BODIESA3_2"], }
    { x=192.000, y=1344.000, tex=TEX_MAP["BODIESA3_2"], }
    { t=256.000, tex=TEX_MAP["BODIESA3_2"], }
    { b=0.000, tex=TEX_MAP["BODIESA3_2"], }
  }
  {
    { m="solid", }
    { x=256.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=384.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=256.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=64.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=192.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=192.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=64.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=64.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=64.000, y=1328.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=1328.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=192.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=64.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=64.000, y=1328.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=1328.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=64.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=1328.000, tex=TEX_MAP["BODIESA2_1"], }
    { x=64.000, y=1328.000, tex=TEX_MAP["BODIESA2_1"], }
    { x=64.000, y=1344.000, tex=TEX_MAP["BODIESA2_1"], }
    { x=0.000, y=1344.000, tex=TEX_MAP["BODIESA2_1"], }
    { t=256.000, tex=TEX_MAP["BODIESA2_1"], }
    { b=0.000, tex=TEX_MAP["BODIESA2_1"], }
  }
  {
    { m="solid", }
    { x=-128.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=1312.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=0.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { x=-128.000, y=1344.000, tex=TEX_MAP["BRICKA2_4"], }
    { t=256.000, tex=TEX_MAP["BRICKA2_4"], }
    { b=0.000, tex=TEX_MAP["BRICKA2_4"], }
  }
  {
    { m="solid", link_entity="m1", }
    { x=1088.000, y=384.000, tex=TEX_MAP["TRIGGER"], }
    { x=1152.000, y=384.000, tex=TEX_MAP["TRIGGER"], }
    { x=1152.000, y=448.000, tex=TEX_MAP["TRIGGER"], }
    { x=1088.000, y=448.000, tex=TEX_MAP["TRIGGER"], }
    { t=128.000, tex=TEX_MAP["TRIGGER"], }
    { b=64.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m2", }
    { x=-400.000, y=1560.000, tex=TEX_MAP["DOOR05_3"], }
    { x=-336.000, y=1560.000, tex=TEX_MAP["DOOR05_3"], }
    { x=-336.000, y=1624.000, tex=TEX_MAP["DOOR05_3"], }
    { x=-400.000, y=1624.000, tex=TEX_MAP["DOOR05_3"], }
    { t=4.000, tex=TEX_MAP["+0FLOORSW"], }
    { b=-4.000, tex=TEX_MAP["DOOR05_3"], }
  }
  {
    { m="solid", link_entity="m3", }
    { x=-304.000, y=1360.000, tex=TEX_MAP["COP2_5"], }
    { x=-64.000, y=1360.000, tex=TEX_MAP["COP2_5"], }
    { x=-64.000, y=1472.000, tex=TEX_MAP["COP2_5"], }
    { x=-304.000, y=1472.000, tex=TEX_MAP["COP2_5"], }
    { t=-4.000, tex=TEX_MAP["COP2_5"], }
    { b=-16.000, tex=TEX_MAP["COP2_5"], }
  }
  {
    { m="solid", link_entity="m4", }
    { x=504.000, y=1232.000, tex=TEX_MAP["DOOR05_3"], }
    { x=512.000, y=1232.000, tex=TEX_MAP["+0BUTTON"], }
    { x=512.000, y=1280.000, tex=TEX_MAP["DOOR05_3"], }
    { x=504.000, y=1280.000, tex=TEX_MAP["+0BUTTON"], }
    { t=-80.000, tex=TEX_MAP["DOOR05_3"], }
    { b=-128.000, tex=TEX_MAP["DOOR05_3"], }
  }
  {
    { m="solid", link_entity="m5", }
    { x=448.000, y=668.000, tex=TEX_MAP["BRICKA2_6"], }
    { x=512.000, y=668.000, tex=TEX_MAP["BRICKA2_6"], }
    { x=512.000, y=684.000, tex=TEX_MAP["BRICKA2_6"], }
    { x=448.000, y=684.000, tex=TEX_MAP["BRICKA2_6"], }
    { t=88.000, tex=TEX_MAP["BRICKA2_6"], }
    { b=8.000, tex=TEX_MAP["BRICKA2_6"], }
  }
  {
    { m="solid", link_entity="m6", }
    { x=244.000, y=1576.000, tex=TEX_MAP["TRIGGER"], }
    { x=284.000, y=1576.000, tex=TEX_MAP["TRIGGER"], }
    { x=284.000, y=1624.000, tex=TEX_MAP["TRIGGER"], }
    { x=244.000, y=1624.000, tex=TEX_MAP["TRIGGER"], }
    { t=-40.000, tex=TEX_MAP["TRIGGER"], }
    { b=-136.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m7", }
    { x=448.000, y=1352.000, tex=TEX_MAP["COP1_6"], }
    { x=464.000, y=1352.000, tex=TEX_MAP["COP1_6"], }
    { x=464.000, y=1368.000, tex=TEX_MAP["COP1_6"], }
    { x=448.000, y=1368.000, tex=TEX_MAP["COP1_6"], }
    { t=-24.000, tex=TEX_MAP["COP1_6"], }
    { b=-144.000, tex=TEX_MAP["COP1_6"], }
  }
  {
    { m="solid", link_entity="m8", }
    { x=412.000, y=1352.000, tex=TEX_MAP["COP1_6"], }
    { x=428.000, y=1352.000, tex=TEX_MAP["COP1_6"], }
    { x=428.000, y=1368.000, tex=TEX_MAP["COP1_6"], }
    { x=412.000, y=1368.000, tex=TEX_MAP["COP1_6"], }
    { t=-24.000, tex=TEX_MAP["COP1_6"], }
    { b=-144.000, tex=TEX_MAP["COP1_6"], }
  }
}
