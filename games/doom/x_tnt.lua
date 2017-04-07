--------------------------------------------------------------------
--  TNT Evilution
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

TNT = { }


TNT.PARAMETERS =
{
  bex_map_prefix  = "THUSTR_"

  bex_secret_name  = "T5TEXT"
  bex_secret2_name = "T6TEXT"
}


TNT.MATERIALS =
{
  TNTDOOR  = { t="TNTDOOR",  f="FLAT23" }
  DOC1     = { t="DOC1",     f="FLAT23" }
  DISASTER = { t="DISASTER", f="FLOOR7_1" }
  MTNT1    = { t="MTNT1",    f="FLOOR7_2" }

  BTNTSLVR = { t="BTNTSLVR", f="FLAT23" }
  BTNTMETL = { t="BTNTMETL", f="CEIL5_2" }
  CUBICLE  = { t="CUBICLE",  f="CEIL5_1" }
  M_TEC    = { t="M_TEC",    f="CEIL5_2" }
  YELMETAL = { t="YELMETAL", f="CEIL5_2" }

  METALDR  = { t="METALDR",  f="CEIL5_2" }
  METAL_BD = { t="METAL-BD", f="CEIL5_2" }
  METAL_RM = { t="METAL-RM", f="CEIL5_2" }
  METAL2BD = { t="METAL2BD", f="CEIL5_2" }

  M_RDOOR  = { t="M_RDOOR",  f="FLOOR7_1" }
  M_YDOOR  = { t="M_RDOOR",  f="FLOOR7_1" }

  CAVERN1  = { t="CAVERN1",  f="RROCK17" }
  CAVERN4  = { t="CAVERN4",  f="MFLR8_3" }
  CAVERN6  = { t="CAVERN6",  f="RROCK17" }
  CAVERN7  = { t="CAVERN7",  f="RROCK16" }

  ASPHALT  = { t="ASPHALT",  f="MFLR8_4" }
  SMSTONE6 = { t="SMSTONE6", f="RROCK09" }
  STONEW1  = { t="STONEW1",  f="RROCK09" }
  STONEW5  = { t="STONEW5",  f="MFLR8_3" }

  -- All the crates here! --

  -- 64x64 etc
  CR64LB  = { t="CR64LB",  f="CRATOP2" }
  CRLWDS6 = { t="CRLWDS6", f="CRATOP2" } --64x32, not really useful

  -- 64x128
  CRBLWDH6 = { t="CRBLWDH6", f="CRATOP2" }
  CRBWDH64 = { t="CRBWDH64", f="FLAT5_2" }
  CRLWDL6B = { t="CRLWDL6B", f="CRATOP2" }
  CR64HBRM = { t="CR64HBRM", f="CRATOP2" }
  CR64HBBP = { t="CR64HBBP", f="CRATOP2" }
  CR64HGBP = { t="CR64HGBP", f="CRATOP1" }
  CR64SLGB = { t="CR64SLGB", f="CRATOP1" }
  CR64HBG  = { t="CR64HBG",  f="CRATOP2" }
  CR64HBB  = { t="CR64HBB",  f="CRATOP2" }
  CR64HGB  = { t="CR64HGB",  f="CRATOP1" }
  CR64HGG  = { t="CR64HGG",  f="CRATOP1" }
  CRSMB    = { t="CRSMB",    f="CRATOP2" }
  CRWDL64A = { t="CRWDL64A", f="FLAT5_2" }
  CRWDL64B = { t="CRWDL64B", f="FLAT5_2" }
  CRWDL64C = { t="CRWDL64C", f="FLAT5_2" }
  CRWDT32  = { t="CRWDT32",  f="FLAT5_2" }
  CRWDH64  = { t="CRWDH64",  f="FLAT5_2" }
  CRWDH64B = { t="CRWDH64B", f="FLAT5_2" }
  CRWDS64  = { t="CRWDH64",  f="FLAT5_2" }
  CRLWDH6B = { t="CRLWDH6B", f="CRATOP2" }
  CRLWDL6  = { t="CRLWDL6",  f="CRATOP2" }
  CRLWDL6E = { t="CRLWDL6E", f="CRATOP2" }
  CRLWDL6C = { t="CRLWDL6C", f="CRATOP2" }
  CRLWDL6D = { t="CRLWDL6D", f="CRATOP2" }
  CRTINYB  = { t="CRTINYB",  f="CRATOP2" }
  CRLWDH6  = { t="CRLWDH6",  f="CRATOP2" }
  CR64LG   = { t="CR64LG",   f="CRATOP1" }
  CRLWDVS  = { t="CRLWDVS",  f="CRATOP2" }

  -- 128x64
  CR128LG  = { t="CR128LG",  f="CRATOP2" }
  CRBWLBP  = { t="CRBWLBP",  f="CRATOP2" }
  CR128LB  = { t="CR128LB",  f="CRATOP2" }

  -- 128x128
  CRWDL128 = { t="CRWDL128", f="FLAT5_2" }
  CRAWHBP  = { t="CRAWHBP",  f="CRATOP1" }
  CRAWLBP  = { t="CRAWLBP",  f="CRATOP2" }
  CRBWHBP  = { t="CRBWHBP",  f="CRATOP1" }
  CRLWDL12 = { t="CRLWDL12", f="CRATOP2" }
  CRBWDL12 = { t="CRBWDL12", f="FLAT5_2" }
  CR128HGB = { t="CR128HGB", f="CRATOP1" }

  DOGRMSC  = { t="DOGRMSC",  f="RROCK20" }
  DOKGRIR  = { t="DOKGRIR",  f="RROCK09" }
  DOKODO1B = { t="DOKODO1B", f="FLAT5" }
  DOKODO2B = { t="DOKODO2B", f="FLAT5" }
  DOKGRIR  = { t="DOKGRIR",  f="RROCK20" }
  DOPUNK4  = { t="DOPUNK4",  f="CEIL5_1" }
  DORED    = { t="DORES",    f="CEIL5_1" }

  PNK4EXIT = { t="PNK4EXIT", f="CEIL5_1" }

  LITEGRN1 = { t="LITEGRN1", f="FLAT1" }
  LITERED1 = { t="LITERED1", f="FLAT1" }
  LITERED2 = { t="LITERED2", f="FLAT23" }
  LITEYEL1 = { t="LITEYEL1", f="CEIL5_1" }
  LITEYEL2 = { t="LITEYEL2", f="FLAT23" }
  LITEYEL3 = { t="LITEYEL3", f="FLAT23" }

  EGGREENI = { t="EGGREENI", f="RROCK20" }
  EGREDI   = { t="EGREDI",   f="FLAT5_3" }
  ALTAQUA  = { t="ALTAQUA",  f="RROCK20" }

  -- Egypt stuff --

  BIGMURAL = { t="BIGMURAL", f="FLAT1_1" }
  MURAL1   = { t="MURAL1",   f="FLAT1_1" }
  MURAL2   = { t="MURAL2",   f="FLAT1_1" }

  PILLAR   = { t="PILLAR",   f="FLAT1_1" }
  BIGWALL  = { t="BIGWALL",  f="FLAT8"   } --256x128, Egyptian mural decor
  DRSIDE1  = { t="DRSIDE1",  f="FLAT1_1" } --32x128, useful for small supports, doesn't tile too well
  DRSIDE2  = { t="DRSIDE2",  f="FLAT1_1" } --32x128, useful for small supports, doesn't tile too well
  DRTOPFR  = { t="DRTOPFR",  f="FLAT1_1" } --32x65
  DRTOPSID = { t="DRTOPSID", f="FLAT1_1" } --32x65
  LONGWALL = { t="LONGWALL", f="FLAT1_1" } --256x128, Anubis mural
  SKIRTING = { t="SKIRTING", f="FLAT1_1" } --256x43, Egyptian hieroglyphics
  STWALL   = { t="STWALL",   f="CRATOP2" }
  DRFRONT  = { t="DRFRONT",  rail_h=128  } --Transparent in center, not really useful

  -- Transparent openings --

  GRNOPEN = { t="GRNOPEN", rail_h=128 } --SP_ROCK1 64x128 opening
  REDOPEN = { t="REDOPEN", rail_h=128 } --ROCKRED 64x128 opening
  BRNOPEN = { t="BRNOPEN", rail_h=128 } --STONE6 64x128 opening

  -- Rails --

  DOGRID   = { t="DOGRID",   rail_h=128 }
  DOWINDOW = { t="DOWINDOW", rail_h=68 } --Yea, it's 64x68
  DOGLPANL = { t="DOGLPANL", rail_h=128 }
  DOBWIRE  = { t="DOBWIRE",  rail_h=128 }
  DOBWIRE2 = { t="DOBWIRE2", rail_h=128 } --Has no real use, no X flipped variant
  SMGLASS1 = { t="SMGLASS",  rail_h=128  }
  TYIRONLG = { t="TYIRONLG", rail_h=128 }
  TYIRONSM = { t="TYIRONSM", rail_h=72  }
  WEBL = { t="WEBL", rail_h=128 } --Not really useful
  WEBR = { t="WEBR", rail_h=128 } --Not really useful

  -- Overrides for existing DOOM materials --

  SUPPORT3 = { t="EGSUPRT3", f="CEIL5_2" }
  ASHWALL2 = { t="ASPHALT",  f="MFLR8_4" }
  MFLR8_4  = { t="ASPHALT",  f="MFLR8_4" }
  FLAT8    = { f="FLAT8",    t="DOKODO1B" }

  BIGDOOR2 = { t="METALDR",  f="CEIL5_2" }
  BIGDOOR3 = { t="METALDR",  f="CEIL5_2" }
  BIGDOOR4 = { t="METALDR",  f="CEIL5_2" }
}


TNT.THEMES =
{
  egypt =
  {
    liquids =
    {
      slime = 60
      blood = 30
      water = 20
      lava  = 10
    }

    entity_remap =
    {
      k_red    = "ks_red"
      k_blue   = "ks_blue"
      k_yellow = "ks_yellow"
    }

    facades =
    {
      SMSTONE6 = 30
      STONEW1  = 20
      STWALL   = 20
      CAVERN1  = 10

      BIGBRIK1 = 30
      BSTONE2  = 20
      BRICK4   = 10
    }

    prefab_remap =
    {
      DOORBLU  = "DOORBLU2"
      DOORRED  = "DOORRED2"
      DOORYEL  = "DOORYEL2"

      SILVER3  = "MURAL1"
      GATE3    = "FLAT22"
      GATE4    = "FLAT22"
      REDWALL  = "DOKGRIR"
      SW1COMP  = "SW1CMT"
    }

    window_groups =
    {
      round  = 90
      barred = 60
      grate  = 30
    }

    outdoor_torches =
    {
      blue_torch = 50
      green_torch = 50
      red_torch = 50
      candelabra = 20
    }

--Mostly based on what is seen in TNT.WAD MAP31
    monster_prefs =
    {
      gunner = 1.2
      mancubus = 1.3
      demon   = 1.5
    }

    archy_arches = true

--Any rocky/stonelike/metal doors (IE METALDR) would do great for this theme -Chris

  }
}



TNT.ROOM_THEMES =
{
  egypt_Tomb =
  {
    env  = "building"
    prob = 50

    walls =
    {
      STWALL  = 30
      BIGWALL = 20
      STONEW1 = 20
      STONEW5 = 10
      LONGWALL = 5

      BRICK7   = 30
      BRICK4   = 20
      BRICK5   = 10
    }

    floors =
    {
      RROCK14  = 20
      FLAT1_2  = 20
      FLOOR5_4 = 20
      MFLR8_1  = 20

      FLAT5_5 = 10
      RROCK12 = 10
      FLAT8   = 10
      SLIME13 = 10
    }

    ceilings =
    {
      FLAT8    = 20
      FLAT1_1  = 20
      FLOOR6_2 = 20

      RROCK11 = 10
      RROCK12 = 10
      RROCK15 = 10
      CEIL1_1 = 5
    }
  }


  egypt_Hallway =
  {
    env  = "hallway"
    prob = 50

    walls =
    {
      STWALL = 30
      MURAL1 = 15
      MURAL2 = 15
      STONE6 = 10
      BIGMURAL = 5
    }

    floors =
    {
      FLAT5 = 30
      FLAT1_1 = 30
      FLAT1_2 = 30
      FLAT8   = 20
      FLOOR5_3 = 20
    }

    ceilings =
    {
      FLAT5 = 20
      FLAT1_1 = 20
      FLAT1_2 = 20
      FLAT8   = 20
      RROCK12 = 20
      RROCK15 = 20
      CEIL1_1 = 20
    }
  }


  egypt_Outdoors =
  {
    env  = "outdoor"
    prob = 50

    floors =
    {
      RROCK09 = 30
      RROCK16 = 30
      RROCK13 = 20
      RROCK04 = 20
      MFLR8_3 = 20
      RROCK03 = 10
      RROCK19 = 10
    }

    naturals =
    {
      ROCK3 = 25
      ROCK4 = 25
      ROCK5 = 25
    }
  }


  egypt_Cave =
  {
    env  = "cave"
    prob = 50

    walls =
    {
      ALTAQUA  = 20
      ASHWALL7 = 20
      TANROCK7 = 20
      TANROCK8 = 20

      ROCK4   = 20
      BSTONE1 = 20
      STONE6  = 20
    }

    floors =
    {
      BSTONE1 = 20
      FLAT10  = 20
      STONE4  = 20

      SP_ROCK1 = 20 -- MFLR8_3
      RROCK18  = 20
      ASHWALL2 = 10
    }
  }
}


TNT.EPISODES =
{
  episode1 =
  {
    theme = "tech"
    sky_patch  = "DOEDAY"
    sky_patch2 = "DONDAY"
    sky_patch3 = "DOWDAY"
    sky_patch4 = "DOSDAY"
    dark_prob = 10
    bex_mid_name = "T1TEXT"
    bex_end_name = "T2TEXT"
  }

  episode2 =
  {
    theme = "urban"
    sky_patch  = "DOENITE"
    sky_patch2 = "DONNITE"
    sky_patch3 = "DOWNITE"
    sky_patch4 = "DOSNITE"
    dark_prob = 80
    bex_end_name = "T3TEXT"
  }

  episode3 =
  {
    theme = "hell"
    sky_patch  = "DOEHELL"
    sky_patch2 = "DONHELL"
    sky_patch3 = "DOWHELL"
    sky_patch4 = "DOSHELL"
    dark_prob = 10
    bex_end_name = "T4TEXT"
  }
}


--------------------------------------------------------------------

OB_GAMES["tnt"] =
{
  label = _("TNT Evilution")

  extends = "doom2"

  iwad_name = "tnt.wad"

  tables =
  {
    TNT
  }
}


OB_THEMES["egypt"] =
{
  -- TNT Evilution theme

  label = _("Egypt")
  game = "tnt"
  priority = 3
  name_class = "GOTHIC"
  mixed_prob = 5
  bit_limited = true
}

