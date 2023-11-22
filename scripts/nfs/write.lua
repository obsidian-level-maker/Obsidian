------------------------------------------------------------------------
--  CODE TO SAVE A TRACK
------------------------------------------------------------------------
--
--  RandTrack : track generator for NFS1 (SE)
--
--  Copyright (C) 2014-2015 Andrew Apted
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


function write_zeros(count)
  for n = 1, count do
    gui.write_byte(0)
  end
end


function write_header()
  local num_segs = #TRACK.segments

  -- format specifier
  if TRACK.sp_ed then
    gui.write_uint(0x11)  -- special edition
  else
    gui.write_uint(0x10)  -- original
  end

  if TRACK.info.kind == "open" then
    gui.write_short(0)
  else
    gui.write_short(num_segs)
  end

  -- number of segments
  gui.write_short(num_segs)

  gui.write_short(0)  -- unknown purpose (if any)
  gui.write_short(6)  --

  -- [this coord seems to be unused by the game, write it anyway]
  local first_coord = TRACK.road[1]

  gui.write_int(first_coord.x / VIRTUAL_SCALE)
  gui.write_int(first_coord.z / VIRTUAL_SCALE)
  gui.write_int(first_coord.y / VIRTUAL_SCALE)

  -- next twelve bytes are unused
  write_zeros(12)

  -- size of actual road data
  local rec_size = sel(TRACK.sp_ed, 0x120, 0x554)

  gui.write_int(num_segs * rec_size)

  -- railing texture occurs at 0x12EC in original format
  if TRACK.sp_ed then
    gui.write_int(32 + TRACK.info.rail_def)
  else
    gui.write_int(0)
  end

  -- original format has another lookup table [possibly unused]
  if not TRACK.sp_ed then
    for n = 0, MAX_SEGMENTS - 1 do
      if TRACK.segments[1 + n] then
        gui.write_int(n * 0x548)
      else
        gui.write_int(0)
      end
    end
  end

  -- finally, a lookup table
  local start = sel(TRACK.sp_ed, 0, 0x1B000)

  for n = 0, MAX_SEGMENTS - 1 do
    gui.write_int(start + n * rec_size)
  end

  if not TRACK.sp_ed then
    gui.write_int(32 + TRACK.info.rail_def)

    gui.write_int(0)  -- unknown purpose (if any)
    gui.write_int(0)  --
  end
end


function write_virtual_road_piece(node, next_node, prev_node)

  -- a0..a3 : track width
  gui.write_byte(node.width1 / ROAD_WIDTH_SCALE)
  gui.write_byte(node.width1 / ROAD_WIDTH_SCALE)

  gui.write_byte(node.width2 / ROAD_WIDTH_SCALE)
  gui.write_byte(node.width2 / ROAD_WIDTH_SCALE)

  -- b0 : starting dist from edge of track
  -- b1 : softness/hardness of sides of track
  -- b2 : gravelly-ness of sides of track
  -- b3 : special effect (e.g. track skewing)
  gui.write_byte(17)

  local b1 = 17
  if node.hard[LF] then b1 = b1 - 16 end
  if node.hard[RT] then b1 = b1 - 1  end
  gui.write_byte(b1)

  gui.write_byte(0)
  gui.write_byte(node.special_fx or 3)

  gui.write_int(node.x / VIRTUAL_SCALE)
  gui.write_int(node.z / VIRTUAL_SCALE)
  gui.write_int(node.y / VIRTUAL_SCALE)

  -- compute orientation

  local dx, dy, dz

  if not next_node and TRACK.info.kind == "closed" then
    next_node = TRACK.road[1]
  end

  if next_node then
    dx = next_node.x - node.x
    dy = next_node.y - node.y
    dz = next_node.z - node.z
  else
    dx = node.x - prev_node.x
    dy = node.y - prev_node.y
    dz = node.z - prev_node.z
  end

  local dlen = math.sqrt(dx * dx + dy * dy)
  if dlen < 0.01 then dlen = 0.01 end

  local angle = math.atan2(dx, dy)   * 180.0 / math.pi
  local slope = math.atan2(dz, dlen) * 180.0 / math.pi

--stderrf("slope = %1.2f\n", slope)

  local twist = node.twist or 0
  assert(twist >= -45 and twist <= 45)

  local slant_B = -31500 * math.tan(twist * math.pi / 180.0)
  local ori_x   = -dx * 32000 / dlen
  local ori_y   =  dy * 32000 / dlen

  gui.write_angle14(slope)
  gui.write_angle14(twist)
  gui.write_angle14(angle)
  gui.write_short(0)

  gui.write_short(ori_y)
  gui.write_short(slant_B)
  gui.write_short(ori_x)
  gui.write_short(0)
end


function write_virtual_road()
  for i = 1, #TRACK.road do
    local node   = TRACK.road[i]
    local n_next = TRACK.road[i+1]
    local n_prev = TRACK.road[i-1]

    write_virtual_road_piece(node, n_next, n_prev)
  end

  -- fill remaining area with zeros

  local remain = 2400 - #TRACK.road

  write_zeros(remain * 36)
end


function write_ai_speeds()
  local num_segs = #TRACK.segments

  for i = 1, MAX_SEGMENTS do
    local seg = TRACK.segments[i]

    if seg and seg.ai_speed then
      local speed = seg.ai_speed * AI_SPEED_SCALE
      local traffic = math.clamp(25, speed * 0.75, 50)

      gui.write_byte(speed)
      gui.write_byte(70)  -- unknown
      gui.write_byte(traffic)
    else
      gui.write_byte(0x14)
      gui.write_byte(0x12)
      gui.write_byte(0x10)
    end
  end
end


function write_a_scale(s)
  -- bit of fudging to get "nice" looking output
  s = (s + 0.00005) * 0x18000
  s = bit.band(s, 0x7fffffc0)

  gui.write_int(s)
end


function write_one_scale_def(def, idx)
  if not def or def.dummy then
    -- filler stuff at the end (never used)

    gui.write_byte(0)
    gui.write_byte(0)
    gui.write_byte(4)
    gui.write_byte(4)

    write_a_scale(1)
    write_a_scale(1)
    write_a_scale(2)
    return
  end

  if def.obj3d then
    -- 3D object

    gui.write_byte(0)
    gui.write_byte(1)

    gui.write_byte(def.obj3d)
    gui.write_byte(def.obj3d)

    write_a_scale(1)
    write_a_scale(1)
    write_a_scale(2)
    return
  end

  -- a fairly normal 2d bitmap
  -- (possibly animated, or a fake 3D box)

  if def.frames then
    gui.write_byte(4)
  else
    gui.write_byte(0)
  end

  if def.fake then
    gui.write_byte(6)
  else
    gui.write_byte(4)
  end

  gui.write_byte(4 * (def.fake or def.img))
  gui.write_byte(4 * (def.alt or def.fake or def.img))

  write_a_scale(def.xs)

  -- for animations, raw[8] is number of frames, raw[9] is speed
  if def.frames then
    gui.write_byte(def.frames)
    gui.write_byte(def.speed or 5)
    gui.write_byte(1)
    gui.write_byte(0)
  else
    write_a_scale(def.ws)
  end

  write_a_scale(def.ys)
end


function write_scale_defs()
  for i = 1, MAX_SCALE_DEFS do
    local def = TRACK.info.scale_defs[i]
    write_one_scale_def(def) 
  end
end


function write_one_object(obj)
  if obj then
    gui.write_int(obj.node.index)

    gui.write_byte(obj.id)
    gui.write_byte(obj.flip or 0)

    -- next four bytes have unknown purpose
    gui.write_byte(0) ; gui.write_byte(0)
    gui.write_byte(1) ; gui.write_byte(4)

    local dx = (obj.x - obj.node.x) / OBJ_DELTA_SCALE
    local dy = (obj.y - obj.node.y) / OBJ_DELTA_SCALE
    local dz = (obj.z - obj.node.z) / OBJ_DELTA_SCALE

    gui.write_short(dx)
    gui.write_short(dz)
    gui.write_short(dy)
 
  else
    -- null object (filler at end of array)

    gui.write_int(-1)
    gui.write_int(0)
    gui.write_int(0)
    gui.write_int(0)
  end
end


function prune_objects(list)
  for min_priority = 0.2, 8.8, 0.2 do
    
    if #list <= MAX_OBJECTS then return end

    for i = #list, 1, -1 do
      if list[i].priority < min_priority then
        table.remove(list, i)
      end
    end
  end
end


function write_objects()
  gui.write_uint(MAX_SCALE_DEFS)
  gui.write_uint(MAX_OBJECTS)

  -- record marker : 'OBJS'
  if TRACK.sp_ed then
    gui.write_uint(0x4F424A53) -- reversed in SE
  else
    gui.write_uint(0x534A424F)
  end

  gui.write_uint(0x428c)     -- record size
  gui.write_uint(0)

  write_scale_defs()

  -- collect all the objects, set 'node' field --

  local list = {}

  for _,node in pairs(TRACK.road) do
    for _,obj in pairs(node.objects) do
      obj.node = node
      table.insert(list, obj)
    end
  end

  -- when too many objects, this prunes the least important ones
  prune_objects(list)

  for i = 1, MAX_OBJECTS do
    write_one_object(list[i])
  end

  -- the original format has zero padding until 0x1B000
  if not TRACK.sp_ed then
    write_zeros(492)
  end
end


function write_textures(seg)
  gui.write_byte(0)  -- unused (it seems)

  -- handle raillng
  local rail_LF = seg.railing[LF]
  local rail_RT = seg.railing[RT]

  if not (rail_LF or rail_RT) then
    gui.write_byte(0)
  else
    -- one bit per side
    local r = sel(rail_LF, 0x80, 0) + sel(rail_RT, 0x40, 0)

    gui.write_byte(r + TRACK.info.rail_def)
  end

  -- texture numbers
  for i = 1,5 do
    gui.write_byte(seg.textures[i])
  end

  for i = 1,5 do
    gui.write_byte(seg.textures[-i])
  end
end


function write_road_coords_SE(node, first, last, step)
  -- this must match coordinate written for the virtual road
  local prev_coord = node

  for i = first, last, step do
    local coord = node.coords[i]

    if not coord then
      error(string.format("Missing coord[%d] at node[%d]", i, node.index))
    end

    local dx = (coord.x - prev_coord.x) / SEG_DELTA_SCALE
    local dy = (coord.y - prev_coord.y) / SEG_DELTA_SCALE
    local dz = (coord.z - prev_coord.z) / SEG_DELTA_SCALE

    gui.write_short(dx)
    gui.write_short(dz)
    gui.write_short(dy)

    prev_coord = coord
  end
end


function write_road_segment_SE(seg, first_node)
  gui.write_uint(0x444B5254)  -- 'TRKD' marker, not reversed
  gui.write_uint(0x120 - 12)  -- record size (minus this header)
  gui.write_uint(0)

  -- textures
  write_textures(seg)

  -- coordinates
  for k = 0, 3 do
    local node = TRACK.road[first_node + k]
    assert(node)

    write_road_coords_SE(node,  0, 5, 1)
    write_road_coords_SE(node, -1,-5,-1)
  end
end


function write_road_coords_ORIG(node, first, last, step)
  for i = first, last, step do
    local coord = node.coords[i]

    -- original format uses absolute coordinates
    gui.write_int(coord.x / VIRTUAL_SCALE)
    gui.write_int(coord.z / VIRTUAL_SCALE)
    gui.write_int(coord.y / VIRTUAL_SCALE)
  end
end


function write_road_segment_ORIG(seg, index, first_node)
  gui.write_uint(0x444B5254)  -- 'TRKD' marker, not reversed
  gui.write_uint(0x548)       -- record size (minus this header)
  gui.write_uint(index - 1)

  -- textures
  write_textures(seg)

  -- reference point [specs say it is unused, write it anyway]
  local ref_coord = TRACK.road[first_node]

  gui.write_int(ref_coord.x / VIRTUAL_SCALE)
  gui.write_int(ref_coord.z / VIRTUAL_SCALE)
  gui.write_int(ref_coord.y / VIRTUAL_SCALE)

  -- coordinates
  for k = 0, 4 do
    local node = TRACK.road[first_node + k]

    -- handle very end of track (closed tracks repeat the very start)
    if k == 4 and not node then
      if TRACK.kind == "closed" then
        node = TRACK.road[1]
      else
        -- FIXME : see what open tracks really do here
        node = TRACK.road[first_node + 2]
      end
    end

    assert(node)

    -- 12 bytes of unknown purpose, probably unused
    write_zeros(12)

    if k == 4 then
      -- before the 'E' points, another unused 12 bytes [quite odd]
      write_zeros(12)
    end

    write_road_coords_ORIG(node,  0, 5, 1)
    write_road_coords_ORIG(node, -1,-5,-1)
  end

  -- filler at end
  write_zeros(516)
  write_zeros(80)
end


function write_actual_road()
  for _,seg in pairs(TRACK.segments) do
    local first_node = 1 + (_index - 1) * 4

    if TRACK.sp_ed then
      write_road_segment_SE(seg, first_node)
    else
      write_road_segment_ORIG(seg, _index, first_node)
    end
  end
end


function save_track(filename)
  -- sanity check
  if #TRACK.segments > MAX_SEGMENTS then
    error("Track too long!")
  end

  if not gui.open_file(filename, "wb") then
    error("Unable to create file for writing:\n" .. filename)
  end

  TRACK.sp_ed = (PREFS.game == "nfs1_se")

  write_header()
  write_virtual_road()
  write_ai_speeds()
  write_objects()
  write_actual_road()

  gui.close_file()
end

