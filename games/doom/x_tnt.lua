--------------------------------------------------------------------
--  TNT Evilution
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C) 2011-2022 Reisal
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

TNT = { }


TNT.PARAMETERS =
{
  bex_map_prefix  = "THUSTR_",

  bex_secret_name  = "T5TEXT",
  bex_secret2_name = "T6TEXT",
}


TNT.MATERIALS =
{
  TNTDOOR  = { t="TNTDOOR",  f="FLAT23" },
  DOC1     = { t="DOC1",     f="FLAT23" },
  DISASTER = { t="DISASTER", f="FLOOR7_1" },
  MTNT1    = { t="MTNT1",    f="FLOOR7_2" },

  BTNTSLVR = { t="BTNTSLVR", f="FLAT23" },
  BTNTMETL = { t="BTNTMETL", f="CEIL5_2" },
  CUBICLE  = { t="CUBICLE",  f="CEIL5_1" },
  M_TEC    = { t="M_TEC",    f="CEIL5_2" },
  YELMETAL = { t="YELMETAL", f="CEIL5_2" },

  METALDR  = { t="METALDR",  f="CEIL5_2" },
  METAL_BD = { t="METAL-BD", f="CEIL5_2" },
  METAL_RM = { t="METAL-RM", f="CEIL5_2" },
  METAL2BD = { t="METAL2BD", f="CEIL5_2" },

  M_RDOOR  = { t="M_RDOOR",  f="FLOOR7_1" },
  M_YDOOR  = { t="M_RDOOR",  f="FLOOR7_1" },

  CAVERN1  = { t="CAVERN1",  f="RROCK17" },
  CAVERN4  = { t="CAVERN4",  f="MFLR8_3" },
  CAVERN6  = { t="CAVERN6",  f="RROCK17" },
  CAVERN7  = { t="CAVERN7",  f="RROCK16" },

  ASPHALT  = { t="ASPHALT",  f="MFLR8_4" },
  SMSTONE6 = { t="SMSTONE6", f="RROCK09" },
  STONEW1  = { t="STONEW1",  f="RROCK09" },
  STONEW5  = { t="STONEW5",  f="MFLR8_3" },

  -- All the crates here! --

  -- 64x64 etc
  CR64LB  = { t="CR64LB",  f="CRATOP2" },
  CRLWDS6 = { t="CRLWDS6", f="CRATOP2" }, --64x32, not really useful

  -- 64x128,
  CRBLWDH6 = { t="CRBLWDH6", f="CRATOP2" },
  CRBWDH64 = { t="CRBWDH64", f="FLAT5_2" },
  CRLWDL6B = { t="CRLWDL6B", f="CRATOP2" },
  CR64HBRM = { t="CR64HBRM", f="CRATOP2" },
  CR64HBBP = { t="CR64HBBP", f="CRATOP2" },
  CR64HGBP = { t="CR64HGBP", f="CRATOP1" },
  CR64SLGB = { t="CR64SLGB", f="CRATOP1" },
  CR64HBG  = { t="CR64HBG",  f="CRATOP2" },
  CR64HBB  = { t="CR64HBB",  f="CRATOP2" },
  CR64HGB  = { t="CR64HGB",  f="CRATOP1" },
  CR64HGG  = { t="CR64HGG",  f="CRATOP1" },
  CRSMB    = { t="CRSMB",    f="CRATOP2" },
  CRWDL64A = { t="CRWDL64A", f="FLAT5_2" },
  CRWDL64B = { t="CRWDL64B", f="FLAT5_2" },
  CRWDL64C = { t="CRWDL64C", f="FLAT5_2" },
  CRWDT32  = { t="CRWDT32",  f="FLAT5_2" },
  CRWDH64  = { t="CRWDH64",  f="FLAT5_2" },
  CRWDH64B = { t="CRWDH64B", f="FLAT5_2" },
  CRWDS64  = { t="CRWDH64",  f="FLAT5_2" },
  CRLWDH6B = { t="CRLWDH6B", f="CRATOP2" },
  CRLWDL6  = { t="CRLWDL6",  f="CRATOP2" },
  CRLWDL6E = { t="CRLWDL6E", f="CRATOP2" },
  CRLWDL6C = { t="CRLWDL6C", f="CRATOP2" },
  CRLWDL6D = { t="CRLWDL6D", f="CRATOP2" },
  CRTINYB  = { t="CRTINYB",  f="CRATOP2" },
  CRLWDH6  = { t="CRLWDH6",  f="CRATOP2" },
  CR64LG   = { t="CR64LG",   f="CRATOP1" },
  CRLWDVS  = { t="CRLWDVS",  f="CRATOP2" },

  -- 128x64,
  CR128LG  = { t="CR128LG",  f="CRATOP2" },
  CRBWLBP  = { t="CRBWLBP",  f="CRATOP2" },
  CR128LB  = { t="CR128LB",  f="CRATOP2" },

  -- 128x128,
  CRWDL128 = { t="CRWDL128", f="FLAT5_2" },
  CRAWHBP  = { t="CRAWHBP",  f="CRATOP1" },
  CRAWLBP  = { t="CRAWLBP",  f="CRATOP2" },
  CRBWHBP  = { t="CRBWHBP",  f="CRATOP1" },
  CRLWDL12 = { t="CRLWDL12", f="CRATOP2" },
  CRBWDL12 = { t="CRBWDL12", f="FLAT5_2" },
  CR128HGB = { t="CR128HGB", f="CRATOP1" },

  DOGRMSC  = { t="DOGRMSC",  f="RROCK20" },
  DOKGRIR  = { t="DOKGRIR",  f="RROCK09" },
  DOKODO1B = { t="DOKODO1B", f="FLAT5" },
  DOKODO2B = { t="DOKODO2B", f="FLAT5" },
  DOKGRIR  = { t="DOKGRIR",  f="RROCK20" },
  DOPUNK4  = { t="DOPUNK4",  f="CEIL5_1" },
  DORED    = { t="DORES",    f="CEIL5_1" },

  PNK4EXIT = { t="PNK4EXIT", f="CEIL5_1" },

  LITEGRN1 = { t="LITEGRN1", f="FLAT1" },
  LITERED1 = { t="LITERED1", f="FLAT1" },
  LITERED2 = { t="LITERED2", f="FLAT23" },
  LITEYEL1 = { t="LITEYEL1", f="CEIL5_1" },
  LITEYEL2 = { t="LITEYEL2", f="FLAT23" },
  LITEYEL3 = { t="LITEYEL3", f="FLAT23" },

  EGGREENI = { t="EGGREENI", f="RROCK20" },
  EGREDI   = { t="EGREDI",   f="FLAT5_3" },
  ALTAQUA  = { t="ALTAQUA",  f="RROCK20" },

  -- Egypt stuff --

  BIGMURAL = { t="BIGMURAL", f="FLAT1_1" },
  MURAL1   = { t="MURAL1",   f="FLAT1_1" },
  MURAL2   = { t="MURAL2",   f="FLAT1_1" },

  PILLAR   = { t="PILLAR",   f="FLAT1_1" },
  BIGWALL  = { t="BIGWALL",  f="FLAT8"   }, --256x128, Egyptian mural decor
  DRSIDE1  = { t="DRSIDE1",  f="FLAT1_1" }, --32x128, useful for small supports, doesn't tile too well
  DRSIDE2  = { t="DRSIDE2",  f="FLAT1_1" }, --32x128, useful for small supports, doesn't tile too well
  DRTOPFR  = { t="DRTOPFR",  f="FLAT1_1" }, --32x65,
  DRTOPSID = { t="DRTOPSID", f="FLAT1_1" }, --32x65,
  LONGWALL = { t="LONGWALL", f="FLAT1_1" }, --256x128, Anubis mural
  SKIRTING = { t="SKIRTING", f="FLAT1_1" }, --256x43, Egyptian hieroglyphics
  STWALL   = { t="STWALL",   f="CRATOP2" },
  DRFRONT  = { t="DRFRONT",  rail_h=128  }, --Transparent in center, not really useful

  -- Transparent openings --

  GRNOPEN = { t="GRNOPEN", rail_h=128 }, --SP_ROCK1 64x128 opening
  REDOPEN = { t="REDOPEN", rail_h=128 }, --ROCKRED 64x128 opening
  BRNOPEN = { t="BRNOPEN", rail_h=128 }, --STONE6 64x128 opening

  -- Rails --

  DOGRID   = { t="DOGRID",   rail_h=128 },
  DOWINDOW = { t="DOWINDOW", rail_h=68 }, --Yea, it's 64x68,
  DOGLPANL = { t="DOGLPANL", rail_h=128 },
  DOBWIRE  = { t="DOBWIRE",  rail_h=128 },
  DOBWIRE2 = { t="DOBWIRE2", rail_h=128 }, --Has no real use, no X flipped variant
  SMGLASS1 = { t="SMGLASS",  rail_h=128  },
  TYIRONLG = { t="TYIRONLG", rail_h=128 },
  TYIRONSM = { t="TYIRONSM", rail_h=72  },
  WEBL = { t="WEBL", rail_h=128 }, --Not really useful
  WEBR = { t="WEBR", rail_h=128 }, --Not really useful

  -- Overrides for existing DOOM materials --

  SUPPORT3 = { t="EGSUPRT3", f="CEIL5_2" },
  ASHWALL2 = { t="ASPHALT",  f="MFLR8_4" },
  MFLR8_4  = { t="ASPHALT",  f="MFLR8_4" },
  FLAT8    = { f="FLAT8",    t="DOKODO1B" },

  BIGDOOR2 = { t="METALDR",  f="CEIL5_2" },
  BIGDOOR3 = { t="METALDR",  f="CEIL5_2" },
  BIGDOOR4 = { t="METALDR",  f="CEIL5_2" },
}


TNT.THEMES =
{
  egypt =
  {
    liquids =
    {
      slime = 60,
      blood = 30,
      water = 20,
      lava  = 10,
    },

    entity_remap =
    {
      k_red    = "ks_red",
      k_blue   = "ks_blue",
      k_yellow = "ks_yellow",
    },

    facades =
    {
      SMSTONE6 = 30,
      STONEW1  = 20,
      STWALL   = 20,
      CAVERN1  = 10,

      BIGBRIK1 = 30,
      BSTONE2  = 20,
      BRICK4   = 10,
    },

    prefab_remap =
    {
      DOORBLU  = "DOORBLU2",
      DOORRED  = "DOORRED2",
      DOORYEL  = "DOORYEL2",

      SILVER3  = "MURAL1",
      GATE3    = "FLAT22",
      GATE4    = "FLAT22",
      REDWALL  = "DOKGRIR",
      SW1COMP  = "SW1CMT",
    },

    window_groups =
    {
      round  = 90,
      barred = 60,
      grate  = 30,
    },

    outdoor_torches =
    {
      blue_torch = 50,
      green_torch = 50,
      red_torch = 50,
      candelabra = 20,
    },

    beam_groups =
    {
      beam_gothic = 50,
      beam_quakeish = 50,
    },

    fence_groups =
    {
      PLAIN = 50,
      crenels = 50,
      gappy = 50,
      fence_gothic = 50,
    },

    fence_posts =
    {
      Post_metal = 25,
      Post_gothic_blue = 10,
      Post_gothic_green = 10,
      Post_gothic_red = 15,
      Post_gothic_blue_2 = 10,
      Post_gothic_green_2 = 10,
      Post_gothic_red_2 = 15,
    },

--Mostly based on what is seen in TNT.WAD MAP31,
    monster_prefs =
    {
      gunner = 1.2,
      mancubus = 1.3,
      demon   = 1.5,
    },

--Any rocky/stonelike/metal doors (IE METALDR) would do great for this theme -Chris
    scenic_fences =
    {
      MIDBARS3 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 1,
    },

    skyboxes =
    {
      Skybox_generic = 50,
    },

    wall_groups =
    {
      PLAIN = 100,
    },
  },
}



TNT.ROOM_THEMES =
{
  egypt_Tomb =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      STWALL  = 30,
      BIGWALL = 20,
      STONEW1 = 20,
      STONEW5 = 10,
      LONGWALL = 5,

      BRICK7   = 30,
      BRICK4   = 20,
      BRICK5   = 10,
    },

    floors =
    {
      RROCK14  = 20,
      FLAT1_2  = 20,
      FLOOR5_4 = 20,
      MFLR8_1  = 20,

      FLAT5_5 = 10,
      RROCK12 = 10,
      FLAT8   = 10,
      SLIME13 = 10,
    },

    ceilings =
    {
      FLAT8    = 20,
      FLAT1_1  = 20,
      FLOOR6_2 = 20,

      RROCK11 = 10,
      RROCK12 = 10,
      RROCK15 = 10,
      CEIL1_1 = 5,
    },
  },


  egypt_Hallway =
  {
    env  = "hallway",
    prob = 50,

    walls =
    {
      STWALL = 30,
      MURAL1 = 15,
      MURAL2 = 15,
      STONE6 = 10,
      BIGMURAL = 5,
    },

    floors =
    {
      FLAT5 = 30,
      FLAT1_1 = 30,
      FLAT1_2 = 30,
      FLAT8   = 20,
      FLOOR5_3 = 20,
    },

    ceilings =
    {
      FLAT5 = 20,
      FLAT1_1 = 20,
      FLAT1_2 = 20,
      FLAT8   = 20,
      RROCK12 = 20,
      RROCK15 = 20,
      CEIL1_1 = 20,
    },
  },


  egypt_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      RROCK09 = 30,
      RROCK16 = 30,
      RROCK13 = 20,
      RROCK04 = 20,
      MFLR8_3 = 20,
      RROCK03 = 10,
      RROCK19 = 10,
    },

    naturals =
    {
      ROCK3 = 25,
      ROCK4 = 25,
      ROCK5 = 25,
    },
  },


  egypt_Cave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      ALTAQUA  = 20,
      ASHWALL7 = 20,
      TANROCK7 = 20,
      TANROCK8 = 20,

      ROCK4   = 20,
      BSTONE1 = 20,
      STONE6  = 20,
    },

    floors =
    {
      BSTONE1 = 20,
      FLAT10  = 20,
      STONE4  = 20,

      SP_ROCK1 = 20, -- MFLR8_3,
      RROCK18  = 20,
      ASHWALL2 = 10,
    },
  },
}


TNT.EPISODES =
{
  episode1 =
  {
    theme = "tech",
    sky_patch  = "DOEDAY",
    sky_patch2 = "DONDAY",
    sky_patch3 = "DOWDAY",
    sky_patch4 = "DOSDAY",
    dark_prob = 10,
    bex_mid_name = "T1TEXT",
    bex_end_name = "T2TEXT",
    ep_index = 1
  },

  episode2 =
  {
    theme = "urban",
    sky_patch  = "DOENITE",
    sky_patch2 = "DONNITE",
    sky_patch3 = "DOWNITE",
    sky_patch4 = "DOSNITE",
    dark_prob = 80,
    bex_end_name = "T3TEXT",
    ep_index = 2
  },

  episode3 =
  {
    theme = "egypt",
    sky_patch  = "DOEHELL",
    sky_patch2 = "DONHELL",
    sky_patch3 = "DOWHELL",
    sky_patch4 = "DOSHELL",
    dark_prob = 10,
    bex_end_name = "T4TEXT",
    ep_index = 3
  },
}

TNT.FACTORY = {}

TNT.FACTORY.TN_COMBOS =
{
  URBAN_EGYPT =
  {
    theme_probs = { URBAN=130 },
    mat_pri = 8,

    wall  = "BIGWALL",
    floor = "FLOOR0_2",
    ceil  = "FLOOR0_2", -- "FLAT1_2",
    step  = "BRICK2",

    scenery = "green_torch",

    sc_fabs = { pillar_rnd_DRSIDE1=50, pillar_rnd_DRSIDE2=50, other=3 },

    wall_fabs = { wall_pic_MURAL1=50, wall_pic_MURAL2=50, wall_pic_LONGWALL=10, other=5 },
  },

  URBAN_STONEW1 =
  {
    theme_probs = { URBAN=15 },
    mat_pri = 5,

    wall  = "STONEW1",
    floor = "RROCK11",
    ceil  = "FLAT10",
    step  = "STEP6",
  },
}

TNT.FACTORY.TN_SCENERY_PREFABS =
{
  pillar_rnd_DRSIDE1 =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",
    skin = { wall="DRSIDE1" },
  },

  pillar_rnd_DRSIDE2 =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",
    skin = { wall="DRSIDE2" },
  },

  crate_WOOD_L6 =
  {
    prefab = "CRATE",
    skin = { crate_h=64, crate_w="CRLWDL6", crate_f="FLOOR4_1" }
  },

  crate_big_WOOD_L12 =
  {
    prefab = "CRATE_BIG",
    min_height = 144,
    skin = { crate_h=128, crate_w="CRLWDL12", crate_f="FLOOR4_1" }
  },

  crate_rot_WOOD_L6C =
  {
    prefab = "CRATE_ROTATE",
    skin = { crate_w="CRLWDL6C", crate_h=64, crate_f="FLAT5_5" }
  },
  
  crate_WOOD_H =
  {
    prefab = "CRATE",
    min_height = 144,
    skin = { crate_w="CRWDH64", crate_h=128, crate_f="FLAT5_2" }
  },

  crate_rot_WOOD2_H =
  {
    prefab = "CRATE_ROTATE",
    min_height = 144,
    skin = { crate_w="CRWDH64B", crate_h=128, crate_f="FLOOR7_1" }
  },

  crate_WOOD_LA =
  {
    prefab = "CRATE",
    skin = { crate_w="CRWDL64A", crate_h=64, crate_f="FLOOR7_1" }
  },

  crate_rot_WOOD_BH =
  {
    prefab = "CRATE_ROTATE",
    min_height = 144,
    skin = { crate_w="CRBLWDH6", crate_h=128, crate_f="FLAT5_5" }
  },

}

TNT.FACTORY.TN_WALL_PREFABS =
{
  wall_pic_DISASTER =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="DISASTER", pic_h=128 },
    prob = 10,
  },

  wall_pic_TNTDOOR =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="TNTDOOR", pic_h=128 },
    theme_probs = { TECH=5, INDUSTRIAL=20 },
  },

  wall_pic_MURAL1 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="MURAL1", pic_h=128 },
    prob = 0.5,
    theme_probs = { URBAN=5, NATURE=3 },
  },

  wall_pic_MURAL2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="MURAL2", pic_h=128 },
    theme_probs = { URBAN=5, NATURE=3 },
  },

  wall_pic_LONGWALL =
  {
    prefab = "WALL_PIC_SCROLLER",
    min_height = 160,
    skin = { pic_w="LONGWALL", pic_h=128, kind=48 },
  },

  lights_wide_LITEGRN1 =
  {
    prefab = "WALL_LIGHTS_WIDE",
    min_height = 128,
    theme_probs = { INDUSTRIAL=50 },
    skin =
    {
      lite_w="LITEGRN1", lite_side="LITEGRN1",
      frame_f="FLAT3",
      wall_lt=255, kind=8,
    },
  },

  lights_wide_LITERED1 =
  {
    prefab = "WALL_LIGHTS_WIDE",
    min_height = 128,
    theme_probs = { TECH=45 },
    skin =
    {
      lite_w="LITERED1", lite_side="LITERED1",
      frame_f="FLAT3",
      wall_lt=255, kind=8,
    },
  },

  lights_wide_LITEYEL1 =
  {
    prefab = "WALL_LIGHTS_WIDE",
    min_height = 128,
    theme_probs = { TECH=15 },
    skin =
    {
      lite_w="LITEYEL1", lite_side="LITEYEL1",
      frame_f="FLAT3",
      wall_lt=255, kind=8,
    },
  },
}

TNT.FACTORY.TN_RAILS =
{
  r_3 = { wall="TYIRONSM", w=64,  h=72  },
  r_4 = { wall="TYIRONLG", w=128, h=128 },
}

TNT.FACTORY.TN_DOORS =
{
--[[ !!!! FIXME
  d_metal = { wall="METALDR", w=128, h=128 },
--]]
}

TNT.FACTORY.TN_ROOMS =
{
  WAREHOUSE2 =
  {
    space_range = { 80, 99 },

    pf_count = { 5,10 },

    sc_fabs =
    {
      crate_WOOD_L6 = 50,
      crate_WOOD_H = 50,
      crate_WOOD_LA = 50,

      crate_big_WOOD_L12 = 70,

      crate_rot_WOOD_L6C = 30,
      crate_rot_WOOD2_H = 30,
      crate_rot_WOOD_BH = 30,

      other = 10
    },
  },
}

TNT.FACTORY.TN_SKY_INFO =
{
  { color="brown",  light=192 },
  { color="black",  light=160 },
  { color="red",    light=192 },
}

----------------------------------------------------------------

GAME_FACTORIES["tnt"] = function()

  local T = GAME_FACTORIES.doom2()

  T.rails   = copy_and_merge(T.rails,  TNT.FACTORY.TN_RAILS)

---##  T.doors   = copy_and_merge(T.doors,  TNT.FACTORY.TN_DOORS)

  T.combos = copy_and_merge(T.combos, TNT.FACTORY.TN_COMBOS)
  T.rooms  = copy_and_merge(T.rooms,  TNT.FACTORY.TN_ROOMS)

  T.sc_fabs   = copy_and_merge(T.sc_fabs,   TNT.FACTORY.TN_SCENERY_PREFABS)
  T.wall_fabs = copy_and_merge(T.wall_fabs, TNT.FACTORY.TN_WALL_PREFABS)

  T.sky_info = TNT.FACTORY.TN_SKY_INFO

  return T
end

--------------------------------------------------------------------

OB_GAMES["tnt"] =
{
  label = _("TNT Evilution"),

  engine = "idtech_1",
  extends = "doom2",

  priority = 95,

  iwad_name = "tnt.wad",

  tables =
  {
    TNT
  },
}


OB_THEMES["egypt"] =
{
  -- TNT Evilution theme

  label = _("Egypt"),
  game = "tnt",
  priority = 3,
  name_class = "GOTHIC",
  mixed_prob = 5,
  bit_limited = true
}
