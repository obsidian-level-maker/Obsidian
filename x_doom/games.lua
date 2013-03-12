----------------------------------------------------------------
--  GAME DEFINITION : DOOM, DOOM II
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2013 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
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

DOOM  = { }  -- common stuff

DOOM2 = { }  -- stuff specific to DOOM II


require "entities"
require "monsters"
require "weapons"
require "pickups"

require "materials"
require "themes"
require "levels"



DOOM.PARAMETERS =
{
  rails = true
  infighting = true
  raising_start = true
---!!!  light_brushes = true

  jump_height = 24

  map_limit = 12800

  -- this is roughly how many characters can fit on the
  -- intermission screens (the CWILVxx patches).  It does not
  -- reflect any buffer limits in the DOOM.EXE
  max_name_length = 28

  skip_monsters = { 15,25,35 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 1.0
  health_factor = 0.7
  monster_factor = 0.9
}

DOOM2.PARAMETERS =
{
  doom2_monsters = true
  doom2_weapons  = true
  doom2_skies    = true  -- RSKY# patches

  skip_monsters = { 20,30,45 }
}


----------------------------------------------------------------

DOOM.SKIN_DEFAULTS =
{
  tex_STARTAN3 = "?wall"
  tex_BLAKWAL1 = "?outer"
}


DOOM.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _file   = "start/basic.wad"
    _where  = "middle"

    top = "O_BOLT"
  }

  Start_Closet =
  {
    _file   = "start/closet1.wad"
    _where  = "closet"
    _fitted = "xy"


--[[
    step = "FLAT1"

    door = "BIGDOOR1"
    track = "DOORTRAK"

    support = "SUPPORT2"
    support_ox = 24

    special = 31  -- open and stay open
    tag = 0

    item1 = "bullet_box"
    item2 = "stimpack"
--]]
  }


  ----| EXITS |----

  Exit_pillar =
  {
    _file  = "exit/pillar1.wad",
    _where = "middle"
  }

  Exit_Closet_tech =
  {
    _file   = "exit/closet1.wad"
    _where  = "closet"
    _fitted = "xy"

--[[ FIXME
    door  = "EXITDOOR"
    track = "DOORTRAK"
    key   = "EXITDOOR"
    key_ox = 112

    inner = { STARGR2=30, STARBR2=30, STARTAN2=30,
              METAL4=15,  PIPE2=15,  SLADWALL=15,
              TEKWALL4=50 }

    ceil  = { TLITE6_5=40, TLITE6_6=20, GRNLITE1=20,
              CEIL4_3=10, SLIME15=10 }

    floor2 = { FLAT4=20, FLOOR0_1=20, FLOOR0_3=20, FLOOR1_1=20 }

    use_sign = 1
    exit = "EXITSIGN"
    exitside = "COMPSPAN"

    switch  = "SW1COMM"
    sw_side = "SHAWN2"

    special = 11
    tag = 0

    item1 = { stimpack=50, medikit=20, soul=1, none=30 }
    item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
  }

  Exit_Closet_hell =
  {
    _file   = "exit/closet1.wad"
    _where  = "closet"
    _fitted = "xy"

--[[ FIXME
    door  = "EXITDOOR"
    track = "DOORTRAK"
    key   = "SUPPORT3"
    key_ox = 24

    inner = { MARBGRAY=40, SP_HOT1=20, REDWALL=10,
              SKINMET1=10, SLOPPY2=10 }

    ceil = { FLAT5_6=20, LAVA1=5, FLAT10=10, FLOOR6_1=10 }

    floor2  = { SLIME09=10, FLOOR7_2=20, FLAT5_2=10, FLAT5_8=10 }

    use_sign = 1
    exit = "EXITSIGN"
    exitside = "COMPSPAN"

    switch  = { SW1LION=10, SW1SATYR=30, SW1GARG=20 }
    sw_side = "METAL"
    sw_oy   = 56

    special = 11
    tag = 0

    item1 = { stimpack=50, medikit=20, soul=1, none=30 }
    item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
  }


  ----| STAIRS |----



  ----| WALLS / CORNERS |----

  Fat_Outside_Corner1 =
  {
    _prefab = "FAT_CORNER_DIAG"
    _where  = "chunk"
  }


  ----| ITEM / KEY |----

  Pedestal_1 =
  {
    _file  = "pedestal/ped.wad"
    _where = "middle"

    top  = "CEIL1_2"
    side = "METAL"
  }


  ----| ARCHES |----


  ----| DOORS |----


  ---| LOCKED DOORS |---

  Locked_kc_blue =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "kc_blue"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORBLU";
    line_33 = 32

    door_w = 128
    door_h = 112

    key = "DOORBLU"
    door = "BIGDOOR3"
    door_c = "FLOOR7_2"
    step = "STEP4"
    track = "DOORTRAK"

    special = 32
    tag = 0  -- kind_mult=26
  }

  Locked_kc_yellow =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "kc_yellow"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORYEL";
    line_33 = 34

    door_w = 128
    door_h = 112

    key = "DOORYEL"
    door = "BIGDOOR4"
    door_c = "FLOOR3_3"
    step = "STEP4"
    track = "DOORTRAK"

    special = 34
    tag = 0  -- kind_mult=27
  }

  Locked_kc_red =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "kc_red"
    _long   = 192
    _deep   = 48

    door_w = 128
    door_h = 112

    key = "DOORRED"
    door = "BIGDOOR2"
    door_c = "FLAT1"
    step = "STEP4"
    track = "DOORTRAK"

    special = 33
    tag = 0  -- kind_mult=28
  }


  Locked_ks_blue =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "ks_blue"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORBLU2";
    line_33 = 32

    door_w = 128
    door_h = 112

    key = "DOORBLU2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLOOR7_2"
    step = "STEP4"
    track = "DOORTRAK"

    special = 32
    tag = 0  -- kind_mult=26
  }

  Locked_ks_yellow =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "ks_yellow"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORYEL2";
    line_33 = 34

    door_w = 128
    door_h = 112

    key = "DOORYEL2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLOOR3_3"
    step = "STEP4"
    track = "DOORTRAK"

    special = 34
    tag = 0  -- kind_mult=27
  }

  Locked_ks_red =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "ks_red"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORRED2";

    door_w = 128
    door_h = 112

    key = "DOORRED2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLAT1"
    step = "STEP4"
    track = "DOORTRAK"

    special = 33
    tag = 0  -- kind_mult=28
  }



  ---| SWITCHED DOORS |---

  Door_SW_blue =
  {
    _file   = "door/sw_door1.wad"
    _where  = "edge"
    _fitted = "xy"
    _switch = "sw_blue"
    _long = 256
    _deep = 48

    door_w = 128
    door_h = 112

    key = "COMPBLUE"
    door = "BIGDOOR3"
    door_c = "FLOOR7_2"
    step = "COMPBLUE"
    track = "DOORTRAK"
    frame = "FLAT14"
    door_h = 112
    special = 0
  }

  Door_SW_blue_NAR =
  {
    _copy = "Door_SW_blue"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR1"
    door_c = "FLAT23"
  }

  Switch_blue1 =
  {
    _file   = "switch/small2.wad"
    _where  = "middle"
    _switch = "sw_blue"

    switch_h = 64
    switch = "SW1BLUE"
    side = "COMPBLUE"
    base = "COMPBLUE"
    x_offset = 0
    y_offset = 50
    special = 103
  }


  ---| HALLWAY PIECES |---

  Hall_Basic_I =
  {
    _file   = "hall/trim1_i_win.wad"
    _shape  = "I"
    _fitted = "xy"
  }

  Hall_Basic_C =
  {
    _file   = "hall/trim1_c.wad"
    _shape  = "C"
    _fitted = "xy"
  }

  Hall_Basic_T =
  {
    _file   = "hall/trim1_t_lit.wad"
    _shape  = "T"
    _fitted = "xy"
  }

  Hall_Basic_P =
  {
    _file   = "hall/trim1_p.wad"
    _shape  = "P"
    _fitted = "xy"
  }

  Hall_Basic_I_Stair =
  {
    _file   = "hall/trim1_st.wad"
    _shape  = "IS"
    _fitted = "xy"

    step = "STEP3"
    support = "SUPPORT2"
    support_ox = 24
  }

  Hall_Basic_I_Lift =
  {
    _file   = "hall/trim1_lf.wad"
    _shape  = "IL"
    _fitted = "xy"
    _z_ranges = { {64,0}, {64,0,"?stair_h-64"}, {128,0} }
    _tags   = 1

    lift = "SUPPORT3"
    top  = { STEP_F1=50, STEP_F2=50 }

    raise_W1 = 130
    lower_WR = 88  -- 120
    lower_SR = 62  -- 123
  }




  Secret_Mini =
  {
    _prefab = "SECRET_MINI"
    _shape  = "I"
    _tags   = 1

    pic   = "O_NEON"
    inner = "COMPSPAN"
    metal = "METAL"
  }


  ---| WIDE JOINERS |---

  Wide_TriPillar =
  {
    _file   = "joiner/tri_pillar.wad"
    _shape  = "I"
    _fitted = "xy"
  }


  ---| BIG JUNCTIONS |---



  Junc_Circle_gothic_P =
  {
    _file   = "junction/circle_p.wad"
    _fitted = "xy"
    _shape  = "P"

    floor  = "CEIL3_5"
    circle = "CEIL3_3"
    step   = "STEP6"

    plinth = "MARBGRAY"
    plinth_top = "FLOOR7_2"
    plinth_ent = "evil_eye"

    billboard = "SW2SATYR"
    bill_side = "METAL"
    bill_oy   = 52

    torch_ent = "red_torch"
  }

  Junc_Circle_gothic_I =
  {
    _copy  = "Junc_Circle_gothic_P"
    _shape = "I"

    east_h = 0
    west_h = 0
  }

  Junc_Circle_gothic_C =
  {
    _copy  = "Junc_Circle_gothic_P"
    _shape = "C"

    east_h = 0
    north_h = 0
  }

  Junc_Circle_gothic_T =
  {
    _copy  = "Junc_Circle_gothic_P"
    _shape = "T"

    north_h = 0
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _file   = "teleport/pad1.wad"
    _where  = "middle"

    tag_1 = "?out_tag"
    tag_2 = "?in_tag"

--[[
    tele = { GATE1=60, GATE2=60, GATE3=30 }
    side = "METAL"

    x_offset = 0
    y_offset = 0
    peg = 1

    special = 97
    effect = 8
    light = 255
--]]
  }

  Teleporter_Closet =
  {
    _file  = "teleport/closet1.wad"
    _where = "closet"
    _fitted = "xy"
    _long   = 256

    tag_1 = "?out_tag"
    tag_2 = "?in_tag"
--[[
    tele = "GATE4"
    tele_side = "METAL"

    inner = "REDWALL"
    floor = "CEIL3_3"
    ceil  = "CEIL3_3"
    step  = "STEP1"

    special = 97
--]]
  }


  ---| WALLS |---

  Wall_plain =
  {
    _file   = "wall/plain.wad"
    _where  = "edge"
    _fitted = "xyz"

    _bound_z1 = 0
    _bound_z2 = 128

  }


  ---| WINDOWS |---

  Window1 =
  {
    _file   = "window/window1.wad"
    _where  = "edge"
    _fitted = "xy"
    _long   = 192
    _deep   = 24

  }


  ---| FENCES |---

  Fence1 =
  {
    _file   = "fence/fence1.wad"
    _where  = "edge"
    _fitted = "xy"
    _long   = 192
    _deep   = 32

    fence = "ICKWALL7"
    metal = "METAL"
    rail  = "MIDBARS3"
  }


  ---| PICTURES |---

  Pic_Carve =
  {
    _file   = "wall/pic_64x64.wad"
    _where  = "edge"
    _fitted = "xy"
    _bound_z1 = 0
    _bound_z2 = 128
    _long   = 256

    tex_GRAYPOIS = "O_CARVE"
  }


  -- techy --

  Pic_Computer =
  {
    _file   = "wall/pic_128x48.wad"
    _where  = "edge"
    _fitted = "xy"
    _bound_z1 = 0
    _bound_z2 = 112
    _long   = 256

    pic   = { COMPSTA1=50, COMPSTA2=50 }
    pic_w = 128
    pic_h = 48

    light = 48
    effect = { [0]=90, [1]=5 }  -- sometimes blink
    fx_delta = -47
  }


  ---| CAGES |---

  Fat_Cage1 =
  {
    _file   = "cage/fat_edge.wad"
    _where  = "chunk"
    _fitted = "xy"

    rail = "MIDBARS3"    
  }


  ---| DECORATION |---

} -- end of DOOM.SKINS


----------------------------------------------------------------

DOOM.PLAYER_MODEL =
{
  doomguy =
  {
    stats   = { health=0 }
    weapons = { pistol=1, fist=1 }
  }
}


DOOM2.SECRET_EXITS =
{
  MAP15 = true
  MAP31 = true
}


DOOM2.EPISODES =
{
  episode1 =
  {
    sky_light = 0.75
  }

  episode2 =
  {
    sky_light = 0.50
  }

  episode3 =
  {
    sky_light = 0.75
  }
}


DOOM2.ORIGINAL_THEMES =
{
  "doom_tech"
  "doom_urban"
  "doom_hell"
}


------------------------------------------------------------


function DOOM2.setup()
  -- nothing needed
end


function DOOM2.get_levels()
  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

  gotcha_map = rand.pick{17,18,19}
  gallow_map = rand.pick{24,25,26}

  local EP_NUM = 1
  if MAP_NUM > 11 then EP_NUM = 2 end
  if MAP_NUM > 30 then EP_NUM = 3 end

  -- create episode info...

  for ep_index = 1,EP_NUM do
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  for map = 1,MAP_NUM do
    -- determine episode from map number
    local ep_index
    local ep_along

    if map > 30 then
      ep_index = 3 ; ep_along = 0.35
    elseif map > 20 then
      ep_index = 3 ; ep_along = (map - 20) / 10
    elseif map > 11 then
      ep_index = 2 ; ep_along = (map - 11) / 9
    else
      ep_index = 1 ; ep_along = map / 11
    end

    if OB_CONFIG.length == "single" then
      ep_along = rand.pick{ 0.2, 0.3, 0.4, 0.6, 0.8 }
    elseif OB_CONFIG.length == "few" then
      ep_along = map / MAP_NUM
    end

    local EPI = GAME.episodes[ep_index]
    assert(EPI)

    local ep_info = DOOM2.EPISODES["episode" .. ep_index]
    assert(ep_info)
    assert(ep_along <= 1)

    local LEV =
    {
      episode = EPI

      name  = string.format("MAP%02d", map)
      patch = string.format("CWILV%02d", map-1)

      ep_along = ep_along

      sky_light = ep_info.sky_light
    }

    table.insert( EPI.levels, LEV)
    table.insert(GAME.levels, LEV)

    LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

    if map == 31 or map == 32 then
      -- secret levels are easy
      LEV.mon_along = 0.35
    elseif OB_CONFIG.length == "single" then
      LEV.mon_along = ep_along
    else
      -- difficulty ramps up over whole wad
      LEV.mon_along = map * 1.4 / math.min(MAP_NUM, 20)
    end

    -- secret levels
    if map == 31 or map == 32 then
      LEV.theme_name = "doom_wolf1"
      LEV.theme = GAME.LEVEL_THEMES[LEV.theme_name]

      LEV.name_theme = "URBAN"
    end

    if map == 23 then
      LEV.style_list = { barrels = { heaps=100 } }
    end

    -- prebuilt levels
    local pb_name = LEV.name

    if map == gotcha_map then pb_name = "GOTCHA" end
    if map == gallow_map then pb_name = "GALLOW" end
    
    LEV.prebuilt = GAME.PREBUILT_LEVELS[pb_name]

    if LEV.prebuilt then
      LEV.name_theme = LEV.prebuilt.name_theme or "BOSS"
    end

    if MAP_NUM == 1 or (map % 10) == 3 then
      LEV.demo_lump = string.format("DEMO%d", ep_index)
    end
  end
end


DOOM.LEVEL_GFX_COLORS =
{
  gold   = { 0,47,44, 167,166,165,164,163,162,161,160, 225 }
  silver = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 }
  bronze = { 0,2, 191,188, 235,232, 221,218,215,213,211,209 }
  iron   = { 0,7,5, 111,109,107,104,101,98,94,90,86,81 }
}


function DOOM.make_cool_gfx()
  local GREEN =
  {
    0, 7, 127, 126, 125, 124, 123,
    122, 120, 118, 116, 113
  }

  local BRONZE_2 =
  {
    0, 2, 191, 189, 187, 235, 233,
    223, 221, 219, 216, 213, 210
  }

  local RED =
  {
    0, 2, 188,185,184,183,182,181,
    180,179,178,177,176,175,174,173
  }


  local colmaps =
  {
    BRONZE_2, GREEN, RED,

    DOOM.LEVEL_GFX_COLORS.gold,
    DOOM.LEVEL_GFX_COLORS.silver,
    DOOM.LEVEL_GFX_COLORS.iron,
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, DOOM.LEVEL_GFX_COLORS.iron)

  -- patches (CEMENT1 .. CEMENT4)
  gui.wad_logo_gfx("WALL52_1", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("WALL53_1", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("WALL55_1", "p", "RELIEF", 128,128, 3)
  gui.wad_logo_gfx("WALL54_1", "p", "CARVE",  128,128, 4)

  -- flats
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)
end


function DOOM.make_level_gfx()
  assert(LEVEL.description)
  assert(LEVEL.patch)

  -- decide color set
  if not GAME.level_gfx_colors then
    local kind = rand.key_by_probs(
    {
      gold=12, silver=3, bronze=8, iron=10
    })

    GAME.level_gfx_colors = assert(DOOM.LEVEL_GFX_COLORS[kind])
  end

  gui.set_colormap(1, GAME.level_gfx_colors)

  gui.wad_name_gfx(LEVEL.patch, LEVEL.description, 1)
end


function DOOM2.end_level()
  if LEVEL.description and LEVEL.patch then
    DOOM.make_level_gfx()
  end
end


function DOOM2.all_done()
  DOOM.make_cool_gfx()

  gui.wad_merge_sections("doom_falls.wad");
  gui.wad_merge_sections("vine_dude.wad");

  if OB_CONFIG.length == "full" then
    gui.wad_merge_sections("freedoom_face.wad");
  end
end



------------------------------------------------------------


OB_GAMES["doom2"] =
{
  label = "Doom 2"

  priority = 99  -- keep at top

  format = "doom"

  tables =
  {
    DOOM, DOOM2
  }

  hooks =
  {
    setup        = DOOM2.setup
    get_levels   = DOOM2.get_levels
    end_level    = DOOM2.end_level
    all_done     = DOOM2.all_done
  }
}


