
ENT_MAP = 
{
  ["func_plat"]                  = "func_plat",
  ["info_intermission"]          = "info_intermission",
  ["info_null"]                  = "info_null",
  ["info_player_deathmatch"]     = "info_player_deathmatch",
  ["info_player_start"]          = "info_player_start",
  ["item_armor2"]                = "item_armor2",
  ["item_artifact_invisibility"] = "item_artifact_invisibility",
  ["item_artifact_invulnerability"] = "item_artifact_invulnerability",
  ["item_artifact_super_damage"] = "item_artifact_super_damage",
  ["item_cells"]                 = "item_cells",
  ["item_health"]                = "item_health",
  ["item_rockets"]               = "item_rockets",
  ["item_shells"]                = "item_shells",
  ["item_spikes"]                = "item_spikes",
  ["light"]                      = "nothing",  --!!!
  ["trigger_push"]               = "trigger_push",
  ["weapon_grenadelauncher"]     = "weapon_grenadelauncher",
  ["weapon_lightning"]           = "weapon_lightning",
  ["weapon_nailgun"]             = "weapon_nailgun",
  ["weapon_rocketlauncher"]      = "weapon_rocketlauncher",
  ["weapon_supernailgun"]        = "weapon_supernailgun",
  ["weapon_supershotgun"]        = "weapon_supershotgun",
}

TEX_MAP = 
{
  ["SKY4"]                       = "skies/nitesky",
  ["TRIGGER"]                    = "base_wall/steed2f",
  ["*04MWAT2"]                   = "liquids/softwater",
  ["COP1_3"]                     = "gothic_block/blocks15",
  ["COP3_4"]                     = "gothic_block/blocks15",
  ["LGMETAL4"]                   = "base_floor/metfloor1",
  ["LIGHT3_2"]                   = "base_trim/pewter_shiney",
  ["LIGHT3_8"]                   = "base_trim/pewter_shiney",
  ["MET5_1"]                     = "base_floor/metfloor1",
  ["METAL1_3"]                   = "base_floor/metfloor1",
  ["METAL1_4"]                   = "base_floor/metfloor1",
  ["METAL6_2"]                   = "base_floor/metfloor1",
  ["MMETAL1_1"]                  = "base_trim/dark_tin2",
  ["MMETAL1_3"]                  = "base_trim/dark_tin2",
  ["MMETAL1_6"]                  = "base_trim/dark_tin2",
  ["NMETAL2_1"]                  = "base_trim/dark_tin2",
  ["PLAT_TOP2"]                  = "base_trim/dark_tin2",
  ["STRNG1_4"]                   = "base_wall/concrete1",
}

all_entities =
{
  {
    id = ENT_MAP["info_player_start"]
    angle = 0
    x = 448
    y = -672
    z = 160
  }
  {
    id = ENT_MAP["light"]
    x = 768
    y = -512
    z = 160
  }
  {
    id = ENT_MAP["light"]
    x = 768
    y = -832
    z = 160
  }
  {
    id = ENT_MAP["light"]
    x = 256
    y = -832
    z = 160
  }
  {
    id = ENT_MAP["light"]
    x = 256
    y = -512
    z = 160
  }
  {
    id = ENT_MAP["light"]
    x = 688
    y = -944
    z = 480
    light = 150
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 688
    y = -1072
    z = 480
  }
  {
    id = ENT_MAP["light"]
    x = 544
    y = -944
    z = 480
    light = 150
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 544
    y = -1072
    z = 480
  }
  {
    id = ENT_MAP["light"]
    x = 400
    y = -944
    z = 480
    light = 150
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 400
    y = -1072
    z = 480
  }
  {
    id = ENT_MAP["light"]
    target = "t5"
    x = 400
    y = -944
    z = 464
    light = 350
  }
  {
    id = ENT_MAP["light"]
    target = "t6"
    x = 400
    y = -1072
    z = 464
    light = 350
  }
  {
    id = ENT_MAP["light"]
    target = "t3"
    x = 544
    y = -944
    z = 464
    light = 350
  }
  {
    id = ENT_MAP["light"]
    target = "t4"
    x = 544
    y = -1072
    z = 464
    light = 350
  }
  {
    id = ENT_MAP["light"]
    target = "t1"
    x = 688
    y = -944
    z = 464
  }
  {
    id = ENT_MAP["light"]
    target = "t2"
    x = 688
    y = -1072
    z = 464
  }
  {
    id = ENT_MAP["info_null"]
    targetname = "t1"
    x = 700
    y = -932
    z = 324
  }
  {
    id = ENT_MAP["info_null"]
    targetname = "t2"
    x = 700
    y = -1084
    z = 324
  }
  {
    id = ENT_MAP["info_null"]
    targetname = "t6"
    x = 412
    y = -1060
    z = 132
  }
  {
    id = ENT_MAP["info_null"]
    targetname = "t5"
    x = 412
    y = -956
    z = 132
  }
  {
    id = ENT_MAP["info_null"]
    targetname = "t3"
    x = 548
    y = -932
    z = 132
  }
  {
    id = ENT_MAP["info_null"]
    targetname = "t4"
    x = 548
    y = -1084
    z = 132
  }
  {
    id = ENT_MAP["func_plat"]
    height = 192
    link_id = "m1"
  }
  {
    id = ENT_MAP["light"]
    x = 400
    y = -1200
    z = 336
    light = 150
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 528
    y = -1200
    z = 336
  }
  {
    id = ENT_MAP["light"]
    target = "t8"
    x = 592
    y = -1200
    z = 480
    light = 100
  }
  {
    id = ENT_MAP["light"]
    light = 100
    x = 688
    y = -1200
    z = 480
  }
  {
    id = ENT_MAP["light"]
    x = 592
    y = -1200
    z = 464
  }
  {
    id = ENT_MAP["light"]
    target = "t7"
    x = 688
    y = -1200
    z = 464
  }
  {
    id = ENT_MAP["info_null"]
    targetname = "t8"
    x = 588
    y = -1212
    z = 148
  }
  {
    id = ENT_MAP["info_null"]
    targetname = "t7"
    x = 692
    y = -1212
    z = 148
  }
  {
    id = ENT_MAP["info_null"]
    targetname = "t10"
    x = 532
    y = -1212
    z = 132
  }
  {
    id = ENT_MAP["info_null"]
    targetname = "t9"
    x = 396
    y = -1212
    z = 132
  }
  {
    id = ENT_MAP["light"]
    target = "t9"
    x = 400
    y = -1200
    z = 320
  }
  {
    id = ENT_MAP["light"]
    target = "t10"
    x = 528
    y = -1200
    z = 320
  }
  {
    id = ENT_MAP["light"]
    x = 448
    y = -960
    z = 160
    light = 100
  }
  {
    id = ENT_MAP["light"]
    light = 100
    x = 448
    y = -1048
    z = 160
  }
  {
    id = ENT_MAP["light"]
    x = 464
    y = -1128
    z = 160
    light = 100
  }
  {
    id = ENT_MAP["light"]
    light = 100
    x = 560
    y = -1168
    z = 160
  }
  {
    id = ENT_MAP["light"]
    x = 640
    y = -1152
    z = 160
    light = 100
  }
  {
    id = ENT_MAP["light"]
    light = 100
    x = 640
    y = -1152
    z = 272
  }
  {
    id = ENT_MAP["light"]
    x = 680
    y = -552
    z = 512
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 680
    y = -792
    z = 512
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 680
    y = -672
    z = 512
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 704
    y = -552
    z = 704
    light = 300
  }
  {
    id = ENT_MAP["light"]
    light = 300
    x = 704
    y = -792
    z = 704
  }
  {
    id = ENT_MAP["light"]
    x = 640
    y = -680
    z = 704
    light = 300
  }
  {
    id = ENT_MAP["light"]
    x = 288
    y = -544
    z = 432
    light = 150
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 288
    y = -672
    z = 432
  }
  {
    id = ENT_MAP["light"]
    x = 288
    y = -800
    z = 432
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 1024
    y = -256
    z = 736
    light = 600
  }
  {
    id = ENT_MAP["light"]
    light = 600
    x = 448
    y = -184
    z = 736
  }
  {
    id = ENT_MAP["light"]
    x = 1080
    y = -696
    z = 736
    light = 600
  }
  {
    id = ENT_MAP["light"]
    light = 600
    x = 1088
    y = -1088
    z = 736
  }
  {
    id = ENT_MAP["light"]
    x = 128
    y = -384
    z = 736
    light = 600
  }
  {
    id = ENT_MAP["light"]
    x = 200
    y = -1088
    z = 736
    light = 600
  }
  {
    id = ENT_MAP["light"]
    x = 1024
    y = -608
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 256
    y = -320
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 256
    y = -1024
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 192
    y = -1216
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 960
    y = -320
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 960
    y = -960
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 832
    y = -1216
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 576
    y = -1024
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 576
    y = -320
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 1216
    y = -64
    z = -192
  }
  {
    id = ENT_MAP["light"]
    x = 1272
    y = -8
    z = -192
  }
  {
    id = ENT_MAP["light"]
    x = 1272
    y = -120
    z = -192
  }
  {
    id = ENT_MAP["light"]
    x = 1216
    y = -280
    z = -104
    light = 200
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1000
    y = -64
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 1232
    y = -64
    z = -104
    light = 100
  }
  {
    id = ENT_MAP["light"]
    light = 100
    x = 64
    y = -64
    z = -104
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 296
    y = -64
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 64
    y = -320
    z = -104
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = 8
    y = -8
    z = -192
  }
  {
    id = ENT_MAP["light"]
    x = 8
    y = -120
    z = -192
  }
  {
    id = ENT_MAP["light"]
    x = 80
    y = -64
    z = -192
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1216
    y = -1000
    z = -104
  }
  {
    id = ENT_MAP["light"]
    x = 1000
    y = -1216
    z = -104
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = 1216
    y = -1216
    z = -192
  }
  {
    id = ENT_MAP["light"]
    x = 1272
    y = -1184
    z = -192
  }
  {
    id = ENT_MAP["light"]
    x = 1272
    y = -1272
    z = -192
  }
  {
    id = ENT_MAP["light"]
    light = 100
    x = 1232
    y = -1216
    z = -104
  }
  {
    id = ENT_MAP["trigger_push"]
    link_id = "m2"
    angle = 360
  }
  {
    id = ENT_MAP["trigger_push"]
    link_id = "m3"
    angle = "-1"
  }
  {
    id = ENT_MAP["trigger_push"]
    speed = 100
    link_id = "m4"
    angle = 180
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 1408
    y = -672
    z = -56
  }
  {
    id = ENT_MAP["light"]
    x = 1408
    y = -672
    z = 208
    light = 150
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1408
    y = -672
    z = 72
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1216
    y = -672
    z = -72
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 384
    y = -64
    z = 192
  }
  {
    id = ENT_MAP["light"]
    x = 896
    y = -64
    z = 192
    light = 200
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 640
    y = -64
    z = 192
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1088
    y = -320
    z = 256
  }
  {
    id = ENT_MAP["light"]
    x = 1088
    y = -576
    z = 256
    light = 200
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 1088
    y = -832
    z = 256
  }
  {
    id = ENT_MAP["light"]
    x = 1096
    y = -1128
    z = 256
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = 896
    y = -192
    z = 256
    light = 200
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 640
    y = -192
    z = 256
  }
  {
    id = ENT_MAP["light"]
    x = 424
    y = -192
    z = 256
    light = 200
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 192
    y = -192
    z = 256
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 640
    y = -448
    z = 392
  }
  {
    id = ENT_MAP["light"]
    x = 640
    y = -640
    z = 392
    light = 200
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 640
    y = -848
    z = 392
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 248
    y = -672
    z = -368
  }
  {
    id = ENT_MAP["light"]
    x = 224
    y = -672
    z = -88
  }
  {
    id = ENT_MAP["light"]
    x = 96
    y = -672
    z = -368
    light = 200
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = -56
    y = -672
    z = -368
  }
  {
    id = ENT_MAP["light"]
    x = -128
    y = -672
    z = -248
    light = 200
  }
  {
    id = ENT_MAP["trigger_push"]
    speed = 200
    link_id = "m5"
    angle = "-1"
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = -104
    y = -672
    z = -80
  }
  {
    id = ENT_MAP["light"]
    x = -144
    y = -648
    z = 56
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = -144
    y = -704
    z = 240
  }
  {
    id = ENT_MAP["light"]
    x = -104
    y = -704
    z = 384
  }
  {
    id = ENT_MAP["light"]
    x = -120
    y = -648
    z = 520
  }
  {
    id = ENT_MAP["light"]
    x = -152
    y = -672
    z = 712
  }
  {
    id = ENT_MAP["trigger_push"]
    speed = 100
    link_id = "m6"
    angle = 360
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 315
    x = 24
    y = -24
    z = 352
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 225
    x = 1256
    y = -24
    z = 352
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 135
    x = 1256
    y = -1256
    z = 352
  }
  {
    id = ENT_MAP["item_artifact_super_damage"]
    x = 936
    y = -672
    z = 664
  }
  {
    id = ENT_MAP["weapon_rocketlauncher"]
    x = 1104
    y = -1216
    z = 320
  }
  {
    id = ENT_MAP["weapon_supernailgun"]
    x = 64
    y = -192
    z = 320
  }
  {
    id = ENT_MAP["weapon_supershotgun"]
    x = 48
    y = -1232
    z = -144
  }
  {
    id = ENT_MAP["weapon_nailgun"]
    x = 1104
    y = -1216
    z = -144
  }
  {
    id = ENT_MAP["weapon_supershotgun"]
    x = 1216
    y = -256
    z = -144
  }
  {
    id = ENT_MAP["weapon_nailgun"]
    x = 224
    y = -64
    z = -144
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 0
    x = 448
    y = -672
    z = 160
  }
  {
    id = ENT_MAP["weapon_supershotgun"]
    x = 632
    y = -672
    z = 128
  }
  {
    id = ENT_MAP["item_armor2"]
    x = 448
    y = -1104
    z = 128
  }
  {
    id = ENT_MAP["trigger_push"]
    link_id = "m7"
    angle = 180
  }
  {
    id = ENT_MAP["item_rockets"]
    spawnflags = 1
    x = 432
    y = -1040
    z = 528
  }
  {
    id = ENT_MAP["item_shells"]
    spawnflags = 1
    x = 496
    y = -1040
    z = 528
  }
  {
    id = ENT_MAP["item_spikes"]
    spawnflags = 1
    x = 560
    y = -1040
    z = 528
  }
  {
    id = ENT_MAP["item_cells"]
    spawnflags = 1
    x = 624
    y = -1040
    z = 528
  }
  {
    id = ENT_MAP["weapon_lightning"]
    x = 448
    y = -1152
    z = 528
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 2
    x = 496
    y = -1168
    z = 528
  }
  {
    id = ENT_MAP["weapon_grenadelauncher"]
    x = 1216
    y = -192
    z = 320
  }
  {
    id = ENT_MAP["item_artifact_invisibility"]
    x = 640
    y = -64
    z = 344
  }
  {
    id = ENT_MAP["item_health"]
    x = 432
    y = -80
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    x = 816
    y = -80
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    x = 1200
    y = -400
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    x = 1200
    y = -976
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    x = 48
    y = -400
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    x = 48
    y = -1040
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    x = 304
    y = -1232
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    x = 880
    y = -1232
    z = -144
  }
  {
    id = ENT_MAP["item_health"]
    x = 760
    y = -688
    z = 128
  }
  {
    id = ENT_MAP["item_health"]
    x = 624
    y = -328
    z = 320
  }
  {
    id = ENT_MAP["item_health"]
    x = 624
    y = -864
    z = 320
  }
  {
    id = ENT_MAP["item_rockets"]
    x = 1072
    y = -688
    z = 128
  }
  {
    id = ENT_MAP["item_rockets"]
    x = 432
    y = -200
    z = 128
  }
  {
    id = ENT_MAP["item_spikes"]
    spawnflags = 1
    x = 272
    y = -880
    z = -144
  }
  {
    id = ENT_MAP["item_shells"]
    spawnflags = 1
    x = 272
    y = -496
    z = -144
  }
  {
    id = ENT_MAP["light"]
    x = 64
    y = -672
    z = -216
  }
  {
    id = ENT_MAP["item_artifact_invulnerability"]
    x = 64
    y = -672
    z = -232
  }
  {
    id = ENT_MAP["info_intermission"]
    x = 1168
    y = -1192
    z = 560
  }
--  {
--    id = "oblige_sun"
--    x = 745
--    y = -677
--    z = 1101
--    light = 850
--  }
}

all_brushes =
{
  {
    { m="solid", }
    { x=512.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-256.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-256.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=672.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=544.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=544.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=1024.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=1024.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="liquid", detail=1, medium="water", }
    { x=832.000, y=-896.000, tex="nothing", }
    { x=832.000, y=-448.000, tex="nothing", }
    { x=384.000, y=-448.000, tex="nothing", }
    { x=384.000, y=-896.000, tex="nothing", }
    { t=64.000, tex=TEX_MAP["*04MWAT2"], }
    { b=-160.000, tex="nothing", }
  }
  {
    { m="solid", }
    { x=576.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=304.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-576.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-576.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-576.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-576.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-576.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-576.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-576.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-576.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=192.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=192.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=192.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-24.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=352.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-24.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=352.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-24.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=304.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=544.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-448.000, tex=TEX_MAP["METAL6_2"], }
    { x=544.000, y=-416.000, tex=TEX_MAP["METAL6_2"], }
    { x=512.000, y=-416.000, tex=TEX_MAP["METAL6_2"], }
    { x=512.000, y=-448.000, tex=TEX_MAP["METAL6_2"], }
    { t=256.000, tex=TEX_MAP["METAL6_2"], }
    { b=128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-448.000, tex=TEX_MAP["METAL1_4"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-416.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["METAL1_4"], }
    { t=272.000, tex=TEX_MAP["METAL1_4"], }
    { b=256.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-448.000, tex=TEX_MAP["METAL6_2"], }
    { x=384.000, y=-416.000, tex=TEX_MAP["METAL6_2"], }
    { x=352.000, y=-416.000, tex=TEX_MAP["METAL6_2"], }
    { x=352.000, y=-448.000, tex=TEX_MAP["METAL6_2"], }
    { t=256.000, tex=TEX_MAP["METAL6_2"], }
    { b=128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=496.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=496.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=400.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=400.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=456.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=456.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=440.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=440.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=496.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=496.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=400.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { x=400.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=456.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { x=456.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=440.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=440.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=544.000, y=-720.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-720.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-624.000, tex=TEX_MAP["MET5_1"], }
    { x=544.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-624.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-680.000, tex=TEX_MAP["MET5_1"], }
    { x=544.000, y=-664.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-664.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-680.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-720.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-720.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-624.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-624.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-680.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-664.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-664.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-680.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MET5_1"], }
    { b=112.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { t=272.000, tex=TEX_MAP["METAL1_4"], }
    { b=256.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-928.000, tex=TEX_MAP["METAL6_2"], }
    { x=544.000, y=-896.000, tex=TEX_MAP["METAL6_2"], }
    { x=512.000, y=-896.000, tex=TEX_MAP["METAL6_2"], }
    { x=512.000, y=-928.000, tex=TEX_MAP["METAL6_2"], }
    { t=256.000, tex=TEX_MAP["METAL6_2"], }
    { b=128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-928.000, tex=TEX_MAP["METAL6_2"], }
    { x=384.000, y=-896.000, tex=TEX_MAP["METAL6_2"], }
    { x=352.000, y=-896.000, tex=TEX_MAP["METAL6_2"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["METAL6_2"], }
    { t=256.000, tex=TEX_MAP["METAL6_2"], }
    { b=128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-768.000, tex=TEX_MAP["METAL6_2"], }
    { x=864.000, y=-736.000, tex=TEX_MAP["METAL6_2"], }
    { x=832.000, y=-736.000, tex=TEX_MAP["METAL6_2"], }
    { x=832.000, y=-768.000, tex=TEX_MAP["METAL6_2"], }
    { t=256.000, tex=TEX_MAP["METAL6_2"], }
    { b=128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-608.000, tex=TEX_MAP["METAL6_2"], }
    { x=864.000, y=-576.000, tex=TEX_MAP["METAL6_2"], }
    { x=832.000, y=-576.000, tex=TEX_MAP["METAL6_2"], }
    { x=832.000, y=-608.000, tex=TEX_MAP["METAL6_2"], }
    { t=256.000, tex=TEX_MAP["METAL6_2"], }
    { b=128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { x=864.000, y=-416.000, tex=TEX_MAP["METAL1_4"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["METAL1_4"], }
    { x=832.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { t=272.000, tex=TEX_MAP["METAL1_4"], }
    { b=256.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { x=192.000, y=-448.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { t=272.000, tex=TEX_MAP["METAL1_4"], }
    { b=256.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=304.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=304.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=304.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=592.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { x=592.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MET5_1"], }
    { b=304.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=688.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=688.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MET5_1"], }
    { b=304.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=648.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { x=648.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=632.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=632.000, y=-768.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MET5_1"], }
    { b=304.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=592.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=592.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MET5_1"], }
    { b=304.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=688.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=688.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MET5_1"], }
    { b=304.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=648.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=648.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=632.000, y=-576.000, tex=TEX_MAP["MET5_1"], }
    { x=632.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MET5_1"], }
    { b=304.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-928.000, tex=TEX_MAP["METAL6_2"], }
    { x=576.000, y=-896.000, tex=TEX_MAP["METAL6_2"], }
    { x=544.000, y=-896.000, tex=TEX_MAP["METAL6_2"], }
    { x=544.000, y=-928.000, tex=TEX_MAP["METAL6_2"], }
    { t=448.000, tex=TEX_MAP["METAL6_2"], }
    { b=320.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-928.000, tex=TEX_MAP["METAL6_2"], }
    { x=736.000, y=-896.000, tex=TEX_MAP["METAL6_2"], }
    { x=704.000, y=-896.000, tex=TEX_MAP["METAL6_2"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["METAL6_2"], }
    { t=448.000, tex=TEX_MAP["METAL6_2"], }
    { b=320.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=128.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=304.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1088.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=304.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=128.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-1088.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=576.000, y=-928.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=512.000, y=-928.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=512.000, y=-1088.000, tex=TEX_MAP["MMETAL1_1"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=112.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=832.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { t=464.000, tex=TEX_MAP["METAL1_4"], }
    { b=448.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1088.000, tex=TEX_MAP["METAL1_4"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["STRNG1_4"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=352.000, y=-1088.000, tex=TEX_MAP["STRNG1_4"], }
    { t=528.000, tex=TEX_MAP["STRNG1_4"], }
    { b=512.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=416.000, y=-960.000, tex=TEX_MAP["MET5_1"], }
    { x=416.000, y=-928.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-960.000, tex=TEX_MAP["MET5_1"], }
    { t=512.000, tex=TEX_MAP["MET5_1"], }
    { b=504.000, tex=TEX_MAP["LIGHT3_8"], }
  }
  {
    { m="solid", }
    { x=416.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { x=416.000, y=-1056.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-1056.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { t=512.000, tex=TEX_MAP["MET5_1"], }
    { b=504.000, tex=TEX_MAP["LIGHT3_8"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-960.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-928.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-960.000, tex=TEX_MAP["MET5_1"], }
    { t=512.000, tex=TEX_MAP["MET5_1"], }
    { b=504.000, tex=TEX_MAP["LIGHT3_8"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-1056.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-1056.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { t=512.000, tex=TEX_MAP["MET5_1"], }
    { b=504.000, tex=TEX_MAP["LIGHT3_8"], }
  }
  {
    { m="solid", }
    { x=560.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { x=560.000, y=-1056.000, tex=TEX_MAP["MET5_1"], }
    { x=528.000, y=-1056.000, tex=TEX_MAP["MET5_1"], }
    { x=528.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { t=512.000, tex=TEX_MAP["MET5_1"], }
    { b=504.000, tex=TEX_MAP["LIGHT3_8"], }
  }
  {
    { m="solid", }
    { x=560.000, y=-960.000, tex=TEX_MAP["MET5_1"], }
    { x=560.000, y=-928.000, tex=TEX_MAP["MET5_1"], }
    { x=528.000, y=-928.000, tex=TEX_MAP["MET5_1"], }
    { x=528.000, y=-960.000, tex=TEX_MAP["MET5_1"], }
    { t=512.000, tex=TEX_MAP["MET5_1"], }
    { b=504.000, tex=TEX_MAP["LIGHT3_8"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=576.000, y=-1088.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=384.000, y=-1088.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=384.000, y=-1216.000, tex=TEX_MAP["MMETAL1_1"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=112.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=448.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=272.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=576.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=256.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=128.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1120.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=384.000, y=-1088.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=384.000, y=-1120.000, tex=TEX_MAP["MMETAL1_6"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_6"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_6"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1248.000, tex=TEX_MAP["METAL1_4"], }
    { x=736.000, y=-1088.000, tex=TEX_MAP["STRNG1_4"], }
    { x=352.000, y=-1088.000, tex=TEX_MAP["METAL1_4"], }
    { x=352.000, y=-1248.000, tex=TEX_MAP["METAL1_4"], }
    { t=528.000, tex=TEX_MAP["STRNG1_4"], }
    { b=512.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-1216.000, tex=TEX_MAP["STRNG1_4"], }
    { x=544.000, y=-1120.000, tex=TEX_MAP["STRNG1_4"], }
    { x=384.000, y=-1120.000, tex=TEX_MAP["STRNG1_4"], }
    { x=384.000, y=-1216.000, tex=TEX_MAP["STRNG1_4"], }
    { t=384.000, tex=TEX_MAP["STRNG1_4"], }
    { b=368.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-1216.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=576.000, y=-1120.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=544.000, y=-1120.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=544.000, y=-1216.000, tex=TEX_MAP["MMETAL1_6"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_6"], }
    { b=352.000, tex=TEX_MAP["MMETAL1_6"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-1120.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=576.000, y=-1088.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=384.000, y=-1088.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=384.000, y=-1120.000, tex=TEX_MAP["MMETAL1_6"], }
    { t=464.000, tex=TEX_MAP["MMETAL1_6"], }
    { b=352.000, tex=TEX_MAP["MMETAL1_6"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1216.000, tex=TEX_MAP["MET5_1"], }
    { x=704.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { x=672.000, y=-1216.000, tex=TEX_MAP["MET5_1"], }
    { t=512.000, tex=TEX_MAP["MET5_1"], }
    { b=504.000, tex=TEX_MAP["LIGHT3_8"], }
  }
  {
    { m="solid", }
    { x=608.000, y=-1216.000, tex=TEX_MAP["MET5_1"], }
    { x=608.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-1216.000, tex=TEX_MAP["MET5_1"], }
    { t=512.000, tex=TEX_MAP["MET5_1"], }
    { b=504.000, tex=TEX_MAP["LIGHT3_8"], }
  }
  {
    { m="solid", }
    { x=416.000, y=-1216.000, tex=TEX_MAP["MET5_1"], }
    { x=416.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { x=384.000, y=-1216.000, tex=TEX_MAP["MET5_1"], }
    { t=368.000, tex=TEX_MAP["MET5_1"], }
    { b=360.000, tex=TEX_MAP["LIGHT3_8"], }
  }
  {
    { m="solid", }
    { x=544.000, y=-1216.000, tex=TEX_MAP["MET5_1"], }
    { x=544.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { x=512.000, y=-1216.000, tex=TEX_MAP["MET5_1"], }
    { t=368.000, tex=TEX_MAP["MET5_1"], }
    { b=360.000, tex=TEX_MAP["LIGHT3_8"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-16.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1216.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=704.000, y=-1088.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=576.000, y=-1088.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=576.000, y=-1216.000, tex=TEX_MAP["MMETAL1_1"], }
    { t=112.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=96.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-1088.000, tex=TEX_MAP["METAL1_4"], }
    { x=704.000, y=-1088.000, tex=TEX_MAP["METAL1_4"], }
    { x=704.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { t=128.000, tex=TEX_MAP["METAL1_4"], }
    { b=112.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1248.000, tex=TEX_MAP["METAL1_4"], }
    { x=736.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=576.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=576.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=128.000, tex=TEX_MAP["METAL1_4"], }
    { b=112.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1088.000, tex=TEX_MAP["METAL1_4"], }
    { x=704.000, y=-1056.000, tex=TEX_MAP["METAL1_4"], }
    { x=576.000, y=-1056.000, tex=TEX_MAP["METAL1_4"], }
    { x=576.000, y=-1088.000, tex=TEX_MAP["METAL1_4"], }
    { t=128.000, tex=TEX_MAP["METAL1_4"], }
    { b=112.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=512.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=464.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=264.000, y=-576.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-512.000, tex=TEX_MAP["COP1_3"], }
    { x=256.000, y=-512.000, tex=TEX_MAP["COP1_3"], }
    { x=256.000, y=-576.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-576.000, tex=TEX_MAP["COP1_3"], }
    { x=320.000, y=-512.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-512.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-576.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=312.000, y=-576.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-568.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-568.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-576.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=312.000, y=-520.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-512.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-512.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-520.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=312.000, y=-568.000, tex=TEX_MAP["LIGHT3_2"], }
    { x=312.000, y=-520.000, tex=TEX_MAP["LIGHT3_2"], }
    { x=264.000, y=-520.000, tex=TEX_MAP["LIGHT3_2"], }
    { x=264.000, y=-568.000, tex=TEX_MAP["LIGHT3_2"], }
    { t=512.000, tex=TEX_MAP["LIGHT3_2"], }
    { b=456.000, tex=TEX_MAP["LIGHT3_2"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=640.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=512.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=264.000, y=-704.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-640.000, tex=TEX_MAP["COP1_3"], }
    { x=256.000, y=-640.000, tex=TEX_MAP["COP1_3"], }
    { x=256.000, y=-704.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-704.000, tex=TEX_MAP["COP1_3"], }
    { x=320.000, y=-640.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-640.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-704.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=312.000, y=-704.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-696.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-696.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-704.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=312.000, y=-648.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-640.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-640.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-648.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=312.000, y=-696.000, tex=TEX_MAP["LIGHT3_2"], }
    { x=312.000, y=-648.000, tex=TEX_MAP["LIGHT3_2"], }
    { x=264.000, y=-648.000, tex=TEX_MAP["LIGHT3_2"], }
    { x=264.000, y=-696.000, tex=TEX_MAP["LIGHT3_2"], }
    { t=512.000, tex=TEX_MAP["LIGHT3_2"], }
    { b=456.000, tex=TEX_MAP["LIGHT3_2"], }
  }
  {
    { m="solid", }
    { x=264.000, y=-832.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-768.000, tex=TEX_MAP["COP1_3"], }
    { x=256.000, y=-768.000, tex=TEX_MAP["COP1_3"], }
    { x=256.000, y=-832.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-832.000, tex=TEX_MAP["COP1_3"], }
    { x=320.000, y=-768.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-768.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-832.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=312.000, y=-832.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-824.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-824.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-832.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=312.000, y=-776.000, tex=TEX_MAP["COP1_3"], }
    { x=312.000, y=-768.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-768.000, tex=TEX_MAP["COP1_3"], }
    { x=264.000, y=-776.000, tex=TEX_MAP["COP1_3"], }
    { t=512.000, tex=TEX_MAP["COP1_3"], }
    { b=448.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=312.000, y=-824.000, tex=TEX_MAP["LIGHT3_2"], }
    { x=312.000, y=-776.000, tex=TEX_MAP["LIGHT3_2"], }
    { x=264.000, y=-776.000, tex=TEX_MAP["LIGHT3_2"], }
    { x=264.000, y=-824.000, tex=TEX_MAP["LIGHT3_2"], }
    { t=512.000, tex=TEX_MAP["LIGHT3_2"], }
    { b=456.000, tex=TEX_MAP["LIGHT3_2"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=640.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=512.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=512.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=640.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=512.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=640.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=512.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=768.000, y=-528.000, tex=TEX_MAP["METAL1_3"], }
    { x=768.000, y=-496.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-496.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-528.000, tex=TEX_MAP["METAL1_3"], }
    { t=608.000, tex=TEX_MAP["METAL1_3"], }
    { b=576.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=768.000, y=-848.000, tex=TEX_MAP["METAL1_3"], }
    { x=768.000, y=-816.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-816.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-848.000, tex=TEX_MAP["METAL1_3"], }
    { t=608.000, tex=TEX_MAP["METAL1_3"], }
    { b=576.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=608.000, y=-896.000, tex=TEX_MAP["METAL1_3"], }
    { x=608.000, y=-848.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-848.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-896.000, tex=TEX_MAP["METAL1_3"], }
    { t=608.000, tex=TEX_MAP["METAL1_3"], }
    { b=576.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=768.000, y=-816.000, tex=TEX_MAP["METAL1_3"], }
    { x=768.000, y=-768.000, tex=TEX_MAP["METAL1_3"], }
    { x=736.000, y=-768.000, tex=TEX_MAP["METAL1_3"], }
    { x=736.000, y=-816.000, tex=TEX_MAP["METAL1_3"], }
    { t=608.000, tex=TEX_MAP["METAL1_3"], }
    { b=576.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=768.000, y=-608.000, tex=TEX_MAP["METAL1_3"], }
    { x=768.000, y=-576.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-576.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-608.000, tex=TEX_MAP["METAL1_3"], }
    { t=608.000, tex=TEX_MAP["METAL1_3"], }
    { b=576.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=608.000, y=-656.000, tex=TEX_MAP["METAL1_3"], }
    { x=608.000, y=-608.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-608.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-656.000, tex=TEX_MAP["METAL1_3"], }
    { t=608.000, tex=TEX_MAP["METAL1_3"], }
    { b=576.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=768.000, y=-576.000, tex=TEX_MAP["METAL1_3"], }
    { x=768.000, y=-528.000, tex=TEX_MAP["METAL1_3"], }
    { x=736.000, y=-528.000, tex=TEX_MAP["METAL1_3"], }
    { x=736.000, y=-576.000, tex=TEX_MAP["METAL1_3"], }
    { t=608.000, tex=TEX_MAP["METAL1_3"], }
    { b=576.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=608.000, y=-496.000, tex=TEX_MAP["METAL1_3"], }
    { x=608.000, y=-448.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-448.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-496.000, tex=TEX_MAP["METAL1_3"], }
    { t=608.000, tex=TEX_MAP["METAL1_3"], }
    { b=576.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=768.000, y=-768.000, tex=TEX_MAP["METAL1_3"], }
    { x=768.000, y=-736.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-736.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-768.000, tex=TEX_MAP["METAL1_3"], }
    { t=608.000, tex=TEX_MAP["METAL1_3"], }
    { b=576.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=608.000, y=-736.000, tex=TEX_MAP["METAL1_3"], }
    { x=608.000, y=-656.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-656.000, tex=TEX_MAP["METAL1_3"], }
    { x=576.000, y=-736.000, tex=TEX_MAP["METAL1_3"], }
    { t=608.000, tex=TEX_MAP["METAL1_3"], }
    { b=576.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-448.000, tex=TEX_MAP["METAL6_2"], }
    { x=736.000, y=-416.000, tex=TEX_MAP["METAL6_2"], }
    { x=704.000, y=-416.000, tex=TEX_MAP["METAL6_2"], }
    { x=704.000, y=-448.000, tex=TEX_MAP["METAL6_2"], }
    { t=448.000, tex=TEX_MAP["METAL6_2"], }
    { b=320.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=576.000, y=-448.000, tex=TEX_MAP["METAL6_2"], }
    { x=576.000, y=-416.000, tex=TEX_MAP["METAL6_2"], }
    { x=544.000, y=-416.000, tex=TEX_MAP["METAL6_2"], }
    { x=544.000, y=-448.000, tex=TEX_MAP["METAL6_2"], }
    { t=448.000, tex=TEX_MAP["METAL6_2"], }
    { b=320.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-448.000, tex=TEX_MAP["METAL1_4"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-416.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["METAL1_4"], }
    { t=464.000, tex=TEX_MAP["METAL1_4"], }
    { b=448.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=1024.000, y=-256.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=1024.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=-128.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=128.000, y=-256.000, tex=TEX_MAP["MET5_1"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-16.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-16.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { t=-16.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=832.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-16.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=832.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-16.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-176.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1152.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=-128.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=1024.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=1024.000, y=-1152.000, tex=TEX_MAP["MMETAL1_1"], }
    { t=128.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=112.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=0.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=32.000, tex=TEX_MAP["LGMETAL4"], }
    { x=0.000, y=32.000, tex=TEX_MAP["LGMETAL4"], }
    { x=0.000, y=0.000, tex=TEX_MAP["LGMETAL4"], }
    { t=768.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=32.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=32.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { t=704.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-1280.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-1280.000, tex=TEX_MAP["LGMETAL4"], }
    { t=704.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { t=704.000, tex=TEX_MAP["LGMETAL4"], }
    { b=288.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { t=-128.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="liquid", detail=1, medium="water", }
    { x=1280.000, y=-1280.000, tex="nothing", }
    { x=1280.000, y=-768.000, tex="nothing", }
    { x=0.000, y=-768.000, tex="nothing", }
    { x=0.000, y=-1280.000, tex="nothing", }
    { t=-160.000, tex=TEX_MAP["*04MWAT2"], }
    { b=-256.000, tex="nothing", }
  }
  {
    { m="solid", }
    { x=1312.000, y=-1312.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-1280.000, tex=TEX_MAP["LGMETAL4"], }
    { x=0.000, y=-1280.000, tex=TEX_MAP["LGMETAL4"], }
    { x=0.000, y=-1312.000, tex=TEX_MAP["LGMETAL4"], }
    { t=768.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=0.000, y=32.000, tex=TEX_MAP["LGMETAL4"], }
    { x=-32.000, y=32.000, tex=TEX_MAP["LGMETAL4"], }
    { x=-32.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { t=768.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=-1312.000, tex=TEX_MAP["LGMETAL4"], }
    { x=0.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=-32.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=-32.000, y=-1312.000, tex=TEX_MAP["LGMETAL4"], }
    { t=768.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=0.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=0.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=-32.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=-32.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { t=640.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-576.000, tex=TEX_MAP["COP1_3"], }
    { x=1312.000, y=32.000, tex=TEX_MAP["COP1_3"], }
    { x=-32.000, y=32.000, tex=TEX_MAP["COP1_3"], }
    { x=-32.000, y=-576.000, tex=TEX_MAP["COP1_3"], }
    { t=-256.000, tex=TEX_MAP["COP1_3"], }
    { b=-272.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="sky", }
    { x=1312.000, y=-1312.000, tex=TEX_MAP["SKY4"], }
    { x=1312.000, y=32.000, tex=TEX_MAP["SKY4"], }
    { x=-32.000, y=32.000, tex=TEX_MAP["SKY4"], }
    { x=-32.000, y=-1312.000, tex=TEX_MAP["SKY4"], }
    { t=848.000, tex=TEX_MAP["SKY4"], }
    { b=832.000, tex=TEX_MAP["SKY4"], }
  }
  {
    { m="solid", }
    { x=1120.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1024.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1024.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { x=192.000, y=-448.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["METAL1_4"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { t=464.000, tex=TEX_MAP["METAL1_4"], }
    { b=448.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=864.000, y=-416.000, tex=TEX_MAP["METAL1_4"], }
    { x=832.000, y=-416.000, tex=TEX_MAP["METAL1_4"], }
    { x=832.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { t=464.000, tex=TEX_MAP["METAL1_4"], }
    { b=448.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=704.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { t=464.000, tex=TEX_MAP["METAL1_4"], }
    { b=448.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1248.000, tex=TEX_MAP["METAL1_4"], }
    { x=736.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=352.000, y=-1248.000, tex=TEX_MAP["METAL1_4"], }
    { t=464.000, tex=TEX_MAP["METAL1_4"], }
    { b=448.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { t=464.000, tex=TEX_MAP["METAL1_4"], }
    { b=448.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=864.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=864.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { x=736.000, y=-896.000, tex=TEX_MAP["METAL1_4"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { t=272.000, tex=TEX_MAP["METAL1_4"], }
    { b=256.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=704.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { t=272.000, tex=TEX_MAP["METAL1_4"], }
    { b=256.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1248.000, tex=TEX_MAP["METAL1_4"], }
    { x=736.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=352.000, y=-1248.000, tex=TEX_MAP["METAL1_4"], }
    { t=272.000, tex=TEX_MAP["METAL1_4"], }
    { b=256.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["METAL1_4"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["METAL1_4"], }
    { t=272.000, tex=TEX_MAP["METAL1_4"], }
    { b=256.000, tex=TEX_MAP["METAL1_4"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-1280.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=0.000, y=-128.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=0.000, y=-1280.000, tex=TEX_MAP["MMETAL1_1"], }
    { t=-144.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-168.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-16.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=352.000, y=-608.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=352.000, y=-448.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=-448.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=128.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { t=-144.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-168.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=192.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-416.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-24.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=192.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-24.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=0.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=128.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { t=-144.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-168.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-1152.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=1280.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=-1152.000, tex=TEX_MAP["MET5_1"], }
    { t=-144.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-168.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1280.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=-1152.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=-1152.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=128.000, y=-1280.000, tex=TEX_MAP["MET5_1"], }
    { t=-144.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-168.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-1216.000, tex=TEX_MAP["STRNG1_4"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["STRNG1_4"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["STRNG1_4"], }
    { x=384.000, y=-1216.000, tex=TEX_MAP["STRNG1_4"], }
    { t=112.000, tex=TEX_MAP["STRNG1_4"], }
    { b=88.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=80.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=80.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=736.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1216.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=80.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-960.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=704.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-928.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-960.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=80.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=352.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=352.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=320.000, y=-448.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=320.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-16.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-24.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1120.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1120.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1024.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1024.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1120.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-32.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1280.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=304.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-32.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1280.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=304.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-32.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1280.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=304.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-32.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=224.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=256.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=256.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=256.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=256.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=112.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-64.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=256.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=256.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=304.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-32.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=0.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=0.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=304.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-32.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-256.000, tex=TEX_MAP["METAL6_2"], }
    { x=1152.000, y=-224.000, tex=TEX_MAP["METAL6_2"], }
    { x=1120.000, y=-224.000, tex=TEX_MAP["METAL6_2"], }
    { x=1120.000, y=-256.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-160.000, tex=TEX_MAP["METAL6_2"], }
    { x=1152.000, y=-128.000, tex=TEX_MAP["METAL6_2"], }
    { x=1120.000, y=-128.000, tex=TEX_MAP["METAL6_2"], }
    { x=1120.000, y=-160.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-160.000, tex=TEX_MAP["METAL6_2"], }
    { x=1056.000, y=-128.000, tex=TEX_MAP["METAL6_2"], }
    { x=1024.000, y=-128.000, tex=TEX_MAP["METAL6_2"], }
    { x=1024.000, y=-160.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-256.000, tex=TEX_MAP["METAL6_2"], }
    { x=1056.000, y=-224.000, tex=TEX_MAP["METAL6_2"], }
    { x=1024.000, y=-224.000, tex=TEX_MAP["METAL6_2"], }
    { x=1024.000, y=-256.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1280.000, y=-224.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=1056.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1280.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-32.000, tex=TEX_MAP["MET5_1"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1280.000, y=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1248.000, y=-32.000, tex=TEX_MAP["MET5_1"], }
    { x=1248.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-96.000, tex=TEX_MAP["MET5_1"], }
    { x=1056.000, y=-96.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1184.000, y=-224.000, tex=TEX_MAP["MET5_1"], }
    { x=1184.000, y=-96.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=-96.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-120.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-104.000, tex=TEX_MAP["METAL1_3"], }
    { x=1152.000, y=-104.000, tex=TEX_MAP["METAL1_3"], }
    { x=1152.000, y=-120.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-104.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-88.000, tex=TEX_MAP["METAL1_3"], }
    { x=1248.000, y=-88.000, tex=TEX_MAP["METAL1_3"], }
    { x=1248.000, y=-104.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-88.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-72.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-72.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-88.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1184.000, y=-72.000, tex=TEX_MAP["METAL1_3"], }
    { x=1184.000, y=-56.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-56.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-72.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-56.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-40.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-40.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-56.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-40.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-24.000, tex=TEX_MAP["METAL1_3"], }
    { x=1248.000, y=-24.000, tex=TEX_MAP["METAL1_3"], }
    { x=1248.000, y=-40.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-24.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-8.000, tex=TEX_MAP["METAL1_3"], }
    { x=1152.000, y=-8.000, tex=TEX_MAP["METAL1_3"], }
    { x=1152.000, y=-24.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-256.000, tex=TEX_MAP["MET5_1"], }
    { x=1280.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=-256.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=304.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=1024.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=1024.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=304.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-256.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=0.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=0.000, y=-256.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=304.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=256.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=304.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=256.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=224.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=0.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-224.000, tex=TEX_MAP["MET5_1"], }
    { x=0.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-96.000, tex=TEX_MAP["MET5_1"], }
    { x=96.000, y=-96.000, tex=TEX_MAP["MET5_1"], }
    { x=96.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=0.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=0.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=32.000, y=-224.000, tex=TEX_MAP["MET5_1"], }
    { x=32.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=224.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=32.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=32.000, y=-32.000, tex=TEX_MAP["MET5_1"], }
    { x=224.000, y=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=224.000, y=-96.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=-96.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-160.000, tex=TEX_MAP["METAL6_2"], }
    { x=256.000, y=-128.000, tex=TEX_MAP["METAL6_2"], }
    { x=224.000, y=-128.000, tex=TEX_MAP["METAL6_2"], }
    { x=224.000, y=-160.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-256.000, tex=TEX_MAP["METAL6_2"], }
    { x=160.000, y=-224.000, tex=TEX_MAP["METAL6_2"], }
    { x=128.000, y=-224.000, tex=TEX_MAP["METAL6_2"], }
    { x=128.000, y=-256.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-160.000, tex=TEX_MAP["METAL6_2"], }
    { x=160.000, y=-128.000, tex=TEX_MAP["METAL6_2"], }
    { x=128.000, y=-128.000, tex=TEX_MAP["METAL6_2"], }
    { x=128.000, y=-160.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-256.000, tex=TEX_MAP["METAL6_2"], }
    { x=256.000, y=-224.000, tex=TEX_MAP["METAL6_2"], }
    { x=224.000, y=-224.000, tex=TEX_MAP["METAL6_2"], }
    { x=224.000, y=-256.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-120.000, tex=TEX_MAP["METAL1_3"], }
    { x=128.000, y=-104.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-104.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-120.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=32.000, y=-104.000, tex=TEX_MAP["METAL1_3"], }
    { x=32.000, y=-88.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-88.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-104.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=112.000, y=-88.000, tex=TEX_MAP["METAL1_3"], }
    { x=112.000, y=-72.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-72.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-88.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=112.000, y=-72.000, tex=TEX_MAP["METAL1_3"], }
    { x=112.000, y=-56.000, tex=TEX_MAP["METAL1_3"], }
    { x=96.000, y=-56.000, tex=TEX_MAP["METAL1_3"], }
    { x=96.000, y=-72.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=112.000, y=-56.000, tex=TEX_MAP["METAL1_3"], }
    { x=112.000, y=-40.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-40.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-56.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=32.000, y=-40.000, tex=TEX_MAP["METAL1_3"], }
    { x=32.000, y=-24.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-24.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-40.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-24.000, tex=TEX_MAP["METAL1_3"], }
    { x=128.000, y=-8.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-8.000, tex=TEX_MAP["METAL1_3"], }
    { x=16.000, y=-24.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1280.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1056.000, tex=TEX_MAP["MET5_1"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-1280.000, tex=TEX_MAP["MET5_1"], }
    { x=1056.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1184.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1184.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { x=1184.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1184.000, tex=TEX_MAP["MET5_1"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1280.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1248.000, y=-1056.000, tex=TEX_MAP["MET5_1"], }
    { x=1248.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1248.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1248.000, y=-1248.000, tex=TEX_MAP["MET5_1"], }
    { x=1056.000, y=-1248.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-32.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-40.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-1272.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=1152.000, y=-1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=1152.000, y=-1272.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-1256.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-1240.000, tex=TEX_MAP["METAL1_3"], }
    { x=1248.000, y=-1240.000, tex=TEX_MAP["METAL1_3"], }
    { x=1248.000, y=-1256.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-1240.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-1224.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-1224.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-1240.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1184.000, y=-1224.000, tex=TEX_MAP["METAL1_3"], }
    { x=1184.000, y=-1208.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-1208.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-1224.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-1208.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-1192.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-1192.000, tex=TEX_MAP["METAL1_3"], }
    { x=1168.000, y=-1208.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-1192.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-1176.000, tex=TEX_MAP["METAL1_3"], }
    { x=1248.000, y=-1176.000, tex=TEX_MAP["METAL1_3"], }
    { x=1248.000, y=-1192.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1264.000, y=-1176.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-1160.000, tex=TEX_MAP["METAL1_3"], }
    { x=1152.000, y=-1160.000, tex=TEX_MAP["METAL1_3"], }
    { x=1152.000, y=-1176.000, tex=TEX_MAP["METAL1_3"], }
    { t=-144.000, tex=TEX_MAP["METAL1_3"], }
    { b=-160.000, tex=TEX_MAP["METAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-1056.000, tex=TEX_MAP["METAL6_2"], }
    { x=1056.000, y=-1024.000, tex=TEX_MAP["METAL6_2"], }
    { x=1024.000, y=-1024.000, tex=TEX_MAP["METAL6_2"], }
    { x=1024.000, y=-1056.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1056.000, tex=TEX_MAP["METAL6_2"], }
    { x=1152.000, y=-1024.000, tex=TEX_MAP["METAL6_2"], }
    { x=1120.000, y=-1024.000, tex=TEX_MAP["METAL6_2"], }
    { x=1120.000, y=-1056.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1152.000, tex=TEX_MAP["METAL6_2"], }
    { x=1152.000, y=-1120.000, tex=TEX_MAP["METAL6_2"], }
    { x=1120.000, y=-1120.000, tex=TEX_MAP["METAL6_2"], }
    { x=1120.000, y=-1152.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-1152.000, tex=TEX_MAP["METAL6_2"], }
    { x=1056.000, y=-1120.000, tex=TEX_MAP["METAL6_2"], }
    { x=1024.000, y=-1120.000, tex=TEX_MAP["METAL6_2"], }
    { x=1024.000, y=-1152.000, tex=TEX_MAP["METAL6_2"], }
    { t=-64.000, tex=TEX_MAP["METAL6_2"], }
    { b=-128.000, tex=TEX_MAP["METAL6_2"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-1280.000, tex=TEX_MAP["MET5_1"], }
    { x=1280.000, y=-1024.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=-1024.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=-1280.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=304.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=304.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-32.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-1280.000, tex=TEX_MAP["MET5_1"], }
    { x=1152.000, y=-1152.000, tex=TEX_MAP["MET5_1"], }
    { x=1024.000, y=-1152.000, tex=TEX_MAP["MET5_1"], }
    { x=1024.000, y=-1280.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=304.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=1472.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1264.000, y=-608.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=288.000, tex=TEX_MAP["NMETAL2_1"], slope={ nx=0.00000, ny=0.70711, nz=0.70711 }, }
    { b=160.000, tex=TEX_MAP["NMETAL2_1"], slope={ nx=0.00000, ny=0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=1472.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1264.000, y=-720.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=288.000, tex=TEX_MAP["NMETAL2_1"], slope={ nx=0.00000, ny=-0.70711, nz=0.70711 }, }
    { b=160.000, tex=TEX_MAP["NMETAL2_1"], slope={ nx=0.00000, ny=-0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=1344.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1344.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1264.000, y=-624.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=176.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=160.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=1472.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1264.000, y=-624.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=288.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=272.000, tex=TEX_MAP["NMETAL2_1"], }
  }
--    @@@@ FIX BRUSH @ line:2429 @@@@
--    @@@@ FIX BRUSH @ line:2437 @@@@
--    @@@@ FIX BRUSH @ line:2445 @@@@
--    @@@@ FIX BRUSH @ line:2453 @@@@
--    @@@@ FIX BRUSH @ line:2461 @@@@
  {
    { m="solid", }
    { x=1488.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1488.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=288.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-128.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=1472.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1360.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1360.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=160.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-120.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=1488.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1488.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1264.000, y=-624.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=-120.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-128.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=1472.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1264.000, y=-608.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=0.000, tex=TEX_MAP["NMETAL2_1"], slope={ nx=0.00000, ny=0.70711, nz=0.70711 }, }
    { b=-128.000, tex=TEX_MAP["NMETAL2_1"], slope={ nx=0.00000, ny=0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=1472.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1264.000, y=-720.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=0.000, tex=TEX_MAP["NMETAL2_1"], slope={ nx=0.00000, ny=-0.70711, nz=0.70711 }, }
    { b=-128.000, tex=TEX_MAP["NMETAL2_1"], slope={ nx=0.00000, ny=-0.70711, nz=-0.70711 }, }
  }
  {
    { m="solid", }
    { x=1360.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1360.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1264.000, y=-624.000, tex=TEX_MAP["METAL1_3"], }
    { x=1264.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=0.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-16.000, tex=TEX_MAP["NMETAL2_1"], }
  }
--    @@@@ FIX BRUSH @ line:2517 @@@@
--    @@@@ FIX BRUSH @ line:2525 @@@@
--    @@@@ FIX BRUSH @ line:2533 @@@@
--    @@@@ FIX BRUSH @ line:2541 @@@@
  {
    { m="solid", }
    { x=1472.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1360.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1360.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=160.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-40.000, tex=TEX_MAP["NMETAL2_1"], }
  }
--    @@@@ FIX BRUSH @ line:2557 @@@@
  {
    { m="solid", }
    { x=1472.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-704.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1456.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=272.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-144.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=1456.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-640.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1472.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=272.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-144.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=1360.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1360.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1344.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1344.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=160.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-16.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=1488.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1488.000, y=-576.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-576.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { t=704.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1488.000, y=-768.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1488.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-768.000, tex=TEX_MAP["LGMETAL4"], }
    { t=704.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1520.000, y=-768.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1520.000, y=-576.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1488.000, y=-576.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1488.000, y=-768.000, tex=TEX_MAP["LGMETAL4"], }
    { t=704.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1488.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1488.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { t=704.000, tex=TEX_MAP["LGMETAL4"], }
    { b=688.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1488.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1488.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { t=-240.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-256.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { t=160.000, tex=TEX_MAP["LGMETAL4"], }
    { b=0.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-752.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=1280.000, y=-592.000, tex=TEX_MAP["MET5_1"], }
    { x=1240.000, y=-592.000, tex=TEX_MAP["MET5_1"], }
    { x=1240.000, y=-752.000, tex=TEX_MAP["MET5_1"], }
    { t=-128.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-144.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-624.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-624.000, tex=TEX_MAP["LGMETAL4"], }
    { t=288.000, tex=TEX_MAP["LGMETAL4"], }
    { b=272.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-720.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-720.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { t=288.000, tex=TEX_MAP["LGMETAL4"], }
    { b=272.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-720.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-720.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { t=176.000, tex=TEX_MAP["LGMETAL4"], }
    { b=160.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-624.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-624.000, tex=TEX_MAP["LGMETAL4"], }
    { t=176.000, tex=TEX_MAP["LGMETAL4"], }
    { b=160.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-624.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-624.000, tex=TEX_MAP["LGMETAL4"], }
    { t=-112.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-128.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-720.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-720.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { t=-112.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-128.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-720.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-720.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-736.000, tex=TEX_MAP["LGMETAL4"], }
    { t=0.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-16.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-624.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-608.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-624.000, tex=TEX_MAP["LGMETAL4"], }
    { t=0.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-16.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-1280.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1312.000, y=32.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=32.000, tex=TEX_MAP["LGMETAL4"], }
    { x=1280.000, y=-1280.000, tex=TEX_MAP["LGMETAL4"], }
    { t=768.000, tex=TEX_MAP["LGMETAL4"], }
    { b=704.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-1280.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=1280.000, y=-1216.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=0.000, y=-1216.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=0.000, y=-1280.000, tex=TEX_MAP["MMETAL1_6"], }
    { t=832.000, tex=TEX_MAP["MMETAL1_6"], }
    { b=768.000, tex=TEX_MAP["MMETAL1_6"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-64.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=1280.000, y=0.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=0.000, y=0.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=0.000, y=-64.000, tex=TEX_MAP["MMETAL1_6"], }
    { t=832.000, tex=TEX_MAP["MMETAL1_6"], }
    { b=768.000, tex=TEX_MAP["MMETAL1_6"], }
  }
  {
    { m="solid", }
    { x=64.000, y=-1216.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=64.000, y=-64.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=0.000, y=-64.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=0.000, y=-1216.000, tex=TEX_MAP["MMETAL1_6"], }
    { t=832.000, tex=TEX_MAP["MMETAL1_6"], }
    { b=768.000, tex=TEX_MAP["MMETAL1_6"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-1216.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=1280.000, y=-64.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=1216.000, y=-64.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=1216.000, y=-1216.000, tex=TEX_MAP["MMETAL1_6"], }
    { t=832.000, tex=TEX_MAP["MMETAL1_6"], }
    { b=768.000, tex=TEX_MAP["MMETAL1_6"], }
  }
  {
    { m="solid", }
    { x=1024.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { x=1024.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=256.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=256.000, y=-128.000, tex=TEX_MAP["MET5_1"], }
    { t=320.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=304.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=352.000, y=-896.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=352.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=-736.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=128.000, y=-896.000, tex=TEX_MAP["MET5_1"], }
    { t=-144.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-168.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=192.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=-608.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=128.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { t=-144.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-160.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=352.000, y=-736.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=352.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=320.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=320.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { t=-144.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-160.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="liquid", detail=1, medium="water", }
    { x=1280.000, y=-576.000, tex="nothing", }
    { x=1280.000, y=0.000, tex="nothing", }
    { x=0.000, y=0.000, tex="nothing", }
    { x=0.000, y=-576.000, tex="nothing", }
    { t=-160.000, tex=TEX_MAP["*04MWAT2"], }
    { b=-256.000, tex="nothing", }
  }
  {
    { m="liquid", detail=1, medium="water", }
    { x=160.000, y=-768.000, tex="nothing", }
    { x=160.000, y=-576.000, tex="nothing", }
    { x=0.000, y=-576.000, tex="nothing", }
    { x=0.000, y=-768.000, tex="nothing", }
    { t=-160.000, tex=TEX_MAP["*04MWAT2"], }
    { b=-256.000, tex="nothing", }
  }
  {
    { m="liquid", detail=1, medium="water", }
    { x=1280.000, y=-768.000, tex="nothing", }
    { x=1280.000, y=-576.000, tex="nothing", }
    { x=352.000, y=-576.000, tex="nothing", }
    { x=352.000, y=-768.000, tex="nothing", }
    { t=-160.000, tex=TEX_MAP["*04MWAT2"], }
    { b=-256.000, tex="nothing", }
  }
  {
    { m="solid", }
    { x=352.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=352.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=320.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=320.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=-160.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-448.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=192.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=160.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=160.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=-160.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-320.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=352.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=352.000, y=-576.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=160.000, y=-576.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=160.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-160.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-448.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=352.000, y=-768.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=352.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=160.000, y=-768.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=-160.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-448.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-1312.000, tex=TEX_MAP["COP1_3"], }
    { x=1312.000, y=-768.000, tex=TEX_MAP["COP1_3"], }
    { x=-32.000, y=-768.000, tex=TEX_MAP["COP1_3"], }
    { x=-32.000, y=-1312.000, tex=TEX_MAP["COP1_3"], }
    { t=-256.000, tex=TEX_MAP["COP1_3"], }
    { b=-272.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-768.000, tex=TEX_MAP["LGMETAL4"], }
    { x=160.000, y=-576.000, tex=TEX_MAP["LGMETAL4"], }
    { x=-32.000, y=-576.000, tex=TEX_MAP["LGMETAL4"], }
    { x=-32.000, y=-768.000, tex=TEX_MAP["LGMETAL4"], }
    { t=-256.000, tex=TEX_MAP["LGMETAL4"], }
    { b=-272.000, tex=TEX_MAP["LGMETAL4"], }
  }
  {
    { m="solid", }
    { x=1312.000, y=-768.000, tex=TEX_MAP["COP1_3"], }
    { x=1312.000, y=-576.000, tex=TEX_MAP["COP1_3"], }
    { x=352.000, y=-576.000, tex=TEX_MAP["COP1_3"], }
    { x=352.000, y=-768.000, tex=TEX_MAP["COP1_3"], }
    { t=-256.000, tex=TEX_MAP["COP1_3"], }
    { b=-272.000, tex=TEX_MAP["COP1_3"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=192.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=-32.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=-32.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=-320.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-336.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=320.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=-192.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=-192.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=-448.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-464.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=160.000, y=-576.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=-192.000, y=-576.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=-192.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-320.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-464.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-768.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=160.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-192.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=-192.000, y=-768.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=-320.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-464.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=-192.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-192.000, y=-576.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=-224.000, y=-576.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=-224.000, y=-768.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=768.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=-464.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=192.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=192.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=160.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=160.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-336.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-344.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=-32.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=-32.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-64.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-64.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-64.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-344.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=-32.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-32.000, y=-576.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-192.000, y=-576.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-192.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=768.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-320.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=-32.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-32.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-192.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-192.000, y=-768.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=768.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-320.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=-32.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-32.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-64.000, y=-608.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=-64.000, y=-736.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=640.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-320.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=0.000, y=-768.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=0.000, y=-576.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=-224.000, y=-576.000, tex=TEX_MAP["MMETAL1_6"], }
    { x=-224.000, y=-768.000, tex=TEX_MAP["MMETAL1_6"], }
    { t=832.000, tex=TEX_MAP["MMETAL1_6"], }
    { b=768.000, tex=TEX_MAP["MMETAL1_6"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { x=128.000, y=-608.000, tex=TEX_MAP["MET5_1"], }
    { x=0.000, y=-608.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=0.000, y=-736.000, tex=TEX_MAP["MET5_1"], }
    { t=640.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=624.000, tex=TEX_MAP["MMETAL1_1"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=160.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=128.000, y=-608.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=128.000, y=-624.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=640.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=624.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=160.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=128.000, y=-720.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=128.000, y=-736.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=640.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=624.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-680.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=160.000, y=-664.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=128.000, y=-664.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=128.000, y=-680.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=640.000, tex=TEX_MAP["NMETAL2_1"], }
    { b=624.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-64.000, tex=TEX_MAP["MET5_1"], }
    { x=1280.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=1216.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=1216.000, y=-64.000, tex=TEX_MAP["MET5_1"], }
    { t=328.000, tex=TEX_MAP["COP3_4"], }
    { b=320.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=64.000, y=-64.000, tex=TEX_MAP["MET5_1"], }
    { x=64.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=0.000, y=0.000, tex=TEX_MAP["MET5_1"], }
    { x=0.000, y=-64.000, tex=TEX_MAP["MET5_1"], }
    { t=328.000, tex=TEX_MAP["COP3_4"], }
    { b=320.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-1280.000, tex=TEX_MAP["MET5_1"], }
    { x=1280.000, y=-1216.000, tex=TEX_MAP["MET5_1"], }
    { x=1216.000, y=-1216.000, tex=TEX_MAP["MET5_1"], }
    { x=1216.000, y=-1280.000, tex=TEX_MAP["MET5_1"], }
    { t=328.000, tex=TEX_MAP["COP3_4"], }
    { b=320.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=960.000, y=-704.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=960.000, y=-640.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-640.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=864.000, y=-704.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=640.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=624.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=480.000, y=-704.000, tex=TEX_MAP["MET5_1"], }
    { x=480.000, y=-640.000, tex=TEX_MAP["MET5_1"], }
    { x=416.000, y=-640.000, tex=TEX_MAP["MET5_1"], }
    { x=416.000, y=-704.000, tex=TEX_MAP["MET5_1"], }
    { t=136.000, tex=TEX_MAP["COP3_4"], }
    { b=128.000, tex=TEX_MAP["MET5_1"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=128.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=0.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=0.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=256.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=256.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=224.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=0.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-128.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1280.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-224.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-256.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1280.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1280.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1024.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1152.000, y=-1056.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=1056.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1056.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1152.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=1024.000, y=-1280.000, tex=TEX_MAP["MMETAL1_3"], }
    { t=-160.000, tex=TEX_MAP["MMETAL1_3"], }
    { b=-256.000, tex=TEX_MAP["MMETAL1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-896.000, tex=TEX_MAP["MMETAL1_3"], }
    { x=384.000, y=-448.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=192.000, y=-448.000, tex=TEX_MAP["MMETAL1_1"], }
    { x=192.000, y=-896.000, tex=TEX_MAP["MMETAL1_1"], }
    { t=0.000, tex=TEX_MAP["MMETAL1_1"], }
    { b=-16.000, tex=TEX_MAP["STRNG1_4"], }
  }
  {
    { m="liquid", detail=1, medium="water", }
    { x=384.000, y=-896.000, tex="nothing", }
    { x=384.000, y=-448.000, tex="nothing", }
    { x=192.000, y=-448.000, tex="nothing", }
    { x=192.000, y=-896.000, tex="nothing", }
    { t=64.000, tex=TEX_MAP["*04MWAT2"], }
    { b=0.000, tex="nothing", }
  }
  {
    { m="solid", link_entity="m1", }
    { x=704.000, y=-1216.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=704.000, y=-1088.000, tex=TEX_MAP["NMETAL2_1"], }
    { x=576.000, y=-1088.000, tex=TEX_MAP["MET5_1"], }
    { x=576.000, y=-1216.000, tex=TEX_MAP["NMETAL2_1"], }
    { t=320.000, tex=TEX_MAP["PLAT_TOP2"], }
    { b=304.000, tex=TEX_MAP["NMETAL2_1"], }
  }
  {
    { m="solid", link_entity="m2", }
    { x=1472.000, y=-704.000, tex=TEX_MAP["TRIGGER"], }
    { x=1472.000, y=-640.000, tex=TEX_MAP["TRIGGER"], }
    { x=1280.000, y=-640.000, tex=TEX_MAP["TRIGGER"], }
    { x=1280.000, y=-704.000, tex=TEX_MAP["TRIGGER"], }
    { t=-64.000, tex=TEX_MAP["TRIGGER"], }
    { b=-80.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m3", }
    { x=1440.000, y=-704.000, tex=TEX_MAP["TRIGGER"], }
    { x=1440.000, y=-640.000, tex=TEX_MAP["TRIGGER"], }
    { x=1376.000, y=-640.000, tex=TEX_MAP["TRIGGER"], }
    { x=1376.000, y=-704.000, tex=TEX_MAP["TRIGGER"], }
    { t=160.000, tex=TEX_MAP["TRIGGER"], }
    { b=-80.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m4", }
    { x=1440.000, y=-704.000, tex=TEX_MAP["TRIGGER"], }
    { x=1440.000, y=-640.000, tex=TEX_MAP["TRIGGER"], }
    { x=1264.000, y=-640.000, tex=TEX_MAP["TRIGGER"], }
    { x=1264.000, y=-704.000, tex=TEX_MAP["TRIGGER"], }
    { t=232.000, tex=TEX_MAP["TRIGGER"], }
    { b=216.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m5", }
    { x=-64.000, y=-736.000, tex=TEX_MAP["TRIGGER"], }
    { x=-64.000, y=-608.000, tex=TEX_MAP["TRIGGER"], }
    { x=-192.000, y=-608.000, tex=TEX_MAP["TRIGGER"], }
    { x=-192.000, y=-736.000, tex=TEX_MAP["TRIGGER"], }
    { t=640.000, tex=TEX_MAP["TRIGGER"], }
    { b=-416.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m6", }
    { x=-48.000, y=-720.000, tex=TEX_MAP["TRIGGER"], }
    { x=-48.000, y=-624.000, tex=TEX_MAP["TRIGGER"], }
    { x=-184.000, y=-624.000, tex=TEX_MAP["TRIGGER"], }
    { x=-184.000, y=-720.000, tex=TEX_MAP["TRIGGER"], }
    { t=752.000, tex=TEX_MAP["TRIGGER"], }
    { b=728.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m7", }
    { x=0.000, y=-736.000, tex=TEX_MAP["TRIGGER"], }
    { x=0.000, y=-608.000, tex=TEX_MAP["TRIGGER"], }
    { x=-112.000, y=-608.000, tex=TEX_MAP["TRIGGER"], }
    { x=-112.000, y=-736.000, tex=TEX_MAP["TRIGGER"], }
    { t=-432.000, tex=TEX_MAP["TRIGGER"], }
    { b=-448.000, tex=TEX_MAP["TRIGGER"], }
  }
}

