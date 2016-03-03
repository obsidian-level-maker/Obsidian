----------------------------------------------------------------
-- RUN IT (without a GUI)
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

require 'oblige'

-- provide a simplified "con" module

con = { }

function con.raw_log_print(str)
  io.stderr:write(str)
end

function con.raw_debug_print(str)
-- [[
  io.stderr:write("# ", str)
--]]
end

function con.at_level() end
function con.progress() end
function con.ticker()   end

function con.abort()
  return false
end

function con.rand_seed(value)
  math.randomseed(value)
end

function con.random()
  return math.random()
end

SETTINGS =
{
  seed = arg[1] or (os.time() % 1000)
  ,
  game   = "doom2",
  mode   = "sp",
  engine = "nolimit",
  length = "single",

  size   = "regular",
  health = "normal",
  ammo   = "normal",
  mons   = "normal",
  traps  = "normal",
}

build_cool_shit()

