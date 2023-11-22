------------------------------------------------------------------------
--  SCENERY CONSTRUCTION
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

--
-- A "Feature" is a somewhat special section of the track, where
-- both sides of the track are utilized.  Example is tunnels, 
-- where the segments on the side of the track fold up over the
-- road to form the tunnel.
--
FEATURES =
{
  -- quite flat on both sides, e.g. desert plains, and fairly
  -- sparse scenery.
  --
  -- Note : this must be a feature (not an edge), since edges cannot
  --        force making the road flat.
  plains =
  {
    length = { 10, 30 },

    can_start  = true,
    can_finish = true,

    slopes = "none",
    twists = "none"
  },


  -- tall trees on each side (using road segments at outer part)
  -- and a dark road.
  forest =
  {
    length = { 14, 30 },

    slopes = "none",  -- TODO allow minor slopage
    twists = "none",

    allow_lamps = true
  },


  -- flat areas on the sides (asphalt or concrete) with buildings,
  -- and other urbany stuff, generally with a railing.
  city_center =
  {
    length = { 20, 30 },

    can_start  = true,
    can_finish = true,

    slopes = "none",
    twists = "none",

    allow_lamps = true
  },


  -- makes a stadium (big slope with seats) on sides of road
  stadium =
  {
    length = { 13, 13 },

    can_start  = true,
    can_finish = true,

    slopes = "none",
    twists = "none",

    allow_lamps = true,

    x_profile =
    {
      near = { 1.5, 3.0, 3.0 },
      far  = { 2.0, 6.0, 6.0 },

      z_power = 1.0
    }
  },


  -- tunnels are formed by folding the side segments over the top
  -- of the road, and want darker road texture and tunnel-y side/top
  -- textures.  generally flat (or _slight_ incline) and never twisted.
  -- might have windows (previous edge is a DROP-OFF) or fake windows.
  low_tunnel =
  {
    length = { 10, 32 },

    tunnel_mode = "low",

    slopes = "none",
    twists = "none"
  },


  -- same as low_tunnel, but with a high roof
  high_tunnel =
  {
    length = { 6, 24 },

    tunnel_mode = "high",

    slopes = "none",
    twists = "none"
  },


  -- an overpass is a very short tunnel (a single segment)
  overpass =
  {
    length = { 3, 3 },  -- a seg each side for the transition

    tunnel_mode = "low",

    slopes = "none",
    twists = "none"
  },


  -- a long tunnel, usually decending down at the entrance and
  -- coming back up at the end.  Some sloping is allowed, and maybe
  -- a little bit of twisting.  Never has windows.
  cave =
  {
    length = { 20, 60 },

    tunnel_mode = "cave",

    enter_slope = "down",
     exit_slope = "up",

    slopes = "few",
    twists = "few"
  },


  -- a tunnel which looks like a parking lot (TR7)
--TODO  parking_lot = { }


  -- a section of road which falls off quite steeply.
  -- never twisted.
  steep_fall =
  {
    length = { 7, 14 },

    need_edge = "both",

    slopes = "big_fall",
    twists = "none"
  },

  -- a section of road which climbs up quite steeply.
  -- never twisted.
  steep_climb =
  {
    length = { 7, 14 },

    need_edge = "both",

    slopes = "big_climb",
    twists = "none"
  },


--[[ TODO
  bridge =
  {
    length = { 4,10 }

    enter_slope = "up"
     exit_slope = "down"
  }
--]]
}


function assign_features()
  --
  -- This decides which part of the track will contain which features.
  -- There is usually at least one feature, but it's not required.
  -- 

  -- current position (in segments)
  local pos

  local remain_segs


  local function collect_usable_features(pos)
    local tab = { }

    -- this is not a real feature  [ it's the lack of a feature ]
    tab.NONE = TRACK.info.features.NONE

    if not tab.NONE or type(tab.NONE) ~= "number" or tab.NONE <= 0 then
      error("Bad track info : features has bad/missing 'NONE' entry")
    end

    -- if distance between last feature has grown long, then try hard
    -- to pick something now.
    local last_end = 1

    local last = table.last(TRACK.features)
    if last then
      last_end = last.p2
    end

    if pos - last_end > 99 then
      tab.NONE = 0.1
    end

    local finish_p = TRACK.finish_seg.index

    -- build the table...

    for name,info in pairs(FEATURES) do
      -- starting only?
      if not info.can_start and pos < 10 then goto continue end

      -- do we have enough track left for it?
      if info.length[1] > (remain_segs - 8) then goto continue end

      -- does it clobber the finish (or is too close)?
      if not info.can_finish and TRACK.open and
         not (pos > finish_p + 2 or
              pos + info.length[2] < finish_p - 3)
      then goto continue end

      -- this can be NIL if track does not want this feature
      tab[name] = prob_for_feature(name)

      ::continue::
    end

    return tab
  end


  local function pick_feature(pos, tab)
    local tab = collect_usable_features(pos)

    if table.empty(tab) then return nil end

    local name = rand.key_by_probs(tab)
    if name == "NONE" then return nil end

    -- remember how often this feature has been used
    TRACK.used_features[name] = (TRACK.used_features[name] or 0) + 1

    local info = FEATURES[name]

    -- select skin
    local skin
    -- TODO : review this  (hack for steep_fall / climb)
    if info.need_edge == "both" then
      skin = {}
    else
      skin = lookup_skin(name)
    end

    table.merge_missing(skin, info)


    -- decide length
    local len = rand.irange(info.length[1], info.length[2])

    len = math.min(len, remain_segs - 4)

    -- TODO : at start of a closed track, sometimes extend feature
    --        before the start (p1 will end up negative)

    local feature =
    {
      name = name,
      skin = skin,

      p1  = pos,
      p2  = pos + len - 1,
      len = len
    }

    return feature
  end


  local function install_feature(feature)
    table.insert(TRACK.features, feature)

stderrf("  %d..%d --> %s\n", feature.p1, feature.p2, feature.name)

    for p = feature.p1, feature.p2 do
      local seg = lookup_seg(p)

      seg.feature = feature
    end
  end


  local function mark_finish_pos()
    -- this value determined by trial and error
    local OPEN_FINISH_BACK = 44

    if TRACK.closed then
      TRACK.finish_seg = TRACK.segments[1]
    else
      TRACK.finish_seg = lookup_seg(TRACK.num_segments - OPEN_FINISH_BACK)

      stderrf("Finish position: seg #%d\n", TRACK.finish_seg.index)
    end

    TRACK.finish_seg.is_finish = true
  end


  ---| assign_features |---

  mark_finish_pos()

stderrf("Assign features:\n")

  pos = 1

  local GAP_LENGTHS = TRACK.gap_lengths or { 18, 28, 44 }

  while pos < TRACK.num_segments do
    remain_segs = TRACK.num_segments - pos

    local feature = pick_feature(pos, tab)

    if feature then
      install_feature(feature)
      pos = feature.p2 + 1
    end

    -- leave a gap between features
    pos = pos + rand.pick(GAP_LENGTHS)
  end
end


------------------------------------------------------------------------


--
-- An "Edge" describes what to do with a single side of the track.
-- The sections of track between two features will consist of these
-- edges, and each side is decided and built fairly independently.
--
EDGES =
{
  -- small to medium incline on the side, often with houses, ruins
  -- or the other occasional scenery (adverts, giant tyres, etc).
  -- curves might have a series of warn-ish turn signs.
  low_hills =
  {
    x_profile =
    {
      near = { 0.6, 1.5, 3.0 },
      far  = { 3.0, 7.5, 15.0 },

      z_power = 0.9
    },

    z_profile =
    {
      low   = { 0.2, 1.0, 2.0 },
      high  = { 0.8, 2.0, 3.5 },
      delta = { 0.88, 1.44, 2.22 },

      z_power = 0.6
    }
  },


  -- medium to high hills, less scenery that low_hills
  high_hills =
  {
    x_profile =
    {
      near = { 0.6, 1.5, 3.0 },
      far  = { 3.0, 7.5, 15.0 }
    },

    z_profile =
    {
      low   = { 0.5, 2.0, 4.5 },
      high  = { 1.5, 5.0, 9.0 },
      delta = { 1.11, 2.22, 3.33 }
    }
  },


  -- steep incline right next to the road, as if the terrain has
  -- been carved away to put the road through it.
  -- might use outer segment to make a tree-line.
  embankment =
  {
    x_profile =
    {
      near = { 0.3, 0.6, 3.0 },
      far  = { 1.0, 2.0, 8.0 },

      z_power = 0.2
    },

    z_profile =
    {
      low   = { 2.0, 4.0, 6.0 },
      high  = { 2.2, 4.5, 7.0 },
      delta = { 0.5, 0.75, 1.0 }
    }
  },


  -- a lowish area (even below road) in front of a hill or mountain
  -- at the far end (outermost part).
  -- can have trees in the lowish area (like a park)
--TODO  hill_foot = { }


  -- a raised but fairly flat area next to road, which can contain
  -- houses or other scenery, and beyond this flat area is another
  -- embankment.
-- TODO plateau = { }


  -- a medium to tall fence (usually cannot see the top), with tall
  -- buildings and sky-scrapers behind it.
  -- fence _may be transparent.
  fence =
  {
    x_profile =
    {
      near = { 0, 0, 2  },
      far  = { 0, 0, 15 },
      z_power = 0.2
    },

    z_profile =
    {
      low   = { 1.0, 0.0, 0.0 },
      high  = { 1.0, 0.0, 0.0 },
      delta = { 0.0, 0.0, 0.0 }
    }
  },


  -- a short fence with a verge of grass or dirt coming off (sloping up)
  -- and ending with a vertical wire fence.  Buildings behind all this
  -- (possibly trees on the verge, but rare).
  verge =
  {
    x_profile =
    {
      near = { 0,  1.5,  1.5 },
      far  = { 0,  4.5,  4.5 },
      z_power = 0.2
    },

    z_profile =
    {
      low   = { 0.11, 0.7, 0.0 },
      high  = { 0.11, 1.8, 0.0 },
      delta = { 0.0, 0.33, 0.0 },

      last_h = 1.5
    }
  },


  -- a sharp drop-off, like near a cliff edge.
  -- occasionally a piece juts out (e.g. with a tree on it).
  drop_off =
  {
  },


  -- a shallow drop-off that goes does to a fixed Z height, usually
  -- ending with a watery texture.  only made on a single side.
  beach =
  {
    single_side = "outer",

    x_profile =
    {
      near = { 0.2, 1.2,  4.0 },
      far  = { 0.6, 3.6, 12.0 }
    }
  }
}


function assign_edges(side)
  --
  -- This decides what the edges of the track will be (in the parts
  -- not already containing a feature).
  --

  local function pick_edge(p1, p2)
    local tab = {}

    for name,info in pairs(EDGES) do
      -- requirements ???

      if info.single_side and not match_side(info.single_side, side) then
        goto continue
      end

      -- this may be NIL if the track does not want this edge type
      tab[name] = prob_for_feature(name)

      ::continue::
    end

    assert(not table.empty(tab))

    local name = rand.key_by_probs(tab)

    -- remember how often this feature has been used
    TRACK.used_features[name] = (TRACK.used_features[name] or 0) + 1

    -- select skin
    local info = EDGES[name]
    local skin = lookup_skin(name)

    table.merge_missing(skin, info)

    local edge =
    {
      name = name,
      skin = skin,

      p1   = p1,
      p2   = p2,
      len  = (p2 - p1 + 1),
      side = side
    }

    return edge
  end


  local function install_edge(edge)
    table.insert(TRACK.edges[side], edge)

stderrf("  %d..%d --> %s\n", edge.p1, edge.p2, edge.name)

    for p = edge.p1, edge.p2 do
      local seg = lookup_seg(p)

      seg.edges[side] = edge
    end
  end


  local function fill_an_edge(p1, p2)
    local len = p2 - p1 + 1

    local edge

    -- at end of a closed track, use same edge as beginning [if exists]
    if TRACK.closed and p2 == TRACK.num_segments then
      edge = TRACK.edges[side][1]

      if edge.p1 == 1 and not edge.is_feature then
        -- extend current edge

        edge.len = edge.len + len
        edge.p1  = p1
        edge.p2  = p1 + edge.len - 1
      else
        edge = nil
      end
    end

    if not edge then
      edge = pick_edge(p1, p2)
    end

    -- store it into the segments
    install_edge(edge)
  end


  local function fill_the_gap(p1, p2)
    local list = break_into_pieces(p1, p2, 18)

    for _,part in pairs(list) do
      fill_an_edge(part.p1, part.p2)
    end
  end


  local function add_edge_from_feature(feature)
    -- create an edge which represents a feature

    -- features get to use the end vertices of a segment strip
    -- (== start vertices of the next segment), so mark it here
    local next_seg = lookup_seg(feature.p2 + 1)
    if next_seg then
      next_seg.start_in_use = true
    end

    local edge = table.copy(feature)

    edge.is_feature = true
    edge.side = side

    install_edge(edge)
  end


  local function collect_normal_features()
    -- ignore certain features (ones that need edges)

    local list = {}

    for _,feature in pairs(TRACK.features) do
      if feature.skin.need_edge == "both" then goto continue end
      if feature.skin.need_edge == side_str(side) then goto continue end

      table.insert(list, feature)

      ::continue::
    end

    return list
  end


  ---| assign_edges |---

stderrf("Assign_edges on: %s\n", side_str(side))

  TRACK.edges[side] = {}

  local feature_list = collect_normal_features()

  local pos = 1

  for i = 1, #feature_list do
    local feature = feature_list[i]

    if pos < feature.p1 then
      fill_the_gap(pos, feature.p1 - 1)
    end

    add_edge_from_feature(feature)

    pos = feature.p2 + 1
  end

  -- handle any gap at the end
  -- (could potentially be the whole track)

  if pos < TRACK.num_segments then
    fill_the_gap(pos, TRACK.num_segments)
  end
end


------------------------------------------------------------------------


function slope_the_track()
  --
  -- create a height profile of the track (which makes slopes).
  -- we must ensure that in closed tracks the final height is zero
  -- (same as the start).  We also never slope the beginning part
  -- of the track -- game engine likes it straight and flat.
  --

  --
  -- ALSO create a twist profile of track, ensuring that for closed
  -- tracks the final twist angle is zero, and keeping certain areas
  -- completely flat.
  --

  local MAX_NORMAL_SLOPE = 30
  local MAX_NORMAL_TWIST = 30


  local function determine_height_limits()
    -- for closed tracks, need to ensure not only that the final
    -- height is zero, but that the last feature does not end too
    -- far away from zero (vertically), otherwise there will be a
    -- tendency to have steep climbs or falls at the end of tracks.

    for i = 1, TRACK.num_segments do
      local seg = TRACK.segments[i]

      local k = sel(i < TRACK.num_segments / 2, i, TRACK.num_segments - i + 1)

      seg.max_height = math.min(k / 4, 24)

      -- even less variation for tracks near water (Coastline)
      if TRACK.info.features.beach then
        seg.max_height = math.min(12, seg.max_height)
      end
    end
  end


  local function height_diff_for_feature(feature, len)
    if feature.skin.slopes == "none" then return 0 end

    if feature.skin.slopes == "big_climb" then return  len / 2 end
    if feature.skin.slopes == "big_fall"  then return -len / 2 end

    local sk = rand.skew()

    return len * (sk / 6)
  end


  local function pick_a_height(z1, z2)
    local mx = (z1 + z2) / 2
    local lx = z1 + (z2 - z1) * 0.25
    local hx = z1 + (z2 - z1) * 0.75

    local list = { z1, lx,lx, mx,mx, hx,hx, z2 }

    return rand.pick(list)
  end


  local function intermediate_height(base_z, diff)
    -- for tracks near water, avoid going below zero
    if TRACK.info.features.beach and base_z + diff >= 0 then
      return pick_a_height(math.max(0, base_z - diff), base_z + diff)
    end

    return pick_a_height(base_z - diff, base_z + diff)
  end


  local function pick_feature_heights()
    -- pick a height for the start and end point of each feature.
    -- these form the backbone of the track's height profile.

    -- Requirements:
    --   (1) one end of the feature obeys the 'max_height' limit.
    --       this requirement is most important and is enforced.
    --       which end (start or finish) depends on where in track.
    --
    --   (2) slope between last feature and current one is not too
    --       large. [only applies when there was a last feature]
    --
    --   (3) if feature has 'entry_slope' of 'exit_slope', try to
    --       honor them [entry is more important].
    
    local prev_z  = 0
    local prev_p2 = 0

stderrf("pick_feature_heights:\n")

    for _,feature in pairs(TRACK.features) do

      -- keep the very beginning of the track flat
      if feature.p1 < 25 then
stderrf("  flat : 0 --> 0\n")
        feature.z1 = 0
        feature.z2 = 0
        prev_z = 0
        goto continue
      end

      local p1  = feature.p1
      local p2  = feature.p2
      local len = feature.len

      local gap_dist = p1 - prev_p2

      local feat_diff = height_diff_for_feature(feature, len)

      local check_end = (p2 > TRACK.num_segments / 2)

      -- determine absolute limits
      local abs_z2 = TRACK.segments[sel(check_end, p2, p1)].max_height
      assert(abs_z2)
      local abs_z1 = 0 - abs_z2

      if check_end then
        abs_z1 = abs_z1 - feat_diff
        abs_z2 = abs_z2 - feat_diff
      end

      -- determine slope limit
      if prev_p2 > 0 then
        local slope = math.tan(MAX_NORMAL_SLOPE * 0.7 * math.pi / 180)

        local sl_z2 = prev_z + gap_dist * slope
        local sl_z1 = prev_z - gap_dist * slope

        if sl_z1 > abs_z2 - 0.01 then
          abs_z1 = abs_z2
        elseif sl_z2 < abs_z1 + 0.01 then
          abs_z2 = abs_z1
        else
          abs_z1 = math.max(abs_z1, sl_z1)
          abs_z2 = math.min(abs_z2, sl_z2)
        end
      end

      assert(abs_z2 >= abs_z1)

      -- for tracks near water, avoid going below zero
      if TRACK.info.features.beach and abs_z2 >= 0 then
        abs_z1 = 0
      end

      local new_z = pick_a_height(abs_z1, abs_z2)

      feature.z1 = new_z
      feature.z2 = new_z + feat_diff

stderrf("  %1.3f --> %1.3f\n", feature.z1, feature.z2)

      prev_z  = feature.z2
      prev_p2 = p2

      ::continue::
    end
  end


  local function linear_slope(p1, p2, z1, z2)
    local v1 = p1 * 4 - 3
    local v2 = p2 * 4

    for v = v1, v2 do
      local z = z1 + (z2 - z1) * (v - v1) / (v2 + 1 - v1)
      TRACK.road[v].z = z
    end
  end


  local function cosine_slope(p1, p2, z1, z2)
    local v1 = p1 * 4 - 3
    local v2 = p2 * 4

    for v = v1, v2 do
      local ang = math.pi * (v - v1) / (v2 + 1 - v1)
      local z = z1 + (z2 - z1) * (1 - math.cos(ang)) / 2
      TRACK.road[v].z = z
    end
  end


  local function slope_a_gap(p1, p2, ft_before, ft_after)
    local z1, z2

    if ft_before then
      z1 = ft_before.z2
    else
      z1 = 0
    end

    if ft_after then
      z2 = ft_after.z1
    else
      z2 = 0
    end

    assert(z1 and z2)

stderrf("  %d .. %d : GAP  %1.2f %1.2f\n", p1, p2, z1, z2)

    local parts = break_into_pieces(p1, p2, 12)
    local num_parts = #parts

    local prev_z = z1

    for i = 1, num_parts do
      local base_z
      local end_z

      if i >= num_parts then
        end_z = z2
      -- keep it flat at start of track
      elseif parts[i].p1 < 12 then
        end_z = z1
      else
        base_z = z1 + (z2 - z1) * parts[i].frac
        end_z  = intermediate_height(base_z, 6)
      end

stderrf("   ----> %d .. %d : %1.2f %1.2f\n", parts[i].p1, parts[i].p2, prev_z, end_z)

      cosine_slope(parts[i].p1, parts[i].p2, prev_z, end_z)

      prev_z = end_z
    end
  end


  local function slope_a_feature(p1, p2, feature)
stderrf("  %d .. %d : FEATURE %s  %1.2f %1.2f\n", p1, p2, feature.name, feature.z1, feature.z2)
 
    cosine_slope(p1, p2, feature.z1, feature.z2)
  end


  --------- LET'S TWIST AGAIN...


  local function cosine_twist(p1, p2, tw1, tw2)
    local v1 = p1 * 4 - 3
    local v2 = p2 * 4

    for v = v1, v2 do
      local ang = math.pi * (v - v1) / (v2 + 1 - v1)
      local tw = tw1 + (tw2 - tw1) * (1 - math.cos(ang)) / 2
      TRACK.road[v].twist = tw
    end
  end


  local function twist_a_gap(p1, p2)
    -- nothing at the start
    if p1 < 10 then return end

    if p2 - p1 < 4 then return end

--[[ TEST :
    local p3 = p1 + (p2 - p1) / 2

    local twist = 40

    cosine_twist(p1, p3,     0, twist)
    cosine_twist(p3 + 1, p2, twist, 0)
--]]
  end


  local function twist_a_feature(p1, p2, feature)
    -- todo?
  end


  local function calc_delta_z()
    for _,node in pairs(TRACK.road) do
      local node2 = lookup_node(node.index + 1) or node

      node.dz = node2.z - node.z
    end
  end


  ---| slope_the_track |---

stderrf("Slope the track:\n")

  determine_height_limits()

  pick_feature_heights()

stderrf("doing slopes:\n")

  local gap_end

  if table.empty(TRACK.features) then
    gap_end = TRACK.num_segments
    
    slope_a_gap(1, gap_end, nil, nil)
    twist_a_gap(1, gap_end)

  elseif TRACK.features[1].p1 > 1 then
    gap_end = TRACK.features[1].p1 - 1

    slope_a_gap(1, gap_end, nil, TRACK.features[1])
    twist_a_gap(1, gap_end)
  end

  for _,feature in pairs(TRACK.features) do
    local next_ft = TRACK.features[_index + 1]

    slope_a_feature(feature.p1, feature.p2, feature)
    twist_a_feature(feature.p1, feature.p2, feature)

    if next_ft then
      gap_end = next_ft.p1 - 1
    else
      gap_end = TRACK.num_segments
    end

    slope_a_gap(feature.p2 + 1, gap_end, feature, next_ft)
    twist_a_gap(feature.p2 + 1, gap_end)
  end

  calc_delta_z()
end


------------------------------------------------------------------------


function render_the_road()
  local normal_skin = lookup_skin("road_normal")
  local finish_skin = lookup_skin("road_finish", "none_ok")

  local TEX_POS = { -2, -1, 1, 2 }


  --- Segments ---

  for _,seg in pairs(TRACK.segments) do
    local pos = _index

    local skin = normal_skin

    if seg.feature and seg.feature.skin.road_tex then
      -- first and last segment of tunnel is a transition
      if seg.feature.skin.normal_road_trans and
        (pos == seg.feature.p1 or pos == seg.feature.p2)
      then
        -- leave it
      else
        skin = seg.feature.skin
      end
    end

    if seg.is_finish then
      skin = finish_skin or skin
    end

    for t = 1, 4 do
      seg.textures[TEX_POS[t]] = skin.road_tex[t]
    end
  end


  --- Nodes ---

  local function build_road(node, side)
    local twist_mul = math.tan(-(node.twist or 0) * math.pi / 180)

    twist_mul = twist_mul * sel(side == LF, -1, 1)

    local width1 = node.width1
    local width2 = node.width2

    -- move wall of tunnel a bit further out
    local feature = node.seg.feature

    if feature and feature.skin.tunnel_mode then
      width2 = width2 + 0.2

      -- tunnel walls are crashy
      node.hard[side] = true
    end

    r_set_coord(node, 0, LF,    0, 0, 0)
    r_set_coord(node, 1, side,  width1, 0, width1 * twist_mul)
    r_set_coord(node, 2, side,  width2, 0, width2 * twist_mul)
  end


  local road_width = TRACK.info.road_width or { 1.0, 1.5 }

  for _,node in pairs(TRACK.road) do
    -- make curvey parts a bit wider
    local curve_mul = 1.0 + node.curvature / 20

    node.width1 = road_width[1] * curve_mul
    node.width2 = road_width[2] * curve_mul

    build_road(node, LF)
    build_road(node, RT)
  end
end



function render_tunnels()
  local tunnel
  local skin


  local LOW_TEMPLATE =
    { 2, 0, 1.2,
      1, 0, 1.2,
      0, 0, 1.2 }

  local HIGH_TEMPLATE =
    { 2, 0, 1.5,
      1, 0, 2.1,
      0, 0, 2.4 }

  local CAVE_TEMPLATE =
    { 1,  0.3, 1.2,
      1, -0.2, 1.8,
      0,  0,   2.2 }

  local TEMPLATES =
  {
    low  =  LOW_TEMPLATE,
    high = HIGH_TEMPLATE,
    cave = CAVE_TEMPLATE
  }


  local CAVE_TRANSITION =
  {
    { 2, 0.5,  0.4,
      2, 1.5,  1.0,
      2, 2.5,  1.8 },

    { 2, 1.0,  1.6,
      2, 1.0,  2.0,
      2, 1.0,  2.4 },

    { 2, 0.0,  2.8,
      1, 0.0,  3.0,
      0, 0.0,  3.2 },

    { 2, 0.0,  1.8,
      1, 0.0,  2.0,
      0, 0.0,  2.2 }
  }


  local function cave_transition(seg_idx, reverse)
    for n = 1, 4 do
      local node_idx = (seg_idx - 1) * 4 + n
      if reverse then node_idx = node_idx + 1 end

      local node = TRACK.road[node_idx]

      local t_idx = sel(reverse, 5 - n, n)

      local template = CAVE_TRANSITION[t_idx]

      for k = 0, 2 do
        local ref = template[k*3 + 1]
        local  dx = template[k*3 + 2]
        local  dz = template[k*3 + 3]

        for side = LF, RT do
          r_delta_coord(node, 3 + k, side,  ref, dx, 0, dz)
        end
      end
    end
  end


  local FENCE_TRANSITION =
  {
    { 2, 0.0,  0.4,
      2, 1.0,  0.6,
      2, 2.0,  0.8 },

    { 2, 0.0,  0.6,
      2, 0.5,  0.8,
      2, 1.0,  1.0 },

    { 2, 0.0,  0.8,
      2, 0.0,  0.9,
      2, 0.0,  1.0 },

    { 2, 0.0,  1.0,
      1, 0.0,  1.0,
      0, 0.0,  1.0 }
  }


  local function fence_transition(seg_idx, reverse)
    local z_mul = 1.0
    
    if skin.tunnel_mode == "high" then 
      z_mul = HIGH_TEMPLATE[3] / LOW_TEMPLATE[3]
    end

    for n = 1, 4 do
      local node_idx = (seg_idx - 1) * 4 + n
      if reverse then node_idx = node_idx + 1 end

      local node = TRACK.road[node_idx]

      local t_idx = sel(reverse, 5 - n, n)

      local template = FENCE_TRANSITION[t_idx]

      for k = 0, 2 do
        local ref = template[k*3 + 1]
        local  dx = template[k*3 + 2]
        local  dz = template[k*3 + 3] * z_mul

        for side = LF, RT do
          r_delta_coord(node, 3 + k, side,  ref, dx, 0, dz)
        end
      end
    end

    local seg = lookup_seg(seg_idx)

    local nothing = assert(TRACK.info.textures.nothing)

    for m = -1, 1, 2 do
      seg.textures[3 * m] = skin.fence_tex or skin.edge_tex[1]
      seg.textures[4 * m] = nothing
      seg.textures[5 * m] = nothing
    end
  end


  local function make_cave_curve(mid, range, delta)
    local n_total = tunnel.n_len

    local curve = {}

    local dz = 0

    for n = 1, n_total do
      if n >= n_total - 8 then
        dz = dz * 0.8
      else
        dz = dz + rand.skew() * delta * 6

        dz = math.clamp(-range, dz, range)
      end

      curve[n] = mid + dz
    end

    return curve
  end


  local function handle_cave(template)
    local curves = {}

    -- here [0] is middle
    curves[-2] = make_cave_curve(0.8, 0.3, 0.05)
    curves[-1] = make_cave_curve(1.7, 0.4, 0.10)
    curves[ 0] = make_cave_curve(2.4, 0.5, 0.15)
    curves[ 1] = make_cave_curve(1.7, 0.4, 0.10)
    curves[ 2] = make_cave_curve(0.8, 0.3, 0.05)

    for n = tunnel.n1, tunnel.n2 do
      local node = lookup_node(n)

      local curv_idx = n - tunnel.n1 + 1

      r_delta_coord(node, 3, LF,  2,  -0.1, 0, curves[-2][curv_idx])
      r_delta_coord(node, 3, RT,  2,  -0.1, 0, curves[ 2][curv_idx])

      r_delta_coord(node, 4, LF,  1,  -0.0, 0, curves[-1][curv_idx])
      r_delta_coord(node, 4, RT,  1,  -0.0, 0, curves[ 1][curv_idx])

      r_delta_coord(node, 5, LF,  0,  0, 0, curves[0][curv_idx])
      r_delta_coord(node, 5, RT,  0,  0, 0, curves[0][curv_idx])
    end  
  end


  local function visit_tunnel(T)
    tunnel = T
    skin   = assert(T.skin)

    -- texturing --

    for p = tunnel.p1, tunnel.p2 do
      local seg = TRACK.segments[p]

      for bit = 3, 5 do
        seg.textures[ bit] = skin.edge_tex[bit - 2]
        seg.textures[-bit] = skin.edge_tex[bit - 2]
      end
    end

    -- transition --

    if skin.tunnel_mode == "cave" then
      cave_transition(tunnel.p1, nil)
      cave_transition(tunnel.p2, "reverse")
    else
      fence_transition(tunnel.p1, nil)
      fence_transition(tunnel.p2, "reverse")
    end

    -- node range, excluding the transition parts
    tunnel.n1 = tunnel.p1 * 4 + 1
    tunnel.n2 = tunnel.p2 * 4 - 3
    tunnel.n_len = tunnel.n2 - tunnel.n1 + 1

    -- entrance object --

    if skin.entrance_def then
      local node = lookup_node(tunnel.n1 - 1)

      local OBJ = r_make_object(skin.entrance_def, 9)

      r_add_object(OBJ, node, 0, LF,  0, 0, 0)
    end

    -- polygons --

    local template = TEMPLATES[skin.tunnel_mode]
    assert(template)

    if skin.tunnel_mode == "cave" then
      handle_cave(template)
      return
    end

    for n = tunnel.n1, tunnel.n2 do
      local node = lookup_node(n)

      for k = 0, 2 do
        local ref = template[k*3 + 1]
        local  dx = template[k*3 + 2]
        local  dz = template[k*3 + 3]
        local  dy = 0

        for side = LF, RT do
          r_delta_coord(node, 3 + k, side,  ref, dx, dy, dz)
        end
      end
    end  
  end


  ---| render_tunnels |---

  for _,feature in pairs(TRACK.features) do
    if feature.skin.tunnel_mode then
      visit_tunnel(feature)
    end
  end
end



function process_transitions(side)
  --
  -- At each place where two edges meet, process the transition.
  -- In particular, determine the heights (relative to track) of the
  -- three segment parts.
  --
  
  local function get_prev_edge(edge)
    local p = edge.p1 - 1
    local seg = lookup_seg(p)
    if not seg then return nil end
    return seg.edges[side]
  end


  local function get_next_edge(edge)
    local p = edge.p2 + 1
    local seg = lookup_seg(p)
    if not seg then return nil end
    return seg.edges[side]
  end


  local function profile_for_edge_pair(edge1, edge2)
    if edge1 and edge2 then
      if edge1.end_profile   then return edge1.end_profile end
      if edge2.start_profile then return edge2.start_profile end
    end

    assert(edge1 or edge2)

        if not edge1 then edge1 = edge2
    elseif not edge2 then edge2 = edge1
    end

    local name1 = edge1.name
    local name2 = edge2.name

    local function match_either(str)
      return (name1 == str) or (name2 == str)
    end

    -- TODO : put these into the FEATURE / EDGE defs ??

    -- TODO : better tunnel transitions [esp. CAVES]
    if edge1.tunnel_mode or edge2.tunnel_mode then
      return { 0, 0.5, 1 }
    end

    if name1 == "drop_off" and name2 == "drop_off" then
      return { -0.5, -4.5, -15.0 }
    end

    if name1 == "beach" and name2 == "beach" then
      return { -0.5, -1.5, -2.5 }
    end

    if match_either("city_center") or
       match_either("stadium") or
       match_either("plains") or

       match_either("fence") or
       match_either("verge") or
       match_either("drop_off") or
       match_either("beach")
    then 
      return { 0, 0, 0 }
    end

    if match_either("forest") then
      return { 0.0, 0.0, 5.0 }
    end

    if match_either("low_hills")
    then
      return { 0.3, 1.0, 3.0 }
    end

    -- TODO: embankment

    -- high_hills
    return { 1.0, 4.5, 7.0 }
  end


  ---| process_transitions |---

  for _,edge in pairs(TRACK.edges[side]) do
    local prev_e = get_prev_edge(edge)
    local next_e = get_next_edge(edge)

    edge.start_profile = profile_for_edge_pair(prev_e, edge)
    edge.  end_profile = profile_for_edge_pair(edge, next_e)
  end
end



function render_the_edges(side)
  --
  -- take all the previously decided stuff, and generate the actual
  -- track segments.
  --
  local edge
  local skin


  local std_x_profile =
  {
    near = { 1.0,  2.0,  3.0 },
    far  = { 5.0, 10.0, 15.0 }
  }


  -- side multiplier
  local M = sel(side == LF, -1, 1)

  local TEXS = TRACK.info.textures


  local function apply_railing()
    for s = edge.p1, edge.p2 do
      local seg = lookup_seg(s)
      seg.railing[side] = true
    end

    for n = edge.n1, edge.n2 do
      local node = lookup_node(n)
      node.hard[side] = true
    end
  end


  local function apply_skin(p1, p2, use_skin)
    if not use_skin then use_skin = skin end

    for s = edge.p1, edge.p2 do
      local seg = lookup_seg(s)

      seg.textures[3 * M] = use_skin.edge_tex[1]
      seg.textures[4 * M] = use_skin.edge_tex[2]
      seg.textures[5 * M] = use_skin.edge_tex[3]
    end

    if use_skin.railing then
      apply_railing()
    end
  end


  local function apply_x_profile(node, xp)
    -- xp short for x_profile

    local space = node.space[side] - node.width2
    if space < 1 then space = 1 end

    if space > xp.far[3] then
       space = xp.far[3]
    end

    local x1, x2, x3

    if space <= xp.near[3] then
      x1 = space * xp.near[1] / xp.near[3]
      x2 = space * xp.near[2] / xp.near[3]
      x3 = space
    else
      x1 = math.lerp(xp.near[3], space, xp.far[3],  xp.near[1], xp.far[1])
      x2 = math.lerp(xp.near[3], space, xp.far[3],  xp.near[2], xp.far[2])
      x3 = math.lerp(xp.near[3], space, xp.far[3],  xp.near[3], xp.far[3])
    end

    return x1, x2, x3, space
  end


  local function apply_heights(node, x_profile, h1, h2, h3)
    local x1, x2, x3
    local space
    
    x1, x2, x3, space = apply_x_profile(node, x_profile)

    local mul = space / x_profile.far[3]
    if mul < 1.0 and x_profile.z_power then
      mul = mul ^ x_profile.z_power
    end

    node.ht_space = space
    node.ht_mul   = mul

    r_delta_coord(node, 3, side,  2,  x1, 0, h1 * mul)
    r_delta_coord(node, 4, side,  2,  x2, 0, h2 * mul)
    r_delta_coord(node, 5, side,  2,  x3, 0, h3 * mul)
  end


  local function apply_heights_forest(node, h1, h2, h3)
    -- TODO : remove this, use 'apply_heights' with an x_profile
    local space = node.space[side] - node.width2
    if space < 1 then space = 1 end

    local mul = node.space[side] / 15
    if mul < 1 then mul = mul ^ 0.7 end

    r_delta_coord(node, 3, side,  2,  space*0.3, 0, h1 * mul)
    r_delta_coord(node, 4, side,  2,  space*0.7, 0, h2 * mul)
    r_delta_coord(node, 5, side,  2,  space*0.7, 0, h3 * mul)
  end


  local function apply_curve_set(curves, x_profile, last_h)
    for n = edge.n1, edge.n2 do
      local node = lookup_node(n)

      local curv_idx = n - edge.n1 + 1

      local h1 = curves[1][curv_idx]
      local h2 = curves[2][curv_idx]
      local h3 = curves[3][curv_idx]

      if last_h then
        h3 = h2 + last_h
      end

      apply_heights(node, x_profile, h1, h2, h3)
    end
  end


  local function generic_hill_profiles()
    local profs = {}

    table.insert(profs, assert(edge.start_profile))

    local z_profile = skin.z_profile

    local extra = int((edge.n2 - edge.n1 + 30) / 40)

    for i = 1, extra do
      local P = {}

      for bit = 1, 3 do
        P[bit] = rand.range(z_profile.low[bit], z_profile.high[bit])
      end

      table.insert(profs, P)
    end

    table.insert(profs, assert(edge.end_profile))

    return profs
  end


  local function make_hill_curve(profs, bit, frac_delta)
    local n_total = edge.n2 - edge.n1 + 1
    local pieces  = #profs - 1

    local min_num = int(n_total / pieces)
    assert(min_num > 0)

    local curve = {}

    assert(frac_delta)

    for p = 1, pieces do
      local len = min_num
      if p == 1 then len = len + (n_total % pieces) end

      local prof1 = profs[p]
      local prof2 = profs[p + 1]

      fractal_curve(curve, len, prof1[bit], prof2[bit], frac_delta)
    end

    return curve
  end


  local function build_generic_hill()
    local z_profile = skin.z_profile

    local profs = generic_hill_profiles()

    local curves = {}

    for bit = 1, 3 do
      curves[bit] = make_hill_curve(profs, bit, z_profile.delta[bit])
    end

    apply_curve_set(curves, skin.x_profile, z_profile.last_h)
  end


  local function lerp_profile(prof1, prof2, bit, frac)
    -- use a cosine curve
    frac = (1 - math.cos(frac * math.pi)) / 2

    return prof1[bit] + (prof2[bit] - prof1[bit]) * frac
  end


  local function make_drop_off_curve(bit, mid_prof)
    local curve = {}

    local trans_num = math.min(12, (edge.n2 - edge.n1) / 2.3)

    for n = edge.n1, edge.n2 do
      local start_dist = n - edge.n1
      local   end_dist = edge.n2 - n

      local h

      if start_dist <= trans_num then
        h = lerp_profile(edge.start_profile, mid_prof, bit, start_dist / trans_num)
      elseif end_dist <= trans_num then
        h = lerp_profile(edge.end_profile, mid_prof, bit, end_dist / trans_num)
      else
        h = mid_prof[bit]
      end
      
      table.insert(curve, h)
    end

    return curve
  end


  local function build_drop_off()
    local curves = {}

    local mid_prof = { -0.5, -4.5, -15.5 }

    curves[1] = make_drop_off_curve(1, mid_prof)
    curves[2] = make_drop_off_curve(2, mid_prof)
    curves[3] = make_drop_off_curve(3, mid_prof)

    apply_curve_set(curves, std_x_profile)
  end


  local function apply_beach_heights(node, x_profile, water_z)
    local x1, x2, x3 = apply_x_profile(node, x_profile)

    -- special logic here to set absolute Z coordinates

    local coord = r_get_coord(node, 2, side)

    local z1 = coord.z - 0.3
    local z2 = coord.z * 0.4 + water_z * 0.6
    local z3 = water_z

    r_delta_coord_abs_z(node, 3, side,  2,  x1, 0, z1)
    r_delta_coord_abs_z(node, 4, side,  2,  x2, 0, z2)
    r_delta_coord_abs_z(node, 5, side,  2,  x3, 0, z3)
  end


  local function build_beach()
    -- this is an absolute Z coord
    local water_z = skin.water_z or -0.6

    local x_profile = skin.x_profile

    for n = edge.n1, edge.n2 do
      local node = lookup_node(n)

      apply_beach_heights(node, x_profile, water_z)
    end

    -- disable water on last segment (for less ugly transition)
    local seg = lookup_seg(edge.p2)

    seg.textures[5 * M] = skin.edge_tex[2]
  end


  local NARROW_SPOTS =
  {
    { dx=2.6, size="small", where="front" }
  }

  local MEDIUM_SPOTS =
  {
    { dx=2.6, size="small", where="front" },
    { dx=5.2, size="big",   where="back"  }
  }

  local WIDE_SPOTS =
  {
    { dx=4.3, size="big", where="front" },
    { dx=8.5, size="big", where="back"  }
  }

  local function categorize_city_spots(node)
    -- if space is small, have a single row of small stuff
    -- if space is medium, two rows: front is small, back is big
    -- if space is large, have two rows where both are big

    if node.space[side] < 6 then
      return NARROW_SPOTS

    elseif (node.space[side] < 10) or rand.odds(35) or edge.name == "forest" then
      return MEDIUM_SPOTS

    else
      return WIDE_SPOTS 
    end
  end


  local function select_decor_obj(skin, size, where)
    assert(size and where)

    if not skin.decoration then return nil end

    local tab = {}

    for _,child in pairs(skin.decoration) do
      local prob = assert(child.prob)

      -- match the size
      if child.big and size ~= "big" then goto continue end

      if not child.big and size == "big" then prob = prob / 2 end

      -- match the position
      if child.row and child.row ~= where then goto continue end

      -- match the road side
      if child.side and child.side ~= side_str(side) then goto continue end

      tab[child] = prob

      ::continue::
    end

    if table.empty(tab) then return nil end

    local child = rand.key_by_probs(tab)

    if child.obj == "NONE" then return nil end

    return child
  end


  local function decorate_at_node(skin, n, adjust)
    local node = lookup_node(n)

    local spot_list = categorize_city_spots(node)

    for _,spot in pairs(spot_list) do
      -- don't add small items near road signs
      if spot.size == "small" and node.signage[side] then goto continue end

      local child = select_decor_obj(skin, spot.size, spot.where)
      if not child then goto continue end

      local OBJ = r_make_object(child.def, child.priority or 4)

      if child.flip then OBJ.flip = child.flip end

      local dx = spot.dx

      if adjust then
        if _index == 1 or edge.name == "forest" then
          local delta = sel(spot.size == "big", 0.1, 0.3)
          dx = dx + rand.offset(delta)
        else
          local extra = node.space[side] - dx - 2.5
          if extra > 0 then dx = dx + rand.range(0, extra) end
        end
      end

      -- FIXME: get proper Z coordinate

      -- TODO:  support clusters

      r_add_object(OBJ, node, 0, side,  dx, 0, 0)

      ::continue::
    end
  end


  local function build_city_center()
    for n = edge.n1, edge.n2 do
      local node = lookup_node(n)

      apply_heights(node, std_x_profile, 0, 0, 0)
    end

    for n = edge.n1 + 3, edge.n2 - 3, skin.node_step do
      decorate_at_node(skin, n)
    end
  end


  local function build_plains()
    for n = edge.n1, edge.n2 do
      local node = lookup_node(n)

      apply_heights(node, std_x_profile, 0, 0.05, 0.2)
    end

    for n = edge.n1 + 3, edge.n2 - 3, skin.node_step do
      decorate_at_node(skin, n, "adjust")
    end
  end


  local function build_forest()
    for n = edge.n1, edge.n2 do
      local node = lookup_node(n)

      apply_heights_forest(node, 0, 0.1, 5.0)
    end

    for n = edge.n1 + 3, edge.n2 - 3, skin.node_step do
      decorate_at_node(skin, n, "adjust")
    end
  end


  local function do_stadium_segs(p1, p_len)
    local p2 = p1 + p_len - 1

    -- handle stadium cut off at end of map
    if p2 > edge.p2 then return end

    for p = p1, p2 do
      local seg = lookup_seg(p)
      seg.textures[4 * M] = lookup_tex(skin.seat_tex)
    end

    local n1 = p1 * 4 - 3
    local n2 = p2 * 4 + 1

    for n = n1, n2 do
      local node = lookup_node(n)
      assert(node)

      node.coords[4 * M].z = node.coords[4 * M].z + 3.0 * node.ht_mul

      -- WISH : make vertical 
    end
  end


  local function build_stadium()
    -- initialize Z coordinates to be flat
    for n = edge.n1, edge.n2 do
      local node = lookup_node(n)
      apply_heights(node, skin.x_profile, 0, 0, 0)
    end

    -- TODO : support different lengths, generate stadium groups

    -- WISH : occasionally skip a stadium, place objects (tent etc) there

    do_stadium_segs(edge.p1 + 1, 3)
    do_stadium_segs(edge.p1 + 5, 3)
    do_stadium_segs(edge.p1 + 9, 3)
  end


  local function visit_edge(E)
    edge = E
    skin = assert(E.skin)

    -- tunnels are done elsewhere
    if skin.tunnel_mode then return end

    -- determine node range

    edge.n1 = edge.p1 * 4 - 3
    edge.n2 = edge.p2 * 4

    local first_seg = lookup_seg(edge.p1)

    if first_seg.start_in_use then edge.n1 = edge.n1 + 1 end
    if edge.is_feature        then edge.n2 = edge.n2 + 1 end

    -- switch to feature/edge specific functions

    apply_skin(edge.p1, edge.p2)

    if edge.name == "plains" then
      build_plains()

    elseif edge.name == "forest" then
      build_forest()

    elseif edge.name == "city_center" then
      build_city_center()

    elseif edge.name == "stadium" then
      build_stadium()

    elseif edge.name == "low_hills"  or
           edge.name == "high_hills" or
           edge.name == "embankment" or
           edge.name == "fence" or
           edge.name == "verge"
    then
      build_generic_hill()

    elseif edge.name == "drop_off" then
      build_drop_off()

    elseif edge.name == "beach" then
      build_beach()

    else
      error("BUG: unknown feature kind: " .. tostring(edge.name))
    end
  end


  ---| render_the_edges |---

  process_transitions(side)

  -- do features first
  for _,E in pairs(TRACK.edges[side]) do
    if E.is_feature then
      visit_edge(E)
    end
  end

  for _,E in pairs(TRACK.edges[side]) do
    if not E.is_feature then
      visit_edge(E)
    end
  end
end



------------------------------------------------------------------------


function add_road_signs()
  --
  -- Determines which road signs to use, and where to place them.
  --
  -- [ also does lamps, finish_banner (etc) ]
  --

  -- Note: the logic here supports signs for "mild" turns.  However
  --       they are disabled since I feel that the player does not
  --       really need them, and they look too similar to a "sharp"
  --       turn sign (which a player DOES need to see).

  local only_hazard
  local nothing_at_all

  local have_mild   = (lookup_obj("turn_mild")   ~= nil)
  local have_sharp  = (lookup_obj("turn_sharp")  ~= nil)
  local have_hazard = (lookup_obj("turn_hazard") ~= nil)

  local have_s_bend = (lookup_obj("s_bend_sign") ~= nil)
  local have_danger = (lookup_obj("danger_sign") ~= nil)
  local have_back   = (lookup_obj("back_of_sign") ~= nil)


  -- minimum distance between two signs
  local SIGN_DIST = 28


  local function check_available_signs()
    only_hazard = have_hazard and not (have_mild or have_sharp)
    nothing_at_all = not (have_mild or have_sharp or have_hazard)
  end


  local function check_used(n, side)
    local node = lookup_node(n)

    return node.signage[side]
  end


  local function mark_as_used(n1, n2, side)
    for n = n1, n2 do
      local node = lookup_node(n)

      if node then
        node.signage[side] = true
      end
    end
  end


  local function sign_for_category(cat)
    local obj_def

    if cat == 3 then
      obj_def = lookup_obj("turn_hazard")
    elseif cat == 2 then
      obj_def = lookup_obj("turn_sharp") or lookup_obj("turn_mild")
    elseif cat == 1 then
      obj_def = lookup_obj("turn_mild") or lookup_obj("turn_sharp")
    end

    if not obj_def then
      error("Sign selection logic is mucked up!")
    end

    return obj_def
  end


  local function add_isolated_sign(n, side, turn_dir, obj_def)
    assert(obj_def)

    local node = lookup_node(n)
    assert(node)

    local OBJ = r_make_object(obj_def, 9)

    -- mirror signs to point left  [ luckily all current signs point right ]
    -- this sub stuff is to handle object groups
    local sub_OBJ = OBJ
    if sub_OBJ.group then sub_OBJ = sub_OBJ.group[1] end
    if not sub_OBJ.flip then
      sub_OBJ.flip = sel(turn_dir == LF, 128, 0)
    end

    -- TODO : support 'skin_dx' in feature/edge skin
    local dx = TRACK.sign_dx or 0.4

    r_add_object(OBJ, node, 2, side,  -dx, 0, 0)

    mark_as_used(n - 4, n + 4, side)
  end


  local function add_hazard_group(n1, n2, side)
    local obj_def = sign_for_category(3)

    local sep = TRACK.hazard_sep or 1.5
    local dx  = TRACK.hazard_dx  or 0.4

    for n = n1, n2, sep do
      local node = lookup_node(int(n))
      if not node then break; end

      local dy = (n - int(n)) * TRACK.stepping

      local OBJ = r_make_object(obj_def, 9)

      r_add_object(OBJ, node, 2, side,  -dx, dy, 0)
    end

    mark_as_used(n1 - 4, n2 + 4, side)
  end


  local function detect_big_fall_at_node(n)
--[[ TODO
    local min_z = node1.z
    local max_z = node1.z

    for i = 1, DIST do
      local node2 = lookup_node(n + i)

      min_z = math.min(min_z, node2.z)
      max_z = math.min(max_z, node2.z)
    end

    if max_z <= node1.z + 0.1 then return false end

    return (max_z > node1.z) and (node1.z - min_z >= 1.35)
--]]
  end


  local function cat_at_node(n, side)
    local node = lookup_node(n)

    if not node then return 0 end

    return sel(side == LF, node.cat_L, node.cat_R)
  end


  local function find_all_road_turns(list, side)
    stderrf("Turns on %s:\n", side_str(side))

    for n = 1, TRACK.num_nodes do
      local prev = lookup_node(n - 1)
      local node = lookup_node(n)

      if not prev then goto continue end

      local p_cat = sel(side == LF, prev.cat_L, prev.cat_R)
      local n_cat = sel(side == LF, node.cat_L, node.cat_R)

      if p_cat ~= 0 then goto continue end
      if n_cat  < 1 then goto continue end

      -- start of turn here, find end and max category

      local len = 1
      local max_cat = n_cat

      while len < 160 do
        local cat = cat_at_node(n + len, side)
        
        if cat == 0 then break; end

        len = len + 1
        max_cat = math.max(max_cat, cat)
      end

      -- skip some bogus data
      if len < 2 then goto continue end

      -- OK --

      local TURN =
      {
        side = side,
        n1 = n,
        n2 = n + len - 1,
        len = len,
        max_cat = max_cat
      }

      table.insert(list, TURN)

      stderrf("  %d .. %d (len %d) (max_cat %d)\n", n, n+len-1, len, max_cat)

      ::continue::
    end
  end


  local function visit_road_turn(T)
    -- ignore "mild" turns for reasons mentioned above
    if T.max_cat < 2 then
      return
    end

    -- find hazard range (if any)
    local hazard_n1
    local hazard_n2

    for n = T.n1, T.n2 do
      if cat_at_node(n, T.side) >= 3 then
        hazard_n1 = hazard_n1 or n
        hazard_n2 = n
      end
    end


    -- hazard signs --

    -- TODO : if hazard in tunnel (etc) and normal not, still make normal

    if hazard_n1 and have_hazard then
      local offset = hazard_n1 - T.n1

      -- expand hazard range and start earlier
      hazard_n1 = hazard_n1 - 10
      hazard_n2 = hazard_n2

      add_hazard_group(hazard_n1, hazard_n2, 3 - T.side)

      -- if hazard signs are far from start, make normal sign too
      if offset < SIGN_DIST then return end
    end


    -- a normal sign --

    if only_hazard then return end

    local sign_n = T.n1

    if sign_n < 20 then return end

    add_isolated_sign(sign_n, RT, T.side, sign_for_category(2))


    if have_back and (T.n2 + 8 < TRACK.num_nodes) and not hazard_n1 then
      -- add the back of a sign after this turn (opposite side of road)
      add_isolated_sign(T.n2 + 2, LF, nil, lookup_obj("back_of_sign"))
    end
  end


  local function traverse_road()
    local turns = {}

    find_all_road_turns(turns, LF)
    find_all_road_turns(turns, RT)

    table.sort(turns, function(A,B) return A.n1 < B.n1 end)

    for _,turn in pairs(turns) do
      visit_road_turn(turn)
    end
  end


  local function speed_limits()
    -- TODO : more, perhaps associate these with CITY areas?

    local obj_def = lookup_obj("speed_limit") or
                    lookup_obj("EA_flag")

    if not obj_def then return end

    local node = lookup_node(28)


    for side = LF, RT do
      if node.signage[side] then
        goto continue
      end

      local OBJ = r_make_object(obj_def, 9)

      r_add_object(OBJ, node, 2, side,  -0.3, 0, 0.0)

      mark_as_used(node.index - 4, node.index + 4, side)

      ::continue::
    end
  end


  local function try_place_lamp(n, side, obj_def)
    -- check if here is a good place for a lamp
    local node = lookup_node(n)

    -- spot taken?
    if node.signage[side] then return end

    local feature = node.seg.feature

    if feature then
      -- this handles tunnels too
      if not feature.skin.allow_lamps then return end

    elseif TRACK.closed then
      -- on closed tracks, only put them inside features
      return
    end

    -- OK --

    local OBJ = r_make_object(obj_def, 6)

    r_add_object(OBJ, node, 2, side,  -0.2, 0, 0)
  end


  local function lamp_posts()
    local obj_def = lookup_obj("lamp")

    if not obj_def then return end

    local spacing = sel(TRACK.closed, 12, 30)

    local side = LF
    local start_n = rand.irange(1, spacing / 2)

    for n = start_n, TRACK.num_nodes, spacing do
      try_place_lamp(n, side, obj_def)

      side = 3 - side
    end
  end


  local function finish_banner()
    local n_index
    local node

    if TRACK.closed then
      -- allow to appear at end of track (when other objects do not)
      n_index = -5
      node = lookup_node(n_index)

    else  -- open track
      node = TRACK.finish_seg.first_node
      n_index = node.index
    end

    local obj_def = lookup_obj("finish_group")
    if not obj_def then return end

    local OBJ = r_make_object(obj_def, 9)

    r_add_object(OBJ, node, 0, LF,  0, 0, 0)

    mark_as_used(n_index - 4, n_index + 4, LF)
    mark_as_used(n_index - 4, n_index + 4, RT)
  end


  ---| add_road_signs |---

  check_available_signs()

  if not nothing_at_all then
    traverse_road()
  end

  -- TODO : danger_signs()    [ for big falls ]

  speed_limits()
  finish_banner()
  lamp_posts()
end



function add_floaters()
  --
  -- Add stuff that floats above the track, like balloons and blimps,
  -- as well as the giant arches.
  -- 
 
  local function eval_arch_spot(p)
    local seg = lookup_seg(p)

    -- never on features
    if seg.feature then return -1 end

    -- never at a drop-off
    if seg.edges[LF].name == "drop_off" then return -1 end
    if seg.edges[RT].name == "drop_off" then return -1 end

    -- too curvey?
    if seg.first_node.curvature > 3.0 then return -1 end

    -- too slopey?
    if math.abs(seg.first_node.dz) > 0.1 then return -1 end

    -- near a road sign?
    if seg.first_node.signage[LF] or
       seg.first_node.signage[RT]
    then return -1 end


    local score = 0

    -- FIXME : check distance to city / not near a tunnel

    -- FIXME : check scenery heights

    -- FIXME : check not clobbering any objects

    -- tie breaker
    return score + gui.random()
  end


  local function collect_arch_spots()
    local list = {}

    for p = 1, TRACK.num_segments do
      local score = eval_arch_spot(p)

      if score > 0 then
        table.insert(list, { p=p, score=score })
      end
    end

    table.sort(list, function(A, B) return A.score > B.score end)

    return list
  end


  local function remove_spots(list, p1, p2)
    for i = #list, 1, -1 do
      if p1 <= list[i].p and list[i].p <= p2 then
        table.remove(list, i)
      end
    end
  end


  local function add_an_arch(p)
    local def = lookup_obj("rocky_arch2") or
                lookup_obj("big_arch") or
                lookup_obj("traffic_sign_group") or
                lookup_obj("balloon_group")
    if not def then return end

    local seg = lookup_seg(p)
    local node = lookup_node(seg.index * 4 - 2)

    local OBJ = r_make_object(def, 8)

    r_add_object(OBJ, node, 0, LF,  0, 0, 0)
  end


  local function place_arches()
    local loc_list = collect_arch_spots()

    local kill_dist = 10  -- segments, either side

    for i = 1, 10 do
      local loc = table.remove(loc_list, 1)

      if not loc then break; end

      add_an_arch(loc.p)

      remove_spots(loc_list, loc.p - kill_dist, loc.p + kill_dist)
    end
  end

  
  ---| add_floaters |---

  place_arches()
end


------------------------------------------------------------------------


function create_scenery()
  TRACK.features = {}
  TRACK.edges = {}

  TRACK.used_features = {}

  assign_features()
  slope_the_track()

  assign_edges(LF)
  assign_edges(RT)

  render_the_road()
  render_tunnels()

  add_road_signs()

  render_the_edges(LF)
  render_the_edges(RT)

  add_floaters()
end

