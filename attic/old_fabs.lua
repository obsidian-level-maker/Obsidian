Start_ledge =
{
  _prefab = "START_LEDGE"
  _where  = "edge"
  _long   = 192
  _deep   =  64

  wall = "CRACKLE2"
}

Exit_switch =
{
  _prefab = "WALL_SWITCH"
  _where  = "edge"
  _long   = 192
  _deep   = 64

  wall = "EXITSTON"

  switch="SW1HOT"
  special=11
  x_offset=0
  y_offset=0
}

Exit_Pillar_tech =
{
  _prefab = "EXIT_PILLAR",
  _where  = "middle"

  switch = "SW1COMP"
  exit = "EXITSIGN"
  exitside = "COMPSPAN"
  use_sign = 1
  special = 11
  tag = 0
}

Exit_Pillar_gothic =
{
  _prefab = "EXIT_PILLAR",
  _where  = "middle"

  switch = { SW1LION=60, SW1GARG=30 }
  exit = "EXITSIGN"
  exitside = "COMPSPAN"
  use_sign = 1
  special = 11
  tag = 0
}

Exit_Pillar_urban =
{
  _prefab = "EXIT_PILLAR",
  _where  = "middle"

  switch = "SW1WDMET"
  exit = "EXITSIGN"
  exitside = "COMPSPAN"
  use_sign = 1
  special = 11
  tag = 0
}

Exit_Closet_urban =
{
  _prefab = "EXIT_CLOSET"
  _where  = "closet"
  _fitted = "xy"

--[[ FIXME
  door  = "EXITDOOR"
  track = "DOORTRAK"
  key   = "SUPPORT3"
  key_ox = 24

  inner = { BIGBRIK3=20, WOOD9=10, STONE=10, WOODMET1=35,
            CEMENT9=5, PANEL6=20 }
  
  ceil = { RROCK04=20, RROCK13=20, RROCK03=10, 
           FLAT10=20, FLOOR6_2=10, FLAT4=20 }

  floor2  = { FLAT5_2=30, CEIL5_1=15, CEIL4_2=15,
              MFLR8_1=15, RROCK18=25, RROCK12=20 }

  use_sign = 1
  exit = "EXITSIGN"
  exitside = "COMPSPAN"

  switch  = { SW1BRNGN=30, SW1ROCK=10, SW1SLAD=20, SW1TEK=20 }
  sw_side = "BROWNGRN"
  sw_oy   = 60

  special = 11
  tag = 0

  item1 = { stimpack=50, medikit=20, soul=1, none=30 }
  item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
}

Stair_Up1 =
{
  _prefab = "STAIR_6"
  _where  = "floor"
  _deltas = { 32,48,48,64,64,80 }
}

Stair_Up2 =
{
  _prefab = "STAIR_W_SIDES"
  _where  = "floor"

  metal = "METAL"
  step  = "STEP1"
  top   = "FLOOR0_1"
}

Stair_Up3 =
{
  _prefab = "STAIR_TRIANGLE"
  _where  = "floor"

  step = "STEP1"
  top = "FLOOR0_1"
}

Stair_Up4 =
{
  _prefab = "STAIR_CIRCLE"
  _where  = "floor"

  step = "STEP5"
  top  = "FLOOR0_2"
}

Stair_Down1 =
{
  _prefab = "NICHE_STAIR_8"
  _where  = "floor"
  _deltas = { -32,-48,-64,-64,-80,-96 }
}

Lift_Up1 =  -- Rusty
{
  _prefab = "LIFT_UP"
  _where  = "floor"
  _tags   = 1
  _deltas = { 96,128,160,192 }

  lift = "SUPPORT3"
  top  = { STEP_F1=50, STEP_F2=50 }

  walk_kind   = 88
  switch_kind = 62
}

Lift_Down1 =  -- Shiny
{
  _prefab = "LIFT_DOWN"
  _where  = "floor"
  _tags   = 1
  _deltas = { -96,-128,-160,-192 }

  lift = "SUPPORT2"
  top  = "FLAT20"

  walk_kind   = 88
  switch_kind = 62
}

Item_niche =
{
  _prefab = "ITEM_NICHE"
  _where  = "edge"
  _long   = 192
  _deep   = 64
}

Item_Closet =
{
  _prefab = "ITEM_CLOSET"
  _where  = "closet"
  _long   = { 192,384 }
  _deep   = { 192,384 }

  item = "soul"
}

Secret_Closet =
{
  _prefab = "SECRET_NICHE_1"
  _where  = "closet"
  _tags   = 1
  _long   = { 192,384 }
  _deep   = { 192,384 }

  item = { backpack=50, blue_armor=50, soul=30, berserk=30,
           invul=10, invis=10, map=10, goggles=5 }

  special = 103  -- open and stay open
}

Arch1 =
{
  _prefab = "ARCH"
  _where  = "edge"
  _long   = 192
  _deep   = 64
}

MiniHall_Arch1 =
{
  _prefab = "FAT_ARCH1"
  _shape  = "I"
  _delta  = 0

  pic = "SW1SATYR"    
}

Door_silver =
{
  _prefab = "DOOR"
  _where  = "edge"
  _long   = 192
  _deep   = 48

  door_w = 128
  door_h = 72

  door  = "BIGDOOR1"
  track = "DOORTRAK"
  key   = "LITE3"
  step  = "STEP4"

  x_offset = 0
  y_offset = 0
  special = 1
  tag = 0
}

OLD_sw_blue2 =
{
  prefab = "SWITCH_FLOOR_BEAM",
  skin =
  {
    switch_h=64,
    switch_w="SW1BLUE", side_w="COMPBLUE",
    switch_f="FLAT14", switch_h=64,

    beam_w="WOOD1", beam_f="FLAT5_2",

    x_offset=0, y_offset=56,
    special=103,
  }
}

OLD_sw_hot =
{
  prefab = "SWITCH_PILLAR",
  skin =
  {
    switch_h=64,
    switch="SW1HOT", side="SP_HOT1", base="FLAT5_3",
    x_offset=0, y_offset=52,
    special=103,
  }

}

OLD_sw_skin =
{
  prefab = "SWITCH_PILLAR",
  skin =
  {
    switch_h=64,
    switch="SW1SKIN", side="SKSNAKE2", base="SFLR6_4",
    x_offset=0, y_offset=52,
    special=103,
  }
}

OLD_sw_vine =
{
  prefab = "SWITCH_PILLAR",
  skin =
  {
    switch_h=64,
    switch="SW1VINE", side="GRAYVINE", base="FLAT1",
    x_offset=0, y_offset=64,
    special=103,
  }
}

OLD_sw_metl =  -- NOT USED
{
  prefab = "SWITCH_CEILING",
  environment = "indoor",
  skin =
  {
    switch_h=56,
    switch_w="SW1GARG", side_w="METAL",
    switch_c="CEIL5_2",

    beam_w="SUPPORT3", beam_c="CEIL5_2",

    x_offset=0, y_offset=64,
    special=23,
  }
}

OLD_sw_wood =
{
  prefab = "SWITCH_PILLAR",
  skin =
  {
    switch_h=64,
    switch="SW1WOOD", side="WOOD1", base="FLAT5_2",
    x_offset=0, y_offset=56,
    special=103,
  }
}

OLD_sw_marble =
{
  prefab = "SWITCH_PILLAR",
  skin =
  {
    switch="SW1GSTON", side="GSTONE1", base="FLOOR7_2",
    x_offset=0, y_offset=56,
    special=103,
  }
}

OLD_bar_wood =
{
  prefab = "SWITCH_PILLAR",
  skin =
  {
    switch="SW1WOOD", side="WOOD9", base="FLAT5_2",
    x_offset=0, y_offset=56,
    special=23,
  }
}

OLD_bar_silver =
{
  prefab = "SWITCH_PILLAR",
  skin =
  {
    switch="SW1COMM", side="SHAWN2", base="FLAT23",
    x_offset=0, y_offset=0,
    special=23,
  }
}

OLD_bar_metal =
{
  prefab = "SWITCH_PILLAR",
  skin =
  {
    switch="SW1MET2", side="METAL2", base="CEIL5_2",
    x_offset=0, y_offset=0,
    special=23,
  }
}

OLD_bar_gray =
{
  prefab = "SWITCH_PILLAR",
  skin =
  {
    switch="SW1GRAY1", side="GRAY1", base="FLAT1",
    x_offset=0, y_offset=64,
    special=23,
  }
}

-- narrow versions of above doors

Locked_kc_blue_NAR =
{
  _copy = "Locked_kc_blue"
  _narrow = 1

  door_w = 64
  door_h = 72
  door   = "DOOR3"
  door_c = "FLAT1"
}

Locked_kc_yellow_NAR =
{
  _copy = "Locked_kc_yellow"
  _narrow = 1

  door_w = 64
  door_h = 72
  door   = "DOOR3"
  door_c = "FLAT1"
}

Locked_kc_red_NAR =
{
  _copy = "Locked_kc_red"
  _narrow = 1

  door_w = 64
  door_h = 72
  door   = "DOOR3"
  door_c = "FLAT1"
}

Locked_ks_blue_NAR =
{
  _copy = "Locked_ks_blue"
  _narrow = 1

  door_w = 64
  door_h = 72
  door   = "DOOR3"
  door_c = "FLAT1"
}

Locked_ks_yellow_NAR =
{
  _copy = "Locked_ks_yellow"
  _narrow = 1

  door_w = 64
  door_h = 72
  door   = "DOOR3"
  door_c = "FLAT1"
}

Locked_ks_red_NAR =
{
  _copy = "Locked_ks_red"
  _narrow = 1

  door_w = 64
  door_h = 72
  door   = "DOOR3"
  door_c = "FLAT1"
}

MiniHall_Door_tech =
{
  _prefab = "MINI_DOOR1"
  _shape  = "I"
  _delta  = 0
  _door   = 1

  door   = { BIGDOOR3=50, BIGDOOR4=40, BIGDOOR2=15 }
  track  = "DOORTRAK"
  step   = "STEP4"
  metal  = "DOORSTOP"
  lite   = "LITE5"
  c_lite = "TLITE6_1"
}

MiniHall_Door_hell =
{
  _prefab = "MINI_DOOR1"
  _shape  = "I"
  _delta  = 0
  _door   = 1

  door   = { BIGDOOR6=50 }
  track  = "DOORTRAK"
  step   = "STEP4"
  metal  = "METAL"
  lite   = "FIREWALL"
}

Door_SW_red =
{
  _prefab = "DOOR"
  _where  = "edge"
  _switch = "sw_red"
  _long = 256
  _deep = 48

  door_w = 128
  door_h = 112

  key = "REDWALL"
  door = "BIGDOOR2"
  door_c = "FLAT1"
  step = "REDWALL"
  track = "DOORTRAK"
  frame = "FLAT5_3"
  door_h = 112
  special = 0
}

Door_SW_red_NAR =
{
  _copy = "Door_SW_red"
  _narrow = 1

  door_w = 64
  door_h = 72
  door   = "DOOR1"
  door_c = "FLAT23"
}

Switch_red1 =
{
  _prefab = "SMALL_SWITCH"
  _where  = "middle"
  _switch = "sw_red"

  switch_h = 64
  switch = "SW1HOT"
  side = "SP_HOT1"
  base = "SP_HOT1"
  x_offset = 0
  y_offset = 50
  special = 103
}

Door_SW_pink =
{
  _prefab = "DOOR"
  _where  = "edge"
  _switch = "sw_pink"
  _long   = 256
  _deep   = 48

  door_w = 128
  door_h = 112

  key = "SKINFACE"
  door = "BIGDOOR4"
  door_c = "FLOOR7_2"
  step = "SKINFACE"
  track = "DOORTRAK"
  frame = "SKINFACE"
  door_h = 112
  special = 0
}

Door_SW_pink_NAR =
{
  _copy = "Door_SW_pink"
  _narrow = 1

  door_w = 64
  door_h = 72
  door   = "DOOR1"
  door_c = "FLAT23"
}

Switch_pink1 =
{
  _prefab = "SMALL_SWITCH"
  _where  = "middle"
  _switch = "sw_pink"

  switch_h = 64
  switch = "SW1SKIN"
  side = "SKIN2"
  base = "SKIN2"
  x_offset = 0
  y_offset = 50
  special = 103
}

Door_SW_vine =
{
  _prefab = "DOOR"
  _where  = "edge"
  _switch = "sw_vine"
  _long   = 256
  _deep   = 48

  door_w = 128
  door_h = 112

  key = "GRAYVINE"
  door = "BIGDOOR4"
  door_c = "FLOOR7_2"
  step = "GRAYVINE"
  track = "DOORTRAK"
  frame = "FLAT1"
  door_h = 112
  special = 0
}

Door_SW_vine_NAR =
{
  _copy = "Door_SW_vine"
  _narrow = 1

  door_w = 64
  door_h = 72
  door   = "DOOR1"
  door_c = "FLAT23"
}

Switch_vine1 =
{
  _prefab = "SMALL_SWITCH"
  _where  = "middle"
  _switch = "sw_vine"

  switch_h = 64
  switch = "SW1VINE"
  side = "GRAYVINE"
  base = "GRAYVINE"
  x_offset = 0
  y_offset = 62
  special = 103
}

Hall_Thin_I =
{
  _prefab = "HALL_THIN_I"
  _shape  = "I"
}

Hall_Thin_C =
{
  _prefab = "HALL_THIN_C"
  _shape  = "C"
}

Hall_Thin_T =
{
  _prefab = "HALL_THIN_T"
  _shape  = "T"

  lamp_ent = "lamp"
}

-- TODO: Hall_Thin_P

Hall_Thin_I_Bend =
{
  _prefab = "HALL_THIN_I_BEND"
  _shape  = "I"
}

Hall_Thin_I_Bulge =
{
  _prefab = "HALL_THIN_I_BULGE"
  _shape  = "I"
  _long   = 192
  _deep   = { 192,384 }
  _in_between = 1

  lamp = "TLITE6_1"
}

Hall_Thin_P_Oh =
{
  _prefab = "HALL_THIN_OH"
  _shape  = "P"
  _long   = 384
  _deep   = 384
  _in_between = 1

  pillar = { WOODMET1=70, TEKLITE=20, SLADWALL=20 }
  niche  = "DOORSTOP"

  torch_ent = { red_torch_sm=50, green_torch_sm=10 }

  effect = 17
}

Hall_Thin_I_Oh =
{
  _copy  = "Hall_Thin_P_Oh"
  _shape = "I"

  east_h = 128
  west_h = 128
}

Hall_Thin_C_Oh =
{
  _copy  = "Hall_Thin_P_Oh"
  _shape = "C"

  east_h  = 128
  north_h = 128
}

Hall_Thin_T_Oh =
{
  _copy  = "Hall_Thin_P_Oh"
  _shape = "T"

  north_h = 128
}

Hall_Thin_I_Stair =
{
  _prefab = "HALL_THIN_I_STAIR"
  _shape  = "IS"

  step = "STEP1"
}

-- TODO: Hall_Thin_I_Lift


Hall_Cavey_I =
{
  _prefab = "HALL_CAVEY_I"
  _shape  = "I"
}

Hall_Cavey_C =
{
  _prefab = "HALL_CAVEY_C"
  _shape  = "C"
}

Hall_Cavey_T =
{
  _prefab = "HALL_CAVEY_T"
  _shape  = "T"
}

Hall_Cavey_P =
{
  _prefab = "HALL_CAVEY_P"
  _shape  = "P"
}

Hall_Cavey_I_Stair =
{
  _prefab = "HALL_CAVEY_I_STAIR"
  _shape  = "IS"
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

  support = "SUPPORT3"
  torch_ent = "green_torch_sm"
}

Sky_Hall_I_Stair =
{
  _prefab = "SKY_HALL_I_STAIR"
  _shape  = "IS"
  _need_sky = 1

  step = "STEP5"
}

Junc_Octo_I =
{
  _prefab = "JUNCTION_OCTO"
  _shape  = "I"

  hole = "_SKY"

  east_wall_q = 1
  west_wall_q = 1
}

Junc_Octo_C =
{
  _prefab = "JUNCTION_OCTO"
  _shape  = "C"

  hole = "_SKY"

  north_wall_q = 1
   east_wall_q = 1
}

Junc_Octo_T =
{
  _prefab = "JUNCTION_OCTO"
  _shape  = "T"

  hole = "_SKY"

  north_wall_q = 1
}

Junc_Octo_P =
{
  _prefab = "JUNCTION_OCTO"
  _shape  = "P"

  hole = "_SKY"

  -- leave all walls open
}

Junc_Nuke_Islands =
{
  _prefab = "JUNCTION_NUKEY_C"
  _shape  = "C"
  _liquid = 1
  _long   = { 576,576 }
  _deep   = { 576,576 }

  island = { FLOOR3_3=50, FLOOR0_3=50, MFLR8_2=10 }
  ceil   = { CEIL5_1=30, FLAT10=10, CEIL3_5=40, CEIL4_2=30 }

  support = "SUPPORT3"
  support_ox = 24

  lamp = { TLITE6_5=50, TLITE6_6=10, TLITE6_1=10, FLOOR1_7=5 }
}

Junc_Circle_tech_P =
{
  _prefab = "JUNCTION_CIRCLE"
  _shape  = "P"

  floor  = "CEIL3_5"
  circle = "CEIL3_3"
  step   = "STEP6"

  plinth = "TEKWALL4"
  plinth_top = "CEIL5_2"
  plinth_ent = "evil_eye"

  billboard = { COMPSTA2=50, COMPSTA1=10 }
  bill_side = "FLAT23"
  bill_oy   = 0

  torch_ent = "mercury_lamp"
}

Junc_Circle_tech_I =
{
  _copy  = "Junc_Circle_tech_P"
  _shape = "I"

  east_h = 0
  west_h = 0
}

Junc_Circle_tech_C =
{
  _copy  = "Junc_Circle_tech_P"
  _shape = "C"

  east_h = 0
  north_h = 0
}

Junc_Circle_tech_T =
{
  _copy  = "Junc_Circle_tech_P"
  _shape = "T"

  north_h = 0
}

Junc_Spokey_P =
{
  _prefab = "JUNCTION_SPOKEY"
  _shape  = "P"

  metal = "METAL"
  floor = "FLOOR0_3"
}

Junc_Spokey_I =
{
  _copy  = "Junc_Spokey_P"
  _shape = "I"

  east_h = 0
  west_h = 0
}

Junc_Spokey_C =
{
  _copy  = "Junc_Spokey_P"
  _shape = "C"

  east_h = 0
  north_h = 0
}

Junc_Spokey_T =
{
  _copy  = "Junc_Spokey_P"
  _shape = "T"

  north_h = 0
}

Junc_Nuke_Pipes_P =
{
  _prefab = "JUNCTION_NUKE_PIPES"
  _shape  = "P"

  main_wall = "BLAKWAL1"
  high_ceil = "CEIL4_1"
  low_ceil = "COMPSPAN"
  low_floor = "FLOOR7_1"  -- CEIL5_1

  trim = "METAL"
  lite = "LITE3"
  pipe = "METAL4"
}

Junc_Nuke_Pipes_I =
{
  _copy  = "Junc_Nuke_Pipes_P"
  _shape = "I"

  east_h = -24
  west_h = -24
}

Junc_Nuke_Pipes_C =
{
  _copy  = "Junc_Nuke_Pipes_P"
  _shape = "C"

  east_h  = -24
  north_h = -24
}

Junc_Nuke_Pipes_T =
{
  _copy  = "Junc_Nuke_Pipes_P"
  _shape = "T"

  north_h = -24
}

Junc_Ledge_T =
{
  _prefab = "JUNCTION_LEDGE_1"
  _shape  = "T"
  _heights = { 0,64,64,64 }
  _floors  = { "floor1", "floor2", "floor2", "floor2" }

  floor1 = "FLOOR0_1"
  ceil1  = "CEIL3_5"

  floor2 = "FLAT4"
  -- ceil2  = "FLAT5_3"
  low_trim = "GRAY7"
  high_trim = "GRAY7"

  support = "METAL2"
  step = "STEP1"
  top = "CEIL5_1"

  lamp_ent = "lamp"
}

Junc_Ledge_P =
{
  _copy = "Junc_Ledge_T"
  _shape  = "P"

  north_h = 64
}

Junc_Well_P =
{
  _prefab = "JUNCTION_WELL_1"
  _shape  = "P"
  _liquid = 1
  _heights = { 0,-84,84,168 }

  brick  = "BIGBRIK2"
  top    = "MFLR8_1"
  floor1 = "BIGBRIK1"
  step   = "ROCK3"

  gore_ent  = "skull_pole"

  torch_ent = { blue_torch_sm=50, blue_torch=50,
                red_torch_sm=10,  red_torch=10 }
}

Junc_Well_T =
{
  _copy = "Junc_Well_P"
  _shape  = "T"

  north_h = 296  -- closed
}

Junc_Well_I =
{
  _copy = "Junc_Well_P"
  _shape  = "I"

  east_h = 212  -- closed
  west_h =  44  --
}

Pic_Pill =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 256

  pic   = "O_PILL"
  pic_w = 128
  pic_h = 32

  light = 64
}

Pic_Neon =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 256

  pic   = "O_NEON"
  pic_w = 128
  pic_h = 128

  light = 64
  effect = 8
  fx_delta = -64
}

Pic_Silver3 =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 256

  pic   = "SILVER3"
  pic_w = 64
  pic_h = 96
  y_offset = 16

  light = 48
  effect = { [0]=90, [1]=5 }  -- sometimes blink
  fx_delta = -47
}

Pic_TekWall =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 256

  pic   = { TEKWALL1=50, TEKWALL4=50 }
  pic_w = 144
  pic_h = 128
  y_offset = 24

  light = 32
  scroll = 48
}

Pic_LiteGlow =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 64
  _repeat = 96

  pic   = "LITE3"
  pic_w = 32
  pic_h = 128

  light = 64
  effect = { [8]=90, [17]=5 }  -- sometimes flicker
  fx_delta = -63
}

Pic_LiteGlowBlue =
{
  _copy = "Pic_LiteGlow"

  pic = "LITEBLU4"
}

Pic_LiteFlash =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 64

  pic   = "LITE3"
  pic_w = 32
  pic_h = 128

  light = 64
  effect = { [1]=90, [2]=20 }
  fx_delta = -63
}

-- hellish --

Pic_FireWall =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 256

  pic   = "FIREWALL"
  pic_w = 128
  pic_h = 112

  light = 64
--  effect = 17
--  fx_delta = -16
}

Pic_MarbFace =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 256

  pic   = { MARBFAC2=50, MARBFAC3=50 }
  pic_w = 128
  pic_h = 128

  light = 16
}

Pic_DemonicFace =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 256

  pic   = "MARBFACE"
  pic_w = 128
  pic_h = 128

  light = 32
}

Pic_SkinScroll =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 256

  pic   = "SKINFACE"
  pic_w = 144
  pic_h = 80
  
  y_offset = 24

  light = 32
  scroll = 48
}

Pic_FaceScroll =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 256

  pic   = "SP_FACE1"
  pic_w = 144
  pic_h = 96

  light = 32
  scroll = 48
}

-- urban --

Pic_Adolf =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 256

  pic   = "ZZWOLF7"
  pic_w = 128
  pic_h = 128

  light = 16
}

Pic_Eagle =
{
  _copy = "Pic_Adolf"

  pic = "ZZWOLF6"
}

Pic_Wreath =
{
  _copy = "Pic_Adolf"

  pic = "ZZWOLF13"
}

Pic_MetalFace =
{
  _prefab = "PICTURE"
  _where  = "edge"
  _long   = 192

  pic   = { SW1SATYR=50, SW1GARG=50, SW1LION=50 }
  pic_w = 64
  pic_h = 72
  y_offset = 56

  light = 16
}

Pic_MetalFaceLit =
{
  _copy = "Pic_MetalFace"

  pic = { SW2SATYR=50, SW2GARG=50, SW2LION=50 }

  light = 32
}

Fat_Cage_W_Bars =
{
  _prefab = "FAT_CAGE_W_BARS"
  _where  = "chunk"

  bar = "METAL"
}

Pillar_2 =
{
  _prefab = "PILLAR_2"
  _where  = "middle"
  _radius = 40
---!!    _long   = 384
---!!    _deep   = 384

  base   = "GRAY1"
  pillar = "METAL"
}

RoundPillar =
{
  _prefab = "ROUND_PILLAR"
  _where  = "middle"
  _radius = 32

  pillar = "TEKLITE"
}

Crate1 =
{
  _prefab = "CRATE"
  _where  = "middle"
  _radius = 32

  crate = "CRATE1"
}

Crate2 =
{
  _prefab = "CRATE"
  _where  = "middle"
  _radius = 32

  crate = "CRATE2"
}

CrateWOOD =
{
  _prefab = "CRATE"
  _where  = "middle"
  _radius = 32

  crate = "WOOD3"
}

CrateICK =
{
  _prefab = "CRATE"
  _where  = "middle"
  _radius = 32

  crate = "ICKWALL4"
}
