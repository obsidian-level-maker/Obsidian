----------------------------------------------------------------
--  PLANNER : EXPERIMENTAL SHIT
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

require 'defs'
require 'util'
require 'room_fabs'


SW = 32
SH = 32

SEEDS = array_2D(SW, SH)

FABS = {}


function select_room_fab(r)

  local function usable(F)
    if r.w < F.width_range[1] or
       r.w > F.width_range[2] or
       r.h < F.height_range[1] or
       r.h > F.height_range[2]
    then
      return false
    end

    if F.area_range then
      if (r.w * r.h) < F.area_range[1] or
         (r.w * r.h) > F.area_range[2]
      then
        return false
      end
    end

    return true
  end

  local list = { }

  for _,F in pairs(ROOM_FABS) do
    if usable(F) then
      table.insert(list, F)
    end
  end

  if #list == 0 then
    error("No usable room fab could be found!!!")
  end

  r.fab = rand_element(list)
end


function built_fab(r)
  
  @@@
end


function try_branch_off(r)
  
  @@@
end


function process_fabs()

  for _,r in ipairs(FABS) do
    
    if not r.built then
      build_fab(r)
    end

    for dir = 2,8,2 do
      if rand_odds(25) then
        try_branch_off(r, dir)
      end
    end
  end
end


function Plan_rooms_sp()

  local function char_for_seed(S)

    if not S or not S.kind then return "." end

    if S.kind == "ground" then return "/" end
    if S.kind == "liquid" then return "~" end
    if S.kind == "cave" then return "%" end
    if S.kind == "building" then return "#" end
    if S.kind == "hall" then return "+" end

    return "?"
  end


  ---===| Plan_rooms_sp |===---

  con.printf("\n--==| Plan_rooms_sp |==--\n\n")

  -- initial room
  local r =
  {
    w = rand_irange(SW/4, SW/2),
    h = rand_irange(SH/4, SH/2),

    x = rand_irange(3, SW-rw-2),
    h = rand_irange(3, SH-rh-2),

    dir = rand_dir(),
  }

  select_room_fab(r),


  table.insert(FABS, r)

  for loop = 1,100 do
    process_fabs()
  end


  -- dump the results

  con.printf("FAB MAP:\n")

  for y = SH,1,-1 do
    
    for x = 1,SW do
      con.printf("%c", char_for_seed(SEEDS[x][y]))
    end

    con.printf("\n")
  end

  exit(9)

end -- Plan_rooms_sp

