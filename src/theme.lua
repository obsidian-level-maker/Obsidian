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

function expand_prefabs(fabs)

  expand_copies(fabs)

  for name,P in pairs(fabs) do
    expand_copies(P.elements)
  
    -- set size values
    local f_deep = #P.structure
    local f_long = #P.structure[1]

    assert(f_long % 4 == 0)
    assert(f_deep % 4 == 0)

    P.long = int(f_long / 4)
    P.deep = int(f_deep / 4)
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
  assert(THEME.liquids)
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


