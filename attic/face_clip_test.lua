--
-- TEST CODE : FACE CLIPPING IN g_quake3.cc
--


-- random seed
seed = 4  --  os.time() % 100000

-- the gap
gap_Lz1 = 0
gap_Lz2 = 0
gap_Rz1 = 0
gap_Rz2 = 0

-- input face
face_Lz1 = 0
face_Lz2 = 0
face_Rz1 = 0
face_Rz2 = 0

-- output face coords
output_face = 0
result_text = 0

-- constants
Z_EPSILON = 0.01

UScale = 4.0   -- horizontal scaling

-- svg state
fp = 0


function SVG_Begin(filename)
  fp = io.open(filename, "w")

  if not fp then error("Cannot create file") end

  -- header
  fp:write('<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n')
  fp:write('<svg xmlns="http://www.w3.org/2000/svg" version="1.1">\n')
end


function SVG_End()
  fp:write('</svg>\n')
  fp:close()
end


-- scale function
function S(n)
  return n * 40
end


function SVG_Grid(pos)
  local BX = (pos - 1) * 1.7 * UScale + 0.5
  local BY = 0.5
  local BW = 1 * UScale
  local BH = 7

  local color = "#999"

  for y = 0, 7 do
    fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
             S(BX), S(BY + y), S(BX + BW), S(BY + y), color, 1))
  end

  for x = 0, 4 do
    local u = x / 4

    fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
             S(BX + u*UScale), S(BY), S(BX + u*UScale), S(BY + BH), color, 1))
  end
end


function SVG_Quad(pos, what, Lz1, Lz2, Rz1, Rz2)
  local BX = (pos - 1) * 1.7 * UScale + 0.5
  local BY = 0.5
  local BW = 1 * UScale
  local BH = 7
  local BT = BY + BH

  local color = "#f00"
  local width = 2

  if what ~= "gap" then
    color = "#00f"
    width = 1
  end

  if pos == 2 then
    width = 3 - width
  end

  fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
           S(BX), S(BT - Lz2), S(BX), S(BT - Lz1), color, width))

  fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
           S(BX + BW), S(BT - Rz2), S(BX + BW), S(BT - Rz1), color, width))

  fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
           S(BX), S(BT - Lz1), S(BX + BW), S(BT - Rz1), color, width))

  fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
           S(BX), S(BT - Lz2), S(BX + BW), S(BT - Rz2), color, width))
end


function SVG_ResultText(pos)
  local BX = (pos - 1) * 1.7 * UScale + 0.5
  local BY = 4.3

  fp:write(string.format('<text x="%d" y="%d" font-size="%d">%s</text>',
           S(BX), S(BY), S(0.7), result_text))
end


function SVG_OutputFace(pos)
  local BX = (pos - 1) * 1.7 * UScale + 0.5
  local BY = 0.5
  local BW = 1 * UScale
  local BH = 7
  local BT = BY + BH

  local color = "#00f"
  local width = 2

  -- draw edges
  for n = 1, # output_face do
    local V1 = output_face[n]
    local V2

    if n < # output_face then
      V2 = output_face[n + 1]
    else
      V2 = output_face[1]
    end

    assert(V1)
    assert(V2)

    fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
             S(BX + V1.u * UScale), S(BT - V1.z),
             S(BX + V2.u * UScale), S(BT - V2.z), color, width))
  end

  -- draw vertex numbers
  for n = 1, # output_face do
    local V1 = output_face[n]
    local V2

    if n < # output_face then
      V2 = output_face[n + 1]
    else
      V2 = output_face[1]
    end

    fp:write(string.format('<text x="%d" y="%d" font-size="%d" fill="%s">%d</text>\n',
             S(BX + V1.u * UScale + 0.2),
             S(BT - V1.z - 0.1),
             S(0.4), "#090", n))
  end
end



function AddVert(u, z)
  assert(u)
  assert(z)

  local V = { u=u, z=z }

  table.insert(output_face, V)
end



function WallFace_Quad(L_bz, L_tz, R_bz, R_tz)

  local tri_side = 0

  if (math.abs(L_tz - L_bz) < Z_EPSILON) then tri_side = -1 end
  if (math.abs(R_tz - R_bz) < Z_EPSILON) then tri_side =  1 end

  AddVert(0.0, L_bz)

  if (tri_side >= 0) then
    AddVert(0.0, L_tz)
  end

  AddVert(1.0, R_tz)

  if (tri_side <= 0) then
    AddVert(1.0, R_bz)
  end

  if (# output_face < 3) then
    result_text = "BAD FACE (LACKING)"
  end
end



function CheckEdgeIntersect(g_z1, g_z2, f_z1, f_z2)

  -- returns:  0, along  if intersects
  --          +1         if face edge completely above gap edge
  --          -1         if face edge completely below gap edge

  if ((f_z1 > g_z1 - Z_EPSILON) and (f_z2 > g_z2 - Z_EPSILON)) then
    return  1
  end

  if ((f_z1 < g_z1 + Z_EPSILON) and (f_z2 < g_z2 + Z_EPSILON)) then
    return -1
  end

  -- find the intersection point
  local den = (g_z2 - g_z1) - (f_z2 - f_z1)

  local along = (f_z1 - g_z1) / den

  return 0, along
end



function DoAddVertex( along,  Lz,  Rz)

  local z = Lz + (Rz - Lz) * along

  AddVert(along, z)
end



function ClipWallFace(
             g_Lz1, g_Lz2, g_Rz1, g_Rz2,
             f_Lz1, f_Lz2, f_Rz1, f_Rz2)

  output_face = { }

  -- ensure the face is sane  [ triangles are Ok ]
  if ((f_Lz1 > f_Lz2 - Z_EPSILON) and (f_Rz1 > f_Rz2 - Z_EPSILON)) then
    result_text = "ILLEGAL INPUT FACE"
    return
  end

  if (f_Lz1 > f_Lz2) then f_Lz1 = (f_Lz1 + f_Lz2) * 0.5 ; f_Lz2 = f_Lz1 end
  if (f_Rz1 > f_Rz2) then f_Rz1 = (f_Rz1 + f_Rz2) * 0.5 ; f_Rz2 = f_Rz1 end


  -- trivial reject
  if ((f_Lz1 > g_Lz2 - Z_EPSILON) and (f_Rz1 > g_Rz2 - Z_EPSILON)) then
    result_text = "Rejected (Above)"
    return
  end

  if ((f_Lz2 < g_Lz1 + Z_EPSILON) and (f_Rz2 < g_Rz1 + Z_EPSILON)) then
    result_text = "Rejected (Below)"
    return
  end


--[[ NOT USED FOR THIS TEST

  -- subdivide faces which are too tall  [ recursively... ]
  float len1 = MIN(f_Lz2, g_Lz2) - MAX(f_Lz1, g_Lz1)
  float len2 = MIN(f_Rz2, g_Rz2) - MAX(f_Rz1, g_Rz1)

  if MAX(len1, len2) > FACE_MAX_SIZE then
    local f_Lmz = (f_Lz1 + f_Lz2) * 0.5
    local f_Rmz = (f_Rz1 + f_Rz2) * 0.5

    ClipWallFace(node, leaf, S, bvert,
           g_Lz1, g_Lz2, g_Rz1, g_Rz2,
           f_Lz1, f_Lmz, f_Rz1, f_Rmz)

    ClipWallFace(node, leaf, S, bvert,
           g_Lz1, g_Lz2, g_Rz1, g_Rz2,
           f_Lmz, f_Lz2, f_Rmz, f_Rz2)

    return
  end
--]]


  -- determine relationship of edges

  local bb, a_bb = CheckEdgeIntersect(g_Lz1, g_Rz1, f_Lz1, f_Rz1)
  local bt, a_bt = CheckEdgeIntersect(g_Lz1, g_Rz1, f_Lz2, f_Rz2)
  local tb, a_tb = CheckEdgeIntersect(g_Lz2, g_Rz2, f_Lz1, f_Rz1)
  local tt, a_tt = CheckEdgeIntersect(g_Lz2, g_Rz2, f_Lz2, f_Rz2)

  -- full-reject cases  [ checked earlier, but handle it again ]
  if bt < 0 or tb > 0 then
    result_text = "Reject (SECONDARY)"
    return
  end

  if not (bb == 0 or bt == 0 or tb == 0 or tt == 0) then

    -- handle the simple cases (no intersections)

    if (bb < 0) then
      f_Lz1 = g_Lz1
      f_Rz1 = g_Rz1
    end

    if (tt > 0) then
      f_Lz2 = g_Lz2
      f_Rz2 = g_Rz2
    end

    WallFace_Quad(f_Lz1, f_Lz2, f_Rz1, f_Rz2)

    return
  end


  --== full clip ==--


  -- basic idea is two produce a winding using all the intercept
  -- points (including at corners of the gap), plus original verts,
  -- but omit all vertices which lie completely outside of the gap.


  -- left edge

  if (f_Lz2 < g_Lz1 - Z_EPSILON) or (f_Lz1 > g_Lz2 + Z_EPSILON) then

    -- none

  else

    local z1 = math.max(f_Lz1, g_Lz1)
    local z2 = math.min(f_Lz2, g_Lz2)

    AddVert(0.0, z1)

    if (z2 > z1 + Z_EPSILON) then
      AddVert(0.0, z2)
    end
  end

  -- top edge

  if (bt == 0 and tt == 0) then

    -- two intersects, ensure order is correct
    if (a_bt > a_tt) then
      DoAddVertex(a_tt, g_Lz2, g_Rz2)
      DoAddVertex(a_bt, g_Lz1, g_Rz1)

      bt = 777 ; tt = 777
    end
  end

  if (bt == 0) then DoAddVertex(a_bt, g_Lz1, g_Rz1) end
  if (tt == 0) then DoAddVertex(a_tt, g_Lz2, g_Rz2) end

  -- right edge

  if ((f_Rz2 < g_Rz1 - Z_EPSILON) or (f_Rz1 > g_Rz2 + Z_EPSILON)) then

    -- none

  else

    local z1 = math.max(f_Rz1, g_Rz1)
    local z2 = math.min(f_Rz2, g_Rz2)

    AddVert(1.0, z2)

    if (z1 < z2 - Z_EPSILON) then
      AddVert(1.0, z1)
    end
  end

  -- bottom edge

  if (bb == 0 and tb == 0) then

    -- two intersects, ensure order is correct
    if (a_bb < a_tb) then
      DoAddVertex(a_tb, g_Lz2, g_Rz2)
      DoAddVertex(a_bb, g_Lz1, g_Rz1)

      bb = 888 ; tb = 888
    end
  end

  if (bb == 0) then DoAddVertex(a_bb, g_Lz1, g_Rz1) end
  if (tb == 0) then DoAddVertex(a_tb, g_Lz2, g_Rz2) end


  -- check face is OK
  -- [ this should not happen, but just in case... ]

  if (# output_face < 3) then
    result_text = "BAD FACE (LACKING)"
  end
end



function CreateQuad()
  local L1, L2
  local R1, R2

  repeat
    L1 = math.floor(math.random() * 8)
    L2 = math.floor(math.random() * 8)

    R1 = math.floor(math.random() * 8)
    R2 = math.floor(math.random() * 8)

    if L2 < L1 then L1,L2 = L2,L1 end
    if R2 < R1 then R1,R2 = R2,R1 end 

  until not (L1 == L2 and R1 == R2)

  return L1,L2, R1,R2
end



function Test(n)
  print("Doing:", n)

  local filename = string.format("ft_%05d__%02d.svg", seed, n)

  output_face = 0
  result_text = 0

   gap_Lz1,  gap_Lz2,  gap_Rz1,  gap_Rz2 = CreateQuad()
  face_Lz1, face_Lz2, face_Rz1, face_Rz2 = CreateQuad()

  SVG_Begin(filename)

  SVG_Grid(1)
  SVG_Grid(2)

  SVG_Quad(1, "gap",   gap_Lz1,  gap_Lz2,  gap_Rz1,  gap_Rz2)
  SVG_Quad(1, "face", face_Lz1, face_Lz2, face_Rz1, face_Rz2)

  local res = ClipWallFace( gap_Lz1,  gap_Lz2,  gap_Rz1,  gap_Rz2,
                           face_Lz1, face_Lz2, face_Rz1, face_Rz2)

  if result_text ~= 0 then
    SVG_ResultText(2)

  else
    SVG_Quad(2, "gap",   gap_Lz1,  gap_Lz2,  gap_Rz1,  gap_Rz2)

    SVG_OutputFace(2)
  end

  SVG_End()
end



function Main()
  if seed < 0 then seed = -seed end

  print("SEED:", seed)

  math.randomseed(seed)

  for n = 1, 50 do
    Test(n)
  end

  print("ALL DONE.")
end


Main()

