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

function get_rand_theme()
--gui.debugf("level =\n%s\n", table_to_str(PLAN.level,2))
  assert(PLAN.level.theme_probs)

  local name = rand.key_by_probs(PLAN.level.theme_probs)
  local info = GAME.FACTORY.themes[name]
  assert(info)

  info.name = name

  return info
end

function get_rand_combo(theme)
  local probs = {}

  for name,combo in pairs(GAME.FACTORY.combos) do
    if combo.theme_probs and combo.theme_probs[theme.name] then
      probs[name] = combo.theme_probs[theme.name]
    end
  end

  if table.empty(probs) then
    error("No matching combos for theme: " .. theme.name)
  end

  local name = rand.key_by_probs(probs)
  local result = GAME.FACTORY.combos[name]

  assert(name)
  assert(result)

  return result
end

function get_rand_roomtype(theme)
  if theme and theme.room_probs then
    local name = rand.key_by_probs(theme.room_probs)
    local info = GAME.FACTORY.rooms[name]
    if not info then error("No such room: " .. name); end
    return info
  else
    local name,info = rand.table_pair(GAME.FACTORY.rooms)
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
    name,info = rand.table_pair(GAME.FACTORY.exits)
  until not info.secret_exit
  return info
end

function get_rand_secret_exit_combo()
  local name,info
  repeat
    name,info = rand.table_pair(GAME.FACTORY.exits)
  until info.secret_exit
  return info
end

function get_rand_hallway(theme)

  -- FIXME: duplicate code with get_rand_combo --> MERGE!

  local probs = {}

  for name,hall in pairs(GAME.FACTORY.hallways) do
    if hall.theme_probs and hall.theme_probs[theme.name] then
      probs[name] = hall.theme_probs[theme.name]
    end
  end

  if table.empty(probs) then
    return nil
    -- error("No matching hallways for theme: " .. theme.name)
  end

  local name = rand.key_by_probs(probs)
  local result = GAME.FACTORY.hallways[name]

  assert(name)
  assert(result)

  return result
end

function get_rand_crate()
  local name,info = rand.table_pair(GAME.FACTORY.crates)
  return info
end

function get_rand_rail()
  local name,info = rand.table_pair(GAME.FACTORY.rails)
  return info
end

function choose_liquid()
  assert(GAME.FACTORY.liquids)
  local name,info = rand.table_pair(GAME.FACTORY.liquids)
  return info
end

function find_liquid(name)
  local info = GAME.FACTORY.liquids[name]

  if not info then
    error("Unknown liquid: " .. name)
  end

  return info
end

function get_rand_pic()
  local name,info = rand.table_pair(GAME.FACTORY.pics)
  return info
end

function get_rand_light()
  local name,info = rand.table_pair(GAME.FACTORY.lights)
  return info
end

function get_rand_wall_light()
  local name,info = rand.table_pair(GAME.FACTORY.wall_lights)
  return info
end

function get_rand_door_kind(theme, long)
  assert(GAME.FACTORY.door_fabs)

  for pass = 1,3 do
    -- pass 1: require same theme and long
    -- pass 2: require same long
    -- pass 3: require long <= wanted

    local probs = {}
    for name,info in pairs(GAME.FACTORY.door_fabs) do
      local fab = non_nil(GAME.FACTORY.PREFABS[info.prefab])
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
      return non_nil(GAME.FACTORY.door_fabs[name])
    end
  end -- for pass

  error("No matching doors for theme: " .. theme.name .. " long: " .. tostring(long))
end

