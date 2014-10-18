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
    gx, gy   : grid coordinate

    neighbor : table[DIR] --> POINT

    edges : table[DIR] --> true if an edge to that neighbor

    num_edges : number

    dead : boolean  -- true if cannot make any more edges off here

    ghost : table[DIR] --> edges which were killed (dead ends)
--]]

GRID = {}

GRID_W = 48
GRID_H = 30


function create_points()
  GRID = table.array_2D(GRID_W, GRID_H)

  for gx = 1, GRID_W do
  for gy = 1, GRID_H do
    local P =
    {
      gx = gx,
      gy = gy,
      neighbor = {},
      edge = {},
      ghost = {},
      num_edges = 0
    }
    
    GRID[gx][gy] = P
  end
  end

  -- link neighbors

  for gx = 1, GRID_W do
  for gy = 1, GRID_H do
    local P = GRID[gx][gy]

    for dir = 1, 9 do
    if dir ~= 5 then
      local nx, ny = geom.nudge(gx, gy, dir)

      if table.valid_pos(GRID, nx, ny) then
        local N = GRID[nx][ny]
        assert(N)

        P.neighbor[dir] = N
      end
    end
    end
  end
  end
end


function add_edge(gx, gy, dir)
  local P = GRID[gx][gy]

  P.edge[dir] = true
  P.num_edges  = P.num_edges + 1

  local N = P.neighbor[dir]

  if N then
    N.edge[10 - dir] = true
    N.num_edges = N.num_edges + 1
  end
end


function is_diagonal_blocked(P, dir)
  local L_dir = geom.LEFT_45[dir]

  local N = P.neighbor[L_dir]
  if not N then return true end

  local dir2 = geom.RIGHT[dir]
  return N.edge[dir]
end


function eval_edge_at_point(P, dir)
  -- returns < 0 if impossible, score > 0 if possible

  local N = P.neighbor[dir]

  if not N then return -1 end

  -- ensure it does not cross another diagonal
  if is_diagonal_blocked(P, dir) then return -1 end

  -- rule # 1 : no more than 3 edges at any point
  if P.num_edges >= 3 then return -1 end
  if N.num_edges >= 3 then return -1 end

  -- rule # 2 : never make sharp (45-degree) angles
  local L_dir = geom. LEFT_45[dir]
  local R_dir = geom.RIGHT_45[dir]

  if P.edge[L_dir] or P.edge[R_dir] then return -1 end
  
  if N.edge[10 - L_dir] or N.edge[10 - R_dir] then return -1 end

  -- OK --

  return 1
end


function try_edge_at_point(P)
  assert(not P.dead)

  local tab = {}

  for dir = 1, 9 do
  if  dir ~= 5 then
    local score = eval_edge_at_point(P, dir)

    if score > 0 then
      tab[dir] = score
    end
  end
  end

  -- nothing was possible
  if table.empty(tab) then
    P.dead = true
    return nil
  end

  local dir = rand.key_by_probs(tab)

  add_edge(P.gx, P.gy, dir)

  -- indicate success by returning neighbor
  return P.neighbor[dir]
end


function try_add_edge()
  local points = {}

  for gx = 1, GRID_W do
  for gy = 1, GRID_H do
    local P = GRID[gx][gy]

    if P.num_edges > 0 and P.num_edges < 3 and not P.dead then
      table.insert(points, P)
    end
  end
  end

--- print("active_points", #points)

  if table.empty(points) then
    return
  end

  local P = rand.pick(points)

  -- keep going until hit dead end or shape joins back onto itself

  repeat
    P = try_edge_at_point(P)
  until not (P and P.num_edges == 0)
end


function remove_dead_ends()
  -- TODO
end


function wr_line(fp, x1, y1, x2, y2, color, width)
  fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
           x1, y1, x2, y2, color, width or 1))
end


function save_as_svg()
  local SIZE = 20

  local fp = io.open("_weird.svg", "w")

  if not fp then error("Cannot create file") end

  -- header
  fp:write('<svg xmlns="http://www.w3.org/2000/svg" version="1.1">\n')

  -- grid
  local max_x = GRID_W * SIZE
  local max_y = GRID_H * SIZE

  for x = 0, GRID_W do
    wr_line(fp, x * SIZE, 0, x * SIZE, max_y, "#bbb")
  end

  for y = 0, GRID_H do
    wr_line(fp, 0, y * SIZE, max_x, y * SIZE, "#bbb")
  end

  -- points
  for x = 1, GRID_W do
  for y = 1, GRID_H do
    local P = GRID[x][y]

    for dir = 6,9 do
      local N = P.neighbor[dir]

      if P.edge[dir] then
        wr_line(fp, x * SIZE, y * SIZE, N.gx * SIZE, N.gy * SIZE, "#00f", 3)

      elseif P.ghost[dir] then
        wr_line(fp, x * SIZE, y * SIZE, N.gx * SIZE, N.gy * SIZE, "#f00", 1)
      end
    end
  end
  end

  -- end
  fp:write('</svg>\n')

  fp:close()
end


-- main --

create_points()

add_edge(GRID_W / 2, GRID_H / 2, 6)

for loop = 1, GRID_W * GRID_H * 2 do
  try_add_edge()
end

remove_dead_ends()

save_as_svg()

