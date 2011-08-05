----------------------------------------------------------------
--  MODULE: Prefab Tester
----------------------------------------------------------------
--
--  Copyright (C) 2010 Andrew Apted
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

PREFAB_NAME = "SMALL_SWITCH"


function resize_coord(n, groups)
  --
  -- GROUPS:
  --   a set of tables which fully covers the coordinate range,
  --   must be sorted from lowest to highest.
  --
  local T = #groups

  if T == 0 then return n end

  if n <= groups[1].low  then return n + (groups[1].low2 -  groups[1].low)  end
  if n >= groups[T].high then return n + (groups[1].high2 - groups[1].high) end

  local G = 1

  while (G < T) and (n > G.high) do
    G = G + 1
  end

  return G.low2 + (G.high2 - G.low2) * (n - G.low) / (G.high - G.low);
end


function compute_groups(groups, lowest, highest)
  if #groups == 0 then return end

  local extra = highest - lowest
  local wt_total = 0

  -- first pass: set size of all RIGID groups, and total the weights
  for _,G in ipairs(groups) do
    if not G.weight then
      G.size = G.high - G.low
      extra = extra - G.size
    else
      assert(G.weight > 0)
      wt_total = wt_total + G.weight
    end
  end

  -- second pas:, set size of all FLEXIBLE groups, and also set
  -- the new coordinate range in low2 and high2.
  local pos = lowest

  for _,G in ipairs(groups) do
    if G.weight then
      G.size = G.high - G.low + extra * G.weight / wt_total
      assert(G.size > 1)
    end

    G.low2  = pos
    G.high2 = pos + G.size

    pos = G.high2
  end
end


function Build_Prefab(info)
  gui.printf("Building prefab....\n")

  gui.printf("transform =\n%s\n", table.tostr(info))

  local prefab = assert(PREFAB[PREFAB_NAME])

  -- empty room
  Trans.brush("solid",
  {
    { x=-1024, y=-1024, tex="BLAKWAL1" },
    { x= 1024, y=-1024, tex="BLAKWAL1" },
    { x= 1024, y= 1024, tex="BLAKWAL1" },
    { x=-1024, y= 1024, tex="BLAKWAL1" },
    { t=0, tex="CEIL5_1" },
  })

  Trans.brush("solid",
  {
    { x=-1024, y=-1024, tex="BLAKWAL1" },
    { x= 1024, y=-1024, tex="BLAKWAL1" },
    { x= 1024, y= 1024, tex="BLAKWAL1" },
    { x=-1024, y= 1024, tex="BLAKWAL1" },
    { b=512, tex="CEIL5_1", light=0.85 },
  })

  -- player start
  Trans.entity("player1", 0, 400, 0, { angle=270 })

  -- THE PREFAB

  local materials =
  {
    "FLAT1", "COMPBLUE", "REDWALL", "RROCK14",
    "GRASS1", "WOOD1", "SFLR6_4", "LAVA1"
  }
  local mapping = { }


  Trans.set(info)

  local brushes = assert(prefab.brushes)

  for _,B0 in ipairs(brushes) do
    local B = table.deep_copy(B0)
    local kind = "solid"

    for _,C in ipairs(B) do
      if C.mat then
        if not mapping[C.mat] then
          local idx = table.size(mapping) + 1
          mapping[C.mat] = materials[1 + (idx-1) % #materials]
        end

        C.tex = mapping[C.mat]
        C.mat = nil
      end
    end

    Trans.brush("solid", B)
  end

  gui.printf("mappings =\n%s\n", table.tostr(mapping))

  Trans.clear()

  gui.printf("Done prefab\n\n")
end


SIZE_CHOICES =
{
  "s100", "100%",
  "s50", "50%",
  "s25", "25%",
  "s150", "150%",
  "s200", "200%",
  "s300", "300%",
}

SIZE_VALUES =
{
  s100 = 1.00, s25 =  0.25, s50 =  0.50,
  s150 = 1.50, s200 = 2.00, s300 = 3.00,
}

MIRROR_CHOICES =
{
  "none","NONE", "x","X", "y","Y", "xy","X+Y"
}


function Test_Prefab(self)
  local LEV = GAME.levels[1]

  LEV.build_func = Build_Prefab

  LEV.build_data =
  {
    scale_x = SIZE_VALUES[self.options.scale_x.value] or 1,
    scale_y = SIZE_VALUES[self.options.scale_y.value] or 1,
    scale_z = SIZE_VALUES[self.options.scale_z.value] or 1,
  }

  local mir = self.options.mirror.value
  if mir == "x" or mir == "xy" then LEV.build_data.mirror_x = 0 end
  if mir == "y" or mir == "xy" then LEV.build_data.mirror_y = 0 end
end


OB_MODULES["prefab_tester"] =
{
  label = "Prefab Tester",

  for_games = { doom2=1 },

  hooks = { get_levels = Test_Prefab },

  options =
  {
    scale_x = { label="X Scaling", choices=SIZE_CHOICES },
    scale_y = { label="Y Scaling", choices=SIZE_CHOICES },
    scale_z = { label="Z Scaling", choices=SIZE_CHOICES },
    mirror  = { label="Mirroring", choices=MIRROR_CHOICES, priority=1 },
  },
}

