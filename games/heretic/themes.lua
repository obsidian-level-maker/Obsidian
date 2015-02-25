------------------------------------------------------------------------
--  HERETIC THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.NAMES =
{
  -- TODO
}


-- FIXME : NEED MAJOR WORK HERE (Heretic Themes) !!!!

HERETIC.THEME_DEFAULTS =
{
  starts = { Start_basic = 20, Start_Closet = 90 }

  exits = { Exit_Pillar = 10, Exit_Closet = 90 }

  pedestals = { Pedestal_1 = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
             Lift_Up1 = 2, Lift_Down1 = 2 }

  -- according to Borsuk, locked doors should always appear in the
  -- following order: Yellow ==> Green ==> Blue.
  keys = { k_yellow=9000, k_green=90, k_blue=1 }

  switches = { sw_metal=50 }

  switch_fabs = { Switch_1=50 }

  locked_doors = { Locked_yellow=50, Locked_green=50, Locked_blue=50,
                   Door_SW_1=50 }

  teleporters = { Teleporter1=50 }


  steps = { step1=50 }

  doors = { d_wood=50, d_demon=15 }

  logos = { Pic_Carve=50, Pic_Pill=15 }

  pictures =
  {
    Pic_Banner5 = 30
    Pic_Banner7 = 30
    Pic_Mosaic5 = 5

    Pic_GrinSkull = 50
    Pic_Saint = 60
    Pic_Eagle = 40
  }

  hallway_groups = { hall_basic = 50 }

  mini_halls = { Hall_Basic_I = 50 }

  sky_halls = { sky_hall = 50 }

--FIXME TEMP STUFF
  cave_walls = { BRWNRCKS=10, LAVA1=20, LOOSERCK=20,
                 RCKSNMUD=20, ROOTWALL=30,
               }

  landscape_walls = { BRWNRCKS=10, LAVA1=20, LOOSERCK=20,
                      RCKSNMUD=20, ROOTWALL=10,
                    }

  periph_pillar_mat = "WOODWL",
  beam_mat = "WOODWL",
  track_mat = "METL2",
  pedestal_mat = "FLAT500",
}


HERETIC.ROOM_THEMES =
{
  ---- URBAN THEME -----------------

  Urban_house1 =
  {
    walls =
    {
      CTYSTCI2 = 20
      CTYSTCI4 = 40
    }

    floors =
    {
      FLOOR03 = 50
      FLOOR06 = 50
      FLOOR10 = 50
    }

    ceilings =
    {
      FLAT521 = 50
      FLAT523 = 50
    }
  }

  Urban_house2 =
  {
    walls =
    {
      CTYSTUC4 = 50
    }

    floors =
    {
      FLOOR03 = 50
      FLOOR06 = 50
      FLOOR10 = 50
    }

    ceilings =
    {
      FLAT521 = 50
      FLAT523 = 50
    }
  }

  Urban_stone =
  {
    walls =
    {
      GRSTNPB = 50
    }

    floors =
    {
      FLOOR00 = 50
      FLOOR19 = 50
      FLAT522 = 50
      FLAT523 = 50
    }

    ceilings =
    {
      FLAT520 = 50
      FLAT523 = 50
    }
  }

  Urban_wood =
  {
    walls =
    {
      WOODWL = 50
    }

    floors =
    {
      FLAT508 = 20
      FLOOR11 = 20
      FLOOR03 = 50
      FLOOR06 = 50
    }

    ceilings =
    {
      FLOOR10 = 50
      FLOOR11 = 30
      FLOOR01 = 50
    }
  }


  ---- CASTLE THEME -----------------

  Castle_green =
  {
    walls =
    {
      GRNBLOK1 = 50
      MOSSRCK1 = 50
    }

    floors =
    {
      FLOOR19 = 20
      FLOOR27 = 50
      FLAT520 = 50
      FLAT521 = 50
    }

    ceilings =
    {
      FLOOR05 = 50
      FLAT512 = 50
    }
  }

  Castle_gray =
  {
    walls =
    {
      CSTLRCK  = 50
      TRISTON1 = 50
    }

    floors =
    {
      FLAT503 = 50
      FLAT522 = 50
      FLOOR10 = 50
    }

    ceilings =
    {
      FLOOR04 = 50
      FLAT520 = 50
    }
  }

  Castle_orange =
  {
    walls =
    {
      SQPEB2   = 50
      TRISTON2 = 50
    }

    floors =
    {
      FLOOR01 = 50
      FLOOR03 = 50
      FLOOR06 = 20
    }

    ceilings =
    {
      FLAT523 = 50
      FLOOR17 = 50
    }
  }

  Castle_hallway =
  {
    walls =
    {
      GRSTNPB  = 60
      SANDSQ2  = 20
      SNDCHNKS = 20
    }

    floors =
    {
      FLOOR00 = 50
      FLOOR18 = 50
      FLAT521 = 50
      FLAT506 = 50
    }

    ceilings =
    {
      FLAT523 = 50
    }
  }



  ---- OTHER STUFF ------------------

  Cave_generic =
  {
    naturals =
    {
      LOOSERCK=20, LAVA1=20, BRWNRCKS=20
    }
  }


  Outdoors_generic =
  {
    floors =
    {
      FLOOR00=20, FLOOR27=30, FLOOR18=50,
      FLAT522=10, FLAT523=20,
    }

    naturals =
    {
      FLOOR17=50, FLAT509=20, FLAT510=20,
      FLAT513=20, FLAT516=35, 
    }
  }
}


HERETIC.LEVEL_THEMES =
{
  heretic_urban1 =
  {
    prob = 50

    liquids = { water=50, sludge=15, lava=4 }

    buildings = { Urban_house1=30, Urban_house2=30,
                  Urban_wood=30, Urban_stone=50
                }

    hallways = { Castle_hallway=50 }  -- FIXME

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

    --TODO: more stuff

  }  -- CITY1


  heretic_castle1 =
  {
    prob = 50

    liquids = { lava=50, magma=20, sludge=3 }

    buildings = { Castle_green=50, Castle_gray=50,
                  Castle_orange=50
                }

    hallways = { Castle_hallway=50 }

    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

    -- hallways = { blah }

    --TODO: more stuff
  }
}


