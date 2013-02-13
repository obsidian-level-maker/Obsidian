DOOM.STEPS =  -- OLD ??
{
  step1 = { step="STEP1", side="BROWNHUG", top="FLOOR7_1" }
  step2 = { step="STEP2", side="BROWN1",   top="FLAT5" }
  step3 = { step="STEP3", side="COMPSPAN", top="CEIL5_1" }
  step4 = { step="STEP4", side="STONE",    top="FLAT5_4" }

  -- Doom II only --
  step4b = { step="STEP4", side="STONE4",   top="FLAT1" }
  step6  = { step="STEP6", side="STUCCO",   top="FLAT5" }
}


DOOM.LIFTS =  -- OLD CRUD
{
  shiny = 
  {
    lift="SUPPORT2", top="FLAT20",
    walk_kind=88, switch_kind=62,
  }

  rusty = 
  {
    lift="SUPPORT3", top="CEIL5_2",
    walk_kind=88, switch_kind=62,
  }

  platform = 
  {
    lift="PLAT1", top="FLAT23",
    walk_kind=88, switch_kind=62,
  }

  spine = 
  {
    lift="SKSPINE1", top="FLAT23",
    walk_kind=88, switch_kind=62,
  }
}

OLD_LIFT_JUNK =
{
  slow = { kind=62,  walk=88  }
  fast = { kind=123, walk=120 }
}


DOOM.PICTURES =  -- Note: UNUSED STUFF
{
  -- Note: this includes pictures that only work on DOOM1 or DOOM2.
  -- It is not a problem, because the game-specific sub-themes will
  -- only reference the appropriate entries.

  compsta1 =
  {
    pic="COMPSTA1", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  compsta2 =
  {
    pic="COMPSTA2", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  compsta1_blink =
  {
    pic="COMPSTA1", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  }

  compsta2_blink =
  {
    pic="COMPSTA2", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  }

  lite5 =
  {
    count=3, gap=32,
    pic="LITE5", width=16, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.9, sec_kind=8,  -- oscillate
  }

  lite5_05blink =
  {
    count=3, gap=32,
    pic="LITE5", width=16, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.9, sec_kind=12,  -- 0.5 second sync
  }

  lite5_10blink =
  {
    count=4, gap=24,
    pic="LITE5", width=16, height=48,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.9, sec_kind=13,  -- 1.0 second sync
  }

  liteblu4 =
  {
    count=3, gap=32,
    pic="LITEBLU4", width=16, height=64,
    x_offset=0, y_offset=0,
    side="LITEBLU4", floor="FLAT14", depth=8, 
    light=0.9, sec_kind=8,
  }

  liteblu4_05sync =
  {
    count=3, gap=32,
    pic="LITEBLU4", width=16, height=64,
    x_offset=0, y_offset=0,
    side="LITEBLU4", floor="FLAT14", depth=8, 
    light=0.9, sec_kind=12,
  }

  liteblu4_10sync =
  {
    count=4, gap=32,
    pic="LITEBLU4", width=16, height=48,
    x_offset=0, y_offset=0,
    side="LITEBLU4", floor="FLAT14", depth=8, 
    light=0.9, sec_kind=13,
  }

  litered =
  {
    count=3, gap=32,
    pic="LITERED", width=16, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=16, 
    light=0.9, sec_kind=8,  -- oscillate
  }

  redwall =
  {
    count=2, gap=48,
    pic="REDWALL", width=16, height=128, raise=20,
    x_offset=0, y_offset=0,
    side="REDWALL", floor="FLAT5_3", depth=8, 
    light=0.99, sec_kind=8,
  }

  silver3 =
  {
    count=1, gap=32,
    pic="SILVER3", width=64, height=96,
    x_offset=0, y_offset=16,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.8,
  }

  shawn1 =
  {
    count=1,
    pic="SHAWN1", width=128, height=72,
    x_offset=-4, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
  }

  pill =
  {
    count=1,
    pic="O_PILL", width=128, height=32, raise=16,
    x_offset=0, y_offset=0,
    side="METAL", floor="CEIL5_2", depth=8, 
    light=0.7,
  }

  carve =
  {
    count=1,
    pic="O_CARVE", width=64, height=64,
    x_offset=0, y_offset=0,
    side="METAL", floor="CEIL5_2", depth=8, 
    light=0.7,
  }

  neon =
  {
    count=1,
    pic="O_NEON", width=128, height=128,
    x_offset=0, y_offset=0,
    side="METAL", floor="CEIL5_2", depth=16, 
    light=0.99, sec_kind=8,
  }

  tekwall1 =
  {
    count=1,
    pic="TEKWALL1", width=160, height=80,
    x_offset=0, y_offset=24,
    side="METAL", floor="CEIL5_2", depth=8, 
    special=48, -- scroll left
    light=0.7,
  }

  tekwall4 =
  {
    count=1,
    pic="TEKWALL4", width=128, height=80,
    x_offset=0, y_offset=24,
    side="METAL", floor="CEIL5_2", depth=8, 
    special=48, -- scroll left
    light=0.7,
  }

  pois1 =
  {
    count=2, gap=32,
    pic="BRNPOIS", width=64, height=56,
    x_offset=0, y_offset=48,
    side="METAL", floor="CEIL5_2",
    depth=8, light=0.5,
  }

  pois2 =
  {
    count=1, gap=32,
    pic="GRAYPOIS", width=64, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2",
    depth=8, light=0.5,
  }

  eagle1 =
  {
    count=1,
    pic="ZZWOLF6", width=128, height=128,
    x_offset=0, y_offset=0,
    side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  }

  hitler1 =
  {
    count=1,
    pic="ZZWOLF7", width=128, height=128,
    x_offset=0, y_offset=0,
    side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  }

  marbface =
  {
    count=1,
    pic="MARBFACE", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  }

  marbfac2 =
  {
    count=1,
    pic="MARBFAC2", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  }

  marbfac3 =
  {
    count=1,
    pic="MARBFAC3", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  }

  skinface =
  {
    count=1,
    pic="SKINFACE", width=160, height=80,
    x_offset=0, y_offset=24,
    -- side="METAL", floor="CEIL5_2",
    depth=8, 
    special=48, -- scroll left
    light=0.7,
  }

  spface1 =
  {
    count=1,
    pic="SP_FACE1", width=160, height=96,
    x_offset=0, y_offset=0,
    -- side="METAL", floor="CEIL5_2",
    depth=8, 
    special=48, -- scroll left
    light=0.7,
  }

  firewall =
  {
    count=1,
    pic="FIREWALL", width=128, height=112,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.9,
  }

  planet1 =
  {
    pic="PLANET1", width=192, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  planet1_blink =
  {
    pic="PLANET1", width=192, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  }

  compute1 =
  {
    pic="COMPUTE1", width=128, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  compute1_blink =
  {
    pic="COMPUTE1", width=128, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  }

  compute2 =
  {
    pic="COMPUTE2", width=192, height=56,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  compute2_blink =
  {
    pic="COMPUTE2", width=192, height=56,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  }

  skulls1 =
  {
    count=1,
    pic="SKULWALL", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  skulls2 =
  {
    count=1,
    pic="SKULWAL3", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spacewall =
  {
    pic="SPACEW3", width=64, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  spdude1 =
  {
    count=1,
    pic="SP_DUDE1", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude2 =
  {
    count=1,
    pic="SP_DUDE2", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude3 =
  {
    count=1,
    pic="SP_DUDE3", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude4 =
  {
    count=1,
    pic="SP_DUDE4", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude5 =
  {
    count=1,
    pic="SP_DUDE5", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude6 =
  {
    count=1,
    pic="SP_DUDE6", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude7 =
  {
    count=1,
    pic="SP_DUDE7", width=128, height=128,
    x_offset=0, y_offset=0,
    side="METAL", floor="RROCK03",
    depth=8, light=0.67,
  }

  spine =
  {
    count=1,
    pic="SKSPINE2", width=160, height=70,
    x_offset=0, y_offset=24,
    -- side="METAL", floor="CEIL5_2",
    depth=8, 
    special=48, -- scroll left
    light=0.7,
  }

}


DOOM.PILLARS =  -- Note: UNUSED STUFF
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


DOOM.CRATES =  -- Note: UNUSED STUFF
{
  crate1 = { crate="CRATE1", x_offset=0, y_offset=0 }
  crate2 = { crate="CRATE2", x_offset=0, y_offset=0 }
  
  space = { crate="SPACEW3",  x_offset=0, y_offset=0 }
  comp  = { crate="COMPWERD", x_offset=0, y_offset=0 }
  mod   = { crate="MODWALL3", x_offset=0, y_offset=0 }
  lite5 = { crate="LITE5",    x_offset=0, y_offset=0 }

  wood = { crate="WOOD3",    x_offset=0, y_offset=0 }
  ick  = { crate="ICKWALL4", x_offset=0, y_offset=0 }
}


DOOM.DOORS =  -- Note: UNUSED STUFF
{
  --- NORMAL DOORS ---

  silver =
  {
    w=128, h=112, door_h=72,
    key="LITE3",
    door="BIGDOOR1", door_c="FLAT1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }

  silver_fast =
  {
    w=128, h=112, door_h=72,
    key="LITE3",
    door="BIGDOOR1", door_c="FLAT1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=117, tag=0,
  }

  silver_once =
  {
    w=128, h=112, door_h=72,
    key="LITE3",
    door="BIGDOOR1", door_c="FLAT1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=31, tag=0,
  }

  wooden =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR6", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=1, tag=0,
  }

  wooden2 =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR5", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=1, tag=0,
  }

  wooden_fast =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR6", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=117, tag=0,
  }

  wooden2_fast =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR5", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=117, tag=0,
  }

  wooden_once =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR6", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=31, tag=0,
  }

  wooden2_once =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR5", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=31, tag=0,
  }

  bigdoor2 =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR2", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }

  bigdoor2_fast =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR2", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=117, tag=0,
  }

  bigdoor2_once =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR2", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=31, tag=0,
  }

  bigdoor4 =
  {
    w=128, h=112, door_h=112,
    key="LITEBLU1", key_oy=56,
    door="BIGDOOR4", door_c="FLOOR7_1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }

  bigdoor4_fast =
  {
    w=128, h=112, door_h=112,
    key="LITEBLU1", key_oy=56,
    door="BIGDOOR4", door_c="FLOOR7_1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=117, tag=0,
  }

  bigdoor4_once =
  {
    w=128, h=112, door_h=112,
    key="LITEBLU1", key_oy=56,
    door="BIGDOOR4", door_c="FLOOR7_1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=31, tag=0,
  }

  bigdoor3 =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR3", door_c="FLOOR7_2",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }

  wolf_door =
  {
    w=128, h=112, door_h=128,
    key="DOORSTOP",
    door="ZDOORB1", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }

  wolf_elev_door =
  {
    w=128, h=112, door_h=128,
    key="DOORSTOP",
    door="ZELDOOR", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }


  --- SWITCHED DOORS ---

  sw_wood =
  {
    w=128, h=112,

    key="WOOD1",
    door="BIGDOOR7", door_c="CEIL5_2",
    step="WOOD1",
    track="DOORTRAK",
    frame="FLAT5_2",
    door_h=112,
    special=0,
  }

  sw_marble =
  {
    w=128, h=112,

    key="GSTONE1",
    door="BIGDOOR2", door_c="FLAT1",
    step="GSTONE1",
    track="DOORTRAK",
    frame="FLOOR7_2",
    door_h=112,
    special=0,
  }

  bar_wood =
  {
    bar="WOOD9",
  }

  bar_silver =
  {
    bar="SUPPORT2",
  }

  bar_metal =
  {
    bar="SUPPORT3",
  }

  bar_gray =
  {
    bar="GRAY7",
  }
} -- end of DOOM.DOORS


DOOM.EXITS =  -- Note: UNUSED STUFF
{
  skull_pillar =
  {
    h=128,
    switch="SW1SKULL",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    special=11,
  }

  demon_pillar2 =
  {
    h=128,
    switch="SW1SATYR",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    special=11,
  }

  demon_pillar3 =
  {
    h=128,
    switch="SW1LION",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    special=11,
  }

  skin_pillar =
  {
    h=128,
    switch="SW1SKIN",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    special=11,
  }

  stone_pillar =
  {
    h=128,
    switch="SW1STON1",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    special=11,
  }

  tech_outdoor =
  {
    podium="CEIL5_1", base="SHAWN2",
    switch="SW1COMM", exit="EXITSIGN",
    special=11,
  }

  tech_outdoor2 =
  {
    podium="STARTAN2", base="SHAWN2",
    switch="SW2COMM", exit="EXITSIGN",
    special=11,
  }

  tech_small =
  {
    door = "EXITDOOR", track = "DOORTRAK",
    exit = "EXITSIGN", exitside = "SHAWN2",
    key = "LITE5",
    track = "DOORSTOP", trim = "DOORSTOP",
    items = { "medikit" }
    door_kind=1, special=11,

    switch = "SW1BRN2",
    floor = "FLOOR0_3", ceil="TLITE6_6",
  }

}

