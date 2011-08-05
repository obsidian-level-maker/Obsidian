----------------------------------------------------------------
--  CUSTOM WRITER for WOLF MAPS
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


function write_wolf_level()

  local function handle_block(x, y)
    if not valid_block(x, y) then return end
    local B = PLAN.blocks[x][y]
    if not B then return end

    local tile = WF_NO_TILE
    local obj  = WF_NO_OBJ

    if B.solid then
      assert(type(B.solid) == "number")
      tile = B.solid
    elseif B.door_kind then
      tile = WF_TILE_NUMS[B.door_kind]
      if not tile then
        error("Unknown door_kind: " .. tostring(B.door_kind))
      end
      if type(tile) == "table" then
        tile = tile[sel(B.door_dir==4 or B.door_dir==6, 1, 2)]
        assert(tile)
      end
    else
      -- when we run out of floor codes (unlikely!) then reuse them
      local avail = WF_TILE_NUMS.area_max - WF_TILE_NUMS.area_min + 1
      local floor = B.floor_code or 0

      tile = WF_TILE_NUMS.area_min + (floor % avail)
    end

    if B.things and B.things[1] then
      local th   = B.things[1]
      local kind = th.kind.id

      if type(kind) == "table" then

        -- convert skill settings
        if not th.options or th.options.easy then
          obj = kind.easy
        elseif th.options.medium then
          obj = kind.medium
        else
          obj = kind.hard
        end
        assert(obj)

        -- convert angle
        --
        -- Note that the player is different from the enemies:
        --   PLAYER : 19=N, 20=E, 21=S, 22=W
        --   ENEMY  : +0=E, +1=N, +2=W, +3=S

        if kind.dirs and th.angle then
          if kind.dirs == "player" then
            local offset = int((360 - th.angle + 135) / 90) % 4
            assert(0 <= offset and offset <= 3)
            obj = obj + offset
          else
            local offset = int((th.angle + 45) / 90) % 4
            assert(0 <= offset and offset <= 3)
            obj = obj + offset
          end
        end

        -- FIXME sometimes patrol (put choice in monster.lua)
        -- Disabled due to problems (T_Path error)

--      if kind.patrol and rand_odds(10) then
--        obj = obj + kind.patrol
--      end
      else
        obj = kind
      end
    end

    if (tile <= 63) and (obj > 0) then
      con.printf("HOLO BLOCK @ (%d,%d) -- tile:%d obj:%d\n", x, y, tile,obj)
    end

    wolf.add_block(x, y, tile, obj)
  end

  con.progress(66); if con.abort() then return end

  wolf.begin_level(lev_name);

  for y = 1,64 do for x = 1,64 do
    handle_block(x, y)
  end end

  wolf.end_level()

  con.progress(100)
end
