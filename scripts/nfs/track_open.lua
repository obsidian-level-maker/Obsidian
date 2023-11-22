------------------------------------------------------------------------
--  INFO about OPEN TRACKS
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


TRACK_FILES.AL1 =
{
  name = "Alpine 1",
  kind = "open",

  track_file = "AL1.TRI",
  fam_file   = "AL1_001.FAM",

  features =
  {
    NONE = 100,

    low_hills = 100
  },

  textures =
  {
    nothing = 42,
    default = 20,

    road  = 3,
    road2 = 7,
    road3 = 6,
    road4 = 9,

    road_edge  = 4,
    road_edge2 = 5,

    dark_cement = 25,

    dark_brick  = 40,
    dark_brick2 = 22,
    dark_block  = 21,
    dark_grill  = 23,

    rocky1 = 12,  -- grass topped
    rocky2 = 15,  --

    grass1 = 18,
    grass2 = 19,
    grass3 = 20,

    grass_dark = 30,
    grass_transition = 34,  -- light to dark

    grass_w_cement_arch = 39,

    -- transparent tops
    forest1 = 35,
    forest2 = 38
  },

  objects =
  {
    turn_mild   = 0,
    turn_sharp  = 4,
    turn_hazard = { id=3, flip_RT=128 },

    speed_limit = 2,
    back_of_sign = 5,

    s_bend_sign = 1,
    merge_lanes = 8,
      new_lane  = 9,

    deer_sign = 18,

    short_fence = 7,
    long_fence  = 13,

    train1 = 19,
    train2 = 23,
    caboose = 22,

    tree1 = 10,
    tree2 = 11,
    tree3 = 32, -- rescales
    tree4 = 33,  --

    tall_tree = 12,

    deer = 17,
    cow  = 6,

    house1  = 15,
    house2  = 16,
    tractor = 14,

    finish_banner = 31,

    -- 3D Objects --

    tunnel_entrance = { id=34, kind="3d" },
  },

  groups =
  {
    finish_group =
    {
      { obj="tall_tree", dx=-1.4 },
      { obj="tall_tree", dx= 1.4 },
      { obj="finish_banner", dx=0.0, dz=0.15 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    --- Features ---

    -- TODO

    --- Edges ---

    low_hills =
    {
      edge_tex = { "grass1", "grass2", "grass3" }
    }
  },

  -- (this is not an real texture number)
  rail_def = 16,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, frames=4, xs=1.0000, ws=6.6927, ys=2.0000 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=4, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=5, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=6, xs=2.3333, ws=2.3333, ys=1.3333 },
    { img=7, xs=7.0000, ws=7.0000, ys=1.5000 },
    { img=8, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=9, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 10 to 19 --
    { img=10, xs=4.0000, ws=3.6667, ys=9.3333 },
    { img=11, xs=5.3333, ws=5.6667, ys=12.0000 },
    { img=12, xs=6.3333, ws=5.6667, ys=22.6667 },
    { img=13, xs=8.3333, ws=8.3333, ys=1.6667 },
    { img=14, xs=5.0000, ws=1.0000, ys=2.6667 },
    { img=15, xs=8.3333, ws=1.0000, ys=4.0000 },
    { img=16, xs=11.0000, ws=11.0000, ys=5.3333 },
    { img=17, xs=2.6667, ws=0.6927, ys=2.8333 },
    { img=18, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=19, frames=3, xs=10.6667, ws=0.7058, ys=3.3333 },

    -- 20 to 29 --
    { img=20, xs=10.6667, ws=1.0000, ys=3.3333 },
    { img=21, xs=10.6667, ws=1.0000, ys=3.3333 },
    { img=22, xs=13.3333, ws=1.0000, ys=3.3333 },
    { img=23, xs=11.3333, ws=1.0000, ys=3.3333 },
    { img=24, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=25, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=26, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=27, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=28, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=29, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 30 to 34 --
    { img=30, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=31, xs=14.0000, ws=1.0000, ys=10.0000 },
    { img=11, xs=10.0000, ws=1.0000, ys=24.0000 },
    { img=12, xs=7.0000, ws=1.0000, ys=26.6667 },

    { obj3d=0 }
  }
}



TRACK_FILES.AL2 =
{
  name = "Alpine 2",
  kind = "open",

  track_file = "AL2.TRI",
  fam_file   = "AL2_001.FAM",

  features =
  {
    NONE = 100,

    low_hills = 100
  },

  textures =
  {
    nothing = 33,
    default = 19,

    road = 3,

    road  = 3,
    road2 = 7,
    road3 = 6,
    road4 = 9,

    road_edge  = 4,

    bridge_road  = 12,
    bridge_road2 = 13,

    bridge_rail1 = 15,
    bridge_rail2 = 36,

    bridge_top1  = 16,
    bridge_top2  = 37,
    bridge_other = 17,  --??

    rocky1 = 18,
    rocky2 = 19,
    rocky3 = 20,  -- ends with grass

    water_a1 = 21,
    water_a2 = 22,
    water_a3 = 23,

    water_b1 = 24,
    water_b2 = 25,
    water_b3 = 26,

    forest_a1 = 42,
    forest_a2 = 43,
    forest_a3 = 44,  -- trans top

    forest_b1 = 46,
    forest_b2 = 43,
    forest_b3 = 48,  -- trans top

    chalk_a1 = 48,
    chalk_a2 = 49,
    chalk_a3 = 50,

    chalk_b1 = 52,
    chalk_b2 = 53,
    chalk_b3 = 51,

    chalk_c1 = 54,
    chalk_c2 = 55,
    chalk_c3 = 56,
  },

  objects =
  {
    turn_mild   = 0,
    turn_sharp  = 4,
    turn_hazard = { id=3, flip_RT=128 },

    speed_limit = 2,

    s_bend_sign = 1,
    merge_lanes = 5,
      new_lane  = 6,
    
    tree1 = 8,
    tree2 = 9,
    tree3 = 32,
    tree4 = 33,

    tall_tree = 10,

    finish_banner = 31,

    -- 3D Objects --

    bridge_entrance = { id=35, kind="3d" }
  },

  groups =
  {
    finish_group =
    {
      { obj="tall_tree", dx=-1.4 },
      { obj="tall_tree", dx= 1.4 },
      { obj="finish_banner", dx=0.0, dz=0.10 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    --- Features ---

    -- TODO

    --- Edges ---

    low_hills =
    {
      edge_tex = { "rocky1", "rocky2", "rocky3" }
    }
  },

  rail_def = 25,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=4, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=5, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=6, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=7, xs=0.0667, ws=1.0000, ys=0.8333 },
    { img=8, xs=2.0000, ws=1.0000, ys=4.0000 },
    { img=9, xs=3.3333, ws=1.0000, ys=8.0000 },

    -- 10 to 19 --
    { img=10, xs=5.0000, ws=1.0000, ys=20.0000 },
    { img=11, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=12, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=13, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=14, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=15, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=16, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=17, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=18, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=19, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 20 to 29 --
    { img=20, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=21, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=22, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=23, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=24, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=25, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=26, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=27, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=28, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=29, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 30 to 35 --
    { img=30, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=31, xs=14.0000, ws=1.0000, ys=10.0000 },
    { img=8,  xs=3.6667, ws=1.0000, ys=6.6667 },
    { img=9,  xs=8.3333, ws=1.0000, ys=22.6667 },
    { img=10, xs=8.3333, ws=1.0000, ys=26.6667 },

    { obj3d=0 }
  }
}



TRACK_FILES.AL3 =
{
  -- The snowy one --

  name = "Alpine 3",
  kind = "open",

  track_file = "AL3.TRI",
  fam_file   = "AL3_001.FAM",

  features =
  {
    NONE = 100,

    low_hills = 100
  },

  textures =
  {
    nothing = 21,
    default = 17,

    road = 3,
    road_edge = 4,

    tunnel_road1 = 6,
    tunnel_road2 = 7,

    tunnel_lit_road1 = 9,
    tunnel_lit_road2 = 10,
    
    tunnel_window = 35,
    tunnel_wall   = 30,
    tunnel_ceil   = 31,

    cave1 = 18,
    cave2 = 19,
    cave3 = 20,

    rocky1 = 15,
    rocky2 = 16,
    rocky3 = 17,

    cliff1 = 24,
    cliff2 = 25,
    cliff3 = 26,  -- trans top

    cliff4 = 28,
    cliff5 = 29,  -- trans top

    snow1 = 36,
    snow2 = 37,
    snow3 = 38,

    brick1 = 39,
    brick2 = 42,
  },

  objects =
  {
    turn_mild   = 0,
    turn_sharp  = 4,
    turn_hazard = { id=2, flip_RT=128 },

    speed_limit = 3,
    back_of_sign = 5,
    s_bend_sign = 1,

    tree1 = 6,
    tree2 = 7,
    tree3 = 32,  -- rescales
    tree4 = 33,  -- 

    tall_tree = 8,

    bull_sign = 12,

    raised_gate = { id=13, flip_LF=128 },

    finish_banner = 31,

    -- 3D Objects --

    tunnel_entrance = { id=35, kind="3d" }
  },

  groups =
  {
    finish_group =
    {
      { obj="tall_tree", dx=-1.4 },
      { obj="tall_tree", dx= 1.4 },
      { obj="finish_banner", dx=0.0, dz=0.15 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    --- Features ---

    -- TODO

    --- Edges ---

    low_hills =
    {
      edge_tex = { "snow1", "snow2", "snow3" }
    }
  },

  rail_def = 19,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=4, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=5, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=6, xs=3.6667, ws=1.0000, ys=10.0000 },
    { img=7, xs=4.3333, ws=1.0000, ys=12.0000 },
    { img=8, xs=7.0000, ws=1.0000, ys=24.0000 },
    { img=9, xs=4.3333, ws=1.0000, ys=12.0000 },

    -- 10 to 19 --
    { img=10, xs=4.3333, ws=1.0000, ys=12.0000 },
    { img=11, xs=0.0667, ws=1.0000, ys=1.0000 },
    { img=12, xs=8.3333, ws=1.0000, ys=4.0000 },
    { img=13, xs=1.6667, ws=1.0000, ys=6.6667 },
    { img=14, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=15, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=16, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=17, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=18, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=19, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 20 to 29 --
    { img=20, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=21, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=22, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=23, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=24, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=25, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=26, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=27, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=28, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=29, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 30 to 33 --
    { img=30, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=31, xs=14.0000, ws=1.0000, ys=10.0000 },
    { img=6,  xs=5.6667, ws=1.0000, ys=14.6667 },
    { img=7,  xs=10.0000, ws=1.0000, ys=24.0000 },

    { obj3d=0 }
  }
}


------------------------------------------------------------------------


TRACK_FILES.CL1 =
{
  name = "Coastline 1",
  kind = "open",

  track_file = "CL1.TRI",
  fam_file   = "CL1_001.FAM",

  features =
  {
    NONE = 100,

    beach = 2000,
    embankment = 200,
    low_hills = 100
  },

  textures =
  {
    nothing = 20,
    default = 24,

    road  = 3,
    road2 = 7,
    road3 = 6,
    road4 = 9,

    road_edge  = 4,
    road_edge3 = 10,  -- more grass
    road_edge2 = 8,   -- cement?

    rocky1 = 12,
    rocky2 = 13,
    rocky3 = 14, -- grassy

    stoney = 15,

    forest1 = 27,
    forest2 = 35,  -- trans top

    grass1 = 21,
    grass2 = 22,
    grass3 = 23,
    grass4 = 25,  -- orangey
    grass5 = 24,

    watery = 26,  -- begins orangey

    wire_fence = 19,

    mud   = 37,
    brick = 36
  },

  objects =
  {
    turn_mild   = 0,
    turn_sharp  = 4,
    turn_hazard = { id=3, flip_RT=128 },

    speed_limit = 2,
    back_of_sign = 11,

    s_bend_sign = 1,
    merge_lanes = 12,
      new_lane  = 16,

    lamp_w_pic = { id=10, flip_RT=128 },

    ad_sweltering = 9,

    boat = 6,
    umbrella = 7,
    stake = 5,

    shrub = 14,
    palm  = 15,
    tree  = 17,

    pole = 13,
    road_sign = 8,

    finish_pole = 35,
    finish_banner = 31,

    -- fake 3D Objects --

    building1 = { id=32, kind="fake" },
    building2 = { id=33, kind="fake" },
    building3 = { id=34, kind="fake" },
  },

  groups =
  {
    finish_group =
    {
      { obj="finish_pole", dx=-1.4 },
      { obj="finish_pole", dx= 1.4 },
      { obj="finish_banner", dx=0.0, dz=0.10 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    --- Features ---

    -- TODO

    --- Edges ---

    low_hills =
    {
      edge_tex = { "grass1", "forest1", "forest2" }
    },

    embankment =
    {
      edge_tex = { "rocky1", "rocky2", "rocky3" }
    },

    beach =
    {
      edge_tex = { "grass2", "grass3", "watery" }
    },
  },

  rail_def = 22,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=1, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=2, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=4, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=5, xs=1.0000, ws=0.0000, ys=5.3333 },
    { img=6, xs=9.6667, ws=0.0000, ys=3.3333 },
    { img=7, xs=2.3333, ws=0.0000, ys=2.0000 },
    { img=8, xs=3.0000, ws=0.0000, ys=1.6667 },
    { img=9, xs=6.6667, ws=0.0000, ys=3.3333 },

    -- 10 to 19 --
    { img=10, xs=4.6667, ws=0.0000, ys=6.6667 },
    { img=11, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=12, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=13, xs=0.1667, ws=0.0000, ys=6.0000 },
    { img=14, xs=2.3333, ws=0.0000, ys=2.6667 },
    { img=15, xs=3.0000, ws=0.0000, ys=10.6667 },
    { img=16, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=17, xs=8.3333, ws=0.0000, ys=6.6667 },
    { img=18, xs=0.1667, ws=0.0000, ys=2.0000 },
    { img=19, xs=2.0000, ws=0.0000, ys=4.3333 },

    -- 20 to 29 --
    { img=20, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=21, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=22, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=23, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=24, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=25, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=26, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=27, xs=1.0000, ws=0.0000, ys=2.0000 },
    { img=28, xs=1.3333, ws=0.0000, ys=6.0000 },
    { img=29, xs=1.3333, ws=0.0000, ys=6.0000 },

    -- 30 to 35 --
    { img=30, xs=1.3333, ws=0.0000, ys=6.0000 },
    { img=31, xs=14.0000, ws=1.0000, ys=10.0000 },

    { fake=25, alt=26, xs=16.3333, ws=16.0000, ys=26.6667 },
    { fake=27, alt=28, xs=16.3333, ws=16.0000, ys=21.3333 },
    { fake=29, alt=30, xs=33.6667, ws=30.0000, ys=25.3333 },
    { img=13, xs=0.2333, ws=0.0000, ys=12.0000 }
  }
}



TRACK_FILES.CL2 =
{
  name = "Coastline 2",
  kind = "open",

  track_file = "CL2.TRI",
  fam_file   = "CL2_001.FAM",

  features =
  {
    NONE = 100,

    low_hills = 100
  },

  textures =
  {
    nothing = 5,
    default = 28,

    road  = 3,
    road2 = 7,
    road3 = 6,
    road4 = 9,

    road_edge  = 4,
    road_edge2 = 10,  -- more grass
    road_edge3 = 8,   -- brown stones

    tunnel_road1 = 12,
    tunnel_road2 = 13,

    tunnel_window = 41,
    tunnel_wall   = 39,
    tunnel_ceil   = 40,

    lit_road1 = 45,
    lit_road2 = 46,

    cliff1 = 15,
    cliff2 = 16,
    cliff3 = 17,  -- orangey top

    bank1 = 18,
    bank2 = 19,
    bank3 = 20,

    forest1 = 24,
    forest2 = 25,
    forest3 = 26,

    grass1 = 27,
    grass2 = 28,
    grass3 = 29,

    grass4 = 30,
    grass5 = 31,
    grass6 = 32,

    hill1 = 33,
    hill2 = 38,  -- trans top

    mud   = 37,
    brick = 36
  },

  objects =
  {
    turn_mild   = 0,
    turn_sharp  = 4,
    turn_hazard = { id=3, flip_RT=128 },

    speed_limit = 2,
    back_of_sign = 7,

    s_bend_sign = 1,
    merge_lanes = 5,
      new_lane  = 6,

    tree1 = 10,
    tree2 = 15,  -- rescale
    shrub = 11,

    balloon1 = 12,
    balloon2 = 13,
    balloon3 = 14,

    finish_banner = 31,

    -- 3D Objects --

    tunnel_entrance = { id=32, kind="3d" }
  },

  groups =
  {
    finish_group =
    {
      { obj="tree1", dx=-1.4 },
      { obj="tree1", dx= 1.4 },
      { obj="finish_banner", dx=0.0, dz=0.15 }
    },

    balloon_group =
    {
      { obj="balloon1", dx= 1, dy=1,  node_ofs=1, dz=6.0 },
      { obj="balloon2", dx= 7, dy=9,  node_ofs=2, dz=4.0 },
      { obj="balloon3", dx=-7, dy=12, node_ofs=3, dz=14.0 },
      { obj="balloon3", dx= 3, dy=17, node_ofs=4, dz=9.0 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    --- Features ---

    -- TODO

    --- Edges ---

    low_hills =
    {
      edge_tex = { "bank1", "bank2", "bank3" }
    }
  },

  rail_def = 16,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=1.6667 },
    { img=4, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=5, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=6, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=7, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=8, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=9, xs=1.5000, ws=1.0000, ys=1.1667 },

    -- 10 to 19 --
    { img=10, xs=7.3333, ws=5.0000, ys=10.6667 },
    { img=11, xs=1.6667, ws=1.0000, ys=1.6667 },
    { img=12, xs=18.3333, ws=1.0000, ys=20.0000 },
    { img=13, xs=18.3333, ws=1.0000, ys=20.0000 },
    { img=14, xs=18.3333, ws=1.0000, ys=20.0000 },
    { img=10, xs=13.6667, ws=1.0000, ys=13.3333 },
    { img=16, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=17, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=18, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=19, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 20 to 29 --
    { img=20, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=21, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=22, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=23, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=24, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=25, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=26, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=27, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=28, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=29, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 30 to 32 --
    { img=30, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=31, xs=8.0000, ws=1.0000, ys=6.0000 },

    { obj3d=0 }
  }
}



TRACK_FILES.CL3 =
{
  name = "Coastline 3",
  kind = "open",

  track_file = "CL3.TRI",
  fam_file   = "CL3_001.FAM",

  features =
  {
    NONE = 100,

    beach = 1600,
    low_hills = 100
  },

  textures =
  {
    nothing = 27,
    default = 22,

    road = 3,
    road_worn = 6,

    road_edge = 4,
    road_edge2 = 7,  -- overgrown

    cliff1 = 9,
    cliff2 = 10,
    cliff3 = 11,  -- orangey top

    bank1 = 12,
    bank2 = 13,
    bank3 = 14,

    grass1 = 15,
    grass2 = 16,
    grass3 = 17,

    grass4 = 18,
    grass5 = 19,
    grass6 = 20,

    drop1 = 24,
    drop2 = 25,
    watery = 26,

    forest1 = 33,
    forest2 = 35,  -- trans top

    dark1 = 42,
    dark2 = 43,
    dark3 = 44,  -- trans top

    brick1 = 39,
    brick2 = 36  -- darker
  },

  objects =
  {
    turn_mild   = 0,
    turn_sharp  = 4,
    turn_hazard = { id=3, flip_RT=128 },

    speed_limit = 2,
    s_bend_sign = 1,
    back_of_sign = 5,

    finish_banner = 31,

    sunken_liberty = 30,

    shrub1 = 7,
    shrub2 = 9,
    shrub3 = 11,  -- rescale

    tree1 = 6,
    tree2 = 14,
    tree3 = 15,  -- rescale

    bare_trunk = 13, --??
    big_bush = 16,

    house1 = 22,
    house2 = 28,
    house3 = 29,
    house4 = 32,

    -- fake 3D Objects --

    wooden_house = { id=23, kind="fake" },

    -- Note: the other ones seem bogus

    -- 3D Objects --

    lighthouse = { id=33, kind="3d" }
  },

  groups =
  {
    finish_group =
    {
      { obj="tree2", dx=-1.4 },
      { obj="tree2", dx= 1.4 },
      { obj="finish_banner", dx=0.0, dz=0.15 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    --- Features ---

    -- TODO

    --- Edges ---

    low_hills =
    {
      edge_tex = { "dark1", "dark2", "dark3" }
    },

    beach =
    {
      edge_tex = { "drop1", "drop2", "watery" },

      railing = true
    }
  },

  rail_def = 13,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=4, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=5, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=6, xs=7.0000, ws=1.0000, ys=4.6667 },
    { img=7, xs=2.6667, ws=1.0000, ys=2.3333 },
    { img=8, xs=0.1000, ws=1.0000, ys=1.0000 },
    { img=9, xs=25.3333, ws=1.0000, ys=14.6667 },

    -- 10 to 19 --
    { img=10, xs=2.6667, ws=1.0000, ys=16.6667 },
    { img=9, xs=19.0000, ws=1.0000, ys=10.6667 },
    { img=10, xs=2.3333, ws=1.0000, ys=19.3333 },
    { img=10, xs=3.6667, ws=1.0000, ys=5.3333 },
    { img=14, xs=7.6667, ws=1.0000, ys=11.3333 },
    { img=14, xs=3.6667, ws=1.0000, ys=5.3333 },
    { img=16, xs=5.6667, ws=1.0000, ys=3.3333 },
    { img=16, xs=7.0000, ws=1.0000, ys=2.0000 },
    { img=18, xs=2.0000, ws=1.0000, ys=0.2333 },
    { img=19, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 20 to 29 --
    { img=20, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=21, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=22, xs=7.6667, ws=1.0000, ys=4.0000 },
    { fake=23, alt=24, xs=10.3333, ws=10.3333, ys=5.3333 },
    { img=24, xs=1.0000, ws=1.0000, ys=2.0000 },
    { fake=25, alt=26, xs=7.0000, ws=9.6667, ys=5.3333 },
    { fake=26, alt=27, xs=13.6667, ws=13.6667, ys=5.3333 },
    { fake=27, alt=28, xs=6.6667, ws=11.3333, ys=6.0000 },
    { img=28, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=29, xs=10.6667, ws=7.0000, ys=5.0000 },

    -- 30 to 32 --
    { img=30, xs=37.0000, ws=1.0000, ys=40.0000 },
    { img=31, xs=8.0000, ws=1.0000, ys=6.0000 },
    { img=26, xs=10.6667, ws=7.0000, ys=5.3333 },
    
    { obj3d=0 }
  }
}


------------------------------------------------------------------------


TRACK_FILES.CY1 =
{
  name = "City 1",
  kind = "open",

  track_file = "CY1.TRI",
  fam_file   = "CY1_001.FAM",

  features =
  {
    NONE = 200,

    low_tunnel = { 5000, 20 },

--??   plains = 100
--??  city_center = 65
--    cave = 45

    steep_climb = 2,  -- steep bits are very rare
    steep_fall  = 2,  --

    verge = 900,
    high_hills = 20
  },

  textures =
  {
    nothing = 21,
    default = 43,

    road = 3,
    road_edge = 4,

    road_dark = 5,
    road_edge_dark = 7,

    wire_fence = 14,

    painted_concrete = 48,
    painted_concrete_dark = 45,

    fence_w_green_grass  = 43,
    fence_w_yellow_grass = 25,

    brick_wall = 44,
    brick_wall_dark = 41,

    dark_ceil = 20,  --??

    tunnel_road  = 9,
    tunnel_road2 = 10,
    tunnel_wall  = 36,
    tunnel_ceil1 = 37,
    tunnel_ceil2 = 38,

    dented_concrete = 42,
  },

  objects =
  {
    turn_mild = 0,

    speed_limit = 2,

    sign_thru = 4,
    sign_2 = 5,
    sign_3 = 6,
    sign_4 = 8,
    sign_5 = 9,

    express_closed = 7,

    mesh_vert  = 12,
    mesh_horiz = 11,
    mesh_tall  = 37,

    lamp = { id=10, flip_RT=128 },

    pole = 18,

    finish_banner = 31,

    mall_1 = 20,
    mall_2 = 21,

    billboard1 = 22,
    billboard2 = 23,
    billboard3 = 26,

    hamburger = 24,

    bush1 = 14,
    bush2 = 15,
    bush3 = 16,
    tree  = 19,

    cars = 3,
    grating_kids = 27,
    cement_wall  = 13,

    -- fake 3D Objects --

    building1 = { id=32, kind="fake" },
    building2 = { id=33, kind="fake" },
    building3 = { id=34, kind="fake" },
    building4 = { id=35, kind="fake" },
    building5 = { id=36, kind="fake" },

    -- 3D Objects --

    overpass_entrance = { id=38, kind="3d", dx=-1.2 }
  },

  groups =
  {
    finish_group =
    {
      { obj="mesh_tall", dx=-1.4 },
      { obj="mesh_tall", dx= 1.4 },
      { obj="finish_banner", dx=0.0, dz=0.10 }
    },

    traffic_sign_group =
    {
      { obj="mesh_vert", dx=-1.4 },
      { obj="mesh_vert", dx= 1.4 },

      { obj="mesh_horiz", dx=-0.7, dz=0.97 },
      { obj="mesh_horiz", dx= 0.7, dz=0.97 },

      { obj="sign_thru", dz=0.85, dy=-0.1, node_ofs=-1 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    --- Features ---

    low_tunnel =
    {
      road_tex = { "tunnel_road2", "tunnel_road", "tunnel_road", "tunnel_road2" },
      edge_tex = { "tunnel_wall", "tunnel_ceil1", "tunnel_ceil2" },

      fence_tex = "brick_wall",

      entrance_obj = "overpass_entrance",

      normal_road_trans = true
    },

    plains =
    {
      edge_tex = { "fence_w_green_grass", "fence_w_green_grass", "fence_w_green_grass" },

      node_step = 7,

      decoration =
      {
        -- TODO

        { obj="NONE", prob=150, big=1 },
        { obj="NONE", prob=100 }
      }
    },

    --- Edges ---

    verge =
    {
      edge_tex = { "dented_concrete", "fence_w_green_grass", "wire_fence" }

      -- TODO : decoration
    },

    high_hills =
    {
      edge_tex = { "fence_w_yellow_grass", "fence_w_yellow_grass", "fence_w_yellow_grass" }

      -- TODO : decoration
    }
  },

  rail_def = 16,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=9.3333, ws=9.3333, ys=1.2000 },
    { img=4, xs=3.0000, ws=3.0000, ys=1.6667 },
    { img=5, xs=3.0000, ws=3.0000, ys=1.6667 },
    { img=6, xs=3.0000, ws=3.0000, ys=1.6667 },
    { img=7, xs=7.0000, ws=7.0000, ys=1.6667 },
    { img=8, xs=3.0000, ws=3.0000, ys=1.6667 },
    { img=9, xs=3.0000, ws=3.0000, ys=1.6667 },

    -- 10 to 19 --
    { img=10, xs=2.6667, ws=2.6667, ys=6.0000 },
    { img=11, xs=6.6660, ws=6.6660, ys=0.9000 },
    { img=12, xs=0.7500, ws=1.0000, ys=6.0000 },
    { img=13, xs=14.6667, ws=14.6667, ys=1.3333 },
    { img=14, xs=2.0000, ws=2.0000, ys=1.3333 },
    { img=15, xs=1.6667, ws=1.6667, ys=1.3333 },
    { img=16, xs=5.6667, ws=5.6667, ys=6.0000 },
    { img=17, xs=0.1667, ws=0.1667, ys=6.6667 },
    { img=18, xs=0.1667, ws=0.1667, ys=6.6667 },
    { img=19, xs=2.3333, ws=2.3333, ys=4.6667 },

    -- 20 to 29 --
    { img=20, xs=6.3333, ws=6.3333, ys=1.6667 },
    { img=21, xs=7.0000, ws=7.0000, ys=1.6667 },
    { img=22, xs=8.3333, ws=8.3333, ys=3.6667 },
    { img=23, xs=8.3333, ws=8.3333, ys=3.6667 },
    { img=24, xs=2.0000, ws=2.0000, ys=4.0000 },
    { img=25, xs=8.3333, ws=8.3333, ys=3.6667 },
    { img=26, xs=8.3333, ws=8.3333, ys=3.6667 },
    { img=27, xs=10.0000, ws=10.0000, ys=2.0000 },
    { img=28, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=29, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 30 to 38 --
    { img=30, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=31, xs=14.0000, ws=1.0000, ys=10.0000 },

    { fake=32, alt=33, xs=17.0000, ws=17.0000, ys=6.0000 },
    { fake=34, alt=35, xs=13.6667, ws=13.6667, ys=8.0000 },
    { fake=36, alt=37, xs=13.6667, ws=15.0000, ys=16.6667 },
    { fake=38, alt=39, xs=27.0000, ws=27.0000, ys=12.0000 },
    { fake=40, alt=41, xs=20.3333, ws=20.3333, ys=16.6667 },
    { img=12, xs=1.5000, ws=1.0000, ys=11.0000 },

    { obj3d=0 }
  }
}



TRACK_FILES.CY2 =
{
  name = "City 2",
  kind = "open",

  track_file = "CY2.TRI",
  fam_file   = "CY2_001.FAM",

  features =
  {
    NONE = 200,

    low_tunnel = { 5000, 20 },

    fence = 900,

    low_hills = 5
  },

  textures =
  {
    nothing = 33,
    default = 29,

    road = 3,

    road_edge = 4,
    road_edge_cont = 5,

    road_dark = 6,
    road_edge_dark = 7,

    middle_lane = 15,

    painted_concrete = 21,
    painted_concrete_dark = 18,

    dark_ceil = 25, --??

    tunnel_road  = 10,
    tunnel_road2 = 11,
    tunnel_wall  = 36,
    tunnel_light = 37,
    tunnel_ceil  = 26,

    fence_w_yellow_grass = 29,

    cement1 = 41,

    dented_concrete = 42,

    entrance1 = 49,
    entrance2 = 46,

    funky_wall = 36,
  },

  objects =
  {
    turn_mild  = 0,
    turn_sharp = 1,

    speed_limit = 2,

    merge_lanes = 3,
      new_lane  = 4,

    lamp = { id=7, flip_RT=128 },

    mesh_horiz = 8,

    finish_banner = 31,

    cement_wall = 9,

    smoke_stack = 11,
     drop_tower = 12,
    water_tower = 14,

    finish_pole = 19,

    -- fake 3D Objects --

    big_building  = { id=32, kind="fake" },
    dark_building = { id=33, kind="fake" },

    hotel = { id=34, kind="fake" },

    building1 = { id=36, kind="fake" },
    building2 = { id=37, kind="fake" },
    building3 = { id=38, kind="fake" },

    -- 3D Objects --

    tunnel_entrance = { id=39, kind="3d", dx=-1.7 },
  },

  groups =
  {
    finish_group =
    {
      { obj="finish_pole", dx=-1.4 },
      { obj="finish_pole", dx= 1.4 },
      { obj="finish_banner", dx=0.0, dz=0.10 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    --- Features ---

    low_tunnel =
    {
      road_tex = { "tunnel_road2", "tunnel_road", "tunnel_road", "tunnel_road2" },
      edge_tex = { "tunnel_wall", "tunnel_light", "tunnel_ceil" },

      fence_tex = "dented_concrete",

      entrance_obj = "tunnel_entrance",

      normal_road_trans = true
    },


    --- Edges ---

    fence =
    {
      edge_tex = { "dented_concrete", "nothing", "road_edge_cont" },

      fence_h = 1.1
    },

    low_hills =
    {
      edge_tex = { "fence_w_yellow_grass", "fence_w_yellow_grass", "fence_w_yellow_grass" }
    }
  },

  rail_def = 18,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=4, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=5, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=6, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=7, xs=2.6667, ws=2.6667, ys=6.0000 },
    { img=8, xs=16.0000, ws=14.6667, ys=1.6667 },
    { img=9, xs=15.6667, ws=15.6667, ys=1.6667 },

    -- 10 to 19 --
    { img=10, xs=2.3333, ws=2.3333, ys=16.6667 },
    { img=11, xs=7.0000, ws=7.0000, ys=8.0000 },
    { img=12, xs=2.3333, ws=2.3333, ys=16.6667 },
    { img=13, xs=1.0000, ws=1.0000, ys=1.0000 },
    { img=14, xs=7.0000, ws=7.0000, ys=13.3333 },
    { img=15, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=16, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=17, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=18, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=19, xs=0.2333, ws=1.0000, ys=12.0000 },

    -- 20 to 29 --
    { img=20, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=21, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=22, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=23, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=24, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=25, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=26, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=27, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=28, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=29, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 30 to 39 --
    { img=30, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=31, xs=14.0000, ws=1.0000, ys=10.0000 },
    
    { fake=17, alt=18, xs=23.6667, ws=23.6667, ys=20.0000 },
    { fake=19, alt=20, xs=10.3333, ws=10.3333, ys=8.6667 },
    { fake=21, alt=22, xs=13.6667, ws=17.0000, ys=20.0000 },
    { fake=23, alt=24, xs=13.6667, ws=13.6667, ys=6.6667 },
    { fake=25, alt=26, xs=13.6667, ws=13.6667, ys=6.6667 },
    { fake=27, alt=28, xs=13.6667, ws=13.6667, ys=6.6667 },
    { fake=29, alt=30, xs=13.6667, ws=13.6667, ys=6.6667 },

    { obj3d=0 }
  }
}



TRACK_FILES.CY3 =
{
  name = "City 3",
  kind = "open",

  track_file = "CY3.TRI",
  fam_file   = "CY3_001.FAM",

  features =
  {
    NONE = 100,

    low_hills = 100
  },

  textures =
  {
    nothing = 15,
    default = 14,

    road  = 3,
    road_edge = 1,

    road_blob = 6,
    road_blob_edge = 7,

    dark_asphalt = 8,

    painted_concrete = 12,
    painted_concrete_dark = 9,

    grass = 11,

    fence_w_green_grass  = 10,
    fence_w_yellow_grass = 27,

    concrete_wall = 28,
    concrete_wall_dark = 25,

    tunnel_roof = 22,
    tunnel_roof_w_light = 20,  -- has light, must repeat in middle
  },

  objects =
  {
    turn_mild   = 0,
    turn_sharp  = 1,
    turn_hazard = { id=3, flip_RT=128 },

    speed_limit = 2,

    mesh_vert  = 16,
    mesh_horiz = 8,
    mesh_tall  = 37,

    lamp = { id=7, flip_RT=128 },

    sign_thru = 10,
    sign_2    = 9,

    tree = 11,
    pine_tree = 14,

    billboard1 = 12,
    billboard2 = 13,

    hockey_sign = 17,

    express_closed = 15,

    finish_banner = 31,

    -- fake 3D Objects --

    dank_building = { id=32, kind="fake" },

    sky_scraper1 = { id=33, kind="fake" },
    sky_scraper2 = { id=34, kind="fake" },

    apartments1 = { id=35, kind="fake" },
    apartments2 = { id=36, kind="fake" },

    -- 3D Objects --

    hospital = { id=38, kind="3d" }
  },

  groups =
  {
    finish_group =
    {
      { obj="mesh_tall", dx=-1.4 },
      { obj="mesh_tall", dx= 1.4 },
      { obj="finish_banner", dx=0.0, dz=0.10 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    --- Features ---

    -- TODO

    --- Edges ---

    low_hills =
    {
      edge_tex = { "fence_w_green_grass", "fence_w_green_grass", "fence_w_green_grass" }
    }
  },

  rail_def = 1,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=4, xs=0.6667, ws=1.0000, ys=0.3333 },
    { img=5, xs=0.3333, ws=1.0000, ys=0.1667 },
    { img=5, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=7, xs=2.6667, ws=1.0000, ys=6.0000 },
    { img=8, xs=14.3333, ws=1.0000, ys=1.6667 },
    { img=9, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 10 to 19 --
    { img=10, xs=2.6667, ws=1.0000, ys=1.6667 },
    { img=11, xs=2.3333, ws=1.0000, ys=4.6667 },
    { img=12, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=13, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=14, xs=5.6667, ws=1.0000, ys=12.0000 },
    { img=15, xs=7.0000, ws=1.0000, ys=2.0000 },
    { img=16, xs=1.0000, ws=1.0000, ys=6.0000 },
    { img=17, xs=7.0000, ws=1.0000, ys=2.0000 },
    { img=18, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=19, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 20 to 29 --
    { img=20, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=21, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=22, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=23, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=24, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=25, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=26, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=27, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=28, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=29, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 30 to 38 --
    { img=30, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=31, xs=14.0000, ws=1.0000, ys=10.0000 },

    { fake=18, alt=19, xs=17.0000, ws=17.0000, ys=33.3333 },
    { fake=21, alt=20, xs=17.0000, ws=17.0000, ys=46.6667 },
    { fake=22, alt=23, xs=15.0000, ws=15.0000, ys=43.3333 },
    { fake=24, alt=25, xs=17.0000, ws=17.0000, ys=33.3333 },
    { fake=26, alt=27, xs=17.0000, ws=17.0000, ys=40.0000 },
    { img=16, xs=1.5000, ws=1.0000, ys=10.5000 },

    { obj3d=0 }
  }
}

