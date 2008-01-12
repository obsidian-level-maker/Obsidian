----------------------------------------------------------------
--  THEME manager
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

require 'x_doom1'
require 'x_doom2'
require 'x_tnt'
require 'x_plutonia'
require 'x_freedoom'

require 'x_heretic'
require 'x_hexen'


----------------------------------------------------------------


function name_up_theme()

  local SUB_LISTS =
  {
    "things",
    "monsters", "bosses", "weapons", "pickups",
    "combos",   "exits",  "hallways",
    "hangs",    "crates", "doors",    "mats",
    "lights",   "pics",   "liquids",  "rails",
    "scenery",  "rooms",   "themes",
    "sc_fabs",  "misc_fabs", "feat_fabs",
  }

  for zzz,sub in ipairs(SUB_LISTS) do
    if GAME[sub] then
      name_it_up(GAME[sub])
    end
  end
end

function compute_pow_factors()

  -- also copies radius/height values to monster info
  
  local function pow_factor(info)
    return 5 + 19 * info.hp ^ 0.5 * (info.dm / sel(info.melee,80,50)) ^ 1.2
  end

  for name,info in pairs(GAME.monsters) do
    info.pow = pow_factor(info)

    con.debugf("Monster %s : power %d\n", name, info.pow)

    local def = GAME.things[name]
    if not def then
      error("Monster has no definition?? : " .. tostring(name))
    end

    info.r = assert(def.r)
    info.h = assert(def.h)
  end
end

function expand_prefabs(fabs)

  name_it_up(fabs)

  expand_copies(fabs)

  for name,P in pairs(fabs) do
    expand_copies(P.elements)
  
    -- set size values
    local f_deep = #P.structure
    local f_long = #P.structure[1]

    if not P.scale then
      P.scale = 16
    end

    if P.scale == 64 then
      P.long, P.deep = f_long, f_deep

    elseif P.scale == 16 then
      if (f_long % 4) ~= 0 or (f_deep % 4) ~= 0 then
        error("Prefab not a multiple of four: " .. tostring(P.name))
      end

      P.long = int(f_long / 4)
      P.deep = int(f_deep / 4)
    else
      error("Unsupported scale " .. tostring(P.scale) .. " in prefab: " .. tostring(P.name))
    end
  end

  name_it_up(fabs)
end


----------------------------------------------------------------

function get_rand_theme()
--con.debugf("level =\n%s\n", table_to_str(PLAN.level,2))
  assert(PLAN.level.theme_probs)

  local name = rand_key_by_probs(PLAN.level.theme_probs)
  local info = GAME.themes[name]
  if not info then
    error("No such theme: " .. tostring(name))
  end

  return info
end

function get_rand_combo(theme)
  local probs = {}

  for name,combo in pairs(GAME.combos) do
    if combo.theme_probs and combo.theme_probs[theme.name] then
      probs[name] = combo.theme_probs[theme.name]
    end
  end

  if table_empty(probs) then
    error("No matching combos for theme: " .. theme.name)
  end

  local name = rand_key_by_probs(probs)
  local result = GAME.combos[name]

  assert(name)
  assert(result)

  return result
end

function get_rand_roomtype(theme)
  if theme and theme.room_probs then
    local name = rand_key_by_probs(theme.room_probs)
    local info = GAME.rooms[name]
    if not info then error("No such room: " .. name); end
    return info
  else
    local name,info = rand_table_pair(GAME.rooms)
    return info
  end
end

function get_rand_indoor_combo(theme)
  local info
  for loop = 1,35 do
    info = get_rand_combo(theme)
    if not info.outdoor then break; end

    -- use a random theme if unsuccessful with current theme
    if loop==20 or loop==25 or loop==30 then
      theme = get_rand_theme()
    end
  end
  return info
end

function get_rand_exit_combo()
  local name,info
  repeat
    name,info = rand_table_pair(GAME.exits)
  until not info.secret_exit
  return info
end

function get_rand_hallway(theme)

  -- FIXME: duplicate code with get_rand_combo --> MERGE!

  local probs = {}

  for name,hall in pairs(GAME.hallways) do
    if hall.theme_probs and hall.theme_probs[theme.name] then
      probs[name] = hall.theme_probs[theme.name]
    end
  end

  if table_empty(probs) then
    return nil
    -- error("No matching hallways for theme: " .. theme.name)
  end

  local name = rand_key_by_probs(probs)
  local result = GAME.hallways[name]

  assert(name)
  assert(result)

  return result
end

function get_rand_crate()
  local name,info = rand_table_pair(GAME.crates)
  return info
end

function get_rand_rail()
  local name,info = rand_table_pair(GAME.rails)
  return info
end

function choose_liquid()
  assert(GAME.liquids)
  local name,info = rand_table_pair(GAME.liquids)
  return info
end

function find_liquid(name)
  local info = GAME.liquids[name]

  if not info then
    error("Unknown liquid: " .. name)
  end

  return info
end

function get_rand_pic()
  local name,info = rand_table_pair(GAME.pics)
  return info
end

function get_rand_light()
  local name,info = rand_table_pair(GAME.lights)
  return info
end

function get_rand_wall_light()
  local name,info = rand_table_pair(GAME.wall_lights)
  return info
end

function get_rand_door_kind(theme, long)
  assert(GAME.door_fabs)

  for pass = 1,3 do
    -- pass 1: require same theme and long
    -- pass 2: require same long
    -- pass 3: require long <= wanted

    local probs = {}
    for name,info in pairs(GAME.door_fabs) do
      local fab = assert(PREFABS[info.prefab])
      local prob = 10

      if pass == 1 then
        if info.theme_probs then
          prob = info.theme_probs[theme.name] or 0
        else
          prob = 0
        end
      end

      if (pass <  3 and fab.long ~= long) or
         (pass == 3 and fab.long >  long)
      then prob = 0 end

      if prob > 0 then
        probs[name] = prob
      end
    end

    if not table_empty(probs) then
      local name = assert(rand_key_by_probs(probs))
      return assert(GAME.door_fabs[name])
    end
  end -- for pass

  error("No matching doors for theme: " .. theme.name .. " long: " .. tostring(long))
end

