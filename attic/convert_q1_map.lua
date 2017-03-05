--
-- Convert Q1 map file to oblige brushes
--
-- Some brushes will require manual conversion!
--
-- USAGE: lua convert_q1_map.lua < blah.map > out.lua
--

LINES = {}

POS = 0

ALL_ENTS = {}

LINK_ID = 1


-- entity keywords whose values should remain as strings
STRING_KEYWORDS =
{
  classname = 1,
  gametype = 1,
  map = 1,
  message = 1,
  model = 1,
  music = 1,
  noise = 1,
  sound = 1,
  target = 1,
  targetname = 1,
  team = 1,
  ["type"] = 1,
  wad = 1,
}


ENT_MAP = {}
TEX_MAP = {}


function err_msg(fmt, ...)
  io.stderr:write(string.format(fmt, ...))
end


function output_mapping_table(tab, name)
  print(name .. " = ")
  print("{")

  for k,v in pairs(tab) do
    print(string.format("  %-30s = \"%s\",", "[\"" .. k .. "\"]", v))
  end

  print("}")
  print()
end


function plane_for_face(F)
  -- get the normal from the cross-product of V1->V2 and V1->V3

  local d1 = F.v2[1] - F.v1[1]
  local d2 = F.v2[2] - F.v1[2]
  local d3 = F.v2[3] - F.v1[3]

  local e1 = F.v3[1] - F.v2[1]
  local e2 = F.v3[2] - F.v2[2]
  local e3 = F.v3[3] - F.v2[3]

  local nx = d3 * e2 - d2 * e3
  local ny = d1 * e3 - d3 * e1
  local nz = d2 * e1 - d1 * e2

  local n_len = math.sqrt(nx*nx + ny*ny + nz*nz)

  if n_len < 0.00001 then
    error("face with degenerate plane!")
  end

  nx = nx / n_len
  ny = ny / n_len
  nz = nz / n_len

  local plane =
  {
    px = F.v1[1],
    py = F.v1[2],
    pz = F.v1[3],

    nx = nx,
    ny = ny,
    nz = nz,
  }

  return plane
end


function vertex_relation_to_side(V, S)
  -- returns 0 if v lies on plane of S (within some epsilon),
  -- or +1 if v lies on front of S, or -1 if v lies on back.

  -- calc distance to the plane   [ nz == 0 ]
  local plane = S.plane

  local d = (V.x - plane.px) * plane.nx +
            (V.y - plane.py) * plane.ny

  if math.abs(d) < 0.01 then return 0 end

  if d < 0 then return -1 end

  return 1
end


function calc_intersect(v1, v2, S)
  -- calculate the intersection point of v1-->v2 with side S.
  -- [ we assume the edge definitely crosses the plane of S ]

  local plane = S.plane

  local a = (v1.x - plane.px) * plane.nx +
            (v1.y - plane.py) * plane.ny

  local b = (v2.x - plane.px) * plane.nx +
            (v2.y - plane.py) * plane.ny

  local along = a / (a - b)

  local v3 =
  {
    x = v1.x + (v2.x - v1.x) * along,
    y = v1.y + (v2.y - v1.y) * along,
  }

  return v3
end


function plane_Z_from_XY(plane, x, y)
  -- for vertical planes, result is meaningless
  if math.abs(plane.nz) < 0.01 then return 0 end

  -- easy for flat planes
  if math.abs(plane.nz) > 0.99 then return plane.pz end

  local tx = (x - plane.px) * plane.nx;
  local ty = (y - plane.py) * plane.ny;

  return plane.pz - (tx + ty) / plane.nz;
end


function clip_winding_to_side(winding, S)
  -- basic idea: keep vertices on the back of S, discard vertices
  -- on the front of S, and insert vertices from intersection points.

  local new_winding = {}

  for i = 1, # winding do
    local v1 = winding[i]
    local v2

    if i < # winding then
      v2 = winding[i + 1]
    else
      v2 = winding[1]
    end

    local rel_1 = vertex_relation_to_side(v1, S)
    local rel_2 = vertex_relation_to_side(v2, S)

    if rel_1 <= 0 then
      table.insert(new_winding, v1)
    end

    if rel_1 ~= 0 and rel_2 ~= 0 and (rel_1 * rel_2) < 0 then
      local intersect = calc_intersect(v1, v2, S)

      table.insert(new_winding, intersect)
    end
  end

  -- sanity check
  if # new_winding < 3 then return nil end

  return new_winding
end


function winding_from_brush_sides(sides)
  -- ALGORITHM: begin with a very large square, and use each half-plane
  --            to carve that square into smaller pieces.  at the end,
  --            we should have the final face.

  local BIG_COORD = 16384

  local HUGE_COORD = BIG_COORD * 8

  local winding =
  {
    { x=-HUGE_COORD, y=-HUGE_COORD },
    { x= HUGE_COORD, y=-HUGE_COORD },
    { x= HUGE_COORD, y= HUGE_COORD },
    { x=-HUGE_COORD, y= HUGE_COORD },
  }

  for n = 1, # sides do
    winding = clip_winding_to_side(winding, sides[n])

    if not winding then return "bad" end
  end

  -- check for unbounded-ness
  for i = 1, # winding do
    if math.abs(winding[i].x) > BIG_COORD or
       math.abs(winding[i].y) > BIG_COORD
    then
      return "unbound"
    end
  end

  return winding
end


function set_face_texs(B, new_tex)
  for i = 1, # B.faces do
    B.faces[i].tex = new_tex
  end
end


function output_brush_kind(B)
  local kind   = "solid"
  local medium
  local is_detail

  if string.match(B.faces[1].tex, "WAT") then
    kind = "liquid"
    medium = "water"
    is_detail = true
  elseif string.match(B.faces[1].tex, "LAV") then
    kind = "liquid"
    medium = "lava"
    is_detail = true
  end

  local line = "    { "

  line = line .. string.format("m=\"%s\", ", kind)

  if is_detail then
    line = line .. "detail=1, "
  end

  if medium then
    line = line .. string.format("medium=\"%s\", ", medium)
  end

  if B.link_entity then
    line = line .. string.format("link_entity=\"%s\", ", B.link_entity)
  end

  line = line .. "}"

  print(line)
end


function output_top(B, F, winding)
  -- compute highest Z
  local high_z = -9e9

  for i = 1, # winding do
    local V = winding[i]

    local z = plane_Z_from_XY(F.plane, V.x, V.y)

    high_z = math.max(high_z, z)
  end

  local line = "    { "

  line = line .. string.format("t=%1.3f, ", high_z)
  line = line .. string.format("tex=TEX_MAP[\"%s\"], ", F.tex)

  if math.abs(F.plane.nz) < 0.99 then
    line = line .. string.format("slope={ nx=%1.5f, ny=%1.5f, nz=%1.5f }, ",
                      F.plane.nx, F.plane.ny, F.plane.nz)
  end

  line = line .. "}"

  print(line)
end


function output_bottom(B, F, winding)
  -- compute lowest Z
  local low_z = 9e9

  for i = 1, # winding do
    local V = winding[i]

    local z = plane_Z_from_XY(F.plane, V.x, V.y)

    low_z = math.min(low_z, z)
  end

  local line = "    { "

  line = line .. string.format("b=%1.3f, ", low_z)
  line = line .. string.format("tex=TEX_MAP[\"%s\"], ", F.tex)

  if math.abs(F.plane.nz) < 0.99 then
    line = line .. string.format("slope={ nx=%1.5f, ny=%1.5f, nz=%1.5f }, ",
                      F.plane.nx, F.plane.ny, F.plane.nz)
  end

  line = line .. "}"

  print(line)
end


function find_side_for_edge(v1, v2, sides)
  -- find which brush side this edge is sitting on

  local best = sides[1]
  local best_dist = 9e9

  for n = 1, # sides do
    local S = sides[n]
    local plane = S.plane

    local a = (v1.x - plane.px) * plane.nx +
              (v1.y - plane.py) * plane.ny

    local b = (v2.x - plane.px) * plane.nx +
              (v2.y - plane.py) * plane.ny

    local dist = math.max(math.abs(a), math.abs(b))

    if dist < best_dist then
      best = S
      best_dist = dist
    end
  end

  return best
end


function output_side(B, v1, v2, S)
  local line = "    { "

  line = line .. string.format("x=%1.3f, y=%1.3f, ", v1.x, v1.y)
  line = line .. string.format("tex=TEX_MAP[\"%s\"], ", S.tex)

  line = line .. "}"

  print(line)
end


function output_all_sides(B, sides, winding)
  for i = 1, # winding do
    local v1 = winding[i]
    local v2

    if i < # winding then
      v2 = winding[i + 1]
    else
      v2 = winding[1]
    end

    local S = find_side_for_edge(v1, v2, sides)
    assert(S)

    output_side(B, v1, v2, S)
  end
end


function convert_brush(B)
  -- returns true if successful

  -- we need brushes with a single top face, single bottom face,
  -- and the rest are side faces which are purely vertical.

  local top
  local bottom
  local sides = {}

  for i = 1, # B.faces do
    local F = B.faces[i]

    if math.abs(F.plane.nz) < 0.01 then
      -- side face

      table.insert(sides, F)

    elseif F.plane.nz > 0 then
      -- top face

      if top then return false end

      top = F

    else
      -- bottom face

      if bottom then return false end

      bottom = F
    end
  end

  if top == nil or bottom == nil then return false end

  local winding = winding_from_brush_sides(sides)

  if winding == "bad"     then return false end
  if winding == "unbound" then return false end

  -- FIXME : check if any side faces become dudded by the top/bottom planes

  -- create the output brush

  print("  {")

  output_brush_kind(B)

  output_all_sides(B, sides, winding)

  output_top   (B, top,    winding)
  output_bottom(B, bottom, winding)

  print("  }")

  return true
end


function convert_prop(k, v)
  if k == "origin" then
    if type(v) == "table" then
      print("    x = " .. v[1])
      print("    y = " .. v[2])
      print("    z = " .. v[3])
    end

    return
  end

  if k == "mangle" or k == "angles" then
    -- TODO
    return
  end

  if k == "color" or k == "_color" then
    print(string.format("    color = { %1.4f, %1.4f, %1.4f }", v[1], v[2], v[3]))
    return
  end

  if k == "classname" then return end

  -- if it looks like a number, remove the quotes
  if STRING_KEYWORDS[k] or string.match(v, "^[0-9.-eE ]*$") == nil then
    v = "\"" .. v .. "\""
  end

  print(string.format("    %s = %s", k, v))
end


function convert_entity(ent, is_world)
  local classname = ent.props.classname

  if classname == nil or classname == "" then return end

  -- create links for mapmodels
  if # ent.brushes > 0 and not is_world then
    ent.props["link_id"] = string.format("m%d", LINK_ID)
    LINK_ID = LINK_ID + 1

    for b = 1, #ent.brushes do
      ent.brushes[b].link_entity = ent.props["link_id"]
    end
  end

  if not is_world then
    print("  {")
    print(string.format("    id = ENT_MAP[\"%s\"]", classname))

    for k,v in pairs(ent.props) do
      convert_prop(k, v)
    end
  end

  if not is_world then
    print("  }")
  end
end


function convert_entity_brushes(ent)
  for b = 1, # ent.brushes do
    local B = ent.brushes[b]

    if convert_brush(B) then
      -- ok
    else
      print("--    @@@@ FIX BRUSH @ line:" .. B.start_line .. " @@@@")
    end
  end
end


----------------------------------------------------------------------


function next_line()
  POS = POS + 1

  local line = LINES[POS]

  if line == nil then return "" end

  return line
end


function parse_vector(str)
  assert(str)

  local x, y, z = string.match(str, "^%s*(%S+)%s+(%S+)%s+(%S+)%s*$")

  if x == nil or y == nil or z == nil then
    err_msg("bad vector coords, line:%d got: '%s'\n", POS, str)
    return { -7,-7,-7 }
  end

  x = 0 + x
  y = 0 + y
  z = 0 + z

  return { x, y, z }
end


function parse_face(line)
  if not string.match(line, "^[(]") then
    err_msg("bad brush face, line:%d got: %s\n", POS, line)
    return nil
  end

  local v1, v2, v3, tex, n1, n2, n3, sc1, sc2 =
    string.match(line, "^[(]([^)]+)[)]%s*[(]([^)]+)[)]%s*[(]([^)]+)[)]%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s*$")

  if v1 == nil or v2 == nil or v3 == nil or tex == nil then
    err_msg("bad brush face, line:%d got: %s\n", POS, line)
    return nil
  end

  v1 = parse_vector(v1)
  v2 = parse_vector(v2)
  v3 = parse_vector(v3)

  if v1 == nil or v2 == nil or v3 == nil then
    err_msg("bad brush face, line:%d got: %s\n", POS, line)
    return nil
  end

  local F =
  {
    v1 = v1,
    v2 = v2,
    v3 = v3,
    tex = tex
  }

  if n1 ~= ni then F.n1 = 0 + n1 end
  if n2 ~= n2 then F.n2 = 0 + n2 end
  if n3 ~= n3 then F.n3 = 0 + n3 end

  if sc1 ~= sc1 then F.sc1 = 0 + sc1 end
  if sc2 ~= sc2 then F.sc2 = 0 + sc2 end

  F.plane = plane_for_face(F)

---  print("plane:", F.plane.nx, F.plane.ny, F.plane.nz)

  TEX_MAP[tex] = tex

  return F
end


function parse_brush()
  local B = {}

  B.start_line = POS
  B.faces = {}

  while true do
    line = next_line()

    if line == "}" then break; end

    local F = parse_face(line)

    if F then
      table.insert(B.faces, F)
    end
  end

  B.end_line = POS

  if # B.faces < 5 then
    err_msg("Brush with too few faces, line:%d\n", B.start_line)
    return nil
  end

  return B
end


function parse_entity()
  local line = next_line()

  if line ~= "{" then
    err_msg("expected { on line:%d, got: %s\n", POS, line)
    return
  end

  local props   = {}
  local brushes = {}

  while true do
    line = next_line()

    if line == "}" then break; end

    if line == "{" then
      local B = parse_brush()

      if B then
        table.insert(brushes, B)
      end

    else
      local key, value = string.match(line, "^%s*\"([^\"]+)\"%s+\"([^\"]*)\"%s*$")

      if key == nil or value == nil then
        err_msg("bad key/value pair on line:%d, got: %s\n", POS, line)
      else
        if key == "origin" or key == "mangle" or key == "angles" or
           key == "color"  or key == "_color"
        then
          value = parse_vector(value)
        end

        props[key] = value
      end
    end
  end

  local ent = { start_line=POS }

  ent.props   = props
  ent.brushes = brushes

  table.insert(ALL_ENTS, ent)

  if props.classname and props.classname ~= "worldspawn" then
    ENT_MAP[props.classname] = props.classname
  end
end


function main()
  -- read each line
  LINES = {}
  POS   = 0

  for line in io.input():lines() do
    -- TODO strip leading and trailing whitespace

    -- skip comments
    if not string.match(line, "^//") then
      table.insert(LINES, line)
    end
  end

  while POS < # LINES do
    parse_entity()
  end

  output_mapping_table(ENT_MAP, "ENT_MAP")
  output_mapping_table(TEX_MAP, "TEX_MAP")

  if # ALL_ENTS >= 1 then
    print("all_entities =")
    print("{")

    for i = 1, # ALL_ENTS do
      convert_entity(ALL_ENTS[i], i == 1)
    end

    print("}")
    print("")
    print("all_brushes =")
    print("{")

    for i = 1, # ALL_ENTS do
      convert_entity_brushes(ALL_ENTS[i])
    end

    print("}")
  end
end


main()

