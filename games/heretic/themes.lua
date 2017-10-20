------------------------------------------------------------------------
--  HERETIC THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.THEMES =
{
  DEFAULTS =
  {
    -- Note: there is no way to control the order which keys are used

    keys =
    {
      k_yellow = 70
      k_green  = 50
      k_blue   = 30
    }

    fences =
    {
      BRWNRCKS = 20
    }

    cliff_mats =
    {
      ROOTWALL = 50
    }

    cage_mats =
    {
      WOODWL = 60
    }

    floor_sinks =
    {
      PLAIN = 50
    }

    ceiling_sinks =
    {
      PLAIN = 50
    }

    wall_groups =
    {
      PLAIN = 50
      torches1 = 50
    }

    window_groups =
    {
      square = 70
      tall   = 30
    }

    wide_halls =
    {
      deuce = 50
    }

    steps_mat = "FLOOR10"

    post_mat  = "METL2"

    cage_rail_mat  = "GATMETL4"
    water_rail_mat = "WDGAT64"

    no_switches = true

    cage_lights = { 0, 8, 12, 13 }

    pool_depth = 24
  }


  castle =
  {
    liquids =
    {
      water2 = 40
      water  = 10

      lava   = 50
      sludge = 20
    }

    facades =
    {
      CSTLRCK  = 50
      GRNBLOK1 = 30
    }
  }


--[[
  town =
  {
    liquids =
    {
      water  = 50
      sludge = 15
      lava   = 5
    }

    facades =
    {
      GRSTNPB = 50
    }
  }
--]]

}


HERETIC.ROOM_THEMES =
{
  any_Hallway =
  {
    env  = "hallway"
    prob = 1

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


  ---- CASTLE THEME --------------------------------

  castle_Green =
  {
    env  = "building"
    prob = 50

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


  castle_Gray =
  {
    env  = "building"
    prob = 50

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


  castle_Orange =
  {
    env  = "building"
    prob = 50

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


  -- TODO : these are same as urban theme, differentiate them!

  castle_Cave =
  {
    env  = "cave"
    prob = 50

    walls =
    {
      LOOSERCK=20, BRWNRCKS=20
    }

    floors =
    {
      LOOSERCK=20, BRWNRCKS=20
    }
  }


  castle_Outdoors =
  {
    env  = "outdoor"
    prob = 50

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


  castle_deuce_Hallway =
  {
    env   = "hallway"
    group = "deuce"
    prob  = 50

    walls =
    {
      SNDCHNKS = 30
      SQPEB1   = 30
      SQPEB2   = 20
      SKULLSB1 = 10
    }

    floors =
    {
      FLOOR00 = 20
      FLOOR01 = 20
      FLOOR06 = 20
      FLOOR07 = 20
      FLOOR09 = 20
      FLAT502 = 10
    }

    ceilings =
    {
      FLOOR29 = 20
      FLOOR00 = 10
      FLOOR09 = 10
      FLAT510 = 10
      FLAT520 = 10
    }
  }


  ---- TOWN THEME ---------------------------------

  town_House1 =
  {
    env  = "building"
    prob = 50

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


  town_House2 =
  {
    env  = "building"
    prob = 50

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


  town_Stone =
  {
    env  = "building"
    prob = 50

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


  town_Wood =
  {
    env  = "building"
    prob = 50

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


  town_Cave =
  {
    env  = "cave"
    prob = 50

    walls =
    {
      LOOSERCK=20, BRWNRCKS=20
    }

    floors =
    {
      LOOSERCK=20, BRWNRCKS=20
    }
  }


  town_Outdoors =
  {
    env  = "outdoor"
    prob = 50

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


------------------------------------------------------------------------

HERETIC.NAMES =
{
  -- TODO
}


HERETIC.ROOMS =
{
  GENERIC =
  {
    env = "any"
  }
}


------------------------------------------------------------------------


OB_THEMES["castle"] =
{
  label = _("Castle")
  game = "heretic"
  name_theme = "URBAN"
  mixed_prob = 50
}


--[[
OB_THEMES["town"] =
{
  label = _("Town")
  game = "heretic"
  name_theme = "URBAN"
  mixed_prob = 50
}
--]]

