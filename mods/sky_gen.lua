----------------------------------------------------------------
--  MODULE: sky generator
----------------------------------------------------------------
--
--  Copyright (C) 2008-2009 Andrew Apted
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


function Skygen_generate_doom()

  -- FIXME: supply full information, e.g. via GAME.skies table
  local sky_list =
  {
    { patch="SKY1" },
    { patch="SKY2" },
    { patch="SKY3" },
    { patch="SKY4" },
  }

  if PARAM.doom2_skies then
    sky_list =
    {
      { patch="RSKY1" },
      { patch="RSKY2" },
      { patch="RSKY3" },
    }
  end

  -- star colors --

  local STAR_COLS =
  {
    8, 7, 6, 5,
    111, 109, 107, 104, 101,
    98, 95, 91, 87, 83, 4
  }

  -- cloud colors --

  local GREY_CLOUDS =
  {
    106, 104, 102, 100,
    98, 96, 94, 92, 90,
    88, 86, 84, 82, 80
  }

  local DARK_CLOUDS =
  {
    7, 6, 5,
    110, 109, 108, 107, 106,
    105, 104, 103, 102, 101
  }

  local BLUE_CLOUDS =
  {
    245, 245, 244, 244, 243, 242, 241,
    240, 206, 205, 204, 204, 203, 203
  }

  local HELL_CLOUDS =
  {
    188, 185, 184, 183, 182, 181, 180,
    179, 178, 177, 176, 175, 174, 173
  }

  local ORANGE_CLOUDS =
  {
    234, 232, 222, 220, 218, 216, 214, 211
  }

  local HELLISH_CLOUDS =
  {
    0, 0, 0, 0, 0, 47, 191, 190, 191, 47, 0, 0
  }

  local BROWN_CLOUDS =
  {
     2, 1,
     79, 78, 77, 76, 75, 74, 73,
     72, 71, 70, 69, 67, 66, 65
  }

  local BROWNISH_CLOUDS =
  {
    239, 238, 237, 236, 143, 142, 141,
    140, 139, 138, 137, 136, 135, 134,
    133, 130, 129, 128
  }

  local YELLOW_CLOUDS =
  {
    167, 166, 165, 164, 163, 162,
    161, 160, 228, 227, 225
  }

  local GREEN_CLOUDS =
  {
    127, 126, 125, 124, 123, 122, 121,
    120, 119, 118, 117, 115, 113, 112
  }

  local JADE_CLOUDS =
  {
    12, 11, 10, 9,
    159, 158, 157, 156, 155, 154, 153, 152
  }

  local DARKRED_CLOUDS =
  {
     47, 46, 45, 44, 43, 42, 41, 40, 39, 37, 36, 34
  }

  local PEACH_CLOUDS =
  {
     68, 66, 64, 62, 60, 58, 57
  }

  local WHITE_CLOUDS =
  {
     99, 98, 97, 96, 95, 94, 93,
     92, 91, 90, 89, 88, 87, 86,
     85, 84, 83, 81
  }

  local SKY_CLOUDS =
  {
    194, 195, 196, 197, 199, 201
  }

  local PURPLE_CLOUDS =
  {
    254, 253, 252, 251, 250, 251, 252, 253, 254
  }

  local RAINBOW_CLOUDS =
  {
    191, 186, 181, 176,
    231, 161, 164, 167,
    242, 207, 204, 199,
    115, 119, 123, 127
  }

  local BLACK_N_WHITE =
  {
    0, 4, 0, 4, 0, 4, 0, 4
  }

  -- hill colors --

  local BLACK_HILLS =
  {
    0, 0, 0
  }

  local BROWN_HILLS =
  {
    0, 2, 1, 79, 77, 75, 73, 70, 67, 64
  }

  local TAN_HILLS =
  {
    239, 237, 143, 140, 136, 132, 128
  }

  local GREEN_HILLS =
  {
    0, 7,
    127, 126, 125, 124, 123,
    122, 120, 118, 116, 113
  }

  local HELL_HILLS =
  {
    0, 6, 47, 45, 43, 41, 39, 37, 35, 33
  }

  local DARKBROWN_HILLS =
  {
    8, 7, 2, 1, 79, 78, 77, 76, 75
  }

  local GREENISH_HILLS =
  {
    0, 7, 12, 11, 10, 9, 15, 14, 13,
    159, 158, 157, 156, 155, 154
  }


  local back_gs = { "stars", "stars",
                    GREY_CLOUDS, DARK_CLOUDS, BLUE_CLOUDS,
                    HELL_CLOUDS, ORANGE_CLOUDS, HELLISH_CLOUDS,
                    BROWN_CLOUDS, BROWNISH_CLOUDS, YELLOW_CLOUDS,
                    GREEN_CLOUDS, JADE_CLOUDS, DARKRED_CLOUDS,
                    PEACH_CLOUDS, WHITE_CLOUDS, SKY_CLOUDS,
                  }

  local fore_gs = { "none",  "none", "none",
                    TAN_HILLS, BROWN_HILLS, GREEN_HILLS,
                    HELL_HILLS, DARKBROWN_HILLS, GREENISH_HILLS,
                    BLACK_HILLS,
                  }

  if OB_CONFIG.theme == "psycho" then
    back_gs = { PURPLE_CLOUDS, PURPLE_CLOUDS,
                RAINBOW_CLOUDS, RAINBOW_CLOUDS,
                GREEN_CLOUDS, YELLOW_CLOUDS,
                HELLISH_CLOUDS, BLACK_N_WHITE,
              }
    fore_gs = { "none", "none", "none",
                PURPLE_CLOUDS, RAINBOW_CLOUDS,
                GREEN_CLOUDS, ORANGE_CLOUDS,
                HELLISH_CLOUDS, YELLOW_CLOUDS,
                BLUE_CLOUDS, BLUE_CLOUDS,
              }
  end


  rand.shuffle(back_gs)
  rand.shuffle(fore_gs)


  for num,sky in ipairs(sky_list) do
    gui.fsky_create(256, 128, 0)

    local squish = rand.index_by_probs { 1, 4, 2 }

    if back_gs[num] == "stars" then
      gui.set_colormap(1, STAR_COLS)
      gui.fsky_add_stars  { seed=num+9, colmap=1 }
    else
      gui.set_colormap(1, back_gs[num])
      gui.fsky_add_clouds { seed=num+1, colmap=1, squish=squish }
    end

    if fore_gs[num] ~= "none" then
      gui.set_colormap(2, fore_gs[num])
      gui.fsky_add_hills  { seed=num+5, colmap=2, max_h=0.6 }
    end

    gui.fsky_write(sky.patch)
  end
end


OB_MODULES["sky_gen_doom"] =
{
  label = "Sky Generator (DOOM)",

  for_games = { doom1=1, doom2=1 },

  hooks =
  {
    levels_start = Skygen_generate_doom,
  },
}

