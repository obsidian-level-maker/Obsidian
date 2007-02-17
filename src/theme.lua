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

function get_rand_theme()
  local name,info = rand_table_pair(THEME.themes)
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

function random_light_kind(is_flat)
  local infos = {}
  for name,info in pairs(THEME.lights) do
    if sel(is_flat, info.flat, info.tex) then
      table.insert(infos,info)
    end
  end
  assert(#infos > 0)
  return rand_element(infos)
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

