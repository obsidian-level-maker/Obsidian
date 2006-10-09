----------------------------------------------------------------
-- RUN IT (without a GUI)
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006 Andrew Apted
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

function con.printf(...)
  io.stderr:write(string.format(...))
end

function con.debugf(...)
  -- io.stderr:write(string.format(...))
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

settings =
{
  seed = arg[1] or (os.time() % 1000)
  ,
  game = "doom2", addon = "none",
  mode = "sp",  size  = "one",
}

build_cool_shit()

