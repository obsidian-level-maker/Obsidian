--------------------------------------------------
--  EXPERIMENTAL GENERATION OF WEIRD SHAPES     --
--  (c) 2014 Andrew Apted, all rights reserved  --
--------------------------------------------------


gui =
{
  random = math.random
}

require '_util'


if arg[1] then
  local seed = 0 + arg[1]
  print("Seed =", seed)
  math.randomseed(seed)
end


-- class POINT
--[[
    x, y   : coordinate

    neighbor : table[DIR] --> POINT

    edges : table[DIR] --> true if an edge to that neighbor

    num_edges : number

    dead : boolean  -- true if cannot make any more edges off here
--]]

GRID = {}

GRID_W = 50
GRID_H = 50


function create_points()
  GRID = table.array_2

  --....
end


function add_edge(gx, gy, dir)
  -- TODO
end


function try_add_edge()
  -- TODO
end


function remove_dead_ends()
  -- TODO
end


function save_as_svg()
  -- TODO
end


-- main --

create_points()

add_edge(GRID_W / 2, GRID_H / 2, 6)

for loop = 1, GRID_W * GRID_H * 1 do
  try_add_edge()
end

remove_dead_ends()

save_as_svg()

