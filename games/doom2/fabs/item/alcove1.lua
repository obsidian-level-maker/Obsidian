--
--  Small item alcove
--

PREFABS.Item_alcove_small =
{
  file  = "item/alcove1.wad",

  prob  = 50,
  map   = "MAP01",
  theme = "!hell",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_alcove_small_tech1 =
{
  template  = "Item_alcove_small",

  theme     = "tech",
  map       = "MAP02",

  tex_GRAY5 = { TEKWALL1=50, TEKWALL4=50 },
  tex_STEP5 = "STEP4",
  flat_FLAT19 = "CEIL5_1",
  flat_CEIL3_3 = { FLOOR0_3=50, FLAT5_4=50, FLAT19=50, FLAT18=50 }

}

PREFABS.Item_alcove_small_tech2 =
{
  template  = "Item_alcove_small",

  theme     = "tech",
  map       = "MAP02",

  tex_GRAY5 = { METAL2=50, BRONZE1=50 },
  tex_STEP5 = "STEP6",
  flat_FLAT19 = "CEIL5_2",
  flat_CEIL3_3 = { FLOOR4_8=50, FLOOR5_1=50 }

}


PREFABS.Item_alcove_small_tech3 =
{
  template  = "Item_alcove_small",

  theme     = "tech",
  map       = "MAP02",

  tex_GRAY5 = "COMPBLUE",
  tex_STEP5 = "STEP4",
  flat_FLAT19 = { FLAT14=50, CEIL4_1=50, CEIL4_2=50 },
  flat_CEIL3_3 = "FLAT19",

}

PREFABS.Item_alcove_small_urban1 =
{
  template  = "Item_alcove_small",

  theme     = "urban",
  map       = "MAP02",

  tex_GRAY5 = "BIGBRIK2",
  tex_STEP5 = "STEP2",
  flat_FLAT19 = "FLAT5_4",
  flat_CEIL3_3 = { CEIL3_1=50, CEIL3_2=50, CEIL3_3=50 },

}

PREFABS.Item_alcove_small_urban2 =
{
  template  = "Item_alcove_small",

  theme     = "urban",
  map       = "MAP02",

  tex_GRAY5 = "BRICK10",
  tex_STEP5 = "STEP6",
  flat_FLAT19 = "SLIME13",
  flat_CEIL3_3 = { FLOOR5_2=50, FLOOR5_3=50, FLOOR5_4=50 }

}

PREFABS.Item_alcove_small_urban3 =
{
  template  = "Item_alcove_small",

  theme     = "urban",
  map       = "MAP02",

  tex_GRAY5 = { BLAKWAL1=50, BLAKWAL2=50 },
  tex_STEP5 = "STEP4",
  flat_FLAT19 = "CEIL5_1",
  flat_CEIL3_3 = "FLAT5_4",

}

PREFABS.Item_alcove_small_hell1 =
{
  template  = "Item_alcove_small",

  theme     = "hell",
  map       = "MAP02",

  tex_GRAY5 = "MARBLE1",
  tex_STEP5 = "STEP2",
  flat_FLAT19 = "FLOOR7_2",
  flat_CEIL3_3 = "CEIL3_1",

}

PREFABS.Item_alcove_small_hell2 =
{
  template  = "Item_alcove_small",

  theme     = "hell",
  map       = "MAP02",

  tex_GRAY5 = "SP_HOT1",
  tex_STEP5 = "STEP4",
  flat_FLAT19 = "FLAT5_3",
  flat_CEIL3_3 = "FLAT5_4",

}

PREFABS.Item_alcove_small_hell3 =
{
  template  = "Item_alcove_small",

  theme     = "hell",
  map       = "MAP02",

  tex_GRAY5 = { ASHWALL3=50, ASHWALL4=50 },
  tex_STEP5 = "STEP6",
  flat_FLAT19 = "RROCK03",
  flat_CEIL3_3 = "RROCK09",

}

PREFABS.Item_alcove_small_general1 =
{
  template  = "Item_alcove_small",

  map       = "MAP02",

  tex_GRAY5 = { STONE2=50, STONE3=50 },
  tex_STEP5 = "STEP4",
  flat_FLAT19 = "FLAT1",
  flat_CEIL3_3 = "FLAT5_4",

}

PREFABS.Item_alcove_small_general2 =
{
  template  = "Item_alcove_small",

  map       = "MAP02",

  tex_GRAY5 = "METAL",
  tex_STEP5 = "STEP2",
  flat_FLAT19 = "CEIL5_2",
  flat_CEIL3_3 = "FLOOR5_3",

}

PREFABS.Item_alcove_small_general3 =
{
  template  = "Item_alcove_small",

  map       = "MAP02",

  tex_GRAY5 = "BROWN1",
  tex_STEP5 = "STEP4",
  flat_FLAT19 = "FLOOR0_1",
  flat_CEIL3_3 = "FLAT5_4",

}

PREFABS.Item_alcove_small_general4 =
{
  template  = "Item_alcove_small",

  map       = "MAP02",

  tex_GRAY5 = { BROWNGRN=50, BROWN96=50, BROWN144=50, BROWNHUG=50 },
  flat_FLAT19 = "FLOOR7_1",

}
