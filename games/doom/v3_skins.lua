
V3_THEME_DEFAULTS =
{
  doors = { wooden=15, wooden_fast=2, wooden_once=6
            wooden2=30, wooden2_fast=2 }

  steps = { step1=50 }

  lifts = { shiny=20, platform=10, rusty=30 }

  outer_fences = { BROWN144=50, STONE2=30, BROWNHUG=10
                   BROVINE2=10, GRAYVINE=10, ICKWALL3=2
                   GRAY1=10, STONE=20
                 }

  logos = { carve=50, pill=50, neon=50 }

  pictures = { tekwall4=10 }

  -- FIXME: should not be separated (environment = "liquid" ??)
  liquid_pics = { pois1=70, pois2=30 }

  crates = { crate1=50, crate2=50, }

  -- FIXME: should not be separated, have 'environment' fields
  out_crates = { wood=50, ick=50 }

  -- FIXME: next three should not be separated
  exits = { demon_pillar2=50 }
  small_exits = { tech_small=50 }
  out_exits = { tech_outdoor=50 }

  keys = { kc_red=50, kc_blue=50, kc_yellow=50 }
  switches = { sw_blue=50, sw_hot=50, sw_marble=50, sw_wood=50 }
  bars = { bar_silver=50 }

  -- MISC STUFF : these don't quite fit in yet --  (FIXME)

  periph_pillar_mat = "SUPPORT3"
  beam_mat = "METAL"
  light_trim = "METAL"
  corner_supports = { SUPPORT2=50, SUPPORT3=10 }
  ceiling_trim = "METAL"
  ceiling_spoke = "SHAWN2"
  teleporter_mat = "GATE3"
  raising_start_switch = "SW1COMP"
  pedestal_mat = "CEIL1_2"
  hall_trim1 = "GRAY7"
  hall_trim2 = "METAL"
  window_side_mat = "DOORSTOP"
  track_mat = "DOORTRAK"

  lowering_pedestal_skin =
  {
    wall="WOOD3", floor="CEIL1_3"
    x_offset=0, y_offset=0, peg=1
    line_kind=23
  }

  lowering_pedestal_skin2 =
  {
    wall="PIPEWAL1", floor="CEIL1_2"
    x_offset=0, y_offset=0, peg=1
    line_kind=23
  }

}


DOOM.STEPS =
{
  step1 = { step_w="STEP1", side_w="BROWNHUG", top_f="FLOOR7_1" }
  step2 = { step_w="STEP2", side_w="BROWN1",   top_f="FLAT5" }
  step3 = { step_w="STEP3", side_w="COMPSPAN", top_f="CEIL5_1" }
  step4 = { step_w="STEP4", side_w="STONE",    top_f="FLAT5_4" }

  -- Doom II only --
  step4b = { step_w="STEP4", side_w="STONE4",   top_f="FLAT1" }
  step6  = { step_w="STEP6", side_w="STUCCO",   top_f="FLAT5" }
}


DOOM.LIFTS =
{
  shiny = 
  {
    side_w="SUPPORT2", top_f="FLAT20"
    walk_kind=88, switch_kind=62
  }

  rusty = 
  {
    side_w="SUPPORT3", top_f="CEIL5_2"
    walk_kind=88, switch_kind=62
  }

  platform = 
  {
    side_w="PLAT1", top_f="FLAT23"
    walk_kind=88, switch_kind=62
  }

  spine = 
  {
    side_w="SKSPINE1", -- top_f="FLAT23"
    walk_kind=88, switch_kind=62
  }
}

OLD_LIFT_JUNK =
{
  slow = { kind=62,  walk=88  }
  fast = { kind=123, walk=120 }
}


DOOM.PICTURES =
{
  -- Note: this includes pictures that only work on DOOM1 or DOOM2.
  -- It is not a problem, because the game-specific sub-themes will
  -- only reference the appropriate entries.

  compsta1 =
  {
    pic_w="COMPSTA1", width=128, height=52
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8
  }

  compsta2 =
  {
    pic_w="COMPSTA2", width=128, height=52
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8
  }

  compsta1_blink =
  {
    pic_w="COMPSTA1", width=128, height=52
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8, sec_kind=1
  }

  compsta2_blink =
  {
    pic_w="COMPSTA2", width=128, height=52
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8, sec_kind=1
  }

  lite5 =
  {
    count=3, gap=32
    pic_w="LITE5", width=16, height=64
    x_offset=0, y_offset=0
    side_t="DOORSTOP", floor="SHAWN2", depth=8
    light=0.9, sec_kind=8,  -- oscillate
  }

  lite5_05blink =
  {
    count=3, gap=32
    pic_w="LITE5", width=16, height=64
    x_offset=0, y_offset=0
    side_t="DOORSTOP", floor="SHAWN2", depth=8
    light=0.9, sec_kind=12,  -- 0.5 second sync
  }

  lite5_10blink =
  {
    count=4, gap=24
    pic_w="LITE5", width=16, height=48
    x_offset=0, y_offset=0
    side_t="DOORSTOP", floor="SHAWN2", depth=8
    light=0.9, sec_kind=13,  -- 1.0 second sync
  }

  liteblu4 =
  {
    count=3, gap=32
    pic_w="LITEBLU4", width=16, height=64
    x_offset=0, y_offset=0
    side_t="LITEBLU4", floor="FLAT14", depth=8
    light=0.9, sec_kind=8
  }

  liteblu4_05sync =
  {
    count=3, gap=32
    pic_w="LITEBLU4", width=16, height=64
    x_offset=0, y_offset=0
    side_t="LITEBLU4", floor="FLAT14", depth=8
    light=0.9, sec_kind=12
  }

  liteblu4_10sync =
  {
    count=4, gap=32
    pic_w="LITEBLU4", width=16, height=48
    x_offset=0, y_offset=0
    side_t="LITEBLU4", floor="FLAT14", depth=8
    light=0.9, sec_kind=13
  }

  litered =
  {
    count=3, gap=32
    pic_w="LITERED", width=16, height=64
    x_offset=0, y_offset=0
    side_t="DOORSTOP", floor="SHAWN2", depth=16
    light=0.9, sec_kind=8,  -- oscillate
  }

  redwall =
  {
    count=2, gap=48
    pic_w="REDWALL", width=16, height=128, raise=20
    x_offset=0, y_offset=0
    side_t="REDWALL", floor="FLAT5_3", depth=8
    light=0.99, sec_kind=8
  }

  silver3 =
  {
    count=1, gap=32
    pic_w="SILVER3", width=64, height=96
    x_offset=0, y_offset=16
    side_t="DOORSTOP", floor="SHAWN2", depth=8
    light=0.8
  }

  shawn1 =
  {
    count=1
    pic_w="SHAWN1", width=128, height=72
    x_offset=-4, y_offset=0
    side_t="DOORSTOP", floor="SHAWN2", depth=8
  }

  pill =
  {
    count=1
    pic_w="O_PILL", width=128, height=32, raise=16
    x_offset=0, y_offset=0
    side_t="METAL", floor="CEIL5_2", depth=8
    light=0.7
  }

  carve =
  {
    count=1
    pic_w="O_CARVE", width=64, height=64
    x_offset=0, y_offset=0
    side_t="METAL", floor="CEIL5_2", depth=8
    light=0.7
  }

  neon =
  {
    count=1
    pic_w="O_NEON", width=128, height=128
    x_offset=0, y_offset=0
    side_t="METAL", floor="CEIL5_2", depth=16
    light=0.99, sec_kind=8
  }

  tekwall1 =
  {
    count=1
    pic_w="TEKWALL1", width=160, height=80
    x_offset=0, y_offset=24
    side_t="METAL", floor="CEIL5_2", depth=8
    line_kind=48, -- scroll left
    light=0.7
  }

  tekwall4 =
  {
    count=1
    pic_w="TEKWALL4", width=128, height=80
    x_offset=0, y_offset=24
    side_t="METAL", floor="CEIL5_2", depth=8
    line_kind=48, -- scroll left
    light=0.7
  }

  pois1 =
  {
    count=2, gap=32
    pic_w="BRNPOIS", width=64, height=56
    x_offset=0, y_offset=48
    side_t="METAL", floor="CEIL5_2"
    depth=8, light=0.5
  }

  pois2 =
  {
    count=1, gap=32
    pic_w="GRAYPOIS", width=64, height=64
    x_offset=0, y_offset=0
    side_t="DOORSTOP", floor="SHAWN2"
    depth=8, light=0.5
  }

  eagle1 =
  {
    count=1
    pic_w="ZZWOLF6", width=128, height=128
    x_offset=0, y_offset=0
    side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.57
  }

  hitler1 =
  {
    count=1
    pic_w="ZZWOLF7", width=128, height=128
    x_offset=0, y_offset=0
    side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.57
  }

  marbface =
  {
    count=1
    pic_w="MARBFACE", width=128, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.57
  }

  marbfac2 =
  {
    count=1
    pic_w="MARBFAC2", width=128, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.57
  }

  marbfac3 =
  {
    count=1
    pic_w="MARBFAC3", width=128, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.57
  }

  skinface =
  {
    count=1
    pic_w="SKINFACE", width=160, height=80
    x_offset=0, y_offset=24
    -- side_t="METAL", floor="CEIL5_2"
    depth=8
    line_kind=48, -- scroll left
    light=0.7
  }

  spface1 =
  {
    count=1
    pic_w="SP_FACE1", width=160, height=96
    x_offset=0, y_offset=0
    -- side_t="METAL", floor="CEIL5_2"
    depth=8
    line_kind=48, -- scroll left
    light=0.7
  }

  firewall =
  {
    count=1
    pic_w="FIREWALL", width=128, height=112
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.9
  }

  planet1 =
  {
    pic_w="PLANET1", width=192, height=128
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8
  }

  planet1_blink =
  {
    pic_w="PLANET1", width=192, height=128
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8, sec_kind=1
  }

  compute1 =
  {
    pic_w="COMPUTE1", width=128, height=128
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8
  }

  compute1_blink =
  {
    pic_w="COMPUTE1", width=128, height=128
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8, sec_kind=1
  }

  compute2 =
  {
    pic_w="COMPUTE2", width=192, height=56
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8
  }

  compute2_blink =
  {
    pic_w="COMPUTE2", width=192, height=56
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8, sec_kind=1
  }

  skulls1 =
  {
    count=1
    pic_w="SKULWALL", width=128, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.67
  }

  skulls2 =
  {
    count=1
    pic_w="SKULWAL3", width=128, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.67
  }

  spacewall =
  {
    pic_w="SPACEW3", width=64, height=128
    x_offset=0, y_offset=0
    side_t="DOORSTOP", depth=8
    floor="SHAWN2", light=0.8
  }

  spdude1 =
  {
    count=1
    pic_w="SP_DUDE1", width=128, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.67
  }

  spdude2 =
  {
    count=1
    pic_w="SP_DUDE2", width=128, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.67
  }

  spdude3 =
  {
    count=1
    pic_w="SP_DUDE3", width=64, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.67
  }

  spdude4 =
  {
    count=1
    pic_w="SP_DUDE4", width=64, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.67
  }

  spdude5 =
  {
    count=1
    pic_w="SP_DUDE5", width=64, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.67
  }

  spdude6 =
  {
    count=1
    pic_w="SP_DUDE6", width=64, height=128
    x_offset=0, y_offset=0
    -- side_t="WOODVERT", floor="FLAT5_2"
    depth=8, light=0.67
  }

  spdude7 =
  {
    count=1
    pic_w="SP_DUDE7", width=128, height=128
    x_offset=0, y_offset=0
    side_t="METAL", floor="RROCK03"
    depth=8, light=0.67
  }

  spine =
  {
    count=1
    pic_w="SKSPINE2", width=160, height=70
    x_offset=0, y_offset=24
    -- side_t="METAL", floor="CEIL5_2"
    depth=8
    line_kind=48, -- scroll left
    light=0.7
  }

}


DOOM.PILLARS =
{
  teklite = { pillar="TEKLITE", trim1="GRAY7", trim2="METAL" }
  silver2 = { pillar="SILVER2", trim1="GRAY7", trim2="METAL" }
  shawn2  = { pillar="SHAWN2",  trim1="STARGR1", trim2="TEKWALL1" }

  big_red  = { pillar="REDWALL",  trim1="GRAY7", trim2="METAL" }
  big_blue = { pillar="LITEBLU4", trim1="GRAY7", trim2="METAL" }

  tekwall4 = { pillar="TEKWALL4", trim1="GRAY7", trim2="METAL1" }
  metal1   = { pillar="METAL1",   trim1="GRAY7", trim2="METAL" }
  blue1    = { pillar="COMPBLUE", trim1="SHAWN2", trim2="TEKWALL1" }

  marble1 = { pillar="MARBLE1",  trim1="GSTONE1", trim2="MARBLE2" }
  redwall = { pillar="REDWALL",  trim1="SP_HOT1", trim2="SP_HOT1" }
  sloppy  = { pillar="SLOPPY1",  trim1="MARBLE1", trim2="METAL" }
  sloppy2 = { pillar="SP_FACE2", trim1="MARBLE1", trim2="METAL" }
}


DOOM.CRATES =  -- temporary (until good prefab system)
{
  crate1 = { side_w="CRATE1", top_f="CRATOP2" }
  crate2 = { side_w="CRATE2", top_f="CRATOP1" }
  
  space = { side_w="SPACEW3",  top_f="CEIL5_1" }
  comp  = { side_w="COMPWERD", top_f="CEIL5_1" }
  mod   = { side_w="MODWALL3", top_f="FLAT19" }
  lite5 = { side_w="LITE5",    top_f="FLAT19" }

  wood = { side_w="WOOD3",    top_f="CEIL1_1" }
  ick  = { side_w="ICKWALL4", top_f="FLAT19" }
}


DOOM.DOORS =
{
  --- NORMAL DOORS ---

  silver =
  {
    w=128, h=112, door_h=72
    key_w="LITE3"
    door_w="BIGDOOR1", door_c="FLAT1"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=1, tag=0
  }

  silver_fast =
  {
    w=128, h=112, door_h=72
    key_w="LITE3"
    door_w="BIGDOOR1", door_c="FLAT1"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=117, tag=0
  }

  silver_once =
  {
    w=128, h=112, door_h=72
    key_w="LITE3"
    door_w="BIGDOOR1", door_c="FLAT1"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=31, tag=0
  }

  wooden =
  {
    w=128, h=112, door_h=112
    door_w="BIGDOOR6", door_c="FLAT5_2"
    lite_w="LITE5", step_w="STEP1"
    frame_f="FLAT1", frame_c="FLAT1"
    track="DOORTRAK"
    key_w="BRICKLIT", key_ox=20, key_oy=-16
    line_kind=1, tag=0
  }

  wooden2 =
  {
    w=128, h=112, door_h=112
    door_w="BIGDOOR5", door_c="FLAT5_2"
    lite_w="LITE5", step_w="STEP1"
    frame_f="FLAT1", frame_c="FLAT1"
    track="DOORTRAK"
    key_w="BRICKLIT", key_ox=20, key_oy=-16
    line_kind=1, tag=0
  }

  wooden_fast =
  {
    w=128, h=112, door_h=112
    door_w="BIGDOOR6", door_c="FLAT5_2"
    lite_w="LITE5", step_w="STEP1"
    frame_f="FLAT1", frame_c="FLAT1"
    track="DOORTRAK"
    key_w="BRICKLIT", key_ox=20, key_oy=-16
    line_kind=117, tag=0
  }

  wooden2_fast =
  {
    w=128, h=112, door_h=112
    door_w="BIGDOOR5", door_c="FLAT5_2"
    lite_w="LITE5", step_w="STEP1"
    frame_f="FLAT1", frame_c="FLAT1"
    track="DOORTRAK"
    key_w="BRICKLIT", key_ox=20, key_oy=-16
    line_kind=117, tag=0
  }

  wooden_once =
  {
    w=128, h=112, door_h=112
    door_w="BIGDOOR6", door_c="FLAT5_2"
    lite_w="LITE5", step_w="STEP1"
    frame_f="FLAT1", frame_c="FLAT1"
    track="DOORTRAK"
    key_w="BRICKLIT", key_ox=20, key_oy=-16
    line_kind=31, tag=0
  }

  wooden2_once =
  {
    w=128, h=112, door_h=112
    door_w="BIGDOOR5", door_c="FLAT5_2"
    lite_w="LITE5", step_w="STEP1"
    frame_f="FLAT1", frame_c="FLAT1"
    track="DOORTRAK"
    key_w="BRICKLIT", key_ox=20, key_oy=-16
    line_kind=31, tag=0
  }

  bigdoor2 =
  {
    w=128, h=112, door_h=112
    key_w="LITE3"
    door_w="BIGDOOR2", door_c="FLAT23"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=1, tag=0
  }

  bigdoor2_fast =
  {
    w=128, h=112, door_h=112
    key_w="LITE3"
    door_w="BIGDOOR2", door_c="FLAT23"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=117, tag=0
  }

  bigdoor2_once =
  {
    w=128, h=112, door_h=112
    key_w="LITE3"
    door_w="BIGDOOR2", door_c="FLAT23"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=31, tag=0
  }

  bigdoor4 =
  {
    w=128, h=112, door_h=112
    key_w="LITEBLU1", key_oy=56
    door_w="BIGDOOR4", door_c="FLOOR7_1"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=1, tag=0
  }

  bigdoor4_fast =
  {
    w=128, h=112, door_h=112
    key_w="LITEBLU1", key_oy=56
    door_w="BIGDOOR4", door_c="FLOOR7_1"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=117, tag=0
  }

  bigdoor4_once =
  {
    w=128, h=112, door_h=112
    key_w="LITEBLU1", key_oy=56
    door_w="BIGDOOR4", door_c="FLOOR7_1"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=31, tag=0
  }

  bigdoor3 =
  {
    w=128, h=112, door_h=112
    key_w="LITE3"
    door_w="BIGDOOR3", door_c="FLOOR7_2"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=1, tag=0
  }

  wolf_door =
  {
    w=128, h=112, door_h=128
    key_w="DOORSTOP"
    door_w="ZDOORB1", door_c="FLAT23"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=1, tag=0
  }

  secret_door =
  {
    w=128, h=112, door_h=128
    key_w="DOORSTOP"
    door_w="ZELDOOR", door_c="FLAT23"
    step_w="STEP4"
    frame_c="FLAT18", track="DOORTRAK"
    line_kind=117, tag=0
  }


  --- LOCKED DOORS ---

  kc_blue =
  {
    w=128, h=112, door_h=112
    key_w="DOORBLU"
    door_w="BIGDOOR3", door_c="FLOOR7_2"
    step_w="STEP4",  track="DOORTRAK"
    frame_c="FLAT18"
    line_kind=32, tag=0,  -- kind_mult=26
  }

  kc_yellow =
  {
    w=128, h=112, door_h=112
    key_w="DOORYEL"
    door_w="BIGDOOR4", door_c="FLOOR3_3"
    step_w="STEP4",  track="DOORTRAK"
    frame_c="FLAT4"
    line_kind=34, tag=0, -- kind_mult=27
  }

  kc_red =
  {
    w=128, h=112

    key_w="DOORRED", door_h=112
    door_w="BIGDOOR2", door_c="FLAT1"
    step_w="STEP4",  track="DOORTRAK"
    frame_c="FLAT18"
    line_kind=33, tag=0, -- kind_mult=28
  }

  ks_blue =
  {
    w=128, h=112, door_h=112
    key_w="DOORBLU2", key_ox=4, key_oy=-10
    door_w="BIGDOOR7", door_c="FLOOR7_2"
    step_w="STEP4",  track="DOORTRAK"
    frame_c="FLAT18"
    line_kind=32, tag=0,  -- kind_mult=26
  }

  ks_yellow =
  {
    w=128, h=112, door_h=112
    key_w="DOORYEL2", key_ox=4, key_oy=-10
    door_w="BIGDOOR7", door_c="FLOOR3_3"
    step_w="STEP4",  track="DOORTRAK"
    frame_c="FLAT4"
    line_kind=34, tag=0, -- kind_mult=27
  }

  ks_red =
  {
    w=128, h=112, door_h=112
    key_w="DOORRED2", key_ox=4, key_oy=-10
    door_w="BIGDOOR7", door_c="FLAT1"
    step_w="STEP4",  track="DOORTRAK"
    frame_c="FLAT18"
    line_kind=33, tag=0, -- kind_mult=28
  }


  --- SWITCHED DOORS ---

  sw_blue =
  {
    w=128, h=112

    key_w="COMPBLUE"
    door_w="BIGDOOR3", door_c="FLOOR7_2"
    step_w="COMPBLUE",  track="DOORTRAK"
    frame_c="FLAT14"
    door_h=112
    line_kind=0
  }

  sw_hot =
  {
    w=128, h=112

    key_w="REDWALL"
    door_w="BIGDOOR2", door_c="FLAT1"
    step_w="REDWALL",  track="DOORTRAK"
    frame_c="FLAT5_3"
    door_h=112
    line_kind=0
  }

  sw_skin =
  {
    w=128, h=112

    key_w="SKINFACE"
    door_w="BIGDOOR4", door_c="FLOOR7_2"
    step_w="SKINFACE", track="DOORTRAK"
    frame_c="SKINFACE"
    door_h=112
    line_kind=0
  }

  sw_vine =
  {
    w=128, h=112

    key_w="GRAYVINE"
    door_w="BIGDOOR4", door_c="FLOOR7_2"
    step_w="GRAYVINE", track="DOORTRAK"
    frame_c="FLAT1"
    door_h=112
    line_kind=0
  }

  sw_wood =
  {
    w=128, h=112

    key_w="WOOD1"
    door_w="BIGDOOR7", door_c="CEIL5_2"
    step_w="WOOD1",  track="DOORTRAK"
    frame_c="FLAT5_2"
    door_h=112
    line_kind=0
  }

  sw_marble =
  {
    w=128, h=112

    key_w="GSTONE1"
    door_w="BIGDOOR2", door_c="FLAT1"
    step_w="GSTONE1",  track="DOORTRAK"
    frame_c="FLOOR7_2"
    door_h=112
    line_kind=0
  }

  bar_wood =
  {
    bar_w="WOOD9"
    bar_f="FLAT5_2"
    bar_h=64
    line_kind=0
  }

  bar_silver =
  {
    bar_w="SUPPORT2"
    bar_h=64
    line_kind=0
  }

  bar_metal =
  {
    bar_w="SUPPORT3"
    bar_h=64
    line_kind=0
  }

  bar_gray =
  {
    bar_w="GRAY7", bar_f="FLAT19"
    bar_h=64
    line_kind=0
  }
}


DOOM.EXITS =
{
  skull_pillar =
  {
    h=128
    switch_w="SW1SKULL"
    exit_w="EXITSIGN", exit_h=16
    exitside="COMPSPAN"
  }

  demon_pillar2 =
  {
    h=128
    switch_w="SW1SATYR"
    exit_w="EXITSIGN", exit_h=16
    exitside="COMPSPAN"
  }

  demon_pillar3 =
  {
    h=128
    switch_w="SW1LION"
    exit_w="EXITSIGN", exit_h=16
    exitside="COMPSPAN"
  }

  skin_pillar =
  {
    h=128
    switch_w="SW1SKIN"
    exit_w="EXITSIGN", exit_h=16
    exitside="COMPSPAN"
  }

  stone_pillar =
  {
    h=128
    switch_w="SW1STON1"
    exit_w="EXITSIGN", exit_h=16
    exitside="COMPSPAN"
  }

  tech_outdoor =
  {
    podium="CEIL5_1", base="SHAWN2"
    switch_w="SW1COMM", exit_w="EXITSIGN"
  }

  tech_outdoor2 =
  {
    podium="STARTAN2", base="SHAWN2"
    switch_w="SW2COMM", exit_w="EXITSIGN"
  }

  tech_small =
  {
    door = "EXITDOOR", track = "DOORTRAK"
    exit = "EXITSIGN", exitside = "SHAWN2"
    frame_c = "FLAT1", key_w = "LITE5"
    break_w = "DOORSTOP"
    items = { "medikit" }
  }

}


DOOM.SWITCHES =
{
  sw_blue =
  {
    prefab = "SWITCH_FLOOR"
    skin =
    {
      switch_w="SW1BLUE", side_w="COMPBLUE"
      switch_f="FLAT14", switch_h=64

      beam_w="WOOD1", beam_f="FLAT5_2"

      x_offset=0, y_offset=56, line_kind=103
    }
  }

  sw_blue2 =
  {
    prefab = "SWITCH_FLOOR_BEAM"
    skin =
    {
      switch_w="SW1BLUE", side_w="COMPBLUE"
      switch_f="FLAT14", switch_h=64

      beam_w="WOOD1", beam_f="FLAT5_2"

      x_offset=0, y_offset=56, line_kind=103
    }
  }

  sw_hot =
  {
    prefab = "SWITCH_PILLAR"
    skin =
    {
      switch_w="SW1HOT", side_w="SP_HOT1"
      switch_f="FLAT5_3"
      x_offset=0, y_offset=52
      line_kind=103
    }

  }

  sw_skin =
  {
    prefab = "SWITCH_PILLAR"
    skin =
    {
      switch_w="SW1SKIN", side_w="SKSNAKE2"
      switch_f="SFLR6_4"
      x_offset=0, y_offset=52
      line_kind=103
    }
  }

  sw_vine =
  {
    prefab = "SWITCH_PILLAR"
    skin =
    {
      switch_w="SW1VINE", side_w="GRAYVINE"
      switch_f="FLAT1"
      x_offset=0, y_offset=64
      line_kind=103
    }
  }

  sw_metl =
  {
    prefab = "SWITCH_CEILING"
    environment = "indoor"
    skin =
    {
      switch_w="SW1GARG", side_w="METAL"
      switch_c="CEIL5_2", switch_h=56

      beam_w="SUPPORT3", beam_c="CEIL5_2"

      x_offset=0, y_offset=64, line_kind=23
    }
  }

  sw_wood =
  {
    prefab = "SWITCH_PILLAR"
    skin =
    {
      switch_w="SW1WOOD", side_w="WOOD1"
      switch_f="FLAT5_2"
      x_offset=0, y_offset=56
      line_kind=103
    }
  }

  sw_marble =
  {
    prefab = "SWITCH_PILLAR"
    skin =
    {
      switch_w="SW1GSTON", side_w="GSTONE1"
      switch_f="FLOOR7_2"
      x_offset=0, y_offset=56
      line_kind=103
    }
  }

  bar_wood =
  {
    prefab = "SWITCH_PILLAR"
    skin =
    {
      switch_w="SW1WOOD", side_w="WOOD9"
      switch_f="FLAT5_2"
      x_offset=0, y_offset=56
      line_kind=23
    }
  }

  bar_silver =
  {
    prefab = "SWITCH_PILLAR"
    skin =
    {
      switch_w="SW1COMM", side_w="SHAWN2"
      switch_f="FLAT23"
      x_offset=0, y_offset=0
      line_kind=23
    }
  }

  bar_metal =
  {
    prefab = "SWITCH_PILLAR"
    skin =
    {
      switch_w="SW1MET2", side_w="METAL2"
      switch_f="CEIL5_2"
      x_offset=0, y_offset=0
      line_kind=23
    }
  }

  bar_gray =
  {
    prefab = "SWITCH_PILLAR"
    skin =
    {
      switch_w="SW1GRAY1", side_w="GRAY1"
      switch_f="FLAT1"
      x_offset=0, y_offset=64
      line_kind=23
    }
  }

}
