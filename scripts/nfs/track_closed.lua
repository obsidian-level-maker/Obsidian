------------------------------------------------------------------------
--  INFO about CLOSED TRACKS
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


TRACK_FILES.TR1 =
{
  name = "Rusty Springs",
  kind = "closed",

  track_file = "TR1.TRI",
  fam_file   = "TR1_001.FAM",

  features =
  {
    NONE = 30,

    plains = 100,
    city_center = 65,
    low_tunnel = 25,
    cave = 45,
    steep_climb = 15,
    steep_fall  = 15,

    high_hills = 100,
    drop_off = 7,
  },

  textures =
  {
    nothing = 1,
    default = 14,

    road = 3,
    road_dark = 39,

    road_edge = 10,
    road_edge_mid = 7,  -- darker
    road_edge_dark = 40,  -- even darker

    checkers = 42,

    hill_top = 26,

    sand1 = 14,
    sand2 = 15,
    sand3 = 16,
    sand4 = 17,
    sand5 = 18,
    sand6 = 19,
    sand7 = 20,

    med_sand1 = 12,
    med_sand2 = 13,
    med_sand3 = 21,
    med_sand5 = 22,
    med_sand6 = 24,
    med_sand7 = 25,

    dark_sand1 = 27,
    dark_sand2 = 28,
    dark_sand3 = 29,

    chunky1 = 46,
    chunky2 = 47,

    cement1 = 30,
    cement2 = 32,
    cement3 = 33,
    cement4 = 34,
    cement5 = 35,
    
    road_cement = 37,

    cement_w_border = 31
  },

  objects =
  {
    -- use same sprite for both sharp turns (a single sign) and hazards (multiple signs)
    turn_sharp  = { id=1 },
    turn_hazard = { id=1, flip_RT=128 },

    ad_fizzy = 2,
    ad_diner = 3,
    ad_wow   = 4,

    cactus1 = 8,
    cactus2 = 9,
    cactus3 = 10,  -- biggest

    rock1 = 14,
    rock2 = 19,

    gas_sign = 16,
    pole = 22,

    fence1 = 17,
    fence2 = 18,

    ruins1 = 25,
    house1 = 26,

    skull = 28,
    bowser = 31,
    old_tyre = 32,
    tree = 33,

    old_car1 = 34,
    old_car2 = 35,
    old_wheel = 38,

    spinning_blades = { id=39, node_ofs=-2 },

    hut_side = 37,

    -- fake 3D objects --

    building1  = { id=6,  kind="fake" },
    building2  = { id=29, kind="fake" },

    wooden_hut = { id=36, kind="fake" },
    fenced_pen = { id=18, kind="fake" },

    ruins2 = { id=20, kind="fake" },
    ruins3 = { id=23, kind="fake" },

    -- 3D Objects --

    water_tower = { id=48, kind="3d" },
     mill_tower = { id=49, kind="3d" },

    bleachers  = { id=50, kind="3d", flip_LF=192, flip_RT=64 },
    bleachers2 = { id=54, kind="3d" }, -- darker (in shadow)

    -- these two must use back side
    rocky_arch  = { id=51, kind="3d", flip=128 },
    rocky_arch2 = { id=52, kind="3d", flip=128, dx=2.8, dz=-0.2 },

    big_arch = { id=53, kind="3d", dx=-1.7 }
  },

  groups =
  {
    windmill =
    {
      { obj="mill_tower" },
      { obj="spinning_blades", dx=0.4, dy=-0.2, dz=4.5 }
    },

    fake_tunnel_facade =
    {
      { obj="hut_side", dx=-1.09, dy=0.75, dz=1.29, flip=128 },
      { obj="hut_side", dx= 1.09, dy=0.75, dz=1.29, flip=0   }
    },

    tree_pair =
    {
      { obj="tree", dx=-0.2, dy=0,   flip=128 },
      { obj="tree", dx= 1.4, dy=0.4, flip=0   }
    },

    bowser_pair =
    {
      { obj="bowser", dy=-0.3 },
      { obj="bowser", dy= 0.5 }
    },

    gas_on_pole =
    {
      { obj="pole" },
      { obj="gas_sign", dz= 1.1, node_ofs=-1, flip=64 }
    },

    wow_billboard =
    {
      { obj="pole", dx=-0.5, dy=-0.25 },
      { obj="pole", dx= 0.5, dy= 0.25 },
      { obj="ad_wow", dz= 0.4, flip=-24, node_ofs=-1 }
    },

    fizzy_billboard =
    {
      { obj="pole", dx=-0.5, dy= 0.25 },
      { obj="pole", dx= 0.5, dy=-0.25 },
      { obj="ad_fizzy", dz= 0.4, flip=24, node_ofs=-1 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    road_finish =
    {
      road_tex = { "checkers", "checkers", "checkers", "checkers" }
    },

    --- Features ---

    plains =
    {
      edge_tex = { "sand2", "sand3", "sand3" },

      node_step = 7,

      decoration =
      {
        { obj="NONE", prob=150, big=1 },
        { obj="NONE", prob=100 },

        { obj="cactus1",  prob=30 },
        { obj="cactus2",  prob=60 },
        { obj="cactus3",  prob=40, big=1 },
        { obj="old_wheel",  prob=20 },

        { obj="rock1",  prob=40, big=1 },
        { obj="rock2",  prob=20, big=1 },

        { obj="ruins1",  prob=20, big=1 },
        { obj="ruins2",  prob=20, big=1 },
        { obj="ruins3",  prob=20, big=1 },

        { obj="windmill",    prob=15, big=1, row="back" },
        { obj="water_tower", prob=10, big=1, row="back" },
        { obj="house1",      prob=20, big=1, row="back" },
      }
    },

    city_center =
    {
      road_tex = { "road_cement", "road", "road", "road_cement" },
      edge_tex = { "cement3", "cement4", "cement5" },

      railing = true,

      node_step = 5,

      decoration =
      {
        { obj="NONE", prob=50, big=1 },
        { obj="NONE", prob=50 },

        { obj="bleachers",  prob=60, big=1 },
        { obj="wooden_hut", prob=40, big=1 },

        { obj="building1",  prob=90, big=1 },
        { obj="building2",  prob=60, big=1 },
        { obj="fenced_pen", prob=30, big=1 },

        { obj=  "wow_billboard", prob=50, big=1, row="front", side="left" },
        { obj="fizzy_billboard", prob=90, big=1, row="front", side="right" },

        { obj="tree",      prob=110, row="front" },
        { obj="tree_pair", prob=110, big=1 },

        { obj="old_car1",    prob=20, row="front" },
        { obj="old_car2",    prob=20, row="front" },
        { obj="gas_on_pole", prob=30, row="front" },
        { obj="bowser_pair", prob=30, row="front" }

      }
    },

    low_tunnel =
    {
      road_tex = { "road_dark", "road_dark", "road_dark", "road_dark" },
      edge_tex = { "cement_w_border", "road_dark", "road_dark" },

      fence_tex = "med_sand5",

      entrance_obj = "fake_tunnel_facade",

      normal_road_trans = true
    },

    cave =
    {
      road_tex = { "road_edge_dark", "road_dark", "road_dark", "road_edge_dark" },
      edge_tex = { "dark_sand1", "dark_sand2", "dark_sand3" }
    },

    --- Edges ---

    drop_off =
    {
      edge_tex = { "sand5", "sand6", "sand7" }
    },

    high_hills =
    {
      edge_tex = { "med_sand6", "med_sand7", "med_sand7" }
    },

    __high_hills2 =
    {
      prob = 10,

      edge_tex = { "dark_sand1", "dark_sand2", "dark_sand3" }
    }
  },

  -- (this is not an real texture number)
  rail_def = 31,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, xs=1.6667, ws=1.0000, ys=2.6667 },
    { img=2, xs=12.6667, ws=1.0000, ys=8.0000 },
    { img=3, xs=6.6667, ws=1.0000, ys=4.6667 },
    { img=4, xs=12.0000, ws=1.0000, ys=6.6667 },
    { img=5, xs=1.0000, ws=1.0000, ys=2.0000 },
    { fake=6, alt=7, xs=6.6667, ws=4.6667, ys=4.3333 },
    { img=7, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=8, xs=1.3333, ws=1.0000, ys=4.0000 },
    { img=9, xs=1.3333, ws=1.0000, ys=3.3333 },

    -- 10 to 19 --
    { img=10, xs=3.3333, ws=1.0000, ys=9.3333 },
    { img=11, xs=2.0000, ws=1.0000, ys=2.0000 },
    { img=12, xs=2.0000, ws=1.0000, ys=2.0000 },
    { img=13, xs=6.6667, ws=1.0000, ys=6.6667 },
    { img=14, xs=5.3333, ws=1.0000, ys=2.0000 },
    { img=14, xs=16.0000, ws=1.0000, ys=6.7777 },
    { img=16, xs=2.0000, ws=1.0000, ys=1.0667 },
    { img=17, xs=4.0000, ws=1.0000, ys=1.6667 },
    { fake=17, alt=18, xs=4.0000, ws=4.0000, ys=1.6667 },
    { img=19, xs=16.0000, ws=1.0000, ys=7.5000 },

    -- 20 to 29 --
    { fake=20, alt=21, xs=7.3333, ws=6.0000, ys=5.0000 },
    { img=21, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=22, xs=0.2500, ws=1.0000, ys=6.6667 },
    { fake=23, alt=24, xs=8.0000, ws=7.0000, ys=3.6667 },
    { img=24, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=25, xs=2.6667, ws=1.0000, ys=4.6667 },
    { img=26, xs=10.0000, ws=1.0000, ys=4.6667 },
    { img=27, xs=6.6667, ws=1.0000, ys=4.6667 },
    { img=28, xs=1.3333, ws=1.0000, ys=2.0000 },
    { fake=30, alt=29, xs=5.3333, ws=6.6667, ys=5.3333 },

    -- 30 to 39 --
    { img=30, xs=1.3333, ws=1.0000, ys=1.1333 },
    { img=31, xs=0.6667, ws=1.0000, ys=2.0000 },
    { img=32, xs=1.0000, ws=1.0000, ys=0.6667 },
    { img=33, xs=4.0000, ws=1.0000, ys=6.6667 },
    { img=34, xs=3.3333, ws=1.0000, ys=1.3333 },
    { img=35, xs=3.3333, ws=1.0000, ys=1.6667 },
    { fake=36, alt=37, xs=3.3333, ws=4.0000, ys=3.3333 },
    { img=37, xs=12.1111, ws=1.0000, ys=6.3333 },
    { img=38, xs=1.3333, ws=1.0000, ys=1.3333 },
    { img=39, frames=4, speed=7, xs=9.6667, ys=9.6667 },

    -- 40 to 49 --
    { img=40, xs=6.6667, ws=1.0000, ys=6.6667 },
    { img=41, xs=6.6667, ws=1.0000, ys=6.6667 },
    { img=42, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=43, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=44, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=45, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=46, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=47, xs=1.0000, ws=1.0000, ys=2.0000 },

    { obj3d=0 },
    { obj3d=1 },

    -- 50 to 54 --
    { obj3d=2 },
    { obj3d=3 },
    { obj3d=4 },
    { obj3d=5 },
    { obj3d=6 }
  }
}



TRACK_FILES.TR2 =
{
  name = "Autumn Valley",
  kind = "closed",

  track_file = "TR2.TRI",
  fam_file   = "TR2_001.FAM",

  features =
  {
    NONE = 100,

    city_center = { 200, 5 },
    stadium = { 200, 100, 40 },

    plains = 40,
    low_tunnel = 50,
    high_tunnel = 20,
    cave = 30,
    steep_climb = 30,
    steep_fall  = 30,

    high_hills = 60,
    drop_off = 10,
  },

  textures =
  {
    nothing = 1,
    default = 31,

    road = 3,

    road_edge = 46,
    road_edge2 = 36,
    road_edge3 = 61,

    asphalt = 37,

    blue_curb = 7,
    checkers  = 42,

    stadium1 = 19,
    stadium2 = 20,

    building1 = 22,
    building2 = 23,
    building3 = 58,
    building4 = 59,

    tree_group1 = 26, -- partially transparent
    tree_group2 = 29,  --

    grass1 = 32,
    grass2 = 35,
    grass3 = 52,
    grass4 = 53,

    dirt_w_grass = 51,

    field1 = 30,
    field2 = 31,  -- grass on top
    field3 = 33,
    field4 = 34,  -- grass on top
  },

  objects =
  {
    -- 2D objects --

    lamp = 5,

    flag_pole  = 7,
    steel_mesh = 8,

    blue_arrow = { id=15 },

    bare_red_flag  = 24,
    bare_blue_flag = 27,
    bare_EA_flag   = 30,

    logo1 = 9,
    logo2 = 10,
    logo3 = 11,
    logo4 = 12,
    logo5 = 13,
    
    grocer_ad    = 14,
    newspaper_ad = 23,

    tent1 = 16,
    tent2 = 17,

    red_tree1 = 18,
    red_tree2 = 19,
    red_tree3 = 20,

    tall_pine  = 21,
    short_pine = 22,
    huge_tree  = 44,

    giant_blimp = 6,
    giant_tyre = 33,
    giant_mechanic = 34,

    stadium_left  = 35,
    stadium_right = 36,
    building_side = 37,

    pile_of_tyres  = 43,
    fountain_water = { id=38, node_ofs=-2 },

    -- fake 3D objects --

    building1 = { id=47, kind="fake", fake_size=1.0 },
    building2 = { id=48, kind="fake", fake_size=1.0 },

    excell    = { id=49, kind="fake", fake_size=1.0 },
    condo     = { id=50, kind="fake", fake_size=1.0 },

    -- 3D objects --

    tower    = { id=51, kind="3d", flip_RT=64 },
    big_arch = { id=52, kind="3d", dx=-1.7 },

    fountain_base = { id=53, kind="3d", rel_dx=-0.75, dy=-0.75,
                      flip_LF=192 }
  },

  groups =
  {
    turn_sharp =
    {
      { obj="blue_arrow", dz=1.0, node_ofs=-1 },
      { obj="steel_mesh", dx=0.32 }
    },

    fountain =
    {
      { obj="fountain_base" },
      { obj="fountain_water", dz=0.1 }
    },

    red_flag =
    {
      { obj="flag_pole" },
      { obj="bare_red_flag", dx=0.3, dz=1.0 }
    },

    blue_flag =
    {
      { obj="flag_pole" },
      { obj="bare_blue_flag", dx=0.3, dz=1.0 }
    },

    EA_flag =
    {
      { obj="flag_pole" },
      { obj="bare_EA_flag", dx=0.4, dz=0.75 }
    },

    news_billboard =
    {
      { obj="steel_mesh",   dx=-1.0 },
      { obj="steel_mesh",   dx=1.0 },
      { obj="newspaper_ad", dx=0.0, dz=0.35 }
    },

    fake_tunnel_entrance =
    {
      { obj="stadium_right", dx=-1.22, dy=0.75, dz=1.32 },
      { obj="stadium_left",  dx= 1.22, dy=0.75, dz=1.32 }
    },

    tall_pine_x2 =
    {
      { obj="tall_pine", dy=-0.2 },
      { obj="tall_pine", dy= 1.0 }
    },

    short_pine_x3 =
    {
      { obj="short", dy=-0.5 },
      { obj="short", dy= 0.0 },
      { obj="short", dy= 0.5 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_edge", "road", "road", "road_edge" }
    },

    road_finish =
    {
      road_tex = { "checkers", "checkers", "checkers", "checkers" }
    },

    --- Features ---

    plains =
    {
      edge_tex = { "dirt_w_grass", "grass4", "grass4" },

      node_step = 4,

      decoration =
      {
        { obj="NONE", prob=25, big=1 },
        { obj="NONE", prob=60 },

        { obj="huge_tree",  prob=40, big=1 },

        { obj="red_tree1",  prob=20 },
        { obj="red_tree2",  prob=20 },
        { obj="red_tree3",  prob=20 },

        { obj="grocer_ad",  prob=5, row="front" }
      }
    },

    city_center =
    {
      edge_tex = { "asphalt", "asphalt", "asphalt" },
      
      railing = true,

      node_step = 6,

      decoration =
      {
        { obj="NONE", prob=50, big=1 },
        { obj="NONE", prob=40 },

        { obj="building1", prob=60, big=1, row="back" },
        { obj="building2", prob=30, big=1, row="back" },
        { obj="condo",     prob=6,  big=1, row="back" },
        { obj="tower",     prob=6,  big=1, row="back" },

        { obj="excell",   prob=25, big=1 },
        { obj="tent1",    prob=20, big=1 },
        { obj="tent2",    prob=20, big=1 },

        { obj="fountain",       prob=30, big=1, row="front" },
        { obj="news_billboard", prob=5,  big=1, row="front" },

        { obj="tall_pine_x2",   prob=110, row="front" },
        { obj="pile_of_tyres",  prob=30,  row="front" }
--???   { obj="short_pine_x3",  prob=20,  row="front" }
      }
    },

    stadium =
    {
      edge_tex = { "asphalt", "asphalt", "asphalt" },

      seat_tex = "stadium1",

      railing = true,

      node_step = 3
    },

    low_tunnel =
    {
      road_tex = { "road_edge2", "road", "road", "road_edge2" },
      edge_tex = { "asphalt", "road_edge2", "asphalt" },

      fence_tex = "dirt_w_grass",

      entrance_obj = "fake_tunnel_entrance",

      normal_road_trans = true
    },

    high_tunnel =
    {
      road_tex = { "road_edge2", "road", "road", "road_edge2" },
      edge_tex = { "stadium2", "stadium2", "stadium2" },

      fence_tex = "dirt_w_grass",

      normal_road_trans = true
    },

    cave =
    {
      road_tex = { "road_edge2", "road", "road", "road_edge2" },
      edge_tex = { "field1", "field2", "field2" }
    },

    --- Edges ---

    drop_off =
    {
      edge_tex = { "dirt_w_grass", "grass3", "grass3" }
    },

    high_hills =
    {
      edge_tex = { "field3", "field4", "grass3" }

      -- TODO : decoration
    }
  },

  rail_def = 31,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=2, xs=4.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=4, xs=20.0000, ws=1.0000, ys=16.0000 },
    { img=5, xs=2.6667, ws=1.0000, ys=10.0000 },
    { img=6, xs=53.3333, ws=1.0000, ys=20.0000 },
    { img=7, xs=0.1667, ws=1.0000, ys=6.6667 },
    { img=8, xs=0.8000, ws=1.0000, ys=8.6667 },
    { img=9, xs=6.6667, ws=1.0000, ys=3.3333 },

    -- 10 to 19 --
    { img=10, xs=6.6667, ws=1.0000, ys=3.3333 },
    { img=11, xs=6.6667, ws=1.0000, ys=3.3333 },
    { img=12, xs=6.6667, ws=1.0000, ys=3.3333 },
    { img=13, xs=8.6667, ws=1.0000, ys=6.0000 },
    { img=14, xs=4.6667, ws=1.0000, ys=3.6667 },
    { img=15, xs=2.6667, ws=1.0000, ys=2.6667 },
    { img=16, xs=9.3333, ws=1.0000, ys=4.6667 },
    { img=17, xs=9.3333, ws=1.0000, ys=5.3333 },
    { img=18, xs=5.3333, ws=1.0000, ys=6.0000 },
    { img=19, xs=4.6667, ws=1.0000, ys=6.0000 },

    -- 20 to 29 --
    { img=20, xs=3.3333, ws=1.0000, ys=4.6667 },
    { img=21, xs=1.3333, ws=1.0000, ys=6.6667 },
    { img=22, xs=2.0000, ws=1.0000, ys=2.0000 },
    { img=23, xs=9.3333, ws=1.0000, ys=4.6666 },
    { img=24, frames=3, xs=3.3333, ws=0.6901, ys=1.3333 },
    { img=25, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=26, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=27, frames=3, xs=3.3333, ws=0.6901, ys=1.3333 },
    { img=28, xs=6.6667, ws=1.0000, ys=4.0000 },
    { img=29, xs=8.0000, ws=1.0000, ys=3.3333 },

    -- 30 to 39 --
    { img=30, frames=3, xs=4.0000, ws=0.6901, ys=2.6667 },
    { img=31, xs=2.0000, ws=1.0000, ys=3.3333 },
    { img=32, xs=2.0000, ws=1.0000, ys=4.6667 },
    { img=33, xs=26.6667, ws=1.0000, ys=33.3333 },
    { img=34, xs=30.0000, ws=1.0000, ys=30.0000 },
    { img=35, xs=12.3333, ws=1.0000, ys=7.0000 },
    { img=36, xs=12.3333, ws=0.6927, ys=7.0000 },
    { img=37, xs=16.6667, ws=0.6927, ys=10.6667 },
    { img=38, frames=4, xs=3.6667, ys=7.3333 },
    { img=39, frames=3, xs=4.6667, ys=1.3333 },

    -- 40 to 50 --
    { img=40, xs=4.6667, ws=1.0000, ys=1.3333 },
    { img=41, xs=4.6667, ws=1.0000, ys=1.3333 },
    { img=42, xs=16.6667, ws=1.0000, ys=13.3333 },
    { img=43, xs=5.0000, ws=1.0000, ys=3.0000 },
    { img=44, xs=16.0000, ws=1.0000, ys=16.0000 },
    { img=45, xs=4.0000, ws=1.0000, ys=3.3333 },
    { img=37, xs=20.0000, ws=1.0000, ys=12.0000 },

    { fake=37, alt=37, xs=13.3333, ws=13.3333, ys=23.3333 },
    { fake=37, alt=37, xs=13.3333, ws=13.3333, ys=15.3333 },
    { fake=1,  alt=2,  xs=13.3333, ws=13.3333, ys=8.0000 },
    { fake=3,  alt=4,  xs=13.3333, ws=13.3333, ys=23.3333 },

    -- 51 to 53 --

    { obj3d=0 },
    { obj3d=1 },
    { obj3d=2 }
  }
}



TRACK_FILES.TR3 =
{
  name = "Vertigo Ridge",
  kind = "closed",

  track_file = "TR3.TRI",
  fam_file   = "TR3_001.FAM",

  road_width = { 0.7, 1.5 },

  features =
  {
    NONE = 60,

    plains = 100,
    forest = 100,
    high_tunnel = 50,
    cave = 10,
    steep_climb = 40,
    steep_fall  = 20,

    high_hills = 100,
    drop_off = 140
  },

  textures =
  {
    nothing = 42,
    default = 30,

    road1 = 6,
    road2 = 3,
    road3 = 4,

    road1_tunnel = 36,
    road2_tunnel = 33,
    road3_tunnel = 34,

    road1_forest = 54,
    road2_forest = 51,
    road3_forest = 52,

    road_edge = 7,
    road_edge_dark = 55,

    grass1 = 9,
    grass2 = 10,
    grass_w_flowers = 57,
    
    murky_water = 11,  -- not sure

    moss_rock1 = 30,
    moss_rock2 = 27,
    moss_rock3 = 31,

    light_rock1 = 28,
    light_rock2 = 32,

    dark_rock1 = 37,
    dark_rock2 = 49,
    dark_rock3 = 53,

    dark_moss  = 48,

    wood1 = 16,
    wood2 = 17,
    wooden_window = 15,

    cement1 = 22,
    cement_lit = 21,
    cement_window = 19,

    trees = 25,
    dark_trees = 14
  },

  objects =
  {
    waterfall = 1,
    froth = 25,

    turn_mild   = 9,
    turn_sharp  = 8,
    turn_hazard = { id=40, flip_RT=128 },

    speed_limit = 37,
    danger_sign = 35,
    back_of_sign = 39,

    finish_banner = 24,
    banner_pole = 28,

    hidden_point_welcome = 11,
    hidden_point_pop = 32,
    wooden_bench = 10,

    tree1 = 20,
    tree2 = 21,
    tree3 = 22,

    tree_group = 19,
    tree_big_group = 36,
    tree_top = 23,

    lamp = 33,

    house1 = 14,
    farm_house = 18,
    fence = 15,

    boat1 = 7,
    boat2 = 17,
    boat3 = 29,

    grave_stone = 16,

    wooden_A_frame = 34,
    water_measure_pole = 38,

    -- fake 3D Objects --

    house2 = { id=13, kind="fake" },
    shack  = { id=5, kind="fake" },

    -- 3D Objects --

    big_house1 = { id=46, kind="3d", flip_LF=192 },
    big_house2 = { id=48, kind="3d", flip_LF=192 },

    wooden_entrance = { id=44, kind="3d" },
    tunnel_entrance = { id=45, kind="3d" },

    rusty_pier = { id=47, kind="3d" }
  },

  groups =
  {
    finish_group =
    {
      { obj="lamp", dx=-1.4 },
      { obj="lamp", dx= 1.4 },
      { obj="finish_banner", dx=0.0, dz=0.50 }
    }
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road3", "road2", "road1", "road_edge" }
    },

    --- Features ---

    plains =
    {
      edge_tex = { "grass1", "grass2", "murky_water" },

      node_step = 4,

      decoration =
      {
        { obj="NONE", prob=100, big=1 },
        { obj="NONE", prob=80 },

        { obj="big_house1", prob=4, big=1 },
        { obj="big_house2", prob=3, big=1 },

        { obj="house2", prob=20, big=1 },
        { obj="shack",  prob=14, big=1 },

        { obj="tree1", prob=40, big=1 },
        { obj="tree2", prob=40 },
        { obj="tree3", prob=40 }
      }
    },

    forest =
    {
      road_tex = { "road3_forest", "road2_forest", "road1_forest", "road_edge_dark" },
      edge_tex = { "dark_moss", "dark_moss", "dark_trees" },

      node_step = 4,

      decoration =
      {
        { obj="NONE", prob=10, big=1 },
        { obj="NONE", prob=10 },

        { obj="tree_group",     prob=150, big=1 },
        { obj="tree_big_group", prob=50,  big=1 },

        { obj="tree1", prob=90 },
        { obj="tree2", prob=30 },
        { obj="tree3", prob=30 },

        { obj="wooden_bench", prob=20, row="front" },
        { obj="hidden_point_welcome", prob=5, row="front" }
      }
    },

    high_tunnel =
    {
      road_tex = { "road3_tunnel", "road2_tunnel", "road1_tunnel", "dark_rock1" },
      edge_tex = { "wooden_window", "wood2", "wood2" },

      fence_tex = "moss_rock1",

      normal_road_trans = true
    },

    cave =
    {
      road_tex = { "road3_forest", "road2_forest", "road1_forest", "dark_rock1" },
      edge_tex = { "dark_rock2", "dark_rock2", "dark_rock2" }
    },

    --- Edges ---

    drop_off =
    {
      edge_tex = { "grass1", "moss_rock1", "light_rock1" },

      railing = true
    },

    high_hills =
    {
      edge_tex = { "moss_rock1", "moss_rock3", "light_rock2" }

      -- TODO : decoration
    }
  },

  rail_def = 31,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=1, frames=4, xs=6.6667, ws=0.6875, ys=46.6667 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=4, xs=1.0000, ws=1.0000, ys=2.0000 },
    { fake=5, alt=6, xs=12.0000, ws=13.3333, ys=8.0000 },
    { img=6, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=7, xs=16.6667, ws=1.0000, ys=8.0000 },
    { img=8, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=9, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 10 to 19 --
    { img=10, xs=4.0000, ws=1.0000, ys=0.6667 },
    { img=11, xs=5.3333, ws=1.0000, ys=2.6667 },
    { img=12, xs=16.6667, ws=1.0000, ys=11.3333 },
    { fake=13, alt=13, xs=8.0000, ws=6.0000, ys=6.6667 },
    { img=14, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=15, xs=6.6667, ws=1.0000, ys=1.8000 },
    { img=16, xs=2.0000, ws=1.0000, ys=3.0000 },
    { img=17, xs=6.6667, ws=1.0000, ys=4.0000 },
    { img=18, xs=20.0000, ws=1.0000, ys=12.6667 },
    { img=19, xs=12.0000, ws=1.0000, ys=5.3333 },

    -- 20 to 29 --
    { img=20, xs=16.0000, ws=1.0000, ys=11.3333 },
    { img=21, xs=7.3333, ws=1.0000, ys=8.0000 },
    { img=22, xs=4.0000, ws=1.0000, ys=6.6667 },
    { img=23, xs=16.0000, ws=1.0000, ys=9.3333 },
    { img=24, xs=14.0000, ws=1.0000, ys=2.0000 },
    { img=25, frames=3, xs=12.0000, ws=0.7136, ys=3.3333 },
    { img=26, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=27, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=28, xs=0.5000, ws=1.0000, ys=7.3333 },
    { img=29, xs=9.3333, ws=1.0000, ys=5.3333 },

    -- 30 to 39 --
    { img=30, xs=6.6667, ws=1.0000, ys=6.6667 },
    { img=31, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=32, xs=4.6667, ws=1.0000, ys=2.6667 },
    { img=33, xs=0.6667, ws=1.0000, ys=5.3333 },
    { img=34, xs=10.0000, ws=1.0000, ys=3.3333 },
    { img=35, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=36, xs=10.0000, ws=1.0000, ys=12.0000 },
    { img=37, xs=1.0000, ws=1.0000, ys=2.3333 },
    { img=38, xs=0.5000, ws=1.0000, ys=12.0000 },
    { img=39, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 40 to 48 --
    { img=40, xs=1.0000, ws=1.0000, ys=1.3333 },
    { img=36, xs=10.6667, ws=1.0000, ys=15.3333 },
    { img=28, xs=0.2000, ws=1.0000, ys=3.3333 },
    { img=20, xs=18.6667, ws=1.0000, ys=13.3333 },

    { obj3d=0 },
    { obj3d=1 },
    { obj3d=2 },
    { obj3d=3 },
    { obj3d=4 }
  }
}



TRACK_FILES.TR4 =
{
  name = "Lost Vegas",
  kind = "closed",

  track_file = "TR4.TRI",
  fam_file   = "TR4_001.FAM",

  features =
  {
    NONE = 100,

    low_hills = 100
  },

  textures =
  {
    nothing = 5,
    default = 6,

    road = 6,
    road2 = 7,

    road_orange = 9,
    road_orange2 = 10,

    dark1 = 12,
    dark2 = 13,
    dark_lit1 = 15,
    dark_lit2 = 15,

    orange_wall = 18,
    orange_roof = 28,
    orange_double_lit = 20,
    orange_double_dim = 29,

    casino = 19,

    houses1 = 22,
    houses2 = 23,  -- trans top
    houses3 = 26,  -- trans top

    dark_hill1 = 31,
    dark_hill2 = 32,  -- trans top

    lit_rail = 51,  --??
    lit_cement = 43,

    wire_fence1 = 53,
    wire_fence2 = 41,

    lamp_post = 44,
    cement_circle = 47,
    purple_lit_tower = 38
  },

  objects =
  {
    turn_hazard = { id=26, flip=64 },

    danger_sign = 0,
    orange_sign = 28,

    lamp = 19,
    pine = 5,
    tree = 8,

    burning_barrel = 29,

    --FIXME: temporary
    speed_limit = 19,
  
    buildings = 42,
    tower2    = 43,

    neon_woman = 1,
    neon_cash  = 20,
    neon_hotel = 47,

    flashing_wheel = 12,
    flashing_arch  = 17,

    glow_line1 = 23,
    glow_line2 = 44,

    lights1 = 11,  --??
    lights2 = 34,
    lights3 = 35,

    -- fake 3D objects --

    shop1 = { id=37, kind="fake" },
    shop2 = { id=38, kind="fake" },
    shop3 = { id=39, kind="fake" },

    hotel = { id=40, kind="fake" },

    -- 3D Objects --

    tower       = { id=48, kind="3d" },
    sky_scraper = { id=51, kind="3d" },

    garage_entrance = { id=49, kind="3d" },
    golden_entrance = { id=50, kind="3d" }
  },

  groups =
  {
  },

  hazard_sep = 7.0,

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road2", "road", "road", "road2" }
    },

    --- Features ---

    -- TODO

    --- Edges ---

    low_hills =
    {
      edge_tex = { "dark_hill1", "dark_hill1", "dark_hill2" }
    }
  },

  rail_def = 25,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=10.0000, ws=1.0000, ys=5.3333 },
    { img=1, frames=4, xs=13.3333, ws=0.7058, ys=18.6667 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=5, xs=1.0000, ws=1.0000, ys=4.6667 },
    { img=6, frames=2, xs=0.6667, ws=0.6719, ys=0.6667 },
    { img=7, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=8, xs=16.6667, ws=0.6771, ys=20.6667 },
    { img=9, frames=2, xs=0.6667, ws=0.6745, ys=0.6667 },

    -- 10 to 19 --
    { img=10, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=11, xs=13.3333, ws=1.0000, ys=46.6667 },
    { img=12, frames=5, xs=13.3333, ws=0.6771, ys=13.3333 },
    { img=13, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=14, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=15, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=16, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=17, frames=2, xs=16.6667, ws=0.6927, ys=10.6667 },
    { img=18, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=19, xs=2.0000, ws=1.0000, ys=11.3333 },

    -- 20 to 29 --
    { img=20, frames=3, xs=4.0000, ws=0.6719, ys=8.0000 },
    { img=21, frames=2, xs=4.0000, ws=0.6849, ys=5.3333 },
    { img=22, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=23, frames=3, xs=20.0000, ws=0.7032, ys=1.3333 },
    { img=24, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=25, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=26, frames=2, speed=20, xs=3.3333, ws=0.6927, ys=2.0000 },
    { img=27, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=28, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=29, frames=5, xs=1.0000, ws=0.7084, ys=2.0000 },

    -- 30 to 39 --
    { img=30, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=31, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=32, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=33, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=34, xs=22.6667, ws=1.0000, ys=26.6667 },
    { img=35, xs=33.3333, ws=1.0000, ys=46.6667 },
    { img=36, xs=1.0000, ws=1.0000, ys=2.0000 },
    { fake=37, alt=36, xs=5.3333, ws=5.3333, ys=6.0000 },
    { fake=38, alt=36, xs=6.0000, ws=4.6667, ys=6.6667 },
    { fake=39, alt=36, xs=4.6667, ws=5.3333, ys=6.0000 },

    -- 40 to 49 --
    { fake=40, alt=41, xs=33.3333, ws=33.3333, ys=16.6667 },
    { img=41, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=42, xs=33.3333, ws=1.0000, ys=6.6667 },
    { img=43, xs=26.6667, ws=1.0000, ys=46.6667 },
    { img=44, frames=3, xs=20.0000, ws=1.3698, ys=1.3333 },
    { img=45, xs=2.6667, ws=1.0000, ys=3.3333 },
    { img=46, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=47, xs=8.0000, ws=1.0000, ys=12.0000 },

    { obj3d=0 },
    { obj3d=1 },

    -- 50 to 54 --
    { obj3d=2 },
    { obj3d=3 }
  }
}



TRACK_FILES.TR5 =
{
  name = "Oasis Springs",
  kind = "closed",

  track_file = "TR5.TRI",
  fam_file   = "TR5_001.FAM",

  super_cool_stuff = 1,

  features =
  {
    NONE = 100,

    steep_climb = 20,
    steep_fall  = 30,

    low_hills = 100
  },

  textures =
  {
    nothing = 41,
    default = 32,

    road = 3,
    road_dark = 39,
    road_w_gravel = 37,

    road2 = 10,
    road2_dark = 40,

    gravel = 42,

    medium1 = 12,
    medium2 = 13,
    medium3 = 21,  -- rocky
    medium4 = 22,  --
    
    light1 = 14,
    light_w_trans = 23,

    dark1 = 27,  -- rocky
    dark2 = 28,  --
    dark3 = 29,  --

    chunky1 = 46,
    chunky2 = 47
  },

  objects =
  {
    -- not many objects here, no signs at all

    camel = 0,
    tent = 8,
    face_rock = 1,

    shrub = 4,
    palm = 5,
    tree = 9,

    -- fake 3D objects --

    ruins2 = { id=2, kind="fake" },
    ruins3 = { id=6, kind="fake" },

    -- 3D Objects --

    pyramid = { id=48, kind="3d" },

    rocky_arch  = { id=51, kind="3d", flip=128 },
    rocky_arch2 = { id=52, kind="3d", flip=128, dx=2.6, dz=-0.2 }
  },

  groups =
  {
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_w_gravel", "road", "road", "road_w_gravel" }
    },

    road_finish =
    {
      road_tex = { "gravel", "gravel", "gravel", "gravel" }
    },

    --- Features ---

    -- TODO

    --- Edges ---

    low_hills =
    {
      edge_tex = { "medium1", "medium1", "medium2" }
    }
  },

  rail_def = 31,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, xs=2.6667, ws=1.0000, ys=1.8333 },
    { img=1, xs=20.0000, ws=1.0000, ys=12.0000 },
    { fake=2, alt=3, xs=5.3333, ws=4.6667, ys=3.3333 },
    { img=3, xs=6.6667, ws=1.0000, ys=4.6667 },
    { img=4, xs=2.0000, ws=1.0000, ys=2.6667 },
    { img=5, xs=4.6667, ws=8.0000, ys=11.3333 },
    { fake=6, alt=7, xs=4.6667, ws=3.3333, ys=2.0000 },
    { img=7, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=8, xs=6.6667, ws=1.0000, ys=4.0000 },
    { img=9, xs=2.0000, ws=1.0000, ys=4.6667 },

    -- 10 to 19 --
    { img=10, xs=1.6667, ws=1.0000, ys=4.6667 },
    { img=11, xs=2.0000, ws=1.0000, ys=2.0000 },
    { img=12, frames=2, xs=6.6667, ws=0.7057, ys=6.6667 },
    { img=13, xs=6.6667, ws=1.0000, ys=6.6667 },
    { img=14, xs=5.3333, ws=1.0000, ys=2.0000 },
    { img=14, xs=20.0000, ws=1.0000, ys=4.6667 },
    { img=16, xs=2.0000, ws=1.0000, ys=1.0667 },
    { img=17, xs=4.0000, ws=1.0000, ys=1.6667 },
    { fake=17, alt=18, xs=4.0000, ws=4.0000, ys=1.6667 },
    { img=19, xs=20.0000, ws=1.0000, ys=10.0000 },

    -- 20 to 29 --
    { fake=20, alt=21, xs=5.3333, ws=4.0000, ys=3.3333 },
    { img=21, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=22, xs=0.1667, ws=1.0000, ys=6.6667 },
    { fake=23, alt=24, xs=6.0000, ws=4.6667, ys=2.6667 },
    { img=24, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=25, xs=2.6667, ws=1.0000, ys=4.6667 },
    { img=26, xs=10.0000, ws=1.0000, ys=4.6667 },
    { img=27, xs=6.6667, ws=1.0000, ys=4.6667 },
    { img=28, xs=1.3333, ws=1.0000, ys=2.0000 },
    { fake=30, alt=29, xs=5.3333, ws=6.6667, ys=4.0000 },

    -- 30 to 39 --
    { img=30, xs=1.3333, ws=1.0000, ys=1.1333 },
    { img=31, xs=0.6667, ws=1.0000, ys=2.0000 },
    { img=32, xs=1.0000, ws=1.0000, ys=0.6667 },
    { img=33, xs=4.0000, ws=1.0000, ys=6.6667 },
    { img=34, xs=3.3333, ws=1.0000, ys=1.3333 },
    { img=35, xs=3.3333, ws=1.0000, ys=1.6667 },
    { fake=36, alt=37, xs=2.6667, ws=3.3333, ys=2.6667 },
    { img=37, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=38, xs=1.3333, ws=1.0000, ys=1.3333 },
    { img=39, frames=4, xs=6.6667, ws=0.6849, ys=6.6667 },

    -- 40 to 49 --
    { img=40, xs=6.6667, ws=1.0000, ys=6.6667 },
    { img=41, xs=6.6667, ws=1.0000, ys=6.6667 },
    { img=42, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=43, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=44, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=45, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=46, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=47, xs=1.0000, ws=1.0000, ys=2.0000 },

    { obj3d=0 },
    { obj3d=1 },

    -- 50 to 52 --
    { obj3d=2 },
    { obj3d=3 },
    { obj3d=4 }
  }
}



TRACK_FILES.TR6 =
{
  name = "Burnt Sienna",
  kind = "closed",

  -- this track only exists in the Special Edition
  is_new = true,

  track_file = "TR6.TRI",
  fam_file   = "TR6_001.FAM",

  features =
  {
    NONE = 100,

--    plains = 100
    low_tunnel = 25,
--    cave = 45
    steep_climb = 10,
    steep_fall  = 25,

    low_hills = 100,
    drop_off = 7
  },

  textures =
  {
    nothing = 37,
    default = 19,

    road = 3,
    road_w_sand = 4,
    road_w_wood = 7,

    bridge_middle = 12,
    bridge_edge   = 13,

    road_dark = 9,
    road_dark_edge = 10,
    cave_wall = 21,

    tunnel_road1 = 30,
    tunnel_road2 = 31,
    tunnel_wall  = 29,
    tunnel_light = 28,
    tunnel_ceil  = 27,

    sand1 = 24,
    sand2 = 25,  -- continues 24
    sand3 = 26,  -- very light

    sand4 = 33,
    sand5 = 34,  -- dark, continues 33

    light_to_dark = 16,
    gray_to_dark  = 15,
    gray_to_medium = 18,  -- a lighter 15

    medium = 19,

    -- transparent tops
    cliff_dark  = 17,  -- continues 16
    cliff_light = 20  -- continues 19
  },

  objects =
  {
    turn_mild   = 17,
    turn_sharp  = 18,
    turn_hazard = { id=20, flip_RT=128 },

    speed_limit  = 22,
    speed_limit2 = 23,  -- has graffiti

    danger_sign = 19,
    caution_sign = 24,
    avalanche_sign = 21,
    wolf_sign = 25,

    stalactite2 = 2,
    stalactite3 = 3,
    stalactite4 = 45,  -- or is it wood?

    stalagmite1 = 4,
    stalagmite2 = 5,
    stalagmite3 = 7,
    stalagmite4 = 30,
    stalagmite5 = 46,

    stal_both1 = 6,
    stal_both2 = 8,

    waterfall = 13,

    cactus = 37,
    shrub  = 36,
    tree1  = 35,
    tree2  = 33,

    fence  = 34,

    barrel = 38,
    tnt_drum = 29,
    wagon  = 39,
    statue = 40,

    wooden_beam  = 31,
    wooden_post  = 32,
    wooden_ruins = 44,

    okcorral_banner = 26,
    deadwood_banner = 27,

    finish_banner = 28,

    -- fake 3D Objects --

    stalactite1 = { id=0, kind="fake" },

    building1 = { id=9,  kind="fake" },
    building2 = { id=10, kind="fake" },
    building3 = { id=11, kind="fake" },

    wooden_shack2 = { id=41, kind="fake" },

    -- 3D Objects --

    wooden_shack  = { id=48, kind="3d" },
    deadwood_mine = { id=49, kind="3d" },
    huge_facade   = { id=50, kind="3d" },

    wooden_supports = { id=51, kind="3d" }  -- for the wooden bridge
  },

  groups =
  {
  },

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road_w_wood", "road", "road", "road_w_wood" }
    },

    --- Features ---

    low_tunnel =
    {
      road_tex = { "tunnel_road2", "tunnel_road1", "tunnel_road1", "tunnel_road2" },
      edge_tex = { "tunnel_wall", "tunnel_light", "tunnel_ceil" },

      fence_tex = "medium",

      normal_road_trans = true
    },

    -- FOR CAVE :
    --entrance_obj = "huge_facade"

    --- Edges ---

    drop_off =
    {
      edge_tex = { "sand1", "sand2", "sand3" }
    },

    low_hills =
    {
      edge_tex = { "sand4", "sand5", "sand5" }
    }
  },

  rail_def = 7,

  scale_defs =
  {
    -- 0 to 9 --
    { fake=0, alt=1, xs=9.3333, ws=6.6667, ys=6.0000 },
    { img=1, xs=6.6667, ws=1.0000, ys=8.0000 },
    { img=2, xs=2.6667, ws=1.0000, ys=8.0000 },
    { img=3, xs=1.3333, ws=1.0000, ys=10.6667 },
    { img=4, xs=6.0000, ws=1.0000, ys=7.3333 },
    { img=5, xs=1.6667, ws=1.0000, ys=12.0000 },
    { img=6, xs=6.6667, ws=1.0000, ys=16.0000 },
    { img=7, xs=2.0000, ws=1.0000, ys=12.6667 },
    { img=8, xs=9.3333, ws=1.0000, ys=8.0000 },
    { fake=9, alt=43, xs=6.0000, ws=4.6667, ys=5.3333 },

    -- 10 to 19 --
    { fake=10, alt=12, xs=6.6667, ws=5.3333, ys=6.0000 },
    { fake=11, alt=12, xs=6.6667, ws=6.6667, ys=5.3333 },
    { img=12, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=13, frames=4, xs=2.0000, ws=0.6771, ys=36.6667 },
    { img=14, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=15, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=16, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=17, xs=0.8000, ws=1.0000, ys=1.4667 },
    { img=18, xs=0.8000, ws=1.0000, ys=1.4667 },
    { img=19, xs=0.4667, ws=1.0000, ys=0.8000 },

    -- 20 to 29 --
    { img=20, xs=1.0000, ws=1.0000, ys=1.3333 },
    { img=21, xs=0.8000, ws=1.0000, ys=1.4667 },
    { img=22, xs=0.6667, ws=1.0000, ys=1.6667 },
    { img=23, xs=0.6667, ws=1.0000, ys=1.6667 },
    { img=24, xs=8.0000, ws=1.0000, ys=4.6667 },
    { img=25, xs=0.8000, ws=1.0000, ys=1.4667 },
    { img=26, xs=5.3333, ws=1.0000, ys=3.0000 },
    { img=27, xs=10.0000, ws=1.0000, ys=2.0000 },
    { img=28, xs=13.3333, ws=1.0000, ys=2.3333 },
    { img=29, xs=0.8000, ws=1.0000, ys=1.2667 },

    -- 30 to 39 --
    { img=30, xs=1.3333, ws=1.0000, ys=10.6667 },
    { img=31, xs=14.6667, ws=1.0000, ys=0.6667 },
    { img=32, xs=0.4667, ws=1.0000, ys=8.6667 },
    { img=33, xs=2.0000, ws=1.0000, ys=4.6667 },
    { img=34, xs=4.0000, ws=1.0000, ys=1.0000 },
    { img=35, xs=5.3333, ws=1.0000, ys=6.6667 },
    { img=36, xs=0.6667, ws=1.0000, ys=1.3333 },
    { img=37, xs=1.3333, ws=1.0000, ys=3.3333 },
    { img=38, xs=0.6667, ws=1.0000, ys=1.3333 },
    { img=39, xs=4.6667, ws=1.0000, ys=2.0000 },

    -- 40 to 49 --
    { img=40, xs=0.6667, ws=1.0000, ys=2.0000 },
    { fake=41, alt=42, xs=4.0000, ws=3.3333, ys=3.3333 },
    { img=42, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=43, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=44, xs=3.0000, ws=1.0000, ys=1.6667 },
    { img=45, xs=1.0000, ws=1.0000, ys=8.0000 },
    { img=46, xs=1.3333, ws=1.0000, ys=12.0000 },
    { img=47, xs=1.0000, ws=1.0000, ys=2.0000 },

    { obj3d=0 },
    { obj3d=1 },

    -- 50 to 54 --
    { obj3d=2 },
    { obj3d=3 }
  }
}



TRACK_FILES.TR7 =
{
  name = "Transtropolis",
  kind = "closed",

  -- this track only exists in the Special Edition
  is_new = true,

  track_file = "TR7.TRI",
  fam_file   = "TR7_001.FAM",

  features =
  {
    NONE = 100,

    steep_climb = 10,
    steep_fall  = 25,

    low_hills = 100
  },

  textures =
  {
    nothing = 41,
    default = 16,

    road  = 3,
    road2 = 4,

    road_dark = 6,
    road_blobby = 7,
    road_orange_bar = 10,

    dark1 = 12,  --??
    dark2 = 13,
    dark3 = 14,
    dark4 = 11,

    dark_warning = 9,

    rusty_metal = 15,
    concrete_bricks = 16,
    herringbone = 27,

    tunnel_window = 22,

    grass1 = 24,
    grass2 = 25,

    cement1 = 33,
    cement2 = 36,
    cement3 = 37,

    grass_with_blob = 28,  --??
    
    bridge_floor = 30,
    bridge_floor2 = 31,  -- bit darker
    bridge_side = 34,
    bridge_top  = 35,

    -- these have transparency at top
    wire_fence = 29,
    shipping_containers = 20,
    sky_scrapers = 26,
    glass_building = 22,
    factories = 38,
  },

  objects =
  {
    sparks = 0,  -- animated

    flashing_arrow = { id=40, flip_RT=128 },

    lamp = { id=28, flip_RT=128 },

    bush  = 9,
    shrub = 47,
    trees = 10,
    big_tree = 11,

    parked_car = 17,

    pole = 34,
    pole_short = 46,

    ad_relax = 8,
    ad_comsteel = 15,
    ad_garby = 37,

    shipping_containers1 = 21,

    loading_crane = 20,
    metal_tank = 24,

    support_beam = 22,
    overpass_sign = 23,

    molten_ore = 29,
    molten_ore_bucket = 32,
    rusty_crane = 36,
    
    boat = 35,
    tail = 25,

    pipe_thing  = 33,  --??
    metal_frame = 38,
    industrial_wall = 39,

    -- fake 3D Objects --

    cement_shed = { id=4, kind="fake" },

    building1 = { id=26, kind="fake" },
    building2 = { id=42, kind="fake" },

    brick1 = { id=12, kind="fake" },
    brick2 = { id=16, kind="fake" },

    shipping_containers2 = { id=16, kind="fake" },

    -- 3D Objects --

    parking_lot = { id=48, kind="3d" },
    comsteel    = { id=49, kind="3d" },
    sky_scraper = { id=50, kind="3d" },
    metal_tower = { id=51, kind="3d" },

    cement_entrance = { id=52, kind="3d" }
  },

  groups =
  {
    turn_hazard =
    {
      { obj="flashing_arrow", dz = 0.5, dy = -0.2, node_ofs=-1 },
      { obj="pole_short", rel_dx = 0.2, dy = 0.0 }
    }
  },

  hazard_sep = 9.0,

  skins =
  {
    --- Road ---

    road_normal =
    {
      road_tex = { "road2", "road", "road", "road2" }
    },

    --- Features ---

    -- TODO

    --- Edges ---

    low_hills =
    {
      edge_tex = { "grass1", "grass2", "grass2" }
    }
  },

  rail_def = 10,

  scale_defs =
  {
    -- 0 to 9 --
    { img=0, frames=4, xs=3.3333, ws=0.6849, ys=3.3333 },
    { img=1, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=2, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=3, xs=1.0000, ws=1.0000, ys=2.0000 },
    { fake=4, alt=5, xs=13.3333, ws=20.0000, ys=8.0000 },
    { img=5, xs=1.0000, ws=1.0000, ys=2.0000 },
    { fake=5, alt=5, xs=3.3333, ws=3.3333, ys=1.0000 },
    { img=7, xs=13.3333, ws=1.0000, ys=26.6667 },
    { img=8, xs=20.0000, ws=1.0000, ys=9.3333 },
    { img=9, xs=2.6667, ws=1.0000, ys=9.3333 },

    -- 10 to 19 --
    { img=10, xs=5.3333, ws=1.0000, ys=8.0000 },
    { img=11, xs=8.0000, ws=1.0000, ys=10.0000 },
    { fake=12, alt=13, xs=2.0000, ws=2.0000, ys=13.3333 },
    { img=13, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=24, xs=3.3333, ws=3.3333, ys=13.3333 },
    { img=15, xs=16.6667, ws=1.0000, ys=12.0000 },
    { fake=12, alt=13, xs=3.3333, ws=3.3333, ys=18.6667 },
    { img=17, xs=8.6667, ws=1.0000, ys=3.0000 },
    { fake=18, alt=19, xs=9.3333, ws=5.3333, ys=12.0000 },
    { img=19, xs=1.0000, ws=1.0000, ys=2.0000 },

    -- 20 to 29 --
    { img=20, xs=40.0000, ws=1.0000, ys=53.3333 },
    { img=21, xs=13.3333, ws=1.0000, ys=10.0000 },
    { img=22, xs=66.6667, ws=1.0000, ys=6.6667 },
    { img=23, xs=43.3333, ws=1.0000, ys=12.0000 },
    { img=24, xs=12.0000, ws=1.0000, ys=12.0000 },
    { img=25, xs=9.3333, ws=1.0000, ys=10.0000 },
    { fake=26, alt=27, xs=16.0000, ws=20.0000, ys=18.6667 },
    { img=27, xs=13.3333, ws=1.0000, ys=8.0000 },
    { img=28, xs=3.3333, ws=1.0000, ys=9.3333 },
    { img=29, frames=3, xs=1.3333, ws=0.6797, ys=12.0000 },

    -- 30 to 39 --
    { img=30, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=31, xs=1.0000, ws=1.0000, ys=2.0000 },
    { img=32, xs=7.3333, ws=1.0000, ys=13.3333 },
    { img=33, xs=30.6667, ws=1.0000, ys=4.6667 },
    { img=34, xs=1.0000, ws=1.0000, ys=19.3333 },
    { img=35, xs=32.0000, ws=1.0000, ys=23.3333 },
    { img=36, xs=9.3333, ws=1.0000, ys=6.6667 },
    { img=37, xs=23.3333, ws=1.0000, ys=10.0000 },
    { img=38, xs=28.0000, ws=1.0000, ys=24.0000 },
    { img=39, xs=41.3333, ws=1.0000, ys=30.0000 },

    -- 40 to 49 --
    { img=40, frames=2, speed=20, xs=3.3333, ws=0.7136, ys=2.0000 },
    { img=41, xs=1.0000, ws=1.0000, ys=2.0000 },
    { fake=42, alt=43, xs=20.0000, ws=20.0000, ys=36.6667 },
    { fake=6, alt=7, xs=3.3333, ws=3.3333, ys=16.6667 },
    { img=44, xs=26.6667, ws=1.0000, ys=16.6667 },
    { img=24, xs=12.0000, ws=1.0000, ys=26.6667 },
    { img=34, xs=0.5000, ws=1.0000, ys=5.0000 },
    { img=45, xs=4.0000, ws=1.0000, ys=2.6667 },

    { obj3d=0 },
    { obj3d=1 },

    -- 50 to 55 --
    { obj3d=2 },
    { obj3d=3 },
    { obj3d=4 }
  }
}

