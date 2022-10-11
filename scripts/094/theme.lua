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
      table.name_up(GAME[sub])
    end
  end
end

function compute_pow_factors()

  -- also copies radius/height values to monster info
  
  local function pow_factor(info)
    return 5 + 19 * info.hp ^ 0.5 * (info.dm / sel(info.melee,80,50)) ^ 1.2
  end

  for name,info in pairs(GAME.factory.monsters) do
    info.pow = pow_factor(info)

    gui.debugf("Monster %s : power %d\n", name, info.pow)

    local def = GAME.factory.things[name]
    if not def then
      error("Monster has no definition?? : " .. tostring(name))
    end

    info.r = non_nil(def.r)
    info.h = non_nil(def.h)
  end
end

function expand_prefabs(fabs)

  table.name_up(fabs)

  table.expand_copies(fabs)

  for name,P in pairs(fabs) do
    table.expand_copies(P.elements)
  
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

  table.name_up(fabs)
end


----------------------------------------------------------------

function get_rand_theme()
--gui.debugf("level =\n%s\n", table_to_str(PLAN.level,2))
  assert(PLAN.level.theme_probs)

  local name = rand.key_by_probs(PLAN.level.theme_probs)
  local info = GAME.factory.themes[name]
  assert(info)

  return info
end

function get_rand_combo(theme)
  local probs = {}

  for name,combo in pairs(GAME.factory.combos) do
    if combo.theme_probs and combo.theme_probs[theme.name] then
      probs[name] = combo.theme_probs[theme.name]
    end
  end

  if table.empty(probs) then
    error("No matching combos for theme: " .. theme.name)
  end

  local name = rand.key_by_probs(probs)
  local result = GAME.factory.combos[name]

  assert(name)
  assert(result)

  return result
end

function get_rand_roomtype(theme)
  if theme and theme.room_probs then
    local name = rand.key_by_probs(theme.room_probs)
    local info = GAME.factory.rooms[name]
    if not info then error("No such room: " .. name); end
    return info
  else
    local name,info = rand.table_pair(GAME.factory.rooms)
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
    name,info = rand.table_pair(GAME.factory.exits)
  until not info.secret_exit
  return info
end

function get_rand_hallway(theme)

  -- FIXME: duplicate code with get_rand_combo --> MERGE!

  local probs = {}

  for name,hall in pairs(GAME.factory.hallways) do
    if hall.theme_probs and hall.theme_probs[theme.name] then
      probs[name] = hall.theme_probs[theme.name]
    end
  end

  if table.empty(probs) then
    return nil
    -- error("No matching hallways for theme: " .. theme.name)
  end

  local name = rand.key_by_probs(probs)
  local result = GAME.factory.hallways[name]

  assert(name)
  assert(result)

  return result
end

function get_rand_crate()
  local name,info = rand.table_pair(GAME.factory.crates)
  return info
end

function get_rand_rail()
  local name,info = rand.table_pair(GAME.factory.rails)
  return info
end

function choose_liquid()
  assert(GAME.factory.liquids)
  local name,info = rand.table_pair(GAME.factory.liquids)
  return info
end

function find_liquid(name)
  local info = GAME.factory.liquids[name]

  if not info then
    error("Unknown liquid: " .. name)
  end

  return info
end

function get_rand_pic()
  local name,info = rand.table_pair(GAME.factory.pics)
  return info
end

function get_rand_light()
  local name,info = rand.table_pair(GAME.factory.lights)
  return info
end

function get_rand_wall_light()
  local name,info = rand.table_pair(GAME.factory.wall_lights)
  return info
end

function get_rand_door_kind(theme, long)
  assert(GAME.factory.door_fabs)

  for pass = 1,3 do
    -- pass 1: require same theme and long
    -- pass 2: require same long
    -- pass 3: require long <= wanted

    local probs = {}
    for name,info in pairs(GAME.factory.door_fabs) do
      local fab = non_nil(v094_PREFABS[info.prefab])
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

    if not table.empty(probs) then
      local name = non_nil(rand.key_by_probs(probs))
      return non_nil(GAME.factory.door_fabs[name])
    end
  end -- for pass

  error("No matching doors for theme: " .. theme.name .. " long: " .. tostring(long))
end

