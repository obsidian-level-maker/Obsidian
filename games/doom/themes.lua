--------------------------------------------------------------------
--  DOOM THEMES
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2014 Andrew Apted
--  Copyright (C) 2011,2014 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.THEMES =
{
  DEFAULTS =
  {
    keys =
    {
      kc_red    = 50
      kc_blue   = 50
      kc_yellow = 50
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
      SP_ROCK1 =  5
    }
  }


  generic_Stairwell =
  {
    kind = "stairwell"

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
  }


-----  TECH BASE  --------------------------------

  tech_DEFAULTS =
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

    base_skin =
    {
      big_door = "BIGDOOR3"
    }

    style_list =
    {
      naturals = { none=30, few=70, some=30, heaps=2 }
    }

    techy_doors = true


    ---!!!  TEMPORARY V3 STUFF  !!!---

    steps = { step1=50, step3=50, step4b=50 }
    lifts = { shiny=20, platform=40, rusty=10 }
    ceil_lights =
    {
      TLITE6_5=50, TLITE6_6=30, TLITE6_1=30, FLOOR1_7=30
      FLAT2=20,    CEIL3_4=10,  FLAT22=10
      GRNLITE1=10
    }
    big_lights =
    {
      TLITE6_5=30, TLITE6_6=30, GRNLITE1=30, FLAT17=30, CEIL3_4=30
      GRNLITE1=20
    }
    pillars = { metal1=70, tekwall4=20
                teklite=50, silver2=10, shawn2=10, metal1=15 }
    big_pillars = { big_red=50, big_blue=50 }
    crates = { crate1=50, crate2=50, comp=70, lite5=20
               space=90, mod=15 }
    exits = { skull_pillar=50, stone_pillar=5 }
  }


  tech_Startan =
  {
    prob = 50
    kind = "building"

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


  fixme_tech_Stargray =
  {
    rarity = "minor"

    prob = 50
    kind = "building"

    walls =
    {
      STARGR2 = 50
      STARGR1 = 50
      SHAWN2 = 5
    }

    floors =
    {
      FLOOR4_8 = 50
      FLOOR5_1 = 20
      FLOOR5_3 = 30
      FLOOR3_3 = 20
      FLOOR0_3 = 30
      FLOOR0_5 = 15
      SLIME15 = 10
      SLIME16 = 10
      FLAT4 = 15
    }

    ceilings =
    {
      CEIL3_5 = 20
      CEIL3_1 = 20
      FLAT4 = 20
      CEIL4_3 = 10
      FLAT23 = 10
      FLAT9 = 20
      SLIME14 = 10
    }
  }


  tech_Tekgren =
  {
    kind = "building"
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
    prob = 50
    kind = "building"

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
    prob = 25
    kind = "building"

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


  tech_Cave =
  {
    kind = "cave"

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
      TANROCK2 = 10
      TANROCK5 = 10

      STONE6   = 10
      TEKWALL4 = 10
    }
  }


  tech_Outdoors =
  {
    kind = "outdoors"

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
    kind = "hallway"

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


  hell_DEFAULTS =
  {
    liquids =
    {
      lava   = 70
      blood  = 40
      nukage = 5
    }

    keys =
    {
      ks_red  = 50
      ks_blue = 50
      ks_yellow = 50
    }

    facades =
    {
      MARBLE2  = 50
      SP_HOT1  = 50
      MARBGRAY = 30
      STONE3   = 30
      GSTVINE1 = 20
      GSTVINE2 = 20
      BRONZE1  = 5
      BROWN1   = 5
    }

    base_skin =
    {
      big_door = "BIGDOOR7"

      grass = "ASHWALL2"
    }

    monster_prefs =
    {
      zombie  = 0.3
      shooter = 0.6
      vile    = 1.3
      skull   = 2.0
    }

    archy_arches = true


    ---!!!  TEMPORARY V3 STUFF  !!!---

    exits = { skin_pillar=40, skull_pillar=20
             demon_pillar2=10, demon_pillar3=10 }
    steps = { step1=50, step3=50, step4=50 }
    lifts = { platform=10, rusty=50, spine=30 }
    big_pillars = { big_red=50, sloppy=20, sloppy2=20, }
  }


  hell_Marble =
  {
    prob = 100
    kind = "building"

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
    prob = 100
    kind = "building"

    walls =
    {
      SP_HOT1 = 50

      -- TODO: need more
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


  -- Hmmm, probably better as a 'speciality' theme...
  hell_Viney =
  {
    prob = 20
    kind = "building"

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


  hell_Stone =
  {
    prob = 50
    kind = "building"

    walls =
    {
      STONE3 = 50
      STONE2 = 10
    }

    floors =
    {
      FLAT1 = 10
      FLAT5_4 = 5
    }

    ceilings =
    {
      FLAT1 = 10
      FLAT5_4 = 3
    }
  }


  -- TODO: this also probably better as 'speciality' theme
  hell_Wood =
  {
    prob = 40
    kind = "building"

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
      FLAT5_1 = 30
      FLAT5_2 = 30
      FLAT5 = 5
      FLOOR4_6 = 3
    }

    ceilings =
    {
      CEIL1_1 = 30
      FLAT5_2 = 10
      FLOOR7_1 = 5
    }
  }


  hell_Skin =
  {
    prob = 20
    kind = "building"

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
    kind = "hallway"

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
    kind = "cave"

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
    kind = "outdoors"

    floors =
    {
      FLOOR6_2 = 10
      FLAT5_7 = 20
      FLAT5_8 = 10
      RROCK03 = 30  -- REMOVE
      RROCK04 = 30  -- REMOVE
      RROCK09 = 15  -- REMOVE
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


  urban_DEFAULTS =
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
      BIGBRIK1 = 30
      BIGBRIK2 = 15
      BLAKWAL2 = 10
      MODWALL1 = 20
      MODWALL3 = 10
      CEMENT7 = 5
      CEMENT9 = 5
      METAL2 = 3
    }

    outdoor_torches =
    {
      blue_torch = 50
      candelabra = 30
      skull_rock = 30
      burning_barrel = 10
    }

    base_skin =
    {
    }

    monster_prefs =
    {
      revenant = 1.2
      knight   = 1.5
      gunner   = 1.5
    }

    archy_arches = true


    ---!!!  TEMPORARY V3 STUFF  !!!---

    exits = { demon_pillar2=20, demon_pillar3=20, stone_pillar=30 }
    steps = { step6=50, }
    lifts = { shiny=20, platform=20, rusty=50 }
    big_pillars = { big_slad=30, big_wood6=30, big_garg=60 }
  }


  urban_Panel =
  {
    kind = "building"
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
      FLAT4 = 50
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


  urban_Brick =
  {
    kind = "building"
    prob = 70

    walls =
    {
      BRICK1  = 10
      BRICK2  = 15
      BRICK5  = 50
      BRICK6  = 20
      BRICK7  = 30
      BRICK8  = 15
      BRICK9  = 20
      BRICK12 = 30
      BRICK11 = 3
      BRICK10 = 5

      BIGBRIK1 = 90
      BIGBRIK2 = 90
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


  urban_Stone =
  {
    kind = "building"
    prob = 20

    walls =
    {
      STONE2 = 50
      STONE3 = 50
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


  urban_Hallway =
  {
    kind = "hallway"

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
    kind = "cave"

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
    kind = "outdoors"

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


----  Wolfenstein 3D Secret Levels  ------------


  wolf_DEFAULTS =
  {
    prob = 10

    square_caves = 1

    facades =
    {
      ZZWOLF1  = 50
      ZZWOLF9  = 50
      ZZWOLF11 = 20
      ZZWOLF5  = 5
    }

    monster_prefs =
    {
      ss_nazi = 100
      zombie  = 20
      shooter = 20
      demon   = 20  -- kinda like a dog
      imp     =  5  -- kinda like a mutant
    }

    base_skin =
    {
      big_door = "ZELDOOR"
    }

    style_list =
    {
      caves = { none=40, few=60, some=10 }
    }
  }


  wolf_Cells =
  {
    kind = "building"

    walls =
    {
      ZZWOLF9 = 50
    }

    floors =
    {
      FLAT1 = 50
    }

    ceilings =
    {
      FLAT1 = 50
    }
  }


  wolf_Stone =
  {
    kind = "building"

    walls =
    {
      ZZWOLF1 = 50
    }

    floors =
    {
      FLAT1 = 50
      MFLR8_1 = 50
    }

    ceilings =
    {
      FLAT1 = 50
    }
  }


  wolf_Brick =
  {
    kind = "building"

    walls =
    {
      ZZWOLF11 = 50
    }

    floors =
    {
      FLAT1 = 50
    }

    ceilings =
    {
      FLAT5_3 = 30
    }
  }


  wolf_Hallway =
  {
    kind = "hallway"

    walls =
    {
      ZZWOLF5 = 50
    }

    floors =
    {
      CEIL5_1 = 50
    }

    ceilings =
    {
      CEIL1_1 = 50
      FLAT5_1 = 50
    }
  }


  wolf_Outdoors =
  {
    kind = "outdoors"

    floors =
    {
      MFLR8_1 = 20
      FLAT1_1 = 10
      RROCK13 = 20
    }

    naturals =
    {
      ROCK4 = 50
      SP_ROCK1 = 10
    }
  }


  wolf_Cave =
  {
    kind = "cave"

    square_caves = true

    naturals =
    {
      ROCK4 = 50
      SP_ROCK1 = 10
    }
  }
}


--------------------------------------------------------------------

DOOM.ROOMS =
{
  GENERIC =
  {
    environment = "any"
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
    theme = { hell=1, wolf=0.5, urban=0.2 }
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
    environment = "outdoor"
    theme = "tech"
    prob = 10
  }

  GARDEN =
  {
    environment = "outdoor"
    theme = "urban"
    prob = 50
  }

  GRAVEYARD =
  {
    environment = "outdoor"
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

OB_THEMES["doom/tech"] =
{
  label = "Tech"
  priority = 18
  name_class = "TECH"
  mixed_prob = 80
}


OB_THEMES["doom/hell"] =
{
  label = "Hell"
  priority = 14
  name_class = "GOTHIC"
  mixed_prob = 40
}


OB_THEMES["doom/urban"] =
{
  label = "Urban"
  priority = 16
  game = "doom2"
  name_class = "URBAN"
  mixed_prob = 50
}


OB_THEMES["doom/mostly_tech"] =
{
  label = "Mostly Tech"
  priority = 8
  name_class = "TECH"
}


OB_THEMES["doom/mostly_urban"] =
{
  label = "Mostly Urban"
  priority = 4
  game = "doom2"
  name_class = "URBAN"
}


OB_THEMES["doom/mostly_hell"] =
{
  label = "Mostly Hell"
  priority = 6
  name_class = "HELL"
}


OB_THEMES["doom/wolf"] =
{
  label = "Wolfenstein"
  priority = 2
  game = "doom2"
  name_class = "URBAN"

  -- this theme is special, hence no mixed_prob
}

