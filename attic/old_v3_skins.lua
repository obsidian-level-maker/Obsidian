
V3_THEME_DEFAULTS =
{
  steps = { step1=50 }

  lifts = { shiny=20, platform=10, rusty=30 }

  logos = { carve=50, pill=50, neon=50 }

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


DOOM.PILLARS =
{
  teklite = { pillar="TEKLITE", trim1="GRAY7", trim2="METAL" }
  silver2 = { pillar="SILVER2", trim1="GRAY7", trim2="METAL" }
  shawn2  = { pillar="SHAWN2",  trim1="STARGR1", trim2="TEKWALL1" }

  big_red  = { pillar="REDWALL",  trim1="GRAY7", trim2="METAL" }
  big_blue = { pillar="LITEBLU4", trim1="GRAY7", trim2="METAL" }

  big_slad = { pillar="SLADWALL", trim1="GRAY7", trim2="METAL" }
  big_garg = { pillar="SW2GARG",  trim1="METAL", trim2="FLAT1" }
  big_wood6 = { pillar="WOOD6",   trim1="GRAY7", trim2="METAL" }

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
