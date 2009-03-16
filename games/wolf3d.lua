----------------------------------------------------------------
-- GAME DEF : Wolfenstein 3D
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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

-- constants
WF_NO_TILE = 48
WF_NO_OBJ  = 0


WOLF_THINGS =
{
  -- players
  player1 = { kind="other", r=30, h=60,
              id={ easy=19, medium=19, hard=19, dirs="player" },
            },

  -- enemies
  dog     = { kind="monster", r=30, h=60,
              id={ easy=138, medium=174, hard=210, dirs=true },
            },
  guard   = { kind="monster", r=30, h=60,
              id={ easy=108, medium=144, hard=180, dirs=true, patrol=4 },
            },
  officer = { kind="monster", r=30, h=60,
              id={ easy=116, medium=152, hard=188, dirs=true, patrol=4 },
            },
  ss_dude = { kind="monster", r=30, h=60,
              id={ easy=126, medium=162, hard=198, dirs=true, patrol=4 },
            },
  mutant  = { kind="monster", r=30, h=60,
              id={ easy=216, medium=234, hard=252, dirs=true, patrol=4 },
            },

  fake_hitler = { kind="monster", id=160, r=30, h=60 },

  -- bosses
  Fatface    = { kind="monster", id=179, r=30, h=60 },
  Gretel     = { kind="monster", id=197, r=30, h=60 },
  Hans       = { kind="monster", id=214, r=30, h=60 },
  Schabbs    = { kind="monster", id=196, r=30, h=60 },
  Giftmacher = { kind="monster", id=215, r=30, h=60 },
  Hitler     = { kind="monster", id=178, r=30, h=60 },

  -- ghosts (red, yellow, pink, blue)
  blinky = { kind="monster", id=224, r=30, h=60 },
  clyde  = { kind="monster", id=225, r=30, h=60 },
  pinky  = { kind="monster", id=226, r=30, h=60 },
  inky   = { kind="monster", id=227, r=30, h=60 },

  -- pickups
  k_silver = { kind="pickup", id=44, r=30, h=60, pass=true },
  k_gold   = { kind="pickup", id=43, r=30, h=60, pass=true },

  first_aid = { kind="pickup", id=48, r=30, h=60, pass=true },
  good_food = { kind="pickup", id=47, r=30, h=60, pass=true },
  dog_food  = { kind="pickup", id=29, r=30, h=60, pass=true },

  clip        = { kind="pickup", id=49, r=30, h=60, pass=true },
  machine_gun = { kind="pickup", id=50, r=30, h=60, pass=true },
  gatling_gun = { kind="pickup", id=51, r=30, h=60, pass=true },

  cross   = { kind="pickup", id=52, r=30, h=60, pass=true },
  chalice = { kind="pickup", id=53, r=30, h=60, pass=true },
  chest   = { kind="pickup", id=54, r=30, h=60, pass=true },
  crown   = { kind="pickup", id=55, r=30, h=60, pass=true },
  one_up  = { kind="pickup", id=56, r=30, h=60, pass=true },

  -- scenery
  green_barrel = { kind="scenery", id=24, r=30, h=60 },
  table_chairs = { kind="scenery", id=25, r=30, h=60, add_mode="island" },

  puddle     = { kind="scenery", id=23, r=30, h=60, pass=true },
  floor_lamp = { kind="scenery", id=26, r=30, h=60, light=255 },
  chandelier = { kind="scenery", id=27, r=30, h=60, light=255, pass=true, ceil=true, add_mode="island" },
  hanged_man = { kind="scenery", id=28, r=30, h=60, add_mode="island" },
  red_pillar = { kind="scenery", id=30, r=30, h=60, add_mode="island" },

  tree  = { kind="scenery", id=31, r=30, h=60 },
  sink  = { kind="scenery", id=33, r=30, h=60, add_mode="extend" },
  plant = { kind="scenery", id=34, r=30, h=60 },
  urn   = { kind="scenery", id=35, r=30, h=60 },

  bare_table    = { kind="scenery", id=36, r=30, h=60, add_mode="island" },
  ceil_light    = { kind="scenery", id=37, r=30, h=60, pass=true, ceil=true, light=255, add_mode="island" },
  skeleton_flat = { kind="scenery", id=32, r=30, h=60, pass=true },
  kitchen_stuff = { kind="scenery", id=38, r=30, h=60 },
  suit_of_armor = { kind="scenery", id=39, r=30, h=60, add_mode="extend" },
  hanging_cage  = { kind="scenery", id=40, r=30, h=60, add_mode="island" },

  skeleton_in_cage = { kind="scenery", id=41, r=30, h=60, add_mode="island" },
  skeleton_relax   = { kind="scenery", id=42, r=30, h=60, pass=true },

  bed    = { kind="scenery", id=45, r=30, h=60 },
  basket = { kind="scenery", id=46, r=30, h=60 },
  barrel = { kind="scenery", id=58, r=30, h=60 },
  gibs_1 = { kind="scenery", id=57, r=30, h=60, pass=true },
  gibs_2 = { kind="scenery", id=61, r=30, h=60, pass=true },
  flag   = { kind="scenery", id=62, r=30, h=60 },

  water_well = { kind="scenery", id=59, r=30, h=60 },
  empty_well = { kind="scenery", id=60, r=30, h=60 },
  aardwolf   = { kind="scenery", id=63, r=30, h=60 },

  junk_1 = { kind="scenery", id=64, r=30, h=60, pass=true },
  junk_2 = { kind="scenery", id=65, r=30, h=60, pass=true },
  junk_3 = { kind="scenery", id=66, r=30, h=60, pass=true },
  pots   = { kind="scenery", id=67, r=30, h=60, pass=true, add_mode="extend" },
  stove  = { kind="scenery", id=68, r=30, h=60 },
  spears = { kind="scenery", id=69, r=30, h=60, add_mode="extend" },
  vines  = { kind="scenery", id=70, r=30, h=60, pass=true },

  dud_clip   = { kind="scenery", id=71,  r=30, h=60, pass=true },
  dead_guard = { kind="scenery", id=124, r=30, h=60, pass=true },

  -- special
  secret  = { kind="other", id=98, r=30,h=60, pass=true },
  endgame = { kind="other", id=99, r=30,h=60, pass=true },

  turn_E  = { kind="other", id=90, r=30,h=60, pass=true },
  turn_NE = { kind="other", id=91, r=30,h=60, pass=true },
  turn_N  = { kind="other", id=92, r=30,h=60, pass=true },
  turn_NW = { kind="other", id=93, r=30,h=60, pass=true },
  turn_W  = { kind="other", id=94, r=30,h=60, pass=true },
  turn_SW = { kind="other", id=95, r=30,h=60, pass=true },
  turn_S  = { kind="other", id=96, r=30,h=60, pass=true },
  turn_SE = { kind="other", id=97, r=30,h=60, pass=true },


  ---===| Spear of Destiny |===---


  chest_of_ammo    = { kind="pickup", id=72, r=30, h=60 },
  spear_of_destiny = { kind="pickup", id=74, r=30, h=60 },

  ghost          = { kind="monster", id=106, r=30, h=60 },
  angel_of_death = { kind="monster", id=107, r=30, h=60 },
  trans_grosse   = { kind="monster", id=125, r=30, h=60 },
  uber_mutant    = { kind="monster", id=142, r=30, h=60 },
  wilhelm        = { kind="monster", id=143, r=30, h=60 },
  death_knight   = { kind="monster", id=161, r=30, h=60 },

  -- skull_stick REPLACES: sink
  -- skull_cage  REPLACES: bed
  -- ceil_light2 REPLACES: aardwolf

  skull_stick = { kind="scenery", id=33, r=30, h=60 },
  skull_cage  = { kind="scenery", id=45, r=30, h=60 },
  ceil_light2 = { kind="scenery", id=63, r=30, h=60, pass=true, ceil=true, light=255 },

  -- cow_skull     REPLACES: pots
  -- blood_well    REPLACES: stove
  -- angel_statue  REPLACES: spears
  -- marble_column REPLACES: dud_clip

  cow_skull    = { kind="scenery", id=67, r=30, h=60 },
  blood_well   = { kind="scenery", id=68, r=30, h=60 },
  angel_statue = { kind="scenery", id=69, r=30, h=60 },
  marble_column = { kind="scenery", id=71, r=30, h=60, add_mode="island" },
}

WOLF_TILE_NUMS =
{
  area_min = 108,
  area_max = 143,

  deaf_guard = 106,
  elevator_secret = 107,

  door = { 90, 91 },  -- E/W then N/S

  door_gold   = { 92, 93 },
  door_silver = { 94, 95 },

  door_elevator = { 100, 101 },
}

----------------------------------------------------------------

WOLF_COMBOS =
{
  WOOD =
  {
    mat_pri = 5,
    wall = 12, void = 12, floor=0, ceil=0,
    decorate = 10, door_side = 23,

    theme_probs = { BUNKER=120, CELLS=25  },
  },

  GRAY_STONE =
  {
    mat_pri = 7,
    wall = 1, void = 1, floor=0, ceil=0,
    decorate = { 4,6 }, door_side = 28,

    theme_probs = { BUNKER=60, CAVE=30 },
  },

  GRAY_BRICK =
  {
    mat_pri = 7,
    wall = 35, void = 35, floor=0, ceil=0,
    decorate = { 37,43 }, door_side = 49,

    theme_probs = { CELLS=60, BUNKER=40 },
  },

  BLUE_STONE =
  {
    mat_pri = 6,
    wall = 8, void = 8, floor=0, ceil=0,
    decorate = { 5,7 }, door_side = 41,

    theme_probs = { CELLS=140 },
  },

  BLUE_BRICK =
  {
    mat_pri = 6,
    wall = 40, void = 40, floor=0, ceil=0,
    decorate = { 34,36 },

    theme_probs = { CELLS=80 },
  },

  RED_BRICK =
  {
    mat_pri = 5,
    wall = 17, void = 17, floor=0, ceil=0,
    decorate = { 18,38 }, door_side = 20,

    theme_probs = { BUNKER=80 },
  },
 
  PURPLE_STONE =
  {
    mat_pri = 1,
    wall = 19, void = 19, floor=0, ceil=0,
    decorate = 25,

    theme_probs = { CAVE=30 },
  },

  BROWN_CAVE =
  {
    mat_pri = 3,
    wall = 29, void = 29, floor=0, ceil=0,
    decorate = { 30,31,32 },

    theme_probs = { CAVE=90 },
  },
 
  BROWN_BRICK =
  {
    mat_pri = 5,
    wall = 42, void = 42, floor=0, ceil=0,
    door_side = 47,

    theme_probs = { CAVE=20 },
  },

  BROWN_STONE =
  {
    mat_pri = 5,
    wall = 44, void = 44, floor=0, ceil=0,

    theme_probs = { CAVE=50, CELLS=20 },
  },
}

WOLF_EXITS =
{
  ELEVATOR =  -- FIXME: not needed, remove
  {
    mat_pri = 0,
    wall = 21, void = 21, floor=0, ceil=0,
  },
}


WOLF_KEY_DOORS =
{
  k_silver = { door_kind="door_silver", door_side=14 },
  k_gold   = { door_kind="door_gold",   door_side=14 },
}

WOLF_MISC_PREFABS =
{
  elevator =
  {
    prefab = "WOLF_ELEVATOR",
    add_mode = "extend",

    skin = { elevator=21, front=14, }
  },
}



---- QUEST STUFF ----------------

WOLF_QUESTS =
{
  key = { k_silver=60, k_gold=30, },

  switch = { },

  weapon = { machine_gun=50, gatling_gun=20, },

  item =
  {
    crown = 50, chest = 50, cross = 50, chalice = 50,
    one_up = 2,
  },

  exit =
  {
    elevator=50
  }
}


WOLF_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    scenery = { ceil_light=90 },

    space_range = { 10, 50 },
  },

  STORAGE =
  {
    scenery = { barrel=50, green_barrel=80, }
  },

  TREASURE =
  {
    pickups = { cross=90, chalice=90, chest=20, crown=5 },
    pickup_rate = 90,
  },

  SUPPLIES =
  {
    scenery = { barrel=70, bed=40, },

    pickups = { first_aid=50, good_food=90, clip=70 },
    pickup_rate = 66,
  },

  QUARTERS =
  {
    scenery = { table_chairs=70, bed=70, chandelier=70,
                bare_table=20, puddle=20,
                floor_lamp=10, urn=10, plant=10
              },
  },

  BATHROOM =
  {
    scenery = { sink=50, puddle=90, water_well=30, empty_well=30 },
  },

  KITCHEN =
  {
    scenery = { kitchen_stuff=50, stove=50, pots=50,
                puddle=20, bare_table=20, table_chairs=5,
                sink=10, barrel=10, green_barrel=5, plant=2
              },

    pickups = { good_food=15, dog_food=5 },
    pickup_rate = 20,
  },

  TORTURE =
  {
    scenery = { hanging_cage=80, skeleton_in_cage=80,
                skeleton_relax=30, skeleton_flat=40,
                hanged_man=60, spears=10, bare_table=10,
                gibs_1=10, gibs_2=10,
                junk_1=10, junk_2=10,junk_3=10
              },
  },
}

WOLF_THEMES =
{
  -- Main Themes:
  --
  -- 1. BUNKER --> brick/wood, humans, quarters, plants/urns
  -- 2. CELLS  --> blue_stone, dogs, skeletons 
  -- 3. CAVE   --> cave/rock tex, vines, mutants

  BUNKER =
  {
    room_probs =
    {
      STORAGE = 50,
      TREASURE = 10, SUPPLIES = 15,
      QUARTERS = 50, BATHROOM = 15,
      KITCHEN = 30,  TORTURE = 20,
    },

    scenery =
    {
      suit_of_armor=50, flag=20,
    },
  },

  CELLS =
  {
    room_probs =
    {
      STORAGE = 40,
      TREASURE = 5,  SUPPLIES = 10,
      QUARTERS = 20, BATHROOM = 10,
      KITCHEN = 10,  TORTURE = 60,
    },

    scenery =
    {
      dead_guard=50, puddle=10,
    },

    monster_prefs =
    {
      dog=2.0, guard=2.0,
    },
  },

  CAVE =
  {
    room_probs =
    {
      STORAGE = 30,
      TREASURE = 15, SUPPLIES = 5,
      QUARTERS = 15, BATHROOM = 30,
      KITCHEN = 5,   TORTURE = 30,
    },

    scenery =
    {
      vines=90, spears=30,
    },

    monster_prefs =
    {
      mutant=6.0, officer=2.0,
    },

    trim_mode = "rough_hew",
  },

--[[
  SECRET =
  {
    prob=0, -- special style, never chosen randomly

    room_probs =
    {
      STORAGE = 10,
      TREASURE = 90, SUPPLIES = 70,
      QUARTERS = 2,  BATHROOM = 2,
      KITCHEN = 20,  TORTURE = 2,
    },

    -- combo_probs : when missing, all have same prob
  },
--]]
}


----------------------------------------------------------------

WOLF_MONSTERS =
{
  dog =
  {
    prob=20, guard_prob=5, trap_prob=1,
    health=1, damage=5, attack="melee",
  },

  guard =
  {
    prob=60, guard_prob=20, trap_prob=3,
    health=25, damage=10, attack="hitscan",
    give={ {ammo="bullet",count=4} },
  },

  officer =
  {
    prob=30, guard_prob=50, trap_prob=10,
    health=50,  damage=20, attack="hitscan",
    give={ {ammo="bullet",count=4} },
  },

  mutant =
  {
    prob=20, guard_prob=20, trap_prob=20,
    health=55,  damage=35, attack="hitscan",
    give={ {ammo="bullet",count=4} },
  },

  ss_dude =
  {
    prob=5, guard_prob=60, trap_prob=20,
    health=100, damage=30, attack="hitscan",
    give={ {weapon="machine_gun"}, {ammo="bullet",count=4} },
  },

  fake_hitler =
  {
    health=350, damage=50, attack="missile",
  },

  --| WOLF_BOSSES |--

  -- FIXME: hit-points are just averages of skill 2 and 3
 
  -- FIXME: proper damage values

  Hans =
  {
    health=1000, damage=40, attack="hitscan",
    give={ {key="k_gold"} }
  },

  Gretel =
  {
    health=1000, damage=50, attack="hitscan",
    give={ {key="k_gold"} }
  },

  Fatface =
  {
    health=1000, damage=50, attack="hitscan",
  },

  Giftmacher =
  {
    health=1000, damage=50, attack="missile",
  },

  Schabbs =
  {
    health=1250, damage=60, attack="missile",
  },

  -- this includes both Hitlers (in and out of the armor suit)
  Hitler =
  {
    health=1100, damage=60, attack="hitscan"
  },

  -- NOTES:
  --
  -- The SS only drops a machine gun (which gives _6_ bullets)
  -- when you don't already have it, otherwise he drops a _4_
  -- bullet clip.  To maintain ammo balance, we assume it is
  -- always 4 bullets.

}


WOLF_WEAPONS =
{
  knife =
  {
    pref=1,
    rate=3.0, damage=7, attack="melee",
  },

  pistol =
  {
    pref=10,
    rate=3.0, damage=17, attack="hitscan",
    ammo="bullet", per=1,
  },

  machine_gun =
  {
    pref=20, add_prob=20,
    rate=8.0, damage=17, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",give=6} },
  },

  gatling_gun =
  {
    pref=30, add_prob=90,
    rate=16,  damage=17, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",give=6} },
  },
}


WOLF_PICKUPS =
{
  -- NOTE: no "gibs" here, they are fairly insignificant

  first_aid =
  {
    give={ {health=25} },
  },

  good_food =
  {
    give={ {health=10} },
  },

  dog_food =
  {
    give={ {health=4} },
  },

  clip =
  {
    give={ {ammo="bullet",count=8} },
  },
}


WOLF_PLAYER_MODEL =
{
  bj =
  {
    stats   = { health=0, bullet=0 },
    weapons = { pistol=1, knife=1  },
  }
}


------------------------------------------------------------

WOLF_EPISODE_THEMES =
{
  { CELLS=7, BUNKER=5, CAVE=3 },
  { CELLS=6, BUNKER=8, CAVE=4 },
  { CELLS=6, BUNKER=8, CAVE=4 },

  { CELLS=6, BUNKER=8, CAVE=4 },
  { CELLS=6, BUNKER=8, CAVE=4 },
  { CELLS=6, BUNKER=8, CAVE=4 },
}

WOLF_SECRET_EXITS =
{
  E1L1 = true,
  E2L1 = true,
  E3L7 = true,

  E4L3 = true,
  E5L5 = true,
  E6L3 = true,
}

WOLF_EPISODE_BOSSES =
{
  "Hans",
  "Schabbs",
  "Hitler",
  "Giftmacher",
  "Gretel",
  "Fatface",
}

WOLF_KEY_NUM_PROBS =
{
  small   = { 90, 50, 20 },
  regular = { 40, 90, 40 },
  large   = { 20, 50, 90 },
}


function wolfy_decide_quests(level_list, is_spear)

  local function add_quest(L, kind, item, secret_prob)
    secret_prob = 0 --FIXME !!!!

    local len_probs = non_nil(WOLF_QUEST_LEN_PROBS[kind])
    local Quest =
    {
      kind = kind,
      item = item,
      want_len = 1 + rand_index_by_probs(len_probs),
    }
    if item == "secret" or (secret_prob and rand_odds(secret_prob)) then
      Quest.is_secret = true
      -- need at least one room in-between (for push-wall)
      if Quest.want_len < 3 then Quest.want_len = 3 end
    end
    table.insert(L.quests, Quest)
    return Quest
  end

  local gatling_maps =
  {
    [rand_irange(2,3)] = true,
    [rand_irange(4,6)] = true,
    [rand_irange(7,9)] = true,
  }

  for zzz,Level in ipairs(level_list) do

    -- weapons and keys

    if rand_odds(90 - 40 * ((Level.ep_along-1) % 3)) then
      add_quest(Level, "weapon", "machine_gun", 35)
    end

    if gatling_maps[Level.ep_along] then
      add_quest(Level, "weapon", "gatling_gun", 50)
    end

    local keys = rand_index_by_probs(WOLF_KEY_NUM_PROBS[SETTINGS.size]) - 1

    if keys >= 1 then
      add_quest(Level, "key", "k_silver")
    end

    -- treasure

    local ITEM_PROBS = { small=33, regular=45, large=66 }

    for i = 1,sel(is_spear,4,6) do
      if rand_odds(ITEM_PROBS[SETTINGS.size]) then
        add_quest(Level, "item", "treasure", 50)
      end
    end

    if is_spear and rand_odds(60) then
      add_quest(Level, "item", "clip_25", 50)
    end

    -- bosses and exits

    if Level.boss_kind then
      local Q = add_quest(Level, "boss", Level.boss_kind)
      Q.give_key = "k_gold"

    elseif keys == 2 then
      add_quest(Level, "key", "k_gold")
    end

    if Level.secret_exit then
--FIXME  add_quest(Level, "exit", "secret")
    end

    add_quest(Level, "exit", "normal")
  end
end

function Wolf3d_get_levels()
  local list = {}

  local EP_NUM  = sel(OB_CONFIG.length == "full", 6, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 10)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  for episode = 1,EP_NUM do

    local theme_probs = WOLF_EPISODE_THEMES[episode]

    local boss_kind = WOLF_EPISODE_BOSSES[episode]
    if OB_CONFIG.length ~= "full" then
      boss_kind = WOLF_EPISODE_BOSSES[rand_irange(1,6)]
    end

    local secret_kind = "pacman"

    for map = 1,MAP_NUM do
      local Level =
      {
        name = string.format("E%dL%d", episode, map),

        ep_along = ((map - 1) % 10) / 9,

        theme_probs = theme_probs,
        sky_info = { color="blue", light=192 }, -- dummy

        boss_kind   = (map == 9)  and boss_kind,
        secret_kind = (map == 10) and secret_kind,

        quests = {},

        toughness_factor = sel(map==10, 1.1, 1 + (map-1) / 5),
      }

      if WOLF_SECRET_EXITS[Level.name] then
        Level.secret_exit = true
      end

      table.insert(list, Level)
    end -- for map

  end -- for episode

--  local function dump_levels()
--    for idx,L in ipairs(list) do
--      gui.printf("Wolf3d episode [%d] map [%d] : %s\n", episode, idx, L.name)
--      show_quests(L.quests)
--    end
--  end

-- FIXME  wolfy_decide_quests(list)

--  dump_levels()

  return list
end


----------------------------------------------------------------

function Wolf3d_setup()

  GAME.player_model = WOLF_PLAYER_MODEL

  GAME.dm = {}

  GAME.hallways  = nil

  Game_merge_tab("things",   WOLF_THINGS)
  Game_merge_tab("monsters", WOLF_MONSTERS)
  Game_merge_tab("bosses",   WOLF_BOSSES)
  Game_merge_tab("mon_give", WOLF_MONSTER_GIVE)

  Game_merge_tab("weapons",  WOLF_WEAPONS)
  Game_merge_tab("pickups", WOLF_PICKUPS)

  Game_merge_tab("quests", WOLF_QUESTS)

  Game_merge_tab("combos", WOLF_COMBOS)
  Game_merge_tab("exits",  WOLF_EXITS)

--??  Game_merge_tab("doors", WOLF_DOORS)
  Game_merge_tab("key_doors", WOLF_KEY_DOORS)

  Game_merge_tab("rooms",  WOLF_ROOMS)
  Game_merge_tab("themes", WOLF_THEMES)

  Game_merge_tab("misc_fabs", WOLF_MISC_PREFABS)

  GAME.toughness_factor = 0.40

  GAME.room_heights = { [128]=50 }
  GAME.space_range  = { 50, 90 }
  GAME.door_probs = { combo_diff=90, normal=20, out_diff=1 }
  GAME.window_probs = { out_diff=0, combo_diff=0, normal=0 }
end


UNFINISHED["wolf3d"] =
{
  label = "Wolfenstein 3D",

  format = "wolf3d",

  setup_func = Wolf3d_setup,

  caps =
  {
     no_height = true,
     no_sky = true,
     one_lock_tex = true,
     elevator_exit = true,
     blocky_items = true,
     blocky_doors = true,
     tiered_skills = true,
     four_dirs = true,
     sealed_start = true,
  },

  params =
  {
    seed_size = 192,  -- actually 3 blocks

    palette_mons = 2,
  },

  hooks =
  {
    get_levels = Wolf3d_get_levels,
  },
}

