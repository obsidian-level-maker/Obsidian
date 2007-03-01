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

function expand_prefabs(LIST)

  -- Prefabs are made simpler using the "copy" statement,
  -- which this code expands to get self-contained tables.

  local function expand_element(P, name, E)
    E.expanding = true

    -- firstly handle copies
    if E.copy then
      local source = P.elements[E.copy]

      if not source then
        error("Bad prefab element " .. name .. " : cannot copy " .. tostring(E.copy))
      end
      if source.expanding then
        error("Bad prefab element " .. name .. " : cyclic copy refs!")
      end

      -- make sure source element has been expanded (RECURSIVE)
      if source.copy then
        expand_element(P, E.copy, source)
      end

      E.copy = nil

      E = copy_and_merge(source, E)

      P.elements[name] = E
    end

    E.expanding = nil
  end

  local function expand_it(name, P)
    P.expanding = true

    -- firstly handle copies
    if P.copy then
      local source = LIST[P.copy]

      if not source then
        error("Bad prefab " .. name .. " : cannot copy " .. tostring(P.copy))
      end
      if source.expanding then
        error("Bad prefab " .. name .. " : cyclic copy refs!")
      end

      -- make sure source prefab has been expanded (RECURSIVE)
      if source.copy then
        expand_it(P.copy, source)
      end
      
      P.copy = nil

      P = copy_and_merge(source, P)

      LIST[name] = P
    end

    -- now do the element list
    for elem,E in pairs(P.elements) do
      expand_element(P, elem, E)
    end

    P.expanding = nil
  end

  -- expand_prefabs

  for name,P in pairs(LIST) do
    expand_it(name, P)
    con.debugf("Prefab %s =\n%s\n", name, table_to_string(LIST[name], 3))
  end
end


----------------------------------------------------------------

function get_rand_theme()
  local name,info = rand_table_pair(THEME.themes)
  return info
end

function get_rand_indoor_theme()
  local name,info

  repeat
    name,info = rand_table_pair(THEME.themes)
  until not info.outdoor

  return info
end

function get_rand_exit_theme()
  local name,info = rand_table_pair(THEME.exits)
  return info
end

function get_rand_hallway()
  local name,info = rand_table_pair(THEME.hallways)
  return info
end

function get_rand_crate()
  local name,info = rand_table_pair(THEME.crates)
  return info
end

function get_rand_rail()
  local name,info = rand_table_pair(THEME.rails)
  return info
end

function choose_liquid()
  local name,info = rand_table_pair(THEME.liquids)
  return info
end

function find_liquid(name)
  local info = THEME.liquids[name]

  if not info then
    error("Unknown liquid: " .. name)
  end
end

function get_rand_pic()
  local name,info = rand_table_pair(THEME.pics)
  return info
end

function get_rand_light()
  local name,info = rand_table_pair(THEME.lights)
  return info
end

function get_rand_wall_light()
  local name,info = rand_table_pair(THEME.wall_lights)
  return info
end

function random_door_kind(w)
  local names = {}
  for kind,info in pairs(THEME.doors) do
    if info.w == w then
      table.insert(names,kind)
    end
  end
  assert(#names > 0)
  return rand_element(names)
end


