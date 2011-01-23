----------------------------------------------------------------
--  DECK THE HALLS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 Andrew Apted
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

--[[ *** CLASS INFORMATION ***

class HALLWAY
{
  start : SEED   -- the starting seed (in a room)
  dest  : SEED   -- destination seed  (in a room)

  start_dir  --  direction from start --> hallway
  dest_dir   --  direction from hallway --> dest

  path : list  -- the path between the start and the destination
               -- (not including either start or dest).
               -- each element holds the seed and direction.

  sub_halls   -- number of hallways branching off this one
              -- (normally zero)
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


