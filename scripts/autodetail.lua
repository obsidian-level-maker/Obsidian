------------------------------------------------------------------------
--  AUTODETAIL
------------------------------------------------------------------------
--
--  Oblige Level Maker // ObAddon
--
--  Copyright (C) 2018-2021 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

-- Autodetail constants

-- the volume of a map in seed count
-- this is the minimum volume required
-- before Autodetail for grouped walls kicks in
LEVEL_SVOLUME_KICKIN = 1800

-- added exponent for grouped walls
-- higher numbers mean grouped walls are even
-- less likely to show
GROUPED_WALL_TONE_DOWN_EXP = 2.5

-- the total perimeter of wall-ish junctions required in the map
-- before Autodetail for ungrouped walls kicks in
LEVEL_PERIMETER_COUNT_KICKIN = 1800

-- added exponent for ungrouped walls
-- higher numbers mean plain walls are more likely
UNGROUPED_WALL_TONE_DOWN_EXP = 2


function Autodetail_get_level_svolume()
  LEVEL.autodetail_group_walls_factor = 1

  if PARAM.autodetail == "off" then return end

  local total_walkable_area = 0

  for _,R in pairs(LEVEL.rooms) do
    total_walkable_area = total_walkable_area + R.svolume
  end

  LEVEL.total_svolume = total_walkable_area

  if LEVEL.total_svolume > LEVEL_SVOLUME_KICKIN then
    LEVEL.autodetail_group_walls_factor = (LEVEL.total_svolume / LEVEL_SVOLUME_KICKIN)
    ^ GROUPED_WALL_TONE_DOWN_EXP
  end
end


function Autodetail_plain_walls()
  LEVEL.autodetail_plain_walls_factor = 0

  if PARAM.autodetail == "off" then return end

  local total_perimeter = 0
  for _,junc in pairs(LEVEL.junctions) do
    if junc.E1 and Edge_is_wallish(junc.E1) then
      total_perimeter = total_perimeter + junc.perimeter
    end
  end

  LEVEL.total_perimeter = total_perimeter

  local tone_down_factor = 0

  if total_perimeter >= LEVEL_PERIMETER_COUNT_KICKIN then
    tone_down_factor = (1 - (LEVEL_PERIMETER_COUNT_KICKIN / total_perimeter)) * 100
    tone_down_factor = tone_down_factor * UNGROUPED_WALL_TONE_DOWN_EXP
  end

  LEVEL.autodetail_plain_walls_factor = math.clamp(0, tone_down_factor * 1.25, 100)

  for _,junc in pairs(LEVEL.junctions) do
    if junc.E1 and junc.E1.kind == "wall" then
      if rand.odds(LEVEL.autodetail_plain_walls_factor) then
        junc.E1.plain = true
      end
    end

    if junc.E2 and junc.E2.kind == "wall" then
      if rand.odds(LEVEL.autodetail_plain_walls_factor) then
        junc.E2.plain = true
      end
    end
  end
end


function Autodetail_report()
  if PARAM.autodetail == "off" then return end

  gui.printf("\n--==| Auto Detail Report |==--\n\n")
  gui.printf("Total walkable volume: " .. LEVEL.total_svolume .. "\n")
  gui.printf("Group walls tone down multiplier: " .. LEVEL.autodetail_group_walls_factor .. "\n")
  gui.printf("Total perimeter: " .. LEVEL.total_perimeter .. "\n")
  gui.printf("Plain walls tone down multiplier: " .. LEVEL.autodetail_plain_walls_factor .. "\n")
end
