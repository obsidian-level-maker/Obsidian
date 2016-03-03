------------------------------------------------------------------------
--  QUAKE THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------


QUAKE.THEMES =
{
  DEFAULTS =
  {
    keys =
    {
      k_silver = 60
      k_gold   = 20
    }

    switches =
    {
      sw_metal = 50
    }

    fences =
    {
      ROCK5_2 = 50
    }
  }


  q1_tech =
  {
    worldtype = 2

    skies =
    {
      sky4 = 80
      sky1 = 20
    }

    liquids =
    {
      slime0 = 25
      slime  = 50
    }

    facades =
    {
      TECH14_2 = 50
    }
  }


  q1_castle =
  {
    worldtype = 0

    skies =
    {
      sky1 = 80
      sky4 = 20
    }

    liquids =
    {
      lava1 = 50
    }

    facades =
    {
      BRICKA2_4 = 50
    }
  }
}


QUAKE.ROOM_THEMES =
{
  any_Stairwell =
  {
    kind = "stairwell"

    walls =
    {
      BRICKA2_1 = 30
    }

    floors =
    {
      WOOD1_1 = 50
    }
  }


  any_Hallway =
  {
    kind = "hallway"

    walls =
    {
      WOOD1_5 = 30
    }

    floors =
    {
      WOODFLR1_5 = 50
    }

    ceilings =
    {
      WOODFLR1_4 = 50
    }
  }


  ----- TECH BASE ----------------------------------

  q1_tech_Room =
  {
    kind = "building"

    walls =
    {
      TECH06_1=50, TECH08_2=50, TECH09_3=50, TECH08_1=50,
      TECH13_2=50, TECH14_1=50, TWALL1_4=50, TECH14_2=50,
      TWALL2_3=50, TECH03_1=50, TECH05_1=50,
    }

    floors =
    {
      FLOOR01_5=50, METAL2_4=50, METFLOR2_1=50, MMETAL1_1=50,
      SFLOOR4_1=50, SFLOOR4_5=50, SFLOOR4_6=50, SFLOOR4_7=50,
      WIZMET1_2=50, MMETAL1_6=50, MMETAL1_7=50, MMETAL1_8=50,
      WMET4_5=50, WMET1_1=50, 
    }

    ceilings =
    {
      FLOOR01_5=50, METAL2_4=50, METFLOR2_1=50, MMETAL1_1=50,
      SFLOOR4_1=50, SFLOOR4_5=50, SFLOOR4_6=50, SFLOOR4_7=50,
      WIZMET1_2=50, MMETAL1_6=50, MMETAL1_7=50, MMETAL1_8=50,
      WMET4_5=50, WMET1_1=50,
    }
  }


  -- TODO : these are duplicate of castle ones -- make them distinct

  q1_tech_Cave =
  {
    kind = "cave"

    naturals =
    {
      ROCK1_2=10, ROCK5_2=40, ROCK3_8=20,
      WALL11_2=10, GROUND1_6=10, GROUND1_7=10,
      GRAVE01_3=10, WSWAMP1_2=20, 
    }
  }


  q1_tech_Outdoors =
  {
    kind = "outdoors"

    floors =
    {
      CITY4_6=30, CITY6_7=30, 
      CITY4_5=30, CITY4_8=30, CITY6_8=30,
      WALL14_6=20, CITY4_1=30, CITY4_2=30, CITY4_7=30,
    }

    naturals =
    {
      GROUND1_2=50, GROUND1_5=50, GROUND1_6=20,
      GROUND1_7=30, GROUND1_8=20,
      ROCK3_7=50, ROCK3_8=50, ROCK4_2=50,
      VINE1_2=50, 
    }
  }


  ----- CASTLE ----------------------------------

  q1_castle_Room =
  {
    kind = "building"

    walls =
    {
      BRICKA2_4=30, CITY5_4=30, WALL14_5=30, CITY1_4=30, METAL4_4=20, METALT1_1=15,
      CITY5_8=40, CITY5_7=50, CITY6_3=50, CITY6_4=50, METAL4_3=20, METALT2_2=5,
      CITY2_1=30, CITY2_2=30, CITY2_3=30, CITY2_5=30, METAL4_2=15, METALT2_3=20,
      CITY2_6=30, CITY2_7=30, CITY2_8=30, CITY6_7=20, METAL4_7=20, METALT2_6=5,
      CITY8_2=30, WALL3_4=30, WALL5_4=30, WBRICK1_5=30, METAL4_8=20, METALT2_7=20, WMET4_8=15,
      WIZ1_4=30, WSWAMP1_4=30, WSWAMP2_1=30, WSWAMP2_2=30, ALTARC_1=20, WMET4_3=15, WMET4_7=15,
      WWALL1_1=30, WALL3_4=30, ALTAR1_3=20, ALTAR1_6=5, ALTAR1_7=20, WMET4_4=15, WMET4_6=15,
    }

    floors =
    {
      AFLOOR1_4=50, AFLOOR3_1=25, AZFLOOR1_1=20, ROCK3_8=20, METAL5_4=30, FLOOR01_5=30,
      CITY4_1=15, CITY4_2=25, CITY4_5=15, CITY4_6=20, ROCK3_7=20, METAL5_2=30, MMETAL1_2=15,
      CITY4_7=15, CITY4_8=15, CITY5_1=30, CITY5_2=30, WALL3_4=30, CITY6_8=20,
      CITY8_2=20, GROUND1_8=20, ROCK3_7=20, AFLOOR1_3=20, BRICKA2_4=30, WALL9_8=30,
      AFLOOR1_8=20, WOODFLR1_5=20, BRICKA2_1=30, BRICKA2_2=30, CITY6_7=20, WOODFLR1_5=30,
    }

    ceilings =
    {
      DUNG01_4=50, DUNG01_5=50, ECOP1_8=50, ECOP1_4=50, ECOP1_6=50, WSWAMP1_4=30,
      WIZMET1_1=50, WIZMET1_4=50, WIZMET1_6=50, WIZMET1_7=50, WIZ1_1=50, WSWAMP2_1=30,
      GRAVE01_1=50, GRAVE01_3=50, GRAVE03_2=50, WALL3_4=30, WALL5_4=30, WALL11_2=20,
      WSWAMP2_2=30, WBRICK1_5=30, WIZ1_4=20, COP1_1=30, COP1_2=30, COP1_8=30, COP2_2=30,
      MET5_1=20, METAL1_1=20, METAL1_2=20, METAL1_3=20, WMET1_1=15,
    }
  }


  q1_castle_Outdoors =
  {
    kind = "outdoors"

    floors =
    {
      CITY4_6=30, CITY6_7=30, 
      CITY4_5=30, CITY4_8=30, CITY6_8=30,
      WALL14_6=20, CITY4_1=30, CITY4_2=30, CITY4_7=30,
    }

    naturals =
    {
      GROUND1_2=50, GROUND1_5=50, GROUND1_6=20,
      GROUND1_7=30, GROUND1_8=20,
      ROCK3_7=50, ROCK3_8=50, ROCK4_2=50,
      VINE1_2=50, 
    }
  }


  q1_castle_Cave =
  {
    kind = "cave"

    naturals =
    {
      ROCK1_2=10, ROCK5_2=40, ROCK3_8=20,
      WALL11_2=10, GROUND1_6=10, GROUND1_7=10,
      GRAVE01_3=10, WSWAMP1_2=20, 
    }
  }
}


------------------------------------------------------------------------

QUAKE.NAMES =
{
  -- TODO
}


QUAKE.ROOMS =
{
  GENERIC =
  {
    environment = "any"
  }
}


------------------------------------------------------------------------


OB_THEMES["q1_tech"] =
{
  game = "quake"
  label = "Tech"
  name_theme = "TECH"
  mixed_prob = 50
}


OB_THEMES["q1_castle"] =
{
  game = "quake"
  label = "Castle"
  name_theme = "URBAN"
  mixed_prob = 50
}

