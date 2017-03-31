ENT_MAP = 
{
  ["func_door_secret"]           = "func_door",
  ["info_intermission"]          = "info_intermission",
  ["info_player_deathmatch"]     = "info_player_deathmatch",
  ["info_player_start"]          = "info_player_start",
  ["info_teleport_destination"]  = "misc_teleporter_dest",
  ["item_armor1"]                = "item_armor1",
  ["item_armorInv"]              = "item_armorInv",
  ["item_artifact_invisibility"] = "item_artifact_invisibility",
  ["item_cells"]                 = "item_cells",
  ["item_health"]                = "item_health",
  ["item_rockets"]               = "item_rockets",
  ["item_shells"]                = "item_shells",
  ["item_weapon"]                = "item_weapon",
  ["light_flame_small_yellow"]   = "light_flame_small_yellow",
  ["light"]                      = "nothing",
  ["light_torch_small_walltorch"] = "light_torch_small_walltorch",
  ["trigger_changelevel"]        = "trigger_changelevel",
  ["trigger_teleport"]           = "trigger_teleport",
  ["weapon_grenadelauncher"]     = "weapon_grenadelauncher",
  ["weapon_lightning"]           = "weapon_lightning",
  ["weapon_nailgun"]             = "weapon_nailgun",
  ["weapon_rocketlauncher"]      = "weapon_rocketlauncher",
  ["weapon_supernailgun"]        = "weapon_supernailgun",
  ["weapon_supershotgun"]        = "weapon_supershotgun",
}

TEX_MAP = 
{
  ["CITY2_6"]      = "gothic_block/blocks10",
  ["CITY2_7"]      = "gothic_block/blocks15",
  ["CITY2_8"]      = "gothic_block/blocks19",
  ["CITY4_2"]      = "gothic_block/blocks9",
  ["COP1_1"]       = "base_wall/concrete",
  ["COP1_7"]       = "base_wall/concrete_dark",
  ["GROUND1_5"]    = "base_floor/clang_floor",
  ["METAL4_4"]     = "base_trim/metal2_2",
  ["SKY4"]         = "skies/hellsky",
  ["*TELEPORT"]    = "TELEPORT",
  ["TRIGGER"]      = "TRIGGER",
  ["WMET4_8"]      = "base_floor/metfloor1",
}

all_entities =
{
  {
    id = ENT_MAP["info_player_start"]
    angle = 0
    x = 760
    y = -1080
    z = 256
  }
  {
    id = ENT_MAP["light"]
    light = 250
    x = 1392
    y = -1088
    z = 208
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 448
    y = -1504
    z = 312
  }
  {
    id = ENT_MAP["light"]
    light = 225
    x = 440
    y = -1640
    z = 344
  }
  {
    id = ENT_MAP["light"]
    light = 300
    x = 184
    y = -1736
    z = 400
  }
  {
    id = ENT_MAP["light"]
    x = 328
    y = -1736
    z = 400
  }
  {
    id = ENT_MAP["light"]
    x = 336
    y = -1912
    z = 400
  }
  {
    id = ENT_MAP["light"]
    x = 184
    y = -1912
    z = 400
  }
  {
    id = ENT_MAP["light"]
    light = 250
    x = 656
    y = -1088
    z = 80
  }
  {
    id = ENT_MAP["light"]
    light = 250
    x = 360
    y = -1088
    z = 152
  }
  {
    id = ENT_MAP["light"]
    light = 400
    x = 1496
    y = -408
    z = 480
  }
  {
    id = ENT_MAP["light"]
    light = 350
    x = 200
    y = -816
    z = 184
  }
  {
    id = ENT_MAP["info_teleport_destination"]
    targetname = "t1"
    angle = 45
    x = 308
    y = -1788
    z = 44
  }
  {
    id = ENT_MAP["trigger_teleport"]
    target = "t1"
    link_id = "m1"
  }
  {
    id = ENT_MAP["info_teleport_destination"]
    targetname = "t2"
    angle = 270
    x = 200
    y = -892
    z = 119
  }
  {
    id = ENT_MAP["trigger_teleport"]
    target = "t2"
    link_id = "m2"
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 1230
    y = -626
    z = 196
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 1286
    y = -294
    z = 196
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 1818
    y = -1174
    z = 76
  }
  {
    id = ENT_MAP["light"]
    x = 1656
    y = -472
    z = 248
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1656
    y = -544
    z = 80
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1744
    y = -544
    z = 80
  }
  {
    id = ENT_MAP["light"]
    light = 250
    x = 1500
    y = -576
    z = 120
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 1642
    y = -870
    z = 76
  }
  {
    id = ENT_MAP["light"]
    x = 1432
    y = -1088
    z = 64
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1744
    y = -1088
    z = 216
  }
  {
    id = ENT_MAP["light"]
    x = 944
    y = -1080
    z = 320
    light = 250
  }
  {
    id = ENT_MAP["light"]
    x = 1104
    y = -1080
    z = 320
    light = 250
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1184
    y = -1088
    z = 184
  }
  {
    id = ENT_MAP["light"]
    x = 1016
    y = -920
    z = 104
  }
  {
    id = ENT_MAP["light"]
    x = 1016
    y = -1256
    z = 104
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1400
    y = -336
    z = 104
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1224
    y = -888
    z = 16
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 824
    y = -888
    z = 16
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1224
    y = -1296
    z = 16
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 824
    y = -1288
    z = 16
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 728
    y = -1088
    z = 168
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 978
    y = -382
    z = 68
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 1024
    y = -720
    z = 56
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 1074
    y = -1718
    z = 68
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 1024
    y = -1464
    z = 56
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 1304
    y = -440
    z = 56
  }
  {
    id = ENT_MAP["light"]
    light = 250
    x = 832
    y = -1272
    z = 344
  }
  {
    id = ENT_MAP["light"]
    light = 250
    x = 1208
    y = -904
    z = 344
  }
  {
    id = ENT_MAP["light"]
    light = 250
    x = 840
    y = -904
    z = 344
  }
  {
    id = ENT_MAP["light"]
    light = 250
    x = 1216
    y = -1280
    z = 344
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 394
    y = -1038
    z = 284
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 704
    y = -1088
    z = 296
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 506
    y = -1966
    z = 236
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 10
    y = -1590
    z = 76
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 10
    y = -2054
    z = 124
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 224
    y = -1784
    z = 72
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 272
    y = -1784
    z = 72
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 552
    y = -1664
    z = 72
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 448
    y = -1912
    z = 72
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 312
    y = -1616
    z = 120
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = 80
    y = -1824
    z = 96
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = 272
    y = -2000
    z = 184
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1744
    y = -832
    z = 256
  }
  {
    id = ENT_MAP["light"]
    light = 250
    x = 200
    y = -880
    z = 144
  }
  {
    id = ENT_MAP["light"]
    x = 204
    y = -944
    z = 336
    light = 200
  }
  {
    id = ENT_MAP["light_flame_small_yellow"]
    x = 192
    y = -1348
    z = 240
  }
  {
    id = ENT_MAP["light"]
    x = 232
    y = -1936
    z = 72
    light = 150
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 180
    x = 232
    y = -1512
    z = 40
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 270
    x = 1016
    y = -416
    z = 40
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 0
    x = 0
    y = -1088
    z = 264
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 270
    x = 456
    y = -1504
    z = 256
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 0
    x = 408
    y = -1088
    z = 256
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 928
    y = -864
    z = 232
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 984
    y = -864
    z = 232
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 2
    x = 192
    y = -1264
    z = 88
  }
  {
    id = ENT_MAP["item_health"]
    x = 1696
    y = -1160
    z = 16
  }
  {
    id = ENT_MAP["item_health"]
    x = 1224
    y = -608
    z = 144
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 4
    x = 1264
    y = -344
    z = 144
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 1048
    y = -520
    z = 16
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 1048
    y = -568
    z = 16
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 1
    x = 752
    y = -1640
    z = 16
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 9
    x = 456
    y = -2048
    z = 16
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 232
    y = -1912
    z = 16
  }
  {
    id = ENT_MAP["item_health"]
    x = 408
    y = -1064
    z = 232
  }
  {
    id = ENT_MAP["trigger_teleport"]
    target = "t1"
    link_id = "m3"
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 872
    y = -960
    z = -64
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 1
    x = 1244
    y = -1316
    z = -64
  }
  {
    id = ENT_MAP["light"]
    x = 1488
    y = -1088
    z = 240
  }
  {
    id = ENT_MAP["light"]
    x = 1024
    y = -840
    z = 368
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = 1024
    y = -1344
    z = 368
    light = 200
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 1758
    y = -298
    z = 196
  }
  {
    id = ENT_MAP["light"]
    x = 1680
    y = -344
    z = 104
    light = 200
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 4
    x = 1328
    y = -280
    z = 144
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 304
    y = -1944
    z = 16
  }
  {
    id = ENT_MAP["light"]
    x = 1520
    y = -280
    z = 80
    light = 150
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 1
    x = 1280
    y = -1272
    z = -64
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 1
    x = 816
    y = -1640
    z = 16
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 920
    y = -1008
    z = -64
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 168
    y = -1512
    z = 56
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 968
    y = -1460
    z = 272
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 0
    x = 896
    y = -1464
    z = 256
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 1696
    y = -168
    z = 192
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 1872
    y = -320
    z = 192
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 1880
    y = -192
    z = 192
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 225
    x = 1892
    y = -160
    z = 168
  }
  {
    id = ENT_MAP["light"]
    x = 16
    y = -1088
    z = 280
    light = 100
  }
  {
    id = ENT_MAP["weapon_nailgun"]
    x = 1224
    y = -1088
    z = -64
  }
  {
    id = ENT_MAP["weapon_grenadelauncher"]
    x = 1224
    y = -1088
    z = 232
  }
  {
    id = ENT_MAP["weapon_supernailgun"]
    angle = 45
    x = 424
    y = -2008
    z = 144
  }
  {
    id = ENT_MAP["weapon_rocketlauncher"]
    angle = 180
    x = 200
    y = -1112
    z = 88
  }
  {
    id = ENT_MAP["weapon_supershotgun"]
    x = 1392
    y = -584
    z = 16
  }
  {
    id = ENT_MAP["item_shells"]
    x = 1736
    y = -1112
    z = 144
  }
  {
    id = ENT_MAP["item_rockets"]
    x = 264
    y = -1632
    z = 36
  }
  {
    id = ENT_MAP["weapon_rocketlauncher"]
    x = 1512
    y = -432
    z = 36
  }
  {
    id = ENT_MAP["light"]
    x = 376
    y = -2016
    z = 80
    light = 125
  }
  {
    id = ENT_MAP["light"]
    x = 240
    y = -2016
    z = 56
    light = 100
  }
  {
    id = ENT_MAP["light"]
    x = 1224
    y = -1088
    z = -40
    light = 125
  }
  {
    id = ENT_MAP["light"]
    x = 1392
    y = -584
    z = 80
    light = 125
  }
  {
    id = ENT_MAP["light"]
    x = 1024
    y = -616
    z = 80
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 344
    y = -1784
    z = 80
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 440
    y = -1640
    z = 112
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 776
    y = -1672
    z = 96
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 448
    y = -1360
    z = 280
    light = 150
  }
  {
    id = ENT_MAP["item_armor1"]
    x = 56
    y = -2008
    z = 64
  }
  {
    id = ENT_MAP["light"]
    x = 728
    y = -1088
    z = -8
    light = 125
  }
  {
    id = ENT_MAP["func_door_secret"]
    spawnflags = 4
    angle = 180
    link_id = "m4"
  }
  {
    id = ENT_MAP["light"]
    x = 840
    y = -1088
    z = -32
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 840
    y = -1088
    z = -120
    light = 150
  }
  {
    id = ENT_MAP["trigger_teleport"]
    target = "t3"
    link_id = "m5"
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 498
    y = -984
    z = -244
    light = 200
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    light = 200
    x = 498
    y = -1184
    z = -244
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 896
    y = -1086
    z = -244
    light = 200
  }
  {
    id = ENT_MAP["info_teleport_destination"]
    targetname = "t3"
    angle = 0
    x = 1072
    y = -1096
    z = -32
  }
  {
    id = ENT_MAP["light"]
    x = 600
    y = -1088
    z = -264
    light = 150
  }
  {
    id = ENT_MAP["weapon_lightning"]
    x = 760
    y = -1080
    z = -296
  }
  {
    id = ENT_MAP["item_cells"]
    spawnflags = 1
    x = 600
    y = -1064
    z = -296
  }
  {
    id = ENT_MAP["item_cells"]
    spawnflags = 1
    x = 656
    y = -1064
    z = -296
  }
  {
    id = ENT_MAP["item_artifact_invisibility"]
    x = 512
    y = -1088
    z = -272
  }
  {
    id = ENT_MAP["item_cells"]
    x = 472
    y = -1400
    z = 232
  }
  {
    id = ENT_MAP["item_cells"]
    x = 472
    y = -1352
    z = 232
  }
  {
    id = ENT_MAP["light"]
    x = 760
    y = -1080
    z = -272
    light = 125
  }
  {
    id = ENT_MAP["info_intermission"]
    x = 864
    y = -1088
    z = 336
  }
  {
    id = ENT_MAP["trigger_changelevel"]
    map = "dm1"
    link_id = "m6"
  }
  {
    id = ENT_MAP["item_armorInv"]
    x = 1736
    y = -344
    z = 144
  }
}

all_brushes =
{
--    @@@@ FIX BRUSH @ line:7 @@@@
  {
    { m="solid", }
    { x=1344.000, y=-896.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-880.000, tex=TEX_MAP["CITY2_6"], }
    { x=1216.000, y=-752.000, tex=TEX_MAP["CITY2_6"], }
    { x=1216.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:22 @@@@
--    @@@@ FIX BRUSH @ line:31 @@@@
--    @@@@ FIX BRUSH @ line:38 @@@@
--    @@@@ FIX BRUSH @ line:45 @@@@
  {
    { m="solid", }
    { x=1632.000, y=-992.000, tex=TEX_MAP["CITY2_6"], }
    { x=1632.000, y=-880.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-880.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-992.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.51450, ny=0.00000, nz=0.85749 }, }
    { b=-80.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:60 @@@@
--    @@@@ FIX BRUSH @ line:67 @@@@
  {
    { m="solid", }
    { x=704.000, y=-896.000, tex=TEX_MAP["CITY2_6"], }
    { x=832.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { x=816.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { x=688.000, y=-896.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=832.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=704.000, y=-1280.000, tex=TEX_MAP["CITY2_6"], }
    { x=704.000, y=-1296.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1360.000, y=-1280.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-1280.000, tex=TEX_MAP["CITY2_6"], }
    { x=1216.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=1232.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-1728.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-1456.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1456.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1728.000, tex=TEX_MAP["CITY2_7"], }
    { t=16.000, tex=TEX_MAP["CITY2_7"], }
    { b=-88.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1152.000, tex=TEX_MAP["WMET4_8"], }
    { x=704.000, y=-1024.000, tex=TEX_MAP["WMET4_8"], }
    { x=456.000, y=-1024.000, tex=TEX_MAP["WMET4_8"], }
    { x=456.000, y=-1152.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=224.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=960.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-752.000, tex=TEX_MAP["CITY2_6"], }
    { x=816.000, y=-752.000, tex=TEX_MAP["CITY2_6"], }
    { x=816.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-80.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:123 @@@@
  {
    { m="solid", }
    { x=960.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-368.000, tex=TEX_MAP["CITY2_6"], }
    { x=944.000, y=-368.000, tex=TEX_MAP["CITY2_6"], }
    { x=944.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { t=104.000, tex=TEX_MAP["CITY2_6"], }
    { b=0.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:139 @@@@
--    @@@@ FIX BRUSH @ line:146 @@@@
--    @@@@ FIX BRUSH @ line:153 @@@@
--    @@@@ FIX BRUSH @ line:161 @@@@
--    @@@@ FIX BRUSH @ line:168 @@@@
--    @@@@ FIX BRUSH @ line:175 @@@@
  {
    { m="solid", }
    { x=1344.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=1104.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=1104.000, y=-512.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-512.000, tex=TEX_MAP["CITY2_6"], }
    { t=100.571, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.49614, nz=0.86824 }, }
    { b=0.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1824.000, y=-144.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-144.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-640.000, tex=TEX_MAP["CITY2_7"], }
    { x=1824.000, y=-640.000, tex=TEX_MAP["CITY2_7"], }
    { t=16.000, tex=TEX_MAP["CITY2_7"], }
    { b=8.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-352.000, tex=TEX_MAP["CITY2_6"], }
    { x=944.000, y=-352.000, tex=TEX_MAP["CITY2_6"], }
    { x=944.000, y=-368.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-368.000, tex=TEX_MAP["CITY2_6"], }
    { t=104.000, tex=TEX_MAP["CITY2_6"], }
    { b=0.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:208 @@@@
--    @@@@ FIX BRUSH @ line:216 @@@@
--    @@@@ FIX BRUSH @ line:224 @@@@
--    @@@@ FIX BRUSH @ line:232 @@@@
  {
    { m="solid", }
    { x=1088.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-672.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-672.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=123.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1080.000, y=-672.000, tex=TEX_MAP["CITY2_6"], }
    { x=1080.000, y=-368.000, tex=TEX_MAP["CITY2_6"], }
    { x=968.000, y=-368.000, tex=TEX_MAP["CITY2_6"], }
    { x=968.000, y=-672.000, tex=TEX_MAP["CITY2_6"], }
    { t=136.000, tex=TEX_MAP["CITY2_6"], }
    { b=123.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-352.000, tex=TEX_MAP["CITY2_6"], }
    { x=1016.000, y=-352.000, tex=TEX_MAP["CITY2_6"], }
    { x=1016.000, y=-512.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-512.000, tex=TEX_MAP["CITY2_6"], }
    { t=136.000, tex=TEX_MAP["CITY2_6"], }
    { b=123.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-1712.000, tex=TEX_MAP["CITY2_6"], }
    { x=1032.000, y=-1712.000, tex=TEX_MAP["CITY2_6"], }
    { x=1032.000, y=-1600.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1600.000, tex=TEX_MAP["CITY2_6"], }
    { t=136.000, tex=TEX_MAP["CITY2_6"], }
    { b=123.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=968.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=968.000, y=-1728.000, tex=TEX_MAP["CITY2_6"], }
    { x=1080.000, y=-1728.000, tex=TEX_MAP["CITY2_6"], }
    { x=1080.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { t=136.000, tex=TEX_MAP["CITY2_6"], }
    { b=123.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=992.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=992.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=123.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1064.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=1064.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=123.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1064.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=992.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=992.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=1064.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=308.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1064.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=992.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=992.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=1064.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { t=224.000, tex=TEX_MAP["CITY2_6"], }
    { b=123.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:312 @@@@
--    @@@@ FIX BRUSH @ line:320 @@@@
--    @@@@ FIX BRUSH @ line:328 @@@@
--    @@@@ FIX BRUSH @ line:336 @@@@
  {
    { m="solid", }
    { x=528.000, y=-1744.000, tex=TEX_MAP["CITY2_6"], }
    { x=1104.000, y=-1744.000, tex=TEX_MAP["CITY2_6"], }
    { x=1104.000, y=-1728.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1728.000, tex=TEX_MAP["CITY2_6"], }
    { t=104.000, tex=TEX_MAP["CITY2_6"], }
    { b=0.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-1728.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1728.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1600.000, tex=TEX_MAP["CITY2_7"], }
    { x=528.000, y=-1600.000, tex=TEX_MAP["CITY2_7"], }
    { t=16.000, tex=TEX_MAP["CITY2_7"], }
    { b=8.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-1600.000, tex=TEX_MAP["CITY2_6"], }
    { x=944.000, y=-1600.000, tex=TEX_MAP["CITY2_6"], }
    { x=944.000, y=-1584.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1584.000, tex=TEX_MAP["CITY2_6"], }
    { t=100.571, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.49614, nz=0.86824 }, }
    { b=0.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:368 @@@@
--    @@@@ FIX BRUSH @ line:377 @@@@
--    @@@@ FIX BRUSH @ line:384 @@@@
--    @@@@ FIX BRUSH @ line:391 @@@@
--    @@@@ FIX BRUSH @ line:399 @@@@
--    @@@@ FIX BRUSH @ line:406 @@@@
  {
    { m="solid", }
    { x=1088.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-1728.000, tex=TEX_MAP["CITY2_6"], }
    { x=1104.000, y=-1728.000, tex=TEX_MAP["CITY2_6"], }
    { x=1104.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { t=104.000, tex=TEX_MAP["CITY2_6"], }
    { b=0.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:421 @@@@
--    @@@@ FIX BRUSH @ line:429 @@@@
  {
    { m="solid", }
    { x=1216.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { x=1216.000, y=-672.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-672.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-768.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-80.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=960.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=832.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=832.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1232.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=1232.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1824.000, y=-1280.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-1184.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-1184.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-1280.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-80.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=776.000, y=-768.000, tex=TEX_MAP["CITY4_2"], }
    { x=704.000, y=-768.000, tex=TEX_MAP["CITY4_2"], }
    { x=704.000, y=-1408.000, tex=TEX_MAP["CITY4_2"], }
    { x=776.000, y=-1408.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-88.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=960.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=960.000, y=-768.000, tex=TEX_MAP["CITY4_2"], }
    { x=584.000, y=-768.000, tex=TEX_MAP["CITY4_2"], }
    { x=584.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=904.000, y=-1408.000, tex=TEX_MAP["CITY4_2"], }
    { x=960.000, y=-1408.000, tex=TEX_MAP["CITY4_2"], }
    { x=960.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=904.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=584.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { x=584.000, y=-1408.000, tex=TEX_MAP["CITY4_2"], }
    { x=904.000, y=-1408.000, tex=TEX_MAP["CITY4_2"], }
    { x=904.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=792.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=776.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=776.000, y=-1032.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-88.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=904.000, y=-1032.000, tex=TEX_MAP["CITY4_2"], }
    { x=904.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=888.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=904.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { x=904.000, y=-1136.000, tex=TEX_MAP["CITY4_2"], }
    { x=888.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=776.000, y=-1136.000, tex=TEX_MAP["CITY4_2"], }
    { x=776.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { x=792.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-88.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=1472.000, y=-1408.000, tex=TEX_MAP["CITY4_2"], }
    { x=1472.000, y=-768.000, tex=TEX_MAP["CITY4_2"], }
    { x=1088.000, y=-768.000, tex=TEX_MAP["CITY4_2"], }
    { x=1088.000, y=-1408.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-88.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-1360.000, tex=TEX_MAP["CITY4_2"], }
    { x=1088.000, y=-816.000, tex=TEX_MAP["CITY4_2"], }
    { x=960.000, y=-816.000, tex=TEX_MAP["CITY4_2"], }
    { x=960.000, y=-1360.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-88.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-688.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-672.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-672.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-688.000, tex=TEX_MAP["CITY2_6"], }
    { t=0.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-1216.000, tex=TEX_MAP["CITY2_7"], }
    { x=1344.000, y=-960.000, tex=TEX_MAP["CITY2_7"], }
    { x=1280.000, y=-960.000, tex=TEX_MAP["CITY2_7"], }
    { x=1280.000, y=-1216.000, tex=TEX_MAP["CITY2_7"], }
    { t=-48.000, tex=TEX_MAP["CITY2_7"], }
    { b=-64.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1840.000, y=-384.000, tex=TEX_MAP["CITY2_6"], }
    { x=1840.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-384.000, tex=TEX_MAP["CITY2_6"], }
    { t=512.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1840.000, y=-1280.000, tex=TEX_MAP["CITY2_6"], }
    { x=1840.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-1280.000, tex=TEX_MAP["CITY2_6"], }
    { t=512.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1840.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { x=1840.000, y=-384.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-384.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { t=512.000, tex=TEX_MAP["CITY2_6"], }
    { b=220.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1840.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { x=1840.000, y=-384.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-384.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { t=136.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1632.000, y=-880.000, tex=TEX_MAP["CITY2_6"], }
    { x=1632.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1616.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1616.000, y=-880.000, tex=TEX_MAP["CITY2_6"], }
    { t=512.000, tex=TEX_MAP["CITY2_6"], }
    { b=361.600, tex=TEX_MAP["CITY2_6"], slope={ nx=0.51450, ny=0.00000, nz=-0.85749 }, }
  }
  {
    { m="solid", }
    { x=1632.000, y=-880.000, tex=TEX_MAP["CITY2_6"], }
    { x=1632.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1616.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1616.000, y=-880.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.51450, ny=0.00000, nz=0.85749 }, }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1632.000, y=-880.000, tex=TEX_MAP["CITY2_6"], }
    { x=1632.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1616.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1616.000, y=-880.000, tex=TEX_MAP["CITY2_6"], }
    { t=371.200, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.51450, ny=0.00000, nz=0.85749 }, }
    { b=352.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:616 @@@@
  {
    { m="solid", }
    { x=1824.000, y=-992.000, tex=TEX_MAP["CITY2_7"], }
    { x=1824.000, y=-640.000, tex=TEX_MAP["CITY2_7"], }
    { x=1632.000, y=-640.000, tex=TEX_MAP["CITY2_7"], }
    { x=1632.000, y=-992.000, tex=TEX_MAP["CITY2_7"], }
    { t=16.000, tex=TEX_MAP["CITY2_7"], }
    { b=0.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=688.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=704.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=704.000, y=-896.000, tex=TEX_MAP["CITY2_6"], }
    { x=688.000, y=-896.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-64.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=688.000, y=-1296.000, tex=TEX_MAP["CITY2_6"], }
    { x=704.000, y=-1296.000, tex=TEX_MAP["CITY2_6"], }
    { x=704.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=688.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=-88.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:647 @@@@
--    @@@@ FIX BRUSH @ line:654 @@@@
  {
    { m="solid", }
    { x=704.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=456.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=456.000, y=-1024.000, tex=TEX_MAP["CITY2_6"], }
    { x=704.000, y=-1024.000, tex=TEX_MAP["CITY2_6"], }
    { t=328.000, tex=TEX_MAP["CITY2_6"], }
    { b=224.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=456.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1024.000, tex=TEX_MAP["CITY2_6"], }
    { x=456.000, y=-1024.000, tex=TEX_MAP["CITY2_6"], }
    { t=328.000, tex=TEX_MAP["CITY2_6"], }
    { b=232.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:678 @@@@
--    @@@@ FIX BRUSH @ line:685 @@@@
--    @@@@ FIX BRUSH @ line:692 @@@@
--    @@@@ FIX BRUSH @ line:700 @@@@
--    @@@@ FIX BRUSH @ line:707 @@@@
--    @@@@ FIX BRUSH @ line:714 @@@@
  {
    { m="solid", }
    { x=528.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { t=388.571, tex=TEX_MAP["CITY2_6"], slope={ nx=0.49614, ny=-0.00000, nz=0.86824 }, }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-1568.000, tex=TEX_MAP["WMET4_8"], }
    { x=512.000, y=-1152.000, tex=TEX_MAP["WMET4_8"], }
    { x=456.000, y=-1152.000, tex=TEX_MAP["WMET4_8"], }
    { x=456.000, y=-1568.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1168.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1568.000, tex=TEX_MAP["WMET4_8"], }
    { x=456.000, y=-1568.000, tex=TEX_MAP["WMET4_8"], }
    { x=456.000, y=-1168.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=368.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=368.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { t=328.000, tex=TEX_MAP["CITY2_6"], }
    { b=224.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=368.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=368.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { t=328.000, tex=TEX_MAP["CITY2_6"], }
    { b=232.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:763 @@@@
--    @@@@ FIX BRUSH @ line:771 @@@@
--    @@@@ FIX BRUSH @ line:779 @@@@
--    @@@@ FIX BRUSH @ line:787 @@@@
  {
    { m="solid", }
    { x=704.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=688.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=688.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=704.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { t=464.000, tex=TEX_MAP["CITY2_6"], }
    { b=347.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=688.000, y=-1032.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1032.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1144.000, tex=TEX_MAP["CITY2_6"], }
    { x=688.000, y=-1144.000, tex=TEX_MAP["CITY2_6"], }
    { t=360.000, tex=TEX_MAP["CITY2_6"], }
    { b=347.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-1080.000, tex=TEX_MAP["CITY2_6"], }
    { x=400.000, y=-1080.000, tex=TEX_MAP["CITY2_6"], }
    { x=400.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { t=360.000, tex=TEX_MAP["CITY2_6"], }
    { b=347.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:819 @@@@
--    @@@@ FIX BRUSH @ line:827 @@@@
--    @@@@ FIX BRUSH @ line:835 @@@@
--    @@@@ FIX BRUSH @ line:843 @@@@
--    @@@@ FIX BRUSH @ line:851 @@@@
  {
    { m="solid", }
    { x=1824.000, y=-1184.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-992.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-992.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-1184.000, tex=TEX_MAP["CITY2_6"], }
    { t=448.000, tex=TEX_MAP["CITY2_6"], }
    { b=344.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1824.000, y=-992.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1632.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1632.000, y=-992.000, tex=TEX_MAP["CITY2_6"], }
    { t=512.000, tex=TEX_MAP["CITY2_6"], }
    { b=344.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-1792.000, tex=TEX_MAP["CITY2_6"], }
    { x=544.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1792.000, tex=TEX_MAP["CITY2_6"], }
    { t=420.000, tex=TEX_MAP["CITY2_6"], }
    { b=128.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-2080.000, tex=TEX_MAP["CITY2_6"], }
    { x=544.000, y=-1728.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1728.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-2080.000, tex=TEX_MAP["CITY2_6"], }
    { t=420.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { t=216.000, tex=TEX_MAP["CITY2_6"], }
    { b=-80.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-1600.000, tex=TEX_MAP["CITY2_6"], }
    { x=544.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1600.000, tex=TEX_MAP["CITY2_6"], }
    { t=196.000, tex=TEX_MAP["CITY2_6"], }
    { b=0.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=544.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { t=412.000, tex=TEX_MAP["CITY2_6"], }
    { b=348.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=56.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=56.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { t=420.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=384.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=120.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=120.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { t=420.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=120.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=56.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=56.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=120.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { t=420.000, tex=TEX_MAP["CITY2_6"], }
    { b=92.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=120.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=56.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=56.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=120.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { t=16.000, tex=TEX_MAP["CITY2_7"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-1624.000, tex=TEX_MAP["WMET4_8"], }
    { x=512.000, y=-1576.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1576.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1624.000, tex=TEX_MAP["WMET4_8"], }
    { t=224.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-1672.000, tex=TEX_MAP["WMET4_8"], }
    { x=512.000, y=-1624.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1624.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1672.000, tex=TEX_MAP["WMET4_8"], }
    { t=208.000, tex=TEX_MAP["WMET4_8"], }
    { b=200.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-1720.000, tex=TEX_MAP["WMET4_8"], }
    { x=512.000, y=-1672.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1672.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1720.000, tex=TEX_MAP["WMET4_8"], }
    { t=192.000, tex=TEX_MAP["WMET4_8"], }
    { b=184.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-2048.000, tex=TEX_MAP["WMET4_8"], }
    { x=512.000, y=-1816.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1816.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-2072.000, tex=TEX_MAP["WMET4_8"], }
    { x=488.000, y=-2072.000, tex=TEX_MAP["WMET4_8"], }
    { t=144.000, tex=TEX_MAP["WMET4_8"], }
    { b=136.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-2064.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=336.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=336.000, y=-2064.000, tex=TEX_MAP["WMET4_8"], }
    { t=128.000, tex=TEX_MAP["WMET4_8"], }
    { b=120.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=336.000, y=-2064.000, tex=TEX_MAP["WMET4_8"], }
    { x=336.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=288.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=288.000, y=-2064.000, tex=TEX_MAP["WMET4_8"], }
    { t=112.000, tex=TEX_MAP["WMET4_8"], }
    { b=104.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=288.000, y=-2064.000, tex=TEX_MAP["WMET4_8"], }
    { x=288.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=240.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=240.000, y=-2064.000, tex=TEX_MAP["WMET4_8"], }
    { t=96.000, tex=TEX_MAP["WMET4_8"], }
    { b=88.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-2064.000, tex=TEX_MAP["WMET4_8"], }
    { x=240.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=192.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=192.000, y=-2064.000, tex=TEX_MAP["WMET4_8"], }
    { t=80.000, tex=TEX_MAP["WMET4_8"], }
    { b=72.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-2040.000, tex=TEX_MAP["WMET4_8"], }
    { x=192.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=0.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=0.000, y=-2040.000, tex=TEX_MAP["WMET4_8"], }
    { t=64.000, tex=TEX_MAP["WMET4_8"], }
    { b=56.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-2064.000, tex=TEX_MAP["WMET4_8"], }
    { x=192.000, y=-2040.000, tex=TEX_MAP["WMET4_8"], }
    { x=0.000, y=-2040.000, tex=TEX_MAP["WMET4_8"], }
    { x=24.000, y=-2064.000, tex=TEX_MAP["WMET4_8"], }
    { t=64.000, tex=TEX_MAP["WMET4_8"], }
    { b=56.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { x=128.000, y=-1888.000, tex=TEX_MAP["WMET4_8"], }
    { x=0.000, y=-1888.000, tex=TEX_MAP["WMET4_8"], }
    { x=0.000, y=-1936.000, tex=TEX_MAP["WMET4_8"], }
    { t=48.000, tex=TEX_MAP["WMET4_8"], }
    { b=40.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-1888.000, tex=TEX_MAP["WMET4_8"], }
    { x=128.000, y=-1840.000, tex=TEX_MAP["WMET4_8"], }
    { x=0.000, y=-1840.000, tex=TEX_MAP["WMET4_8"], }
    { x=0.000, y=-1888.000, tex=TEX_MAP["WMET4_8"], }
    { t=32.000, tex=TEX_MAP["WMET4_8"], }
    { b=24.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-1816.000, tex=TEX_MAP["WMET4_8"], }
    { x=512.000, y=-1768.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1768.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1816.000, tex=TEX_MAP["WMET4_8"], }
    { t=160.000, tex=TEX_MAP["WMET4_8"], }
    { b=152.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-1768.000, tex=TEX_MAP["WMET4_8"], }
    { x=512.000, y=-1720.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1720.000, tex=TEX_MAP["WMET4_8"], }
    { x=384.000, y=-1768.000, tex=TEX_MAP["WMET4_8"], }
    { t=176.000, tex=TEX_MAP["WMET4_8"], }
    { b=168.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-2096.000, tex=TEX_MAP["CITY2_6"], }
    { x=544.000, y=-2080.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-2080.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-2096.000, tex=TEX_MAP["CITY2_6"], }
    { t=420.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-16.000, y=-2096.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=-32.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=-32.000, y=-2096.000, tex=TEX_MAP["CITY2_6"], }
    { t=420.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-2080.000, tex=TEX_MAP["CITY2_6"], }
    { x=560.000, y=-2048.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-2048.000, tex=TEX_MAP["CITY2_6"], }
    { x=496.000, y=-2080.000, tex=TEX_MAP["CITY2_6"], }
    { t=421.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=16.000, y=-2112.000, tex=TEX_MAP["CITY2_6"], }
    { x=16.000, y=-2080.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-2048.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-2080.000, tex=TEX_MAP["CITY2_6"], }
    { t=421.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-16.000, y=-1600.000, tex=TEX_MAP["CITY2_6"], }
    { x=16.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-1600.000, tex=TEX_MAP["CITY2_6"], }
    { t=421.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-1752.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-1736.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1736.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1752.000, tex=TEX_MAP["COP1_1"], }
    { t=168.000, tex=TEX_MAP["COP1_1"], }
    { b=160.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1752.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1736.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1736.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1752.000, tex=TEX_MAP["COP1_1"], }
    { t=184.000, tex=TEX_MAP["COP1_1"], }
    { b=160.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-1800.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-1784.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1784.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1800.000, tex=TEX_MAP["COP1_1"], }
    { t=152.000, tex=TEX_MAP["COP1_1"], }
    { b=144.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1800.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1784.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1784.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1800.000, tex=TEX_MAP["COP1_1"], }
    { t=168.000, tex=TEX_MAP["COP1_1"], }
    { b=144.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-1872.000, tex=TEX_MAP["COP1_1"], }
    { x=128.000, y=-1856.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-1856.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-1872.000, tex=TEX_MAP["COP1_1"], }
    { t=24.000, tex=TEX_MAP["COP1_1"], }
    { b=16.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=136.000, y=-1872.000, tex=TEX_MAP["COP1_1"], }
    { x=136.000, y=-1856.000, tex=TEX_MAP["COP1_1"], }
    { x=128.000, y=-1856.000, tex=TEX_MAP["COP1_1"], }
    { x=128.000, y=-1872.000, tex=TEX_MAP["COP1_1"], }
    { t=40.000, tex=TEX_MAP["COP1_1"], }
    { b=16.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-1920.000, tex=TEX_MAP["COP1_1"], }
    { x=128.000, y=-1904.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-1904.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-1920.000, tex=TEX_MAP["COP1_1"], }
    { t=40.000, tex=TEX_MAP["COP1_1"], }
    { b=32.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=136.000, y=-1920.000, tex=TEX_MAP["COP1_1"], }
    { x=136.000, y=-1904.000, tex=TEX_MAP["COP1_1"], }
    { x=128.000, y=-1904.000, tex=TEX_MAP["COP1_1"], }
    { x=128.000, y=-1920.000, tex=TEX_MAP["COP1_1"], }
    { t=56.000, tex=TEX_MAP["COP1_1"], }
    { b=32.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=184.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { x=184.000, y=-1944.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-1944.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { t=56.000, tex=TEX_MAP["COP1_1"], }
    { b=-104.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=224.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { x=224.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=208.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=208.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { t=72.000, tex=TEX_MAP["COP1_1"], }
    { b=64.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=224.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=224.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=208.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=208.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { t=88.000, tex=TEX_MAP["COP1_1"], }
    { b=64.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=272.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { x=272.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=256.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=256.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { t=88.000, tex=TEX_MAP["COP1_1"], }
    { b=80.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=272.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=272.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=256.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=256.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { t=104.000, tex=TEX_MAP["COP1_1"], }
    { b=80.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { x=320.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=304.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=304.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { t=104.000, tex=TEX_MAP["COP1_1"], }
    { b=96.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=320.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=304.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=304.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { t=120.000, tex=TEX_MAP["COP1_1"], }
    { b=96.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=368.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { x=368.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=352.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=352.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { t=120.000, tex=TEX_MAP["COP1_1"], }
    { b=112.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=368.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { x=368.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=352.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=352.000, y=-1936.000, tex=TEX_MAP["COP1_1"], }
    { t=136.000, tex=TEX_MAP["COP1_1"], }
    { b=112.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=480.000, y=-1848.000, tex=TEX_MAP["COP1_1"], }
    { x=480.000, y=-1832.000, tex=TEX_MAP["COP1_1"], }
    { x=464.000, y=-1832.000, tex=TEX_MAP["COP1_1"], }
    { x=464.000, y=-1848.000, tex=TEX_MAP["COP1_1"], }
    { t=136.000, tex=TEX_MAP["COP1_1"], }
    { b=-104.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-1704.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-1688.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1688.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1704.000, tex=TEX_MAP["COP1_1"], }
    { t=184.000, tex=TEX_MAP["COP1_1"], }
    { b=176.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1704.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1688.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1688.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1704.000, tex=TEX_MAP["COP1_1"], }
    { t=200.000, tex=TEX_MAP["COP1_1"], }
    { b=176.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-1656.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-1640.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1640.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1656.000, tex=TEX_MAP["COP1_1"], }
    { t=200.000, tex=TEX_MAP["COP1_1"], }
    { b=192.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1656.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1640.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1640.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1656.000, tex=TEX_MAP["COP1_1"], }
    { t=216.000, tex=TEX_MAP["COP1_1"], }
    { b=192.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-1608.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-1592.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1592.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1608.000, tex=TEX_MAP["COP1_1"], }
    { t=216.000, tex=TEX_MAP["COP1_1"], }
    { b=208.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1608.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1592.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1592.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1608.000, tex=TEX_MAP["COP1_1"], }
    { t=232.000, tex=TEX_MAP["COP1_1"], }
    { b=208.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-2088.000, tex=TEX_MAP["CITY2_7"], }
    { x=544.000, y=-1472.000, tex=TEX_MAP["CITY2_7"], }
    { x=-16.000, y=-1472.000, tex=TEX_MAP["CITY2_7"], }
    { x=-16.000, y=-2088.000, tex=TEX_MAP["CITY2_7"], }
    { t=16.000, tex=TEX_MAP["CITY2_7"], }
    { b=8.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=24.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { x=24.000, y=-1944.000, tex=TEX_MAP["COP1_1"], }
    { x=8.000, y=-1944.000, tex=TEX_MAP["COP1_1"], }
    { x=8.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { t=56.000, tex=TEX_MAP["COP1_1"], }
    { b=-104.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=184.000, y=-2056.000, tex=TEX_MAP["COP1_1"], }
    { x=184.000, y=-2040.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-2040.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-2056.000, tex=TEX_MAP["COP1_1"], }
    { t=56.000, tex=TEX_MAP["COP1_1"], }
    { b=-104.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=-8.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { x=24.000, y=-2048.000, tex=TEX_MAP["COP1_1"], }
    { x=16.000, y=-2040.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-2072.000, tex=TEX_MAP["COP1_1"], }
    { t=56.000, tex=TEX_MAP["COP1_1"], }
    { b=48.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-1728.000, tex=TEX_MAP["CITY2_6"], }
    { x=544.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1568.000, tex=TEX_MAP["CITY2_6"], }
    { x=528.000, y=-1728.000, tex=TEX_MAP["CITY2_6"], }
    { t=0.000, tex=TEX_MAP["CITY2_6"], }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=424.000, y=-1848.000, tex=TEX_MAP["COP1_1"], }
    { x=424.000, y=-1832.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1832.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1848.000, tex=TEX_MAP["COP1_1"], }
    { t=136.000, tex=TEX_MAP["COP1_1"], }
    { b=-104.000, tex=TEX_MAP["COP1_1"], }
  }
--    @@@@ FIX BRUSH @ line:1340 @@@@
--    @@@@ FIX BRUSH @ line:1348 @@@@
--    @@@@ FIX BRUSH @ line:1356 @@@@
--    @@@@ FIX BRUSH @ line:1364 @@@@
  {
    { m="solid", }
    { x=432.000, y=-2008.000, tex=TEX_MAP["COP1_1"], }
    { x=432.000, y=-1992.000, tex=TEX_MAP["COP1_1"], }
    { x=416.000, y=-1992.000, tex=TEX_MAP["COP1_1"], }
    { x=416.000, y=-2008.000, tex=TEX_MAP["COP1_1"], }
    { t=136.000, tex=TEX_MAP["COP1_1"], }
    { b=-104.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=488.000, y=-2008.000, tex=TEX_MAP["COP1_1"], }
    { x=488.000, y=-1992.000, tex=TEX_MAP["COP1_1"], }
    { x=472.000, y=-1992.000, tex=TEX_MAP["COP1_1"], }
    { x=472.000, y=-2008.000, tex=TEX_MAP["COP1_1"], }
    { t=136.000, tex=TEX_MAP["COP1_1"], }
    { b=-104.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=344.000, y=-1864.000, tex=TEX_MAP["CITY2_7"], }
    { x=344.000, y=-1704.000, tex=TEX_MAP["CITY2_7"], }
    { x=160.000, y=-1704.000, tex=TEX_MAP["CITY2_7"], }
    { x=160.000, y=-1864.000, tex=TEX_MAP["CITY2_7"], }
    { t=24.000, tex=TEX_MAP["CITY2_7"], }
    { b=8.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=328.000, y=-1848.000, tex=TEX_MAP["CITY2_7"], }
    { x=328.000, y=-1720.000, tex=TEX_MAP["CITY2_7"], }
    { x=176.000, y=-1720.000, tex=TEX_MAP["CITY2_7"], }
    { x=176.000, y=-1848.000, tex=TEX_MAP["CITY2_7"], }
    { t=32.000, tex=TEX_MAP["CITY2_7"], }
    { b=8.000, tex=TEX_MAP["CITY2_7"], }
  }
--    @@@@ FIX BRUSH @ line:1404 @@@@
--    @@@@ FIX BRUSH @ line:1412 @@@@
--    @@@@ FIX BRUSH @ line:1420 @@@@
--    @@@@ FIX BRUSH @ line:1428 @@@@
--    @@@@ FIX BRUSH @ line:1436 @@@@
--    @@@@ FIX BRUSH @ line:1444 @@@@
--    @@@@ FIX BRUSH @ line:1452 @@@@
--    @@@@ FIX BRUSH @ line:1460 @@@@
--    @@@@ FIX BRUSH @ line:1468 @@@@
--    @@@@ FIX BRUSH @ line:1476 @@@@
--    @@@@ FIX BRUSH @ line:1484 @@@@
--    @@@@ FIX BRUSH @ line:1492 @@@@
  {
    { m="solid", }
    { x=136.000, y=-1720.000, tex=TEX_MAP["COP1_1"], }
    { x=136.000, y=-1624.000, tex=TEX_MAP["COP1_1"], }
    { x=40.000, y=-1624.000, tex=TEX_MAP["COP1_1"], }
    { x=40.000, y=-1720.000, tex=TEX_MAP["COP1_1"], }
    { t=424.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=472.000, y=-2024.000, tex=TEX_MAP["COP1_1"], }
    { x=472.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-2024.000, tex=TEX_MAP["COP1_1"], }
    { t=424.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=136.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=40.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=40.000, y=-2024.000, tex=TEX_MAP["COP1_1"], }
    { x=136.000, y=-2024.000, tex=TEX_MAP["COP1_1"], }
    { t=424.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=104.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=104.000, y=-1720.000, tex=TEX_MAP["COP1_1"], }
    { x=80.000, y=-1720.000, tex=TEX_MAP["COP1_1"], }
    { x=80.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { t=424.000, tex=TEX_MAP["COP1_1"], }
    { b=392.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=376.000, y=-1984.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { x=136.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { x=136.000, y=-1984.000, tex=TEX_MAP["COP1_1"], }
    { t=424.000, tex=TEX_MAP["COP1_1"], }
    { b=392.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=432.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { x=432.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1928.000, tex=TEX_MAP["COP1_1"], }
    { t=424.000, tex=TEX_MAP["COP1_1"], }
    { b=392.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=432.000, y=-1656.000, tex=TEX_MAP["COP1_1"], }
    { x=136.000, y=-1656.000, tex=TEX_MAP["COP1_1"], }
    { x=136.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { x=432.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { t=424.000, tex=TEX_MAP["COP1_1"], }
    { b=392.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-1656.000, tex=TEX_MAP["CITY2_8"], }
    { x=528.000, y=-1568.000, tex=TEX_MAP["CITY2_8"], }
    { x=-16.000, y=-1568.000, tex=TEX_MAP["CITY2_8"], }
    { x=-16.000, y=-1656.000, tex=TEX_MAP["CITY2_8"], }
    { t=416.000, tex=TEX_MAP["CITY2_8"], }
    { b=408.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=80.000, y=-2080.000, tex=TEX_MAP["CITY2_8"], }
    { x=80.000, y=-1656.000, tex=TEX_MAP["CITY2_8"], }
    { x=-16.000, y=-1656.000, tex=TEX_MAP["CITY2_8"], }
    { x=-16.000, y=-2080.000, tex=TEX_MAP["CITY2_8"], }
    { t=416.000, tex=TEX_MAP["CITY2_8"], }
    { b=408.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-2080.000, tex=TEX_MAP["CITY2_8"], }
    { x=528.000, y=-1984.000, tex=TEX_MAP["CITY2_8"], }
    { x=80.000, y=-1984.000, tex=TEX_MAP["CITY2_8"], }
    { x=80.000, y=-2080.000, tex=TEX_MAP["CITY2_8"], }
    { t=416.000, tex=TEX_MAP["CITY2_8"], }
    { b=408.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-1984.000, tex=TEX_MAP["CITY2_8"], }
    { x=528.000, y=-1656.000, tex=TEX_MAP["CITY2_8"], }
    { x=432.000, y=-1656.000, tex=TEX_MAP["CITY2_8"], }
    { x=432.000, y=-1984.000, tex=TEX_MAP["CITY2_8"], }
    { t=416.000, tex=TEX_MAP["CITY2_8"], }
    { b=408.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=408.000, y=-1960.000, tex=TEX_MAP["SKY4"], }
    { x=408.000, y=-1680.000, tex=TEX_MAP["SKY4"], }
    { x=104.000, y=-1680.000, tex=TEX_MAP["SKY4"], }
    { x=104.000, y=-1960.000, tex=TEX_MAP["SKY4"], }
    { t=424.000, tex=TEX_MAP["SKY4"], }
    { b=416.000, tex=TEX_MAP["SKY4"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { x=264.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { x=240.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { x=104.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { t=416.000, tex=TEX_MAP["COP1_1"], }
    { b=400.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { x=376.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { x=400.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { x=264.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { t=416.000, tex=TEX_MAP["COP1_1"], }
    { b=400.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=272.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { x=384.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { x=248.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { t=416.000, tex=TEX_MAP["COP1_1"], }
    { b=400.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=104.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { x=240.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { x=264.000, y=-1960.000, tex=TEX_MAP["COP1_1"], }
    { x=128.000, y=-1680.000, tex=TEX_MAP["COP1_1"], }
    { t=416.000, tex=TEX_MAP["COP1_1"], }
    { b=400.000, tex=TEX_MAP["COP1_1"], }
  }
--    @@@@ FIX BRUSH @ line:1628 @@@@
--    @@@@ FIX BRUSH @ line:1636 @@@@
--    @@@@ FIX BRUSH @ line:1644 @@@@
--    @@@@ FIX BRUSH @ line:1651 @@@@
--    @@@@ FIX BRUSH @ line:1659 @@@@
--    @@@@ FIX BRUSH @ line:1667 @@@@
  {
    { m="solid", }
    { x=1344.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-1360.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-1360.000, tex=TEX_MAP["CITY2_6"], }
    { x=1088.000, y=-1408.000, tex=TEX_MAP["CITY2_6"], }
    { t=-14.400, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.66896, nz=0.74329 }, }
    { b=-72.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.66896, nz=-0.74329 }, }
  }
--    @@@@ FIX BRUSH @ line:1682 @@@@
--    @@@@ FIX BRUSH @ line:1690 @@@@
--    @@@@ FIX BRUSH @ line:1698 @@@@
  {
    { m="solid", }
    { x=252.000, y=-1808.000, tex=TEX_MAP["*TELEPORT"], }
    { x=252.000, y=-1760.000, tex=TEX_MAP["*TELEPORT"], }
    { x=248.000, y=-1760.000, tex=TEX_MAP["*TELEPORT"], }
    { x=248.000, y=-1808.000, tex=TEX_MAP["*TELEPORT"], }
    { t=148.000, tex=TEX_MAP["*TELEPORT"], }
    { b=44.000, tex=TEX_MAP["*TELEPORT"], }
  }
  {
    { m="solid", }
    { x=260.000, y=-1816.000, tex=TEX_MAP["COP1_1"], }
    { x=260.000, y=-1808.000, tex=TEX_MAP["COP1_1"], }
    { x=236.000, y=-1808.000, tex=TEX_MAP["COP1_1"], }
    { x=236.000, y=-1816.000, tex=TEX_MAP["COP1_1"], }
    { t=152.000, tex=TEX_MAP["COP1_1"], }
    { b=40.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=260.000, y=-1760.000, tex=TEX_MAP["COP1_1"], }
    { x=260.000, y=-1752.000, tex=TEX_MAP["COP1_1"], }
    { x=236.000, y=-1752.000, tex=TEX_MAP["COP1_1"], }
    { x=236.000, y=-1760.000, tex=TEX_MAP["COP1_1"], }
    { t=152.000, tex=TEX_MAP["COP1_1"], }
    { b=40.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=260.000, y=-1816.000, tex=TEX_MAP["COP1_1"], }
    { x=260.000, y=-1752.000, tex=TEX_MAP["COP1_1"], }
    { x=236.000, y=-1752.000, tex=TEX_MAP["COP1_1"], }
    { x=236.000, y=-1816.000, tex=TEX_MAP["COP1_1"], }
    { t=152.000, tex=TEX_MAP["COP1_1"], }
    { b=144.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=260.000, y=-1816.000, tex=TEX_MAP["COP1_1"], }
    { x=260.000, y=-1752.000, tex=TEX_MAP["COP1_1"], }
    { x=236.000, y=-1752.000, tex=TEX_MAP["COP1_1"], }
    { x=236.000, y=-1816.000, tex=TEX_MAP["COP1_1"], }
    { t=48.000, tex=TEX_MAP["COP1_1"], }
    { b=40.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1400.000, y=-1184.000, tex=TEX_MAP["CITY2_7"], }
    { x=1400.000, y=-992.000, tex=TEX_MAP["CITY2_7"], }
    { x=1344.000, y=-992.000, tex=TEX_MAP["CITY2_7"], }
    { x=1344.000, y=-1184.000, tex=TEX_MAP["CITY2_7"], }
    { t=-32.000, tex=TEX_MAP["CITY2_7"], }
    { b=-48.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1456.000, y=-1184.000, tex=TEX_MAP["CITY2_7"], }
    { x=1456.000, y=-992.000, tex=TEX_MAP["CITY2_7"], }
    { x=1400.000, y=-992.000, tex=TEX_MAP["CITY2_7"], }
    { x=1400.000, y=-1184.000, tex=TEX_MAP["CITY2_7"], }
    { t=-16.000, tex=TEX_MAP["CITY2_7"], }
    { b=-32.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1512.000, y=-1184.000, tex=TEX_MAP["CITY2_7"], }
    { x=1512.000, y=-992.000, tex=TEX_MAP["CITY2_7"], }
    { x=1456.000, y=-992.000, tex=TEX_MAP["CITY2_7"], }
    { x=1456.000, y=-1184.000, tex=TEX_MAP["CITY2_7"], }
    { t=0.000, tex=TEX_MAP["CITY2_7"], }
    { b=-16.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1824.000, y=-1184.000, tex=TEX_MAP["CITY2_7"], }
    { x=1824.000, y=-992.000, tex=TEX_MAP["CITY2_7"], }
    { x=1512.000, y=-992.000, tex=TEX_MAP["CITY2_7"], }
    { x=1512.000, y=-1184.000, tex=TEX_MAP["CITY2_7"], }
    { t=16.000, tex=TEX_MAP["CITY2_7"], }
    { b=0.000, tex=TEX_MAP["CITY2_7"], }
  }
--    @@@@ FIX BRUSH @ line:1778 @@@@
--    @@@@ FIX BRUSH @ line:1785 @@@@
--    @@@@ FIX BRUSH @ line:1792 @@@@
--    @@@@ FIX BRUSH @ line:1799 @@@@
  {
    { m="solid", }
    { x=584.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { x=584.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=456.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=456.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { t=104.000, tex=TEX_MAP["METAL4_4"], slope={ nx=0.18429, ny=0.00000, nz=0.98287 }, }
    { b=64.000, tex=TEX_MAP["METAL4_4"], slope={ nx=-0.18429, ny=0.00000, nz=-0.98287 }, }
  }
  {
    { m="solid", }
    { x=584.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { x=584.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=456.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=456.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { t=232.000, tex=TEX_MAP["METAL4_4"], slope={ nx=0.18429, ny=0.00000, nz=0.98287 }, }
    { b=192.000, tex=TEX_MAP["METAL4_4"], slope={ nx=-0.18429, ny=0.00000, nz=-0.98287 }, }
  }
--    @@@@ FIX BRUSH @ line:1822 @@@@
--    @@@@ FIX BRUSH @ line:1829 @@@@
--    @@@@ FIX BRUSH @ line:1836 @@@@
--    @@@@ FIX BRUSH @ line:1843 @@@@
  {
    { m="solid", }
    { x=712.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { x=712.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=584.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=584.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { t=80.000, tex=TEX_MAP["METAL4_4"], slope={ nx=0.40082, ny=0.00000, nz=0.91616 }, }
    { b=8.000, tex=TEX_MAP["METAL4_4"], }
  }
  {
    { m="solid", }
    { x=712.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { x=712.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=584.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=584.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { t=216.000, tex=TEX_MAP["METAL4_4"], }
    { b=136.000, tex=TEX_MAP["METAL4_4"], slope={ nx=-0.40082, ny=0.00000, nz=-0.91616 }, }
  }
  {
    { m="solid", }
    { x=712.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { x=712.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=696.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=696.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { t=224.000, tex=TEX_MAP["METAL4_4"], }
    { b=192.000, tex=TEX_MAP["METAL4_4"], }
  }
  {
    { m="solid", }
    { x=712.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=712.000, y=-1008.000, tex=TEX_MAP["METAL4_4"], }
    { x=696.000, y=-1008.000, tex=TEX_MAP["METAL4_4"], }
    { x=696.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { t=224.000, tex=TEX_MAP["METAL4_4"], }
    { b=216.000, tex=TEX_MAP["METAL4_4"], }
  }
  {
    { m="solid", }
    { x=712.000, y=-1168.000, tex=TEX_MAP["METAL4_4"], }
    { x=712.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { x=696.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { x=696.000, y=-1168.000, tex=TEX_MAP["METAL4_4"], }
    { t=224.000, tex=TEX_MAP["METAL4_4"], }
    { b=216.000, tex=TEX_MAP["METAL4_4"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=704.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=688.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=688.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-88.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-1400.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-984.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-984.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-1400.000, tex=TEX_MAP["CITY2_6"], }
    { t=88.000, tex=TEX_MAP["CITY2_6"], }
    { b=80.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1348.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { x=1348.000, y=-352.000, tex=TEX_MAP["WMET4_8"], }
    { x=1216.000, y=-352.000, tex=TEX_MAP["WMET4_8"], }
    { x=1216.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { t=144.000, tex=TEX_MAP["WMET4_8"], }
    { b=128.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1380.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { x=1380.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1348.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1348.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { t=128.000, tex=TEX_MAP["WMET4_8"], }
    { b=120.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1412.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { x=1412.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1380.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1380.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { t=112.000, tex=TEX_MAP["WMET4_8"], }
    { b=104.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1444.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { x=1444.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1412.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1412.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { t=96.000, tex=TEX_MAP["WMET4_8"], }
    { b=88.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1476.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { x=1476.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1444.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1444.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { t=80.000, tex=TEX_MAP["WMET4_8"], }
    { b=72.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1508.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { x=1508.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1476.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1476.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { t=64.000, tex=TEX_MAP["WMET4_8"], }
    { b=56.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1540.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { x=1540.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1508.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1508.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { t=48.000, tex=TEX_MAP["WMET4_8"], }
    { b=40.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1572.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { x=1572.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1540.000, y=-512.000, tex=TEX_MAP["WMET4_8"], }
    { x=1540.000, y=-640.000, tex=TEX_MAP["WMET4_8"], }
    { t=32.000, tex=TEX_MAP["WMET4_8"], }
    { b=24.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=1328.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=1328.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { t=136.000, tex=TEX_MAP["CITY2_6"], }
    { b=11.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1616.000, y=-832.000, tex=TEX_MAP["CITY2_6"], }
    { x=1616.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-832.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], }
    { b=11.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1632.000, y=-816.000, tex=TEX_MAP["CITY2_7"], }
    { x=1632.000, y=-640.000, tex=TEX_MAP["CITY2_7"], }
    { x=1280.000, y=-640.000, tex=TEX_MAP["CITY2_7"], }
    { x=1280.000, y=-816.000, tex=TEX_MAP["CITY2_7"], }
    { t=16.000, tex=TEX_MAP["CITY2_7"], }
    { b=8.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1616.000, y=-656.000, tex=TEX_MAP["CITY2_6"], }
    { x=1616.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1216.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1216.000, y=-656.000, tex=TEX_MAP["CITY2_6"], }
    { t=424.000, tex=TEX_MAP["CITY2_6"], }
    { b=11.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1216.000, y=-656.000, tex=TEX_MAP["CITY2_6"], }
    { x=1216.000, y=-352.000, tex=TEX_MAP["CITY2_6"], }
    { x=1200.000, y=-352.000, tex=TEX_MAP["CITY2_6"], }
    { x=1200.000, y=-656.000, tex=TEX_MAP["CITY2_6"], }
    { t=424.000, tex=TEX_MAP["CITY2_6"], }
    { b=131.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1824.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1664.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1664.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { t=424.000, tex=TEX_MAP["CITY2_6"], }
    { b=16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1600.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1328.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1328.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { x=1600.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { t=424.000, tex=TEX_MAP["CITY2_6"], }
    { b=16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1664.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1600.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1600.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { x=1664.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { t=424.000, tex=TEX_MAP["CITY2_6"], }
    { b=220.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1664.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1600.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1600.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { x=1664.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { t=136.000, tex=TEX_MAP["CITY2_6"], }
    { b=16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-368.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-144.000, tex=TEX_MAP["CITY2_6"], }
    { x=1200.000, y=-144.000, tex=TEX_MAP["CITY2_6"], }
    { x=1200.000, y=-368.000, tex=TEX_MAP["CITY2_6"], }
    { t=136.000, tex=TEX_MAP["CITY2_6"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1564.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { x=1564.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1548.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1548.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { t=24.000, tex=TEX_MAP["COP1_1"], }
    { b=16.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1532.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { x=1532.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1516.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1516.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { t=40.000, tex=TEX_MAP["COP1_1"], }
    { b=32.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1500.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { x=1500.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1484.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1484.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { t=56.000, tex=TEX_MAP["COP1_1"], }
    { b=48.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1468.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { x=1468.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1452.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1452.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { t=72.000, tex=TEX_MAP["COP1_1"], }
    { b=64.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1436.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { x=1436.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1420.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1420.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { t=88.000, tex=TEX_MAP["COP1_1"], }
    { b=80.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1404.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { x=1404.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1388.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1388.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { t=104.000, tex=TEX_MAP["COP1_1"], }
    { b=96.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1372.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { x=1372.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1356.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1356.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { t=120.000, tex=TEX_MAP["COP1_1"], }
    { b=112.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1372.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1372.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1356.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1356.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { t=136.000, tex=TEX_MAP["COP1_1"], }
    { b=112.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1404.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1404.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1388.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1388.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { t=120.000, tex=TEX_MAP["COP1_1"], }
    { b=96.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1436.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1436.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1420.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1420.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { t=104.000, tex=TEX_MAP["COP1_1"], }
    { b=80.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1468.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1468.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1452.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1452.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { t=88.000, tex=TEX_MAP["COP1_1"], }
    { b=64.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1500.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1500.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1484.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1484.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { t=72.000, tex=TEX_MAP["COP1_1"], }
    { b=48.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1532.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1532.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1516.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1516.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { t=56.000, tex=TEX_MAP["COP1_1"], }
    { b=32.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1564.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { x=1564.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1548.000, y=-504.000, tex=TEX_MAP["COP1_1"], }
    { x=1548.000, y=-512.000, tex=TEX_MAP["COP1_1"], }
    { t=40.000, tex=TEX_MAP["COP1_1"], }
    { b=16.000, tex=TEX_MAP["COP1_1"], }
  }
--    @@@@ FIX BRUSH @ line:2162 @@@@
--    @@@@ FIX BRUSH @ line:2170 @@@@
--    @@@@ FIX BRUSH @ line:2178 @@@@
--    @@@@ FIX BRUSH @ line:2186 @@@@
--    @@@@ FIX BRUSH @ line:2194 @@@@
--    @@@@ FIX BRUSH @ line:2202 @@@@
  {
    { m="solid", }
    { x=320.000, y=-984.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-952.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-952.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-984.000, tex=TEX_MAP["CITY2_6"], }
    { t=96.000, tex=TEX_MAP["CITY2_6"], }
    { b=88.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-952.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-920.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-920.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-952.000, tex=TEX_MAP["CITY2_6"], }
    { t=104.000, tex=TEX_MAP["CITY2_6"], }
    { b=96.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-920.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-920.000, tex=TEX_MAP["CITY2_6"], }
    { t=112.000, tex=TEX_MAP["CITY2_6"], }
    { b=104.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-860.000, tex=TEX_MAP["COP1_1"], }
    { x=232.000, y=-836.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-836.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-860.000, tex=TEX_MAP["COP1_1"], }
    { t=128.000, tex=TEX_MAP["COP1_1"], }
    { b=120.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-860.000, tex=TEX_MAP["COP1_1"], }
    { x=232.000, y=-836.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-836.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-860.000, tex=TEX_MAP["COP1_1"], }
    { t=232.000, tex=TEX_MAP["COP1_1"], }
    { b=224.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-860.000, tex=TEX_MAP["COP1_1"], }
    { x=232.000, y=-836.000, tex=TEX_MAP["COP1_1"], }
    { x=224.000, y=-836.000, tex=TEX_MAP["COP1_1"], }
    { x=224.000, y=-860.000, tex=TEX_MAP["COP1_1"], }
    { t=232.000, tex=TEX_MAP["COP1_1"], }
    { b=120.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=176.000, y=-860.000, tex=TEX_MAP["COP1_1"], }
    { x=176.000, y=-836.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-836.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-860.000, tex=TEX_MAP["COP1_1"], }
    { t=232.000, tex=TEX_MAP["COP1_1"], }
    { b=120.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=224.000, y=-852.000, tex=TEX_MAP["*TELEPORT"], }
    { x=224.000, y=-848.000, tex=TEX_MAP["*TELEPORT"], }
    { x=176.000, y=-848.000, tex=TEX_MAP["*TELEPORT"], }
    { x=176.000, y=-852.000, tex=TEX_MAP["*TELEPORT"], }
    { t=228.000, tex=TEX_MAP["*TELEPORT"], }
    { b=124.000, tex=TEX_MAP["*TELEPORT"], }
  }
--    @@@@ FIX BRUSH @ line:2274 @@@@
--    @@@@ FIX BRUSH @ line:2282 @@@@
--    @@@@ FIX BRUSH @ line:2290 @@@@
--    @@@@ FIX BRUSH @ line:2298 @@@@
  {
    { m="solid", }
    { x=320.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-704.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-704.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { t=408.000, tex=TEX_MAP["CITY2_6"], }
    { b=104.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-1400.000, tex=TEX_MAP["CITY2_8"], }
    { x=320.000, y=-704.000, tex=TEX_MAP["CITY2_8"], }
    { x=80.000, y=-704.000, tex=TEX_MAP["CITY2_8"], }
    { x=80.000, y=-1400.000, tex=TEX_MAP["CITY2_8"], }
    { t=424.000, tex=TEX_MAP["CITY2_8"], }
    { b=408.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=336.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=-704.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-704.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { t=408.000, tex=TEX_MAP["CITY2_6"], }
    { b=88.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=80.000, y=-1056.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-704.000, tex=TEX_MAP["CITY2_6"], }
    { x=64.000, y=-704.000, tex=TEX_MAP["CITY2_6"], }
    { x=64.000, y=-1056.000, tex=TEX_MAP["CITY2_6"], }
    { t=408.000, tex=TEX_MAP["CITY2_6"], }
    { b=88.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=80.000, y=-1400.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-1128.000, tex=TEX_MAP["CITY2_6"], }
    { x=64.000, y=-1128.000, tex=TEX_MAP["CITY2_6"], }
    { x=64.000, y=-1400.000, tex=TEX_MAP["CITY2_6"], }
    { t=408.000, tex=TEX_MAP["CITY2_6"], }
    { b=88.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=80.000, y=-1128.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-1056.000, tex=TEX_MAP["CITY2_6"], }
    { x=64.000, y=-1056.000, tex=TEX_MAP["CITY2_6"], }
    { x=64.000, y=-1128.000, tex=TEX_MAP["CITY2_6"], }
    { t=408.000, tex=TEX_MAP["CITY2_6"], }
    { b=320.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=80.000, y=-1128.000, tex=TEX_MAP["CITY2_6"], }
    { x=80.000, y=-1056.000, tex=TEX_MAP["CITY2_6"], }
    { x=-32.000, y=-1056.000, tex=TEX_MAP["CITY2_6"], }
    { x=-32.000, y=-1128.000, tex=TEX_MAP["CITY2_6"], }
    { t=240.000, tex=TEX_MAP["CITY2_6"], }
    { b=88.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=336.000, y=-1400.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-1400.000, tex=TEX_MAP["CITY2_6"], }
    { t=408.000, tex=TEX_MAP["CITY2_6"], }
    { b=88.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=336.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-1008.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-1168.000, tex=TEX_MAP["CITY2_6"], }
    { t=408.000, tex=TEX_MAP["CITY2_6"], }
    { b=232.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:2378 @@@@
--    @@@@ FIX BRUSH @ line:2386 @@@@
  {
    { m="solid", }
    { x=1784.000, y=-752.000, tex=TEX_MAP["COP1_1"], }
    { x=1784.000, y=-704.000, tex=TEX_MAP["COP1_1"], }
    { x=1744.000, y=-704.000, tex=TEX_MAP["COP1_1"], }
    { x=1744.000, y=-752.000, tex=TEX_MAP["COP1_1"], }
    { t=128.000, tex=TEX_MAP["COP1_1"], }
    { b=120.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1776.000, y=-1136.000, tex=TEX_MAP["COP1_1"], }
    { x=1776.000, y=-1096.000, tex=TEX_MAP["COP1_1"], }
    { x=1736.000, y=-1096.000, tex=TEX_MAP["COP1_1"], }
    { x=1736.000, y=-1136.000, tex=TEX_MAP["COP1_1"], }
    { t=128.000, tex=TEX_MAP["COP1_1"], }
    { b=120.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1544.000, y=-304.000, tex=TEX_MAP["COP1_1"], }
    { x=1544.000, y=-264.000, tex=TEX_MAP["COP1_1"], }
    { x=1496.000, y=-264.000, tex=TEX_MAP["COP1_1"], }
    { x=1496.000, y=-304.000, tex=TEX_MAP["COP1_1"], }
    { t=128.000, tex=TEX_MAP["COP1_1"], }
    { b=120.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=224.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { x=224.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=216.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=216.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { t=264.000, tex=TEX_MAP["COP1_1"], }
    { b=256.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=196.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { x=196.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=188.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=188.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { t=264.000, tex=TEX_MAP["COP1_1"], }
    { b=256.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=168.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=160.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=160.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { t=264.000, tex=TEX_MAP["COP1_1"], }
    { b=256.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=168.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=160.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=160.000, y=-1336.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-1336.000, tex=TEX_MAP["COP1_1"], }
    { t=260.000, tex=TEX_MAP["COP1_1"], }
    { b=220.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=196.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=188.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=188.000, y=-1336.000, tex=TEX_MAP["COP1_1"], }
    { x=196.000, y=-1336.000, tex=TEX_MAP["COP1_1"], }
    { t=260.000, tex=TEX_MAP["COP1_1"], }
    { b=220.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=224.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=216.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=216.000, y=-1336.000, tex=TEX_MAP["COP1_1"], }
    { x=224.000, y=-1336.000, tex=TEX_MAP["COP1_1"], }
    { t=260.000, tex=TEX_MAP["COP1_1"], }
    { b=220.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=224.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { x=224.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=216.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=216.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { t=228.000, tex=TEX_MAP["COP1_1"], }
    { b=220.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=196.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { x=196.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=188.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=188.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { t=228.000, tex=TEX_MAP["COP1_1"], }
    { b=220.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=168.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { x=168.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=160.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=160.000, y=-1368.000, tex=TEX_MAP["COP1_1"], }
    { t=228.000, tex=TEX_MAP["COP1_1"], }
    { b=220.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-1360.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-1312.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1312.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1360.000, tex=TEX_MAP["CITY2_7"], }
    { t=-32.000, tex=TEX_MAP["CITY2_7"], }
    { b=-88.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-1312.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-1264.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1264.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1312.000, tex=TEX_MAP["CITY2_7"], }
    { t=-48.000, tex=TEX_MAP["CITY2_7"], }
    { b=-88.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-720.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-368.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-368.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-720.000, tex=TEX_MAP["CITY2_7"], }
    { t=16.000, tex=TEX_MAP["CITY2_7"], }
    { b=-88.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-864.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-816.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-816.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-864.000, tex=TEX_MAP["CITY2_7"], }
    { t=-32.000, tex=TEX_MAP["CITY2_7"], }
    { b=-88.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-912.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-864.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-864.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-912.000, tex=TEX_MAP["CITY2_7"], }
    { t=-48.000, tex=TEX_MAP["CITY2_7"], }
    { b=-88.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1036.000, y=-1128.000, tex=TEX_MAP["COP1_1"], }
    { x=1036.000, y=-1064.000, tex=TEX_MAP["COP1_1"], }
    { x=1012.000, y=-1064.000, tex=TEX_MAP["COP1_1"], }
    { x=1012.000, y=-1128.000, tex=TEX_MAP["COP1_1"], }
    { t=-32.000, tex=TEX_MAP["COP1_1"], }
    { b=-40.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1036.000, y=-1128.000, tex=TEX_MAP["COP1_1"], }
    { x=1036.000, y=-1064.000, tex=TEX_MAP["COP1_1"], }
    { x=1012.000, y=-1064.000, tex=TEX_MAP["COP1_1"], }
    { x=1012.000, y=-1128.000, tex=TEX_MAP["COP1_1"], }
    { t=72.000, tex=TEX_MAP["COP1_1"], }
    { b=64.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1036.000, y=-1072.000, tex=TEX_MAP["COP1_1"], }
    { x=1036.000, y=-1064.000, tex=TEX_MAP["COP1_1"], }
    { x=1012.000, y=-1064.000, tex=TEX_MAP["COP1_1"], }
    { x=1012.000, y=-1072.000, tex=TEX_MAP["COP1_1"], }
    { t=72.000, tex=TEX_MAP["COP1_1"], }
    { b=-40.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1036.000, y=-1128.000, tex=TEX_MAP["COP1_1"], }
    { x=1036.000, y=-1120.000, tex=TEX_MAP["COP1_1"], }
    { x=1012.000, y=-1120.000, tex=TEX_MAP["COP1_1"], }
    { x=1012.000, y=-1128.000, tex=TEX_MAP["COP1_1"], }
    { t=72.000, tex=TEX_MAP["COP1_1"], }
    { b=-40.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1028.000, y=-1120.000, tex=TEX_MAP["*TELEPORT"], }
    { x=1028.000, y=-1072.000, tex=TEX_MAP["*TELEPORT"], }
    { x=1024.000, y=-1072.000, tex=TEX_MAP["*TELEPORT"], }
    { x=1024.000, y=-1120.000, tex=TEX_MAP["*TELEPORT"], }
    { t=68.000, tex=TEX_MAP["*TELEPORT"], }
    { b=-36.000, tex=TEX_MAP["*TELEPORT"], }
  }
  {
    { m="solid", }
    { x=1064.000, y=-1152.000, tex=TEX_MAP["CITY2_7"], }
    { x=1064.000, y=-1040.000, tex=TEX_MAP["CITY2_7"], }
    { x=984.000, y=-1040.000, tex=TEX_MAP["CITY2_7"], }
    { x=984.000, y=-1152.000, tex=TEX_MAP["CITY2_7"], }
    { t=-48.000, tex=TEX_MAP["CITY2_7"], }
    { b=-72.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-1176.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-1016.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1016.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1176.000, tex=TEX_MAP["CITY2_7"], }
    { t=-56.000, tex=TEX_MAP["CITY2_7"], }
    { b=-72.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-920.000, tex=TEX_MAP["WMET4_8"], }
    { x=1344.000, y=-768.000, tex=TEX_MAP["WMET4_8"], }
    { x=672.000, y=-768.000, tex=TEX_MAP["WMET4_8"], }
    { x=672.000, y=-920.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-1496.000, tex=TEX_MAP["WMET4_8"], }
    { x=1344.000, y=-1256.000, tex=TEX_MAP["WMET4_8"], }
    { x=672.000, y=-1256.000, tex=TEX_MAP["WMET4_8"], }
    { x=672.000, y=-1496.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=856.000, y=-1432.000, tex=TEX_MAP["WMET4_8"], }
    { x=856.000, y=-760.000, tex=TEX_MAP["WMET4_8"], }
    { x=704.000, y=-760.000, tex=TEX_MAP["WMET4_8"], }
    { x=704.000, y=-1432.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-1424.000, tex=TEX_MAP["WMET4_8"], }
    { x=1344.000, y=-832.000, tex=TEX_MAP["WMET4_8"], }
    { x=1192.000, y=-832.000, tex=TEX_MAP["WMET4_8"], }
    { x=1192.000, y=-1424.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1696.000, y=-1184.000, tex=TEX_MAP["WMET4_8"], }
    { x=1696.000, y=-992.000, tex=TEX_MAP["WMET4_8"], }
    { x=1648.000, y=-992.000, tex=TEX_MAP["WMET4_8"], }
    { x=1648.000, y=-1184.000, tex=TEX_MAP["WMET4_8"], }
    { t=144.000, tex=TEX_MAP["WMET4_8"], }
    { b=128.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1648.000, y=-1184.000, tex=TEX_MAP["WMET4_8"], }
    { x=1648.000, y=-992.000, tex=TEX_MAP["WMET4_8"], }
    { x=1344.000, y=-992.000, tex=TEX_MAP["WMET4_8"], }
    { x=1344.000, y=-1184.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], slope={ nx=0.28097, ny=0.00000, nz=0.95972 }, }
    { b=127.000, tex=TEX_MAP["WMET4_8"], slope={ nx=-0.28097, ny=0.00000, nz=-0.95972 }, }
  }
  {
    { m="solid", }
    { x=1192.000, y=-1256.000, tex=TEX_MAP["WMET4_8"], }
    { x=1192.000, y=-1176.000, tex=TEX_MAP["WMET4_8"], }
    { x=1112.000, y=-1256.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=936.000, y=-920.000, tex=TEX_MAP["WMET4_8"], }
    { x=856.000, y=-920.000, tex=TEX_MAP["WMET4_8"], }
    { x=856.000, y=-1000.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1192.000, y=-1000.000, tex=TEX_MAP["WMET4_8"], }
    { x=1192.000, y=-920.000, tex=TEX_MAP["WMET4_8"], }
    { x=1112.000, y=-920.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1216.000, y=-352.000, tex=TEX_MAP["CITY2_6"], }
    { x=1344.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { x=1328.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { x=1200.000, y=-352.000, tex=TEX_MAP["CITY2_6"], }
    { t=336.000, tex=TEX_MAP["CITY2_6"], }
    { b=131.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1840.000, y=-352.000, tex=TEX_MAP["CITY2_6"], }
    { x=1712.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { x=1696.000, y=-224.000, tex=TEX_MAP["CITY2_6"], }
    { x=1824.000, y=-352.000, tex=TEX_MAP["CITY2_6"], }
    { t=336.000, tex=TEX_MAP["CITY2_6"], }
    { b=11.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1920.000, y=-1184.000, tex=TEX_MAP["WMET4_8"], }
    { x=1920.000, y=-128.000, tex=TEX_MAP["WMET4_8"], }
    { x=1696.000, y=-128.000, tex=TEX_MAP["WMET4_8"], }
    { x=1696.000, y=-1184.000, tex=TEX_MAP["WMET4_8"], }
    { t=144.000, tex=TEX_MAP["WMET4_8"], }
    { b=128.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1696.000, y=-352.000, tex=TEX_MAP["WMET4_8"], }
    { x=1696.000, y=-128.000, tex=TEX_MAP["WMET4_8"], }
    { x=1216.000, y=-128.000, tex=TEX_MAP["WMET4_8"], }
    { x=1216.000, y=-352.000, tex=TEX_MAP["WMET4_8"], }
    { t=144.000, tex=TEX_MAP["WMET4_8"], }
    { b=128.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1696.000, y=-416.000, tex=TEX_MAP["WMET4_8"], }
    { x=1696.000, y=-352.000, tex=TEX_MAP["WMET4_8"], }
    { x=1632.000, y=-352.000, tex=TEX_MAP["WMET4_8"], }
    { t=144.000, tex=TEX_MAP["WMET4_8"], }
    { b=128.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=1408.000, y=-352.000, tex=TEX_MAP["WMET4_8"], }
    { x=1344.000, y=-352.000, tex=TEX_MAP["WMET4_8"], }
    { x=1344.000, y=-416.000, tex=TEX_MAP["WMET4_8"], }
    { t=144.000, tex=TEX_MAP["WMET4_8"], }
    { b=128.000, tex=TEX_MAP["WMET4_8"], }
  }
--    @@@@ FIX BRUSH @ line:2701 @@@@
--    @@@@ FIX BRUSH @ line:2709 @@@@
--    @@@@ FIX BRUSH @ line:2717 @@@@
--    @@@@ FIX BRUSH @ line:2725 @@@@
--    @@@@ FIX BRUSH @ line:2733 @@@@
  {
    { m="solid", }
    { x=1728.000, y=-328.000, tex=TEX_MAP["COP1_1"], }
    { x=1728.000, y=-296.000, tex=TEX_MAP["COP1_1"], }
    { x=1312.000, y=-296.000, tex=TEX_MAP["COP1_1"], }
    { x=1312.000, y=-328.000, tex=TEX_MAP["COP1_1"], }
    { t=480.000, tex=TEX_MAP["COP1_1"], }
    { b=451.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1736.000, y=-560.000, tex=TEX_MAP["COP1_1"], }
    { x=1736.000, y=-296.000, tex=TEX_MAP["COP1_1"], }
    { x=1704.000, y=-296.000, tex=TEX_MAP["COP1_1"], }
    { x=1704.000, y=-560.000, tex=TEX_MAP["COP1_1"], }
    { t=480.000, tex=TEX_MAP["COP1_1"], }
    { b=451.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1368.000, y=-560.000, tex=TEX_MAP["COP1_1"], }
    { x=1368.000, y=-296.000, tex=TEX_MAP["COP1_1"], }
    { x=1336.000, y=-296.000, tex=TEX_MAP["COP1_1"], }
    { x=1336.000, y=-560.000, tex=TEX_MAP["COP1_1"], }
    { t=480.000, tex=TEX_MAP["COP1_1"], }
    { b=451.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1728.000, y=-560.000, tex=TEX_MAP["COP1_1"], }
    { x=1728.000, y=-528.000, tex=TEX_MAP["COP1_1"], }
    { x=1336.000, y=-528.000, tex=TEX_MAP["COP1_1"], }
    { x=1336.000, y=-560.000, tex=TEX_MAP["COP1_1"], }
    { t=480.000, tex=TEX_MAP["COP1_1"], }
    { b=451.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1728.000, y=-560.000, tex=TEX_MAP["SKY4"], }
    { x=1728.000, y=-296.000, tex=TEX_MAP["SKY4"], }
    { x=1336.000, y=-296.000, tex=TEX_MAP["SKY4"], }
    { x=1336.000, y=-560.000, tex=TEX_MAP["SKY4"], }
    { t=488.000, tex=TEX_MAP["SKY4"], }
    { b=475.000, tex=TEX_MAP["SKY4"], }
  }
--    @@@@ FIX BRUSH @ line:2781 @@@@
--    @@@@ FIX BRUSH @ line:2789 @@@@
--    @@@@ FIX BRUSH @ line:2797 @@@@
--    @@@@ FIX BRUSH @ line:2805 @@@@
  {
    { m="solid", }
    { x=1600.000, y=-1184.000, tex=TEX_MAP["COP1_1"], }
    { x=1600.000, y=-992.000, tex=TEX_MAP["COP1_1"], }
    { x=1576.000, y=-992.000, tex=TEX_MAP["COP1_1"], }
    { x=1576.000, y=-1184.000, tex=TEX_MAP["COP1_1"], }
    { t=144.000, tex=TEX_MAP["COP1_1"], }
    { b=136.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1496.000, y=-1184.000, tex=TEX_MAP["COP1_1"], }
    { x=1496.000, y=-992.000, tex=TEX_MAP["COP1_1"], }
    { x=1472.000, y=-992.000, tex=TEX_MAP["COP1_1"], }
    { x=1472.000, y=-1184.000, tex=TEX_MAP["COP1_1"], }
    { t=176.000, tex=TEX_MAP["COP1_1"], }
    { b=168.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1376.000, y=-1184.000, tex=TEX_MAP["COP1_1"], }
    { x=1376.000, y=-992.000, tex=TEX_MAP["COP1_1"], }
    { x=1352.000, y=-992.000, tex=TEX_MAP["COP1_1"], }
    { x=1352.000, y=-1184.000, tex=TEX_MAP["COP1_1"], }
    { t=212.000, tex=TEX_MAP["COP1_1"], }
    { b=204.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=992.000, y=-768.000, tex=TEX_MAP["CITY2_8"], }
    { x=704.000, y=-768.000, tex=TEX_MAP["CITY2_8"], }
    { x=704.000, y=-1408.000, tex=TEX_MAP["CITY2_8"], }
    { x=992.000, y=-1408.000, tex=TEX_MAP["CITY2_8"], }
    { t=408.000, tex=TEX_MAP["CITY2_8"], }
    { b=392.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-800.000, tex=TEX_MAP["CITY2_8"], }
    { x=1344.000, y=-768.000, tex=TEX_MAP["CITY2_8"], }
    { x=992.000, y=-768.000, tex=TEX_MAP["CITY2_8"], }
    { x=992.000, y=-800.000, tex=TEX_MAP["CITY2_8"], }
    { t=408.000, tex=TEX_MAP["CITY2_8"], }
    { b=392.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-1408.000, tex=TEX_MAP["CITY2_8"], }
    { x=1344.000, y=-800.000, tex=TEX_MAP["CITY2_8"], }
    { x=1056.000, y=-800.000, tex=TEX_MAP["CITY2_8"], }
    { x=1056.000, y=-1408.000, tex=TEX_MAP["CITY2_8"], }
    { t=408.000, tex=TEX_MAP["CITY2_8"], }
    { b=392.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-1312.000, tex=TEX_MAP["CITY2_8"], }
    { x=1056.000, y=-864.000, tex=TEX_MAP["CITY2_8"], }
    { x=992.000, y=-864.000, tex=TEX_MAP["CITY2_8"], }
    { x=992.000, y=-1312.000, tex=TEX_MAP["CITY2_8"], }
    { t=408.000, tex=TEX_MAP["CITY2_8"], }
    { b=392.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=992.000, y=-1376.000, tex=TEX_MAP["CITY2_8"], }
    { x=992.000, y=-1408.000, tex=TEX_MAP["CITY2_8"], }
    { x=1056.000, y=-1408.000, tex=TEX_MAP["CITY2_8"], }
    { x=1056.000, y=-1376.000, tex=TEX_MAP["CITY2_8"], }
    { t=408.000, tex=TEX_MAP["CITY2_8"], }
    { b=392.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=952.000, y=-952.000, tex=TEX_MAP["COP1_1"], }
    { x=952.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=936.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=936.000, y=-952.000, tex=TEX_MAP["COP1_1"], }
    { t=224.000, tex=TEX_MAP["COP1_1"], }
    { b=208.000, tex=TEX_MAP["COP1_1"], }
  }
--    @@@@ FIX BRUSH @ line:2885 @@@@
  {
    { m="solid", }
    { x=1344.000, y=-1008.000, tex=TEX_MAP["COP1_1"], }
    { x=1344.000, y=-960.000, tex=TEX_MAP["COP1_1"], }
    { x=704.000, y=-960.000, tex=TEX_MAP["COP1_1"], }
    { x=704.000, y=-1008.000, tex=TEX_MAP["COP1_1"], }
    { t=400.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1128.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { x=1128.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=1080.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=1080.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { t=400.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
--    @@@@ FIX BRUSH @ line:2909 @@@@
  {
    { m="solid", }
    { x=1112.000, y=-952.000, tex=TEX_MAP["COP1_1"], }
    { x=1112.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=1096.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=1096.000, y=-952.000, tex=TEX_MAP["COP1_1"], }
    { t=224.000, tex=TEX_MAP["COP1_1"], }
    { b=208.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1112.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { x=1112.000, y=-1224.000, tex=TEX_MAP["COP1_1"], }
    { x=1096.000, y=-1224.000, tex=TEX_MAP["COP1_1"], }
    { x=1096.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { t=224.000, tex=TEX_MAP["COP1_1"], }
    { b=208.000, tex=TEX_MAP["COP1_1"], }
  }
--    @@@@ FIX BRUSH @ line:2933 @@@@
  {
    { m="solid", }
    { x=1344.000, y=-1216.000, tex=TEX_MAP["COP1_1"], }
    { x=1344.000, y=-1168.000, tex=TEX_MAP["COP1_1"], }
    { x=704.000, y=-1168.000, tex=TEX_MAP["COP1_1"], }
    { x=704.000, y=-1216.000, tex=TEX_MAP["COP1_1"], }
    { t=400.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=968.000, y=-1424.000, tex=TEX_MAP["COP1_1"], }
    { x=968.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=920.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=920.000, y=-1424.000, tex=TEX_MAP["COP1_1"], }
    { t=400.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
--    @@@@ FIX BRUSH @ line:2957 @@@@
  {
    { m="solid", }
    { x=952.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { x=952.000, y=-1232.000, tex=TEX_MAP["COP1_1"], }
    { x=936.000, y=-1232.000, tex=TEX_MAP["COP1_1"], }
    { x=936.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { t=224.000, tex=TEX_MAP["COP1_1"], }
    { b=208.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-1280.000, tex=TEX_MAP["COP1_1"], }
    { x=1344.000, y=-896.000, tex=TEX_MAP["COP1_1"], }
    { x=1336.000, y=-896.000, tex=TEX_MAP["COP1_1"], }
    { x=1336.000, y=-1280.000, tex=TEX_MAP["COP1_1"], }
    { t=392.000, tex=TEX_MAP["COP1_1"], }
    { b=368.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=712.000, y=-1280.000, tex=TEX_MAP["COP1_1"], }
    { x=712.000, y=-896.000, tex=TEX_MAP["COP1_1"], }
    { x=704.000, y=-896.000, tex=TEX_MAP["COP1_1"], }
    { x=704.000, y=-1280.000, tex=TEX_MAP["COP1_1"], }
    { t=392.000, tex=TEX_MAP["COP1_1"], }
    { b=368.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1216.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { x=1344.000, y=-1280.000, tex=TEX_MAP["COP1_1"], }
    { x=1336.000, y=-1280.000, tex=TEX_MAP["COP1_1"], }
    { x=1208.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { t=392.000, tex=TEX_MAP["COP1_1"], }
    { b=368.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { x=832.000, y=-1400.000, tex=TEX_MAP["COP1_1"], }
    { x=704.000, y=-1272.000, tex=TEX_MAP["COP1_1"], }
    { x=704.000, y=-1280.000, tex=TEX_MAP["COP1_1"], }
    { t=392.000, tex=TEX_MAP["COP1_1"], }
    { b=368.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1344.000, y=-896.000, tex=TEX_MAP["COP1_1"], }
    { x=1216.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=1216.000, y=-776.000, tex=TEX_MAP["COP1_1"], }
    { x=1344.000, y=-904.000, tex=TEX_MAP["COP1_1"], }
    { t=392.000, tex=TEX_MAP["COP1_1"], }
    { b=368.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=712.000, y=-896.000, tex=TEX_MAP["COP1_1"], }
    { x=840.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=832.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=704.000, y=-896.000, tex=TEX_MAP["COP1_1"], }
    { t=392.000, tex=TEX_MAP["COP1_1"], }
    { b=368.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1216.000, y=-776.000, tex=TEX_MAP["COP1_1"], }
    { x=1216.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=832.000, y=-768.000, tex=TEX_MAP["COP1_1"], }
    { x=832.000, y=-776.000, tex=TEX_MAP["COP1_1"], }
    { t=392.000, tex=TEX_MAP["COP1_1"], }
    { b=368.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1216.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { x=1216.000, y=-1400.000, tex=TEX_MAP["COP1_1"], }
    { x=832.000, y=-1400.000, tex=TEX_MAP["COP1_1"], }
    { x=832.000, y=-1408.000, tex=TEX_MAP["COP1_1"], }
    { t=392.000, tex=TEX_MAP["COP1_1"], }
    { b=368.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-864.000, tex=TEX_MAP["COP1_7"], }
    { x=1056.000, y=-800.000, tex=TEX_MAP["COP1_7"], }
    { x=992.000, y=-800.000, tex=TEX_MAP["COP1_7"], }
    { x=992.000, y=-864.000, tex=TEX_MAP["COP1_7"], }
    { t=408.000, tex=TEX_MAP["COP1_7"], }
    { b=400.000, tex=TEX_MAP["COP1_7"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-1376.000, tex=TEX_MAP["COP1_7"], }
    { x=1056.000, y=-1312.000, tex=TEX_MAP["COP1_7"], }
    { x=992.000, y=-1312.000, tex=TEX_MAP["COP1_7"], }
    { x=992.000, y=-1376.000, tex=TEX_MAP["COP1_7"], }
    { t=416.000, tex=TEX_MAP["COP1_7"], }
    { b=400.000, tex=TEX_MAP["COP1_7"], }
  }
  {
    { m="solid", }
    { x=856.000, y=-1176.000, tex=TEX_MAP["WMET4_8"], }
    { x=856.000, y=-1256.000, tex=TEX_MAP["WMET4_8"], }
    { x=936.000, y=-1256.000, tex=TEX_MAP["WMET4_8"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["WMET4_8"], }
  }
  {
    { m="solid", }
    { x=56.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=56.000, y=-1472.000, tex=TEX_MAP["CITY2_6"], }
    { x=40.000, y=-1472.000, tex=TEX_MAP["CITY2_6"], }
    { x=40.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { t=92.000, tex=TEX_MAP["CITY2_6"], }
    { b=16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=280.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=280.000, y=-1472.000, tex=TEX_MAP["CITY2_6"], }
    { x=264.000, y=-1472.000, tex=TEX_MAP["CITY2_6"], }
    { x=264.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { t=92.000, tex=TEX_MAP["CITY2_6"], }
    { b=16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=280.000, y=-1472.000, tex=TEX_MAP["CITY2_6"], }
    { x=280.000, y=-1456.000, tex=TEX_MAP["CITY2_6"], }
    { x=40.000, y=-1456.000, tex=TEX_MAP["CITY2_6"], }
    { x=40.000, y=-1472.000, tex=TEX_MAP["CITY2_6"], }
    { t=92.000, tex=TEX_MAP["CITY2_6"], }
    { b=16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=280.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { x=280.000, y=-1456.000, tex=TEX_MAP["CITY2_6"], }
    { x=40.000, y=-1456.000, tex=TEX_MAP["CITY2_6"], }
    { x=40.000, y=-1552.000, tex=TEX_MAP["CITY2_6"], }
    { t=100.000, tex=TEX_MAP["CITY2_6"], }
    { b=92.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1080.000, y=-1496.000, tex=TEX_MAP["CITY2_6"], }
    { x=1080.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=1064.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=1064.000, y=-1496.000, tex=TEX_MAP["CITY2_6"], }
    { t=312.000, tex=TEX_MAP["CITY2_6"], }
    { b=232.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1080.000, y=-1512.000, tex=TEX_MAP["CITY2_6"], }
    { x=1080.000, y=-1496.000, tex=TEX_MAP["CITY2_6"], }
    { x=856.000, y=-1496.000, tex=TEX_MAP["CITY2_6"], }
    { x=856.000, y=-1512.000, tex=TEX_MAP["CITY2_6"], }
    { t=312.000, tex=TEX_MAP["CITY2_6"], }
    { b=232.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=856.000, y=-1512.000, tex=TEX_MAP["CITY2_6"], }
    { x=856.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=840.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=840.000, y=-1512.000, tex=TEX_MAP["CITY2_6"], }
    { t=312.000, tex=TEX_MAP["CITY2_6"], }
    { b=232.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1080.000, y=-1512.000, tex=TEX_MAP["CITY2_6"], }
    { x=1080.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=840.000, y=-1424.000, tex=TEX_MAP["CITY2_6"], }
    { x=840.000, y=-1512.000, tex=TEX_MAP["CITY2_6"], }
    { t=316.000, tex=TEX_MAP["CITY2_6"], }
    { b=308.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1920.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=1920.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { x=1840.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { x=1840.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { t=224.000, tex=TEX_MAP["CITY2_6"], }
    { b=136.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1600.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1600.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=1584.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=1584.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { t=224.000, tex=TEX_MAP["CITY2_6"], }
    { b=136.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1920.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=1920.000, y=-112.000, tex=TEX_MAP["CITY2_6"], }
    { x=1584.000, y=-112.000, tex=TEX_MAP["CITY2_6"], }
    { x=1584.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { t=224.000, tex=TEX_MAP["CITY2_6"], }
    { b=136.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1936.000, y=-112.000, tex=TEX_MAP["CITY2_6"], }
    { x=1920.000, y=-112.000, tex=TEX_MAP["CITY2_6"], }
    { x=1920.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=1936.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { t=224.000, tex=TEX_MAP["CITY2_6"], }
    { b=136.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1936.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=1936.000, y=-112.000, tex=TEX_MAP["CITY2_6"], }
    { x=1840.000, y=-112.000, tex=TEX_MAP["CITY2_6"], }
    { x=1840.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { t=236.000, tex=TEX_MAP["CITY2_6"], }
    { b=220.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1840.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { x=1840.000, y=-112.000, tex=TEX_MAP["CITY2_6"], }
    { x=1584.000, y=-112.000, tex=TEX_MAP["CITY2_6"], }
    { x=1584.000, y=-208.000, tex=TEX_MAP["CITY2_6"], }
    { t=236.000, tex=TEX_MAP["CITY2_6"], }
    { b=220.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=64.000, y=-1056.000, tex=TEX_MAP["CITY2_6"], }
    { x=64.000, y=-1040.000, tex=TEX_MAP["CITY2_6"], }
    { x=-32.000, y=-1040.000, tex=TEX_MAP["CITY2_6"], }
    { x=-32.000, y=-1056.000, tex=TEX_MAP["CITY2_6"], }
    { t=320.000, tex=TEX_MAP["CITY2_6"], }
    { b=240.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=64.000, y=-1144.000, tex=TEX_MAP["CITY2_6"], }
    { x=64.000, y=-1128.000, tex=TEX_MAP["CITY2_6"], }
    { x=-32.000, y=-1128.000, tex=TEX_MAP["CITY2_6"], }
    { x=-32.000, y=-1144.000, tex=TEX_MAP["CITY2_6"], }
    { t=320.000, tex=TEX_MAP["CITY2_6"], }
    { b=240.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-32.000, y=-1040.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-1040.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-1144.000, tex=TEX_MAP["CITY2_6"], }
    { x=-32.000, y=-1144.000, tex=TEX_MAP["CITY2_6"], }
    { t=320.000, tex=TEX_MAP["CITY2_6"], }
    { b=240.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=64.000, y=-1144.000, tex=TEX_MAP["CITY2_6"], }
    { x=64.000, y=-1040.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-1040.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-1144.000, tex=TEX_MAP["CITY2_6"], }
    { t=336.000, tex=TEX_MAP["CITY2_6"], }
    { b=320.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-768.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-720.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-720.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-768.000, tex=TEX_MAP["CITY2_7"], }
    { t=0.000, tex=TEX_MAP["CITY2_7"], }
    { b=-88.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-816.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-768.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-768.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-816.000, tex=TEX_MAP["CITY2_7"], }
    { t=-16.000, tex=TEX_MAP["CITY2_7"], }
    { b=-88.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-1456.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-1408.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1408.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1456.000, tex=TEX_MAP["CITY2_7"], }
    { t=0.000, tex=TEX_MAP["CITY2_7"], }
    { b=-88.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1088.000, y=-1408.000, tex=TEX_MAP["CITY2_7"], }
    { x=1088.000, y=-1360.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1360.000, tex=TEX_MAP["CITY2_7"], }
    { x=960.000, y=-1408.000, tex=TEX_MAP["CITY2_7"], }
    { t=-16.000, tex=TEX_MAP["CITY2_7"], }
    { b=-88.000, tex=TEX_MAP["CITY2_7"], }
  }
  {
    { m="solid", }
    { x=1712.000, y=-232.000, tex=TEX_MAP["COP1_1"], }
    { x=1712.000, y=-224.000, tex=TEX_MAP["COP1_1"], }
    { x=1336.000, y=-224.000, tex=TEX_MAP["COP1_1"], }
    { x=1336.000, y=-232.000, tex=TEX_MAP["COP1_1"], }
    { t=352.000, tex=TEX_MAP["COP1_1"], }
    { b=320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1224.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { x=1224.000, y=-344.000, tex=TEX_MAP["COP1_1"], }
    { x=1216.000, y=-344.000, tex=TEX_MAP["COP1_1"], }
    { x=1216.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { t=352.000, tex=TEX_MAP["COP1_1"], }
    { b=320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1224.000, y=-352.000, tex=TEX_MAP["COP1_1"], }
    { x=1352.000, y=-224.000, tex=TEX_MAP["COP1_1"], }
    { x=1344.000, y=-224.000, tex=TEX_MAP["COP1_1"], }
    { x=1216.000, y=-352.000, tex=TEX_MAP["COP1_1"], }
    { t=352.000, tex=TEX_MAP["COP1_1"], }
    { b=320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1824.000, y=-360.000, tex=TEX_MAP["COP1_1"], }
    { x=1824.000, y=-352.000, tex=TEX_MAP["COP1_1"], }
    { x=1696.000, y=-224.000, tex=TEX_MAP["COP1_1"], }
    { x=1696.000, y=-232.000, tex=TEX_MAP["COP1_1"], }
    { t=352.000, tex=TEX_MAP["COP1_1"], }
    { b=320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=1840.000, y=-352.000, tex=TEX_MAP["CITY2_8"], }
    { x=1712.000, y=-224.000, tex=TEX_MAP["CITY2_8"], }
    { x=1696.000, y=-224.000, tex=TEX_MAP["CITY2_8"], }
    { x=1824.000, y=-352.000, tex=TEX_MAP["CITY2_8"], }
    { t=568.000, tex=TEX_MAP["CITY2_8"], }
    { b=339.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=1216.000, y=-352.000, tex=TEX_MAP["CITY2_8"], }
    { x=1344.000, y=-224.000, tex=TEX_MAP["CITY2_8"], }
    { x=1344.000, y=-208.000, tex=TEX_MAP["CITY2_8"], }
    { x=1216.000, y=-336.000, tex=TEX_MAP["CITY2_8"], }
    { t=528.000, tex=TEX_MAP["CITY2_8"], }
    { b=331.000, tex=TEX_MAP["CITY2_8"], }
  }
  {
    { m="solid", }
    { x=1824.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { x=1824.000, y=-352.000, tex=TEX_MAP["COP1_1"], }
    { x=1816.000, y=-352.000, tex=TEX_MAP["COP1_1"], }
    { x=1816.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { t=352.000, tex=TEX_MAP["COP1_1"], }
    { b=320.000, tex=TEX_MAP["COP1_1"], }
  }
--    @@@@ FIX BRUSH @ line:3292 @@@@
--    @@@@ FIX BRUSH @ line:3300 @@@@
  {
    { m="solid", }
    { x=1920.000, y=-688.000, tex=TEX_MAP["CITY2_6"], }
    { x=1920.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1520.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=1520.000, y=-688.000, tex=TEX_MAP["CITY2_6"], }
    { t=384.000, tex=TEX_MAP["CITY2_6"], }
    { b=272.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1824.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { x=1824.000, y=-632.000, tex=TEX_MAP["COP1_1"], }
    { x=1224.000, y=-632.000, tex=TEX_MAP["COP1_1"], }
    { x=1224.000, y=-640.000, tex=TEX_MAP["COP1_1"], }
    { t=352.000, tex=TEX_MAP["COP1_1"], }
    { b=320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-1568.000, tex=TEX_MAP["COP1_1"], }
    { x=520.000, y=-1568.000, tex=TEX_MAP["COP1_1"], }
    { x=520.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { t=408.000, tex=TEX_MAP["COP1_1"], }
    { b=376.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-2072.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-2072.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { t=408.000, tex=TEX_MAP["COP1_1"], }
    { b=376.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=-8.000, y=-2088.000, tex=TEX_MAP["COP1_1"], }
    { x=-8.000, y=-1568.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-1568.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-2088.000, tex=TEX_MAP["COP1_1"], }
    { t=408.000, tex=TEX_MAP["COP1_1"], }
    { b=376.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=520.000, y=-1568.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-1568.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-1576.000, tex=TEX_MAP["COP1_1"], }
    { x=520.000, y=-1576.000, tex=TEX_MAP["COP1_1"], }
    { t=408.000, tex=TEX_MAP["COP1_1"], }
    { b=376.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=-8.000, y=-1600.000, tex=TEX_MAP["COP1_1"], }
    { x=16.000, y=-1576.000, tex=TEX_MAP["COP1_1"], }
    { x=8.000, y=-1576.000, tex=TEX_MAP["COP1_1"], }
    { x=-16.000, y=-1600.000, tex=TEX_MAP["COP1_1"], }
    { t=409.000, tex=TEX_MAP["COP1_1"], }
    { b=376.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=16.000, y=-2080.000, tex=TEX_MAP["COP1_1"], }
    { x=16.000, y=-2072.000, tex=TEX_MAP["COP1_1"], }
    { x=-8.000, y=-2048.000, tex=TEX_MAP["COP1_1"], }
    { x=-8.000, y=-2056.000, tex=TEX_MAP["COP1_1"], }
    { t=409.000, tex=TEX_MAP["COP1_1"], }
    { b=376.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=504.000, y=-2072.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-2048.000, tex=TEX_MAP["COP1_1"], }
    { x=520.000, y=-2048.000, tex=TEX_MAP["COP1_1"], }
    { x=496.000, y=-2072.000, tex=TEX_MAP["COP1_1"], }
    { t=409.000, tex=TEX_MAP["COP1_1"], }
    { b=376.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-1384.000, tex=TEX_MAP["COP1_1"], }
    { x=320.000, y=-720.000, tex=TEX_MAP["COP1_1"], }
    { x=312.000, y=-720.000, tex=TEX_MAP["COP1_1"], }
    { x=312.000, y=-1384.000, tex=TEX_MAP["COP1_1"], }
    { t=408.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=88.000, y=-1384.000, tex=TEX_MAP["COP1_1"], }
    { x=88.000, y=-720.000, tex=TEX_MAP["COP1_1"], }
    { x=80.000, y=-720.000, tex=TEX_MAP["COP1_1"], }
    { x=80.000, y=-1384.000, tex=TEX_MAP["COP1_1"], }
    { t=408.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=312.000, y=-728.000, tex=TEX_MAP["COP1_1"], }
    { x=312.000, y=-720.000, tex=TEX_MAP["COP1_1"], }
    { x=88.000, y=-720.000, tex=TEX_MAP["COP1_1"], }
    { x=88.000, y=-728.000, tex=TEX_MAP["COP1_1"], }
    { t=408.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { x=320.000, y=-1312.000, tex=TEX_MAP["COP1_1"], }
    { x=88.000, y=-1312.000, tex=TEX_MAP["COP1_1"], }
    { x=88.000, y=-1328.000, tex=TEX_MAP["COP1_1"], }
    { t=408.000, tex=TEX_MAP["COP1_1"], }
    { b=384.000, tex=TEX_MAP["COP1_1"], }
  }
--    @@@@ FIX BRUSH @ line:3412 @@@@
  {
    { m="solid", }
    { x=456.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { x=456.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=320.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=320.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { t=104.000, tex=TEX_MAP["METAL4_4"], }
    { b=88.000, tex=TEX_MAP["METAL4_4"], }
  }
--    @@@@ FIX BRUSH @ line:3427 @@@@
--    @@@@ FIX BRUSH @ line:3434 @@@@
--    @@@@ FIX BRUSH @ line:3441 @@@@
  {
    { m="solid", }
    { x=456.000, y=-1168.000, tex=TEX_MAP["METAL4_4"], }
    { x=456.000, y=-1008.000, tex=TEX_MAP["METAL4_4"], }
    { x=320.000, y=-1008.000, tex=TEX_MAP["METAL4_4"], }
    { x=320.000, y=-1168.000, tex=TEX_MAP["METAL4_4"], }
    { t=232.000, tex=TEX_MAP["WMET4_8"], }
    { b=216.000, tex=TEX_MAP["METAL4_4"], }
  }
  {
    { m="solid", }
    { x=712.000, y=-1168.000, tex=TEX_MAP["METAL4_4"], }
    { x=712.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { x=320.000, y=-1152.000, tex=TEX_MAP["METAL4_4"], }
    { x=320.000, y=-1168.000, tex=TEX_MAP["METAL4_4"], }
    { t=216.000, tex=TEX_MAP["METAL4_4"], }
    { b=8.000, tex=TEX_MAP["METAL4_4"], }
  }
  {
    { m="solid", }
    { x=712.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { x=712.000, y=-1008.000, tex=TEX_MAP["METAL4_4"], }
    { x=320.000, y=-1008.000, tex=TEX_MAP["METAL4_4"], }
    { x=320.000, y=-1024.000, tex=TEX_MAP["METAL4_4"], }
    { t=216.000, tex=TEX_MAP["METAL4_4"], }
    { b=8.000, tex=TEX_MAP["METAL4_4"], }
  }
  {
    { m="solid", }
    { x=792.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=776.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=776.000, y=-1032.000, tex=TEX_MAP["CITY4_2"], }
    { t=-108.000, tex=TEX_MAP["CITY4_2"], }
    { b=-132.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=776.000, y=-1136.000, tex=TEX_MAP["CITY4_2"], }
    { x=776.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { x=792.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { t=-108.000, tex=TEX_MAP["CITY4_2"], }
    { b=-132.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=776.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { x=776.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=584.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=584.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { t=-108.000, tex=TEX_MAP["CITY4_2"], }
    { b=-132.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=920.000, y=-1168.000, tex=TEX_MAP["GROUND1_5"], }
    { x=920.000, y=-1008.000, tex=TEX_MAP["GROUND1_5"], }
    { x=584.000, y=-1008.000, tex=TEX_MAP["GROUND1_5"], }
    { x=584.000, y=-1168.000, tex=TEX_MAP["GROUND1_5"], }
    { t=-304.000, tex=TEX_MAP["GROUND1_5"], }
    { b=-320.000, tex=TEX_MAP["GROUND1_5"], }
  }
  {
    { m="solid", }
    { x=688.000, y=-1168.000, tex=TEX_MAP["CITY4_2"], }
    { x=688.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=672.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=672.000, y=-1168.000, tex=TEX_MAP["CITY4_2"], }
    { t=-88.000, tex=TEX_MAP["CITY4_2"], }
    { b=-112.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=584.000, y=-1240.000, tex=TEX_MAP["CITY4_2"], }
    { x=584.000, y=-944.000, tex=TEX_MAP["CITY4_2"], }
    { x=400.000, y=-944.000, tex=TEX_MAP["CITY4_2"], }
    { x=400.000, y=-1240.000, tex=TEX_MAP["CITY4_2"], }
    { t=-112.000, tex=TEX_MAP["CITY4_2"], }
    { b=-128.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=584.000, y=-1240.000, tex=TEX_MAP["GROUND1_5"], }
    { x=584.000, y=-944.000, tex=TEX_MAP["GROUND1_5"], }
    { x=400.000, y=-944.000, tex=TEX_MAP["GROUND1_5"], }
    { x=400.000, y=-1240.000, tex=TEX_MAP["GROUND1_5"], }
    { t=-304.000, tex=TEX_MAP["GROUND1_5"], }
    { b=-320.000, tex=TEX_MAP["GROUND1_5"], }
  }
  {
    { m="solid", }
    { x=444.000, y=-1120.000, tex=TEX_MAP["COP1_1"], }
    { x=444.000, y=-1056.000, tex=TEX_MAP["COP1_1"], }
    { x=420.000, y=-1056.000, tex=TEX_MAP["COP1_1"], }
    { x=420.000, y=-1120.000, tex=TEX_MAP["COP1_1"], }
    { t=-280.000, tex=TEX_MAP["COP1_1"], }
    { b=-288.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=444.000, y=-1120.000, tex=TEX_MAP["COP1_1"], }
    { x=444.000, y=-1056.000, tex=TEX_MAP["COP1_1"], }
    { x=420.000, y=-1056.000, tex=TEX_MAP["COP1_1"], }
    { x=420.000, y=-1120.000, tex=TEX_MAP["COP1_1"], }
    { t=-176.000, tex=TEX_MAP["COP1_1"], }
    { b=-184.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=444.000, y=-1064.000, tex=TEX_MAP["COP1_1"], }
    { x=444.000, y=-1056.000, tex=TEX_MAP["COP1_1"], }
    { x=420.000, y=-1056.000, tex=TEX_MAP["COP1_1"], }
    { x=420.000, y=-1064.000, tex=TEX_MAP["COP1_1"], }
    { t=-176.000, tex=TEX_MAP["COP1_1"], }
    { b=-288.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=444.000, y=-1120.000, tex=TEX_MAP["COP1_1"], }
    { x=444.000, y=-1112.000, tex=TEX_MAP["COP1_1"], }
    { x=420.000, y=-1112.000, tex=TEX_MAP["COP1_1"], }
    { x=420.000, y=-1120.000, tex=TEX_MAP["COP1_1"], }
    { t=-176.000, tex=TEX_MAP["COP1_1"], }
    { b=-288.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=436.000, y=-1112.000, tex=TEX_MAP["*TELEPORT"], }
    { x=436.000, y=-1064.000, tex=TEX_MAP["*TELEPORT"], }
    { x=432.000, y=-1064.000, tex=TEX_MAP["*TELEPORT"], }
    { x=432.000, y=-1112.000, tex=TEX_MAP["*TELEPORT"], }
    { t=-180.000, tex=TEX_MAP["*TELEPORT"], }
    { b=-284.000, tex=TEX_MAP["*TELEPORT"], }
  }
  {
    { m="solid", }
    { x=472.000, y=-1144.000, tex=TEX_MAP["CITY4_2"], }
    { x=472.000, y=-1032.000, tex=TEX_MAP["CITY4_2"], }
    { x=392.000, y=-1032.000, tex=TEX_MAP["CITY4_2"], }
    { x=392.000, y=-1144.000, tex=TEX_MAP["CITY4_2"], }
    { t=-296.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=584.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { x=584.000, y=-1000.000, tex=TEX_MAP["CITY4_2"], }
    { x=544.000, y=-960.000, tex=TEX_MAP["CITY4_2"], }
    { x=544.000, y=-976.000, tex=TEX_MAP["CITY4_2"], }
    { t=-120.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-1192.000, tex=TEX_MAP["CITY4_2"], }
    { x=544.000, y=-1208.000, tex=TEX_MAP["CITY4_2"], }
    { x=584.000, y=-1168.000, tex=TEX_MAP["CITY4_2"], }
    { x=584.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { t=-120.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-976.000, tex=TEX_MAP["CITY4_2"], }
    { x=544.000, y=-960.000, tex=TEX_MAP["CITY4_2"], }
    { x=448.000, y=-960.000, tex=TEX_MAP["CITY4_2"], }
    { x=448.000, y=-976.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-1208.000, tex=TEX_MAP["CITY4_2"], }
    { x=544.000, y=-1192.000, tex=TEX_MAP["CITY4_2"], }
    { x=448.000, y=-1192.000, tex=TEX_MAP["CITY4_2"], }
    { x=448.000, y=-1208.000, tex=TEX_MAP["CITY4_2"], }
    { t=-64.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=448.000, y=-976.000, tex=TEX_MAP["CITY4_2"], }
    { x=448.000, y=-960.000, tex=TEX_MAP["CITY4_2"], }
    { x=408.000, y=-1000.000, tex=TEX_MAP["CITY4_2"], }
    { x=408.000, y=-1016.000, tex=TEX_MAP["CITY4_2"], }
    { t=-120.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=448.000, y=-1208.000, tex=TEX_MAP["CITY4_2"], }
    { x=448.000, y=-1192.000, tex=TEX_MAP["CITY4_2"], }
    { x=408.000, y=-1152.000, tex=TEX_MAP["CITY4_2"], }
    { x=408.000, y=-1168.000, tex=TEX_MAP["CITY4_2"], }
    { t=-120.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=408.000, y=-1168.000, tex=TEX_MAP["CITY4_2"], }
    { x=408.000, y=-1000.000, tex=TEX_MAP["CITY4_2"], }
    { x=392.000, y=-1000.000, tex=TEX_MAP["CITY4_2"], }
    { x=392.000, y=-1168.000, tex=TEX_MAP["CITY4_2"], }
    { t=-120.000, tex=TEX_MAP["CITY4_2"], }
    { b=-320.000, tex=TEX_MAP["CITY4_2"], }
  }
  {
    { m="solid", }
    { x=464.000, y=-1192.000, tex=TEX_MAP["COP1_1"], }
    { x=464.000, y=-976.000, tex=TEX_MAP["COP1_1"], }
    { x=448.000, y=-976.000, tex=TEX_MAP["COP1_1"], }
    { x=448.000, y=-1192.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-136.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-1192.000, tex=TEX_MAP["COP1_1"], }
    { x=544.000, y=-976.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-976.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-1192.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-136.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=600.000, y=-1168.000, tex=TEX_MAP["COP1_1"], }
    { x=600.000, y=-1008.000, tex=TEX_MAP["COP1_1"], }
    { x=584.000, y=-1008.000, tex=TEX_MAP["COP1_1"], }
    { x=584.000, y=-1168.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-136.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1168.000, tex=TEX_MAP["COP1_1"], }
    { x=704.000, y=-1008.000, tex=TEX_MAP["COP1_1"], }
    { x=688.000, y=-1008.000, tex=TEX_MAP["COP1_1"], }
    { x=688.000, y=-1168.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-136.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=584.000, y=-1032.000, tex=TEX_MAP["COP1_1"], }
    { x=584.000, y=-1016.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1016.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1032.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-136.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=584.000, y=-1152.000, tex=TEX_MAP["COP1_1"], }
    { x=584.000, y=-1136.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1136.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1152.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-136.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-984.000, tex=TEX_MAP["COP1_1"], }
    { x=544.000, y=-976.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-976.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-984.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=464.000, y=-984.000, tex=TEX_MAP["COP1_1"], }
    { x=464.000, y=-976.000, tex=TEX_MAP["COP1_1"], }
    { x=448.000, y=-976.000, tex=TEX_MAP["COP1_1"], }
    { x=448.000, y=-984.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=464.000, y=-1192.000, tex=TEX_MAP["COP1_1"], }
    { x=464.000, y=-1184.000, tex=TEX_MAP["COP1_1"], }
    { x=448.000, y=-1184.000, tex=TEX_MAP["COP1_1"], }
    { x=448.000, y=-1192.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-1192.000, tex=TEX_MAP["COP1_1"], }
    { x=544.000, y=-1184.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-1184.000, tex=TEX_MAP["COP1_1"], }
    { x=528.000, y=-1192.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=416.000, y=-1152.000, tex=TEX_MAP["COP1_1"], }
    { x=416.000, y=-1136.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1136.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1152.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", }
    { x=416.000, y=-1032.000, tex=TEX_MAP["COP1_1"], }
    { x=416.000, y=-1016.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1016.000, tex=TEX_MAP["COP1_1"], }
    { x=408.000, y=-1032.000, tex=TEX_MAP["COP1_1"], }
    { t=-120.000, tex=TEX_MAP["COP1_1"], }
    { b=-320.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", link_entity="m1", }
    { x=224.000, y=-868.000, tex=TEX_MAP["TRIGGER"], }
    { x=224.000, y=-828.000, tex=TEX_MAP["TRIGGER"], }
    { x=176.000, y=-828.000, tex=TEX_MAP["TRIGGER"], }
    { x=176.000, y=-868.000, tex=TEX_MAP["TRIGGER"], }
    { t=228.000, tex=TEX_MAP["TRIGGER"], }
    { b=112.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m2", }
    { x=268.000, y=-1808.000, tex=TEX_MAP["TRIGGER"], }
    { x=268.000, y=-1760.000, tex=TEX_MAP["TRIGGER"], }
    { x=228.000, y=-1760.000, tex=TEX_MAP["TRIGGER"], }
    { x=228.000, y=-1808.000, tex=TEX_MAP["TRIGGER"], }
    { t=143.000, tex=TEX_MAP["TRIGGER"], }
    { b=23.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m3", }
    { x=1044.000, y=-1120.000, tex=TEX_MAP["TRIGGER"], }
    { x=1044.000, y=-1072.000, tex=TEX_MAP["TRIGGER"], }
    { x=1004.000, y=-1072.000, tex=TEX_MAP["TRIGGER"], }
    { x=1004.000, y=-1120.000, tex=TEX_MAP["TRIGGER"], }
    { t=64.000, tex=TEX_MAP["TRIGGER"], }
    { b=-36.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m4", }
    { x=904.000, y=-1136.000, tex=TEX_MAP["COP1_1"], }
    { x=904.000, y=-1032.000, tex=TEX_MAP["COP1_1"], }
    { x=888.000, y=-1016.000, tex=TEX_MAP["COP1_1"], }
    { x=792.000, y=-1016.000, tex=TEX_MAP["COP1_1"], }
    { x=776.000, y=-1032.000, tex=TEX_MAP["COP1_1"], }
    { x=776.000, y=-1136.000, tex=TEX_MAP["COP1_1"], }
    { x=792.000, y=-1152.000, tex=TEX_MAP["COP1_1"], }
    { x=888.000, y=-1152.000, tex=TEX_MAP["COP1_1"], }
    { t=-68.000, tex=TEX_MAP["COP1_1"], }
    { b=-88.000, tex=TEX_MAP["COP1_1"], }
  }
  {
    { m="solid", link_entity="m5", }
    { x=452.000, y=-1112.000, tex=TEX_MAP["TRIGGER"], }
    { x=452.000, y=-1064.000, tex=TEX_MAP["TRIGGER"], }
    { x=412.000, y=-1064.000, tex=TEX_MAP["TRIGGER"], }
    { x=412.000, y=-1112.000, tex=TEX_MAP["TRIGGER"], }
    { t=-184.000, tex=TEX_MAP["TRIGGER"], }
    { b=-284.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m6", }
    { x=1600.000, y=-1472.000, tex=TEX_MAP["TRIGGER"], }
    { x=1600.000, y=-1408.000, tex=TEX_MAP["TRIGGER"], }
    { x=1536.000, y=-1408.000, tex=TEX_MAP["TRIGGER"], }
    { x=1536.000, y=-1472.000, tex=TEX_MAP["TRIGGER"], }
    { t=352.000, tex=TEX_MAP["TRIGGER"], }
    { b=320.000, tex=TEX_MAP["TRIGGER"], }
  }
}
