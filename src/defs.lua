----------------------------------------------------------------
-- BASIC DEFINITIONS
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

PL_W = 10; PL_H = 8  -- cells in the plan

BW =  9; BH = BW  -- blocks in a cell
FW =  4; FH = FW  -- fragments in a block
KW =  3; KH = KW  -- chunks in a cell

JW = BW/KW  -- blocks in a chunk
JH = BH/KH

BORDER_BLK = 5  -- number of spare blocks around plan

MIN_FLOOR = 0
MAX_CEIL  = 640

SKILLS = { "easy", "medium", "hard" }

THEME_FACTORIES = {}

PLAN  = {}
THEME = {}

