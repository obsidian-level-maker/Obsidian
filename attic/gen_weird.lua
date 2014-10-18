--------------------------------------------------
--  EXPERIMENTAL GENERATION OF WEIRD SHAPES     --
--  (c) 2014 Andrew Apted, all rights reserved  --
--------------------------------------------------


gui =
{
  random = math.random
}

require '_util'


SHOW_GHOST = true


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

    limit_edges : number  -- do not allow more than this
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

    P.limit_edges = rand.pick({ 2, 3, 3, 3})
  end
  end

  -- link neighbors

  for gx = 1, GRID_W do
  for gy = 1, GRID_H do
    local P = GRID[gx][gy]

    for dir = 1, 9 do
    if  dir ~= 5 then
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
  P.num_edges = P.num_edges + 1

  local N = P.neighbor[dir]
  assert(N)

  N.edge[10 - dir] = true
  N.num_edges = N.num_edges + 1
end


function remove_edge(gx, gy, dir)
  local P = GRID[gx][gy]
  local N = P.neighbor[dir]
  assert(N)

  assert(P.edge[dir])
  assert(N.edge[10 - dir])

  P.edge[dir] = nil
  N.edge[10 - dir] = nil

  P.ghost[dir] = true
  N.ghost[10 - dir] = true

  P.num_edges = P.num_edges - 1
  N.num_edges = N.num_edges - 1
end


function is_diagonal_blocked(P, dir)
  -- not a diagonal?
  if not (dir == 1 or dir == 3 or dir == 7 or dir == 9) then
    return false
  end

  local L_dir = geom.LEFT_45[dir]

  local N = P.neighbor[L_dir]
  if not N then return true end

  return N.edge[geom.RIGHT[dir]]
end


function eval_edge_at_point(P, dir)
  -- returns < 0 if impossible, score > 0 if possible

  local N = P.neighbor[dir]

  if not N then return -1 end
  if N.dead then return -1 end

  -- already an edge there?
  if P.edge[dir] then return -1 end

  -- ensure it does not cross another diagonal
  if is_diagonal_blocked(P, dir) then return -1 end

  -- rule # 1 : no more than 3 edges at any point
  if P.num_edges >= P.limit_edges then return -1 end
  if N.num_edges >= N.limit_edges then return -1 end

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


function remove_dud_point(P)
  for dir = 1, 9 do
  if  dir ~= 5 then
    if P.edge[dir] then
      remove_edge(P.gx, P.gy, dir)
    end
  end
  end
end


function remove_dead_ends()
  local found = false

  for gx = 1, GRID_W do
  for gy = 1, GRID_H do
    local P = GRID[gx][gy]

    if P.num_edges == 1 then
      found = true

      remove_dud_point(P)
    end
  end
  end

  return found
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

  for x = 1, GRID_W do
    wr_line(fp, x * SIZE, SIZE, x * SIZE, max_y, "#bbb")
  end

  for y = 1, GRID_H do
    wr_line(fp, SIZE, y * SIZE, max_x, y * SIZE, "#bbb")
  end

  -- points
  for x = 1, GRID_W do
  for y = 1, GRID_H do
    local P = GRID[x][y]

    for dir = 6,9 do
      local N = P.neighbor[dir]

      if N then
        local x1 = x * SIZE
        local y1 = (GRID_H - y + 1) * SIZE

        local x2 = N.gx * SIZE
        local y2 = (GRID_H - N.gy + 1) * SIZE

        if P.edge[dir] then
          wr_line(fp, x1, y1, x2, y2, "#00f", 3)

        elseif P.ghost[dir] and SHOW_GHOST then
          wr_line(fp, x1, y1, x2, y2, "#f00", 1)
        end
      end

    end -- dir
  end -- x, y
  end

  -- end
  fp:write('</svg>\n')

  fp:close()
end


-- main --

create_points()

add_edge(GRID_W / 2, GRID_H / 2, 6)

for pass = 1, 4 do
  for loop = 1, GRID_W * GRID_H * 2 do
    try_add_edge()
  end

  while remove_dead_ends() do end
end

save_as_svg()

