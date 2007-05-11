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

require 'x_wolf'
require 'x_spear'


----------------------------------------------------------------


function name_up_theme()

  local SUB_LISTS =
  {
    "monsters", "bosses", "weapons", "pickups",
    "combos",   "exits",  "hallways",
    "hangs",    "crates", "doors",    "mats",
    "lights",   "pics",   "liquids",  "rails",
    "scenery",  "sc_fabs", "rooms",   "themes"
  }

  for zzz,sub in ipairs(SUB_LISTS) do
    if GAME[sub] then
      name_it_up(GAME[sub])
    end
  end
end

function compute_pow_factors()

  local function pow_factor(info)
    return 5 + 19 * info.hp ^ 0.5 * (info.dm / 50) ^ 1.2
  end

  for name,info in pairs(GAME.monsters) do
    info.pow = pow_factor(info)

    con.debugf("Monster %s : power %d\n", name, info.pow)
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
  assert(info)

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

function get_rand_indoor_theme()
  local name,info

  repeat
    name,info = rand_table_pair(GAME.combos)
  until not info.outdoor

  return info
end

function get_rand_exit_combo()
  local name,info
  repeat
    name,info = rand_table_pair(GAME.exits)
  until not info.secret_exit
  return info
end

function get_rand_hallway()
  local name,info = rand_table_pair(GAME.hallways)
  return info
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

function random_door_kind(w)
  local names = {}
  for kind,info in pairs(GAME.doors) do
    if info.w == w then
      table.insert(names,kind)
    end
  end
  assert(#names > 0)
  return rand_element(names)
end

