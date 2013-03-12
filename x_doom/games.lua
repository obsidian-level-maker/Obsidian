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
    file   = "start/basic.wad"
    where  = "middle"

    top = "O_BOLT"
  }

  Start_Closet =
  {
    file   = "start/closet1.wad"
    where  = "closet"
    fitted = "xy"
  }


  ----| EXITS |----

  Exit_pillar =
  {
    file  = "exit/pillar1.wad",
    where = "middle"
  }

  Exit_Closet_tech =
  {
    file   = "exit/closet1.wad"
    where  = "closet"
    fitted = "xy"

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
    file   = "exit/closet1.wad"
    where  = "closet"
    fitted = "xy"

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
    prefab = "FAT_CORNER_DIAG"
    where  = "chunk"
  }


  ----| ITEM / KEY |----

  Pedestal_1 =
  {
    file  = "pedestal/ped.wad"
    where = "middle"

    top  = "CEIL1_2"
    side = "METAL"
  }


  ----| ARCHES |----


  ----| DOORS |----


  ---| LOCKED DOORS |---

  Locked_kc_blue =
  {
    file   = "door/key_door.wad"
    where  = "edge"
    fitted = "xy"
    key    = "kc_blue"
    long   = 192
    deep   = 48

    tex_DOORRED = "DOORBLU";
    line_33 = 32
  }

  Locked_kc_yellow =
  {
    file   = "door/key_door.wad"
    where  = "edge"
    fitted = "xy"
    key    = "kc_yellow"
    long   = 192
    deep   = 48

    tex_DOORRED = "DOORYEL";
    line_33 = 34
  }

  Locked_kc_red =
  {
    file   = "door/key_door.wad"
    where  = "edge"
    fitted = "xy"
    key    = "kc_red"
    long   = 192
    deep   = 48
  }


  Locked_ks_blue =
  {
    file   = "door/key_door.wad"
    where  = "edge"
    fitted = "xy"
    key    = "ks_blue"
    long   = 192
    deep   = 48

    tex_DOORRED = "DOORBLU2";
    line_33 = 32
  }

  Locked_ks_yellow =
  {
    file   = "door/key_door.wad"
    where  = "edge"
    fitted = "xy"
    key    = "ks_yellow"
    long   = 192
    deep   = 48

    tex_DOORRED = "DOORYEL2";
    line_33 = 34
  }

  Locked_ks_red =
  {
    file   = "door/key_door.wad"
    where  = "edge"
    fitted = "xy"
    key    = "ks_red"
    long   = 192
    deep   = 48

    tex_DOORRED = "DOORRED2";
  }


  ---| SWITCHED DOORS |---

  Door_SW_blue =
  {
    file   = "door/sw_door1.wad"
    where  = "edge"
    fitted = "xy"
    switch = "sw_blue"
    long = 256
    deep = 48
  }

  Door_SW_blue_NAR =
  {
    copy = "Door_SW_blue"
    narrow = 1
  }

  Switch_blue1 =
  {
    file   = "switch/small2.wad"
    where  = "middle"
    switch = "sw_blue"
  }


  ---| HALLWAY PIECES |---

  Hall_Basic_I =
  {
    file   = "hall/trim1_i_win.wad"
    shape  = "I"
    fitted = "xy"
  }

  Hall_Basic_C =
  {
    file   = "hall/trim1_c.wad"
    shape  = "C"
    fitted = "xy"
  }

  Hall_Basic_T =
  {
    file   = "hall/trim1_t_lit.wad"
    shape  = "T"
    fitted = "xy"
  }

  Hall_Basic_P =
  {
    file   = "hall/trim1_p.wad"
    shape  = "P"
    fitted = "xy"
  }

  Hall_Basic_I_Stair =
  {
    file   = "hall/trim1_st.wad"
    shape  = "IS"
    fitted = "xy"

    step = "STEP3"
    support = "SUPPORT2"
    support_ox = 24
  }

  Hall_Basic_I_Lift =
  {
    file   = "hall/trim1_lf.wad"
    shape  = "IL"
    fitted = "xy"
    z_ranges = { {64,0}, {64,0,"?stair_h-64"}, {128,0} }
    tags   = 1

    lift = "SUPPORT3"
    top  = { STEP_F1=50, STEP_F2=50 }

    raise_W1 = 130
    lower_WR = 88  -- 120
    lower_SR = 62  -- 123
  }


  Secret_Mini =
  {
    prefab = "SECRET_MINI"
    shape  = "I"
    tags   = 1

    pic   = "O_NEON"
    inner = "COMPSPAN"
    metal = "METAL"
  }


  ---| WIDE JOINERS |---

  Wide_TriPillar =
  {
    file   = "joiner/tri_pillar.wad"
    shape  = "I"
    fitted = "xy"
  }


  ---| BIG JUNCTIONS |---

  Junc_Circle_gothic_P =
  {
    file   = "junction/circle_p.wad"
    fitted = "xy"
    shape  = "P"
  }

  Junc_Circle_gothic_I =
  {
    copy  = "Junc_Circle_gothic_P"
    shape = "I"

    east_h = 0
    west_h = 0
  }

  Junc_Circle_gothic_C =
  {
    copy  = "Junc_Circle_gothic_P"
    shape = "C"

    east_h = 0
    north_h = 0
  }

  Junc_Circle_gothic_T =
  {
    copy  = "Junc_Circle_gothic_P"
    shape = "T"

    north_h = 0
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    file   = "teleport/pad1.wad"
    where  = "middle"

    tag_1 = "?out_tag"
    tag_2 = "?in_tag"
  }

  Teleporter_Closet =
  {
    file  = "teleport/closet1.wad"
    where = "closet"
    fitted = "xy"
    long   = 256

    tag_1 = "?out_tag"
    tag_2 = "?in_tag"
  }


  ---| WALLS |---

  Wall_plain =
  {
    file   = "wall/plain.wad"
    where  = "edge"
    fitted = "xyz"

    bound_z1 = 0
    bound_z2 = 128

  }


  ---| WINDOWS |---

  Window1 =
  {
    file   = "window/window1.wad"
    where  = "edge"
    fitted = "xy"
    long   = 192
    deep   = 24

  }


  ---| FENCES |---

  Fence1 =
  {
    file   = "fence/fence1.wad"
    where  = "edge"
    fitted = "xy"
    long   = 192
    deep   = 32

    fence = "ICKWALL7"
    metal = "METAL"
    rail  = "MIDBARS3"
  }


  ---| PICTURES |---

  Pic_Carve =
  {
    file   = "wall/pic_64x64.wad"
    where  = "edge"
    fitted = "xy"
    long   = 256
    bound_z1 = 0
    bound_z2 = 128

    tex_GRAYPOIS = "O_CARVE"
  }


  -- techy --

  Pic_Computer =
  {
    file   = "wall/pic_128x48.wad"
    where  = "edge"
    fitted = "xy"
    long   = 256
    bound_z1 = 0
    bound_z2 = 112

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
    file   = "cage/fat_edge.wad"
    where  = "chunk"
    fitted = "xy"

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


