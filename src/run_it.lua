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

function run_printf(...)
  io.stderr:write(string.format(...))
end

con =
{
  printf   = run_printf,
  at_level = do_nothing,
  progress = do_nothing,
  ticker   = do_nothing,
  abort    = function() return false end,

  random    = function() return math.random() end,
  rand_seed = function(seed) math.randomseed(seed) end,
}

settings =
{
  seed = arg[1] or (os.time() % 1000)
  ,
  game = "doom2", addon = "none",
  mode = "sp",    size  = "one",
}

build_cool_shit()

