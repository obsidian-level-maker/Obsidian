------------------------------------------------------------------------
--  BASIC DEFINITIONS
------------------------------------------------------------------------
--
--  RandTrack : track generator for NFS1 (SE)
--
--  Copyright (C) 2014 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 3
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this software.  If not, please visit the following
--  web page: http://www.gnu.org/licenses/gpl.html
--
------------------------------------------------------------------------

--
-- current settings (from UI)
--
PREFS = {}


--
-- information about each track goes here
--
TRACK_FILES = {}


--
-- useful constants
--
LF = 1  -- left side / edge
RT = 2  -- right side / edge

MAX_SEGMENTS = 600
MAX_NODES    = (MAX_SEGMENTS * 4)
MAX_OBJECTS  = 1000
MAX_SCALE_DEFS = 64

VIRTUAL_SCALE    = (1.0 / 524288.0)
SEG_DELTA_SCALE  = (512.0 * VIRTUAL_SCALE)
OBJ_DELTA_SCALE  = (SEG_DELTA_SCALE / 2.0)
ROAD_WIDTH_SCALE = (1.0 / 64.0)

-- this is pure guess-work
AI_SPEED_SCALE   = 0.45


-- Note : road polygons are limited to about 31 units from a node,
--        and objects are limited to about 15 units from a node.


--
-- info for current generated track
--
TRACK =
{
--[[
    info : table ---> an entry in TRACK_FILES[] table, read-only

    road : list(NODE)

    segments : list(SEGMENT)

    mirrored   -- true if a closed track was mirrored
               -- (will run anti-clockwise instead of clockwise)

    features    : list  -- all the features
    edges[SIDE] : list  -- all the edges
--]]
}


-- class NODE
--[[
    x, y, z : position in virtual road

    angle : ANGLE  -- 0 is north, +90 east, -90 west, -180 south
    slope : ANGLE  -- forward/backward, 0 is flat, negative is down
    twist : ANGLE  -- side to side, 0 is flat, negative make left side go down

    -- scenery quads
    coords : list(COORD)  -- [0] is middle, [-5] far left, [+5] far right

    objects : list(OBJECT)

    seg : SEGMENT  -- shared between every four consecutive nodes

    hard[SIDE] : bool

    special_fx : number  -- usually NIL

    curvature  -- computed curvature, from 0.0 to 9.0 (or so)
               -- this value is always >= 0

    bend  -- smoothed angle difference at current node
          -- value is > 0 when track is curving to the right
          -- value is < 0 when track is curving to the left

    -- how much usable space on each side
    space[SIDE] : number

    signage[SIDE] : bool  -- true if road sign here or nearby
--]]


-- class SEGMENT
--[[
    textures : list

    railing[SIDE] : boolean

    feature  : FEATURE_INFO

    edges[SIDE] : EDGE_INFO
--]]


-- class OBJECT
--[[
    id  -- object id number (bitmap / 3D object)

    x, y, z  -- coordinate

    flip  -- rotation number, 0 to 255
--]]


--
-- special effect valuess (NODE.special_fx)
--
SPECIAL_FX =
{
  skew_start = 0,
  skew_end   = 2,

  buzz_sound   = 4,
  water_sound  = 14,
  water2_sound = 15,

  tunnel_mode  = 12,
  tunnel_mode2 = 13
}

