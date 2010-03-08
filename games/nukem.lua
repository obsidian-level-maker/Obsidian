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

NUKEM_THINGS =
{
  --- special stuff ---
  player1 = { id=1405, kind="other", r=20,h=56 },
  player2 = { id=1405, kind="other", r=20,h=56 },
  player3 = { id=1405, kind="other", r=20,h=56 },
  player4 = { id=1405, kind="other", r=20,h=56 },

  dm_player = { id=1405, kind="other", r=20,h=56 },

  --- monsters ---
  pig_cop = { id=2000, kind="monster", r=16,h=56 },

  -- bosses

  --- pickups ---
  k_yellow   = { id=80, kind="pickup", r=20,h=16, pass=true },

  --- scenery ---

}


----------------------------------------------------------------

NUKEM_MATERIALS =
{
  -- special materials --
  _ERROR = { t=1 },
  _SKY   = { t=89 },


  WATER = { t=336 },
  SLIME = { t=200 },
  LAVA  = { t=1082 },

  GLASS1 = { t=198 },
  GLASS2 = { t=758 },

  

  BRNBRICK = { t=0 },


  GRAYCIRCLE = { t=181 },
  GRAYFLAT = { t=182 },
  GRATE1 = { t=183 },

  CRETE1 = { t=300 },
  CRETE2 = { t=302 },
  CONC1 = { t=740 },
  CONC2 = { t=741 },

  ROCK1 = { t=239 },
  ROCK2 = { t=240 },
  ROCK3 = { t=241 },

  PIPES = { t=243 },
  DOOR1 = { t=242 },

  REDCARPET = { t=331 },
  REDSLATS  = { t=332 },
  ROOF1 = { t=342 },
  ROOF2 = { t=343 },

  WARNING = { t=355 },
  BOULEVARD = { t=823 },

  GRAYBRICK  = { t=461 },
  BRICK2 = { t=750 },
  CLANG1 = { t=755 },
  GRNBRICK = { t=748 },

  ROCK4 = { t=772 },
  ROCK5 = { t=782 },
  ROCK6 = { t=780 },
  SMROCK1 = { t=771 },
  SMROCK2 = { t=775 },
  SMROCK3 = { t=773 },

  ROCK7 = { t=801 },
  ZROCK1 = { t=805 },
  ZROCK2 = { t=796 },
  TETROCK = { t=876 },

  GRASS = { t=803 },
  STONES = { t=819 },
  MUD = { t=1218 },
  BLOCKS1 = { t=1205 },
  FLAT18 = { t=1204 },

  CABLES = { t=243 },
  BLOCKS2 = { t=1191 },
  WINDOW1 = { t=763 },
  WINDOW2 = { t=764 },
  IRON  = { t=757 },


  SUPPORT2 = { t=739 },
  SUPPORT3 = { t=349 },
  METAL  = { t=437 },
  METAL2 = { t=368 },


  PICT1 = { t=265 },
  PICT2 = { t=266 },
  PICT3 = { t=267 },
}


NUKEM_SANITY_MAP =
{
  -- FIXME
}


NUKEM_LIQUIDS =
{
  water = { mat="WATER", },
  slime = { mat="SLIME",  },
  lava  = { mat="LAVA", },
}



----------------------------------------------------------------


NUKEM_STEPS =
{
  step1 = { step_w="_ERROR", side_w="_ERROR", top_f="_ERROR" },
}


NUKEM_PICTURES =
{
  carve =
  {
    count=1,
    pic_w="PICT1", width=120, height=82,
    x_offset=0, y_offset=0,
    -- side_t="METAL", floor="CEIL5_2",
    depth=8, 
  },

  pill =
  {
    count=1,
    pic_w="PICT2", width=120, height=82,
    x_offset=0, y_offset=0,
    -- side_t="METAL", floor="CEIL5_2",
    depth=8, 
  },
}


NUKEM_SUB_THEMES =
{
  CITY1 =
  {
    prob=50,

    liquids = { water=50, slime=20, lava=7 },

    building =
    {
      walls = { BRNBRICK=50, WINDOW1=30, WINDOW2=30,
                BRICK2=50, GRNBRICK=30, GRAYBRICK=50,
                REDSLATS=20, IRON=20,
               },
      floors = { GRAYCIRCLE=30, CLANG1=90, GRAYFLAT=10, REDCARPET=10 },
      ceilings = { IRON=5, GRAYCIRCLE=50, ROOF1=20, ROOF2=20, },
    },

    courtyard =
    {
      floors = { MUD=50, GRASS=50,
                 CRETE1=20, CRETE2=20, CONC1=20, CONC2=20,
                 BLOCKS1=30, BLOCKS2=30, STONES=30, 
                 ROCK1=15, ROCK2=15, ROCK3=15, ROCK4=15,
                 ROCK5=15, ROCK6=15, ROCK7=15,
                 SMROCK1=20, SMROCK2=20, SMROCK3=20,
                 },
    },

    logos = { carve=50, pill=50 },

    steps = { step1=50 },

  }, -- CITY
}


------------------------------------------------------------

NUKEM_MONSTERS =
{
  -- FIXME : NUKEM_MONSTERS
}


NUKEM_WEAPONS =
{
  foot =
  {
    rate=1.5, damage=10, attack="melee",
  },

  -- FIXME : NUKEM_WEAPONS
}


NUKEM_PICKUPS =
{
  -- FIXME : NUKEM_PICKUPS
}


NUKEM_PLAYER_MODEL =
{
  duke =
  {
    stats = { health=0, bullet=0, missile=0,
              grenade=0, cell=0 },

    weapons = { foot=1 },
  }
}


------------------------------------------------------------


function Nukem_setup()
  -- nothing needed
end


function Nukem_get_levels()
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
        ep_info  = { },

        keys = { foo=50 },
        switches = { foo=50 },
        bars = { },
      }

      table.insert(GAME.all_levels, LEV)
    end -- for map

  end -- for episode
end



------------------------------------------------------------


OB_THEMES["nukem_city"] =
{
  label = "City",
  for_games = { nukem=1 },

  prefix = "CITY",
  name_theme = "URBAN",

  mixed_prob = 50,
}


OB_GAMES["nukem"] =
{
  label = "Duke Nukem",

  setup_func = Nukem_setup,
  levels_start_func = Nukem_get_levels,

  param =
  {
    format = "nukem",

    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    noblaze_door = true,

    no_keys = true,

    seed_size = 256,

    max_name_length = 28,

    skip_monsters = { 20,30 },

    mon_time_max = 12,

    mon_damage_max  = 200,
    mon_damage_high = 100,
    mon_damage_low  =   1,

    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  tables =
  {
    "player_model", NUKEM_PLAYER_MODEL,
    
    "things",   NUKEM_THINGS,
    "monsters", NUKEM_MONSTERS,
    "weapons",  NUKEM_WEAPONS,
    "pickups",  NUKEM_PICKUPS,

    "materials", NUKEM_MATERIALS,
    "liquids",   NUKEM_LIQUIDS,
    "themes",    NUKEM_SUB_THEMES,
    "pictures",  NUKEM_PICTURES,
    "steps",     NUKEM_STEPS,
  },
}

