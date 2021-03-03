------------------------------------------------------------------------
--  MODULE: Modded Game extras module
------------------------------------------------------------------------
--
--  Copyright (C) 2019-2021 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

MODDED_GAME_EXTRAS = { }

MODDED_GAME_EXTRAS.ENABLE_DISABLE =
{
  "enable",  _("Enable"),
  "disable", _("Disable"),
}

MODDED_GAME_EXTRAS.HN_CHOICES =
{
  "dec",  _("DECORATE"),
  "none", _("NONE"),
}

MODDED_GAME_EXTRAS.ACTOR_NAME_GEN_CHOICES =
{
  "zs",      _("ZScript - Universal"),
  "zs_pb",   _("ZScript - Project Brutality"),
  "none",    _("NONE"),
}

MODDED_GAME_EXTRAS.HELLSCAPE_NAVIGATOR_TEMPLATE =
{
  BASE =
[[actor m8f_hn_AreaNameMarker_ObAddon : Actor
{
  +NOBLOCKMAP
  +NOGRAVITY
  +DONTSPLASH
  +NOTONAUTOMAP
  +DONTTHRUST
}

]],

  COPIES =
[[actor m8f_hn_AreaNameMarker_NUMNUMNUM : m8f_hn_AreaNameMarker_ObAddon NUMNUMNUM
{
  Tag "NAMENAMENAME"
  Health SIZESIZESIZE
}

]]

}

MODDED_GAME_EXTRAS.QCDE_LOOTBOX_NICE_ITEMS =
{
  lb_backpack =
  {
    id = 15514,
    kind = "powerup",
    add_prob = 5,
    start_prob = 40,
    closet_prob = 10,
    secret_prob = 35,
    storage_prob = 80,
  },

  lb_chest =
  {
    id = 15515,
    kind = "powerup",
    add_prob = 5,
    start_prob = 30,
    closet_prob = 8,
    secret_prob = 35,
    storage_prob = 60,
  },

  lb_reliquary =
  {
    id = 15516,
    kind = "powerup",
    add_prob = 4,
    start_prob = 20,
    closet_prob = 8,
    secret_prob = 35,
    storage_prob = 40,
  },
}

MODDED_GAME_EXTRAS.D4T_THINGS =
{
  d4t_drone =
  {
    id = 13611,
    kind = "other",
    add_prob = 8,
    start_prob = 40,
    closet_prob = 8,
    secret_prob = 60,
  },

  d4t_spectre_rune =
  {
    id = 13679, kind = "powerup", level = 2,
    add_prob = 3, secret_prob = 6,
  },

  d4t_prowler_rune =
  {
    id = 13680, kind = "powerup", level = 2,
    add_prob = 3, secret_prob = 6,
  },

  d4t_cacodemon_rune =
  {
    id = 13673, kind = "powerup", level = 3,
    add_prob = 2, secret_prob = 4,
  },

  d4t_fatso_rune =
  {
    id = 13675, kind = "powerup", level = 4,
    add_prob = 2, secret_prob = 4,
  },

  d4t_revenant_rune =
  {
    id = 13677, kind = "powerup", level = 4,
    add_prob = 2, secret_prob = 4,
  },

  d4t_arach_rune =
  {
    id = 13670, kind = "powerup", level = 5,
    add_prob = 1.4, secret_prob = 2.8,
  },

  d4t_hellknight_rune =
  {
    id = 13682, kind = "powerup", level = 6,
    add_prob = 1.4, secret_prob = 2.8,
  },

  d4t_painelemental_rune =
  {
    id = 13676, kind = "powerup", level = 7,
    add_prob = 1.4, secret_prob = 2.8,
  },

  d4t_baron_rune =
  {
    id = 13672, kind = "powerup", level = 7,
    add_prob = 1, secret_prob = 2,
  },

  d4t_harvester_rune =
  {
    id = 13681, kind = "powerup", level = 8,
    add_prob = 1, secret_prob = 2,
  },

  d4t_summoner_rune =
  {
    id = 13671, kind = "powerup", level = 8,
    add_prob = 1, secret_prob = 2,
  },

  d4t_cyberdemon_rune =
  {
    id = 13674, kind = "powerup", level = 9,
    add_prob = 1, secret_prob = 2,
  },

  d4t_mastermind_rune =
  {
    id = 13678, kind = "powerup", level = 9,
    add_prob = 1, secret_prob = 2,
  },
}

MODDED_GAME_EXTRAS.D4T_MONS =
{
  d4t_gore_nest =
  {
    id = 13511,
    r = 112,
    h = 5,
    level = 1,
    boss_type = "tough",
    boss_prob = 50,
    prob = 8,
    health = 2500,
    damage = 25,
    attack = "hitscan",
    density = 0.1,
    cage_factor = 0,
    trap_factor = 0,
  },

  d4t_gore_nest_rank_n_file =
  {
    id = 13511,
    r = 112,
    h = 5,
    level = 3,
    prob = 17,
    health = 2500,
    damage = 25,
    attack = "hitscan",
    density = 0.05,
    cage_factor = 0,
    trap_factor = 0,
  },
}

function MODDED_GAME_EXTRAS.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end

  if PARAM.hn_markers ~= "none" then
    MODDED_GAME_EXTRAS.init_hn_info()
  end

  if PARAM.custom_actor_names ~= "none" then
    MODDED_GAME_EXTRAS.generate_custom_actor_names(PARAM.custom_actor_names)
  end

  if PARAM.qcde_lootboxes == "enable" then
    MODDED_GAME_EXTRAS.add_qcde_lootboxes()
  end

  if PARAM.d4t_ents == "enable" then
    MODDED_GAME_EXTRAS.add_d4t_ents()
  end
end

function MODDED_GAME_EXTRAS.init_hn_info()
  HN_INFO_TABLE = {}

  PARAM.hn_thing_start_offset = 15000
end

function MODDED_GAME_EXTRAS.create_hn_info()

  -- skip Hellscape Navigator stuff on prebuilt levels (no info to draw from)
  -- and procedural gotchas (what the heck are you gonna navigate in two rooms?)
  if LEVEL.prebuilt then return end
  if LEVEL.is_procedural_gotcha then return end

  if PARAM.hn_markers == "none" or not PARAM.hn_markers then
    return
  end

  gui.printf("--==| Hellscape Navigator Support |==--\n\n")

  -- function to find the best place to put the HN marker on in
  -- MSSP-TODO: Marker placement sometimes fails, figure out a way to place them
  -- on a preferably clean spot
  local function find_closest_seed_to_center(R)
    local cx = (R.sx1 + R.sx2) / 2
    local cy = (R.sy1 + R.sy2) / 2

    local seed_list = {}
    for _,A in pairs(R.areas) do
      if not A.chunk
      or (A.chunk and not A.chunk.content) then
        for _,S in pairs(A.seeds) do

          -- skip this area if it's a closet or a joiner
          -- want to make sure the entity gets placed... somewhere.
          if S.area.chunk then
            if S.area.chunk.kind == "closet"
            or S.area.chunk.kind == "joiner" then
              goto continue
            end
          end

          S.distance_from_room_center = geom.dist(cx, cy, S.sx, S.sy)
          table.insert(seed_list, S)
          ::continue::
        end
      end
    end

    table.sort(seed_list, function(A,B)
    return A.distance_from_room_center < B.distance_from_room_center end)

    return seed_list[1]
  end

  -- get name, evaluate rooms in the zone for recoloring
  -- based on the zone goal
  local function generate_name(zone)
    local name = Naming_grab_one(LEVEL.name_class)

    if #zone.rooms == 1 and zone.rooms[1].is_exit then
      if zone.rooms[1].conns then
        name = zone.rooms[1].conns[1].R1.zone.hn_name
        zone.single_exit = true
      end
    end

    if not zone.single_exit then
      gui.printf("ZONE_" .. zone.id .. " name: " .. name .. "\n")
    else
      gui.printf("ZONE_" .. zone.id .. " name: " .. name .. " (single exit," ..
      " borrows prior connecting zone's name)\n")
    end

    zone.hn_name = name
  end

  -- decide goal for room
  local function fetch_room_goal(R)
    local goal_string = ""
    local goal_objective = "none"
    local goal_obstacles = {}

    -- check for locked gates (keyed or switched doors)
    for _,C in pairs(R.conns) do
      if C.R2 == R then goto continue end
      if C.lock then
        if C.lock.kind == "quest" then
          for _,G in pairs(C.lock.goals) do
            if G.item == "k_yellow" or G.item == "ks_yellow" then
              goal_obstacles.yellow_door = true
            elseif G.item == "k_blue" or G.item == "ks_blue" then
              goal_obstacles.blue_door = true
            elseif G.item == "k_red" or G.item == "ks_red" then
              goal_obstacles.red_door = true
            elseif G.kind == "SWITCH" then
              goal_obstacles.barred_door = true
            end
          end
        end
      end
      ::continue::
    end

    -- check for goal contents (keys or quest switches)
    if R.goals then
      if R.goals[1] then
        local goal_info = R.goals[1]

        if goal_info.kind == "SWITCH" then

          goal_objective = "switch"
        elseif goal_info.kind == "KEY" then

          if goal_info.item == "k_yellow" or
          goal_info.item == "ks_yellow" then

            goal_objective = "yellow_key"

          elseif goal_info.item == "k_blue" or
          goal_info.item == "ks_blue" then

            goal_objective = "blue_key"

          elseif goal_info.item == "k_red" or
          goal_info.item == "ks_red" then

            goal_objective = "red_key"
          else

            goal_objective = "none"
          end
        elseif goal_info.kind == "EXIT" then

          goal_objective = "exit"
        end
      end
    end

    -- generate strings for presence of doors
    -- locked by goal items/switches
    if goal_obstacles then

      local door_type = "none"
      if goal_obstacles.yellow_door and goal_obstacles.blue_door
      and goal_obstacles.red_door then
        goal_string = goal_string .. " (All-Key Door)"
        door_type = "all_key"
      end

      if door_type ~= "all_key" then
        if goal_obstacles.yellow_door then
          goal_string = goal_string .. " (Yellow Door)"
        end
        if goal_obstacles.blue_door then
          goal_string = goal_string .. " (Blue Door)"
        end
        if goal_obstacles.red_door then
          goal_string = goal_string .. " (Red Door)"
        end
        if goal_obstacles.barred_door then
          goal_string = goal_string .. " (Barred Door)"
        end
      end
    end

    -- generate strings for presence of goal items
    if goal_objective == "yellow_key" then
      goal_string = goal_string .. " (Yellow Key Nearby)"
    end
    if goal_objective == "blue_key" then
      goal_string = goal_string .. " (Blue Key Nearby)"
    end
    if goal_objective == "red_key" then
      goal_string = goal_string .. " (Red Key Nearby)"
    end
    if goal_objective == "switch" then
      goal_string = goal_string .. " (Switch Nearby)"
    end
    if goal_objective == "exit" then
      goal_string = goal_string .. " (Exit Nearby)"
    end

    if R.is_secret then
      goal_string = goal_string .. " (Secret Area #" .. PARAM.hn_secret_count .. ")"
      PARAM.hn_secret_count = PARAM.hn_secret_count + 1
    end

    if R.lev_along and not R.is_start and #LEVEL.rooms > 2 then
      goal_string = goal_string .. " (" .. int(R.lev_along * 100) .. "%%)"
    end

    return goal_string
  end

  -- generate information for the HN marker
  local function make_room_info(R)
    local info = {}

    info.name = R.zone.hn_name

    -- attach goal information
    info.name = "Location: " .. info.name .. fetch_room_goal(R)

    info.editor_num = PARAM.hn_thing_start_offset

    local x_span = (R.sx2 - R.sx1) * SEED_SIZE
    local y_span = (R.sy2 - R.sy1) * SEED_SIZE

    info.radius = (x_span + y_span)/2
    info.env = R:get_env()

    PARAM.hn_thing_start_offset = PARAM.hn_thing_start_offset + 1

    local prefered_S = find_closest_seed_to_center(R)
    if not prefered_S then
      gui.printf("WTF man where do I put the HN marker here??!?!! " ..
      "WHERE MAN?!?! WHGEREREE???!!!! OH GOD HELP ME I CAN'T COMPUTER\n")
      return
    end

    table.insert(HN_INFO_TABLE, info)

    hn_marker = {
      x = prefered_S.mid_x,
      y = prefered_S.mid_y,
      z = prefered_S.area.ceil_h,
      id = info.editor_num
    }

    raw_add_entity(hn_marker)
  end

  --== Hellscape Navigator init ==--
  for _,Z in pairs(LEVEL.zones) do
    generate_name(Z)
  end

  PARAM.hn_secret_count = 1
  for _,R in pairs(LEVEL.rooms) do
    make_room_info(R)
  end
end

function MODDED_GAME_EXTRAS.generate_hn_decorate()

  if PARAM.hn_markers == "none" or not PARAM.hn_markers then
    return
  end

  local decorate_string = MODDED_GAME_EXTRAS.HELLSCAPE_NAVIGATOR_TEMPLATE.BASE

  -- create decorate file!
  for _,I in pairs(HN_INFO_TABLE) do
    local name = I.name
    local editor_num = I.editor_num
    local radius = I.radius

    local thing_chunk = MODDED_GAME_EXTRAS.HELLSCAPE_NAVIGATOR_TEMPLATE.COPIES
    thing_chunk = string.gsub(thing_chunk, "NUMNUMNUM", editor_num)
    thing_chunk = string.gsub(thing_chunk, "NAMENAMENAME", name)
    thing_chunk = string.gsub(thing_chunk, "SIZESIZESIZE", int(radius))

    decorate_string = decorate_string .. thing_chunk
  end

  SCRIPTS.hn_marker_decorate_lines = decorate_string
end



MODDED_GAME_EXTRAS.ACTOR_NAME_SCRIPT =
[[/* Content of this list is pulled directly from ObAddon's names libraries. */

class bossNameHandler : EventHandler
{
  string exoticSyllables[SYL_NUM + 1];
  string demonTitles[TITLE_NUM + 1];
  string humanFirstNames[F_NUM];
  string humanLastNames[L_NUM];
  string humanNicknames[NICK_NUM];

  string mon_name;
  string obit;
  string tag_string;

  bool randOdds(int x)
  {
    if (x >= Random(1,100))
    {
      return true;
    }
    else
    {
      return false;
    }

  }

  bool isRankedDemon(Actor a)
  {
    if (a.Species == "IAmTheBoss") return false;
    if (a.bBoss) return true;

    /* Check for Champions-morphed things */
    /* Inventory token;
    token = a.FindInventory("champion_TitanToken", true);
    token = a.FindInventory("champion_SplitterToken", true);
    token = a.FindInventory("champion_HeartToken", true);
    if(token) return true; */

    /* Vanilla Oblige sets these up as "bosses" so might as well. */
    if (a is "BaronOfHell") return true;
    if (a is "Archvile") return true;
    if (a is "PainElemental") return true;
    if (a is "HellKnight") return true;

    GDEMONS_COMPAT_CHECKS

    return false;
  }

  bool isSemiRankedDemon(Actor a)
  {
    if (a is "Cacodemon") return true;
    if (a is "Fatso") return true;
    if (a is "Revenant") return true;
    if (a is "Arachnotron") return true;

    SDEMONS_COMPAT_CHECKS

    return false;
  }

  bool isRanklessDemon(Actor a)
  {
    if (a is "DoomImp") return true;
    if (a is "Demon") return true;
    if (a is "Spectre") return true;

    LDEMONS_COMPAT_CHECKS

    return false;
  }

  bool isHuman(Actor a)
  {
    if (a is "ZombieMan") return true;
    if (a is "ShotgunGuy") return true;
    if (a is "ChaingunGuy") return true;
    if (a is "ScriptedMarine") return true;

    HUMAN_COMPAT_CHECKS

    return false;
  }

  void nameGenInit()
  {
    SYLLABLE_LIST
    EVIL_TITLE_LIST
    FIRST_NAMES_LIST
    LAST_NAMES_LIST
    HUMAN_TITLES_LIST
  }

  string getExoticSyls()
  {
    return exoticSyllables[Random(0,SYL_NUM)];
  }

  string getExoticName()
  {
    string tmp;

    switch(Random(1,6))
    {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        tmp = getExoticSyls() .. getExoticSyls();
        break;
      case 6:
        tmp = getExoticSyls() .. getExoticSyls() .. getExoticSyls();
        break;
    }

    return tmp;
  }

  string getDemonTitles()
  {
    return demonTitles[Random(0,TITLE_NUM)];
  }

  string getFancyDemonTag()
  {
    return getExoticName() .. " the " .. getDemonTitles();
  }

  string getNormalDemonTag()
  {
    return getExoticName();
  }

  string getRandomDemonTag()
  {
    string tmp;

    switch(Random(1,2))
    {
      case 1:
        tmp = getFancyDemonTag();
        break;
      case 2:
        tmp = getNormalDemonTag();
        break;
    }

    return tmp;
  }

  string getHumanTag()
  {
    string tmp;

    switch(Random(1,4))
    {
      case 1:
      case 2:
      case 3:
        tmp = humanFirstNames[Random(0, F_NUM - 1)] .. ' ' .. humanLastNames[Random(0, L_NUM - 1)];
        break;
      case 4:
        tmp = humanFirstNames[Random(0, F_NUM - 1)] .. ' "' .. humanNicknames[Random(0, NICK_NUM - 1)] .. '" ' .. humanLastNames[Random(0, L_NUM - 1)];
        break;
    }

    return tmp;
  }

  string bootifyName(string inputName)
  {
    string firstLetter;

    firstLetter = inputName.Left(1);
    firstLetter.toUpper();
    inputName.Remove(0,1);
    inputName = firstLetter .. inputName;

    return inputName;
  }

  override void WorldLoaded(WorldEvent e)
  {
    nameGenInit();
  }

  override void WorldThingSpawned(WorldEvent e)
  {
    if (e.Thing)
    {
      mon_name = "";

      if (isRanklessDemon(e.Thing))
      {
        mon_name = getNormalDemonTag();
      }

      if (isSemiRankedDemon(e.Thing))
      {
        mon_name = getRandomDemonTag();
      }

      if (isRankedDemon(e.Thing))
      {
        mon_name = getFancyDemonTag();
      }

      if (isHuman(e.Thing))
      {
        mon_name = getHumanTag();
      }

      // universal check if all other checks failed
      if (e.Thing.bIsMonster && e.Thing.bCountKill
      && mon_name == "")
      {
        if(e.Thing.Health)
        {
          int mon_hp = e.Thing.Health;

          mon_hp = Floor((mon_hp-100) / 2);

          if(randOdds(mon_hp))
          {
            mon_name = getFancyDemonTag();
          }else
          {
            mon_name = getNormalDemonTag();
          }

          // human-ish check
          obit = e.Thing.Obituary;

          if(obit)
          {
            if(obit.IndexOf("$", 0) > -1)
            {
              obit = Stringtable.localize(obit);
            }
            obit = obit.MakeLower();

            if(obit.IndexOf("human", 0) > -1
            || obit.IndexOf("zombie", 0) > -1
            || obit.IndexOf("former", 0) > -1
            || obit.IndexOf("sergeant", 0) > -1
            || obit.IndexOf("guy", 0) > -1
            || obit.IndexOf("scientist", 0) > -1
            || obit.IndexOf("gunner", 0) > -1
            || obit.IndexOf("dude", 0) > -1
            || obit.IndexOf("girl", 0) > -1
            || obit.IndexOf("female", 0) > -1
            || obit.IndexOf("security", 0) > -1
            || obit.IndexOf("zsec", 0) > -1
            || obit.IndexOf("razer", 0) > -1)
            {
              mon_name = getHumanTag();
            }
          }

          tag_string = e.Thing.GetTag();

          if(tag_string)
          {
            if(tag_string.IndexOf("$", 0) > -1)
            {
              tag_string = Stringtable.localize(tag_string);
            }
            tag_string = tag_string.MakeLower();

            if(tag_string.IndexOf("human", 0) > -1
            || tag_string.IndexOf("zombie", 0) > -1
            || tag_string.IndexOf("former", 0) > -1
            || tag_string.IndexOf("sergeant", 0) > -1
            || tag_string.IndexOf("guy", 0) > -1
            || tag_string.IndexOf("scientist", 0) > -1
            || tag_string.IndexOf("gunner", 0) > -1
            || tag_string.IndexOf("dude", 0) > -1
            || tag_string.IndexOf("girl", 0) > -1
            || tag_string.IndexOf("female", 0) > -1
            || tag_string.IndexOf("security", 0) > -1
            || tag_string.IndexOf("zsec", 0) > -1
            || tag_string.IndexOf("razer", 0) > -1)
            {
              mon_name = getHumanTag();
            }
          }
        }
      }

      if (mon_name != "")
      {
        mon_name = bootifyName(mon_name);
        e.Thing.SetTag(mon_name);
        e.Thing.giveInventory("ObAddonNameToken", 1);
      }
    }
  }
}

class ObAddonNameToken : Inventory
{
}
]]

MODDED_GAME_EXTRAS.PB_HUMAN_CHECK =
[[    if (a is "PB_Zombieman") return true;
    if (a is "PB_CarbineZombieman") return true;
    if (a is "PB_HelmetZombieman") return true;
    if (a is "PB_PistolZombieman2") return true;
    if (a is "PB_PistolZombieman1") return true;
    if (a is "PB_ZombieScientist") return true;
    if (a is "Zombie_Man") return true;
    if (a is "Labguy") return true;
    if (a is "ShotgunGuy1") return true;
    if (a is "ChaingunGuy1") return true;
    if (a is "HellTrooper") return true;

    if (a is "Marine_Rifle") return true;

    if (a is "ImpaledMarineAlive1") return true;
    if (a is "ImpaledMarineAlive2") return true;
]]

MODDED_GAME_EXTRAS.PB_LESSER_DEMONS_CHECK =
[[
    if (a is "NamiDarkImp") return true;
    if (a is "NetherDarkImp") return true;
    if (a is "STDarkImp") return true;
    if (a is "VoidDarkImp") return true;
    if (a is "Imp") return true;
    if (a is "BullDemon") return true;
]]

MODDED_GAME_EXTRAS.PB_STANDARD_DEMONS_CHECK =
[[
    if (a is "Arachnophyte") return true;
    if (a is "Aracnorb") return true;
    if (a is "Daedabus") return true;
    if (a is "Afrit") return true;
    if (a is "Watcher") return true;
    if (a is "Revenant1") return true;
]]

MODDED_GAME_EXTRAS.PB_GREATER_DEMONS_CHECK =
[[
    if (a is "OverLord") return true;
    if (a is "Cyberbaron") return true;
    if (a is "FleshWizard") return true;
    if (a is "Hellion") return true;
    if (a is "CyberPaladin") return true;
    if (a is "ICEVILE") return true;

    if (a is "BossBrainBase") return true;
    if (a is "TheSpiderMastermind") return true;
    if (a is "Motherdemon") return true;
    if (a is "Juggernaut") return true;
]]

function MODDED_GAME_EXTRAS.generate_custom_actor_names(mode)
  local actor_name_script = ""

  local syl_list = "\n"
  local title_list = "\n"

  local title_num = 0
  local syl_num = 0

  local first_name_list = "\n"
  local last_name_list = "\n"
  local human_titles_list = "\n"

  local f_num = 0
  local l_num = 0
  local t_num = 0

  actor_name_script = actor_name_script .. MODDED_GAME_EXTRAS.ACTOR_NAME_SCRIPT

  for name,prob in pairs(namelib.SYLLABLES.e) do
    syl_list = syl_list .. '    exoticSyllables[' .. syl_num .. ']="' .. name .. '";\n'
    syl_num = syl_num + 1
  end

  for name,prob in pairs(ZDOOM_STORIES.EVIL_TITLES) do
    title_list = title_list .. '    demonTitles[' .. title_num .. ']="' .. name .. '";\n'
    title_num = title_num + 1
  end

  for name,prob in pairs(namelib.HUMAN_NAMES.f) do
    local dupe_count = prob
    while(dupe_count > 0) do
      first_name_list = first_name_list .. '    humanFirstNames[' .. f_num .. ']="' .. name .. '";\n'
      dupe_count = dupe_count - 1
      f_num = f_num + 1
    end
  end

  for name,prob in pairs(namelib.HUMAN_NAMES.l) do
    last_name_list = last_name_list .. '    humanLastNames[' .. l_num .. ']="' .. name .. '";\n'
    l_num = l_num + 1
  end

  for name,prob in pairs(namelib.HUMAN_NAMES.t) do
    human_titles_list = human_titles_list .. '    humanNicknames[' .. t_num .. ']="' .. name .. '";\n'
    t_num = t_num + 1
  end


  actor_name_script = string.gsub( actor_name_script, "SYLLABLE_LIST", syl_list )
  actor_name_script = string.gsub( actor_name_script, "EVIL_TITLE_LIST", title_list )

  actor_name_script = string.gsub( actor_name_script, "SYL_NUM", syl_num - 1 )
  actor_name_script = string.gsub( actor_name_script, "TITLE_NUM", title_num - 1 )

  actor_name_script = string.gsub( actor_name_script, "FIRST_NAMES_LIST", first_name_list)
  actor_name_script = string.gsub( actor_name_script, "LAST_NAMES_LIST", last_name_list)
  actor_name_script = string.gsub( actor_name_script, "HUMAN_TITLES_LIST", human_titles_list)

  actor_name_script = string.gsub( actor_name_script, "F_NUM", f_num)
  actor_name_script = string.gsub( actor_name_script, "L_NUM", l_num)
  actor_name_script = string.gsub( actor_name_script, "NICK_NUM", t_num)

  if mode == "zs_pb" then
    actor_name_script = string.gsub( actor_name_script, "HUMAN_COMPAT_CHECKS", "\n" .. MODDED_GAME_EXTRAS.PB_HUMAN_CHECK)
    actor_name_script = string.gsub( actor_name_script, "LDEMONS_COMPAT_CHECKS", "\n" .. MODDED_GAME_EXTRAS.PB_LESSER_DEMONS_CHECK)
    actor_name_script = string.gsub( actor_name_script, "SDEMONS_COMPAT_CHECKS", "\n" .. MODDED_GAME_EXTRAS.PB_STANDARD_DEMONS_CHECK)
    actor_name_script = string.gsub( actor_name_script, "GDEMONS_COMPAT_CHECKS", "\n" .. MODDED_GAME_EXTRAS.PB_GREATER_DEMONS_CHECK)
  elseif mode == "zs" then
    actor_name_script = string.gsub( actor_name_script, "HUMAN_COMPAT_CHECKS", " ")
    actor_name_script = string.gsub( actor_name_script, "LDEMONS_COMPAT_CHECKS", " ")
    actor_name_script = string.gsub( actor_name_script, "SDEMONS_COMPAT_CHECKS", " ")
    actor_name_script = string.gsub( actor_name_script, "GDEMONS_COMPAT_CHECKS", " ")
  end

  SCRIPTS.actor_name_script = actor_name_script
end



function MODDED_GAME_EXTRAS.add_qcde_lootboxes()
  table.name_up(MODDED_GAME_EXTRAS.QCDE_LOOTBOX_NICE_ITEMS)

  GAME.NICE_ITEMS = table.deep_merge(GAME.NICE_ITEMS, MODDED_GAME_EXTRAS.QCDE_LOOTBOX_NICE_ITEMS, 2)
end



function MODDED_GAME_EXTRAS.add_d4t_ents()
  table.name_up(MODDED_GAME_EXTRAS.D4T_THINGS)
  table.name_up(MODDED_GAME_EXTRAS.D4T_MONS)

  GAME.NICE_ITEMS = table.deep_merge(GAME.NICE_ITEMS, MODDED_GAME_EXTRAS.D4T_THINGS, 2)
  GAME.MONSTERS = table.deep_merge(GAME.MONSTERS, MODDED_GAME_EXTRAS.D4T_MONS, 2)
end



----------------------------------------------------------------

OB_MODULES["modded_game_extras"] =
{
  label = _("Modded Game Extras"),

  side = "left",
  priority = 75,

  game = "doomish",

  hooks =
  {
    setup = MODDED_GAME_EXTRAS.setup,
    end_level = MODDED_GAME_EXTRAS.create_hn_info,
    all_done = MODDED_GAME_EXTRAS.generate_hn_decorate
  },

  tooltip = "Offers extra features and expanded support for various mods.",

  options =
  {
    hn_markers =
    {
      name = "hn_markers",
      label=_("HN Markers"),
      choices=MODDED_GAME_EXTRAS.HN_CHOICES,
      tooltip = "Adds support for m8f's Hellscape Navigator by generating " ..
      "name markers in the map per room.",
      default = "none",
      priority = 5,
      gap = 1,
    },

    custom_actor_names =
    {
      name = "custom_actor_names",
      label=_("Custom Actor Names"),
      choices=MODDED_GAME_EXTRAS.ACTOR_NAME_GEN_CHOICES,
      tooltip = "Renames tags of monsters with generated names. Humans recieve human names, " ..
      "demons recieve exotic names.\n" ..
      "Best used with TargetSpy or other healthbar mods to see the name.\n" ..
      "Uses class inheritance and string comparisons to determine monster species (human or demon). "..
      "Use compatibility options only when necessary, preferably use Universal option instead.",
      default = "none",
      priority = 4,
      gap = 1,
    },

    hd_cover_walls =
    {
      name = "hd_cover_walls",
      label=_("HD Cover Walls"),
      choices=MODDED_GAME_EXTRAS.ENABLE_DISABLE,
      tooltip = "Adds some Hideous Destructor-specific fabs such as walls with " ..
      "cover to serve Hideous Destructor gameplay better. " ..
      "It is recommended to keep this disabled if you are not " ..
      "playing Hideous Destructor as these fabs will interfere with non-HD gameplay.",
      default = "disable",
      priority = 3,
    },

    qcde_lootboxes =
    {
      name = "qcde_lootboxes",
      label = _("QC:DE Lootboxes"),
      choices = MODDED_GAME_EXTRAS.ENABLE_DISABLE,
      tooltip = "Adds Quake Champions: Doom Edition Lootboxes as nice item pickups.",
      default = "disable",
      priority = 2,
    },

    d4t_ents =
    {
      name = "d4t_ents",
      label = _("D4T Entities"),
      choices = MODDED_GAME_EXTRAS.ENABLE_DISABLE,
      tooltip = "Adds Death Foretold field drones into items table and " ..
                "gore nests as potential minor boss monsters.",
      default = "disable",
      priority = 1,
    },
  },
}
