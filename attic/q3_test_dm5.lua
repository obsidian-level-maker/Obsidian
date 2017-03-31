ENT_MAP = 
{
  ["func_button"]                = "func_button",
  ["func_door"]                  = "func_door",
  ["info_intermission"]          = "info_intermission",
  ["info_player_deathmatch"]     = "info_player_deathmatch",
  ["info_player_start"]          = "info_player_start",
  ["info_teleport_destination"]  = "misc_teleporter_dest",
  ["item_armor2"]                = "item_armor2",
  ["item_artifact_invulnerability"] = "item_artifact_invulnerability",
  ["item_cells"]                 = "item_cells",
  ["item_health"]                = "item_health",
  ["item_rockets"]               = "item_rockets",
  ["item_spikes"]                = "item_spikes",
  ["item_weapon"]                = "item_weapon",
  ["light_flame_small_yellow"]   = "light",
  ["light"]                      = "light",
  ["light_torch_small_walltorch"] = "nothing",
  ["trigger_changelevel"]        = "trigger_changelevel",
  ["trigger_multiple"]           = "trigger_multiple",
  ["trigger_teleport"]           = "trigger_teleport",
  ["weapon_grenadelauncher"]     = "weapon_grenadelauncher",
  ["weapon_lightning"]           = "weapon_lightning",
  ["weapon_nailgun"]             = "weapon_nailgun",
  ["weapon_rocketlauncher"]      = "weapon_rocketlauncher",
  ["weapon_supernailgun"]        = "weapon_supernailgun",
}

TEX_MAP = 
{
  ["SKY4"]                       = "skies/nitesky",
  ["*TELEPORT"]                  = "TELEPORT",
  ["TRIGGER"]                    = "TRIGGER",
  ["*04WATER2"]                  = "liquids/softwater",
  ["+2BUTTON"]                   = "+2BUTTON",
  ["AFLOOR1_3"]                  = "cosmo_floor/bfloor3",
  ["AFLOOR1_4"]                  = "cosmo_floor/bfloor3",
  ["AFLOOR1_8"]                  = "cosmo_floor/bfloor3",
  ["AZ1_6"]                      = "AZ1_6",
  ["CITY2_3"]                    = "gothic_block/blocks15",
  ["CITY2_6"]                    = "gothic_block/blocks15",
  ["CITY3_4"]                    = "gothic_block/blocks15",
  ["CITY4_1"]                    = "gothic_block/blocks15",
  ["COP1_2"]                     = "base_wall/concrete1",
  ["COP1_5"]                     = "base_wall/concrete1",
  ["ADOOR03_6"]                  = "base_trim/pewter_shiney",
  ["DOOR04_1"]                   = "base_trim/pewter_shiney",
  ["DOOR05_3"]                   = "base_trim/pewter_shiney",
  ["METAL1_7"]                   = "base_wall/redmet",
  ["METAL2_4"]                   = "base_wall/redmet",
  ["Z_EXIT"]                     = "base_wall/concrete1",
}

all_entities =
{
  {
    id = ENT_MAP["info_player_start"]
    angle = 0
    x = -72
    y = 376
    z = 232
  }
  {
    id = ENT_MAP["light"]
    x = 744
    y = -440
    z = 376
    light = 400
  }
  {
    id = ENT_MAP["light"]
    x = 432
    y = -440
    z = 376
    light = 400
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 506
    y = -286
    z = 148
    light = 250
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 650
    y = -286
    z = 148
    light = 250
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 858
    y = -826
    z = 244
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 178
    y = -320
    z = 68
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = -176
    y = -824
    z = 68
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = 116
    y = -224
    z = 344
    light = 300
  }
  {
    id = ENT_MAP["light"]
    x = -104
    y = -644
    z = 344
    light = 300
  }
  {
    id = ENT_MAP["light"]
    x = 88
    y = -644
    z = 344
    light = 300
  }
  {
    id = ENT_MAP["light"]
    x = 8
    y = -640
    z = 296
    light = 200
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 522
    y = -718
    z = 244
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = 344
    y = -640
    z = 176
    light = 200
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = -24
    y = -222
    z = 68
  }
  {
    id = ENT_MAP["light"]
    x = 80
    y = -592
    z = -8
    light = 250
  }
  {
    id = ENT_MAP["light"]
    x = 792
    y = 372
    z = 344
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = -176
    y = 482
    z = 68
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 132
    y = 792
    z = 148
    light = 250
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 426
    y = 792
    z = 148
    light = 250
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 122
    y = 586
    z = 20
    light = 250
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 442
    y = 586
    z = 20
    light = 250
  }
  {
    id = ENT_MAP["light"]
    x = 280
    y = -224
    z = 256
    light = 200
  }
  {
    id = ENT_MAP["light_flame_small_yellow"]
    -- id = "oblige_rtlight"
    x = 288
    y = 574
    z = 304
    light = 250*1.7
  }
  {
    id = ENT_MAP["light_flame_small_yellow"]
    -- id = "oblige_rtlight"
    x = 288
    y = 234
    z = 304
    light = 250*1.7
  }
  {
    id = ENT_MAP["light"]
    x = 288
    y = 416
    z = 280
  }
  {
    id = ENT_MAP["light"]
    x = 288
    y = 392
    z = 152
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = -112
    y = 368
    z = 272
    light = 200
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 616
    y = 224
    z = 244
  }
  {
    id = ENT_MAP["light"]
    x = 528
    y = 280
    z = 296
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = -104
    y = -224
    z = 272
    light = 200
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 288
    y = 248
    z = -8
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 224
    y = -120
    z = -16
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 544
    y = -640
    z = -16
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 216
    y = -408
    z = -16
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 528
    y = -128
    z = -16
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 280
    y = -664
    z = -16
  }
  {
    id = ENT_MAP["light"]
    light = 100
    x = 568
    y = -376
    z = -16
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = 616
    y = -552
    z = 264
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 225
    x = 144
    y = -344
    z = 40
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 0
    x = 160
    y = -224
    z = 232
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 270
    x = 296
    y = 704
    z = 120
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 180
    x = 720
    y = 368
    z = 248
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 90
    x = 640
    y = -776
    z = 216
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 2
    x = 8
    y = -640
    z = -120
    mdl = "grenade"
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 2
    x = 288
    y = 368
    z = 192
    mdl = "grenade"
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 1146
    y = -646
    z = 244
    light = 250
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 952
    y = -176
    z = 244
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 1146
    y = -890
    z = 244
    light = 250
  }
  {
    id = ENT_MAP["info_teleport_destination"]
    targetname = "t2"
    angle = 180
    x = 1072
    y = -768
    z = 204
  }
  {
    id = ENT_MAP["trigger_teleport"]
    target = "t2"
    angle = 180
    link_id = "m1"
  }
  {
    id = ENT_MAP["trigger_teleport"]
    target = "t3"
    angle = 180
    link_id = "m2"
  }
  {
    id = ENT_MAP["info_teleport_destination"]
    targetname = "t3"
    angle = 180
    x = 848
    y = 376
    z = 200
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 362
    y = 1032
    z = 164
    light = 200
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 214
    y = 1032
    z = 164
    light = 200
  }
  {
    id = ENT_MAP["func_button"]
    spawnflags = 1
    angle = 270
    target = "t4"
    link_id = "m3"
    wait = 2
  }
  {
    id = ENT_MAP["light"]
    x = 288
    y = 760
    z = 176
    light = 150
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 242
    y = -286
    z = 148
    light = 250
  }
  {
    id = ENT_MAP["info_player_deathmatch"]
    angle = 225
    x = 880
    y = -256
    z = 216
  }
  {
    id = ENT_MAP["light"]
    x = 288
    y = 224
    z = 168
    light = 150
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 2
    x = 272
    y = 1000
    z = 96
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 736
    y = 504
    z = 192
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 792
    y = 504
    z = 192
  }
  {
    id = ENT_MAP["item_health"]
    x = -120
    y = 376
    z = 192
  }
  {
    id = ENT_MAP["item_health"]
    x = 80
    y = -432
    z = 16
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 200
    y = -256
    z = 192
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 256
    y = -256
    z = 192
  }
  {
    id = ENT_MAP["item_health"]
    x = 1016
    y = -680
    z = 192
  }
  {
    id = ENT_MAP["item_health"]
    spawnflags = 1
    x = 512
    y = -240
    z = -136
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 1
    x = 920
    y = -544
    z = 208
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 1
    x = 920
    y = -600
    z = 208
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 4
    x = -160
    y = -48
    z = 16
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 9
    x = -160
    y = -104
    z = 16
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 12
    x = -112
    y = -792
    z = 192
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 9
    x = 504
    y = -16
    z = -136
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 4
    x = 372
    y = -320
    z = 96
  }
  {
    id = ENT_MAP["item_weapon"]
    spawnflags = 1
    x = 768
    y = 240
    z = 192
  }
  {
    id = ENT_MAP["item_rockets"]
    x = 416
    y = -808
    z = 100
  }
  {
    id = ENT_MAP["func_door"]
    targetname = "t4"
    link_id = "m4"
    angle = 180
  }
  {
    id = ENT_MAP["trigger_multiple"]
    target = "t4"
    link_id = "m5"
  }
  {
    id = ENT_MAP["item_spikes"]
    x = 904
    y = -208
    z = 208
  }
  {
    id = ENT_MAP["weapon_supernailgun"]
    x = 832
    y = -208
    z = 208
  }
  {
    id = ENT_MAP["item_spikes"]
    x = 520
    y = 288
    z = -32
  }
  {
    id = ENT_MAP["weapon_nailgun"]
    x = 536
    y = 360
    z = -32
  }
  {
    id = ENT_MAP["weapon_rocketlauncher"]
    angle = 180
    x = 272
    y = 944
    z = 96
  }
  {
    id = ENT_MAP["weapon_grenadelauncher"]
    x = 112
    y = -400
    z = 16
  }
  {
    id = ENT_MAP["item_armor2"]
    x = 656
    y = -320
    z = 96
  }
  {
    id = ENT_MAP["func_door"]
    sounds = 1
    angle = 0
    link_id = "m6"
  }
  {
    id = ENT_MAP["light_torch_small_walltorch"]
    x = 714
    y = 58
    z = 28
    light = 250
  }
  {
    id = ENT_MAP["weapon_lightning"]
    x = 648
    y = -72
    z = -32
  }
  {
    id = ENT_MAP["item_cells"]
    spawnflags = 1
    x = 680
    y = -120
    z = -32
  }
  {
    id = ENT_MAP["light"]
    x = 288
    y = 72
    z = -88
    light = 150
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 504
    y = 48
    z = -88
  }
  {
    id = ENT_MAP["light"]
    x = 496
    y = -128
    z = -88
    light = 150
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 336
    y = -200
    z = -88
  }
  {
    id = ENT_MAP["light"]
    x = 528
    y = -432
    z = -88
    light = 150
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 296
    y = -568
    z = -88
  }
  {
    id = ENT_MAP["light"]
    x = 520
    y = -584
    z = -88
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 400
    y = -360
    z = -88
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 512
    y = 280
    z = 72
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 88
    y = 328
    z = 72
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = 288
    y = 544
    z = 32
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 928
    y = 376
    z = 248
    light = 200
  }
  {
    id = ENT_MAP["light"]
    x = 632
    y = 520
    z = 232
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = -64
    y = -648
    z = 96
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 40
    y = -760
    z = 120
    light = 125
  }
  {
    id = ENT_MAP["light"]
    x = 216
    y = -768
    z = 136
    light = 125
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = 384
    y = -768
    z = 136
  }
  {
    id = ENT_MAP["light"]
    x = 272
    y = -320
    z = -80
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = -104
    y = 248
    z = 272
    light = 175
  }
  {
    id = ENT_MAP["light"]
    x = -104
    y = 96
    z = 272
    light = 125
  }
  {
    id = ENT_MAP["light"]
    x = -96
    y = -424
    z = 272
    light = 125
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = -96
    y = -536
    z = 272
  }
  {
    id = ENT_MAP["light"]
    x = 280
    y = 864
    z = 192
    light = 150
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 528
    y = 440
    z = 264
  }
  {
    id = ENT_MAP["light"]
    light = 100
    x = 592
    y = 368
    z = 240
  }
  {
    id = ENT_MAP["light"]
    light = 100
    x = -96
    y = -480
    z = 88
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = -144
    y = -640
    z = 232
  }
  {
    id = ENT_MAP["light"]
    x = 88
    y = -800
    z = 232
    light = 125
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = -48
    y = -800
    z = 232
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 744
    y = -392
    z = 232
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = 584
    y = -224
    z = 248
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = 736
    y = -224
    z = 248
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = 440
    y = -224
    z = 248
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = 536
    y = 360
    z = -16
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = 120
    y = -224
    z = 248
  }
  {
    id = ENT_MAP["light"]
    light = 150
    x = -96
    y = -536
    z = 112
  }
  {
    id = ENT_MAP["light"]
    light = 200
    x = -96
    y = 128
    z = 104
  }
  {
    id = ENT_MAP["light"]
    x = 440
    y = -776
    z = 296
    light = 150
  }
  {
    id = ENT_MAP["light"]
    x = 8
    y = -376
    z = 80
    light = 100
  }
  {
    id = ENT_MAP["item_cells"]
    spawnflags = 1
    x = -176
    y = -704
    z = 16
  }
  {
    id = ENT_MAP["item_cells"]
    spawnflags = 1
    x = -176
    y = -752
    z = 16
  }
  {
    id = ENT_MAP["light"]
    light = 125
    x = 136
    y = -640
    z = 232
  }
  {
    id = ENT_MAP["light"]
    x = 776
    y = 512
    z = 272
    light = 125
  }
  {
    id = ENT_MAP["light"]
    x = 552
    y = 600
    z = 256
    light = 125
  }
  {
    id = ENT_MAP["light"]
    x = 8
    y = 592
    z = 168
    light = 125
  }
  {
    id = ENT_MAP["item_artifact_invulnerability"]
    x = 648
    y = 8
    z = -8
  }
  {
    id = ENT_MAP["trigger_changelevel"]
    map = "dm6"
    link_id = "m7"
  }
  {
    id = ENT_MAP["info_intermission"]
    x = 112
    y = 552
    z = 232
  }
  {
    id = ENT_MAP["info_intermission"]
    x = -72
    y = 248
    z = 312
  }
  {
    id = "oblige_rtlight"
    x = 580
    y = -450
    z = 320
    light = 300
    style = 2
  }
}

all_brushes =
{
  {
    { m="solid", }
    { x=16.000, y=528.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-64.000, y=608.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-96.000, y=576.000, tex=TEX_MAP["AZ1_6"], }
    { x=-16.000, y=496.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=32.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=16.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=48.000, y=560.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-32.000, y=640.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-64.000, y=608.000, tex=TEX_MAP["AZ1_6"], }
    { x=16.000, y=528.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=48.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=32.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=80.000, y=592.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=0.000, y=672.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-32.000, y=640.000, tex=TEX_MAP["AZ1_6"], }
    { x=48.000, y=560.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=64.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=48.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=112.000, y=624.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=32.000, y=704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=0.000, y=672.000, tex=TEX_MAP["AZ1_6"], }
    { x=80.000, y=592.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=80.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=64.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=560.000, y=672.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=528.000, y=704.000, tex=TEX_MAP["AZ1_6"], }
    { x=448.000, y=624.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=480.000, y=592.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=112.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=96.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=592.000, y=640.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=560.000, y=672.000, tex=TEX_MAP["AZ1_6"], }
    { x=480.000, y=592.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=512.000, y=560.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=128.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=112.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=624.000, y=608.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=592.000, y=640.000, tex=TEX_MAP["AZ1_6"], }
    { x=512.000, y=560.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=544.000, y=528.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=144.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=128.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=656.000, y=576.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=624.000, y=608.000, tex=TEX_MAP["AZ1_6"], }
    { x=544.000, y=528.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=576.000, y=496.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=160.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=144.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=688.000, y=544.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=656.000, y=576.000, tex=TEX_MAP["AZ1_6"], }
    { x=576.000, y=496.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=608.000, y=464.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=176.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=160.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=608.000, y=472.000, tex=TEX_MAP["AFLOOR1_3"], }
    { x=608.000, y=608.000, tex=TEX_MAP["AFLOOR1_3"], }
    { x=-8.000, y=608.000, tex=TEX_MAP["AFLOOR1_3"], }
    { x=-8.000, y=472.000, tex=TEX_MAP["AFLOOR1_3"], }
    { t=-32.000, tex=TEX_MAP["AFLOOR1_3"], }
    { b=-48.000, tex=TEX_MAP["AFLOOR1_3"], }
  }
  {
    { m="solid", }
    { x=64.000, y=216.000, tex=TEX_MAP["AZ1_6"], }
    { x=64.000, y=400.000, tex=TEX_MAP["AZ1_6"], }
    { x=32.000, y=432.000, tex=TEX_MAP["AZ1_6"], }
    { x=-8.000, y=432.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-8.000, y=216.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=0.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=-16.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=120.000, y=216.000, tex=TEX_MAP["AZ1_6"], }
    { x=120.000, y=400.000, tex=TEX_MAP["AZ1_6"], }
    { x=48.000, y=472.000, tex=TEX_MAP["AZ1_6"], }
    { x=-8.000, y=472.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-8.000, y=216.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=-16.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=-32.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=80.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { x=0.000, y=672.000, tex=TEX_MAP["CITY2_3"], }
    { x=-32.000, y=640.000, tex=TEX_MAP["CITY2_3"], }
    { x=48.000, y=560.000, tex=TEX_MAP["CITY2_3"], }
    { t=224.000, tex=TEX_MAP["CITY2_3"], }
    { b=208.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=48.000, y=560.000, tex=TEX_MAP["CITY2_3"], }
    { x=-32.000, y=640.000, tex=TEX_MAP["CITY2_3"], }
    { x=-64.000, y=608.000, tex=TEX_MAP["CITY2_3"], }
    { x=16.000, y=528.000, tex=TEX_MAP["CITY2_3"], }
    { t=224.000, tex=TEX_MAP["CITY2_3"], }
    { b=208.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=592.000, y=640.000, tex=TEX_MAP["CITY3_4"], }
    { x=560.000, y=672.000, tex=TEX_MAP["CITY3_4"], }
    { x=480.000, y=592.000, tex=TEX_MAP["CITY3_4"], }
    { x=512.000, y=560.000, tex=TEX_MAP["CITY3_4"], }
    { t=304.000, tex=TEX_MAP["CITY3_4"], }
    { b=288.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=544.000, y=528.000, tex=TEX_MAP["CITY2_3"], }
    { x=624.000, y=608.000, tex=TEX_MAP["CITY2_3"], }
    { x=592.000, y=640.000, tex=TEX_MAP["CITY2_3"], }
    { x=512.000, y=560.000, tex=TEX_MAP["CITY2_3"], }
    { t=304.000, tex=TEX_MAP["CITY2_3"], }
    { b=288.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=576.000, y=496.000, tex=TEX_MAP["CITY2_3"], }
    { x=656.000, y=576.000, tex=TEX_MAP["CITY2_3"], }
    { x=624.000, y=608.000, tex=TEX_MAP["CITY2_3"], }
    { x=544.000, y=528.000, tex=TEX_MAP["CITY2_3"], }
    { t=304.000, tex=TEX_MAP["CITY2_3"], }
    { b=288.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=608.000, y=416.000, tex=TEX_MAP["AZ1_6"], }
    { x=-144.000, y=416.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-144.000, y=320.000, tex=TEX_MAP["AZ1_6"], }
    { x=608.000, y=320.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=176.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=264.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { x=264.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=624.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=592.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { t=208.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.44721, ny=0.00000, nz=0.89443 }, }
    { b=176.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.44721, ny=0.00000, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=344.000, y=592.000, tex=TEX_MAP["CITY2_6"], }
    { x=344.000, y=624.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=312.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=312.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { t=208.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.44721, ny=-0.00000, nz=0.89443 }, }
    { b=176.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.44721, ny=-0.00000, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=312.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { x=312.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=264.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=264.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { t=208.000, tex=TEX_MAP["CITY2_6"], }
    { b=192.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=248.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { x=248.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=624.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=592.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { t=160.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=248.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { x=248.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=624.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=592.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { t=192.000, tex=TEX_MAP["CITY2_6"], }
    { b=160.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=344.000, y=592.000, tex=TEX_MAP["CITY2_6"], }
    { x=344.000, y=624.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { t=128.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=344.000, y=592.000, tex=TEX_MAP["CITY2_6"], }
    { x=344.000, y=624.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { t=168.000, tex=TEX_MAP["CITY2_6"], }
    { b=128.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=344.000, y=592.000, tex=TEX_MAP["CITY2_6"], }
    { x=344.000, y=624.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=632.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { t=192.000, tex=TEX_MAP["CITY2_6"], }
    { b=168.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=336.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=624.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=624.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=584.000, tex=TEX_MAP["CITY2_6"], }
    { t=88.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=336.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { x=336.000, y=624.000, tex=TEX_MAP["CITY2_3"], }
    { x=240.000, y=624.000, tex=TEX_MAP["CITY2_3"], }
    { x=240.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=192.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=112.000, y=624.000, tex=TEX_MAP["CITY2_3"], }
    { x=-24.000, y=488.000, tex=TEX_MAP["CITY2_3"], }
    { x=-0.000, y=472.000, tex=TEX_MAP["CITY2_3"], }
    { x=120.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=0.000, y=432.000, tex=TEX_MAP["CITY2_3"], }
    { x=0.000, y=472.000, tex=TEX_MAP["CITY2_3"], }
    { x=-24.000, y=488.000, tex=TEX_MAP["CITY2_3"], }
    { x=-24.000, y=432.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=608.000, y=464.000, tex=TEX_MAP["CITY2_3"], }
    { x=688.000, y=544.000, tex=TEX_MAP["CITY2_3"], }
    { x=656.000, y=576.000, tex=TEX_MAP["CITY2_3"], }
    { x=576.000, y=496.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=288.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=464.000, y=800.000, tex=TEX_MAP["CITY2_3"], }
    { x=432.000, y=800.000, tex=TEX_MAP["CITY2_3"], }
    { x=688.000, y=544.000, tex=TEX_MAP["CITY2_3"], }
    { x=720.000, y=544.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=960.000, y=560.000, tex=TEX_MAP["CITY2_3"], }
    { x=704.000, y=560.000, tex=TEX_MAP["CITY2_3"], }
    { x=720.000, y=544.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=544.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=-56.000, y=-456.000, tex=TEX_MAP["AZ1_6"], }
    { x=-56.000, y=320.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-144.000, y=320.000, tex=TEX_MAP["AZ1_6"], }
    { x=-144.000, y=-456.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=176.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=-136.000, y=-816.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-56.000, y=-816.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-56.000, y=-456.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-136.000, y=-456.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=176.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=-144.000, y=-504.000, tex=TEX_MAP["AZ1_6"], }
    { x=-144.000, y=-816.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-136.000, y=-816.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-136.000, y=-504.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=176.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=-48.000, y=-816.000, tex=TEX_MAP["AZ1_6"], }
    { x=-48.000, y=-504.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-56.000, y=-504.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-56.000, y=-816.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=176.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=240.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { x=240.000, y=216.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=216.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-64.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=16.000, y=528.000, tex=TEX_MAP["CITY2_3"], }
    { x=-64.000, y=608.000, tex=TEX_MAP["CITY2_3"], }
    { x=-96.000, y=576.000, tex=TEX_MAP["CITY2_3"], }
    { x=-16.000, y=496.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=160.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=128.000, y=800.000, tex=TEX_MAP["CITY2_3"], }
    { x=96.000, y=800.000, tex=TEX_MAP["CITY2_3"], }
    { x=-184.000, y=520.000, tex=TEX_MAP["CITY2_3"], }
    { x=-184.000, y=488.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=-8.000, y=-464.000, tex=TEX_MAP["AZ1_6"], }
    { x=-8.000, y=608.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-184.000, y=608.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-184.000, y=-464.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=16.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=0.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=-184.000, y=520.000, tex=TEX_MAP["CITY2_3"], }
    { x=-216.000, y=520.000, tex=TEX_MAP["CITY2_3"], }
    { x=-216.000, y=-832.000, tex=TEX_MAP["CITY2_3"], }
    { x=-184.000, y=-832.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=248.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { x=248.000, y=224.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=224.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=216.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { t=-40.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=248.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { x=248.000, y=224.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=224.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=216.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { t=-24.000, tex=TEX_MAP["CITY2_6"], }
    { b=-40.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=344.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { x=344.000, y=216.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=224.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=224.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { t=-40.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=344.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { x=344.000, y=216.000, tex=TEX_MAP["CITY2_6"], }
    { x=336.000, y=224.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=224.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { t=-24.000, tex=TEX_MAP["CITY2_6"], }
    { b=-40.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=336.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { x=336.000, y=216.000, tex=TEX_MAP["CITY2_3"], }
    { x=240.000, y=216.000, tex=TEX_MAP["CITY2_3"], }
    { x=240.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=200.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=616.000, y=344.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=344.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=320.000, tex=TEX_MAP["CITY2_6"], }
    { x=576.000, y=312.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=312.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=320.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=272.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=608.000, y=424.000, tex=TEX_MAP["CITY2_6"], }
    { x=576.000, y=424.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=416.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=392.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=392.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=416.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.44721, nz=0.89443 }, }
    { b=272.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=616.000, y=392.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=392.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=344.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=344.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], }
    { b=288.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=616.000, y=416.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=416.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=320.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=320.000, tex=TEX_MAP["CITY2_6"], }
    { t=184.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=608.000, y=424.000, tex=TEX_MAP["CITY2_6"], }
    { x=576.000, y=424.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=416.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=408.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=408.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=416.000, tex=TEX_MAP["CITY2_6"], }
    { t=248.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=608.000, y=424.000, tex=TEX_MAP["CITY2_6"], }
    { x=576.000, y=424.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=416.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=408.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=408.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=416.000, tex=TEX_MAP["CITY2_6"], }
    { t=288.000, tex=TEX_MAP["CITY2_6"], }
    { b=248.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=616.000, y=328.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=328.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=320.000, tex=TEX_MAP["CITY2_6"], }
    { x=576.000, y=312.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=312.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=320.000, tex=TEX_MAP["CITY2_6"], }
    { t=248.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=616.000, y=328.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=328.000, tex=TEX_MAP["CITY2_6"], }
    { x=568.000, y=320.000, tex=TEX_MAP["CITY2_6"], }
    { x=576.000, y=312.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=312.000, tex=TEX_MAP["CITY2_6"], }
    { x=616.000, y=320.000, tex=TEX_MAP["CITY2_6"], }
    { t=288.000, tex=TEX_MAP["CITY2_6"], }
    { b=248.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=32.000, y=-248.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-248.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-280.000, tex=TEX_MAP["CITY2_6"], }
    { x=24.000, y=-280.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=272.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=24.000, y=-168.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-168.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-176.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-200.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-200.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-176.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.44721, nz=0.89443 }, }
    { b=272.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=32.000, y=-200.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-200.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-248.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-248.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], }
    { b=288.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=24.000, y=-168.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-168.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-176.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-184.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-184.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-176.000, tex=TEX_MAP["CITY2_6"], }
    { t=248.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=24.000, y=-168.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-168.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-176.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-184.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-184.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-176.000, tex=TEX_MAP["CITY2_6"], }
    { t=288.000, tex=TEX_MAP["CITY2_6"], }
    { b=248.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=32.000, y=-264.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-264.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-280.000, tex=TEX_MAP["CITY2_6"], }
    { x=24.000, y=-280.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { t=248.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=32.000, y=-264.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-264.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-280.000, tex=TEX_MAP["CITY2_6"], }
    { x=24.000, y=-280.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { t=288.000, tex=TEX_MAP["CITY2_6"], }
    { b=248.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=24.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-280.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=-280.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=288.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=32.000, y=-176.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-176.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { t=184.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=608.000, y=216.000, tex=TEX_MAP["CITY2_3"], }
    { x=608.000, y=328.000, tex=TEX_MAP["CITY2_6"], }
    { x=576.000, y=328.000, tex=TEX_MAP["CITY2_3"], }
    { x=576.000, y=216.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=608.000, y=416.000, tex=TEX_MAP["CITY2_3"], }
    { x=608.000, y=464.000, tex=TEX_MAP["CITY2_3"], }
    { x=576.000, y=464.000, tex=TEX_MAP["CITY2_3"], }
    { x=576.000, y=416.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=608.000, y=424.000, tex=TEX_MAP["CITY2_3"], }
    { x=576.000, y=424.000, tex=TEX_MAP["CITY2_3"], }
    { x=576.000, y=320.000, tex=TEX_MAP["CITY2_3"], }
    { x=608.000, y=320.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=288.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=480.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { x=448.000, y=624.000, tex=TEX_MAP["CITY2_3"], }
    { x=336.000, y=624.000, tex=TEX_MAP["CITY2_3"], }
    { x=336.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=608.000, y=464.000, tex=TEX_MAP["CITY2_3"], }
    { x=480.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { x=448.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { x=576.000, y=464.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=336.000, y=184.000, tex=TEX_MAP["AZ1_6"], }
    { x=336.000, y=624.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=240.000, y=624.000, tex=TEX_MAP["AZ1_6"], }
    { x=240.000, y=184.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=96.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=80.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=1152.000, y=-368.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=232.000, y=-368.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=232.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=96.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=80.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=-152.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-184.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-184.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=-152.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=16.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=-120.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-136.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-136.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=-120.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=312.000, tex=TEX_MAP["CITY2_3"], slope={ nx=0.44721, ny=0.00000, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=-56.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-72.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-72.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=-56.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=312.000, tex=TEX_MAP["CITY2_3"], slope={ nx=-0.44721, ny=0.00000, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=-72.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-120.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-120.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=-72.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=320.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=-136.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-152.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-152.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=-136.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=304.000, tex=TEX_MAP["CITY2_3"], slope={ nx=0.44721, ny=0.00000, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=-8.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-40.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-40.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-152.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=-40.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-56.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-56.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=-40.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=304.000, tex=TEX_MAP["CITY2_3"], slope={ nx=-0.44721, ny=0.00000, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=232.000, y=-312.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-280.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-280.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-312.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=16.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=8.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-176.000, tex=TEX_MAP["CITY2_3"], }
    { x=8.000, y=-176.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=24.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=24.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=80.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=24.000, y=-176.000, tex=TEX_MAP["AZ1_6"], }
    { x=-56.000, y=-176.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-56.000, y=-272.000, tex=TEX_MAP["AZ1_6"], }
    { x=24.000, y=-272.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=176.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-280.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-168.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=24.000, y=-168.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=24.000, y=-280.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=96.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=960.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=216.000, tex=TEX_MAP["CITY2_3"], }
    { x=336.000, y=216.000, tex=TEX_MAP["CITY2_3"], }
    { x=336.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-64.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=960.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=24.000, tex=TEX_MAP["CITY2_3"], }
    { x=344.000, y=24.000, tex=TEX_MAP["CITY2_3"], }
    { x=344.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=80.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=552.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=696.000, y=552.000, tex=TEX_MAP["AZ1_6"], }
    { x=608.000, y=464.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=608.000, y=184.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=832.000, y=184.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=176.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-280.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=832.000, y=-168.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=232.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-280.000, tex=TEX_MAP["CITY2_3"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=80.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-280.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=320.000, y=-280.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=320.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=832.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=96.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=80.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=992.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { x=992.000, y=560.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=560.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=224.000, y=832.000, tex=TEX_MAP["CITY2_3"], }
    { x=96.000, y=832.000, tex=TEX_MAP["CITY2_3"], }
    { x=96.000, y=800.000, tex=TEX_MAP["CITY2_3"], }
    { x=224.000, y=800.000, tex=TEX_MAP["COP1_2"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=112.000, y=624.000, tex=TEX_MAP["CITY2_3"], }
    { x=32.000, y=704.000, tex=TEX_MAP["CITY2_3"], }
    { x=0.000, y=672.000, tex=TEX_MAP["CITY2_3"], }
    { x=80.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { t=288.000, tex=TEX_MAP["CITY2_3"], }
    { b=208.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=240.000, y=624.000, tex=TEX_MAP["CITY2_3"], }
    { x=112.000, y=624.000, tex=TEX_MAP["CITY2_3"], }
    { x=120.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { x=240.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=560.000, y=672.000, tex=TEX_MAP["CITY2_3"], }
    { x=528.000, y=704.000, tex=TEX_MAP["CITY2_3"], }
    { x=448.000, y=624.000, tex=TEX_MAP["CITY2_3"], }
    { x=480.000, y=592.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=224.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=48.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { x=48.000, y=608.000, tex=TEX_MAP["CITY3_4"], }
    { x=-184.000, y=608.000, tex=TEX_MAP["CITY3_4"], }
    { x=-184.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=-64.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=48.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=48.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { x=-64.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=-72.000, y=-584.000, tex=TEX_MAP["SKY4"], }
    { x=-136.000, y=-584.000, tex=TEX_MAP["SKY4"], }
    { x=-136.000, y=-704.000, tex=TEX_MAP["SKY4"], }
    { x=-72.000, y=-704.000, tex=TEX_MAP["SKY4"], }
    { t=368.000, tex=TEX_MAP["SKY4"], }
    { b=352.000, tex=TEX_MAP["SKY4"], }
  }
  {
    { m="solid", }
    { x=-144.000, y=-584.000, tex=TEX_MAP["CITY3_4"], }
    { x=-184.000, y=-584.000, tex=TEX_MAP["CITY3_4"], }
    { x=-184.000, y=-704.000, tex=TEX_MAP["CITY3_4"], }
    { x=-144.000, y=-704.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=-184.000, y=-712.000, tex=TEX_MAP["CITY3_4"], }
    { x=-184.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=-64.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=-64.000, y=-712.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=-144.000, y=-704.000, tex=TEX_MAP["CITY3_4"], }
    { x=-184.000, y=-704.000, tex=TEX_MAP["CITY3_4"], }
    { x=-184.000, y=-712.000, tex=TEX_MAP["CITY3_4"], }
    { x=-144.000, y=-712.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=-144.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { x=-184.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { x=-184.000, y=-584.000, tex=TEX_MAP["CITY3_4"], }
    { x=-144.000, y=-584.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=344.000, y=-184.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=608.000, tex=TEX_MAP["CITY3_4"], }
    { x=48.000, y=608.000, tex=TEX_MAP["CITY3_4"], }
    { x=48.000, y=-184.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=176.000, y=-256.000, tex=TEX_MAP["SKY4"], }
    { x=176.000, y=-192.000, tex=TEX_MAP["SKY4"], }
    { x=56.000, y=-192.000, tex=TEX_MAP["SKY4"], }
    { x=56.000, y=-256.000, tex=TEX_MAP["SKY4"], }
    { t=368.000, tex=TEX_MAP["SKY4"], }
    { b=352.000, tex=TEX_MAP["SKY4"], }
  }
  {
    { m="solid", }
    { x=176.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { x=176.000, y=-264.000, tex=TEX_MAP["CITY3_4"], }
    { x=56.000, y=-264.000, tex=TEX_MAP["CITY3_4"], }
    { x=56.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=176.000, y=-584.000, tex=TEX_MAP["CITY3_4"], }
    { x=176.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { x=128.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { x=128.000, y=-584.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=176.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=176.000, y=-584.000, tex=TEX_MAP["CITY3_4"], }
    { x=128.000, y=-584.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=56.000, y=-712.000, tex=TEX_MAP["CITY3_4"], }
    { x=56.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=128.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=128.000, y=-712.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=120.000, y=-584.000, tex=TEX_MAP["SKY4"], }
    { x=56.000, y=-584.000, tex=TEX_MAP["SKY4"], }
    { x=56.000, y=-704.000, tex=TEX_MAP["SKY4"], }
    { x=120.000, y=-704.000, tex=TEX_MAP["SKY4"], }
    { t=368.000, tex=TEX_MAP["SKY4"], }
    { b=352.000, tex=TEX_MAP["SKY4"], }
  }
  {
    { m="solid", }
    { x=184.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=-184.000, tex=TEX_MAP["CITY3_4"], }
    { x=184.000, y=-184.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=176.000, y=-264.000, tex=TEX_MAP["CITY3_4"], }
    { x=176.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=184.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=184.000, y=-264.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=48.000, y=-712.000, tex=TEX_MAP["CITY3_4"], }
    { x=48.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=56.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=56.000, y=-712.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=56.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { x=56.000, y=-264.000, tex=TEX_MAP["CITY3_4"], }
    { x=48.000, y=-264.000, tex=TEX_MAP["CITY3_4"], }
    { x=48.000, y=-576.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=960.000, y=440.000, tex=TEX_MAP["CITY3_4"], }
    { x=960.000, y=608.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=608.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=440.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=960.000, y=432.000, tex=TEX_MAP["CITY3_4"], }
    { x=960.000, y=440.000, tex=TEX_MAP["CITY3_4"], }
    { x=832.000, y=440.000, tex=TEX_MAP["CITY3_4"], }
    { x=832.000, y=432.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=752.000, y=440.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=440.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=432.000, tex=TEX_MAP["CITY3_4"], }
    { x=752.000, y=432.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=960.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=960.000, y=560.000, tex=TEX_MAP["CITY3_4"], }
    { x=832.000, y=560.000, tex=TEX_MAP["CITY3_4"], }
    { x=832.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=344.000, y=304.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=-360.000, tex=TEX_MAP["CITY3_4"], }
    { x=832.000, y=-360.000, tex=TEX_MAP["CITY3_4"], }
    { x=832.000, y=304.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=752.000, y=312.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=312.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=304.000, tex=TEX_MAP["CITY3_4"], }
    { x=752.000, y=304.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=824.000, y=432.000, tex=TEX_MAP["SKY4"], }
    { x=760.000, y=432.000, tex=TEX_MAP["SKY4"], }
    { x=760.000, y=312.000, tex=TEX_MAP["SKY4"], }
    { x=824.000, y=312.000, tex=TEX_MAP["SKY4"], }
    { t=368.000, tex=TEX_MAP["SKY4"], }
    { b=352.000, tex=TEX_MAP["SKY4"], }
  }
  {
    { m="solid", }
    { x=752.000, y=432.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=432.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=312.000, tex=TEX_MAP["CITY3_4"], }
    { x=752.000, y=312.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-896.000, tex=TEX_MAP["CITY3_4"], }
    { x=1152.000, y=-360.000, tex=TEX_MAP["CITY3_4"], }
    { x=832.000, y=-360.000, tex=TEX_MAP["CITY3_4"], }
    { x=832.000, y=-896.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=808.000, y=-384.000, tex=TEX_MAP["SKY4"], }
    { x=368.000, y=-384.000, tex=TEX_MAP["SKY4"], }
    { x=368.000, y=-496.000, tex=TEX_MAP["SKY4"], }
    { x=808.000, y=-496.000, tex=TEX_MAP["SKY4"], }
    { t=392.000, tex=TEX_MAP["SKY4"], }
    { b=384.000, tex=TEX_MAP["SKY4"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=832.000, y=-488.000, tex=TEX_MAP["CITY2_3"], }
    { x=808.000, y=-488.000, tex=TEX_MAP["CITY2_3"], }
    { x=808.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=336.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=344.000, y=-520.000, tex=TEX_MAP["CITY3_4"], }
    { x=344.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=832.000, y=-832.000, tex=TEX_MAP["CITY3_4"], }
    { x=832.000, y=-520.000, tex=TEX_MAP["CITY3_4"], }
    { t=352.000, tex=TEX_MAP["CITY3_4"], }
    { b=336.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=472.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { x=472.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=408.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=408.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { t=128.000, tex=TEX_MAP["METAL2_4"], }
    { b=96.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=456.000, y=-336.000, tex=TEX_MAP["METAL2_4"], }
    { x=456.000, y=-296.000, tex=TEX_MAP["METAL2_4"], }
    { x=424.000, y=-296.000, tex=TEX_MAP["METAL2_4"], }
    { x=424.000, y=-336.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=128.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=472.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { x=472.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=408.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=408.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=304.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=616.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { x=616.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=552.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=552.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=304.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=600.000, y=-336.000, tex=TEX_MAP["METAL2_4"], }
    { x=600.000, y=-296.000, tex=TEX_MAP["METAL2_4"], }
    { x=568.000, y=-296.000, tex=TEX_MAP["METAL2_4"], }
    { x=568.000, y=-336.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=128.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=616.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { x=616.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=552.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=552.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { t=128.000, tex=TEX_MAP["METAL2_4"], }
    { b=96.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=768.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { x=768.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=704.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=704.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { t=128.000, tex=TEX_MAP["METAL2_4"], }
    { b=96.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=752.000, y=-336.000, tex=TEX_MAP["METAL2_4"], }
    { x=752.000, y=-296.000, tex=TEX_MAP["METAL2_4"], }
    { x=720.000, y=-296.000, tex=TEX_MAP["METAL2_4"], }
    { x=720.000, y=-336.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=128.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=768.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { x=768.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=704.000, y=-280.000, tex=TEX_MAP["METAL2_4"], }
    { x=704.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=304.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-648.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=832.000, y=-448.000, tex=TEX_MAP["AZ1_6"], }
    { x=344.000, y=-448.000, tex=TEX_MAP["AZ1_6"], }
    { x=344.000, y=-648.000, tex=TEX_MAP["AZ1_6"], }
    { t=112.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=96.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-608.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=832.000, y=-488.000, tex=TEX_MAP["AZ1_6"], }
    { x=376.000, y=-488.000, tex=TEX_MAP["AZ1_6"], }
    { x=376.000, y=-608.000, tex=TEX_MAP["AZ1_6"], }
    { t=128.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=96.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=728.000, y=-560.000, tex=TEX_MAP["CITY2_3"], }
    { x=728.000, y=-536.000, tex=TEX_MAP["CITY2_3"], }
    { x=704.000, y=-528.000, tex=TEX_MAP["CITY2_3"], }
    { x=704.000, y=-552.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=744.000, y=-576.000, tex=TEX_MAP["CITY2_3"], }
    { x=744.000, y=-552.000, tex=TEX_MAP["CITY2_3"], }
    { x=728.000, y=-536.000, tex=TEX_MAP["CITY2_3"], }
    { x=728.000, y=-560.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=760.000, y=-600.000, tex=TEX_MAP["CITY2_3"], }
    { x=760.000, y=-576.000, tex=TEX_MAP["CITY2_3"], }
    { x=744.000, y=-552.000, tex=TEX_MAP["CITY2_3"], }
    { x=744.000, y=-576.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { x=832.000, y=-576.000, tex=TEX_MAP["CITY2_3"], }
    { x=704.000, y=-576.000, tex=TEX_MAP["CITY2_3"], }
    { x=704.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=504.000, y=-712.000, tex=TEX_MAP["CITY2_3"], }
    { x=504.000, y=-600.000, tex=TEX_MAP["CITY2_3"], }
    { x=472.000, y=-600.000, tex=TEX_MAP["CITY2_3"], }
    { x=472.000, y=-712.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=488.000, y=-576.000, tex=TEX_MAP["CITY2_3"], }
    { x=488.000, y=-552.000, tex=TEX_MAP["CITY2_3"], }
    { x=472.000, y=-576.000, tex=TEX_MAP["CITY2_3"], }
    { x=472.000, y=-600.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=504.000, y=-560.000, tex=TEX_MAP["CITY2_3"], }
    { x=504.000, y=-536.000, tex=TEX_MAP["CITY2_3"], }
    { x=488.000, y=-552.000, tex=TEX_MAP["CITY2_3"], }
    { x=488.000, y=-576.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-552.000, tex=TEX_MAP["CITY2_3"], }
    { x=528.000, y=-528.000, tex=TEX_MAP["CITY2_3"], }
    { x=504.000, y=-536.000, tex=TEX_MAP["CITY2_3"], }
    { x=504.000, y=-560.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=552.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { x=552.000, y=-528.000, tex=TEX_MAP["CITY2_3"], }
    { x=528.000, y=-528.000, tex=TEX_MAP["CITY2_3"], }
    { x=528.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { t=336.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=704.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { x=704.000, y=-528.000, tex=TEX_MAP["CITY2_3"], }
    { x=680.000, y=-528.000, tex=TEX_MAP["CITY2_3"], }
    { x=680.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { t=336.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=680.000, y=-576.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=680.000, y=-536.000, tex=TEX_MAP["AZ1_6"], }
    { x=552.000, y=-536.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=552.000, y=-576.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=144.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=128.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=680.000, y=-616.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=680.000, y=-576.000, tex=TEX_MAP["AZ1_6"], }
    { x=552.000, y=-576.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=552.000, y=-616.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=160.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=144.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=680.000, y=-656.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=680.000, y=-616.000, tex=TEX_MAP["AZ1_6"], }
    { x=552.000, y=-616.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=552.000, y=-656.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=176.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=160.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=680.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=680.000, y=-656.000, tex=TEX_MAP["AZ1_6"], }
    { x=552.000, y=-656.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=552.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=176.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=-72.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-72.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-120.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-120.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=144.000, tex=TEX_MAP["CITY2_6"], }
    { b=128.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-56.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-72.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-72.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-56.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=144.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.44721, ny=-0.00000, nz=0.89443 }, }
    { b=120.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.44721, ny=-0.00000, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=-120.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-120.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-136.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-136.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=144.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.44721, ny=0.00000, nz=0.89443 }, }
    { b=120.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.44721, ny=0.00000, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=32.000, y=-344.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-328.000, tex=TEX_MAP["CITY2_6"], }
    { x=24.000, y=-320.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-320.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-328.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-344.000, tex=TEX_MAP["CITY2_6"], }
    { t=144.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=116.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=32.000, y=-416.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-392.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-392.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-416.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-424.000, tex=TEX_MAP["CITY2_6"], }
    { x=24.000, y=-424.000, tex=TEX_MAP["CITY2_6"], }
    { t=144.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=112.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=32.000, y=-392.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-344.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-344.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-392.000, tex=TEX_MAP["CITY2_6"], }
    { t=144.000, tex=TEX_MAP["CITY2_6"], }
    { b=128.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=32.000, y=-416.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-408.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-408.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-416.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-424.000, tex=TEX_MAP["CITY2_6"], }
    { x=24.000, y=-424.000, tex=TEX_MAP["CITY2_6"], }
    { t=104.000, tex=TEX_MAP["CITY2_6"], }
    { b=16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=32.000, y=-416.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-408.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-408.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-416.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-424.000, tex=TEX_MAP["CITY2_6"], }
    { x=24.000, y=-424.000, tex=TEX_MAP["CITY2_6"], }
    { t=128.000, tex=TEX_MAP["CITY2_6"], }
    { b=104.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=24.000, y=-432.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=-416.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-416.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-432.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=128.000, tex=TEX_MAP["CITY2_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=-8.000, y=-424.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=-424.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-128.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=24.000, y=-336.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=-312.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-312.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-336.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=124.000, tex=TEX_MAP["CITY2_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=24.000, y=-400.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=-352.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-352.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-400.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=144.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=24.000, y=-416.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=-400.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-400.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-416.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=136.000, tex=TEX_MAP["CITY2_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=24.000, y=-352.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=-336.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-336.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-352.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=136.000, tex=TEX_MAP["CITY2_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=184.000, y=-464.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=184.000, y=-312.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-8.000, y=-312.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-8.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { t=16.000, tex=TEX_MAP["AFLOOR1_4"], }
    { b=0.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-536.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-456.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-456.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-536.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-136.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-616.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-568.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-568.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-616.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-648.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-648.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-136.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-648.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-616.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-616.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-648.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-16.000, tex=TEX_MAP["CITY2_3"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=232.000, y=-568.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-536.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-536.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-568.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-16.000, tex=TEX_MAP["CITY2_3"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=184.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-456.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-456.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { t=32.000, tex=TEX_MAP["CITY2_3"], }
    { b=-136.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=-32.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-32.000, y=-464.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-184.000, y=-464.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-184.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=16.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=0.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=-24.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=-24.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=-32.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=-32.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { t=32.000, tex=TEX_MAP["CITY2_3"], }
    { b=-136.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=160.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=112.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=112.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=80.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=64.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=112.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=112.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=64.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=64.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=64.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=48.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=64.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=64.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=16.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=16.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=48.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=32.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=16.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=16.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-32.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-32.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=32.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=16.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=232.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=160.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=160.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=96.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=80.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=16.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { x=16.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=-32.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=-32.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { t=48.000, tex=TEX_MAP["CITY2_3"], }
    { b=-136.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=64.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { x=64.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=16.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=16.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { t=64.000, tex=TEX_MAP["CITY2_3"], }
    { b=-136.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=112.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { x=112.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=64.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=64.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { t=80.000, tex=TEX_MAP["CITY2_3"], }
    { b=-136.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=160.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { x=160.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=112.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=112.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { t=96.000, tex=TEX_MAP["CITY2_3"], }
    { b=-136.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=184.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=160.000, y=-696.000, tex=TEX_MAP["CITY2_3"], }
    { x=160.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { t=112.000, tex=TEX_MAP["CITY2_3"], }
    { b=-136.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=960.000, y=-848.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=-832.000, tex=TEX_MAP["CITY2_3"], }
    { x=-216.000, y=-832.000, tex=TEX_MAP["CITY2_3"], }
    { x=-216.000, y=-848.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=504.000, y=-816.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=504.000, y=-720.000, tex=TEX_MAP["AZ1_6"], }
    { x=-48.000, y=-720.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=-48.000, y=-816.000, tex=TEX_MAP["AZ1_6"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=176.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-744.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=504.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=472.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-744.000, tex=TEX_MAP["CITY2_6"], }
    { t=320.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=288.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=512.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-792.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-792.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=472.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { x=504.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { t=320.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=288.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=512.000, y=-792.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-744.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-744.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-792.000, tex=TEX_MAP["CITY2_6"], }
    { t=320.000, tex=TEX_MAP["CITY2_6"], }
    { b=304.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-728.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=504.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=472.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-728.000, tex=TEX_MAP["CITY2_6"], }
    { t=280.000, tex=TEX_MAP["CITY2_6"], }
    { b=96.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-728.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=504.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=472.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-728.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], }
    { b=280.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-808.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-808.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=472.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { x=504.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { t=280.000, tex=TEX_MAP["CITY2_6"], }
    { b=96.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-808.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-808.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=472.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { x=504.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], }
    { b=280.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=504.000, y=-832.000, tex=TEX_MAP["CITY2_3"], }
    { x=504.000, y=-824.000, tex=TEX_MAP["CITY2_3"], }
    { x=472.000, y=-824.000, tex=TEX_MAP["CITY2_3"], }
    { x=472.000, y=-832.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=832.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=504.000, y=-704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=504.000, y=-832.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=176.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=512.000, y=-808.000, tex=TEX_MAP["CITY2_6"], }
    { x=512.000, y=-728.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-728.000, tex=TEX_MAP["CITY2_6"], }
    { x=464.000, y=-808.000, tex=TEX_MAP["CITY2_6"], }
    { t=184.000, tex=TEX_MAP["CITY2_6"], }
    { b=96.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-40.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=-40.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-56.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-56.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=272.000, tex=TEX_MAP["CITY2_6"], }
    { b=144.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-40.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=-40.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-56.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-56.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=296.000, tex=TEX_MAP["CITY2_6"], }
    { b=272.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-40.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=-40.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-56.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-56.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=104.000, tex=TEX_MAP["CITY2_6"], }
    { b=16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-40.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=-40.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-56.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-56.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-48.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=144.000, tex=TEX_MAP["CITY2_6"], }
    { b=104.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-136.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-136.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-144.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-152.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=-152.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=-144.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=272.000, tex=TEX_MAP["CITY2_6"], }
    { b=144.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-136.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-136.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-144.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-152.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=-152.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=-144.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=296.000, tex=TEX_MAP["CITY2_6"], }
    { b=272.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-136.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-136.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-144.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-152.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=-152.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=-144.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=104.000, tex=TEX_MAP["CITY2_6"], }
    { b=16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-136.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-136.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-144.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-152.000, y=-464.000, tex=TEX_MAP["CITY2_6"], }
    { x=-152.000, y=-496.000, tex=TEX_MAP["CITY2_6"], }
    { x=-144.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=144.000, tex=TEX_MAP["CITY2_6"], }
    { b=104.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=-72.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { x=-72.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-120.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=-120.000, y=-504.000, tex=TEX_MAP["CITY2_6"], }
    { t=320.000, tex=TEX_MAP["CITY2_6"], }
    { b=304.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:1705 @@@@
--    @@@@ FIX BRUSH @ line:1712 @@@@
--    @@@@ FIX BRUSH @ line:1723 @@@@
--    @@@@ FIX BRUSH @ line:1730 @@@@
  {
    { m="solid", }
    { x=-56.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { x=-56.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-136.000, y=-464.000, tex=TEX_MAP["CITY2_3"], }
    { x=-136.000, y=-496.000, tex=TEX_MAP["CITY2_3"], }
    { t=184.000, tex=TEX_MAP["CITY2_3"], }
    { b=128.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=504.000, y=-824.000, tex=TEX_MAP["CITY2_3"], }
    { x=504.000, y=-712.000, tex=TEX_MAP["CITY2_3"], }
    { x=472.000, y=-712.000, tex=TEX_MAP["CITY2_3"], }
    { x=472.000, y=-824.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=304.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=528.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { x=528.000, y=-680.000, tex=TEX_MAP["CITY2_3"], }
    { x=504.000, y=-680.000, tex=TEX_MAP["CITY2_3"], }
    { x=504.000, y=-704.000, tex=TEX_MAP["CITY2_3"], }
    { t=336.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=1912.000, y=-1744.000, tex=TEX_MAP["CITY2_3"], }
    { x=1912.000, y=-1560.000, tex=TEX_MAP["CITY2_3"], }
    { x=1824.000, y=-1560.000, tex=TEX_MAP["CITY2_3"], }
    { x=1824.000, y=-1744.000, tex=TEX_MAP["CITY2_3"], }
    { t=96.000, tex=TEX_MAP["CITY2_3"], }
    { b=80.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-896.000, tex=TEX_MAP["CITY2_3"], }
    { x=1152.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { x=832.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { x=832.000, y=-896.000, tex=TEX_MAP["CITY2_3"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=-64.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=528.000, y=704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=528.000, y=1056.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=32.000, y=1056.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=32.000, y=704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=96.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=80.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=528.000, y=624.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=528.000, y=704.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=32.000, y=704.000, tex=TEX_MAP["AZ1_6"], }
    { x=112.000, y=624.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=96.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=80.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=528.000, y=704.000, tex=TEX_MAP["CITY3_4"], }
    { x=32.000, y=704.000, tex=TEX_MAP["CITY3_4"], }
    { x=112.000, y=624.000, tex=TEX_MAP["CITY3_4"], }
    { x=448.000, y=624.000, tex=TEX_MAP["CITY3_4"], }
    { t=288.000, tex=TEX_MAP["CITY3_4"], }
    { b=272.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=528.000, y=704.000, tex=TEX_MAP["CITY3_4"], }
    { x=528.000, y=800.000, tex=TEX_MAP["CITY3_4"], }
    { x=32.000, y=800.000, tex=TEX_MAP["CITY3_4"], }
    { x=32.000, y=704.000, tex=TEX_MAP["CITY3_4"], }
    { t=288.000, tex=TEX_MAP["CITY3_4"], }
    { b=272.000, tex=TEX_MAP["CITY3_4"], }
  }
  {
    { m="solid", }
    { x=144.000, y=216.000, tex=TEX_MAP["AFLOOR1_3"], }
    { x=144.000, y=472.000, tex=TEX_MAP["AFLOOR1_3"], }
    { x=48.000, y=472.000, tex=TEX_MAP["AFLOOR1_3"], }
    { x=48.000, y=216.000, tex=TEX_MAP["AFLOOR1_3"], }
    { t=-32.000, tex=TEX_MAP["AFLOOR1_3"], }
    { b=-48.000, tex=TEX_MAP["AFLOOR1_3"], }
  }
  {
    { m="solid", }
    { x=576.000, y=216.000, tex=TEX_MAP["AFLOOR1_3"], }
    { x=576.000, y=472.000, tex=TEX_MAP["AFLOOR1_3"], }
    { x=432.000, y=472.000, tex=TEX_MAP["AFLOOR1_3"], }
    { x=432.000, y=216.000, tex=TEX_MAP["AFLOOR1_3"], }
    { t=-32.000, tex=TEX_MAP["AFLOOR1_3"], }
    { b=-48.000, tex=TEX_MAP["AFLOOR1_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=176.000, tex=TEX_MAP["CITY4_1"], }
    { x=384.000, y=472.000, tex=TEX_MAP["CITY4_1"], }
    { x=344.000, y=472.000, tex=TEX_MAP["CITY4_1"], }
    { x=344.000, y=176.000, tex=TEX_MAP["CITY4_1"], }
    { t=-48.000, tex=TEX_MAP["CITY4_1"], }
    { b=-136.000, tex=TEX_MAP["CITY4_1"], }
  }
  {
    { m="solid", }
    { x=312.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { x=312.000, y=224.000, tex=TEX_MAP["CITY2_6"], }
    { x=264.000, y=224.000, tex=TEX_MAP["CITY2_6"], }
    { x=264.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { t=0.000, tex=TEX_MAP["CITY2_6"], }
    { b=-16.000, tex=TEX_MAP["CITY2_6"], }
  }
--    @@@@ FIX BRUSH @ line:1845 @@@@
--    @@@@ FIX BRUSH @ line:1852 @@@@
--    @@@@ FIX BRUSH @ line:1862 @@@@
--    @@@@ FIX BRUSH @ line:1869 @@@@
  {
    { m="solid", }
    { x=232.000, y=176.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=472.000, tex=TEX_MAP["CITY4_1"], }
    { x=192.000, y=472.000, tex=TEX_MAP["CITY4_1"], }
    { x=192.000, y=176.000, tex=TEX_MAP["CITY4_1"], }
    { t=-48.000, tex=TEX_MAP["CITY4_1"], }
    { b=-136.000, tex=TEX_MAP["CITY4_1"], }
  }
  {
    { m="solid", }
    { x=344.000, y=384.000, tex=TEX_MAP["CITY4_1"], }
    { x=344.000, y=416.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=416.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=384.000, tex=TEX_MAP["CITY4_1"], }
    { t=-56.000, tex=TEX_MAP["CITY4_1"], }
    { b=-72.000, tex=TEX_MAP["CITY4_1"], }
  }
  {
    { m="solid", }
    { x=344.000, y=352.000, tex=TEX_MAP["CITY4_1"], }
    { x=344.000, y=384.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=384.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=352.000, tex=TEX_MAP["CITY4_1"], }
    { t=-72.000, tex=TEX_MAP["CITY4_1"], }
    { b=-88.000, tex=TEX_MAP["CITY4_1"], }
  }
  {
    { m="solid", }
    { x=344.000, y=320.000, tex=TEX_MAP["CITY4_1"], }
    { x=344.000, y=352.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=352.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=320.000, tex=TEX_MAP["CITY4_1"], }
    { t=-88.000, tex=TEX_MAP["CITY4_1"], }
    { b=-104.000, tex=TEX_MAP["CITY4_1"], }
  }
  {
    { m="solid", }
    { x=344.000, y=288.000, tex=TEX_MAP["CITY4_1"], }
    { x=344.000, y=320.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=320.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=288.000, tex=TEX_MAP["CITY4_1"], }
    { t=-104.000, tex=TEX_MAP["CITY4_1"], }
    { b=-120.000, tex=TEX_MAP["CITY4_1"], }
  }
--    @@@@ FIX BRUSH @ line:1919 @@@@
--    @@@@ FIX BRUSH @ line:1927 @@@@
--    @@@@ FIX BRUSH @ line:1935 @@@@
  {
    { m="liquid", detail=1, medium="water", }
    { x=592.000, y=-704.000, tex="nothing", }
    { x=592.000, y=552.000, tex="nothing", }
    { x=-32.000, y=552.000, tex="nothing", }
    { x=-32.000, y=-704.000, tex="nothing", }
    { t=-40.000, tex=TEX_MAP["*04WATER2"], }
    { b=-152.000, tex="nothing", }
  }
  {
    { m="solid", }
    { x=344.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { x=344.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { x=328.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { t=-16.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=248.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { x=248.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=176.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { t=-16.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-456.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-312.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-312.000, tex=TEX_MAP["CITY2_3"], }
    { x=184.000, y=-456.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=16.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-568.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-544.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=-536.000, tex=TEX_MAP["CITY2_6"], }
    { x=184.000, y=-536.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-544.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-568.000, tex=TEX_MAP["CITY2_6"], }
    { t=0.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.00000, ny=0.44721, nz=0.89443 }, }
    { b=-32.000, tex=TEX_MAP["CITY2_6"], slope={ nx=-0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=240.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-616.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-616.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=184.000, y=-648.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=-648.000, tex=TEX_MAP["CITY2_6"], }
    { t=0.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=-32.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=240.000, y=-616.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-568.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-568.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-616.000, tex=TEX_MAP["CITY2_6"], }
    { t=0.000, tex=TEX_MAP["CITY2_6"], }
    { b=-16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-552.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-544.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=-536.000, tex=TEX_MAP["CITY2_6"], }
    { x=184.000, y=-536.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-544.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-552.000, tex=TEX_MAP["CITY2_6"], }
    { t=-56.000, tex=TEX_MAP["CITY2_6"], }
    { b=-136.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-552.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-544.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=-536.000, tex=TEX_MAP["CITY2_6"], }
    { x=184.000, y=-536.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-544.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-552.000, tex=TEX_MAP["CITY2_6"], }
    { t=-16.000, tex=TEX_MAP["CITY2_6"], }
    { b=-56.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-632.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-632.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=184.000, y=-648.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=-648.000, tex=TEX_MAP["CITY2_6"], }
    { t=-56.000, tex=TEX_MAP["CITY2_6"], }
    { b=-136.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-632.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-632.000, tex=TEX_MAP["CITY2_6"], }
    { x=176.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=184.000, y=-648.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=-648.000, tex=TEX_MAP["CITY2_6"], }
    { t=-16.000, tex=TEX_MAP["CITY2_6"], }
    { b=-56.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=344.000, y=256.000, tex=TEX_MAP["CITY4_1"], }
    { x=344.000, y=288.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=288.000, tex=TEX_MAP["CITY4_1"], }
    { x=232.000, y=256.000, tex=TEX_MAP["CITY4_1"], }
    { t=-120.000, tex=TEX_MAP["CITY4_1"], }
    { b=-136.000, tex=TEX_MAP["CITY4_1"], }
  }
  {
    { m="solid", }
    { x=696.000, y=-696.000, tex=TEX_MAP["CITY4_1"], }
    { x=696.000, y=288.000, tex=TEX_MAP["CITY4_1"], }
    { x=-24.000, y=288.000, tex=TEX_MAP["CITY4_1"], }
    { x=-24.000, y=-696.000, tex=TEX_MAP["CITY4_1"], }
    { t=-136.000, tex=TEX_MAP["CITY4_1"], }
    { b=-152.000, tex=TEX_MAP["CITY4_1"], }
  }
  {
    { m="solid", }
    { x=608.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=112.000, tex=TEX_MAP["CITY2_6"], }
    { x=344.000, y=112.000, tex=TEX_MAP["CITY2_6"], }
    { x=344.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-696.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-696.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=608.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=-696.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-696.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=608.000, y=-696.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=592.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=592.000, y=-696.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-544.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-544.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=224.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { x=184.000, y=-448.000, tex=TEX_MAP["CITY2_6"], }
    { x=184.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=184.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=184.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { x=168.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { x=168.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=232.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=112.000, tex=TEX_MAP["CITY2_6"], }
    { x=168.000, y=112.000, tex=TEX_MAP["CITY2_6"], }
    { x=168.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-648.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-536.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-536.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-648.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=0.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=240.000, y=-640.000, tex=TEX_MAP["CITY2_6"], }
    { x=240.000, y=-544.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=-536.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-536.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-648.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=-648.000, tex=TEX_MAP["CITY2_6"], }
    { t=0.000, tex=TEX_MAP["CITY2_6"], }
    { b=-16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=344.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { x=344.000, y=112.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=112.000, tex=TEX_MAP["CITY2_6"], }
    { x=232.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=608.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=-368.000, tex=TEX_MAP["CITY2_6"], }
    { x=168.000, y=-368.000, tex=TEX_MAP["CITY2_6"], }
    { x=168.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { t=16.000, tex=TEX_MAP["AFLOOR1_4"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=224.000, y=112.000, tex=TEX_MAP["CITY2_6"], }
    { x=168.000, y=112.000, tex=TEX_MAP["CITY2_6"], }
    { x=168.000, y=-384.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-384.000, tex=TEX_MAP["CITY2_6"], }
    { t=16.000, tex=TEX_MAP["AFLOOR1_4"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=592.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { x=592.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { t=16.000, tex=TEX_MAP["AFLOOR1_4"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=608.000, y=-384.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-272.000, tex=TEX_MAP["CITY2_6"], }
    { x=320.000, y=-384.000, tex=TEX_MAP["CITY2_6"], }
    { t=16.000, tex=TEX_MAP["AFLOOR1_4"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=608.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-456.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { t=16.000, tex=TEX_MAP["CITY2_6"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=976.000, y=440.000, tex=TEX_MAP["CITY2_3"], }
    { x=856.000, y=560.000, tex=TEX_MAP["CITY2_3"], }
    { x=840.000, y=560.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=440.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=192.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=832.000, y=-360.000, tex=TEX_MAP["METAL2_4"], }
    { x=344.000, y=-360.000, tex=TEX_MAP["METAL2_4"], }
    { x=344.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { t=392.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-520.000, tex=TEX_MAP["METAL2_4"], }
    { x=832.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { x=344.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { x=344.000, y=-520.000, tex=TEX_MAP["METAL2_4"], }
    { t=392.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=368.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { x=368.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=344.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=344.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { t=392.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=832.000, y=-488.000, tex=TEX_MAP["METAL2_4"], }
    { x=832.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=808.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=808.000, y=-488.000, tex=TEX_MAP["METAL2_4"], }
    { t=392.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=376.000, y=-392.000, tex=TEX_MAP["METAL2_4"], }
    { x=376.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { x=336.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { x=336.000, y=-392.000, tex=TEX_MAP["METAL2_4"], }
    { t=392.000, tex=TEX_MAP["METAL2_4"], }
    { b=320.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=376.000, y=-528.000, tex=TEX_MAP["METAL2_4"], }
    { x=376.000, y=-488.000, tex=TEX_MAP["METAL2_4"], }
    { x=336.000, y=-488.000, tex=TEX_MAP["METAL2_4"], }
    { x=336.000, y=-528.000, tex=TEX_MAP["METAL2_4"], }
    { t=416.000, tex=TEX_MAP["METAL2_4"], }
    { b=320.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=840.000, y=-528.000, tex=TEX_MAP["METAL2_4"], }
    { x=840.000, y=-488.000, tex=TEX_MAP["METAL2_4"], }
    { x=800.000, y=-488.000, tex=TEX_MAP["METAL2_4"], }
    { x=800.000, y=-528.000, tex=TEX_MAP["METAL2_4"], }
    { t=392.000, tex=TEX_MAP["METAL2_4"], }
    { b=320.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=840.000, y=-392.000, tex=TEX_MAP["METAL2_4"], }
    { x=840.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { x=800.000, y=-352.000, tex=TEX_MAP["METAL2_4"], }
    { x=800.000, y=-392.000, tex=TEX_MAP["METAL2_4"], }
    { t=392.000, tex=TEX_MAP["METAL2_4"], }
    { b=320.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=496.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { x=384.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=368.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=480.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { t=344.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=384.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { x=496.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=480.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=368.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { t=344.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=696.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { x=808.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=792.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=680.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { t=344.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=808.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { x=696.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=680.000, y=-384.000, tex=TEX_MAP["METAL2_4"], }
    { x=792.000, y=-496.000, tex=TEX_MAP["METAL2_4"], }
    { t=344.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=56.000, y=-264.000, tex=TEX_MAP["METAL2_4"], }
    { x=56.000, y=-184.000, tex=TEX_MAP["METAL2_4"], }
    { x=48.000, y=-184.000, tex=TEX_MAP["METAL2_4"], }
    { x=48.000, y=-264.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=184.000, y=-264.000, tex=TEX_MAP["METAL2_4"], }
    { x=184.000, y=-184.000, tex=TEX_MAP["METAL2_4"], }
    { x=176.000, y=-184.000, tex=TEX_MAP["METAL2_4"], }
    { x=176.000, y=-264.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=176.000, y=-264.000, tex=TEX_MAP["METAL2_4"], }
    { x=176.000, y=-256.000, tex=TEX_MAP["METAL2_4"], }
    { x=56.000, y=-256.000, tex=TEX_MAP["METAL2_4"], }
    { x=56.000, y=-264.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=176.000, y=-192.000, tex=TEX_MAP["METAL2_4"], }
    { x=176.000, y=-184.000, tex=TEX_MAP["METAL2_4"], }
    { x=56.000, y=-184.000, tex=TEX_MAP["METAL2_4"], }
    { x=56.000, y=-192.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=120.000, y=-256.000, tex=TEX_MAP["METAL2_4"], }
    { x=120.000, y=-192.000, tex=TEX_MAP["METAL2_4"], }
    { x=112.000, y=-192.000, tex=TEX_MAP["METAL2_4"], }
    { x=112.000, y=-256.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=176.000, y=-228.000, tex=TEX_MAP["METAL2_4"], }
    { x=176.000, y=-220.000, tex=TEX_MAP["METAL2_4"], }
    { x=56.000, y=-220.000, tex=TEX_MAP["METAL2_4"], }
    { x=56.000, y=-228.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=92.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { x=92.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=84.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=84.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=120.000, y=-648.000, tex=TEX_MAP["METAL2_4"], }
    { x=120.000, y=-640.000, tex=TEX_MAP["METAL2_4"], }
    { x=56.000, y=-640.000, tex=TEX_MAP["METAL2_4"], }
    { x=56.000, y=-648.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=-72.000, y=-648.000, tex=TEX_MAP["METAL2_4"], }
    { x=-72.000, y=-640.000, tex=TEX_MAP["METAL2_4"], }
    { x=-136.000, y=-640.000, tex=TEX_MAP["METAL2_4"], }
    { x=-136.000, y=-648.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=-100.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { x=-100.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=-108.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=-108.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=-64.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=-64.000, y=-576.000, tex=TEX_MAP["METAL2_4"], }
    { x=-144.000, y=-576.000, tex=TEX_MAP["METAL2_4"], }
    { x=-144.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=-64.000, y=-712.000, tex=TEX_MAP["METAL2_4"], }
    { x=-64.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { x=-144.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { x=-144.000, y=-712.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=-136.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { x=-136.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=-144.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=-144.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=-64.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { x=-64.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=-72.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=-72.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { x=128.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=120.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=120.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=56.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { x=56.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=48.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=48.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-712.000, tex=TEX_MAP["METAL2_4"], }
    { x=128.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { x=48.000, y=-704.000, tex=TEX_MAP["METAL2_4"], }
    { x=48.000, y=-712.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=128.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { x=128.000, y=-576.000, tex=TEX_MAP["METAL2_4"], }
    { x=48.000, y=-576.000, tex=TEX_MAP["METAL2_4"], }
    { x=48.000, y=-584.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=796.000, y=312.000, tex=TEX_MAP["METAL2_4"], }
    { x=796.000, y=432.000, tex=TEX_MAP["METAL2_4"], }
    { x=788.000, y=432.000, tex=TEX_MAP["METAL2_4"], }
    { x=788.000, y=312.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=824.000, y=368.000, tex=TEX_MAP["METAL2_4"], }
    { x=824.000, y=376.000, tex=TEX_MAP["METAL2_4"], }
    { x=760.000, y=376.000, tex=TEX_MAP["METAL2_4"], }
    { x=760.000, y=368.000, tex=TEX_MAP["METAL2_4"], }
    { t=336.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=832.000, y=312.000, tex=TEX_MAP["METAL2_4"], }
    { x=832.000, y=432.000, tex=TEX_MAP["METAL2_4"], }
    { x=824.000, y=432.000, tex=TEX_MAP["METAL2_4"], }
    { x=824.000, y=312.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=760.000, y=312.000, tex=TEX_MAP["METAL2_4"], }
    { x=760.000, y=432.000, tex=TEX_MAP["METAL2_4"], }
    { x=752.000, y=432.000, tex=TEX_MAP["METAL2_4"], }
    { x=752.000, y=312.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=832.000, y=304.000, tex=TEX_MAP["METAL2_4"], }
    { x=832.000, y=312.000, tex=TEX_MAP["METAL2_4"], }
    { x=752.000, y=312.000, tex=TEX_MAP["METAL2_4"], }
    { x=752.000, y=304.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=832.000, y=432.000, tex=TEX_MAP["METAL2_4"], }
    { x=832.000, y=440.000, tex=TEX_MAP["METAL2_4"], }
    { x=752.000, y=440.000, tex=TEX_MAP["METAL2_4"], }
    { x=752.000, y=432.000, tex=TEX_MAP["METAL2_4"], }
    { t=360.000, tex=TEX_MAP["METAL2_4"], }
    { b=328.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=264.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { x=264.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { t=328.000, tex=TEX_MAP["METAL1_7"], }
    { b=320.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=292.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { x=292.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { t=328.000, tex=TEX_MAP["METAL1_7"], }
    { b=320.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=320.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { x=320.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { t=328.000, tex=TEX_MAP["METAL1_7"], }
    { b=320.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=320.000, y=560.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=560.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { x=320.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { t=324.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=292.000, y=560.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=560.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { x=292.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { t=324.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=264.000, y=560.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=560.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { x=264.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { t=324.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=264.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { x=264.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { t=292.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=292.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { x=292.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { t=292.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=320.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { x=320.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=592.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=552.000, tex=TEX_MAP["METAL1_7"], }
    { t=292.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=264.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { x=264.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { t=292.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=292.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { x=292.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { t=292.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=320.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { x=320.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { t=292.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=320.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=248.000, tex=TEX_MAP["METAL1_7"], }
    { x=320.000, y=248.000, tex=TEX_MAP["METAL1_7"], }
    { t=324.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=292.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=248.000, tex=TEX_MAP["METAL1_7"], }
    { x=292.000, y=248.000, tex=TEX_MAP["METAL1_7"], }
    { t=324.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=264.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=248.000, tex=TEX_MAP["METAL1_7"], }
    { x=264.000, y=248.000, tex=TEX_MAP["METAL1_7"], }
    { t=324.000, tex=TEX_MAP["METAL1_7"], }
    { b=284.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=264.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { x=264.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=256.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { t=328.000, tex=TEX_MAP["METAL1_7"], }
    { b=320.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=292.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { x=292.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=284.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { t=328.000, tex=TEX_MAP["METAL1_7"], }
    { b=320.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=320.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { x=320.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=256.000, tex=TEX_MAP["METAL1_7"], }
    { x=312.000, y=216.000, tex=TEX_MAP["METAL1_7"], }
    { t=328.000, tex=TEX_MAP["METAL1_7"], }
    { b=320.000, tex=TEX_MAP["METAL1_7"], }
  }
  {
    { m="solid", }
    { x=992.000, y=-896.000, tex=TEX_MAP["CITY2_3"], }
    { x=992.000, y=-824.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=-824.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=-896.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=1000.000, y=-792.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-792.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { x=992.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { x=1000.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.44721, nz=0.89443 }, }
    { b=272.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=992.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-744.000, tex=TEX_MAP["CITY2_6"], }
    { x=1000.000, y=-744.000, tex=TEX_MAP["CITY2_6"], }
    { x=1000.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=0.44721, nz=0.89443 }, }
    { b=272.000, tex=TEX_MAP["CITY2_6"], slope={ nx=0.00000, ny=-0.44721, nz=-0.89443 }, }
  }
  {
    { m="solid", }
    { x=1000.000, y=-744.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-744.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-792.000, tex=TEX_MAP["CITY2_6"], }
    { x=1000.000, y=-792.000, tex=TEX_MAP["CITY2_6"], }
    { t=304.000, tex=TEX_MAP["CITY2_6"], }
    { b=288.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=992.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-728.000, tex=TEX_MAP["CITY2_6"], }
    { x=1000.000, y=-728.000, tex=TEX_MAP["CITY2_6"], }
    { x=1000.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { t=248.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=992.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-712.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-728.000, tex=TEX_MAP["CITY2_6"], }
    { x=1000.000, y=-728.000, tex=TEX_MAP["CITY2_6"], }
    { x=1000.000, y=-720.000, tex=TEX_MAP["CITY2_6"], }
    { t=288.000, tex=TEX_MAP["CITY2_6"], }
    { b=248.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1000.000, y=-808.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-808.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { x=992.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { x=1000.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { t=248.000, tex=TEX_MAP["CITY2_6"], }
    { b=-48.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=1000.000, y=-808.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-808.000, tex=TEX_MAP["CITY2_6"], }
    { x=952.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { x=960.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { x=992.000, y=-824.000, tex=TEX_MAP["CITY2_6"], }
    { x=1000.000, y=-816.000, tex=TEX_MAP["CITY2_6"], }
    { t=288.000, tex=TEX_MAP["CITY2_6"], }
    { b=248.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=992.000, y=-824.000, tex=TEX_MAP["CITY2_3"], }
    { x=992.000, y=-712.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=-712.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=-824.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=288.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=856.000, y=200.000, tex=TEX_MAP["CITY2_3"], }
    { x=976.000, y=320.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=320.000, tex=TEX_MAP["CITY2_3"], }
    { x=840.000, y=200.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=192.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=992.000, y=-712.000, tex=TEX_MAP["CITY2_3"], }
    { x=992.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { x=960.000, y=-712.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-912.000, tex=TEX_MAP["CITY2_3"], }
    { x=1152.000, y=-896.000, tex=TEX_MAP["CITY2_3"], }
    { x=992.000, y=-896.000, tex=TEX_MAP["CITY2_3"], }
    { x=992.000, y=-912.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=1152.000, y=-640.000, tex=TEX_MAP["CITY2_3"], }
    { x=1152.000, y=-616.000, tex=TEX_MAP["CITY2_3"], }
    { x=992.000, y=-616.000, tex=TEX_MAP["CITY2_3"], }
    { x=992.000, y=-640.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=1176.000, y=-912.000, tex=TEX_MAP["CITY2_3"], }
    { x=1176.000, y=-616.000, tex=TEX_MAP["CITY2_3"], }
    { x=1152.000, y=-616.000, tex=TEX_MAP["CITY2_3"], }
    { x=1152.000, y=-912.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=-48.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=900.000, y=344.000, tex=TEX_MAP["COP1_5"], }
    { x=900.000, y=408.000, tex=TEX_MAP["COP1_5"], }
    { x=880.000, y=408.000, tex=TEX_MAP["COP1_5"], }
    { x=880.000, y=344.000, tex=TEX_MAP["COP1_5"], }
    { t=208.000, tex=TEX_MAP["COP1_5"], }
    { b=200.000, tex=TEX_MAP["COP1_5"], }
  }
  {
    { m="solid", }
    { x=900.000, y=344.000, tex=TEX_MAP["COP1_5"], }
    { x=900.000, y=408.000, tex=TEX_MAP["COP1_5"], }
    { x=880.000, y=408.000, tex=TEX_MAP["COP1_5"], }
    { x=880.000, y=344.000, tex=TEX_MAP["COP1_5"], }
    { t=312.000, tex=TEX_MAP["COP1_5"], }
    { b=304.000, tex=TEX_MAP["COP1_5"], }
  }
  {
    { m="solid", }
    { x=900.000, y=400.000, tex=TEX_MAP["COP1_5"], }
    { x=900.000, y=408.000, tex=TEX_MAP["COP1_5"], }
    { x=880.000, y=408.000, tex=TEX_MAP["COP1_5"], }
    { x=880.000, y=400.000, tex=TEX_MAP["COP1_5"], }
    { t=312.000, tex=TEX_MAP["COP1_5"], }
    { b=200.000, tex=TEX_MAP["COP1_5"], }
  }
  {
    { m="solid", }
    { x=900.000, y=344.000, tex=TEX_MAP["COP1_5"], }
    { x=900.000, y=352.000, tex=TEX_MAP["COP1_5"], }
    { x=880.000, y=352.000, tex=TEX_MAP["COP1_5"], }
    { x=880.000, y=344.000, tex=TEX_MAP["COP1_5"], }
    { t=312.000, tex=TEX_MAP["COP1_5"], }
    { b=200.000, tex=TEX_MAP["COP1_5"], }
  }
  {
    { m="solid", }
    { x=1124.000, y=-792.000, tex=TEX_MAP["*TELEPORT"], }
    { x=1124.000, y=-744.000, tex=TEX_MAP["*TELEPORT"], }
    { x=1120.000, y=-744.000, tex=TEX_MAP["*TELEPORT"], }
    { x=1120.000, y=-792.000, tex=TEX_MAP["*TELEPORT"], }
    { t=308.000, tex=TEX_MAP["*TELEPORT"], }
    { b=204.000, tex=TEX_MAP["*TELEPORT"], }
  }
  {
    { m="solid", }
    { x=1132.000, y=-800.000, tex=TEX_MAP["COP1_5"], }
    { x=1132.000, y=-792.000, tex=TEX_MAP["COP1_5"], }
    { x=1108.000, y=-792.000, tex=TEX_MAP["COP1_5"], }
    { x=1108.000, y=-800.000, tex=TEX_MAP["COP1_5"], }
    { t=312.000, tex=TEX_MAP["COP1_5"], }
    { b=200.000, tex=TEX_MAP["COP1_5"], }
  }
  {
    { m="solid", }
    { x=1132.000, y=-744.000, tex=TEX_MAP["COP1_5"], }
    { x=1132.000, y=-736.000, tex=TEX_MAP["COP1_5"], }
    { x=1108.000, y=-736.000, tex=TEX_MAP["COP1_5"], }
    { x=1108.000, y=-744.000, tex=TEX_MAP["COP1_5"], }
    { t=312.000, tex=TEX_MAP["COP1_5"], }
    { b=200.000, tex=TEX_MAP["COP1_5"], }
  }
  {
    { m="solid", }
    { x=1132.000, y=-800.000, tex=TEX_MAP["COP1_5"], }
    { x=1132.000, y=-736.000, tex=TEX_MAP["COP1_5"], }
    { x=1108.000, y=-736.000, tex=TEX_MAP["COP1_5"], }
    { x=1108.000, y=-800.000, tex=TEX_MAP["COP1_5"], }
    { t=312.000, tex=TEX_MAP["COP1_5"], }
    { b=304.000, tex=TEX_MAP["COP1_5"], }
  }
  {
    { m="solid", }
    { x=1132.000, y=-800.000, tex=TEX_MAP["COP1_5"], }
    { x=1132.000, y=-736.000, tex=TEX_MAP["COP1_5"], }
    { x=1108.000, y=-736.000, tex=TEX_MAP["COP1_5"], }
    { x=1108.000, y=-800.000, tex=TEX_MAP["COP1_5"], }
    { t=208.000, tex=TEX_MAP["COP1_5"], }
    { b=200.000, tex=TEX_MAP["COP1_5"], }
  }
  {
    { m="solid", }
    { x=344.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { x=344.000, y=24.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=24.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-168.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=96.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=892.000, y=352.000, tex=TEX_MAP["*TELEPORT"], }
    { x=892.000, y=400.000, tex=TEX_MAP["*TELEPORT"], }
    { x=888.000, y=400.000, tex=TEX_MAP["*TELEPORT"], }
    { x=888.000, y=352.000, tex=TEX_MAP["*TELEPORT"], }
    { t=312.000, tex=TEX_MAP["*TELEPORT"], }
    { b=212.000, tex=TEX_MAP["*TELEPORT"], }
  }
  {
    { m="solid", }
    { x=464.000, y=800.000, tex=TEX_MAP["CITY2_3"], }
    { x=464.000, y=832.000, tex=TEX_MAP["CITY2_3"], }
    { x=352.000, y=832.000, tex=TEX_MAP["COP1_2"], }
    { x=352.000, y=800.000, tex=TEX_MAP["CITY2_3"], }
    { t=352.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=352.000, y=800.000, tex=TEX_MAP["CITY2_3"], }
    { x=352.000, y=832.000, tex=TEX_MAP["CITY2_3"], }
    { x=224.000, y=832.000, tex=TEX_MAP["CITY2_3"], }
    { x=224.000, y=800.000, tex=TEX_MAP["CITY2_3"], }
    { t=288.000, tex=TEX_MAP["CITY2_3"], }
    { b=248.000, tex=TEX_MAP["COP1_2"], }
  }
  {
    { m="solid", }
    { x=384.000, y=832.000, tex=TEX_MAP["CITY2_3"], }
    { x=384.000, y=880.000, tex=TEX_MAP["CITY2_3"], }
    { x=368.000, y=880.000, tex=TEX_MAP["CITY2_3"], }
    { x=368.000, y=832.000, tex=TEX_MAP["CITY2_3"], }
    { t=296.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=208.000, y=832.000, tex=TEX_MAP["CITY2_3"], }
    { x=208.000, y=880.000, tex=TEX_MAP["CITY2_3"], }
    { x=192.000, y=880.000, tex=TEX_MAP["CITY2_3"], }
    { x=192.000, y=832.000, tex=TEX_MAP["CITY2_3"], }
    { t=296.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=208.000, y=880.000, tex=TEX_MAP["CITY2_3"], }
    { x=176.000, y=912.000, tex=TEX_MAP["CITY2_3"], }
    { x=160.000, y=912.000, tex=TEX_MAP["CITY2_3"], }
    { x=192.000, y=880.000, tex=TEX_MAP["CITY2_3"], }
    { t=296.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=416.000, y=912.000, tex=TEX_MAP["CITY2_3"], }
    { x=400.000, y=912.000, tex=TEX_MAP["CITY2_3"], }
    { x=368.000, y=880.000, tex=TEX_MAP["CITY2_3"], }
    { x=384.000, y=880.000, tex=TEX_MAP["CITY2_3"], }
    { t=296.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=416.000, y=912.000, tex=TEX_MAP["CITY2_3"], }
    { x=416.000, y=1008.000, tex=TEX_MAP["CITY2_3"], }
    { x=400.000, y=1008.000, tex=TEX_MAP["CITY2_3"], }
    { x=400.000, y=912.000, tex=TEX_MAP["CITY2_3"], }
    { t=296.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=176.000, y=912.000, tex=TEX_MAP["CITY2_3"], }
    { x=176.000, y=1008.000, tex=TEX_MAP["CITY2_3"], }
    { x=160.000, y=1008.000, tex=TEX_MAP["CITY2_3"], }
    { x=160.000, y=912.000, tex=TEX_MAP["CITY2_3"], }
    { t=296.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=208.000, y=1040.000, tex=TEX_MAP["CITY2_3"], }
    { x=192.000, y=1040.000, tex=TEX_MAP["CITY2_3"], }
    { x=160.000, y=1008.000, tex=TEX_MAP["CITY2_3"], }
    { x=176.000, y=1008.000, tex=TEX_MAP["CITY2_3"], }
    { t=296.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=416.000, y=1008.000, tex=TEX_MAP["CITY2_3"], }
    { x=384.000, y=1040.000, tex=TEX_MAP["CITY2_3"], }
    { x=368.000, y=1040.000, tex=TEX_MAP["CITY2_3"], }
    { x=400.000, y=1008.000, tex=TEX_MAP["CITY2_3"], }
    { t=296.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=384.000, y=1040.000, tex=TEX_MAP["CITY2_3"], }
    { x=384.000, y=1056.000, tex=TEX_MAP["CITY2_3"], }
    { x=192.000, y=1056.000, tex=TEX_MAP["CITY2_3"], }
    { x=192.000, y=1040.000, tex=TEX_MAP["CITY2_3"], }
    { t=296.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=416.000, y=816.000, tex=TEX_MAP["CITY3_4"], }
    { x=416.000, y=1056.000, tex=TEX_MAP["CITY3_4"], }
    { x=160.000, y=1056.000, tex=TEX_MAP["CITY3_4"], }
    { x=160.000, y=816.000, tex=TEX_MAP["CITY3_4"], }
    { t=296.000, tex=TEX_MAP["CITY3_4"], }
    { b=288.000, tex=TEX_MAP["CITY3_4"], }
  }
--    @@@@ FIX BRUSH @ line:2937 @@@@
--    @@@@ FIX BRUSH @ line:2945 @@@@
--    @@@@ FIX BRUSH @ line:2953 @@@@
--    @@@@ FIX BRUSH @ line:2961 @@@@
--    @@@@ FIX BRUSH @ line:2969 @@@@
--    @@@@ FIX BRUSH @ line:2977 @@@@
--    @@@@ FIX BRUSH @ line:2985 @@@@
--    @@@@ FIX BRUSH @ line:2993 @@@@
--    @@@@ FIX BRUSH @ line:3001 @@@@
--    @@@@ FIX BRUSH @ line:3009 @@@@
  {
    { m="solid", }
    { x=320.000, y=-272.000, tex=TEX_MAP["CITY2_3"], }
    { x=312.000, y=-272.000, tex=TEX_MAP["CITY2_3"], }
    { x=312.000, y=-368.000, tex=TEX_MAP["CITY2_3"], }
    { x=320.000, y=-368.000, tex=TEX_MAP["CITY2_3"], }
    { t=104.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-368.000, tex=TEX_MAP["CITY2_3"], }
    { x=320.000, y=-360.000, tex=TEX_MAP["CITY2_3"], }
    { x=224.000, y=-360.000, tex=TEX_MAP["CITY2_3"], }
    { x=224.000, y=-368.000, tex=TEX_MAP["CITY2_3"], }
    { t=104.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=232.000, y=-368.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=-272.000, tex=TEX_MAP["CITY2_3"], }
    { x=224.000, y=-272.000, tex=TEX_MAP["CITY2_3"], }
    { x=224.000, y=-368.000, tex=TEX_MAP["CITY2_3"], }
    { t=104.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=320.000, y=-280.000, tex=TEX_MAP["CITY2_3"], }
    { x=320.000, y=-272.000, tex=TEX_MAP["CITY2_3"], }
    { x=224.000, y=-272.000, tex=TEX_MAP["CITY2_3"], }
    { x=224.000, y=-280.000, tex=TEX_MAP["CITY2_3"], }
    { t=104.000, tex=TEX_MAP["CITY2_3"], }
    { b=0.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=344.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { x=344.000, y=216.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=216.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { t=88.000, tex=TEX_MAP["CITY2_3"], }
    { b=-16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=344.000, y=176.000, tex=TEX_MAP["CITY2_3"], }
    { x=344.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=184.000, tex=TEX_MAP["CITY2_3"], }
    { x=232.000, y=176.000, tex=TEX_MAP["CITY2_3"], }
    { t=208.000, tex=TEX_MAP["CITY2_3"], }
    { b=80.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=480.000, y=-32.000, tex=TEX_MAP["METAL2_4"], }
    { x=480.000, y=0.000, tex=TEX_MAP["METAL2_4"], }
    { x=448.000, y=0.000, tex=TEX_MAP["METAL2_4"], }
    { x=448.000, y=-32.000, tex=TEX_MAP["METAL2_4"], }
    { t=32.000, tex=TEX_MAP["METAL2_4"], }
    { b=-136.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=480.000, y=-480.000, tex=TEX_MAP["METAL2_4"], }
    { x=480.000, y=-448.000, tex=TEX_MAP["METAL2_4"], }
    { x=448.000, y=-448.000, tex=TEX_MAP["METAL2_4"], }
    { x=448.000, y=-480.000, tex=TEX_MAP["METAL2_4"], }
    { t=32.000, tex=TEX_MAP["METAL2_4"], }
    { b=-136.000, tex=TEX_MAP["METAL2_4"], }
  }
  {
    { m="solid", }
    { x=480.000, y=-256.000, tex=TEX_MAP["METAL2_4"], }
    { x=480.000, y=-224.000, tex=TEX_MAP["METAL2_4"], }
    { x=448.000, y=-224.000, tex=TEX_MAP["METAL2_4"], }
    { x=448.000, y=-256.000, tex=TEX_MAP["METAL2_4"], }
    { t=32.000, tex=TEX_MAP["METAL2_4"], }
    { b=-136.000, tex=TEX_MAP["METAL2_4"], }
  }
--    @@@@ FIX BRUSH @ line:3089 @@@@
--    @@@@ FIX BRUSH @ line:3097 @@@@
--    @@@@ FIX BRUSH @ line:3105 @@@@
--    @@@@ FIX BRUSH @ line:3113 @@@@
  {
    { m="solid", }
    { x=32.000, y=-336.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-328.000, tex=TEX_MAP["CITY2_6"], }
    { x=24.000, y=-320.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-320.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-328.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-336.000, tex=TEX_MAP["CITY2_6"], }
    { t=104.000, tex=TEX_MAP["CITY2_6"], }
    { b=16.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=32.000, y=-336.000, tex=TEX_MAP["CITY2_6"], }
    { x=32.000, y=-328.000, tex=TEX_MAP["CITY2_6"], }
    { x=24.000, y=-320.000, tex=TEX_MAP["CITY2_6"], }
    { x=-8.000, y=-320.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-328.000, tex=TEX_MAP["CITY2_6"], }
    { x=-16.000, y=-336.000, tex=TEX_MAP["CITY2_6"], }
    { t=128.000, tex=TEX_MAP["CITY2_6"], }
    { b=104.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=24.000, y=-320.000, tex=TEX_MAP["CITY2_3"], }
    { x=24.000, y=-312.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-312.000, tex=TEX_MAP["CITY2_3"], }
    { x=-8.000, y=-320.000, tex=TEX_MAP["CITY2_3"], }
    { t=144.000, tex=TEX_MAP["CITY2_3"], }
    { b=4.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", }
    { x=992.000, y=184.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=992.000, y=560.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=832.000, y=560.000, tex=TEX_MAP["AFLOOR1_8"], }
    { x=832.000, y=184.000, tex=TEX_MAP["AFLOOR1_8"], }
    { t=192.000, tex=TEX_MAP["AFLOOR1_8"], }
    { b=-64.000, tex=TEX_MAP["AFLOOR1_8"], }
  }
  {
    { m="solid", }
    { x=608.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { x=592.000, y=96.000, tex=TEX_MAP["CITY2_6"], }
    { x=592.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-152.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=608.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=112.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=112.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { t=16.000, tex=TEX_MAP["CITY2_6"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=520.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=520.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { x=224.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { t=16.000, tex=TEX_MAP["CITY2_6"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=720.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { x=720.000, y=80.000, tex=TEX_MAP["CITY2_6"], }
    { x=520.000, y=80.000, tex=TEX_MAP["CITY2_6"], }
    { x=520.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { t=128.000, tex=TEX_MAP["CITY2_6"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=720.000, y=-144.000, tex=TEX_MAP["CITY2_6"], }
    { x=720.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=520.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=520.000, y=-144.000, tex=TEX_MAP["CITY2_6"], }
    { t=128.000, tex=TEX_MAP["CITY2_6"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=520.000, y=-144.000, tex=TEX_MAP["CITY2_6"], }
    { x=520.000, y=80.000, tex=TEX_MAP["CITY2_6"], }
    { x=504.000, y=80.000, tex=TEX_MAP["CITY2_6"], }
    { x=504.000, y=-144.000, tex=TEX_MAP["CITY2_6"], }
    { t=128.000, tex=TEX_MAP["CITY2_6"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=544.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { x=520.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { x=520.000, y=40.000, tex=TEX_MAP["CITY2_6"], }
    { t=128.000, tex=TEX_MAP["CITY2_6"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=520.000, y=-104.000, tex=TEX_MAP["CITY2_6"], }
    { x=520.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=544.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { t=128.000, tex=TEX_MAP["CITY2_6"], }
    { b=8.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=736.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { x=592.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { x=592.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { t=-32.000, tex=TEX_MAP["CITY2_6"], }
    { b=-136.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=720.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { x=720.000, y=80.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=80.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=64.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-32.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=720.000, y=-144.000, tex=TEX_MAP["CITY2_6"], }
    { x=720.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=-128.000, tex=TEX_MAP["CITY2_6"], }
    { x=608.000, y=-144.000, tex=TEX_MAP["CITY2_6"], }
    { t=8.000, tex=TEX_MAP["CITY2_6"], }
    { b=-32.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=736.000, y=-144.000, tex=TEX_MAP["CITY2_6"], }
    { x=736.000, y=80.000, tex=TEX_MAP["CITY2_6"], }
    { x=720.000, y=80.000, tex=TEX_MAP["CITY2_6"], }
    { x=720.000, y=-144.000, tex=TEX_MAP["CITY2_6"], }
    { t=128.000, tex=TEX_MAP["CITY2_6"], }
    { b=-32.000, tex=TEX_MAP["CITY2_6"], }
  }
  {
    { m="solid", }
    { x=736.000, y=24.000, tex=TEX_MAP["CITY2_3"], }
    { x=736.000, y=80.000, tex=TEX_MAP["CITY2_3"], }
    { x=504.000, y=80.000, tex=TEX_MAP["CITY2_3"], }
    { x=504.000, y=24.000, tex=TEX_MAP["CITY2_3"], }
    { t=96.000, tex=TEX_MAP["CITY2_3"], }
    { b=80.000, tex=TEX_MAP["CITY2_3"], }
  }
  {
    { m="solid", link_entity="m1", }
    { x=908.000, y=352.000, tex=TEX_MAP["TRIGGER"], }
    { x=908.000, y=400.000, tex=TEX_MAP["TRIGGER"], }
    { x=872.000, y=400.000, tex=TEX_MAP["TRIGGER"], }
    { x=872.000, y=352.000, tex=TEX_MAP["TRIGGER"], }
    { t=312.000, tex=TEX_MAP["TRIGGER"], }
    { b=212.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m2", }
    { x=1132.000, y=-792.000, tex=TEX_MAP["TRIGGER"], }
    { x=1132.000, y=-744.000, tex=TEX_MAP["TRIGGER"], }
    { x=1100.000, y=-744.000, tex=TEX_MAP["TRIGGER"], }
    { x=1100.000, y=-792.000, tex=TEX_MAP["TRIGGER"], }
    { t=312.000, tex=TEX_MAP["TRIGGER"], }
    { b=200.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m3", }
    { x=312.000, y=184.000, tex=TEX_MAP["ADOOR03_6"], }
    { x=312.000, y=192.000, tex=TEX_MAP["+2BUTTON"], }
    { x=264.000, y=192.000, tex=TEX_MAP["ADOOR03_6"], }
    { x=264.000, y=184.000, tex=TEX_MAP["ADOOR03_6"], }
    { t=160.000, tex=TEX_MAP["ADOOR03_6"], }
    { b=112.000, tex=TEX_MAP["ADOOR03_6"], }
  }
  {
    { m="solid", link_entity="m4", }
    { x=288.000, y=808.000, tex=TEX_MAP["DOOR05_3"], }
    { x=288.000, y=824.000, tex=TEX_MAP["DOOR04_1"], }
    { x=224.000, y=824.000, tex=TEX_MAP["DOOR04_1"], }
    { x=224.000, y=808.000, tex=TEX_MAP["DOOR04_1"], }
    { t=248.000, tex=TEX_MAP["DOOR04_1"], }
    { b=96.000, tex=TEX_MAP["DOOR04_1"], }
  }
  {
    { m="solid", link_entity="m5", }
    { x=368.000, y=832.000, tex=TEX_MAP["TRIGGER"], }
    { x=368.000, y=848.000, tex=TEX_MAP["TRIGGER"], }
    { x=208.000, y=848.000, tex=TEX_MAP["TRIGGER"], }
    { x=208.000, y=832.000, tex=TEX_MAP["TRIGGER"], }
    { t=136.000, tex=TEX_MAP["TRIGGER"], }
    { b=128.000, tex=TEX_MAP["TRIGGER"], }
  }
  {
    { m="solid", link_entity="m6", }
    { x=352.000, y=808.000, tex=TEX_MAP["DOOR05_3"], }
    { x=352.000, y=824.000, tex=TEX_MAP["DOOR04_1"], }
    { x=288.000, y=824.000, tex=TEX_MAP["DOOR05_3"], }
    { x=288.000, y=808.000, tex=TEX_MAP["DOOR04_1"], }
    { t=248.000, tex=TEX_MAP["DOOR04_1"], }
    { b=96.000, tex=TEX_MAP["DOOR04_1"], }
  }
  {
    { m="solid", link_entity="m7", }
    { x=1216.000, y=-1088.000, tex=TEX_MAP["Z_EXIT"], }
    { x=1216.000, y=-1024.000, tex=TEX_MAP["Z_EXIT"], }
    { x=1152.000, y=-1024.000, tex=TEX_MAP["Z_EXIT"], }
    { x=1152.000, y=-1088.000, tex=TEX_MAP["Z_EXIT"], }
    { t=128.000, tex=TEX_MAP["Z_EXIT"], }
    { b=64.000, tex=TEX_MAP["Z_EXIT"], }
  }
}
