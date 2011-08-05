----------------------------------------------------------------
-- GAME DEF : Spear of Destiny
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

SP_COMBOS =
{
  CONCRETE =
  {
    mat_pri=4,
    wall=57, void=57, floor=0, ceil=0,
  },

  GRAY_CONCRETE =
  {
    mat_pri=4,
    wall=54, void=54, floor=0, ceil=0,
  },

  BROWN_CONCRETE =
  {
    mat_pri=4,
    wall=62, void=62, floor=0, ceil=0,
  },

  PURPLE_BRICK=
  {
    mat_pri=1,
    wall=63, void=63, floor=0, ceil=0,
  }
}
 

----------------------------------------------------------------

SP_BOSSES =
{
  -- FIXME: dm values were pulled straight out of my arse

  trans_grosse = { hp=1000, dm=40, hitscan=true, give_key="k_gold" },
  wilhelm      = { hp=1100, dm=70, hitscan=true, give_key="k_gold" },
  uber_mutant  = { hp=1200, dm=60, hitscan=true, give_key="k_gold" },
  death_knight = { hp=1400, dm=90, hitscan=true, give_key="k_gold" },

  ghost = { hp=15,   dm=20, melee=true },  -- not a boss, move out???

  angel_of_death = { hp=1600, dm=150,},
}


SP_PICKUPS =
{
  clip_25 = { stat="bullet", give=25 },
}

----------------------------------------------------------------


SP_ROOM_TYPES =
{
  HALLWAY =
  {
    scenery = { ceil_light2=90 },
  },

  KITCHEN =
  {
    scenery = { kitchen_stuff=50,
                puddle=20, bare_table=20, table_chairs=5,
                barrel=10, green_barrel=5, plant=2
              },

    pickups = { good_food=15, dog_food=5 },
    pickup_rate = 20,
  },

}

SP_THEMES =
{
  CELLS =
  {
    room_probs =
    {
      PLAIN = 90,    STORAGE = 40,
      TREASURE = 5,  SUPPLIES = 10,
      QUARTERS = 20, BATHROOM = 10,
      KITCHEN = 10,  TORTURE = 60,
    },

    theme_probs =
    {
      WOOD = 25,
      GRAY_STONE = 60,
      GRAY_BRICK = 60,
      BLUE_STONE = 90,
      BLUE_BRICK = 50,
      RED_BRICK = 20,
      PURPLE_STONE = 1,
      BROWN_CAVE = 10,
      BROWN_BRICK = 10,
      BROWN_STONE = 20,

      CONCRETE = 5,
      GRAY_CONCRETE = 5,
      BROWN_CONCRETE = 20,
      PURPLE_BRICK = 20,
    },

    scenery =
    {
      dead_guard=50, blood_well=40, puddle=10,
    },
  },

  BUNKER =
  {
    room_probs =
    {
      PLAIN = 90,    STORAGE = 50,
      TREASURE = 10, SUPPLIES = 10,
      QUARTERS = 50, BATHROOM = 15,
      KITCHEN = 25,  TORTURE = 20,
    },

    theme_probs =
    {
      WOOD = 120,
      GRAY_STONE = 60,
      GRAY_BRICK = 40,
      BLUE_STONE = 5,
      BLUE_BRICK = 10,
      RED_BRICK = 80,
      PURPLE_STONE = 1,
      BROWN_CAVE = 5,
      BROWN_BRICK = 10,
      BROWN_STONE = 5,

      CONCRETE = 50,
      GRAY_CONCRETE = 50,
      BROWN_CONCRETE = 30,
      PURPLE_BRICK= 10,
    },

    scenery =
    {
      marble_column=90, angel_statue=30,
      suit_of_armor=10, flag=10,
    },
  },

  CAVE =
  {
    room_probs =
    {
      PLAIN = 120,   STORAGE = 30,
      TREASURE = 15, SUPPLIES = 5,
      QUARTERS = 15, BATHROOM = 30,
      KITCHEN = 5,   TORTURE = 30,
    },

    theme_probs =
    {
      WOOD = 2,
      GRAY_STONE = 30,
      GRAY_BRICK = 10,
      BLUE_STONE = 5,
      BLUE_BRICK = 5,
      RED_BRICK = 10,
      PURPLE_STONE = 30,
      BROWN_CAVE = 80,
      BROWN_BRICK = 20,
      BROWN_STONE = 50,

      CONCRETE = 10,
      GRAY_CONCRETE = 5,
      BROWN_CONCRETE = 5,
      PURPLE_BRICK = 5,
    },

    scenery =
    {
      vines=70, cow_skull=30, skull_stick=20
    },
  },

  SECRET =
  {
    prob=0, -- special style, never chosen randomly

    room_probs =
    {
      PLAIN = 30,    STORAGE = 10,
      TREASURE = 90, SUPPLIES = 70,
      QUARTERS = 2,  BATHROOM = 2,
      KITCHEN = 20,  TORTURE = 2,
    },

    -- theme_probs : when missing, all have same prob
  },
}

----------------------------------------------------------------

SP_EPISODE_THEMES =
{
  -- FIXME: proper themes for Spear episodes
  { CELLS=3, BUNKER=5, CAVE=4 },  -- Tunnels
  { CELLS=3, BUNKER=5, CAVE=4 },  -- Dungeons
  { CELLS=3, BUNKER=5, CAVE=4 },  -- Castle
  { CELLS=3, BUNKER=5, CAVE=4 },  -- Ramparts
  { CELLS=3, BUNKER=5, CAVE=4 },  -- Secrets
  { CELLS=3, BUNKER=5, CAVE=4 },  -- Finale
}

SP_EPISODE_BOSSES =
{
  "trans_grosse",
  "wilhelm",
  "uber_mutant",
  "death_knight",
  "",
  "angel_of_death",
}

SP_EPISODE_INFO =
{
  { start=1,  len=5 },
  { start=6,  len=5 },
  { start=11, len=6 },
  { start=17, len=2 },
  { start=19, len=2 },  -- secret levels
  { start=21, len=1 },
}

function spear_get_levels(episode)

  local level_list = {}

  local theme_probs = SP_EPISODE_THEMES[episode]
  if SETTINGS.length ~= "full" then
    theme_probs = SP_EPISODE_THEMES[rand_irange(1,4)]
  end

  local ep_start  = SP_EPISODE_INFO[episode].start
  local ep_length = SP_EPISODE_INFO[episode].len

  for map = 1,ep_length do
    local Level =
    {
      name = string.format("E%dL%d", episode, ep_start + map-1),

      episode   = episode,
      ep_along  = map,
      ep_length = ep_length,

      sky_info  = { color="blue", light=192 }, -- dummy

      theme_probs = theme_probs,
      quests = {},
    }

    if (map == ep_length) and episode ~= 5 then
      Level.boss_kind = SP_EPISODE_BOSSES[episode]
    end

    -- add secret levels
    if SETTINGS.length == "full" then
      if episode == 5 then
        Level.secret_kind = "spear"
      end

      if Level.name == "E1L4" or Level.name == "E3L2" then
        Level.secret_exit = true
      end
    end

    table.insert(level_list, Level)
  end

  wolfy_decide_quests(level_list, "spear")

  return level_list
end


----------------------------------------------------------------

GAME_FACTORIES["spear"] = function()

  local T = GAME_FACTORIES.wolf3d()

  T.episodes   = 6
  T.level_func = spear_get_levels

  T.bosses   = SP_BOSSES

  T.combos   = copy_and_merge(T.combos,   SP_COMBOS)
  T.pickups  = copy_and_merge(T.pickups,  SP_PICKUPS)

  T.themes   = SP_THEMES
  T.rooms    = copy_and_merge(T.rooms,    SP_ROOMS)

  return T
end

