----------------------------------------------------------------
--  GAME DEFINITION : Duke Nukem 3D
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010 Andrew Apted
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

NUKEM = { }

NUKEM.ENTITIES =
{
  --- players ---
  player1 = { id=1405, r=20, h=56 }
  player2 = { id=1405, r=20, h=56 }
  player3 = { id=1405, r=20, h=56 }
  player4 = { id=1405, r=20, h=56 }

  dm_player = { id=1405 }

  --- pickups ---
  k_yellow   = { id=80 }

  --- scenery ---

  --- buttons ---
  nuke_button   = { id=142, r=32, h=64, pass=true }
  red_button    = { id=162, r=32, h=64, pass=true }
  square_button = { id=164, r=32, h=64, pass=true }
  access_panel  = { id=130, r=32, h=64, pass=true }

  turn_switch   = { id=136, r=32, h=64, pass=true }
  handle_switch = { id=140, r=32, h=64, pass=true }
  light_switch  = { id=712, r=32, h=64, pass=true }
  lever_switch  = { id=862, r=32, h=64, pass=true }
}


NUKEM.PARAMETERS =
{
  rails = true
  switches = true
  light_brushes = true

  max_name_length = 28

  skip_monsters = { 20,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
}


----------------------------------------------------------------

NUKEM.MATERIALS =
{
  -- special materials --
  _ERROR = { t=1 }
  _SKY   = { t=89 }


  WATER  = { t=336 }
  SLIME  = { t=200 }
  PLASMA = { t=1082 }


  BRN_BRICK = { t=0 }

  SCREEN_BREAK1 = { t=263 }
  SCREEN_BREAK2 = { t=264 }
  SCREEN_BREAK3 = { t=265 }
  SCREEN_BREAK4 = { t=266 }
  SCREEN_BREAK5 = { t=267 }

  SCREEN_BREAK13 = { t=275 }
  SCREEN_BREAK15 = { t=4123 }
  SCREEN_BREAK17 = { t=4128 }
  SCREEN_BREAK18 = { t=4129 }
  SCREEN_BREAK19 = { t=4125 }


  GLASS1 = { t=198 }
  GLASS2 = { t=758 }



  GRAYCIRCLE = { t=181 }
  GRAYFLAT = { t=182 }
  GRATE1 = { t=183 }

  CRETE1 = { t=300 }
  CRETE2 = { t=302 }
  CONC1 = { t=740 }
  CONC2 = { t=741 }
  CONC3 = { t=802 }

  ROCK1 = { t=239 }
  ROCK2 = { t=240 }
  ROCK3 = { t=241 }

  PIPES = { t=243 }
  DOOR1 = { t=242 }
  VAULTDOOR = { t=470 }

  REDCARPET = { t=331 }
  REDSLATS  = { t=332 }
  ROOF1 = { t=342 }
  ROOF2 = { t=343 }

  WARNING = { t=355 }
  BOULEVARD = { t=823 }

  GRAYBRICK  = { t=461 }
  BRICK2 = { t=750 }
  CLANG1 = { t=755 }
  GRNBRICK = { t=748 }

  ROCK4 = { t=772 }
  ROCK5 = { t=782 }
  ROCK6 = { t=780 }
  SMROCK1 = { t=771 }
  SMROCK2 = { t=775 }
  SMROCK3 = { t=773 }

  ROCK7 = { t=801 }
  ZROCK1 = { t=805 }
  ZROCK2 = { t=796 }
  TETROCK = { t=876 }

  GRASS = { t=803 }
  STONES = { t=819 }
  MUD = { t=1218 }
  BLOCKS1 = { t=1205 }
  FLAT18 = { t=1204 }

  CABLES = { t=243 }
  BLOCKS2 = { t=1191 }
  WINDOW1 = { t=763 }
  WINDOW2 = { t=764 }
  IRON  = { t=757 }


  SUPPORT2 = { t=739 }
  SUPPORT3 = { t=349 }
  METAL  = { t=437 }
  METAL2 = { t=368 }


  BSTONES = { t=781 }
  WOOD1 = { t=884 }
  WOOD2 = { t=880 }
  WOOD3 = { t=1188 }
  WOOD4 = { t=1181 }

  CANYON1 = { t=1169 }
  CANYON2 = { t=1170 }
  OCTAFLOOR = { t=417 }
  BLOCKS4 = { t=827 }
  RUST = { t=767 }
  
  COMPUTER1 = { t=875 }
  COMPUTER2 = { t=294 }
  COMPUTER3 = { t=297 }
  COMPUTER4 = { t=298 }
  COMPUTER5 = { t=299 }
}


NUKEM.LIQUIDS =
{
  water  = { mat="WATER", }
  slime  = { mat="SLIME",  }
  plasma = { mat="PLASMA", }
}


----------------------------------------------------------------

NUKEM.STEPS =
{
  step1 = { step_w="RUST", side_w="RUST", top_f="RUST" }
}


NUKEM.PICTURES =
{
  carve =
  {
    count=1,
    pic_w="SCREEN_BREAK3", width=120, height=82,
    x_offset=0, y_offset=0,
    -- side_t="METAL", floor="CEIL5_2",
    depth=8, 
  }

  pill =
  {
    count=1,
    pic_w="SCREEN_BREAK4", width=120, height=82,
    x_offset=0, y_offset=0,
    -- side_t="METAL", floor="CEIL5_2",
    depth=8, 
  }
}


NUKEM.LEVEL_THEMES =
{
  nukem_city1 =
  {
    prob=50,

    liquids = { water=50, slime=20, lava=7 }

    building_walls = { BRN_BRICK=50, WINDOW1=30, WINDOW2=30,
                BRICK2=50, GRNBRICK=30, GRAYBRICK=50,
                REDSLATS=20, IRON=20,
               }

    building_floors = { GRAYCIRCLE=30, CLANG1=90, GRAYFLAT=10, REDCARPET=10 }

    building_ceilings = { IRON=5, GRAYCIRCLE=50, ROOF1=20, ROOF2=20, }

    courtyard_floors =
    {
      MUD=50, GRASS=50,
      CRETE1=20, CONC1=20, CONC2=20,
      BLOCKS1=30, BLOCKS2=30,
      ROCK1=15, ROCK2=15, ROCK3=15, ROCK4=15,
      ROCK5=15, ROCK6=15, ROCK7=15,
      SMROCK1=20, SMROCK2=20, SMROCK3=20,
    }

    logos = { carve=50, pill=50 }

    steps = { step1=50 }

    outer_fences = { STONES=50, BSTONES=50, WOOD3=50 }

  }  -- CITY
}


------------------------------------------------------------

NUKEM.MONSTERS =
{
  -- FIXME : NUKEM.MONSTERS

  pig_cop   = { id=2000, r=16, h=56 }
  liz_troop = { id=1680, r=16, h=56 } 
  liz_man   = { id=2120, r=16, h=56 }
  commander = { id=1920, r=16, h=56 }
  octabrain = { id=1820, r=16, h=56 } 
  new_beast = { id=4610, r=16, h=56 }

  recon     = { id=1960, r=16, h=56 }
  tank      = { id=1975, r=16, h=56 }
  drone     = { id=1880, r=16, h=56 }
  rotategun = { id=2360, r=16, h=56 }
  green_slime = { id=2370, r=16, h=56 }

  -- FIXME: BOSSES

  Boss1 = { id=2630, r=50, h=200 }
  Boss2 = { id=2710, r=50, h=200 }
  Boss3 = { id=2760, r=50, h=200 }
  Boss4 = { id=4740, r=50, h=200 }
}


NUKEM.WEAPONS =
{
  foot =
  {
    rate = 1.5
    damage = 10
    attack = "melee"
  }

  -- FIXME : NUKEM.WEAPONS
}


NUKEM.PICKUPS =
{
  -- FIXME : NUKEM.PICKUPS
}


NUKEM.PLAYER_MODEL =
{
  duke =
  {
    stats = { health=0 }
    weapons = { foot=1 }
  }
}


------------------------------------------------------------


function NUKEM.setup()
  -- nothing needed
end


function NUKEM.get_levels()
  local EP_NUM  = 1
  local MAP_NUM = 1

  if OB_CONFIG.length == "few"     then MAP_NUM = 4 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 9 end
  if OB_CONFIG.length == "full"    then MAP_NUM = 9 ; EP_NUM = 3 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name = string.format("E%dL%d", episode, map),

        episode  = episode,
        ep_along = map / MAP_NUM,
        ep_info  = { }
      }

      table.insert(GAME.levels, LEV)

    end -- for map
  end -- for episode
end



------------------------------------------------------------

UNFINISHED["nukem"] =
{
  label = "Duke Nukem"

  format = "nukem"

  tables =
  {
    NUKEM
  }

  hooks =
  {
    setup       = NUKEM.setup
    get_levels  = NUKEM.get_levels
  }
}


OB_THEMES["nukem_city"] =
{
  label = "City"
  for_games = { nukem=1 }
  name_theme = "URBAN"
  mixed_prob = 50
}

