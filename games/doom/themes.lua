--------------------------------------------------------------------
--  DOOM THEMES
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C) 2011,2014 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------


DOOM.SINKS =
{
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY"
    dz    = 64
    light = 16
  }

  sky_metal =
  {
    mat   = "_SKY"
    dz    = 48
    light = 16

    trim_mat = "METAL"
    trim_dz  = -9
    trim_light = 16
  }

  sky_shiny =
  {
    mat   = "_SKY"
    dz    = 32
    light = 16

    trim_mat = "FLAT23"
    trim_dz  = -5
    trim_light = 16
  }

  sky_red =
  {
    mat   = "_SKY"
    dz    = 32
    light = 16

    trim_mat = "REDWALL"
    trim_dz  = -5
    trim_light = 16
  }


  -- liquid floor --

  liquid_plain =
  {
    mat = "_LIQUID"
    dz  = -12
  }

  liquid_blood =
  {
    mat = "BLOOD1"
    dz  = -12
    light = 16
  }

  liquid_shiny =
  {
    mat = "_LIQUID"
    dz  = -10

    trim_mat = "FLAT23"
    trim_dz  = 3
  }

  liquid_metal =
  {
    mat = "_LIQUID"
    dz  = -8

    trim_mat = "METAL"
    trim_dz  = 3
  }


  -- ceiling lights --

  light_red_shiny =
  {
    mat = "TLITE6_5"
    dz  = 4
    light = 16

    trim_mat = "FLAT23"
    trim_dz  = -5
  }

  light_orange_shiny =
  {
    mat = "TLITE6_6"
    dz  = 4
    light = 16

    trim_mat = "FLAT23"
    trim_dz  = -5
  }

  light_brightred_metal =
  {
    mat = "FLOOR1_7"
    dz  = 4
    light = 32

    trim_mat = "METAL"
    trim_dz  = -5
    trim_light = 16
  }

  light_diamond =
  {
    mat = "TLITE6_1"
    dz  = 8
    light = 16
  }

  light_urban1 =
  {
    mat = "CEIL3_4"
    dz  = 4
    light = 32

    trim_mat = "METAL"
    trim_dz  = -5
  }

  light_hell_red =
  {
    mat = "FLAT5_3"
    dz  = 16
    light = 16
  }

  light_hell_lava =
  {
    mat = "LAVA1"
    dz  = 16
    light = 32
  }


  -- misc floor --

  floor_glowingrock =
  {
    mat = "RROCK05"
    dz  = -8
  }

  floor_skulls =
  {
    mat = "FLAT5_6"
    dz  = -8
  }

  floor_snakes =
  {
    mat = "SFLR6_4"
    dz  = -8
  }

  floor_green =
  {
    mat = "DEM1_6"
    dz  = -8
  }

  floor_red =
  {
    mat = "FLOOR1_6"
    dz  = -8
  }

  floor_blue =
  {
    mat = "FLAT14"
    dz  = -8
  }

  floor_blue2 =
  {
    mat = "CEIL4_3"
    dz  = -8
  }


  -- misc ceiling --

  ceil_redash =
  {
    mat = "FLOOR6_1"
    dz  = 8
  }
}



DOOM.THEMES =
{
  DEFAULTS =
  {
    keys =
    {
      k_red    = 50
      k_blue   = 50
      k_yellow = 50
    }

    switches = { sw_blue=50, sw_red=50 }

    cave_torches =
    {
      red_torch   = 60
      green_torch = 40
      blue_torch  = 20
    }

    fences =
    {
      BROWN144 = 60
      WOOD5    = 60
      STONE    = 40
      BSTONE2  = 40
      CEMENT9  = 30
      BRICK12  = 20

      GSTVINE2 = 15
      BRICK10  = 10
      BRICK11  = 10
      SLADWALL = 20
      STUCCO3  = 10
    }

    floor_sinks =
    {
      PLAIN = 100
    }

    ceiling_sinks =
    {
      PLAIN = 100
    }

    wall_groups =
    {
      PLAIN = 100
    }

    -- FIXME: temp crud
    has_triple_key_door = true
    has_double_switch_door = true

    steps_mat = "GRAY7"

    cliff_mats =
    {
      GRAYVINE = 60
    }
  }

  ------------------------------------

  tech =
  {
    liquids =
    {
      nukage = 90
      water  = 30
      slime  = 20
      lava   = 5
    }

    facades =
    {
      BROWN1   = 40
      STARTAN3 = 40
      STARG3   = 40
      STARGR2  = 40
      STARBR2  = 30

      BROWN96  = 25
      BROWNGRN = 25
      SLADWALL = 20
      METAL2   = 10
      METAL1   = 5
    }

    cliff_mats =
    {
      ASHWALL4 = 60
      ASHWALL7 = 40
      ZIMMER1  = 40
      STONE5   = 40
      STONE7   = 40
      SP_ROCK1 = 20
      BROVINE2 = 20
    }

    corners =
    {
      STARGR1 = 50
      METAL1 = 30
      METAL7 = 50
      METAL2 = 15
      METAL4 = 15

      ICKWALL3 = 10
      TEKWALL4 = 10
      TEKWALL6 = 15
      TEKBRON1 = 5
      COMPTALL = 5
      COMPBLUE = 5
    }

    prefab_remap =
    {
    }

    entity_remap =
    {
      green_torch = "mercury_lamp"
    }

    floor_sinks =
    {
      PLAIN = 200
      liquid_plain = 10
      liquid_shiny = 5
      liquid_metal = 5
      floor_green = 10
      floor_blue2 = 5
    }

    ceiling_sinks =
    {
      PLAIN = 90
      sky_shiny = 20
      sky_metal = 10
      light_red_shiny = 20
      light_orange_shiny = 7
      light_brightred_metal = 7
    }

    wall_groups =
    {
      PLAIN = 70
      low_gap = 50
      mid_band = 25
      lite2 = 15
    }

    monster_prefs =
    {
      zombie  = 1.5
      shooter = 1.2
      arach   = 1.5
    }

    outdoor_torches =
    {
      lamp   = 10
      mercury_lamp = 40
      short_lamp   = 40
    }

    ceil_light_prob = 60

    style_list =
    {
      naturals = { none=30, few=70, some=30, heaps=2 }
    }

    techy_doors = true
  }

  ------------------------------------

  urban =
  {
    liquids =
    {
      water = 80
      slime = 40
      blood = 25
      lava  = 5
    }

    facades =
    {
      BIGBRIK1 = 40
      BIGBRIK2 = 30
      MODWALL1 = 30
      STONE3   = 30

      BLAKWAL2 = 20
      CEMENT7  = 20
      BRICK12  = 20
      BRICK7   = 20
      STONE    = 20

      BRICK10 = 10
      BRICK11 = 10
      METAL2  = 10
    }

    cliff_mats =
    {
      ROCK2    = 60
      ASHWALL6 = 40
      TANROCK8 = 40
      ZIMMER5  = 40
      ZIMMER7  = 40
      BSTONE1  = 20
      ROCK5    = 20
    }

    prefab_remap =
    {
      SW1COMP  = "SW1PANEL"
      SILVER3  = "WOODGARG"
    }

    floor_sinks =
    {
      PLAIN = 100
      liquid_plain = 20
      liquid_metal = 10
      floor_red = 20
      floor_blue = 10
      floor_green = 10
    }

    ceiling_sinks =
    {
      PLAIN = 60
      sky_metal = 30
      sky_plain = 10
      light_urban1 = 15
      light_diamond = 5
      ceil_redash = 5
    }

    outdoor_torches =
    {
      blue_torch = 50
      candelabra = 30
      skull_rock = 30
      burning_barrel = 10
    }

    monster_prefs =
    {
      revenant = 1.2
      knight   = 1.5
      gunner   = 1.5
    }

    ceil_light_prob = 75

    archy_arches = true
  }

  ------------------------------------

  hell =
  {
    liquids =
    {
      lava   = 70
      blood  = 40
      nukage = 5
    }

    entity_remap =
    {
      k_red    = "ks_red"
      k_blue   = "ks_blue"
      k_yellow = "ks_yellow"
    }

    facades =
    {
      MARBGRAY = 60
      SP_HOT1  = 50
      STONE3   = 30
      BROWN1   = 30

      SKINMET2 = 20
      GSTVINE1 = 20
      GSTVINE2 = 20
      STONE    = 10
      MARBLE2  = 10
    }

    cliff_mats =
    {
      ROCKRED1 = 80
      SP_ROCK1 = 40
      ASHWALL2 = 40
      ROCK3    = 40
      CRACKLE4 = 40
      SKSNAKE1 = 20
      SKSNAKE2 = 20
      SKIN2    = 20
    }

    prefab_remap =
    {
      DOORBLU  = "DOORBLU2"
      DOORRED  = "DOORRED2"
      DOORYEL  = "DOORYEL2"

      BIGDOOR1 = "BIGDOOR6"
      BIGDOOR2 = "BIGDOOR7"
      BIGDOOR3 = "BIGDOOR7"
      BIGDOOR4 = "BIGDOOR5"

      SW1COMP  = "SW1LION"
      SW1PIPE  = "SW1BROWN"
      SILVER3  = "MARBFACE"
    }

    floor_sinks =
    {
      PLAIN = 120
      liquid_plain = 10
      liquid_blood = 10
      floor_skulls = 20
      floor_glowingrock = 10
      floor_snakes = 5
    }

    ceiling_sinks =
    {
      PLAIN = 50
      sky_metal = 20
      sky_plain = 20
      light_diamond = 10
      light_hell_red = 20
      light_hell_lava = 5
      ceil_redash = 5
    }

    wall_groups =
    {
      PLAIN = 100
      low_gap = 30
      runes1 = 20
      cross1 = 10
    }

    monster_prefs =
    {
      zombie  = 0.3
      shooter = 0.6
      vile    = 1.3
      skull   = 2.0
    }

    ceil_light_prob = 25
  }
}



DOOM.ROOM_THEMES =
{

-----  GENERIC STUFF  ------------------------------

  any_Hallway =
  {
    env = "hallway"
    prob = 1

    walls =
    {
      BROWN1  = 50
      GRAY1   = 50
      STARGR1 = 50
      METAL1  = 20
    }

    floors =
    {
      FLAT1 = 30
      FLOOR7_1 = 50
    }

    ceilings =
    {
      FLAT1 = 30
      FLOOR7_1 = 50
    }
  }


-----  TECH BASES  --------------------------------

  tech_Startan =
  {
    env  = "building"
    prob = 50

    walls =
    {
      STARTAN3 = 60
      STARG3 = 40
      STARG2 = 10

      STARTAN2 = 50
      STARBR2  = 40
    }

    floors =
    {
      FLOOR4_8 = 50
      FLOOR5_3 = 30
      FLOOR0_3 = 30
      FLOOR5_1 = 25
      FLOOR3_3 = 20
      FLOOR0_2 = 20
      FLOOR0_1 = 20
      FLOOR4_6 = 15
      FLAT4 = 15
      FLAT14 = 10
      SLIME15 = 10
      SLIME16 = 10
      FLOOR1_1 = 8
      FLOOR0_5 = 5
      FLAT5 = 5
    }

    ceilings =
    {
      CEIL3_1 = 20
      CEIL3_2 = 20
      CEIL3_5 = 20
      CEIL3_3 = 15
      CEIL4_2 = 10
      CEIL4_3 = 10
      CEIL5_1 = 15

      FLAT9  = 30
      FLAT19 = 20
      FLAT4  = 20
      FLAT9  = 15
      FLAT23 = 5
    }
  }


  tech_Tekgren =
  {
    env  = "building"
    prob = 25

    walls =
    {
      TEKGREN2 = 50
    }

    floors =
    {
      FLAT14 = 55
      FLOOR1_1 = 20
      FLOOR0_3 = 20
      FLOOR3_3 = 40
      FLOOR5_1 = 20
      FLOOR4_8 = 20
      FLOOR4_6 = 20
      FLAT5 = 10
    }

    ceilings =
    {
      FLAT1   = 15
      CEIL3_5 = 5
      SLIME15 = 5
      SLIME14 = 5
    }
  }


  tech_Metal =
  {
    env  = "building"
    prob = 50

    walls =
    {
      METAL2 = 70
      METAL4 = 15
      METAL1 = 15
      STARGR2 = 10
      PIPE4 = 10
    }

    floors =
    {
      FLAT3 = 50
      FLOOR0_1 = 30
      FLOOR4_5 = 20
      FLOOR4_6 = 20
      FLOOR7_1 = 15
      SLIME15 = 20
      SLIME14 = 20
      FLAT4 = 5
    }

    ceilings =
    {
      CEIL5_1 = 40
      CEIL5_2 = 40
      SLIME15 = 40
      CEIL4_1 = 20
      SLIME14 = 40
    }
  }


  tech_Gray =
  {
    env  = "building"
    prob = 20

    walls =
    {
      GRAY1 = 50
      GRAY4 = 30
      GRAY7 = 30
      ICKWALL1 = 40
      ICKWALL3 = 20
    }

    floors =
    {
      FLAT4 = 50
      FLAT5_4 = 20
      FLAT9 = 10
      FLOOR0_5 = 40
      FLOOR0_1 = 30
      FLOOR0_3 = 10
      FLOOR3_3 = 20
      FLOOR5_1 = 10
      SLIME14 = 10
      SLIME15 = 10
      SLIME16 = 10
    }

    ceilings =
    {
      CEIL5_1 = 10
      CEIL3_1 = 20
      CEIL3_5 = 20
      FLAT5_4 = 20
      FLAT4   = 10
      FLAT5_5 = 5
      FLAT1   = 5
    }
  }


  tech_Sladwall =
  {
    env  = "building"
    prob = 20

    walls =
    {
      SLADWALL = 50
    }

    floors =
    {
      FLOOR5_1 = 50
      FLOOR0_1 = 40
      FLAT5    = 30
      FLOOR0_5 = 30
      SLIME15  = 20
      FLOOR3_3 = 10
    }

    ceilings =
    {
      CEIL3_2 = 30
      CEIL3_5 = 30
      FLAT1 = 30
      FLAT4 = 20
    }
  }


  tech_VeryShiny =
  {
    env = "building"
    prob = 10

    walls =
    {
      SHAWN2 = 50
    }

    floors =
    {
      FLAT1 = 60
      FLAT9 = 60
      FLOOR4_5 = 20
      CEIL5_1 = 20
    }

    ceilings =
    {
      FLAT23 = 50
    }
  }


  tech_VeryTekky =
  {
    env  = "building"
    prob = 10

    walls =
    {
      TEKWALL4 = 50
    }

    floors =
    {
      CEIL4_3  = 60
      FLOOR0_2 = 60
      FLOOR5_1 = 40
      SLIME14  = 20
      CEIL5_1  = 20
    }

    ceilings =
    {
      CEIL5_1 = 50
    }
  }


  tech_Cave =
  {
    env  = "cave"
    prob = 50

    naturals =
    {
      GRAYVINE = 50
      BROVINE2 = 10

      ZIMMER8  = 40
      ZIMMER7  = 20
      BROWN144 = 30
      BSTONE1  = 30

      ASHWALL2 = 20
      ASHWALL6 = 10
      TANROCK5 = 10

      STONE6   = 10
      TEKWALL4 = 10
    }
  }


  tech_Outdoors =
  {
    env  = "outdoor"
    prob = 50

    floors =
    {
      BROWN1 = 50
      BRICK12 = 20
      SLIME14 = 20
      SLIME16 = 20
      STONE3 = 40
      FLOOR4_8 = 10
      FLOOR5_4 = 20
      FLOOR5_4 = 20
    }

    naturals =
    {
      ASHWALL2 = 50
      ASHWALL4 = 50
      SP_ROCK1 = 50
      GRASS1   = 40

      ASHWALL6 = 20
      TANROCK4 = 15
      ZIMMER2  = 15
      ZIMMER4  = 15
      ZIMMER8  = 5
      ROCK5    = 20
    }
  }


  tech_Hallway =
  {
    env  = "hallway"
    prob = 50

    walls =
    {
      BROWNGRN = 90
      BROWN1   = 90
      GRAY1    = 70

      TEKWALL6 = 30
      TEKWALL4 = 10
      TEKGREN1 = 40
      STARGR1 = 10
      STARBR2 = 10

      BROWNPIP = 20
      PIPEWAL2 = 40
      PIPE2 = 15
      PIPE4 = 15
    }

    floors =
    {
      FLAT4  = 50
      FLAT14 = 50
      FLAT1  = 20
      FLOOR4_8 = 15
      FLOOR0_2 = 20
      CEIL4_1 = 20
    }

    ceilings =
    {
      CEIL3_5 = 50
      CEIL3_1 = 50
      RROCK03 = 50
      CEIL4_2 = 20
      CEIL5_1 = 40
    }
  }


----- HELL / GOTHIC -----------------------------


  hell_Marble =
  {
    env  = "building"
    prob = 100

    walls =
    {
      MARBLE1 = 20
      MARBLE2 = 50
      MARBLE3 = 50

      MARBGRAY = 80
    }

    floors =
    {
      DEM1_5   = 50
      DEM1_6   = 30
      FLAT10   = 25
      FLAT5_4  = 15
      FLOOR7_1 = 30
      FLOOR7_2 = 30
    }

    ceilings =
    {
      FLOOR7_2 = 50
      DEM1_5   = 20
      FLOOR6_1 = 20
      FLOOR6_2 = 20
      MFLR8_4  = 15
    }
  }


  hell_Hotbrick =
  {
    env  = "building"
    prob = 40

    walls =
    {
      SP_HOT1 = 50
    }

    floors =
    {
      FLAT5_3 = 30
      FLAT10 = 50
      FLAT1 = 20
      FLOOR7_1 = 50
      FLAT5_7 = 10
      FLAT5_8 = 10
      FLOOR6_1 = 10
      FLOOR6_2 = 5
    }

    ceilings =
    {
      FLOOR6_1 = 20
      FLOOR6_2 = 20
      FLAT10 = 15
      FLAT5_3 = 10
    }
  }


  hell_Stone =
  {
    env  = "building"
    prob = 60

    walls =
    {
      STONE3 = 50
      STONE2 = 10
    }

    floors =
    {
      FLOOR6_2 = 30
      RROCK13  = 30
      GRNROCK  = 30
      DEM1_6   = 30
      SLIME13  = 30
    }

    ceilings =
    {
      RROCK12  = 30
      RROCK03  = 30
      MFLR8_2  = 30
      FLAT5_1  = 30
    }
  }


  hell_Viney =
  {
    env  = "building"
    prob = 10

    walls =
    {
      GSTVINE2 = 50
      GSTVINE1 = 10
    }

    floors =
    {
      FLAT1 = 10
      FLOOR7_1 = 10
      DEM1_6 = 5
      DEM1_5 = 5
      FLOOR7_2 = 10
    }

    ceilings =
    {
      FLAT1 = 5
      FLOOR7_2 = 20
      FLOOR6_1 = 3
    }
  }


  hell_Wood =
  {
    env  = "building"
    prob = 15

    walls =
    {
      WOOD1 = 50
      WOOD3 = 30
      WOOD5 = 30
      WOOD12 = 30
      WOODVERT = 10
    }

    floors =
    {
      FLAT5_1 = 50
      FLAT5_2 = 50
      MFLR8_1 = 50
      FLOOR7_1 = 50
      FLAT5_4 = 30
      FLOOR4_6 = 10
    }

    ceilings =
    {
      FLOOR7_2 = 50
      RROCK14 = 40
      CEIL1_1 = 30
      FLAT5_2 = 10
      FLAT5_7 = 10
      FLOOR7_1 = 5
    }
  }


  hell_Skin =
  {
    env  = "building"
    prob = 10

    walls =
    {
      SKINMET1 = 50
      SKINMET2 = 50
      SKINCUT  = 5
      SKINSYMB = 5
    }

    floors =
    {
      SFLR6_1  = 10
      FLOOR7_1 = 20
      FLOOR6_1 = 40
    }

    ceilings =
    {
      SFLR6_1 = 30
      SFLR6_4 = 30
      FLAT5_3 = 7
      FLAT5_4 = 5
      FLOOR7_2 = 10
      DEM1_5 = 10
    }
  }


  hell_Hallway =
  {
    env  = "hallway"
    prob = 50

    walls =
    {
      MARBGRAY = 80
      REDWALL  = 60
      SKIN2    = 60

      GSTVINE1 = 40
      GSTVINE2 = 40
      GSTONE1  = 20
      SKINMET1 = 10
      SKINMET2 = 10
    }

    floors =
    {
      FLAT1 = 50
      DEM1_6  = 30
      FLOOR6_2 = 15
      FLOOR7_1 = 20
      FLOOR7_2 = 25
      FLAT10  = 20
    }

    ceilings =
    {
      FLAT1 = 50
      SFLR6_1 = 20
      SFLR6_4 = 20
      FLAT5_2 = 10
      FLOOR7_2 = 20
      CEIL1_1 = 15
    }
  }


  hell_Cave =
  {
    env  = "cave"
    prob = 50

    naturals =
    {
      ROCKRED1 = 40
      SP_ROCK1 = 30
      GSTVINE1 = 30

      ASHWALL2 = 30
      RROCK04  = 20
      STONE    = 10

      FIRELAVA = 10
      FIREBLU1 = 10
      SKINEDGE = 10
      CRACKLE4 = 10
      SKSNAKE1 = 10
    }
  }


  hell_Outdoors =
  {
    env  = "outdoor"
    prob = 50

    floors =
    {
      FLOOR6_2 = 10
      FLAT5_7 = 20
      FLAT5_8 = 10
      RROCK03 = 30
      RROCK04 = 30
      RROCK09 = 15
    }

    naturals =
    {
      ROCKRED1 = 50
      SP_ROCK1 = 30
      ASHWALL2 = 30
      ASHWALL3  = 25
      ASHWALL6  = 20
      ASHWALL7  = 15
      ASHWALL4 = 30
      SKIN2 = 10
      SKSNAKE1 = 30
      SKSNAKE2 = 30
    }
  }


----  URBAN / CITY / EARTH  -----------------------


  urban_Brick =
  {
    env  = "building"
    prob = 100

    walls =
    {
      BIGBRIK1 = 80
      BIGBRIK2 = 80

      BRICK12 = 60
      BRICK5  = 40
      BRICK7  = 40

      BRICK2  = 20
      BRICK1  = 10
      BRICK9  = 10
    }

    floors =
    {
      FLAT1_1 = 50
      FLAT1   = 30
      FLAT5   = 15
      FLAT5_1 = 50
      FLAT5_2 = 20
      FLAT5_2 = 30
      FLAT5_4 = 20
      FLAT5_5 = 30
      FLAT8   = 50

      FLOOR0_1 = 20
      FLOOR0_2 = 20
      FLOOR0_3 = 20
      FLOOR4_6 = 20
      FLOOR5_3 = 25
      FLOOR5_4 = 10
    }

    ceilings =
    {
      FLAT1   = 50
      FLAT5_4 = 20
      FLAT8   = 15
      RROCK10 = 20
      RROCK14 = 20
      MFLR8_1 = 10
      SLIME13 = 5
    }
  }


  urban_Panel =
  {
    env  = "building"
    prob = 50

    walls =
    {
      PANEL6 = 50
      PANEL8 = 50
      PANEL9 = 30
      PANEL7 = 20
      PANEL3 = 50
      PANEL2 = 50
      PANCASE2 = 30
    }

    floors =
    {
      FLOOR0_2 = 15
      FLOOR5_3 = 20
      FLOOR5_4 = 15
      FLAT1_1 = 50
      FLAT1 = 30
      FLAT8 = 10
      FLAT5_5 = 30
      FLAT5 = 20
    }

    ceilings =
    {
      FLAT1 = 50
      CEIL1_1 = 20
      FLAT5_2 = 20
      CEIL3_3 = 10
      RROCK10 = 20
    }
  }


  urban_Stone =
  {
    env  = "building"
    prob = 50

    walls =
    {
      STONE2 = 50
      STONE3 = 50
      ROCK1  = 10
      ROCK3  = 10
    }

    floors =
    {
      FLAT1_2 = 50
      FLAT5_2 = 50
      FLAT1 = 50
      FLAT8 = 20
      FLAT5_4 = 35
      FLAT5_5 = 20
      FLAT5_1 = 50
      SLIME15 = 15
    }

    ceilings =
    {
      FLAT1 = 50
      CEIL1_1 = 20
      CEIL3_5 = 25
      MFLR8_1 = 30
      FLAT5_4 = 20
    }
  }


  urban_RedBrick =
  {
    env  = "building"
    prob = 20

    walls =
    {
      BRICK11 = 50
    }

    floors =
    {
      RROCK14  = 40
      MFLR8_2  = 40
      FLAT1_1  = 40
      FLOOR3_3 = 20
      FLOOR5_4 = 20
      FLOOR6_2 = 10
    }

    ceilings =
    {
      FLOOR6_1 = 30
      FLAT5_1  = 20
      CEIL3_5  = 20
      FLAT8    = 10
    }
  }


  urban_GreenBrick =
  {
    env  = "building"
    prob = 20

    walls =
    {
      BRICK10 = 50
    }

    floors =
    {
      RROCK14  = 40
      MFLR8_1  = 40
      FLAT5_8  = 30
      FLAT1    = 20
      FLOOR7_1 = 10
      FLOOR3_3 = 10
    }

    ceilings =
    {
      GRNROCK  = 40
      FLOOR7_2 = 20
      FLAT10   = 20
      CEIL3_5  = 20
      CEIL5_1  = 20
      FLAT8    = 10
    }
  }


  urban_Cement =
  {
    env  = "building"
    prob = 20

    walls =
    {
      CEMENT7 = 50
    }

    floors =
    {
      FLAT1    = 40
      FLAT3    = 40
      FLAT10   = 20
      FLOOR3_3 = 20
      FLOOR6_2 = 20
      MFLR8_2  = 20
    }

    ceilings =
    {
      RROCK13  = 30
      MFLR8_1  = 30
      SLIME13  = 20
      FLOOR7_1 = 10
      FLAT4    = 10
    }
  }


  -- TODO : this is same as hell_Wood, differentiate it...
  urban_Wood =
  {
    env  = "building"
    prob = 20

    walls =
    {
      WOOD1 = 50
      WOOD3 = 30
      WOOD5 = 30
      WOOD12 = 30
      WOODVERT = 10
    }

    floors =
    {
      FLAT5_1 = 50
      FLAT5_2 = 50
      MFLR8_1 = 50
      FLOOR7_1 = 50
      FLAT5_4 = 30
      FLOOR4_6 = 10
    }

    ceilings =
    {
      FLOOR7_2 = 50
      RROCK14 = 40
      CEIL1_1 = 30
      FLAT5_2 = 10
      FLAT5_7 = 10
      FLOOR7_1 = 5
    }
  }


  urban_Stucco =
  {
    env  = "building"
    prob = 10

    walls =
    {
      STUCCO3 = 60
      STUCCO1 = 30
    }

    floors =
    {
      FLAT8    = 20
      FLOOR4_6 = 20
      FLOOR5_4 = 20

      FLAT9    = 30
      CEIL3_5  = 30
      MFLR8_2  = 20
      FLOOR1_6 = 10
    }

    ceilings =
    {
      CEIL1_1  = 30
      FLAT5_5  = 10

      CEIL1_5  = 30
      FLAT19   = 30
      RROCK03  = 10
    }
  }


  urban_Hallway =
  {
    env  = "hallway"
    prob = 50

    walls =
    {
      WOOD1    = 90
      WOOD12   = 90
      WOOD9    = 90
      WOODVERT = 90

      BIGBRIK1 = 50
      BIGBRIK2 = 50
      BRICK10  = 50
      BRICK11  = 10

      PANEL1   = 50
      PANEL7   = 30
      STUCCO   = 30
      STUCCO1  = 30
      STUCCO3  = 30
    }

    floors =
    {
      FLAT5_1 = 50
      FLAT5_2 = 20
      FLAT8   = 50
      FLAT5_4 = 50
      MFLR8_1 = 50
      FLOOR5_3 = 20
      FLAT5 = 20
    }

    ceilings =
    {
      CEIL1_1 = 30
      FLAT5_2 = 25
      CEIL3_5 = 20
      MFLR8_1 = 50
      FLAT1   = 30
    }
  }


  urban_Cave =
  {
    env  = "cave"
    prob = 50

    naturals =
    {
      ROCK2    = 40
      ASHWALL2 = 40
      ASHWALL4 = 30
      ZIMMER1  = 30

      BSTONE2  = 10
      ZIMMER5  = 20
      ZIMMER3  = 20

      STONE5   = 10
      ASHWALL7 = 10
      ROCK5    = 10
      WOOD9    = 10
    }
  }


  urban_Outdoors =
  {
    env  = "outdoor"
    prob = 50

    floors =
    {
      STONE = 50
      FLAT5_2 = 50
    }

    naturals =
    {
      ASHWALL2 = 50
      ASHWALL4 = 50
      BSTONE1  = 15
      ZIMMER5  = 15
      ROCK3    = 70
    }
  }

}


--------------------------------------------------------------------

DOOM.ROOMS =
{
  GENERIC =
  {
    env = "any"
  }


  ---- Indoors ----

  COMPUTER =
  {
    theme = "tech"
    prob  = 50
  }

  STORAGE =
  {
    prob  = 50
  }

  WASTE =
  {
    theme = "!hell"
    style = "liquids"
    prob  = 50
  }

  PRISON =
  {
    style = "cages"
    prob  = 50
  }

  TORTURE =
  {
    theme = { hell=1, urban=0.2 }
    prob  = 50
  }

  CHAPEL =
  {
    theme = "hell"
    prob  = 15
  }

  LIBRARY =
  {
    theme = "urban"
    prob  = 15
  }


  ---- Outdoors ----

  LAUNCH =
  {
    env = "outdoor"
    theme = "tech"
    prob = 10
  }

  GARDEN =
  {
    env = "outdoor"
    theme = "urban"
    prob = 50
  }

  GRAVEYARD =
  {
    env = "outdoor"
    theme = { hell=1, urban=0.4 }
    prob = 20
  }
}


--------------------------------------------------------------------

DOOM.NAMES =
{
  -- these tables provide *additional* words to those in naming.lua

  TECH =
  {
    lexicon =
    {
      a =
      {
        Deimos=40
        Phobos=40
        Ganymede=20
        Io=20
        Europa=20
        ["Tei Tenga"]=25
      }

      b =
      {
        UAC=30
      }

      s =
      {
        ["UAC Crisis"]=30
      }
    }
  }
}


--------------------------------------------------------------------

OB_THEMES["tech"] =
{
  label = _("Tech")
  game = { doom1=1, doom2=1 }
  priority = 18
  name_class = "TECH"
  mixed_prob = 80
}


OB_THEMES["hell"] =
{
  label = _("Hell")
  game = { doom1=1, doom2=1 }
  priority = 14
  name_class = "GOTHIC"
  mixed_prob = 40
}


OB_THEMES["urban"] =
{
  label = _("Urban")
  game = "doom2"
  priority = 16
  name_class = "URBAN"
  mixed_prob = 50
}


OB_THEMES["mostly_tech"] =
{
  label = _("Mostly Tech")
  game = { doom1=1, doom2=1 }
  priority = 8
  name_class = "TECH"
}


OB_THEMES["mostly_urban"] =
{
  label = _("Mostly Urban")
  game = "doom2"
  priority = 4
  name_class = "URBAN"
}


OB_THEMES["mostly_hell"] =
{
  label = _("Mostly Hell")
  game = { doom1=1, doom2=1 }
  priority = 6
  name_class = "HELL"
}

